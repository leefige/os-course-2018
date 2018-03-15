
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
  10001f:	e8 b5 2e 00 00       	call   102ed9 <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 31 15 00 00       	call   10155d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 80 36 10 00 	movl   $0x103680,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 9c 36 10 00       	push   $0x10369c
  10003e:	e8 07 02 00 00       	call   10024a <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 89 08 00 00       	call   1008d4 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 79 00 00 00       	call   1000c9 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 48 2b 00 00       	call   102b9d <pmm_init>

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
  100112:	68 a1 36 10 00       	push   $0x1036a1
  100117:	e8 2e 01 00 00       	call   10024a <cprintf>
  10011c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100123:	0f b7 d0             	movzwl %ax,%edx
  100126:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10012b:	83 ec 04             	sub    $0x4,%esp
  10012e:	52                   	push   %edx
  10012f:	50                   	push   %eax
  100130:	68 af 36 10 00       	push   $0x1036af
  100135:	e8 10 01 00 00       	call   10024a <cprintf>
  10013a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  10013d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100141:	0f b7 d0             	movzwl %ax,%edx
  100144:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100149:	83 ec 04             	sub    $0x4,%esp
  10014c:	52                   	push   %edx
  10014d:	50                   	push   %eax
  10014e:	68 bd 36 10 00       	push   $0x1036bd
  100153:	e8 f2 00 00 00       	call   10024a <cprintf>
  100158:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  10015b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015f:	0f b7 d0             	movzwl %ax,%edx
  100162:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100167:	83 ec 04             	sub    $0x4,%esp
  10016a:	52                   	push   %edx
  10016b:	50                   	push   %eax
  10016c:	68 cb 36 10 00       	push   $0x1036cb
  100171:	e8 d4 00 00 00       	call   10024a <cprintf>
  100176:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100179:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10017d:	0f b7 d0             	movzwl %ax,%edx
  100180:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100185:	83 ec 04             	sub    $0x4,%esp
  100188:	52                   	push   %edx
  100189:	50                   	push   %eax
  10018a:	68 d9 36 10 00       	push   $0x1036d9
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
  1001c9:	68 e8 36 10 00       	push   $0x1036e8
  1001ce:	e8 77 00 00 00       	call   10024a <cprintf>
  1001d3:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001d6:	e8 cc ff ff ff       	call   1001a7 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001db:	e8 0a ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001e0:	83 ec 0c             	sub    $0xc,%esp
  1001e3:	68 08 37 10 00       	push   $0x103708
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
  10023d:	e8 cd 2f 00 00       	call   10320f <vprintfmt>
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
  100300:	68 27 37 10 00       	push   $0x103727
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
  1003d8:	68 2a 37 10 00       	push   $0x10372a
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
  1003fa:	68 46 37 10 00       	push   $0x103746
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
  100433:	68 48 37 10 00       	push   $0x103748
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
  100455:	68 46 37 10 00       	push   $0x103746
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
  1005cf:	c7 00 68 37 10 00    	movl   $0x103768,(%eax)
    info->eip_line = 0;
  1005d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e2:	c7 40 08 68 37 10 00 	movl   $0x103768,0x8(%eax)
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
  100606:	c7 45 f4 0c 40 10 00 	movl   $0x10400c,-0xc(%ebp)
    stab_end = __STAB_END__;
  10060d:	c7 45 f0 20 bc 10 00 	movl   $0x10bc20,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100614:	c7 45 ec 21 bc 10 00 	movl   $0x10bc21,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10061b:	c7 45 e8 be dc 10 00 	movl   $0x10dcbe,-0x18(%ebp)

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
  100755:	e8 f3 25 00 00       	call   102d4d <strfind>
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
  1008dd:	68 72 37 10 00       	push   $0x103772
  1008e2:	e8 63 f9 ff ff       	call   10024a <cprintf>
  1008e7:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008ea:	83 ec 08             	sub    $0x8,%esp
  1008ed:	68 00 00 10 00       	push   $0x100000
  1008f2:	68 8b 37 10 00       	push   $0x10378b
  1008f7:	e8 4e f9 ff ff       	call   10024a <cprintf>
  1008fc:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008ff:	83 ec 08             	sub    $0x8,%esp
  100902:	68 70 36 10 00       	push   $0x103670
  100907:	68 a3 37 10 00       	push   $0x1037a3
  10090c:	e8 39 f9 ff ff       	call   10024a <cprintf>
  100911:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100914:	83 ec 08             	sub    $0x8,%esp
  100917:	68 16 ea 10 00       	push   $0x10ea16
  10091c:	68 bb 37 10 00       	push   $0x1037bb
  100921:	e8 24 f9 ff ff       	call   10024a <cprintf>
  100926:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100929:	83 ec 08             	sub    $0x8,%esp
  10092c:	68 80 fd 10 00       	push   $0x10fd80
  100931:	68 d3 37 10 00       	push   $0x1037d3
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
  100961:	68 ec 37 10 00       	push   $0x1037ec
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
  100996:	68 16 38 10 00       	push   $0x103816
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
  1009fd:	68 32 38 10 00       	push   $0x103832
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
  100a4d:	68 44 38 10 00       	push   $0x103844
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
  100a9b:	68 5c 38 10 00       	push   $0x10385c
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
  100b1c:	68 00 39 10 00       	push   $0x103900
  100b21:	e8 f4 21 00 00       	call   102d1a <strchr>
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
  100b42:	68 05 39 10 00       	push   $0x103905
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
  100b8a:	68 00 39 10 00       	push   $0x103900
  100b8f:	e8 86 21 00 00       	call   102d1a <strchr>
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
  100bf5:	e8 80 20 00 00       	call   102c7a <strcmp>
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
  100c42:	68 23 39 10 00       	push   $0x103923
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
  100c5f:	68 3c 39 10 00       	push   $0x10393c
  100c64:	e8 e1 f5 ff ff       	call   10024a <cprintf>
  100c69:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c6c:	83 ec 0c             	sub    $0xc,%esp
  100c6f:	68 64 39 10 00       	push   $0x103964
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
  100c93:	68 89 39 10 00       	push   $0x103989
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
  100cfe:	68 8d 39 10 00       	push   $0x10398d
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
  100d8e:	68 96 39 10 00       	push   $0x103996
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
  101179:	e8 9b 1d 00 00       	call   102f19 <memmove>
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
  101504:	68 b1 39 10 00       	push   $0x1039b1
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
  10157e:	68 bd 39 10 00       	push   $0x1039bd
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
  1017f6:	68 e0 39 10 00       	push   $0x1039e0
  1017fb:	e8 4a ea ff ff       	call   10024a <cprintf>
  101800:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101803:	83 ec 0c             	sub    $0xc,%esp
  101806:	68 ea 39 10 00       	push   $0x1039ea
  10180b:	e8 3a ea ff ff       	call   10024a <cprintf>
  101810:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  101813:	83 ec 04             	sub    $0x4,%esp
  101816:	68 f8 39 10 00       	push   $0x1039f8
  10181b:	6a 12                	push   $0x12
  10181d:	68 0e 3a 10 00       	push   $0x103a0e
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

	// set RPL of switch_to_kernel as user 
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
  1019a6:	8b 04 85 c0 3d 10 00 	mov    0x103dc0(,%eax,4),%eax
  1019ad:	eb 18                	jmp    1019c7 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019af:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019b3:	7e 0d                	jle    1019c2 <trapname+0x2a>
  1019b5:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019b9:	7f 07                	jg     1019c2 <trapname+0x2a>
        return "Hardware Interrupt";
  1019bb:	b8 1f 3a 10 00       	mov    $0x103a1f,%eax
  1019c0:	eb 05                	jmp    1019c7 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019c2:	b8 32 3a 10 00       	mov    $0x103a32,%eax
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
  1019eb:	68 73 3a 10 00       	push   $0x103a73
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
  101a15:	68 84 3a 10 00       	push   $0x103a84
  101a1a:	e8 2b e8 ff ff       	call   10024a <cprintf>
  101a1f:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a22:	8b 45 08             	mov    0x8(%ebp),%eax
  101a25:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a29:	0f b7 c0             	movzwl %ax,%eax
  101a2c:	83 ec 08             	sub    $0x8,%esp
  101a2f:	50                   	push   %eax
  101a30:	68 97 3a 10 00       	push   $0x103a97
  101a35:	e8 10 e8 ff ff       	call   10024a <cprintf>
  101a3a:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a40:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a44:	0f b7 c0             	movzwl %ax,%eax
  101a47:	83 ec 08             	sub    $0x8,%esp
  101a4a:	50                   	push   %eax
  101a4b:	68 aa 3a 10 00       	push   $0x103aaa
  101a50:	e8 f5 e7 ff ff       	call   10024a <cprintf>
  101a55:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a58:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5b:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a5f:	0f b7 c0             	movzwl %ax,%eax
  101a62:	83 ec 08             	sub    $0x8,%esp
  101a65:	50                   	push   %eax
  101a66:	68 bd 3a 10 00       	push   $0x103abd
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
  101a92:	68 d0 3a 10 00       	push   $0x103ad0
  101a97:	e8 ae e7 ff ff       	call   10024a <cprintf>
  101a9c:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa2:	8b 40 34             	mov    0x34(%eax),%eax
  101aa5:	83 ec 08             	sub    $0x8,%esp
  101aa8:	50                   	push   %eax
  101aa9:	68 e2 3a 10 00       	push   $0x103ae2
  101aae:	e8 97 e7 ff ff       	call   10024a <cprintf>
  101ab3:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab9:	8b 40 38             	mov    0x38(%eax),%eax
  101abc:	83 ec 08             	sub    $0x8,%esp
  101abf:	50                   	push   %eax
  101ac0:	68 f1 3a 10 00       	push   $0x103af1
  101ac5:	e8 80 e7 ff ff       	call   10024a <cprintf>
  101aca:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101acd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ad4:	0f b7 c0             	movzwl %ax,%eax
  101ad7:	83 ec 08             	sub    $0x8,%esp
  101ada:	50                   	push   %eax
  101adb:	68 00 3b 10 00       	push   $0x103b00
  101ae0:	e8 65 e7 ff ff       	call   10024a <cprintf>
  101ae5:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  101aeb:	8b 40 40             	mov    0x40(%eax),%eax
  101aee:	83 ec 08             	sub    $0x8,%esp
  101af1:	50                   	push   %eax
  101af2:	68 13 3b 10 00       	push   $0x103b13
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
  101b3a:	68 22 3b 10 00       	push   $0x103b22
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
  101b68:	68 26 3b 10 00       	push   $0x103b26
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
  101b91:	68 2f 3b 10 00       	push   $0x103b2f
  101b96:	e8 af e6 ff ff       	call   10024a <cprintf>
  101b9b:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba1:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ba5:	0f b7 c0             	movzwl %ax,%eax
  101ba8:	83 ec 08             	sub    $0x8,%esp
  101bab:	50                   	push   %eax
  101bac:	68 3e 3b 10 00       	push   $0x103b3e
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
  101bcb:	68 51 3b 10 00       	push   $0x103b51
  101bd0:	e8 75 e6 ff ff       	call   10024a <cprintf>
  101bd5:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdb:	8b 40 04             	mov    0x4(%eax),%eax
  101bde:	83 ec 08             	sub    $0x8,%esp
  101be1:	50                   	push   %eax
  101be2:	68 60 3b 10 00       	push   $0x103b60
  101be7:	e8 5e e6 ff ff       	call   10024a <cprintf>
  101bec:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bef:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf2:	8b 40 08             	mov    0x8(%eax),%eax
  101bf5:	83 ec 08             	sub    $0x8,%esp
  101bf8:	50                   	push   %eax
  101bf9:	68 6f 3b 10 00       	push   $0x103b6f
  101bfe:	e8 47 e6 ff ff       	call   10024a <cprintf>
  101c03:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c06:	8b 45 08             	mov    0x8(%ebp),%eax
  101c09:	8b 40 0c             	mov    0xc(%eax),%eax
  101c0c:	83 ec 08             	sub    $0x8,%esp
  101c0f:	50                   	push   %eax
  101c10:	68 7e 3b 10 00       	push   $0x103b7e
  101c15:	e8 30 e6 ff ff       	call   10024a <cprintf>
  101c1a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c20:	8b 40 10             	mov    0x10(%eax),%eax
  101c23:	83 ec 08             	sub    $0x8,%esp
  101c26:	50                   	push   %eax
  101c27:	68 8d 3b 10 00       	push   $0x103b8d
  101c2c:	e8 19 e6 ff ff       	call   10024a <cprintf>
  101c31:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c34:	8b 45 08             	mov    0x8(%ebp),%eax
  101c37:	8b 40 14             	mov    0x14(%eax),%eax
  101c3a:	83 ec 08             	sub    $0x8,%esp
  101c3d:	50                   	push   %eax
  101c3e:	68 9c 3b 10 00       	push   $0x103b9c
  101c43:	e8 02 e6 ff ff       	call   10024a <cprintf>
  101c48:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4e:	8b 40 18             	mov    0x18(%eax),%eax
  101c51:	83 ec 08             	sub    $0x8,%esp
  101c54:	50                   	push   %eax
  101c55:	68 ab 3b 10 00       	push   $0x103bab
  101c5a:	e8 eb e5 ff ff       	call   10024a <cprintf>
  101c5f:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c62:	8b 45 08             	mov    0x8(%ebp),%eax
  101c65:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c68:	83 ec 08             	sub    $0x8,%esp
  101c6b:	50                   	push   %eax
  101c6c:	68 ba 3b 10 00       	push   $0x103bba
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
  101c93:	0f 83 81 02 00 00    	jae    101f1a <trap_dispatch+0x29e>
  101c99:	83 f8 21             	cmp    $0x21,%eax
  101c9c:	0f 84 87 00 00 00    	je     101d29 <trap_dispatch+0xad>
  101ca2:	83 f8 24             	cmp    $0x24,%eax
  101ca5:	74 5b                	je     101d02 <trap_dispatch+0x86>
  101ca7:	83 f8 20             	cmp    $0x20,%eax
  101caa:	74 1c                	je     101cc8 <trap_dispatch+0x4c>
  101cac:	e9 33 02 00 00       	jmp    101ee4 <trap_dispatch+0x268>
  101cb1:	83 f8 78             	cmp    $0x78,%eax
  101cb4:	0f 84 87 01 00 00    	je     101e41 <trap_dispatch+0x1c5>
  101cba:	83 f8 79             	cmp    $0x79,%eax
  101cbd:	0f 84 f3 01 00 00    	je     101eb6 <trap_dispatch+0x23a>
  101cc3:	e9 1c 02 00 00       	jmp    101ee4 <trap_dispatch+0x268>
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
  101cf2:	0f 85 25 02 00 00    	jne    101f1d <trap_dispatch+0x2a1>
            print_ticks();
  101cf8:	e8 ee fa ff ff       	call   1017eb <print_ticks>
        }

        // 3. too simple ?!
        break;
  101cfd:	e9 1b 02 00 00       	jmp    101f1d <trap_dispatch+0x2a1>
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
  101d17:	68 c9 3b 10 00       	push   $0x103bc9
  101d1c:	e8 29 e5 ff ff       	call   10024a <cprintf>
  101d21:	83 c4 10             	add    $0x10,%esp
        break;
  101d24:	e9 f8 01 00 00       	jmp    101f21 <trap_dispatch+0x2a5>
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
  101d3e:	68 db 3b 10 00       	push   $0x103bdb
  101d43:	e8 02 e5 ff ff       	call   10024a <cprintf>
  101d48:	83 c4 10             	add    $0x10,%esp
        
        //LAB1 CHALLENGE 2 : TODO
        // switch to kernel
        if (c == '0') {
  101d4b:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
  101d4f:	75 41                	jne    101d92 <trap_dispatch+0x116>
            cprintf("switch to kern\n");
  101d51:	83 ec 0c             	sub    $0xc,%esp
  101d54:	68 ea 3b 10 00       	push   $0x103bea
  101d59:	e8 ec e4 ff ff       	call   10024a <cprintf>
  101d5e:	83 c4 10             	add    $0x10,%esp
            tf->tf_cs = KERNEL_CS;
  101d61:	8b 45 08             	mov    0x8(%ebp),%eax
  101d64:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = KERNEL_DS;
  101d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6d:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
            tf->tf_es = KERNEL_DS;
  101d73:	8b 45 08             	mov    0x8(%ebp),%eax
  101d76:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7f:	8b 40 40             	mov    0x40(%eax),%eax
  101d82:	80 e4 cf             	and    $0xcf,%ah
  101d85:	89 c2                	mov    %eax,%edx
  101d87:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8a:	89 50 40             	mov    %edx,0x40(%eax)
        }
        // print to show PL
        else if (c == 'p') {
            print_trapframe(tf);
        }
        break;
  101d8d:	e9 8e 01 00 00       	jmp    101f20 <trap_dispatch+0x2a4>
            tf->tf_ds = KERNEL_DS;
            tf->tf_es = KERNEL_DS;
            tf->tf_eflags &= ~FL_IOPL_MASK;
        }
        // switch to user
        else if (c == '3') {
  101d92:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
  101d96:	0f 85 88 00 00 00    	jne    101e24 <trap_dispatch+0x1a8>
            cprintf("switch to user\n");
  101d9c:	83 ec 0c             	sub    $0xc,%esp
  101d9f:	68 fa 3b 10 00       	push   $0x103bfa
  101da4:	e8 a1 e4 ff ff       	call   10024a <cprintf>
  101da9:	83 c4 10             	add    $0x10,%esp
            
            switchk2u = *tf;
  101dac:	8b 55 08             	mov    0x8(%ebp),%edx
  101daf:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101db4:	89 d3                	mov    %edx,%ebx
  101db6:	ba 4c 00 00 00       	mov    $0x4c,%edx
  101dbb:	8b 0b                	mov    (%ebx),%ecx
  101dbd:	89 08                	mov    %ecx,(%eax)
  101dbf:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  101dc3:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  101dc7:	8d 78 04             	lea    0x4(%eax),%edi
  101dca:	83 e7 fc             	and    $0xfffffffc,%edi
  101dcd:	29 f8                	sub    %edi,%eax
  101dcf:	29 c3                	sub    %eax,%ebx
  101dd1:	01 c2                	add    %eax,%edx
  101dd3:	83 e2 fc             	and    $0xfffffffc,%edx
  101dd6:	89 d0                	mov    %edx,%eax
  101dd8:	c1 e8 02             	shr    $0x2,%eax
  101ddb:	89 de                	mov    %ebx,%esi
  101ddd:	89 c1                	mov    %eax,%ecx
  101ddf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101de1:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101de8:	1b 00 
            switchk2u.tf_ds = USER_DS;
  101dea:	66 c7 05 4c f9 10 00 	movw   $0x23,0x10f94c
  101df1:	23 00 
            switchk2u.tf_es = USER_DS;
  101df3:	66 c7 05 48 f9 10 00 	movw   $0x23,0x10f948
  101dfa:	23 00 
            switchk2u.tf_ss = USER_DS;
  101dfc:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101e03:	23 00 

            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101e05:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101e0a:	80 cc 30             	or     $0x30,%ah
  101e0d:	a3 60 f9 10 00       	mov    %eax,0x10f960
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101e12:	8b 45 08             	mov    0x8(%ebp),%eax
  101e15:	83 e8 04             	sub    $0x4,%eax
  101e18:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101e1d:	89 10                	mov    %edx,(%eax)
        }
        // print to show PL
        else if (c == 'p') {
            print_trapframe(tf);
        }
        break;
  101e1f:	e9 fc 00 00 00       	jmp    101f20 <trap_dispatch+0x2a4>

            switchk2u.tf_eflags |= FL_IOPL_MASK;
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
        }
        // print to show PL
        else if (c == 'p') {
  101e24:	80 7d e7 70          	cmpb   $0x70,-0x19(%ebp)
  101e28:	0f 85 f2 00 00 00    	jne    101f20 <trap_dispatch+0x2a4>
            print_trapframe(tf);
  101e2e:	83 ec 0c             	sub    $0xc,%esp
  101e31:	ff 75 08             	pushl  0x8(%ebp)
  101e34:	e8 a6 fb ff ff       	call   1019df <print_trapframe>
  101e39:	83 c4 10             	add    $0x10,%esp
        }
        break;
  101e3c:	e9 df 00 00 00       	jmp    101f20 <trap_dispatch+0x2a4>
    //LAB1 CHALLENGE 1 : 2015010062 you should modify below codes.
    case T_SWITCH_TOU:
        switchk2u = *tf;
  101e41:	8b 55 08             	mov    0x8(%ebp),%edx
  101e44:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101e49:	89 d3                	mov    %edx,%ebx
  101e4b:	ba 4c 00 00 00       	mov    $0x4c,%edx
  101e50:	8b 0b                	mov    (%ebx),%ecx
  101e52:	89 08                	mov    %ecx,(%eax)
  101e54:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  101e58:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  101e5c:	8d 78 04             	lea    0x4(%eax),%edi
  101e5f:	83 e7 fc             	and    $0xfffffffc,%edi
  101e62:	29 f8                	sub    %edi,%eax
  101e64:	29 c3                	sub    %eax,%ebx
  101e66:	01 c2                	add    %eax,%edx
  101e68:	83 e2 fc             	and    $0xfffffffc,%edx
  101e6b:	89 d0                	mov    %edx,%eax
  101e6d:	c1 e8 02             	shr    $0x2,%eax
  101e70:	89 de                	mov    %ebx,%esi
  101e72:	89 c1                	mov    %eax,%ecx
  101e74:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        switchk2u.tf_cs = USER_CS;
  101e76:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101e7d:	1b 00 
        switchk2u.tf_ds = USER_DS;
  101e7f:	66 c7 05 4c f9 10 00 	movw   $0x23,0x10f94c
  101e86:	23 00 
        switchk2u.tf_es = USER_DS;
  101e88:	66 c7 05 48 f9 10 00 	movw   $0x23,0x10f948
  101e8f:	23 00 
        switchk2u.tf_ss = USER_DS;
  101e91:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101e98:	23 00 

        // set eflags, make sure ucore can use io under user mode.
        // if CPL > IOPL, then cpu will generate a general protection.
        switchk2u.tf_eflags |= FL_IOPL_MASK;
  101e9a:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101e9f:	80 cc 30             	or     $0x30,%ah
  101ea2:	a3 60 f9 10 00       	mov    %eax,0x10f960
        // set trap frame pointer
        // tf is the pointer to the pointer of trap frame (a structure)
        // tf = esp, while esp -> esp - 1 (*trap_frame) due to `pushl %esp`
        // so *(tf - 1) is the pointer to trap frame
        // change *trap_frame to point to the new frame
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  101eaa:	83 e8 04             	sub    $0x4,%eax
  101ead:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101eb2:	89 10                	mov    %edx,(%eax)
        break;
  101eb4:	eb 6b                	jmp    101f21 <trap_dispatch+0x2a5>
    case T_SWITCH_TOK:
        // panic("T_SWITCH_** ??\n");
        tf->tf_cs = KERNEL_CS;
  101eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb9:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = KERNEL_DS;
  101ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec2:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        tf->tf_es = KERNEL_DS;
  101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  101ecb:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)

        // restore eflags
        tf->tf_eflags &= ~FL_IOPL_MASK;
  101ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed4:	8b 40 40             	mov    0x40(%eax),%eax
  101ed7:	80 e4 cf             	and    $0xcf,%ah
  101eda:	89 c2                	mov    %eax,%edx
  101edc:	8b 45 08             	mov    0x8(%ebp),%eax
  101edf:	89 50 40             	mov    %edx,0x40(%eax)
        break;
  101ee2:	eb 3d                	jmp    101f21 <trap_dispatch+0x2a5>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101eeb:	0f b7 c0             	movzwl %ax,%eax
  101eee:	83 e0 03             	and    $0x3,%eax
  101ef1:	85 c0                	test   %eax,%eax
  101ef3:	75 2c                	jne    101f21 <trap_dispatch+0x2a5>
            print_trapframe(tf);
  101ef5:	83 ec 0c             	sub    $0xc,%esp
  101ef8:	ff 75 08             	pushl  0x8(%ebp)
  101efb:	e8 df fa ff ff       	call   1019df <print_trapframe>
  101f00:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101f03:	83 ec 04             	sub    $0x4,%esp
  101f06:	68 0a 3c 10 00       	push   $0x103c0a
  101f0b:	68 fb 00 00 00       	push   $0xfb
  101f10:	68 0e 3a 10 00       	push   $0x103a0e
  101f15:	e8 96 e4 ff ff       	call   1003b0 <__panic>
        tf->tf_eflags &= ~FL_IOPL_MASK;
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101f1a:	90                   	nop
  101f1b:	eb 04                	jmp    101f21 <trap_dispatch+0x2a5>
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }

        // 3. too simple ?!
        break;
  101f1d:	90                   	nop
  101f1e:	eb 01                	jmp    101f21 <trap_dispatch+0x2a5>
        }
        // print to show PL
        else if (c == 'p') {
            print_trapframe(tf);
        }
        break;
  101f20:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101f21:	90                   	nop
  101f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  101f25:	5b                   	pop    %ebx
  101f26:	5e                   	pop    %esi
  101f27:	5f                   	pop    %edi
  101f28:	5d                   	pop    %ebp
  101f29:	c3                   	ret    

00101f2a <cur_debug>:

void
cur_debug(void) {
  101f2a:	55                   	push   %ebp
  101f2b:	89 e5                	mov    %esp,%ebp
  101f2d:	83 ec 18             	sub    $0x18,%esp
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  101f30:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  101f33:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  101f36:	8c 45 f2             	mov    %es,-0xe(%ebp)
  101f39:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", reg1 & 3);
  101f3c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101f40:	0f b7 c0             	movzwl %ax,%eax
  101f43:	83 e0 03             	and    $0x3,%eax
  101f46:	83 ec 08             	sub    $0x8,%esp
  101f49:	50                   	push   %eax
  101f4a:	68 26 3c 10 00       	push   $0x103c26
  101f4f:	e8 f6 e2 ff ff       	call   10024a <cprintf>
  101f54:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", reg1);
  101f57:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101f5b:	0f b7 c0             	movzwl %ax,%eax
  101f5e:	83 ec 08             	sub    $0x8,%esp
  101f61:	50                   	push   %eax
  101f62:	68 34 3c 10 00       	push   $0x103c34
  101f67:	e8 de e2 ff ff       	call   10024a <cprintf>
  101f6c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", reg2);
  101f6f:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  101f73:	0f b7 c0             	movzwl %ax,%eax
  101f76:	83 ec 08             	sub    $0x8,%esp
  101f79:	50                   	push   %eax
  101f7a:	68 42 3c 10 00       	push   $0x103c42
  101f7f:	e8 c6 e2 ff ff       	call   10024a <cprintf>
  101f84:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", reg3);
  101f87:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101f8b:	0f b7 c0             	movzwl %ax,%eax
  101f8e:	83 ec 08             	sub    $0x8,%esp
  101f91:	50                   	push   %eax
  101f92:	68 50 3c 10 00       	push   $0x103c50
  101f97:	e8 ae e2 ff ff       	call   10024a <cprintf>
  101f9c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", reg4);
  101f9f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101fa3:	0f b7 c0             	movzwl %ax,%eax
  101fa6:	83 ec 08             	sub    $0x8,%esp
  101fa9:	50                   	push   %eax
  101faa:	68 5e 3c 10 00       	push   $0x103c5e
  101faf:	e8 96 e2 ff ff       	call   10024a <cprintf>
  101fb4:	83 c4 10             	add    $0x10,%esp
}
  101fb7:	90                   	nop
  101fb8:	c9                   	leave  
  101fb9:	c3                   	ret    

00101fba <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101fba:	55                   	push   %ebp
  101fbb:	89 e5                	mov    %esp,%ebp
  101fbd:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101fc0:	83 ec 0c             	sub    $0xc,%esp
  101fc3:	ff 75 08             	pushl  0x8(%ebp)
  101fc6:	e8 b1 fc ff ff       	call   101c7c <trap_dispatch>
  101fcb:	83 c4 10             	add    $0x10,%esp
}
  101fce:	90                   	nop
  101fcf:	c9                   	leave  
  101fd0:	c3                   	ret    

00101fd1 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101fd1:	6a 00                	push   $0x0
  pushl $0
  101fd3:	6a 00                	push   $0x0
  jmp __alltraps
  101fd5:	e9 69 0a 00 00       	jmp    102a43 <__alltraps>

00101fda <vector1>:
.globl vector1
vector1:
  pushl $0
  101fda:	6a 00                	push   $0x0
  pushl $1
  101fdc:	6a 01                	push   $0x1
  jmp __alltraps
  101fde:	e9 60 0a 00 00       	jmp    102a43 <__alltraps>

00101fe3 <vector2>:
.globl vector2
vector2:
  pushl $0
  101fe3:	6a 00                	push   $0x0
  pushl $2
  101fe5:	6a 02                	push   $0x2
  jmp __alltraps
  101fe7:	e9 57 0a 00 00       	jmp    102a43 <__alltraps>

00101fec <vector3>:
.globl vector3
vector3:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $3
  101fee:	6a 03                	push   $0x3
  jmp __alltraps
  101ff0:	e9 4e 0a 00 00       	jmp    102a43 <__alltraps>

00101ff5 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ff5:	6a 00                	push   $0x0
  pushl $4
  101ff7:	6a 04                	push   $0x4
  jmp __alltraps
  101ff9:	e9 45 0a 00 00       	jmp    102a43 <__alltraps>

00101ffe <vector5>:
.globl vector5
vector5:
  pushl $0
  101ffe:	6a 00                	push   $0x0
  pushl $5
  102000:	6a 05                	push   $0x5
  jmp __alltraps
  102002:	e9 3c 0a 00 00       	jmp    102a43 <__alltraps>

00102007 <vector6>:
.globl vector6
vector6:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $6
  102009:	6a 06                	push   $0x6
  jmp __alltraps
  10200b:	e9 33 0a 00 00       	jmp    102a43 <__alltraps>

00102010 <vector7>:
.globl vector7
vector7:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $7
  102012:	6a 07                	push   $0x7
  jmp __alltraps
  102014:	e9 2a 0a 00 00       	jmp    102a43 <__alltraps>

00102019 <vector8>:
.globl vector8
vector8:
  pushl $8
  102019:	6a 08                	push   $0x8
  jmp __alltraps
  10201b:	e9 23 0a 00 00       	jmp    102a43 <__alltraps>

00102020 <vector9>:
.globl vector9
vector9:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $9
  102022:	6a 09                	push   $0x9
  jmp __alltraps
  102024:	e9 1a 0a 00 00       	jmp    102a43 <__alltraps>

00102029 <vector10>:
.globl vector10
vector10:
  pushl $10
  102029:	6a 0a                	push   $0xa
  jmp __alltraps
  10202b:	e9 13 0a 00 00       	jmp    102a43 <__alltraps>

00102030 <vector11>:
.globl vector11
vector11:
  pushl $11
  102030:	6a 0b                	push   $0xb
  jmp __alltraps
  102032:	e9 0c 0a 00 00       	jmp    102a43 <__alltraps>

00102037 <vector12>:
.globl vector12
vector12:
  pushl $12
  102037:	6a 0c                	push   $0xc
  jmp __alltraps
  102039:	e9 05 0a 00 00       	jmp    102a43 <__alltraps>

0010203e <vector13>:
.globl vector13
vector13:
  pushl $13
  10203e:	6a 0d                	push   $0xd
  jmp __alltraps
  102040:	e9 fe 09 00 00       	jmp    102a43 <__alltraps>

00102045 <vector14>:
.globl vector14
vector14:
  pushl $14
  102045:	6a 0e                	push   $0xe
  jmp __alltraps
  102047:	e9 f7 09 00 00       	jmp    102a43 <__alltraps>

0010204c <vector15>:
.globl vector15
vector15:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $15
  10204e:	6a 0f                	push   $0xf
  jmp __alltraps
  102050:	e9 ee 09 00 00       	jmp    102a43 <__alltraps>

00102055 <vector16>:
.globl vector16
vector16:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $16
  102057:	6a 10                	push   $0x10
  jmp __alltraps
  102059:	e9 e5 09 00 00       	jmp    102a43 <__alltraps>

0010205e <vector17>:
.globl vector17
vector17:
  pushl $17
  10205e:	6a 11                	push   $0x11
  jmp __alltraps
  102060:	e9 de 09 00 00       	jmp    102a43 <__alltraps>

00102065 <vector18>:
.globl vector18
vector18:
  pushl $0
  102065:	6a 00                	push   $0x0
  pushl $18
  102067:	6a 12                	push   $0x12
  jmp __alltraps
  102069:	e9 d5 09 00 00       	jmp    102a43 <__alltraps>

0010206e <vector19>:
.globl vector19
vector19:
  pushl $0
  10206e:	6a 00                	push   $0x0
  pushl $19
  102070:	6a 13                	push   $0x13
  jmp __alltraps
  102072:	e9 cc 09 00 00       	jmp    102a43 <__alltraps>

00102077 <vector20>:
.globl vector20
vector20:
  pushl $0
  102077:	6a 00                	push   $0x0
  pushl $20
  102079:	6a 14                	push   $0x14
  jmp __alltraps
  10207b:	e9 c3 09 00 00       	jmp    102a43 <__alltraps>

00102080 <vector21>:
.globl vector21
vector21:
  pushl $0
  102080:	6a 00                	push   $0x0
  pushl $21
  102082:	6a 15                	push   $0x15
  jmp __alltraps
  102084:	e9 ba 09 00 00       	jmp    102a43 <__alltraps>

00102089 <vector22>:
.globl vector22
vector22:
  pushl $0
  102089:	6a 00                	push   $0x0
  pushl $22
  10208b:	6a 16                	push   $0x16
  jmp __alltraps
  10208d:	e9 b1 09 00 00       	jmp    102a43 <__alltraps>

00102092 <vector23>:
.globl vector23
vector23:
  pushl $0
  102092:	6a 00                	push   $0x0
  pushl $23
  102094:	6a 17                	push   $0x17
  jmp __alltraps
  102096:	e9 a8 09 00 00       	jmp    102a43 <__alltraps>

0010209b <vector24>:
.globl vector24
vector24:
  pushl $0
  10209b:	6a 00                	push   $0x0
  pushl $24
  10209d:	6a 18                	push   $0x18
  jmp __alltraps
  10209f:	e9 9f 09 00 00       	jmp    102a43 <__alltraps>

001020a4 <vector25>:
.globl vector25
vector25:
  pushl $0
  1020a4:	6a 00                	push   $0x0
  pushl $25
  1020a6:	6a 19                	push   $0x19
  jmp __alltraps
  1020a8:	e9 96 09 00 00       	jmp    102a43 <__alltraps>

001020ad <vector26>:
.globl vector26
vector26:
  pushl $0
  1020ad:	6a 00                	push   $0x0
  pushl $26
  1020af:	6a 1a                	push   $0x1a
  jmp __alltraps
  1020b1:	e9 8d 09 00 00       	jmp    102a43 <__alltraps>

001020b6 <vector27>:
.globl vector27
vector27:
  pushl $0
  1020b6:	6a 00                	push   $0x0
  pushl $27
  1020b8:	6a 1b                	push   $0x1b
  jmp __alltraps
  1020ba:	e9 84 09 00 00       	jmp    102a43 <__alltraps>

001020bf <vector28>:
.globl vector28
vector28:
  pushl $0
  1020bf:	6a 00                	push   $0x0
  pushl $28
  1020c1:	6a 1c                	push   $0x1c
  jmp __alltraps
  1020c3:	e9 7b 09 00 00       	jmp    102a43 <__alltraps>

001020c8 <vector29>:
.globl vector29
vector29:
  pushl $0
  1020c8:	6a 00                	push   $0x0
  pushl $29
  1020ca:	6a 1d                	push   $0x1d
  jmp __alltraps
  1020cc:	e9 72 09 00 00       	jmp    102a43 <__alltraps>

001020d1 <vector30>:
.globl vector30
vector30:
  pushl $0
  1020d1:	6a 00                	push   $0x0
  pushl $30
  1020d3:	6a 1e                	push   $0x1e
  jmp __alltraps
  1020d5:	e9 69 09 00 00       	jmp    102a43 <__alltraps>

001020da <vector31>:
.globl vector31
vector31:
  pushl $0
  1020da:	6a 00                	push   $0x0
  pushl $31
  1020dc:	6a 1f                	push   $0x1f
  jmp __alltraps
  1020de:	e9 60 09 00 00       	jmp    102a43 <__alltraps>

001020e3 <vector32>:
.globl vector32
vector32:
  pushl $0
  1020e3:	6a 00                	push   $0x0
  pushl $32
  1020e5:	6a 20                	push   $0x20
  jmp __alltraps
  1020e7:	e9 57 09 00 00       	jmp    102a43 <__alltraps>

001020ec <vector33>:
.globl vector33
vector33:
  pushl $0
  1020ec:	6a 00                	push   $0x0
  pushl $33
  1020ee:	6a 21                	push   $0x21
  jmp __alltraps
  1020f0:	e9 4e 09 00 00       	jmp    102a43 <__alltraps>

001020f5 <vector34>:
.globl vector34
vector34:
  pushl $0
  1020f5:	6a 00                	push   $0x0
  pushl $34
  1020f7:	6a 22                	push   $0x22
  jmp __alltraps
  1020f9:	e9 45 09 00 00       	jmp    102a43 <__alltraps>

001020fe <vector35>:
.globl vector35
vector35:
  pushl $0
  1020fe:	6a 00                	push   $0x0
  pushl $35
  102100:	6a 23                	push   $0x23
  jmp __alltraps
  102102:	e9 3c 09 00 00       	jmp    102a43 <__alltraps>

00102107 <vector36>:
.globl vector36
vector36:
  pushl $0
  102107:	6a 00                	push   $0x0
  pushl $36
  102109:	6a 24                	push   $0x24
  jmp __alltraps
  10210b:	e9 33 09 00 00       	jmp    102a43 <__alltraps>

00102110 <vector37>:
.globl vector37
vector37:
  pushl $0
  102110:	6a 00                	push   $0x0
  pushl $37
  102112:	6a 25                	push   $0x25
  jmp __alltraps
  102114:	e9 2a 09 00 00       	jmp    102a43 <__alltraps>

00102119 <vector38>:
.globl vector38
vector38:
  pushl $0
  102119:	6a 00                	push   $0x0
  pushl $38
  10211b:	6a 26                	push   $0x26
  jmp __alltraps
  10211d:	e9 21 09 00 00       	jmp    102a43 <__alltraps>

00102122 <vector39>:
.globl vector39
vector39:
  pushl $0
  102122:	6a 00                	push   $0x0
  pushl $39
  102124:	6a 27                	push   $0x27
  jmp __alltraps
  102126:	e9 18 09 00 00       	jmp    102a43 <__alltraps>

0010212b <vector40>:
.globl vector40
vector40:
  pushl $0
  10212b:	6a 00                	push   $0x0
  pushl $40
  10212d:	6a 28                	push   $0x28
  jmp __alltraps
  10212f:	e9 0f 09 00 00       	jmp    102a43 <__alltraps>

00102134 <vector41>:
.globl vector41
vector41:
  pushl $0
  102134:	6a 00                	push   $0x0
  pushl $41
  102136:	6a 29                	push   $0x29
  jmp __alltraps
  102138:	e9 06 09 00 00       	jmp    102a43 <__alltraps>

0010213d <vector42>:
.globl vector42
vector42:
  pushl $0
  10213d:	6a 00                	push   $0x0
  pushl $42
  10213f:	6a 2a                	push   $0x2a
  jmp __alltraps
  102141:	e9 fd 08 00 00       	jmp    102a43 <__alltraps>

00102146 <vector43>:
.globl vector43
vector43:
  pushl $0
  102146:	6a 00                	push   $0x0
  pushl $43
  102148:	6a 2b                	push   $0x2b
  jmp __alltraps
  10214a:	e9 f4 08 00 00       	jmp    102a43 <__alltraps>

0010214f <vector44>:
.globl vector44
vector44:
  pushl $0
  10214f:	6a 00                	push   $0x0
  pushl $44
  102151:	6a 2c                	push   $0x2c
  jmp __alltraps
  102153:	e9 eb 08 00 00       	jmp    102a43 <__alltraps>

00102158 <vector45>:
.globl vector45
vector45:
  pushl $0
  102158:	6a 00                	push   $0x0
  pushl $45
  10215a:	6a 2d                	push   $0x2d
  jmp __alltraps
  10215c:	e9 e2 08 00 00       	jmp    102a43 <__alltraps>

00102161 <vector46>:
.globl vector46
vector46:
  pushl $0
  102161:	6a 00                	push   $0x0
  pushl $46
  102163:	6a 2e                	push   $0x2e
  jmp __alltraps
  102165:	e9 d9 08 00 00       	jmp    102a43 <__alltraps>

0010216a <vector47>:
.globl vector47
vector47:
  pushl $0
  10216a:	6a 00                	push   $0x0
  pushl $47
  10216c:	6a 2f                	push   $0x2f
  jmp __alltraps
  10216e:	e9 d0 08 00 00       	jmp    102a43 <__alltraps>

00102173 <vector48>:
.globl vector48
vector48:
  pushl $0
  102173:	6a 00                	push   $0x0
  pushl $48
  102175:	6a 30                	push   $0x30
  jmp __alltraps
  102177:	e9 c7 08 00 00       	jmp    102a43 <__alltraps>

0010217c <vector49>:
.globl vector49
vector49:
  pushl $0
  10217c:	6a 00                	push   $0x0
  pushl $49
  10217e:	6a 31                	push   $0x31
  jmp __alltraps
  102180:	e9 be 08 00 00       	jmp    102a43 <__alltraps>

00102185 <vector50>:
.globl vector50
vector50:
  pushl $0
  102185:	6a 00                	push   $0x0
  pushl $50
  102187:	6a 32                	push   $0x32
  jmp __alltraps
  102189:	e9 b5 08 00 00       	jmp    102a43 <__alltraps>

0010218e <vector51>:
.globl vector51
vector51:
  pushl $0
  10218e:	6a 00                	push   $0x0
  pushl $51
  102190:	6a 33                	push   $0x33
  jmp __alltraps
  102192:	e9 ac 08 00 00       	jmp    102a43 <__alltraps>

00102197 <vector52>:
.globl vector52
vector52:
  pushl $0
  102197:	6a 00                	push   $0x0
  pushl $52
  102199:	6a 34                	push   $0x34
  jmp __alltraps
  10219b:	e9 a3 08 00 00       	jmp    102a43 <__alltraps>

001021a0 <vector53>:
.globl vector53
vector53:
  pushl $0
  1021a0:	6a 00                	push   $0x0
  pushl $53
  1021a2:	6a 35                	push   $0x35
  jmp __alltraps
  1021a4:	e9 9a 08 00 00       	jmp    102a43 <__alltraps>

001021a9 <vector54>:
.globl vector54
vector54:
  pushl $0
  1021a9:	6a 00                	push   $0x0
  pushl $54
  1021ab:	6a 36                	push   $0x36
  jmp __alltraps
  1021ad:	e9 91 08 00 00       	jmp    102a43 <__alltraps>

001021b2 <vector55>:
.globl vector55
vector55:
  pushl $0
  1021b2:	6a 00                	push   $0x0
  pushl $55
  1021b4:	6a 37                	push   $0x37
  jmp __alltraps
  1021b6:	e9 88 08 00 00       	jmp    102a43 <__alltraps>

001021bb <vector56>:
.globl vector56
vector56:
  pushl $0
  1021bb:	6a 00                	push   $0x0
  pushl $56
  1021bd:	6a 38                	push   $0x38
  jmp __alltraps
  1021bf:	e9 7f 08 00 00       	jmp    102a43 <__alltraps>

001021c4 <vector57>:
.globl vector57
vector57:
  pushl $0
  1021c4:	6a 00                	push   $0x0
  pushl $57
  1021c6:	6a 39                	push   $0x39
  jmp __alltraps
  1021c8:	e9 76 08 00 00       	jmp    102a43 <__alltraps>

001021cd <vector58>:
.globl vector58
vector58:
  pushl $0
  1021cd:	6a 00                	push   $0x0
  pushl $58
  1021cf:	6a 3a                	push   $0x3a
  jmp __alltraps
  1021d1:	e9 6d 08 00 00       	jmp    102a43 <__alltraps>

001021d6 <vector59>:
.globl vector59
vector59:
  pushl $0
  1021d6:	6a 00                	push   $0x0
  pushl $59
  1021d8:	6a 3b                	push   $0x3b
  jmp __alltraps
  1021da:	e9 64 08 00 00       	jmp    102a43 <__alltraps>

001021df <vector60>:
.globl vector60
vector60:
  pushl $0
  1021df:	6a 00                	push   $0x0
  pushl $60
  1021e1:	6a 3c                	push   $0x3c
  jmp __alltraps
  1021e3:	e9 5b 08 00 00       	jmp    102a43 <__alltraps>

001021e8 <vector61>:
.globl vector61
vector61:
  pushl $0
  1021e8:	6a 00                	push   $0x0
  pushl $61
  1021ea:	6a 3d                	push   $0x3d
  jmp __alltraps
  1021ec:	e9 52 08 00 00       	jmp    102a43 <__alltraps>

001021f1 <vector62>:
.globl vector62
vector62:
  pushl $0
  1021f1:	6a 00                	push   $0x0
  pushl $62
  1021f3:	6a 3e                	push   $0x3e
  jmp __alltraps
  1021f5:	e9 49 08 00 00       	jmp    102a43 <__alltraps>

001021fa <vector63>:
.globl vector63
vector63:
  pushl $0
  1021fa:	6a 00                	push   $0x0
  pushl $63
  1021fc:	6a 3f                	push   $0x3f
  jmp __alltraps
  1021fe:	e9 40 08 00 00       	jmp    102a43 <__alltraps>

00102203 <vector64>:
.globl vector64
vector64:
  pushl $0
  102203:	6a 00                	push   $0x0
  pushl $64
  102205:	6a 40                	push   $0x40
  jmp __alltraps
  102207:	e9 37 08 00 00       	jmp    102a43 <__alltraps>

0010220c <vector65>:
.globl vector65
vector65:
  pushl $0
  10220c:	6a 00                	push   $0x0
  pushl $65
  10220e:	6a 41                	push   $0x41
  jmp __alltraps
  102210:	e9 2e 08 00 00       	jmp    102a43 <__alltraps>

00102215 <vector66>:
.globl vector66
vector66:
  pushl $0
  102215:	6a 00                	push   $0x0
  pushl $66
  102217:	6a 42                	push   $0x42
  jmp __alltraps
  102219:	e9 25 08 00 00       	jmp    102a43 <__alltraps>

0010221e <vector67>:
.globl vector67
vector67:
  pushl $0
  10221e:	6a 00                	push   $0x0
  pushl $67
  102220:	6a 43                	push   $0x43
  jmp __alltraps
  102222:	e9 1c 08 00 00       	jmp    102a43 <__alltraps>

00102227 <vector68>:
.globl vector68
vector68:
  pushl $0
  102227:	6a 00                	push   $0x0
  pushl $68
  102229:	6a 44                	push   $0x44
  jmp __alltraps
  10222b:	e9 13 08 00 00       	jmp    102a43 <__alltraps>

00102230 <vector69>:
.globl vector69
vector69:
  pushl $0
  102230:	6a 00                	push   $0x0
  pushl $69
  102232:	6a 45                	push   $0x45
  jmp __alltraps
  102234:	e9 0a 08 00 00       	jmp    102a43 <__alltraps>

00102239 <vector70>:
.globl vector70
vector70:
  pushl $0
  102239:	6a 00                	push   $0x0
  pushl $70
  10223b:	6a 46                	push   $0x46
  jmp __alltraps
  10223d:	e9 01 08 00 00       	jmp    102a43 <__alltraps>

00102242 <vector71>:
.globl vector71
vector71:
  pushl $0
  102242:	6a 00                	push   $0x0
  pushl $71
  102244:	6a 47                	push   $0x47
  jmp __alltraps
  102246:	e9 f8 07 00 00       	jmp    102a43 <__alltraps>

0010224b <vector72>:
.globl vector72
vector72:
  pushl $0
  10224b:	6a 00                	push   $0x0
  pushl $72
  10224d:	6a 48                	push   $0x48
  jmp __alltraps
  10224f:	e9 ef 07 00 00       	jmp    102a43 <__alltraps>

00102254 <vector73>:
.globl vector73
vector73:
  pushl $0
  102254:	6a 00                	push   $0x0
  pushl $73
  102256:	6a 49                	push   $0x49
  jmp __alltraps
  102258:	e9 e6 07 00 00       	jmp    102a43 <__alltraps>

0010225d <vector74>:
.globl vector74
vector74:
  pushl $0
  10225d:	6a 00                	push   $0x0
  pushl $74
  10225f:	6a 4a                	push   $0x4a
  jmp __alltraps
  102261:	e9 dd 07 00 00       	jmp    102a43 <__alltraps>

00102266 <vector75>:
.globl vector75
vector75:
  pushl $0
  102266:	6a 00                	push   $0x0
  pushl $75
  102268:	6a 4b                	push   $0x4b
  jmp __alltraps
  10226a:	e9 d4 07 00 00       	jmp    102a43 <__alltraps>

0010226f <vector76>:
.globl vector76
vector76:
  pushl $0
  10226f:	6a 00                	push   $0x0
  pushl $76
  102271:	6a 4c                	push   $0x4c
  jmp __alltraps
  102273:	e9 cb 07 00 00       	jmp    102a43 <__alltraps>

00102278 <vector77>:
.globl vector77
vector77:
  pushl $0
  102278:	6a 00                	push   $0x0
  pushl $77
  10227a:	6a 4d                	push   $0x4d
  jmp __alltraps
  10227c:	e9 c2 07 00 00       	jmp    102a43 <__alltraps>

00102281 <vector78>:
.globl vector78
vector78:
  pushl $0
  102281:	6a 00                	push   $0x0
  pushl $78
  102283:	6a 4e                	push   $0x4e
  jmp __alltraps
  102285:	e9 b9 07 00 00       	jmp    102a43 <__alltraps>

0010228a <vector79>:
.globl vector79
vector79:
  pushl $0
  10228a:	6a 00                	push   $0x0
  pushl $79
  10228c:	6a 4f                	push   $0x4f
  jmp __alltraps
  10228e:	e9 b0 07 00 00       	jmp    102a43 <__alltraps>

00102293 <vector80>:
.globl vector80
vector80:
  pushl $0
  102293:	6a 00                	push   $0x0
  pushl $80
  102295:	6a 50                	push   $0x50
  jmp __alltraps
  102297:	e9 a7 07 00 00       	jmp    102a43 <__alltraps>

0010229c <vector81>:
.globl vector81
vector81:
  pushl $0
  10229c:	6a 00                	push   $0x0
  pushl $81
  10229e:	6a 51                	push   $0x51
  jmp __alltraps
  1022a0:	e9 9e 07 00 00       	jmp    102a43 <__alltraps>

001022a5 <vector82>:
.globl vector82
vector82:
  pushl $0
  1022a5:	6a 00                	push   $0x0
  pushl $82
  1022a7:	6a 52                	push   $0x52
  jmp __alltraps
  1022a9:	e9 95 07 00 00       	jmp    102a43 <__alltraps>

001022ae <vector83>:
.globl vector83
vector83:
  pushl $0
  1022ae:	6a 00                	push   $0x0
  pushl $83
  1022b0:	6a 53                	push   $0x53
  jmp __alltraps
  1022b2:	e9 8c 07 00 00       	jmp    102a43 <__alltraps>

001022b7 <vector84>:
.globl vector84
vector84:
  pushl $0
  1022b7:	6a 00                	push   $0x0
  pushl $84
  1022b9:	6a 54                	push   $0x54
  jmp __alltraps
  1022bb:	e9 83 07 00 00       	jmp    102a43 <__alltraps>

001022c0 <vector85>:
.globl vector85
vector85:
  pushl $0
  1022c0:	6a 00                	push   $0x0
  pushl $85
  1022c2:	6a 55                	push   $0x55
  jmp __alltraps
  1022c4:	e9 7a 07 00 00       	jmp    102a43 <__alltraps>

001022c9 <vector86>:
.globl vector86
vector86:
  pushl $0
  1022c9:	6a 00                	push   $0x0
  pushl $86
  1022cb:	6a 56                	push   $0x56
  jmp __alltraps
  1022cd:	e9 71 07 00 00       	jmp    102a43 <__alltraps>

001022d2 <vector87>:
.globl vector87
vector87:
  pushl $0
  1022d2:	6a 00                	push   $0x0
  pushl $87
  1022d4:	6a 57                	push   $0x57
  jmp __alltraps
  1022d6:	e9 68 07 00 00       	jmp    102a43 <__alltraps>

001022db <vector88>:
.globl vector88
vector88:
  pushl $0
  1022db:	6a 00                	push   $0x0
  pushl $88
  1022dd:	6a 58                	push   $0x58
  jmp __alltraps
  1022df:	e9 5f 07 00 00       	jmp    102a43 <__alltraps>

001022e4 <vector89>:
.globl vector89
vector89:
  pushl $0
  1022e4:	6a 00                	push   $0x0
  pushl $89
  1022e6:	6a 59                	push   $0x59
  jmp __alltraps
  1022e8:	e9 56 07 00 00       	jmp    102a43 <__alltraps>

001022ed <vector90>:
.globl vector90
vector90:
  pushl $0
  1022ed:	6a 00                	push   $0x0
  pushl $90
  1022ef:	6a 5a                	push   $0x5a
  jmp __alltraps
  1022f1:	e9 4d 07 00 00       	jmp    102a43 <__alltraps>

001022f6 <vector91>:
.globl vector91
vector91:
  pushl $0
  1022f6:	6a 00                	push   $0x0
  pushl $91
  1022f8:	6a 5b                	push   $0x5b
  jmp __alltraps
  1022fa:	e9 44 07 00 00       	jmp    102a43 <__alltraps>

001022ff <vector92>:
.globl vector92
vector92:
  pushl $0
  1022ff:	6a 00                	push   $0x0
  pushl $92
  102301:	6a 5c                	push   $0x5c
  jmp __alltraps
  102303:	e9 3b 07 00 00       	jmp    102a43 <__alltraps>

00102308 <vector93>:
.globl vector93
vector93:
  pushl $0
  102308:	6a 00                	push   $0x0
  pushl $93
  10230a:	6a 5d                	push   $0x5d
  jmp __alltraps
  10230c:	e9 32 07 00 00       	jmp    102a43 <__alltraps>

00102311 <vector94>:
.globl vector94
vector94:
  pushl $0
  102311:	6a 00                	push   $0x0
  pushl $94
  102313:	6a 5e                	push   $0x5e
  jmp __alltraps
  102315:	e9 29 07 00 00       	jmp    102a43 <__alltraps>

0010231a <vector95>:
.globl vector95
vector95:
  pushl $0
  10231a:	6a 00                	push   $0x0
  pushl $95
  10231c:	6a 5f                	push   $0x5f
  jmp __alltraps
  10231e:	e9 20 07 00 00       	jmp    102a43 <__alltraps>

00102323 <vector96>:
.globl vector96
vector96:
  pushl $0
  102323:	6a 00                	push   $0x0
  pushl $96
  102325:	6a 60                	push   $0x60
  jmp __alltraps
  102327:	e9 17 07 00 00       	jmp    102a43 <__alltraps>

0010232c <vector97>:
.globl vector97
vector97:
  pushl $0
  10232c:	6a 00                	push   $0x0
  pushl $97
  10232e:	6a 61                	push   $0x61
  jmp __alltraps
  102330:	e9 0e 07 00 00       	jmp    102a43 <__alltraps>

00102335 <vector98>:
.globl vector98
vector98:
  pushl $0
  102335:	6a 00                	push   $0x0
  pushl $98
  102337:	6a 62                	push   $0x62
  jmp __alltraps
  102339:	e9 05 07 00 00       	jmp    102a43 <__alltraps>

0010233e <vector99>:
.globl vector99
vector99:
  pushl $0
  10233e:	6a 00                	push   $0x0
  pushl $99
  102340:	6a 63                	push   $0x63
  jmp __alltraps
  102342:	e9 fc 06 00 00       	jmp    102a43 <__alltraps>

00102347 <vector100>:
.globl vector100
vector100:
  pushl $0
  102347:	6a 00                	push   $0x0
  pushl $100
  102349:	6a 64                	push   $0x64
  jmp __alltraps
  10234b:	e9 f3 06 00 00       	jmp    102a43 <__alltraps>

00102350 <vector101>:
.globl vector101
vector101:
  pushl $0
  102350:	6a 00                	push   $0x0
  pushl $101
  102352:	6a 65                	push   $0x65
  jmp __alltraps
  102354:	e9 ea 06 00 00       	jmp    102a43 <__alltraps>

00102359 <vector102>:
.globl vector102
vector102:
  pushl $0
  102359:	6a 00                	push   $0x0
  pushl $102
  10235b:	6a 66                	push   $0x66
  jmp __alltraps
  10235d:	e9 e1 06 00 00       	jmp    102a43 <__alltraps>

00102362 <vector103>:
.globl vector103
vector103:
  pushl $0
  102362:	6a 00                	push   $0x0
  pushl $103
  102364:	6a 67                	push   $0x67
  jmp __alltraps
  102366:	e9 d8 06 00 00       	jmp    102a43 <__alltraps>

0010236b <vector104>:
.globl vector104
vector104:
  pushl $0
  10236b:	6a 00                	push   $0x0
  pushl $104
  10236d:	6a 68                	push   $0x68
  jmp __alltraps
  10236f:	e9 cf 06 00 00       	jmp    102a43 <__alltraps>

00102374 <vector105>:
.globl vector105
vector105:
  pushl $0
  102374:	6a 00                	push   $0x0
  pushl $105
  102376:	6a 69                	push   $0x69
  jmp __alltraps
  102378:	e9 c6 06 00 00       	jmp    102a43 <__alltraps>

0010237d <vector106>:
.globl vector106
vector106:
  pushl $0
  10237d:	6a 00                	push   $0x0
  pushl $106
  10237f:	6a 6a                	push   $0x6a
  jmp __alltraps
  102381:	e9 bd 06 00 00       	jmp    102a43 <__alltraps>

00102386 <vector107>:
.globl vector107
vector107:
  pushl $0
  102386:	6a 00                	push   $0x0
  pushl $107
  102388:	6a 6b                	push   $0x6b
  jmp __alltraps
  10238a:	e9 b4 06 00 00       	jmp    102a43 <__alltraps>

0010238f <vector108>:
.globl vector108
vector108:
  pushl $0
  10238f:	6a 00                	push   $0x0
  pushl $108
  102391:	6a 6c                	push   $0x6c
  jmp __alltraps
  102393:	e9 ab 06 00 00       	jmp    102a43 <__alltraps>

00102398 <vector109>:
.globl vector109
vector109:
  pushl $0
  102398:	6a 00                	push   $0x0
  pushl $109
  10239a:	6a 6d                	push   $0x6d
  jmp __alltraps
  10239c:	e9 a2 06 00 00       	jmp    102a43 <__alltraps>

001023a1 <vector110>:
.globl vector110
vector110:
  pushl $0
  1023a1:	6a 00                	push   $0x0
  pushl $110
  1023a3:	6a 6e                	push   $0x6e
  jmp __alltraps
  1023a5:	e9 99 06 00 00       	jmp    102a43 <__alltraps>

001023aa <vector111>:
.globl vector111
vector111:
  pushl $0
  1023aa:	6a 00                	push   $0x0
  pushl $111
  1023ac:	6a 6f                	push   $0x6f
  jmp __alltraps
  1023ae:	e9 90 06 00 00       	jmp    102a43 <__alltraps>

001023b3 <vector112>:
.globl vector112
vector112:
  pushl $0
  1023b3:	6a 00                	push   $0x0
  pushl $112
  1023b5:	6a 70                	push   $0x70
  jmp __alltraps
  1023b7:	e9 87 06 00 00       	jmp    102a43 <__alltraps>

001023bc <vector113>:
.globl vector113
vector113:
  pushl $0
  1023bc:	6a 00                	push   $0x0
  pushl $113
  1023be:	6a 71                	push   $0x71
  jmp __alltraps
  1023c0:	e9 7e 06 00 00       	jmp    102a43 <__alltraps>

001023c5 <vector114>:
.globl vector114
vector114:
  pushl $0
  1023c5:	6a 00                	push   $0x0
  pushl $114
  1023c7:	6a 72                	push   $0x72
  jmp __alltraps
  1023c9:	e9 75 06 00 00       	jmp    102a43 <__alltraps>

001023ce <vector115>:
.globl vector115
vector115:
  pushl $0
  1023ce:	6a 00                	push   $0x0
  pushl $115
  1023d0:	6a 73                	push   $0x73
  jmp __alltraps
  1023d2:	e9 6c 06 00 00       	jmp    102a43 <__alltraps>

001023d7 <vector116>:
.globl vector116
vector116:
  pushl $0
  1023d7:	6a 00                	push   $0x0
  pushl $116
  1023d9:	6a 74                	push   $0x74
  jmp __alltraps
  1023db:	e9 63 06 00 00       	jmp    102a43 <__alltraps>

001023e0 <vector117>:
.globl vector117
vector117:
  pushl $0
  1023e0:	6a 00                	push   $0x0
  pushl $117
  1023e2:	6a 75                	push   $0x75
  jmp __alltraps
  1023e4:	e9 5a 06 00 00       	jmp    102a43 <__alltraps>

001023e9 <vector118>:
.globl vector118
vector118:
  pushl $0
  1023e9:	6a 00                	push   $0x0
  pushl $118
  1023eb:	6a 76                	push   $0x76
  jmp __alltraps
  1023ed:	e9 51 06 00 00       	jmp    102a43 <__alltraps>

001023f2 <vector119>:
.globl vector119
vector119:
  pushl $0
  1023f2:	6a 00                	push   $0x0
  pushl $119
  1023f4:	6a 77                	push   $0x77
  jmp __alltraps
  1023f6:	e9 48 06 00 00       	jmp    102a43 <__alltraps>

001023fb <vector120>:
.globl vector120
vector120:
  pushl $0
  1023fb:	6a 00                	push   $0x0
  pushl $120
  1023fd:	6a 78                	push   $0x78
  jmp __alltraps
  1023ff:	e9 3f 06 00 00       	jmp    102a43 <__alltraps>

00102404 <vector121>:
.globl vector121
vector121:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $121
  102406:	6a 79                	push   $0x79
  jmp __alltraps
  102408:	e9 36 06 00 00       	jmp    102a43 <__alltraps>

0010240d <vector122>:
.globl vector122
vector122:
  pushl $0
  10240d:	6a 00                	push   $0x0
  pushl $122
  10240f:	6a 7a                	push   $0x7a
  jmp __alltraps
  102411:	e9 2d 06 00 00       	jmp    102a43 <__alltraps>

00102416 <vector123>:
.globl vector123
vector123:
  pushl $0
  102416:	6a 00                	push   $0x0
  pushl $123
  102418:	6a 7b                	push   $0x7b
  jmp __alltraps
  10241a:	e9 24 06 00 00       	jmp    102a43 <__alltraps>

0010241f <vector124>:
.globl vector124
vector124:
  pushl $0
  10241f:	6a 00                	push   $0x0
  pushl $124
  102421:	6a 7c                	push   $0x7c
  jmp __alltraps
  102423:	e9 1b 06 00 00       	jmp    102a43 <__alltraps>

00102428 <vector125>:
.globl vector125
vector125:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $125
  10242a:	6a 7d                	push   $0x7d
  jmp __alltraps
  10242c:	e9 12 06 00 00       	jmp    102a43 <__alltraps>

00102431 <vector126>:
.globl vector126
vector126:
  pushl $0
  102431:	6a 00                	push   $0x0
  pushl $126
  102433:	6a 7e                	push   $0x7e
  jmp __alltraps
  102435:	e9 09 06 00 00       	jmp    102a43 <__alltraps>

0010243a <vector127>:
.globl vector127
vector127:
  pushl $0
  10243a:	6a 00                	push   $0x0
  pushl $127
  10243c:	6a 7f                	push   $0x7f
  jmp __alltraps
  10243e:	e9 00 06 00 00       	jmp    102a43 <__alltraps>

00102443 <vector128>:
.globl vector128
vector128:
  pushl $0
  102443:	6a 00                	push   $0x0
  pushl $128
  102445:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10244a:	e9 f4 05 00 00       	jmp    102a43 <__alltraps>

0010244f <vector129>:
.globl vector129
vector129:
  pushl $0
  10244f:	6a 00                	push   $0x0
  pushl $129
  102451:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102456:	e9 e8 05 00 00       	jmp    102a43 <__alltraps>

0010245b <vector130>:
.globl vector130
vector130:
  pushl $0
  10245b:	6a 00                	push   $0x0
  pushl $130
  10245d:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102462:	e9 dc 05 00 00       	jmp    102a43 <__alltraps>

00102467 <vector131>:
.globl vector131
vector131:
  pushl $0
  102467:	6a 00                	push   $0x0
  pushl $131
  102469:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10246e:	e9 d0 05 00 00       	jmp    102a43 <__alltraps>

00102473 <vector132>:
.globl vector132
vector132:
  pushl $0
  102473:	6a 00                	push   $0x0
  pushl $132
  102475:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10247a:	e9 c4 05 00 00       	jmp    102a43 <__alltraps>

0010247f <vector133>:
.globl vector133
vector133:
  pushl $0
  10247f:	6a 00                	push   $0x0
  pushl $133
  102481:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102486:	e9 b8 05 00 00       	jmp    102a43 <__alltraps>

0010248b <vector134>:
.globl vector134
vector134:
  pushl $0
  10248b:	6a 00                	push   $0x0
  pushl $134
  10248d:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102492:	e9 ac 05 00 00       	jmp    102a43 <__alltraps>

00102497 <vector135>:
.globl vector135
vector135:
  pushl $0
  102497:	6a 00                	push   $0x0
  pushl $135
  102499:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10249e:	e9 a0 05 00 00       	jmp    102a43 <__alltraps>

001024a3 <vector136>:
.globl vector136
vector136:
  pushl $0
  1024a3:	6a 00                	push   $0x0
  pushl $136
  1024a5:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1024aa:	e9 94 05 00 00       	jmp    102a43 <__alltraps>

001024af <vector137>:
.globl vector137
vector137:
  pushl $0
  1024af:	6a 00                	push   $0x0
  pushl $137
  1024b1:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1024b6:	e9 88 05 00 00       	jmp    102a43 <__alltraps>

001024bb <vector138>:
.globl vector138
vector138:
  pushl $0
  1024bb:	6a 00                	push   $0x0
  pushl $138
  1024bd:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1024c2:	e9 7c 05 00 00       	jmp    102a43 <__alltraps>

001024c7 <vector139>:
.globl vector139
vector139:
  pushl $0
  1024c7:	6a 00                	push   $0x0
  pushl $139
  1024c9:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1024ce:	e9 70 05 00 00       	jmp    102a43 <__alltraps>

001024d3 <vector140>:
.globl vector140
vector140:
  pushl $0
  1024d3:	6a 00                	push   $0x0
  pushl $140
  1024d5:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1024da:	e9 64 05 00 00       	jmp    102a43 <__alltraps>

001024df <vector141>:
.globl vector141
vector141:
  pushl $0
  1024df:	6a 00                	push   $0x0
  pushl $141
  1024e1:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1024e6:	e9 58 05 00 00       	jmp    102a43 <__alltraps>

001024eb <vector142>:
.globl vector142
vector142:
  pushl $0
  1024eb:	6a 00                	push   $0x0
  pushl $142
  1024ed:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1024f2:	e9 4c 05 00 00       	jmp    102a43 <__alltraps>

001024f7 <vector143>:
.globl vector143
vector143:
  pushl $0
  1024f7:	6a 00                	push   $0x0
  pushl $143
  1024f9:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1024fe:	e9 40 05 00 00       	jmp    102a43 <__alltraps>

00102503 <vector144>:
.globl vector144
vector144:
  pushl $0
  102503:	6a 00                	push   $0x0
  pushl $144
  102505:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10250a:	e9 34 05 00 00       	jmp    102a43 <__alltraps>

0010250f <vector145>:
.globl vector145
vector145:
  pushl $0
  10250f:	6a 00                	push   $0x0
  pushl $145
  102511:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102516:	e9 28 05 00 00       	jmp    102a43 <__alltraps>

0010251b <vector146>:
.globl vector146
vector146:
  pushl $0
  10251b:	6a 00                	push   $0x0
  pushl $146
  10251d:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102522:	e9 1c 05 00 00       	jmp    102a43 <__alltraps>

00102527 <vector147>:
.globl vector147
vector147:
  pushl $0
  102527:	6a 00                	push   $0x0
  pushl $147
  102529:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10252e:	e9 10 05 00 00       	jmp    102a43 <__alltraps>

00102533 <vector148>:
.globl vector148
vector148:
  pushl $0
  102533:	6a 00                	push   $0x0
  pushl $148
  102535:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10253a:	e9 04 05 00 00       	jmp    102a43 <__alltraps>

0010253f <vector149>:
.globl vector149
vector149:
  pushl $0
  10253f:	6a 00                	push   $0x0
  pushl $149
  102541:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102546:	e9 f8 04 00 00       	jmp    102a43 <__alltraps>

0010254b <vector150>:
.globl vector150
vector150:
  pushl $0
  10254b:	6a 00                	push   $0x0
  pushl $150
  10254d:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102552:	e9 ec 04 00 00       	jmp    102a43 <__alltraps>

00102557 <vector151>:
.globl vector151
vector151:
  pushl $0
  102557:	6a 00                	push   $0x0
  pushl $151
  102559:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10255e:	e9 e0 04 00 00       	jmp    102a43 <__alltraps>

00102563 <vector152>:
.globl vector152
vector152:
  pushl $0
  102563:	6a 00                	push   $0x0
  pushl $152
  102565:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10256a:	e9 d4 04 00 00       	jmp    102a43 <__alltraps>

0010256f <vector153>:
.globl vector153
vector153:
  pushl $0
  10256f:	6a 00                	push   $0x0
  pushl $153
  102571:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102576:	e9 c8 04 00 00       	jmp    102a43 <__alltraps>

0010257b <vector154>:
.globl vector154
vector154:
  pushl $0
  10257b:	6a 00                	push   $0x0
  pushl $154
  10257d:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102582:	e9 bc 04 00 00       	jmp    102a43 <__alltraps>

00102587 <vector155>:
.globl vector155
vector155:
  pushl $0
  102587:	6a 00                	push   $0x0
  pushl $155
  102589:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10258e:	e9 b0 04 00 00       	jmp    102a43 <__alltraps>

00102593 <vector156>:
.globl vector156
vector156:
  pushl $0
  102593:	6a 00                	push   $0x0
  pushl $156
  102595:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10259a:	e9 a4 04 00 00       	jmp    102a43 <__alltraps>

0010259f <vector157>:
.globl vector157
vector157:
  pushl $0
  10259f:	6a 00                	push   $0x0
  pushl $157
  1025a1:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1025a6:	e9 98 04 00 00       	jmp    102a43 <__alltraps>

001025ab <vector158>:
.globl vector158
vector158:
  pushl $0
  1025ab:	6a 00                	push   $0x0
  pushl $158
  1025ad:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1025b2:	e9 8c 04 00 00       	jmp    102a43 <__alltraps>

001025b7 <vector159>:
.globl vector159
vector159:
  pushl $0
  1025b7:	6a 00                	push   $0x0
  pushl $159
  1025b9:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1025be:	e9 80 04 00 00       	jmp    102a43 <__alltraps>

001025c3 <vector160>:
.globl vector160
vector160:
  pushl $0
  1025c3:	6a 00                	push   $0x0
  pushl $160
  1025c5:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1025ca:	e9 74 04 00 00       	jmp    102a43 <__alltraps>

001025cf <vector161>:
.globl vector161
vector161:
  pushl $0
  1025cf:	6a 00                	push   $0x0
  pushl $161
  1025d1:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1025d6:	e9 68 04 00 00       	jmp    102a43 <__alltraps>

001025db <vector162>:
.globl vector162
vector162:
  pushl $0
  1025db:	6a 00                	push   $0x0
  pushl $162
  1025dd:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1025e2:	e9 5c 04 00 00       	jmp    102a43 <__alltraps>

001025e7 <vector163>:
.globl vector163
vector163:
  pushl $0
  1025e7:	6a 00                	push   $0x0
  pushl $163
  1025e9:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1025ee:	e9 50 04 00 00       	jmp    102a43 <__alltraps>

001025f3 <vector164>:
.globl vector164
vector164:
  pushl $0
  1025f3:	6a 00                	push   $0x0
  pushl $164
  1025f5:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1025fa:	e9 44 04 00 00       	jmp    102a43 <__alltraps>

001025ff <vector165>:
.globl vector165
vector165:
  pushl $0
  1025ff:	6a 00                	push   $0x0
  pushl $165
  102601:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102606:	e9 38 04 00 00       	jmp    102a43 <__alltraps>

0010260b <vector166>:
.globl vector166
vector166:
  pushl $0
  10260b:	6a 00                	push   $0x0
  pushl $166
  10260d:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102612:	e9 2c 04 00 00       	jmp    102a43 <__alltraps>

00102617 <vector167>:
.globl vector167
vector167:
  pushl $0
  102617:	6a 00                	push   $0x0
  pushl $167
  102619:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10261e:	e9 20 04 00 00       	jmp    102a43 <__alltraps>

00102623 <vector168>:
.globl vector168
vector168:
  pushl $0
  102623:	6a 00                	push   $0x0
  pushl $168
  102625:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10262a:	e9 14 04 00 00       	jmp    102a43 <__alltraps>

0010262f <vector169>:
.globl vector169
vector169:
  pushl $0
  10262f:	6a 00                	push   $0x0
  pushl $169
  102631:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102636:	e9 08 04 00 00       	jmp    102a43 <__alltraps>

0010263b <vector170>:
.globl vector170
vector170:
  pushl $0
  10263b:	6a 00                	push   $0x0
  pushl $170
  10263d:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102642:	e9 fc 03 00 00       	jmp    102a43 <__alltraps>

00102647 <vector171>:
.globl vector171
vector171:
  pushl $0
  102647:	6a 00                	push   $0x0
  pushl $171
  102649:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10264e:	e9 f0 03 00 00       	jmp    102a43 <__alltraps>

00102653 <vector172>:
.globl vector172
vector172:
  pushl $0
  102653:	6a 00                	push   $0x0
  pushl $172
  102655:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10265a:	e9 e4 03 00 00       	jmp    102a43 <__alltraps>

0010265f <vector173>:
.globl vector173
vector173:
  pushl $0
  10265f:	6a 00                	push   $0x0
  pushl $173
  102661:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102666:	e9 d8 03 00 00       	jmp    102a43 <__alltraps>

0010266b <vector174>:
.globl vector174
vector174:
  pushl $0
  10266b:	6a 00                	push   $0x0
  pushl $174
  10266d:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102672:	e9 cc 03 00 00       	jmp    102a43 <__alltraps>

00102677 <vector175>:
.globl vector175
vector175:
  pushl $0
  102677:	6a 00                	push   $0x0
  pushl $175
  102679:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10267e:	e9 c0 03 00 00       	jmp    102a43 <__alltraps>

00102683 <vector176>:
.globl vector176
vector176:
  pushl $0
  102683:	6a 00                	push   $0x0
  pushl $176
  102685:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10268a:	e9 b4 03 00 00       	jmp    102a43 <__alltraps>

0010268f <vector177>:
.globl vector177
vector177:
  pushl $0
  10268f:	6a 00                	push   $0x0
  pushl $177
  102691:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102696:	e9 a8 03 00 00       	jmp    102a43 <__alltraps>

0010269b <vector178>:
.globl vector178
vector178:
  pushl $0
  10269b:	6a 00                	push   $0x0
  pushl $178
  10269d:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1026a2:	e9 9c 03 00 00       	jmp    102a43 <__alltraps>

001026a7 <vector179>:
.globl vector179
vector179:
  pushl $0
  1026a7:	6a 00                	push   $0x0
  pushl $179
  1026a9:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1026ae:	e9 90 03 00 00       	jmp    102a43 <__alltraps>

001026b3 <vector180>:
.globl vector180
vector180:
  pushl $0
  1026b3:	6a 00                	push   $0x0
  pushl $180
  1026b5:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1026ba:	e9 84 03 00 00       	jmp    102a43 <__alltraps>

001026bf <vector181>:
.globl vector181
vector181:
  pushl $0
  1026bf:	6a 00                	push   $0x0
  pushl $181
  1026c1:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1026c6:	e9 78 03 00 00       	jmp    102a43 <__alltraps>

001026cb <vector182>:
.globl vector182
vector182:
  pushl $0
  1026cb:	6a 00                	push   $0x0
  pushl $182
  1026cd:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1026d2:	e9 6c 03 00 00       	jmp    102a43 <__alltraps>

001026d7 <vector183>:
.globl vector183
vector183:
  pushl $0
  1026d7:	6a 00                	push   $0x0
  pushl $183
  1026d9:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1026de:	e9 60 03 00 00       	jmp    102a43 <__alltraps>

001026e3 <vector184>:
.globl vector184
vector184:
  pushl $0
  1026e3:	6a 00                	push   $0x0
  pushl $184
  1026e5:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1026ea:	e9 54 03 00 00       	jmp    102a43 <__alltraps>

001026ef <vector185>:
.globl vector185
vector185:
  pushl $0
  1026ef:	6a 00                	push   $0x0
  pushl $185
  1026f1:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1026f6:	e9 48 03 00 00       	jmp    102a43 <__alltraps>

001026fb <vector186>:
.globl vector186
vector186:
  pushl $0
  1026fb:	6a 00                	push   $0x0
  pushl $186
  1026fd:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102702:	e9 3c 03 00 00       	jmp    102a43 <__alltraps>

00102707 <vector187>:
.globl vector187
vector187:
  pushl $0
  102707:	6a 00                	push   $0x0
  pushl $187
  102709:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10270e:	e9 30 03 00 00       	jmp    102a43 <__alltraps>

00102713 <vector188>:
.globl vector188
vector188:
  pushl $0
  102713:	6a 00                	push   $0x0
  pushl $188
  102715:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10271a:	e9 24 03 00 00       	jmp    102a43 <__alltraps>

0010271f <vector189>:
.globl vector189
vector189:
  pushl $0
  10271f:	6a 00                	push   $0x0
  pushl $189
  102721:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102726:	e9 18 03 00 00       	jmp    102a43 <__alltraps>

0010272b <vector190>:
.globl vector190
vector190:
  pushl $0
  10272b:	6a 00                	push   $0x0
  pushl $190
  10272d:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102732:	e9 0c 03 00 00       	jmp    102a43 <__alltraps>

00102737 <vector191>:
.globl vector191
vector191:
  pushl $0
  102737:	6a 00                	push   $0x0
  pushl $191
  102739:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10273e:	e9 00 03 00 00       	jmp    102a43 <__alltraps>

00102743 <vector192>:
.globl vector192
vector192:
  pushl $0
  102743:	6a 00                	push   $0x0
  pushl $192
  102745:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10274a:	e9 f4 02 00 00       	jmp    102a43 <__alltraps>

0010274f <vector193>:
.globl vector193
vector193:
  pushl $0
  10274f:	6a 00                	push   $0x0
  pushl $193
  102751:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102756:	e9 e8 02 00 00       	jmp    102a43 <__alltraps>

0010275b <vector194>:
.globl vector194
vector194:
  pushl $0
  10275b:	6a 00                	push   $0x0
  pushl $194
  10275d:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102762:	e9 dc 02 00 00       	jmp    102a43 <__alltraps>

00102767 <vector195>:
.globl vector195
vector195:
  pushl $0
  102767:	6a 00                	push   $0x0
  pushl $195
  102769:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10276e:	e9 d0 02 00 00       	jmp    102a43 <__alltraps>

00102773 <vector196>:
.globl vector196
vector196:
  pushl $0
  102773:	6a 00                	push   $0x0
  pushl $196
  102775:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10277a:	e9 c4 02 00 00       	jmp    102a43 <__alltraps>

0010277f <vector197>:
.globl vector197
vector197:
  pushl $0
  10277f:	6a 00                	push   $0x0
  pushl $197
  102781:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102786:	e9 b8 02 00 00       	jmp    102a43 <__alltraps>

0010278b <vector198>:
.globl vector198
vector198:
  pushl $0
  10278b:	6a 00                	push   $0x0
  pushl $198
  10278d:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102792:	e9 ac 02 00 00       	jmp    102a43 <__alltraps>

00102797 <vector199>:
.globl vector199
vector199:
  pushl $0
  102797:	6a 00                	push   $0x0
  pushl $199
  102799:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10279e:	e9 a0 02 00 00       	jmp    102a43 <__alltraps>

001027a3 <vector200>:
.globl vector200
vector200:
  pushl $0
  1027a3:	6a 00                	push   $0x0
  pushl $200
  1027a5:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1027aa:	e9 94 02 00 00       	jmp    102a43 <__alltraps>

001027af <vector201>:
.globl vector201
vector201:
  pushl $0
  1027af:	6a 00                	push   $0x0
  pushl $201
  1027b1:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1027b6:	e9 88 02 00 00       	jmp    102a43 <__alltraps>

001027bb <vector202>:
.globl vector202
vector202:
  pushl $0
  1027bb:	6a 00                	push   $0x0
  pushl $202
  1027bd:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1027c2:	e9 7c 02 00 00       	jmp    102a43 <__alltraps>

001027c7 <vector203>:
.globl vector203
vector203:
  pushl $0
  1027c7:	6a 00                	push   $0x0
  pushl $203
  1027c9:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1027ce:	e9 70 02 00 00       	jmp    102a43 <__alltraps>

001027d3 <vector204>:
.globl vector204
vector204:
  pushl $0
  1027d3:	6a 00                	push   $0x0
  pushl $204
  1027d5:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1027da:	e9 64 02 00 00       	jmp    102a43 <__alltraps>

001027df <vector205>:
.globl vector205
vector205:
  pushl $0
  1027df:	6a 00                	push   $0x0
  pushl $205
  1027e1:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1027e6:	e9 58 02 00 00       	jmp    102a43 <__alltraps>

001027eb <vector206>:
.globl vector206
vector206:
  pushl $0
  1027eb:	6a 00                	push   $0x0
  pushl $206
  1027ed:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1027f2:	e9 4c 02 00 00       	jmp    102a43 <__alltraps>

001027f7 <vector207>:
.globl vector207
vector207:
  pushl $0
  1027f7:	6a 00                	push   $0x0
  pushl $207
  1027f9:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1027fe:	e9 40 02 00 00       	jmp    102a43 <__alltraps>

00102803 <vector208>:
.globl vector208
vector208:
  pushl $0
  102803:	6a 00                	push   $0x0
  pushl $208
  102805:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10280a:	e9 34 02 00 00       	jmp    102a43 <__alltraps>

0010280f <vector209>:
.globl vector209
vector209:
  pushl $0
  10280f:	6a 00                	push   $0x0
  pushl $209
  102811:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102816:	e9 28 02 00 00       	jmp    102a43 <__alltraps>

0010281b <vector210>:
.globl vector210
vector210:
  pushl $0
  10281b:	6a 00                	push   $0x0
  pushl $210
  10281d:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102822:	e9 1c 02 00 00       	jmp    102a43 <__alltraps>

00102827 <vector211>:
.globl vector211
vector211:
  pushl $0
  102827:	6a 00                	push   $0x0
  pushl $211
  102829:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10282e:	e9 10 02 00 00       	jmp    102a43 <__alltraps>

00102833 <vector212>:
.globl vector212
vector212:
  pushl $0
  102833:	6a 00                	push   $0x0
  pushl $212
  102835:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10283a:	e9 04 02 00 00       	jmp    102a43 <__alltraps>

0010283f <vector213>:
.globl vector213
vector213:
  pushl $0
  10283f:	6a 00                	push   $0x0
  pushl $213
  102841:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102846:	e9 f8 01 00 00       	jmp    102a43 <__alltraps>

0010284b <vector214>:
.globl vector214
vector214:
  pushl $0
  10284b:	6a 00                	push   $0x0
  pushl $214
  10284d:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102852:	e9 ec 01 00 00       	jmp    102a43 <__alltraps>

00102857 <vector215>:
.globl vector215
vector215:
  pushl $0
  102857:	6a 00                	push   $0x0
  pushl $215
  102859:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10285e:	e9 e0 01 00 00       	jmp    102a43 <__alltraps>

00102863 <vector216>:
.globl vector216
vector216:
  pushl $0
  102863:	6a 00                	push   $0x0
  pushl $216
  102865:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10286a:	e9 d4 01 00 00       	jmp    102a43 <__alltraps>

0010286f <vector217>:
.globl vector217
vector217:
  pushl $0
  10286f:	6a 00                	push   $0x0
  pushl $217
  102871:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102876:	e9 c8 01 00 00       	jmp    102a43 <__alltraps>

0010287b <vector218>:
.globl vector218
vector218:
  pushl $0
  10287b:	6a 00                	push   $0x0
  pushl $218
  10287d:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102882:	e9 bc 01 00 00       	jmp    102a43 <__alltraps>

00102887 <vector219>:
.globl vector219
vector219:
  pushl $0
  102887:	6a 00                	push   $0x0
  pushl $219
  102889:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10288e:	e9 b0 01 00 00       	jmp    102a43 <__alltraps>

00102893 <vector220>:
.globl vector220
vector220:
  pushl $0
  102893:	6a 00                	push   $0x0
  pushl $220
  102895:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10289a:	e9 a4 01 00 00       	jmp    102a43 <__alltraps>

0010289f <vector221>:
.globl vector221
vector221:
  pushl $0
  10289f:	6a 00                	push   $0x0
  pushl $221
  1028a1:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1028a6:	e9 98 01 00 00       	jmp    102a43 <__alltraps>

001028ab <vector222>:
.globl vector222
vector222:
  pushl $0
  1028ab:	6a 00                	push   $0x0
  pushl $222
  1028ad:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1028b2:	e9 8c 01 00 00       	jmp    102a43 <__alltraps>

001028b7 <vector223>:
.globl vector223
vector223:
  pushl $0
  1028b7:	6a 00                	push   $0x0
  pushl $223
  1028b9:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1028be:	e9 80 01 00 00       	jmp    102a43 <__alltraps>

001028c3 <vector224>:
.globl vector224
vector224:
  pushl $0
  1028c3:	6a 00                	push   $0x0
  pushl $224
  1028c5:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1028ca:	e9 74 01 00 00       	jmp    102a43 <__alltraps>

001028cf <vector225>:
.globl vector225
vector225:
  pushl $0
  1028cf:	6a 00                	push   $0x0
  pushl $225
  1028d1:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1028d6:	e9 68 01 00 00       	jmp    102a43 <__alltraps>

001028db <vector226>:
.globl vector226
vector226:
  pushl $0
  1028db:	6a 00                	push   $0x0
  pushl $226
  1028dd:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1028e2:	e9 5c 01 00 00       	jmp    102a43 <__alltraps>

001028e7 <vector227>:
.globl vector227
vector227:
  pushl $0
  1028e7:	6a 00                	push   $0x0
  pushl $227
  1028e9:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1028ee:	e9 50 01 00 00       	jmp    102a43 <__alltraps>

001028f3 <vector228>:
.globl vector228
vector228:
  pushl $0
  1028f3:	6a 00                	push   $0x0
  pushl $228
  1028f5:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1028fa:	e9 44 01 00 00       	jmp    102a43 <__alltraps>

001028ff <vector229>:
.globl vector229
vector229:
  pushl $0
  1028ff:	6a 00                	push   $0x0
  pushl $229
  102901:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102906:	e9 38 01 00 00       	jmp    102a43 <__alltraps>

0010290b <vector230>:
.globl vector230
vector230:
  pushl $0
  10290b:	6a 00                	push   $0x0
  pushl $230
  10290d:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102912:	e9 2c 01 00 00       	jmp    102a43 <__alltraps>

00102917 <vector231>:
.globl vector231
vector231:
  pushl $0
  102917:	6a 00                	push   $0x0
  pushl $231
  102919:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10291e:	e9 20 01 00 00       	jmp    102a43 <__alltraps>

00102923 <vector232>:
.globl vector232
vector232:
  pushl $0
  102923:	6a 00                	push   $0x0
  pushl $232
  102925:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10292a:	e9 14 01 00 00       	jmp    102a43 <__alltraps>

0010292f <vector233>:
.globl vector233
vector233:
  pushl $0
  10292f:	6a 00                	push   $0x0
  pushl $233
  102931:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102936:	e9 08 01 00 00       	jmp    102a43 <__alltraps>

0010293b <vector234>:
.globl vector234
vector234:
  pushl $0
  10293b:	6a 00                	push   $0x0
  pushl $234
  10293d:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102942:	e9 fc 00 00 00       	jmp    102a43 <__alltraps>

00102947 <vector235>:
.globl vector235
vector235:
  pushl $0
  102947:	6a 00                	push   $0x0
  pushl $235
  102949:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10294e:	e9 f0 00 00 00       	jmp    102a43 <__alltraps>

00102953 <vector236>:
.globl vector236
vector236:
  pushl $0
  102953:	6a 00                	push   $0x0
  pushl $236
  102955:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10295a:	e9 e4 00 00 00       	jmp    102a43 <__alltraps>

0010295f <vector237>:
.globl vector237
vector237:
  pushl $0
  10295f:	6a 00                	push   $0x0
  pushl $237
  102961:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102966:	e9 d8 00 00 00       	jmp    102a43 <__alltraps>

0010296b <vector238>:
.globl vector238
vector238:
  pushl $0
  10296b:	6a 00                	push   $0x0
  pushl $238
  10296d:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102972:	e9 cc 00 00 00       	jmp    102a43 <__alltraps>

00102977 <vector239>:
.globl vector239
vector239:
  pushl $0
  102977:	6a 00                	push   $0x0
  pushl $239
  102979:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10297e:	e9 c0 00 00 00       	jmp    102a43 <__alltraps>

00102983 <vector240>:
.globl vector240
vector240:
  pushl $0
  102983:	6a 00                	push   $0x0
  pushl $240
  102985:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10298a:	e9 b4 00 00 00       	jmp    102a43 <__alltraps>

0010298f <vector241>:
.globl vector241
vector241:
  pushl $0
  10298f:	6a 00                	push   $0x0
  pushl $241
  102991:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102996:	e9 a8 00 00 00       	jmp    102a43 <__alltraps>

0010299b <vector242>:
.globl vector242
vector242:
  pushl $0
  10299b:	6a 00                	push   $0x0
  pushl $242
  10299d:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1029a2:	e9 9c 00 00 00       	jmp    102a43 <__alltraps>

001029a7 <vector243>:
.globl vector243
vector243:
  pushl $0
  1029a7:	6a 00                	push   $0x0
  pushl $243
  1029a9:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1029ae:	e9 90 00 00 00       	jmp    102a43 <__alltraps>

001029b3 <vector244>:
.globl vector244
vector244:
  pushl $0
  1029b3:	6a 00                	push   $0x0
  pushl $244
  1029b5:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1029ba:	e9 84 00 00 00       	jmp    102a43 <__alltraps>

001029bf <vector245>:
.globl vector245
vector245:
  pushl $0
  1029bf:	6a 00                	push   $0x0
  pushl $245
  1029c1:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1029c6:	e9 78 00 00 00       	jmp    102a43 <__alltraps>

001029cb <vector246>:
.globl vector246
vector246:
  pushl $0
  1029cb:	6a 00                	push   $0x0
  pushl $246
  1029cd:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1029d2:	e9 6c 00 00 00       	jmp    102a43 <__alltraps>

001029d7 <vector247>:
.globl vector247
vector247:
  pushl $0
  1029d7:	6a 00                	push   $0x0
  pushl $247
  1029d9:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1029de:	e9 60 00 00 00       	jmp    102a43 <__alltraps>

001029e3 <vector248>:
.globl vector248
vector248:
  pushl $0
  1029e3:	6a 00                	push   $0x0
  pushl $248
  1029e5:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1029ea:	e9 54 00 00 00       	jmp    102a43 <__alltraps>

001029ef <vector249>:
.globl vector249
vector249:
  pushl $0
  1029ef:	6a 00                	push   $0x0
  pushl $249
  1029f1:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1029f6:	e9 48 00 00 00       	jmp    102a43 <__alltraps>

001029fb <vector250>:
.globl vector250
vector250:
  pushl $0
  1029fb:	6a 00                	push   $0x0
  pushl $250
  1029fd:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a02:	e9 3c 00 00 00       	jmp    102a43 <__alltraps>

00102a07 <vector251>:
.globl vector251
vector251:
  pushl $0
  102a07:	6a 00                	push   $0x0
  pushl $251
  102a09:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102a0e:	e9 30 00 00 00       	jmp    102a43 <__alltraps>

00102a13 <vector252>:
.globl vector252
vector252:
  pushl $0
  102a13:	6a 00                	push   $0x0
  pushl $252
  102a15:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a1a:	e9 24 00 00 00       	jmp    102a43 <__alltraps>

00102a1f <vector253>:
.globl vector253
vector253:
  pushl $0
  102a1f:	6a 00                	push   $0x0
  pushl $253
  102a21:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102a26:	e9 18 00 00 00       	jmp    102a43 <__alltraps>

00102a2b <vector254>:
.globl vector254
vector254:
  pushl $0
  102a2b:	6a 00                	push   $0x0
  pushl $254
  102a2d:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a32:	e9 0c 00 00 00       	jmp    102a43 <__alltraps>

00102a37 <vector255>:
.globl vector255
vector255:
  pushl $0
  102a37:	6a 00                	push   $0x0
  pushl $255
  102a39:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a3e:	e9 00 00 00 00       	jmp    102a43 <__alltraps>

00102a43 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102a43:	1e                   	push   %ds
    pushl %es
  102a44:	06                   	push   %es
    pushl %fs
  102a45:	0f a0                	push   %fs
    pushl %gs
  102a47:	0f a8                	push   %gs
    pushal
  102a49:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102a4a:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102a4f:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102a51:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102a53:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102a54:	e8 61 f5 ff ff       	call   101fba <trap>

    # pop the pushed stack pointer
    popl %esp
  102a59:	5c                   	pop    %esp

00102a5a <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102a5a:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102a5b:	0f a9                	pop    %gs
    popl %fs
  102a5d:	0f a1                	pop    %fs
    popl %es
  102a5f:	07                   	pop    %es
    popl %ds
  102a60:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102a61:	83 c4 08             	add    $0x8,%esp
    iret
  102a64:	cf                   	iret   

00102a65 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102a65:	55                   	push   %ebp
  102a66:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102a68:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6b:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102a6e:	b8 23 00 00 00       	mov    $0x23,%eax
  102a73:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102a75:	b8 23 00 00 00       	mov    $0x23,%eax
  102a7a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102a7c:	b8 10 00 00 00       	mov    $0x10,%eax
  102a81:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102a83:	b8 10 00 00 00       	mov    $0x10,%eax
  102a88:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102a8a:	b8 10 00 00 00       	mov    $0x10,%eax
  102a8f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102a91:	ea 98 2a 10 00 08 00 	ljmp   $0x8,$0x102a98
}
  102a98:	90                   	nop
  102a99:	5d                   	pop    %ebp
  102a9a:	c3                   	ret    

00102a9b <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a9b:	55                   	push   %ebp
  102a9c:	89 e5                	mov    %esp,%ebp
  102a9e:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102aa1:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  102aa6:	05 00 04 00 00       	add    $0x400,%eax
  102aab:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102ab0:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102ab7:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102ab9:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102ac0:	68 00 
  102ac2:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102ac7:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102acd:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102ad2:	c1 e8 10             	shr    $0x10,%eax
  102ad5:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102ada:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102ae1:	83 e0 f0             	and    $0xfffffff0,%eax
  102ae4:	83 c8 09             	or     $0x9,%eax
  102ae7:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102aec:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102af3:	83 c8 10             	or     $0x10,%eax
  102af6:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102afb:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102b02:	83 e0 9f             	and    $0xffffff9f,%eax
  102b05:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102b0a:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102b11:	83 c8 80             	or     $0xffffff80,%eax
  102b14:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102b19:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102b20:	83 e0 f0             	and    $0xfffffff0,%eax
  102b23:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102b28:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102b2f:	83 e0 ef             	and    $0xffffffef,%eax
  102b32:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102b37:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102b3e:	83 e0 df             	and    $0xffffffdf,%eax
  102b41:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102b46:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102b4d:	83 c8 40             	or     $0x40,%eax
  102b50:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102b55:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102b5c:	83 e0 7f             	and    $0x7f,%eax
  102b5f:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102b64:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102b69:	c1 e8 18             	shr    $0x18,%eax
  102b6c:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102b71:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102b78:	83 e0 ef             	and    $0xffffffef,%eax
  102b7b:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102b80:	68 10 ea 10 00       	push   $0x10ea10
  102b85:	e8 db fe ff ff       	call   102a65 <lgdt>
  102b8a:	83 c4 04             	add    $0x4,%esp
  102b8d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102b93:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102b97:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102b9a:	90                   	nop
  102b9b:	c9                   	leave  
  102b9c:	c3                   	ret    

00102b9d <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102b9d:	55                   	push   %ebp
  102b9e:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102ba0:	e8 f6 fe ff ff       	call   102a9b <gdt_init>
}
  102ba5:	90                   	nop
  102ba6:	5d                   	pop    %ebp
  102ba7:	c3                   	ret    

00102ba8 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102ba8:	55                   	push   %ebp
  102ba9:	89 e5                	mov    %esp,%ebp
  102bab:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102bae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102bb5:	eb 04                	jmp    102bbb <strlen+0x13>
        cnt ++;
  102bb7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  102bbe:	8d 50 01             	lea    0x1(%eax),%edx
  102bc1:	89 55 08             	mov    %edx,0x8(%ebp)
  102bc4:	0f b6 00             	movzbl (%eax),%eax
  102bc7:	84 c0                	test   %al,%al
  102bc9:	75 ec                	jne    102bb7 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102bce:	c9                   	leave  
  102bcf:	c3                   	ret    

00102bd0 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102bd0:	55                   	push   %ebp
  102bd1:	89 e5                	mov    %esp,%ebp
  102bd3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102bd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102bdd:	eb 04                	jmp    102be3 <strnlen+0x13>
        cnt ++;
  102bdf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102be6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102be9:	73 10                	jae    102bfb <strnlen+0x2b>
  102beb:	8b 45 08             	mov    0x8(%ebp),%eax
  102bee:	8d 50 01             	lea    0x1(%eax),%edx
  102bf1:	89 55 08             	mov    %edx,0x8(%ebp)
  102bf4:	0f b6 00             	movzbl (%eax),%eax
  102bf7:	84 c0                	test   %al,%al
  102bf9:	75 e4                	jne    102bdf <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102bfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102bfe:	c9                   	leave  
  102bff:	c3                   	ret    

00102c00 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102c00:	55                   	push   %ebp
  102c01:	89 e5                	mov    %esp,%ebp
  102c03:	57                   	push   %edi
  102c04:	56                   	push   %esi
  102c05:	83 ec 20             	sub    $0x20,%esp
  102c08:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c11:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102c14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c1a:	89 d1                	mov    %edx,%ecx
  102c1c:	89 c2                	mov    %eax,%edx
  102c1e:	89 ce                	mov    %ecx,%esi
  102c20:	89 d7                	mov    %edx,%edi
  102c22:	ac                   	lods   %ds:(%esi),%al
  102c23:	aa                   	stos   %al,%es:(%edi)
  102c24:	84 c0                	test   %al,%al
  102c26:	75 fa                	jne    102c22 <strcpy+0x22>
  102c28:	89 fa                	mov    %edi,%edx
  102c2a:	89 f1                	mov    %esi,%ecx
  102c2c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102c2f:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102c32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102c38:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102c39:	83 c4 20             	add    $0x20,%esp
  102c3c:	5e                   	pop    %esi
  102c3d:	5f                   	pop    %edi
  102c3e:	5d                   	pop    %ebp
  102c3f:	c3                   	ret    

00102c40 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102c40:	55                   	push   %ebp
  102c41:	89 e5                	mov    %esp,%ebp
  102c43:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102c46:	8b 45 08             	mov    0x8(%ebp),%eax
  102c49:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102c4c:	eb 21                	jmp    102c6f <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c51:	0f b6 10             	movzbl (%eax),%edx
  102c54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c57:	88 10                	mov    %dl,(%eax)
  102c59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c5c:	0f b6 00             	movzbl (%eax),%eax
  102c5f:	84 c0                	test   %al,%al
  102c61:	74 04                	je     102c67 <strncpy+0x27>
            src ++;
  102c63:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102c67:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102c6b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  102c6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c73:	75 d9                	jne    102c4e <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  102c75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102c78:	c9                   	leave  
  102c79:	c3                   	ret    

00102c7a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102c7a:	55                   	push   %ebp
  102c7b:	89 e5                	mov    %esp,%ebp
  102c7d:	57                   	push   %edi
  102c7e:	56                   	push   %esi
  102c7f:	83 ec 20             	sub    $0x20,%esp
  102c82:	8b 45 08             	mov    0x8(%ebp),%eax
  102c85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102c8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c94:	89 d1                	mov    %edx,%ecx
  102c96:	89 c2                	mov    %eax,%edx
  102c98:	89 ce                	mov    %ecx,%esi
  102c9a:	89 d7                	mov    %edx,%edi
  102c9c:	ac                   	lods   %ds:(%esi),%al
  102c9d:	ae                   	scas   %es:(%edi),%al
  102c9e:	75 08                	jne    102ca8 <strcmp+0x2e>
  102ca0:	84 c0                	test   %al,%al
  102ca2:	75 f8                	jne    102c9c <strcmp+0x22>
  102ca4:	31 c0                	xor    %eax,%eax
  102ca6:	eb 04                	jmp    102cac <strcmp+0x32>
  102ca8:	19 c0                	sbb    %eax,%eax
  102caa:	0c 01                	or     $0x1,%al
  102cac:	89 fa                	mov    %edi,%edx
  102cae:	89 f1                	mov    %esi,%ecx
  102cb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102cb3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102cb6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  102cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102cbc:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102cbd:	83 c4 20             	add    $0x20,%esp
  102cc0:	5e                   	pop    %esi
  102cc1:	5f                   	pop    %edi
  102cc2:	5d                   	pop    %ebp
  102cc3:	c3                   	ret    

00102cc4 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102cc4:	55                   	push   %ebp
  102cc5:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102cc7:	eb 0c                	jmp    102cd5 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102cc9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ccd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102cd1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102cd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cd9:	74 1a                	je     102cf5 <strncmp+0x31>
  102cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  102cde:	0f b6 00             	movzbl (%eax),%eax
  102ce1:	84 c0                	test   %al,%al
  102ce3:	74 10                	je     102cf5 <strncmp+0x31>
  102ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce8:	0f b6 10             	movzbl (%eax),%edx
  102ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cee:	0f b6 00             	movzbl (%eax),%eax
  102cf1:	38 c2                	cmp    %al,%dl
  102cf3:	74 d4                	je     102cc9 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102cf5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cf9:	74 18                	je     102d13 <strncmp+0x4f>
  102cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfe:	0f b6 00             	movzbl (%eax),%eax
  102d01:	0f b6 d0             	movzbl %al,%edx
  102d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d07:	0f b6 00             	movzbl (%eax),%eax
  102d0a:	0f b6 c0             	movzbl %al,%eax
  102d0d:	29 c2                	sub    %eax,%edx
  102d0f:	89 d0                	mov    %edx,%eax
  102d11:	eb 05                	jmp    102d18 <strncmp+0x54>
  102d13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d18:	5d                   	pop    %ebp
  102d19:	c3                   	ret    

00102d1a <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102d1a:	55                   	push   %ebp
  102d1b:	89 e5                	mov    %esp,%ebp
  102d1d:	83 ec 04             	sub    $0x4,%esp
  102d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d23:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102d26:	eb 14                	jmp    102d3c <strchr+0x22>
        if (*s == c) {
  102d28:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2b:	0f b6 00             	movzbl (%eax),%eax
  102d2e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102d31:	75 05                	jne    102d38 <strchr+0x1e>
            return (char *)s;
  102d33:	8b 45 08             	mov    0x8(%ebp),%eax
  102d36:	eb 13                	jmp    102d4b <strchr+0x31>
        }
        s ++;
  102d38:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3f:	0f b6 00             	movzbl (%eax),%eax
  102d42:	84 c0                	test   %al,%al
  102d44:	75 e2                	jne    102d28 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102d46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d4b:	c9                   	leave  
  102d4c:	c3                   	ret    

00102d4d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102d4d:	55                   	push   %ebp
  102d4e:	89 e5                	mov    %esp,%ebp
  102d50:	83 ec 04             	sub    $0x4,%esp
  102d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d56:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102d59:	eb 0f                	jmp    102d6a <strfind+0x1d>
        if (*s == c) {
  102d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5e:	0f b6 00             	movzbl (%eax),%eax
  102d61:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102d64:	74 10                	je     102d76 <strfind+0x29>
            break;
        }
        s ++;
  102d66:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6d:	0f b6 00             	movzbl (%eax),%eax
  102d70:	84 c0                	test   %al,%al
  102d72:	75 e7                	jne    102d5b <strfind+0xe>
  102d74:	eb 01                	jmp    102d77 <strfind+0x2a>
        if (*s == c) {
            break;
  102d76:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  102d77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102d7a:	c9                   	leave  
  102d7b:	c3                   	ret    

00102d7c <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102d7c:	55                   	push   %ebp
  102d7d:	89 e5                	mov    %esp,%ebp
  102d7f:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102d82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102d89:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102d90:	eb 04                	jmp    102d96 <strtol+0x1a>
        s ++;
  102d92:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102d96:	8b 45 08             	mov    0x8(%ebp),%eax
  102d99:	0f b6 00             	movzbl (%eax),%eax
  102d9c:	3c 20                	cmp    $0x20,%al
  102d9e:	74 f2                	je     102d92 <strtol+0x16>
  102da0:	8b 45 08             	mov    0x8(%ebp),%eax
  102da3:	0f b6 00             	movzbl (%eax),%eax
  102da6:	3c 09                	cmp    $0x9,%al
  102da8:	74 e8                	je     102d92 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  102daa:	8b 45 08             	mov    0x8(%ebp),%eax
  102dad:	0f b6 00             	movzbl (%eax),%eax
  102db0:	3c 2b                	cmp    $0x2b,%al
  102db2:	75 06                	jne    102dba <strtol+0x3e>
        s ++;
  102db4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102db8:	eb 15                	jmp    102dcf <strtol+0x53>
    }
    else if (*s == '-') {
  102dba:	8b 45 08             	mov    0x8(%ebp),%eax
  102dbd:	0f b6 00             	movzbl (%eax),%eax
  102dc0:	3c 2d                	cmp    $0x2d,%al
  102dc2:	75 0b                	jne    102dcf <strtol+0x53>
        s ++, neg = 1;
  102dc4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102dc8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102dcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102dd3:	74 06                	je     102ddb <strtol+0x5f>
  102dd5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102dd9:	75 24                	jne    102dff <strtol+0x83>
  102ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dde:	0f b6 00             	movzbl (%eax),%eax
  102de1:	3c 30                	cmp    $0x30,%al
  102de3:	75 1a                	jne    102dff <strtol+0x83>
  102de5:	8b 45 08             	mov    0x8(%ebp),%eax
  102de8:	83 c0 01             	add    $0x1,%eax
  102deb:	0f b6 00             	movzbl (%eax),%eax
  102dee:	3c 78                	cmp    $0x78,%al
  102df0:	75 0d                	jne    102dff <strtol+0x83>
        s += 2, base = 16;
  102df2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102df6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102dfd:	eb 2a                	jmp    102e29 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102dff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e03:	75 17                	jne    102e1c <strtol+0xa0>
  102e05:	8b 45 08             	mov    0x8(%ebp),%eax
  102e08:	0f b6 00             	movzbl (%eax),%eax
  102e0b:	3c 30                	cmp    $0x30,%al
  102e0d:	75 0d                	jne    102e1c <strtol+0xa0>
        s ++, base = 8;
  102e0f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102e13:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102e1a:	eb 0d                	jmp    102e29 <strtol+0xad>
    }
    else if (base == 0) {
  102e1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e20:	75 07                	jne    102e29 <strtol+0xad>
        base = 10;
  102e22:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102e29:	8b 45 08             	mov    0x8(%ebp),%eax
  102e2c:	0f b6 00             	movzbl (%eax),%eax
  102e2f:	3c 2f                	cmp    $0x2f,%al
  102e31:	7e 1b                	jle    102e4e <strtol+0xd2>
  102e33:	8b 45 08             	mov    0x8(%ebp),%eax
  102e36:	0f b6 00             	movzbl (%eax),%eax
  102e39:	3c 39                	cmp    $0x39,%al
  102e3b:	7f 11                	jg     102e4e <strtol+0xd2>
            dig = *s - '0';
  102e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e40:	0f b6 00             	movzbl (%eax),%eax
  102e43:	0f be c0             	movsbl %al,%eax
  102e46:	83 e8 30             	sub    $0x30,%eax
  102e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e4c:	eb 48                	jmp    102e96 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e51:	0f b6 00             	movzbl (%eax),%eax
  102e54:	3c 60                	cmp    $0x60,%al
  102e56:	7e 1b                	jle    102e73 <strtol+0xf7>
  102e58:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5b:	0f b6 00             	movzbl (%eax),%eax
  102e5e:	3c 7a                	cmp    $0x7a,%al
  102e60:	7f 11                	jg     102e73 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102e62:	8b 45 08             	mov    0x8(%ebp),%eax
  102e65:	0f b6 00             	movzbl (%eax),%eax
  102e68:	0f be c0             	movsbl %al,%eax
  102e6b:	83 e8 57             	sub    $0x57,%eax
  102e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e71:	eb 23                	jmp    102e96 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102e73:	8b 45 08             	mov    0x8(%ebp),%eax
  102e76:	0f b6 00             	movzbl (%eax),%eax
  102e79:	3c 40                	cmp    $0x40,%al
  102e7b:	7e 3c                	jle    102eb9 <strtol+0x13d>
  102e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e80:	0f b6 00             	movzbl (%eax),%eax
  102e83:	3c 5a                	cmp    $0x5a,%al
  102e85:	7f 32                	jg     102eb9 <strtol+0x13d>
            dig = *s - 'A' + 10;
  102e87:	8b 45 08             	mov    0x8(%ebp),%eax
  102e8a:	0f b6 00             	movzbl (%eax),%eax
  102e8d:	0f be c0             	movsbl %al,%eax
  102e90:	83 e8 37             	sub    $0x37,%eax
  102e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e99:	3b 45 10             	cmp    0x10(%ebp),%eax
  102e9c:	7d 1a                	jge    102eb8 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102e9e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ea2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ea5:	0f af 45 10          	imul   0x10(%ebp),%eax
  102ea9:	89 c2                	mov    %eax,%edx
  102eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102eae:	01 d0                	add    %edx,%eax
  102eb0:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102eb3:	e9 71 ff ff ff       	jmp    102e29 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  102eb8:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  102eb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ebd:	74 08                	je     102ec7 <strtol+0x14b>
        *endptr = (char *) s;
  102ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ec2:	8b 55 08             	mov    0x8(%ebp),%edx
  102ec5:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102ec7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102ecb:	74 07                	je     102ed4 <strtol+0x158>
  102ecd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ed0:	f7 d8                	neg    %eax
  102ed2:	eb 03                	jmp    102ed7 <strtol+0x15b>
  102ed4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102ed7:	c9                   	leave  
  102ed8:	c3                   	ret    

00102ed9 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102ed9:	55                   	push   %ebp
  102eda:	89 e5                	mov    %esp,%ebp
  102edc:	57                   	push   %edi
  102edd:	83 ec 24             	sub    $0x24,%esp
  102ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee3:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102ee6:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102eea:	8b 55 08             	mov    0x8(%ebp),%edx
  102eed:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102ef0:	88 45 f7             	mov    %al,-0x9(%ebp)
  102ef3:	8b 45 10             	mov    0x10(%ebp),%eax
  102ef6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102ef9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102efc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102f00:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102f03:	89 d7                	mov    %edx,%edi
  102f05:	f3 aa                	rep stos %al,%es:(%edi)
  102f07:	89 fa                	mov    %edi,%edx
  102f09:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102f0c:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102f0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f12:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102f13:	83 c4 24             	add    $0x24,%esp
  102f16:	5f                   	pop    %edi
  102f17:	5d                   	pop    %ebp
  102f18:	c3                   	ret    

00102f19 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102f19:	55                   	push   %ebp
  102f1a:	89 e5                	mov    %esp,%ebp
  102f1c:	57                   	push   %edi
  102f1d:	56                   	push   %esi
  102f1e:	53                   	push   %ebx
  102f1f:	83 ec 30             	sub    $0x30,%esp
  102f22:	8b 45 08             	mov    0x8(%ebp),%eax
  102f25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  102f31:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f37:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102f3a:	73 42                	jae    102f7e <memmove+0x65>
  102f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f45:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f4b:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102f4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f51:	c1 e8 02             	shr    $0x2,%eax
  102f54:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102f56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f5c:	89 d7                	mov    %edx,%edi
  102f5e:	89 c6                	mov    %eax,%esi
  102f60:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102f62:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102f65:	83 e1 03             	and    $0x3,%ecx
  102f68:	74 02                	je     102f6c <memmove+0x53>
  102f6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102f6c:	89 f0                	mov    %esi,%eax
  102f6e:	89 fa                	mov    %edi,%edx
  102f70:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102f73:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102f76:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102f7c:	eb 36                	jmp    102fb4 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102f7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f81:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f87:	01 c2                	add    %eax,%edx
  102f89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f8c:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f92:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  102f95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f98:	89 c1                	mov    %eax,%ecx
  102f9a:	89 d8                	mov    %ebx,%eax
  102f9c:	89 d6                	mov    %edx,%esi
  102f9e:	89 c7                	mov    %eax,%edi
  102fa0:	fd                   	std    
  102fa1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102fa3:	fc                   	cld    
  102fa4:	89 f8                	mov    %edi,%eax
  102fa6:	89 f2                	mov    %esi,%edx
  102fa8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102fab:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102fae:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  102fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102fb4:	83 c4 30             	add    $0x30,%esp
  102fb7:	5b                   	pop    %ebx
  102fb8:	5e                   	pop    %esi
  102fb9:	5f                   	pop    %edi
  102fba:	5d                   	pop    %ebp
  102fbb:	c3                   	ret    

00102fbc <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102fbc:	55                   	push   %ebp
  102fbd:	89 e5                	mov    %esp,%ebp
  102fbf:	57                   	push   %edi
  102fc0:	56                   	push   %esi
  102fc1:	83 ec 20             	sub    $0x20,%esp
  102fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  102fd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102fd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fd9:	c1 e8 02             	shr    $0x2,%eax
  102fdc:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fe4:	89 d7                	mov    %edx,%edi
  102fe6:	89 c6                	mov    %eax,%esi
  102fe8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102fea:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102fed:	83 e1 03             	and    $0x3,%ecx
  102ff0:	74 02                	je     102ff4 <memcpy+0x38>
  102ff2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ff4:	89 f0                	mov    %esi,%eax
  102ff6:	89 fa                	mov    %edi,%edx
  102ff8:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102ffb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102ffe:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103001:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  103004:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103005:	83 c4 20             	add    $0x20,%esp
  103008:	5e                   	pop    %esi
  103009:	5f                   	pop    %edi
  10300a:	5d                   	pop    %ebp
  10300b:	c3                   	ret    

0010300c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10300c:	55                   	push   %ebp
  10300d:	89 e5                	mov    %esp,%ebp
  10300f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103012:	8b 45 08             	mov    0x8(%ebp),%eax
  103015:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103018:	8b 45 0c             	mov    0xc(%ebp),%eax
  10301b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10301e:	eb 30                	jmp    103050 <memcmp+0x44>
        if (*s1 != *s2) {
  103020:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103023:	0f b6 10             	movzbl (%eax),%edx
  103026:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103029:	0f b6 00             	movzbl (%eax),%eax
  10302c:	38 c2                	cmp    %al,%dl
  10302e:	74 18                	je     103048 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103030:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103033:	0f b6 00             	movzbl (%eax),%eax
  103036:	0f b6 d0             	movzbl %al,%edx
  103039:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10303c:	0f b6 00             	movzbl (%eax),%eax
  10303f:	0f b6 c0             	movzbl %al,%eax
  103042:	29 c2                	sub    %eax,%edx
  103044:	89 d0                	mov    %edx,%eax
  103046:	eb 1a                	jmp    103062 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103048:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10304c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  103050:	8b 45 10             	mov    0x10(%ebp),%eax
  103053:	8d 50 ff             	lea    -0x1(%eax),%edx
  103056:	89 55 10             	mov    %edx,0x10(%ebp)
  103059:	85 c0                	test   %eax,%eax
  10305b:	75 c3                	jne    103020 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10305d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103062:	c9                   	leave  
  103063:	c3                   	ret    

00103064 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  103064:	55                   	push   %ebp
  103065:	89 e5                	mov    %esp,%ebp
  103067:	83 ec 38             	sub    $0x38,%esp
  10306a:	8b 45 10             	mov    0x10(%ebp),%eax
  10306d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103070:	8b 45 14             	mov    0x14(%ebp),%eax
  103073:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  103076:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103079:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10307c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10307f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  103082:	8b 45 18             	mov    0x18(%ebp),%eax
  103085:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103088:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10308b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10308e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103091:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103097:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10309a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10309e:	74 1c                	je     1030bc <printnum+0x58>
  1030a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030a3:	ba 00 00 00 00       	mov    $0x0,%edx
  1030a8:	f7 75 e4             	divl   -0x1c(%ebp)
  1030ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1030ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030b1:	ba 00 00 00 00       	mov    $0x0,%edx
  1030b6:	f7 75 e4             	divl   -0x1c(%ebp)
  1030b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030c2:	f7 75 e4             	divl   -0x1c(%ebp)
  1030c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1030c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1030cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1030d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030d4:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1030d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1030da:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1030dd:	8b 45 18             	mov    0x18(%ebp),%eax
  1030e0:	ba 00 00 00 00       	mov    $0x0,%edx
  1030e5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1030e8:	77 41                	ja     10312b <printnum+0xc7>
  1030ea:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1030ed:	72 05                	jb     1030f4 <printnum+0x90>
  1030ef:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1030f2:	77 37                	ja     10312b <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  1030f4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1030f7:	83 e8 01             	sub    $0x1,%eax
  1030fa:	83 ec 04             	sub    $0x4,%esp
  1030fd:	ff 75 20             	pushl  0x20(%ebp)
  103100:	50                   	push   %eax
  103101:	ff 75 18             	pushl  0x18(%ebp)
  103104:	ff 75 ec             	pushl  -0x14(%ebp)
  103107:	ff 75 e8             	pushl  -0x18(%ebp)
  10310a:	ff 75 0c             	pushl  0xc(%ebp)
  10310d:	ff 75 08             	pushl  0x8(%ebp)
  103110:	e8 4f ff ff ff       	call   103064 <printnum>
  103115:	83 c4 20             	add    $0x20,%esp
  103118:	eb 1b                	jmp    103135 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10311a:	83 ec 08             	sub    $0x8,%esp
  10311d:	ff 75 0c             	pushl  0xc(%ebp)
  103120:	ff 75 20             	pushl  0x20(%ebp)
  103123:	8b 45 08             	mov    0x8(%ebp),%eax
  103126:	ff d0                	call   *%eax
  103128:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  10312b:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10312f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103133:	7f e5                	jg     10311a <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103135:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103138:	05 90 3e 10 00       	add    $0x103e90,%eax
  10313d:	0f b6 00             	movzbl (%eax),%eax
  103140:	0f be c0             	movsbl %al,%eax
  103143:	83 ec 08             	sub    $0x8,%esp
  103146:	ff 75 0c             	pushl  0xc(%ebp)
  103149:	50                   	push   %eax
  10314a:	8b 45 08             	mov    0x8(%ebp),%eax
  10314d:	ff d0                	call   *%eax
  10314f:	83 c4 10             	add    $0x10,%esp
}
  103152:	90                   	nop
  103153:	c9                   	leave  
  103154:	c3                   	ret    

00103155 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103155:	55                   	push   %ebp
  103156:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103158:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10315c:	7e 14                	jle    103172 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10315e:	8b 45 08             	mov    0x8(%ebp),%eax
  103161:	8b 00                	mov    (%eax),%eax
  103163:	8d 48 08             	lea    0x8(%eax),%ecx
  103166:	8b 55 08             	mov    0x8(%ebp),%edx
  103169:	89 0a                	mov    %ecx,(%edx)
  10316b:	8b 50 04             	mov    0x4(%eax),%edx
  10316e:	8b 00                	mov    (%eax),%eax
  103170:	eb 30                	jmp    1031a2 <getuint+0x4d>
    }
    else if (lflag) {
  103172:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103176:	74 16                	je     10318e <getuint+0x39>
        return va_arg(*ap, unsigned long);
  103178:	8b 45 08             	mov    0x8(%ebp),%eax
  10317b:	8b 00                	mov    (%eax),%eax
  10317d:	8d 48 04             	lea    0x4(%eax),%ecx
  103180:	8b 55 08             	mov    0x8(%ebp),%edx
  103183:	89 0a                	mov    %ecx,(%edx)
  103185:	8b 00                	mov    (%eax),%eax
  103187:	ba 00 00 00 00       	mov    $0x0,%edx
  10318c:	eb 14                	jmp    1031a2 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10318e:	8b 45 08             	mov    0x8(%ebp),%eax
  103191:	8b 00                	mov    (%eax),%eax
  103193:	8d 48 04             	lea    0x4(%eax),%ecx
  103196:	8b 55 08             	mov    0x8(%ebp),%edx
  103199:	89 0a                	mov    %ecx,(%edx)
  10319b:	8b 00                	mov    (%eax),%eax
  10319d:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1031a2:	5d                   	pop    %ebp
  1031a3:	c3                   	ret    

001031a4 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1031a4:	55                   	push   %ebp
  1031a5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1031a7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1031ab:	7e 14                	jle    1031c1 <getint+0x1d>
        return va_arg(*ap, long long);
  1031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b0:	8b 00                	mov    (%eax),%eax
  1031b2:	8d 48 08             	lea    0x8(%eax),%ecx
  1031b5:	8b 55 08             	mov    0x8(%ebp),%edx
  1031b8:	89 0a                	mov    %ecx,(%edx)
  1031ba:	8b 50 04             	mov    0x4(%eax),%edx
  1031bd:	8b 00                	mov    (%eax),%eax
  1031bf:	eb 28                	jmp    1031e9 <getint+0x45>
    }
    else if (lflag) {
  1031c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1031c5:	74 12                	je     1031d9 <getint+0x35>
        return va_arg(*ap, long);
  1031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ca:	8b 00                	mov    (%eax),%eax
  1031cc:	8d 48 04             	lea    0x4(%eax),%ecx
  1031cf:	8b 55 08             	mov    0x8(%ebp),%edx
  1031d2:	89 0a                	mov    %ecx,(%edx)
  1031d4:	8b 00                	mov    (%eax),%eax
  1031d6:	99                   	cltd   
  1031d7:	eb 10                	jmp    1031e9 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031dc:	8b 00                	mov    (%eax),%eax
  1031de:	8d 48 04             	lea    0x4(%eax),%ecx
  1031e1:	8b 55 08             	mov    0x8(%ebp),%edx
  1031e4:	89 0a                	mov    %ecx,(%edx)
  1031e6:	8b 00                	mov    (%eax),%eax
  1031e8:	99                   	cltd   
    }
}
  1031e9:	5d                   	pop    %ebp
  1031ea:	c3                   	ret    

001031eb <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1031eb:	55                   	push   %ebp
  1031ec:	89 e5                	mov    %esp,%ebp
  1031ee:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  1031f1:	8d 45 14             	lea    0x14(%ebp),%eax
  1031f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1031f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031fa:	50                   	push   %eax
  1031fb:	ff 75 10             	pushl  0x10(%ebp)
  1031fe:	ff 75 0c             	pushl  0xc(%ebp)
  103201:	ff 75 08             	pushl  0x8(%ebp)
  103204:	e8 06 00 00 00       	call   10320f <vprintfmt>
  103209:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10320c:	90                   	nop
  10320d:	c9                   	leave  
  10320e:	c3                   	ret    

0010320f <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10320f:	55                   	push   %ebp
  103210:	89 e5                	mov    %esp,%ebp
  103212:	56                   	push   %esi
  103213:	53                   	push   %ebx
  103214:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103217:	eb 17                	jmp    103230 <vprintfmt+0x21>
            if (ch == '\0') {
  103219:	85 db                	test   %ebx,%ebx
  10321b:	0f 84 8e 03 00 00    	je     1035af <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  103221:	83 ec 08             	sub    $0x8,%esp
  103224:	ff 75 0c             	pushl  0xc(%ebp)
  103227:	53                   	push   %ebx
  103228:	8b 45 08             	mov    0x8(%ebp),%eax
  10322b:	ff d0                	call   *%eax
  10322d:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103230:	8b 45 10             	mov    0x10(%ebp),%eax
  103233:	8d 50 01             	lea    0x1(%eax),%edx
  103236:	89 55 10             	mov    %edx,0x10(%ebp)
  103239:	0f b6 00             	movzbl (%eax),%eax
  10323c:	0f b6 d8             	movzbl %al,%ebx
  10323f:	83 fb 25             	cmp    $0x25,%ebx
  103242:	75 d5                	jne    103219 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  103244:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103248:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10324f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103252:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103255:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10325c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10325f:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103262:	8b 45 10             	mov    0x10(%ebp),%eax
  103265:	8d 50 01             	lea    0x1(%eax),%edx
  103268:	89 55 10             	mov    %edx,0x10(%ebp)
  10326b:	0f b6 00             	movzbl (%eax),%eax
  10326e:	0f b6 d8             	movzbl %al,%ebx
  103271:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103274:	83 f8 55             	cmp    $0x55,%eax
  103277:	0f 87 05 03 00 00    	ja     103582 <vprintfmt+0x373>
  10327d:	8b 04 85 b4 3e 10 00 	mov    0x103eb4(,%eax,4),%eax
  103284:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103286:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10328a:	eb d6                	jmp    103262 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10328c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  103290:	eb d0                	jmp    103262 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103292:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103299:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10329c:	89 d0                	mov    %edx,%eax
  10329e:	c1 e0 02             	shl    $0x2,%eax
  1032a1:	01 d0                	add    %edx,%eax
  1032a3:	01 c0                	add    %eax,%eax
  1032a5:	01 d8                	add    %ebx,%eax
  1032a7:	83 e8 30             	sub    $0x30,%eax
  1032aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1032ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1032b0:	0f b6 00             	movzbl (%eax),%eax
  1032b3:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1032b6:	83 fb 2f             	cmp    $0x2f,%ebx
  1032b9:	7e 39                	jle    1032f4 <vprintfmt+0xe5>
  1032bb:	83 fb 39             	cmp    $0x39,%ebx
  1032be:	7f 34                	jg     1032f4 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1032c0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1032c4:	eb d3                	jmp    103299 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1032c6:	8b 45 14             	mov    0x14(%ebp),%eax
  1032c9:	8d 50 04             	lea    0x4(%eax),%edx
  1032cc:	89 55 14             	mov    %edx,0x14(%ebp)
  1032cf:	8b 00                	mov    (%eax),%eax
  1032d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1032d4:	eb 1f                	jmp    1032f5 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  1032d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032da:	79 86                	jns    103262 <vprintfmt+0x53>
                width = 0;
  1032dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1032e3:	e9 7a ff ff ff       	jmp    103262 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1032e8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1032ef:	e9 6e ff ff ff       	jmp    103262 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  1032f4:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  1032f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032f9:	0f 89 63 ff ff ff    	jns    103262 <vprintfmt+0x53>
                width = precision, precision = -1;
  1032ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103302:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103305:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10330c:	e9 51 ff ff ff       	jmp    103262 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  103311:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  103315:	e9 48 ff ff ff       	jmp    103262 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10331a:	8b 45 14             	mov    0x14(%ebp),%eax
  10331d:	8d 50 04             	lea    0x4(%eax),%edx
  103320:	89 55 14             	mov    %edx,0x14(%ebp)
  103323:	8b 00                	mov    (%eax),%eax
  103325:	83 ec 08             	sub    $0x8,%esp
  103328:	ff 75 0c             	pushl  0xc(%ebp)
  10332b:	50                   	push   %eax
  10332c:	8b 45 08             	mov    0x8(%ebp),%eax
  10332f:	ff d0                	call   *%eax
  103331:	83 c4 10             	add    $0x10,%esp
            break;
  103334:	e9 71 02 00 00       	jmp    1035aa <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103339:	8b 45 14             	mov    0x14(%ebp),%eax
  10333c:	8d 50 04             	lea    0x4(%eax),%edx
  10333f:	89 55 14             	mov    %edx,0x14(%ebp)
  103342:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103344:	85 db                	test   %ebx,%ebx
  103346:	79 02                	jns    10334a <vprintfmt+0x13b>
                err = -err;
  103348:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10334a:	83 fb 06             	cmp    $0x6,%ebx
  10334d:	7f 0b                	jg     10335a <vprintfmt+0x14b>
  10334f:	8b 34 9d 74 3e 10 00 	mov    0x103e74(,%ebx,4),%esi
  103356:	85 f6                	test   %esi,%esi
  103358:	75 19                	jne    103373 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  10335a:	53                   	push   %ebx
  10335b:	68 a1 3e 10 00       	push   $0x103ea1
  103360:	ff 75 0c             	pushl  0xc(%ebp)
  103363:	ff 75 08             	pushl  0x8(%ebp)
  103366:	e8 80 fe ff ff       	call   1031eb <printfmt>
  10336b:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10336e:	e9 37 02 00 00       	jmp    1035aa <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  103373:	56                   	push   %esi
  103374:	68 aa 3e 10 00       	push   $0x103eaa
  103379:	ff 75 0c             	pushl  0xc(%ebp)
  10337c:	ff 75 08             	pushl  0x8(%ebp)
  10337f:	e8 67 fe ff ff       	call   1031eb <printfmt>
  103384:	83 c4 10             	add    $0x10,%esp
            }
            break;
  103387:	e9 1e 02 00 00       	jmp    1035aa <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10338c:	8b 45 14             	mov    0x14(%ebp),%eax
  10338f:	8d 50 04             	lea    0x4(%eax),%edx
  103392:	89 55 14             	mov    %edx,0x14(%ebp)
  103395:	8b 30                	mov    (%eax),%esi
  103397:	85 f6                	test   %esi,%esi
  103399:	75 05                	jne    1033a0 <vprintfmt+0x191>
                p = "(null)";
  10339b:	be ad 3e 10 00       	mov    $0x103ead,%esi
            }
            if (width > 0 && padc != '-') {
  1033a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033a4:	7e 76                	jle    10341c <vprintfmt+0x20d>
  1033a6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1033aa:	74 70                	je     10341c <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1033ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033af:	83 ec 08             	sub    $0x8,%esp
  1033b2:	50                   	push   %eax
  1033b3:	56                   	push   %esi
  1033b4:	e8 17 f8 ff ff       	call   102bd0 <strnlen>
  1033b9:	83 c4 10             	add    $0x10,%esp
  1033bc:	89 c2                	mov    %eax,%edx
  1033be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033c1:	29 d0                	sub    %edx,%eax
  1033c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033c6:	eb 17                	jmp    1033df <vprintfmt+0x1d0>
                    putch(padc, putdat);
  1033c8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1033cc:	83 ec 08             	sub    $0x8,%esp
  1033cf:	ff 75 0c             	pushl  0xc(%ebp)
  1033d2:	50                   	push   %eax
  1033d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1033d6:	ff d0                	call   *%eax
  1033d8:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1033db:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1033df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033e3:	7f e3                	jg     1033c8 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1033e5:	eb 35                	jmp    10341c <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  1033e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1033eb:	74 1c                	je     103409 <vprintfmt+0x1fa>
  1033ed:	83 fb 1f             	cmp    $0x1f,%ebx
  1033f0:	7e 05                	jle    1033f7 <vprintfmt+0x1e8>
  1033f2:	83 fb 7e             	cmp    $0x7e,%ebx
  1033f5:	7e 12                	jle    103409 <vprintfmt+0x1fa>
                    putch('?', putdat);
  1033f7:	83 ec 08             	sub    $0x8,%esp
  1033fa:	ff 75 0c             	pushl  0xc(%ebp)
  1033fd:	6a 3f                	push   $0x3f
  1033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103402:	ff d0                	call   *%eax
  103404:	83 c4 10             	add    $0x10,%esp
  103407:	eb 0f                	jmp    103418 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  103409:	83 ec 08             	sub    $0x8,%esp
  10340c:	ff 75 0c             	pushl  0xc(%ebp)
  10340f:	53                   	push   %ebx
  103410:	8b 45 08             	mov    0x8(%ebp),%eax
  103413:	ff d0                	call   *%eax
  103415:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103418:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10341c:	89 f0                	mov    %esi,%eax
  10341e:	8d 70 01             	lea    0x1(%eax),%esi
  103421:	0f b6 00             	movzbl (%eax),%eax
  103424:	0f be d8             	movsbl %al,%ebx
  103427:	85 db                	test   %ebx,%ebx
  103429:	74 26                	je     103451 <vprintfmt+0x242>
  10342b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10342f:	78 b6                	js     1033e7 <vprintfmt+0x1d8>
  103431:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  103435:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103439:	79 ac                	jns    1033e7 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10343b:	eb 14                	jmp    103451 <vprintfmt+0x242>
                putch(' ', putdat);
  10343d:	83 ec 08             	sub    $0x8,%esp
  103440:	ff 75 0c             	pushl  0xc(%ebp)
  103443:	6a 20                	push   $0x20
  103445:	8b 45 08             	mov    0x8(%ebp),%eax
  103448:	ff d0                	call   *%eax
  10344a:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10344d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103451:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103455:	7f e6                	jg     10343d <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  103457:	e9 4e 01 00 00       	jmp    1035aa <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10345c:	83 ec 08             	sub    $0x8,%esp
  10345f:	ff 75 e0             	pushl  -0x20(%ebp)
  103462:	8d 45 14             	lea    0x14(%ebp),%eax
  103465:	50                   	push   %eax
  103466:	e8 39 fd ff ff       	call   1031a4 <getint>
  10346b:	83 c4 10             	add    $0x10,%esp
  10346e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103471:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103477:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10347a:	85 d2                	test   %edx,%edx
  10347c:	79 23                	jns    1034a1 <vprintfmt+0x292>
                putch('-', putdat);
  10347e:	83 ec 08             	sub    $0x8,%esp
  103481:	ff 75 0c             	pushl  0xc(%ebp)
  103484:	6a 2d                	push   $0x2d
  103486:	8b 45 08             	mov    0x8(%ebp),%eax
  103489:	ff d0                	call   *%eax
  10348b:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  10348e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103491:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103494:	f7 d8                	neg    %eax
  103496:	83 d2 00             	adc    $0x0,%edx
  103499:	f7 da                	neg    %edx
  10349b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10349e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1034a1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1034a8:	e9 9f 00 00 00       	jmp    10354c <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1034ad:	83 ec 08             	sub    $0x8,%esp
  1034b0:	ff 75 e0             	pushl  -0x20(%ebp)
  1034b3:	8d 45 14             	lea    0x14(%ebp),%eax
  1034b6:	50                   	push   %eax
  1034b7:	e8 99 fc ff ff       	call   103155 <getuint>
  1034bc:	83 c4 10             	add    $0x10,%esp
  1034bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1034c5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1034cc:	eb 7e                	jmp    10354c <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1034ce:	83 ec 08             	sub    $0x8,%esp
  1034d1:	ff 75 e0             	pushl  -0x20(%ebp)
  1034d4:	8d 45 14             	lea    0x14(%ebp),%eax
  1034d7:	50                   	push   %eax
  1034d8:	e8 78 fc ff ff       	call   103155 <getuint>
  1034dd:	83 c4 10             	add    $0x10,%esp
  1034e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1034e6:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1034ed:	eb 5d                	jmp    10354c <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  1034ef:	83 ec 08             	sub    $0x8,%esp
  1034f2:	ff 75 0c             	pushl  0xc(%ebp)
  1034f5:	6a 30                	push   $0x30
  1034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1034fa:	ff d0                	call   *%eax
  1034fc:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  1034ff:	83 ec 08             	sub    $0x8,%esp
  103502:	ff 75 0c             	pushl  0xc(%ebp)
  103505:	6a 78                	push   $0x78
  103507:	8b 45 08             	mov    0x8(%ebp),%eax
  10350a:	ff d0                	call   *%eax
  10350c:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10350f:	8b 45 14             	mov    0x14(%ebp),%eax
  103512:	8d 50 04             	lea    0x4(%eax),%edx
  103515:	89 55 14             	mov    %edx,0x14(%ebp)
  103518:	8b 00                	mov    (%eax),%eax
  10351a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10351d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103524:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10352b:	eb 1f                	jmp    10354c <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10352d:	83 ec 08             	sub    $0x8,%esp
  103530:	ff 75 e0             	pushl  -0x20(%ebp)
  103533:	8d 45 14             	lea    0x14(%ebp),%eax
  103536:	50                   	push   %eax
  103537:	e8 19 fc ff ff       	call   103155 <getuint>
  10353c:	83 c4 10             	add    $0x10,%esp
  10353f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103542:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103545:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10354c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103550:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103553:	83 ec 04             	sub    $0x4,%esp
  103556:	52                   	push   %edx
  103557:	ff 75 e8             	pushl  -0x18(%ebp)
  10355a:	50                   	push   %eax
  10355b:	ff 75 f4             	pushl  -0xc(%ebp)
  10355e:	ff 75 f0             	pushl  -0x10(%ebp)
  103561:	ff 75 0c             	pushl  0xc(%ebp)
  103564:	ff 75 08             	pushl  0x8(%ebp)
  103567:	e8 f8 fa ff ff       	call   103064 <printnum>
  10356c:	83 c4 20             	add    $0x20,%esp
            break;
  10356f:	eb 39                	jmp    1035aa <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103571:	83 ec 08             	sub    $0x8,%esp
  103574:	ff 75 0c             	pushl  0xc(%ebp)
  103577:	53                   	push   %ebx
  103578:	8b 45 08             	mov    0x8(%ebp),%eax
  10357b:	ff d0                	call   *%eax
  10357d:	83 c4 10             	add    $0x10,%esp
            break;
  103580:	eb 28                	jmp    1035aa <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103582:	83 ec 08             	sub    $0x8,%esp
  103585:	ff 75 0c             	pushl  0xc(%ebp)
  103588:	6a 25                	push   $0x25
  10358a:	8b 45 08             	mov    0x8(%ebp),%eax
  10358d:	ff d0                	call   *%eax
  10358f:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  103592:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103596:	eb 04                	jmp    10359c <vprintfmt+0x38d>
  103598:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10359c:	8b 45 10             	mov    0x10(%ebp),%eax
  10359f:	83 e8 01             	sub    $0x1,%eax
  1035a2:	0f b6 00             	movzbl (%eax),%eax
  1035a5:	3c 25                	cmp    $0x25,%al
  1035a7:	75 ef                	jne    103598 <vprintfmt+0x389>
                /* do nothing */;
            break;
  1035a9:	90                   	nop
        }
    }
  1035aa:	e9 68 fc ff ff       	jmp    103217 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  1035af:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1035b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1035b3:	5b                   	pop    %ebx
  1035b4:	5e                   	pop    %esi
  1035b5:	5d                   	pop    %ebp
  1035b6:	c3                   	ret    

001035b7 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1035b7:	55                   	push   %ebp
  1035b8:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1035ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035bd:	8b 40 08             	mov    0x8(%eax),%eax
  1035c0:	8d 50 01             	lea    0x1(%eax),%edx
  1035c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035c6:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1035c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035cc:	8b 10                	mov    (%eax),%edx
  1035ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035d1:	8b 40 04             	mov    0x4(%eax),%eax
  1035d4:	39 c2                	cmp    %eax,%edx
  1035d6:	73 12                	jae    1035ea <sprintputch+0x33>
        *b->buf ++ = ch;
  1035d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035db:	8b 00                	mov    (%eax),%eax
  1035dd:	8d 48 01             	lea    0x1(%eax),%ecx
  1035e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  1035e3:	89 0a                	mov    %ecx,(%edx)
  1035e5:	8b 55 08             	mov    0x8(%ebp),%edx
  1035e8:	88 10                	mov    %dl,(%eax)
    }
}
  1035ea:	90                   	nop
  1035eb:	5d                   	pop    %ebp
  1035ec:	c3                   	ret    

001035ed <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1035ed:	55                   	push   %ebp
  1035ee:	89 e5                	mov    %esp,%ebp
  1035f0:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1035f3:	8d 45 14             	lea    0x14(%ebp),%eax
  1035f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1035f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035fc:	50                   	push   %eax
  1035fd:	ff 75 10             	pushl  0x10(%ebp)
  103600:	ff 75 0c             	pushl  0xc(%ebp)
  103603:	ff 75 08             	pushl  0x8(%ebp)
  103606:	e8 0b 00 00 00       	call   103616 <vsnprintf>
  10360b:	83 c4 10             	add    $0x10,%esp
  10360e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103611:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103614:	c9                   	leave  
  103615:	c3                   	ret    

00103616 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103616:	55                   	push   %ebp
  103617:	89 e5                	mov    %esp,%ebp
  103619:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10361c:	8b 45 08             	mov    0x8(%ebp),%eax
  10361f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103622:	8b 45 0c             	mov    0xc(%ebp),%eax
  103625:	8d 50 ff             	lea    -0x1(%eax),%edx
  103628:	8b 45 08             	mov    0x8(%ebp),%eax
  10362b:	01 d0                	add    %edx,%eax
  10362d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103630:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103637:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10363b:	74 0a                	je     103647 <vsnprintf+0x31>
  10363d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103643:	39 c2                	cmp    %eax,%edx
  103645:	76 07                	jbe    10364e <vsnprintf+0x38>
        return -E_INVAL;
  103647:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10364c:	eb 20                	jmp    10366e <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10364e:	ff 75 14             	pushl  0x14(%ebp)
  103651:	ff 75 10             	pushl  0x10(%ebp)
  103654:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103657:	50                   	push   %eax
  103658:	68 b7 35 10 00       	push   $0x1035b7
  10365d:	e8 ad fb ff ff       	call   10320f <vprintfmt>
  103662:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  103665:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103668:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10366b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10366e:	c9                   	leave  
  10366f:	c3                   	ret    
