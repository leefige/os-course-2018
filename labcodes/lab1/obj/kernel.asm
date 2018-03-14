
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
  100006:	ba 00 fe 10 00       	mov    $0x10fe00,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 ea 10 00       	push   $0x10ea16
  10001f:	e8 eb 2c 00 00       	call   102d0f <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 34 15 00 00       	call   101560 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 c0 34 10 00 	movl   $0x1034c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 dc 34 10 00       	push   $0x1034dc
  10003e:	e8 0a 02 00 00       	call   10024d <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 8c 08 00 00       	call   1008d7 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 79 00 00 00       	call   1000c9 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 7e 29 00 00       	call   1029d3 <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 49 16 00 00       	call   1016a3 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 cb 17 00 00       	call   10182a <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 e1 0c 00 00       	call   100d45 <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 77 17 00 00       	call   1017e0 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100069:	e8 50 01 00 00       	call   1001be <lab1_switch_test>

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
  10007f:	e8 af 0c 00 00       	call   100d33 <mon_backtrace>
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
  100112:	68 e1 34 10 00       	push   $0x1034e1
  100117:	e8 31 01 00 00       	call   10024d <cprintf>
  10011c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100123:	0f b7 d0             	movzwl %ax,%edx
  100126:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10012b:	83 ec 04             	sub    $0x4,%esp
  10012e:	52                   	push   %edx
  10012f:	50                   	push   %eax
  100130:	68 ef 34 10 00       	push   $0x1034ef
  100135:	e8 13 01 00 00       	call   10024d <cprintf>
  10013a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  10013d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100141:	0f b7 d0             	movzwl %ax,%edx
  100144:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100149:	83 ec 04             	sub    $0x4,%esp
  10014c:	52                   	push   %edx
  10014d:	50                   	push   %eax
  10014e:	68 fd 34 10 00       	push   $0x1034fd
  100153:	e8 f5 00 00 00       	call   10024d <cprintf>
  100158:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  10015b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015f:	0f b7 d0             	movzwl %ax,%edx
  100162:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100167:	83 ec 04             	sub    $0x4,%esp
  10016a:	52                   	push   %edx
  10016b:	50                   	push   %eax
  10016c:	68 0b 35 10 00       	push   $0x10350b
  100171:	e8 d7 00 00 00       	call   10024d <cprintf>
  100176:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100179:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10017d:	0f b7 d0             	movzwl %ax,%edx
  100180:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100185:	83 ec 04             	sub    $0x4,%esp
  100188:	52                   	push   %edx
  100189:	50                   	push   %eax
  10018a:	68 19 35 10 00       	push   $0x103519
  10018f:	e8 b9 00 00 00       	call   10024d <cprintf>
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
  1001aa:	83 ec 08             	sub    $0x8,%esp
  1001ad:	cd 78                	int    $0x78
  1001af:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001b1:	90                   	nop
  1001b2:	5d                   	pop    %ebp
  1001b3:	c3                   	ret    

001001b4 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001b4:	55                   	push   %ebp
  1001b5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  1001b7:	cd 79                	int    $0x79
  1001b9:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001bb:	90                   	nop
  1001bc:	5d                   	pop    %ebp
  1001bd:	c3                   	ret    

001001be <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001be:	55                   	push   %ebp
  1001bf:	89 e5                	mov    %esp,%ebp
  1001c1:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001c4:	e8 21 ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001c9:	83 ec 0c             	sub    $0xc,%esp
  1001cc:	68 28 35 10 00       	push   $0x103528
  1001d1:	e8 77 00 00 00       	call   10024d <cprintf>
  1001d6:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001d9:	e8 c9 ff ff ff       	call   1001a7 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001de:	e8 07 ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001e3:	83 ec 0c             	sub    $0xc,%esp
  1001e6:	68 48 35 10 00       	push   $0x103548
  1001eb:	e8 5d 00 00 00       	call   10024d <cprintf>
  1001f0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001f3:	e8 bc ff ff ff       	call   1001b4 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001f8:	e8 ed fe ff ff       	call   1000ea <lab1_print_cur_status>
}
  1001fd:	90                   	nop
  1001fe:	c9                   	leave  
  1001ff:	c3                   	ret    

00100200 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100200:	55                   	push   %ebp
  100201:	89 e5                	mov    %esp,%ebp
  100203:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100206:	83 ec 0c             	sub    $0xc,%esp
  100209:	ff 75 08             	pushl  0x8(%ebp)
  10020c:	e8 80 13 00 00       	call   101591 <cons_putc>
  100211:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100214:	8b 45 0c             	mov    0xc(%ebp),%eax
  100217:	8b 00                	mov    (%eax),%eax
  100219:	8d 50 01             	lea    0x1(%eax),%edx
  10021c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10021f:	89 10                	mov    %edx,(%eax)
}
  100221:	90                   	nop
  100222:	c9                   	leave  
  100223:	c3                   	ret    

00100224 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100224:	55                   	push   %ebp
  100225:	89 e5                	mov    %esp,%ebp
  100227:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10022a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100231:	ff 75 0c             	pushl  0xc(%ebp)
  100234:	ff 75 08             	pushl  0x8(%ebp)
  100237:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10023a:	50                   	push   %eax
  10023b:	68 00 02 10 00       	push   $0x100200
  100240:	e8 00 2e 00 00       	call   103045 <vprintfmt>
  100245:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100248:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10024b:	c9                   	leave  
  10024c:	c3                   	ret    

0010024d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10024d:	55                   	push   %ebp
  10024e:	89 e5                	mov    %esp,%ebp
  100250:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100253:	8d 45 0c             	lea    0xc(%ebp),%eax
  100256:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10025c:	83 ec 08             	sub    $0x8,%esp
  10025f:	50                   	push   %eax
  100260:	ff 75 08             	pushl  0x8(%ebp)
  100263:	e8 bc ff ff ff       	call   100224 <vcprintf>
  100268:	83 c4 10             	add    $0x10,%esp
  10026b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10026e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100271:	c9                   	leave  
  100272:	c3                   	ret    

00100273 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100273:	55                   	push   %ebp
  100274:	89 e5                	mov    %esp,%ebp
  100276:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100279:	83 ec 0c             	sub    $0xc,%esp
  10027c:	ff 75 08             	pushl  0x8(%ebp)
  10027f:	e8 0d 13 00 00       	call   101591 <cons_putc>
  100284:	83 c4 10             	add    $0x10,%esp
}
  100287:	90                   	nop
  100288:	c9                   	leave  
  100289:	c3                   	ret    

0010028a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10028a:	55                   	push   %ebp
  10028b:	89 e5                	mov    %esp,%ebp
  10028d:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100290:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100297:	eb 14                	jmp    1002ad <cputs+0x23>
        cputch(c, &cnt);
  100299:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10029d:	83 ec 08             	sub    $0x8,%esp
  1002a0:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002a3:	52                   	push   %edx
  1002a4:	50                   	push   %eax
  1002a5:	e8 56 ff ff ff       	call   100200 <cputch>
  1002aa:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1002b0:	8d 50 01             	lea    0x1(%eax),%edx
  1002b3:	89 55 08             	mov    %edx,0x8(%ebp)
  1002b6:	0f b6 00             	movzbl (%eax),%eax
  1002b9:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002bc:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002c0:	75 d7                	jne    100299 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002c2:	83 ec 08             	sub    $0x8,%esp
  1002c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002c8:	50                   	push   %eax
  1002c9:	6a 0a                	push   $0xa
  1002cb:	e8 30 ff ff ff       	call   100200 <cputch>
  1002d0:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002d6:	c9                   	leave  
  1002d7:	c3                   	ret    

001002d8 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002d8:	55                   	push   %ebp
  1002d9:	89 e5                	mov    %esp,%ebp
  1002db:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002de:	e8 de 12 00 00       	call   1015c1 <cons_getc>
  1002e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002ea:	74 f2                	je     1002de <getchar+0x6>
        /* do nothing */;
    return c;
  1002ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ef:	c9                   	leave  
  1002f0:	c3                   	ret    

001002f1 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002f1:	55                   	push   %ebp
  1002f2:	89 e5                	mov    %esp,%ebp
  1002f4:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  1002f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002fb:	74 13                	je     100310 <readline+0x1f>
        cprintf("%s", prompt);
  1002fd:	83 ec 08             	sub    $0x8,%esp
  100300:	ff 75 08             	pushl  0x8(%ebp)
  100303:	68 67 35 10 00       	push   $0x103567
  100308:	e8 40 ff ff ff       	call   10024d <cprintf>
  10030d:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100310:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100317:	e8 bc ff ff ff       	call   1002d8 <getchar>
  10031c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10031f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100323:	79 0a                	jns    10032f <readline+0x3e>
            return NULL;
  100325:	b8 00 00 00 00       	mov    $0x0,%eax
  10032a:	e9 82 00 00 00       	jmp    1003b1 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10032f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100333:	7e 2b                	jle    100360 <readline+0x6f>
  100335:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10033c:	7f 22                	jg     100360 <readline+0x6f>
            cputchar(c);
  10033e:	83 ec 0c             	sub    $0xc,%esp
  100341:	ff 75 f0             	pushl  -0x10(%ebp)
  100344:	e8 2a ff ff ff       	call   100273 <cputchar>
  100349:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10034c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10034f:	8d 50 01             	lea    0x1(%eax),%edx
  100352:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100355:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100358:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  10035e:	eb 4c                	jmp    1003ac <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  100360:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100364:	75 1a                	jne    100380 <readline+0x8f>
  100366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10036a:	7e 14                	jle    100380 <readline+0x8f>
            cputchar(c);
  10036c:	83 ec 0c             	sub    $0xc,%esp
  10036f:	ff 75 f0             	pushl  -0x10(%ebp)
  100372:	e8 fc fe ff ff       	call   100273 <cputchar>
  100377:	83 c4 10             	add    $0x10,%esp
            i --;
  10037a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10037e:	eb 2c                	jmp    1003ac <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  100380:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100384:	74 06                	je     10038c <readline+0x9b>
  100386:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10038a:	75 8b                	jne    100317 <readline+0x26>
            cputchar(c);
  10038c:	83 ec 0c             	sub    $0xc,%esp
  10038f:	ff 75 f0             	pushl  -0x10(%ebp)
  100392:	e8 dc fe ff ff       	call   100273 <cputchar>
  100397:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  10039a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10039d:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003a2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003a5:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003aa:	eb 05                	jmp    1003b1 <readline+0xc0>
        }
    }
  1003ac:	e9 66 ff ff ff       	jmp    100317 <readline+0x26>
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003b9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003be:	85 c0                	test   %eax,%eax
  1003c0:	75 4a                	jne    10040c <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003c2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003c9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003cc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003d2:	83 ec 04             	sub    $0x4,%esp
  1003d5:	ff 75 0c             	pushl  0xc(%ebp)
  1003d8:	ff 75 08             	pushl  0x8(%ebp)
  1003db:	68 6a 35 10 00       	push   $0x10356a
  1003e0:	e8 68 fe ff ff       	call   10024d <cprintf>
  1003e5:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1003e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003eb:	83 ec 08             	sub    $0x8,%esp
  1003ee:	50                   	push   %eax
  1003ef:	ff 75 10             	pushl  0x10(%ebp)
  1003f2:	e8 2d fe ff ff       	call   100224 <vcprintf>
  1003f7:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1003fa:	83 ec 0c             	sub    $0xc,%esp
  1003fd:	68 86 35 10 00       	push   $0x103586
  100402:	e8 46 fe ff ff       	call   10024d <cprintf>
  100407:	83 c4 10             	add    $0x10,%esp
  10040a:	eb 01                	jmp    10040d <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  10040c:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  10040d:	e8 d5 13 00 00       	call   1017e7 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100412:	83 ec 0c             	sub    $0xc,%esp
  100415:	6a 00                	push   $0x0
  100417:	e8 3d 08 00 00       	call   100c59 <kmonitor>
  10041c:	83 c4 10             	add    $0x10,%esp
    }
  10041f:	eb f1                	jmp    100412 <__panic+0x5f>

00100421 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100421:	55                   	push   %ebp
  100422:	89 e5                	mov    %esp,%ebp
  100424:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100427:	8d 45 14             	lea    0x14(%ebp),%eax
  10042a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10042d:	83 ec 04             	sub    $0x4,%esp
  100430:	ff 75 0c             	pushl  0xc(%ebp)
  100433:	ff 75 08             	pushl  0x8(%ebp)
  100436:	68 88 35 10 00       	push   $0x103588
  10043b:	e8 0d fe ff ff       	call   10024d <cprintf>
  100440:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100446:	83 ec 08             	sub    $0x8,%esp
  100449:	50                   	push   %eax
  10044a:	ff 75 10             	pushl  0x10(%ebp)
  10044d:	e8 d2 fd ff ff       	call   100224 <vcprintf>
  100452:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100455:	83 ec 0c             	sub    $0xc,%esp
  100458:	68 86 35 10 00       	push   $0x103586
  10045d:	e8 eb fd ff ff       	call   10024d <cprintf>
  100462:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100465:	90                   	nop
  100466:	c9                   	leave  
  100467:	c3                   	ret    

00100468 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100468:	55                   	push   %ebp
  100469:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10046b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100470:	5d                   	pop    %ebp
  100471:	c3                   	ret    

00100472 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100472:	55                   	push   %ebp
  100473:	89 e5                	mov    %esp,%ebp
  100475:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100478:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047b:	8b 00                	mov    (%eax),%eax
  10047d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100480:	8b 45 10             	mov    0x10(%ebp),%eax
  100483:	8b 00                	mov    (%eax),%eax
  100485:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100488:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10048f:	e9 d2 00 00 00       	jmp    100566 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  100494:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100497:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10049a:	01 d0                	add    %edx,%eax
  10049c:	89 c2                	mov    %eax,%edx
  10049e:	c1 ea 1f             	shr    $0x1f,%edx
  1004a1:	01 d0                	add    %edx,%eax
  1004a3:	d1 f8                	sar    %eax
  1004a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004ab:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ae:	eb 04                	jmp    1004b4 <stab_binsearch+0x42>
            m --;
  1004b0:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ba:	7c 1f                	jl     1004db <stab_binsearch+0x69>
  1004bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004bf:	89 d0                	mov    %edx,%eax
  1004c1:	01 c0                	add    %eax,%eax
  1004c3:	01 d0                	add    %edx,%eax
  1004c5:	c1 e0 02             	shl    $0x2,%eax
  1004c8:	89 c2                	mov    %eax,%edx
  1004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1004cd:	01 d0                	add    %edx,%eax
  1004cf:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004d3:	0f b6 c0             	movzbl %al,%eax
  1004d6:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004d9:	75 d5                	jne    1004b0 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004e1:	7d 0b                	jge    1004ee <stab_binsearch+0x7c>
            l = true_m + 1;
  1004e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004e6:	83 c0 01             	add    $0x1,%eax
  1004e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004ec:	eb 78                	jmp    100566 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004ee:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  1004f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004f8:	89 d0                	mov    %edx,%eax
  1004fa:	01 c0                	add    %eax,%eax
  1004fc:	01 d0                	add    %edx,%eax
  1004fe:	c1 e0 02             	shl    $0x2,%eax
  100501:	89 c2                	mov    %eax,%edx
  100503:	8b 45 08             	mov    0x8(%ebp),%eax
  100506:	01 d0                	add    %edx,%eax
  100508:	8b 40 08             	mov    0x8(%eax),%eax
  10050b:	3b 45 18             	cmp    0x18(%ebp),%eax
  10050e:	73 13                	jae    100523 <stab_binsearch+0xb1>
            *region_left = m;
  100510:	8b 45 0c             	mov    0xc(%ebp),%eax
  100513:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100516:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10051b:	83 c0 01             	add    $0x1,%eax
  10051e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100521:	eb 43                	jmp    100566 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100523:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100526:	89 d0                	mov    %edx,%eax
  100528:	01 c0                	add    %eax,%eax
  10052a:	01 d0                	add    %edx,%eax
  10052c:	c1 e0 02             	shl    $0x2,%eax
  10052f:	89 c2                	mov    %eax,%edx
  100531:	8b 45 08             	mov    0x8(%ebp),%eax
  100534:	01 d0                	add    %edx,%eax
  100536:	8b 40 08             	mov    0x8(%eax),%eax
  100539:	3b 45 18             	cmp    0x18(%ebp),%eax
  10053c:	76 16                	jbe    100554 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10053e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100541:	8d 50 ff             	lea    -0x1(%eax),%edx
  100544:	8b 45 10             	mov    0x10(%ebp),%eax
  100547:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054c:	83 e8 01             	sub    $0x1,%eax
  10054f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100552:	eb 12                	jmp    100566 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100554:	8b 45 0c             	mov    0xc(%ebp),%eax
  100557:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10055a:	89 10                	mov    %edx,(%eax)
            l = m;
  10055c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100562:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100566:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100569:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10056c:	0f 8e 22 ff ff ff    	jle    100494 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  100572:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100576:	75 0f                	jne    100587 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100578:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057b:	8b 00                	mov    (%eax),%eax
  10057d:	8d 50 ff             	lea    -0x1(%eax),%edx
  100580:	8b 45 10             	mov    0x10(%ebp),%eax
  100583:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100585:	eb 3f                	jmp    1005c6 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100587:	8b 45 10             	mov    0x10(%ebp),%eax
  10058a:	8b 00                	mov    (%eax),%eax
  10058c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10058f:	eb 04                	jmp    100595 <stab_binsearch+0x123>
  100591:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100595:	8b 45 0c             	mov    0xc(%ebp),%eax
  100598:	8b 00                	mov    (%eax),%eax
  10059a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10059d:	7d 1f                	jge    1005be <stab_binsearch+0x14c>
  10059f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005a2:	89 d0                	mov    %edx,%eax
  1005a4:	01 c0                	add    %eax,%eax
  1005a6:	01 d0                	add    %edx,%eax
  1005a8:	c1 e0 02             	shl    $0x2,%eax
  1005ab:	89 c2                	mov    %eax,%edx
  1005ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b0:	01 d0                	add    %edx,%eax
  1005b2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005b6:	0f b6 c0             	movzbl %al,%eax
  1005b9:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005bc:	75 d3                	jne    100591 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005c4:	89 10                	mov    %edx,(%eax)
    }
}
  1005c6:	90                   	nop
  1005c7:	c9                   	leave  
  1005c8:	c3                   	ret    

001005c9 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005c9:	55                   	push   %ebp
  1005ca:	89 e5                	mov    %esp,%ebp
  1005cc:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d2:	c7 00 a8 35 10 00    	movl   $0x1035a8,(%eax)
    info->eip_line = 0;
  1005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e5:	c7 40 08 a8 35 10 00 	movl   $0x1035a8,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ef:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1005fc:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  1005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100602:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100609:	c7 45 f4 ec 3d 10 00 	movl   $0x103dec,-0xc(%ebp)
    stab_end = __STAB_END__;
  100610:	c7 45 f0 98 b8 10 00 	movl   $0x10b898,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100617:	c7 45 ec 99 b8 10 00 	movl   $0x10b899,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10061e:	c7 45 e8 41 d9 10 00 	movl   $0x10d941,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100628:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10062b:	76 0d                	jbe    10063a <debuginfo_eip+0x71>
  10062d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100630:	83 e8 01             	sub    $0x1,%eax
  100633:	0f b6 00             	movzbl (%eax),%eax
  100636:	84 c0                	test   %al,%al
  100638:	74 0a                	je     100644 <debuginfo_eip+0x7b>
        return -1;
  10063a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10063f:	e9 91 02 00 00       	jmp    1008d5 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100644:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10064b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10064e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100651:	29 c2                	sub    %eax,%edx
  100653:	89 d0                	mov    %edx,%eax
  100655:	c1 f8 02             	sar    $0x2,%eax
  100658:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10065e:	83 e8 01             	sub    $0x1,%eax
  100661:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100664:	ff 75 08             	pushl  0x8(%ebp)
  100667:	6a 64                	push   $0x64
  100669:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10066c:	50                   	push   %eax
  10066d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100670:	50                   	push   %eax
  100671:	ff 75 f4             	pushl  -0xc(%ebp)
  100674:	e8 f9 fd ff ff       	call   100472 <stab_binsearch>
  100679:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  10067c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10067f:	85 c0                	test   %eax,%eax
  100681:	75 0a                	jne    10068d <debuginfo_eip+0xc4>
        return -1;
  100683:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100688:	e9 48 02 00 00       	jmp    1008d5 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10068d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100690:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100693:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100696:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100699:	ff 75 08             	pushl  0x8(%ebp)
  10069c:	6a 24                	push   $0x24
  10069e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006a1:	50                   	push   %eax
  1006a2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006a5:	50                   	push   %eax
  1006a6:	ff 75 f4             	pushl  -0xc(%ebp)
  1006a9:	e8 c4 fd ff ff       	call   100472 <stab_binsearch>
  1006ae:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006b7:	39 c2                	cmp    %eax,%edx
  1006b9:	7f 7c                	jg     100737 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006be:	89 c2                	mov    %eax,%edx
  1006c0:	89 d0                	mov    %edx,%eax
  1006c2:	01 c0                	add    %eax,%eax
  1006c4:	01 d0                	add    %edx,%eax
  1006c6:	c1 e0 02             	shl    $0x2,%eax
  1006c9:	89 c2                	mov    %eax,%edx
  1006cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ce:	01 d0                	add    %edx,%eax
  1006d0:	8b 00                	mov    (%eax),%eax
  1006d2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006d8:	29 d1                	sub    %edx,%ecx
  1006da:	89 ca                	mov    %ecx,%edx
  1006dc:	39 d0                	cmp    %edx,%eax
  1006de:	73 22                	jae    100702 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006e3:	89 c2                	mov    %eax,%edx
  1006e5:	89 d0                	mov    %edx,%eax
  1006e7:	01 c0                	add    %eax,%eax
  1006e9:	01 d0                	add    %edx,%eax
  1006eb:	c1 e0 02             	shl    $0x2,%eax
  1006ee:	89 c2                	mov    %eax,%edx
  1006f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f3:	01 d0                	add    %edx,%eax
  1006f5:	8b 10                	mov    (%eax),%edx
  1006f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006fa:	01 c2                	add    %eax,%edx
  1006fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ff:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100702:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100705:	89 c2                	mov    %eax,%edx
  100707:	89 d0                	mov    %edx,%eax
  100709:	01 c0                	add    %eax,%eax
  10070b:	01 d0                	add    %edx,%eax
  10070d:	c1 e0 02             	shl    $0x2,%eax
  100710:	89 c2                	mov    %eax,%edx
  100712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100715:	01 d0                	add    %edx,%eax
  100717:	8b 50 08             	mov    0x8(%eax),%edx
  10071a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10071d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	8b 40 10             	mov    0x10(%eax),%eax
  100726:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100729:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10072c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10072f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100732:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100735:	eb 15                	jmp    10074c <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100737:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073a:	8b 55 08             	mov    0x8(%ebp),%edx
  10073d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100743:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100746:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100749:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10074c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074f:	8b 40 08             	mov    0x8(%eax),%eax
  100752:	83 ec 08             	sub    $0x8,%esp
  100755:	6a 3a                	push   $0x3a
  100757:	50                   	push   %eax
  100758:	e8 26 24 00 00       	call   102b83 <strfind>
  10075d:	83 c4 10             	add    $0x10,%esp
  100760:	89 c2                	mov    %eax,%edx
  100762:	8b 45 0c             	mov    0xc(%ebp),%eax
  100765:	8b 40 08             	mov    0x8(%eax),%eax
  100768:	29 c2                	sub    %eax,%edx
  10076a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076d:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100770:	83 ec 0c             	sub    $0xc,%esp
  100773:	ff 75 08             	pushl  0x8(%ebp)
  100776:	6a 44                	push   $0x44
  100778:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10077b:	50                   	push   %eax
  10077c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10077f:	50                   	push   %eax
  100780:	ff 75 f4             	pushl  -0xc(%ebp)
  100783:	e8 ea fc ff ff       	call   100472 <stab_binsearch>
  100788:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  10078b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10078e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100791:	39 c2                	cmp    %eax,%edx
  100793:	7f 24                	jg     1007b9 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  100795:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100798:	89 c2                	mov    %eax,%edx
  10079a:	89 d0                	mov    %edx,%eax
  10079c:	01 c0                	add    %eax,%eax
  10079e:	01 d0                	add    %edx,%eax
  1007a0:	c1 e0 02             	shl    $0x2,%eax
  1007a3:	89 c2                	mov    %eax,%edx
  1007a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a8:	01 d0                	add    %edx,%eax
  1007aa:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007ae:	0f b7 d0             	movzwl %ax,%edx
  1007b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b4:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007b7:	eb 13                	jmp    1007cc <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007be:	e9 12 01 00 00       	jmp    1008d5 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007c6:	83 e8 01             	sub    $0x1,%eax
  1007c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d2:	39 c2                	cmp    %eax,%edx
  1007d4:	7c 56                	jl     10082c <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d9:	89 c2                	mov    %eax,%edx
  1007db:	89 d0                	mov    %edx,%eax
  1007dd:	01 c0                	add    %eax,%eax
  1007df:	01 d0                	add    %edx,%eax
  1007e1:	c1 e0 02             	shl    $0x2,%eax
  1007e4:	89 c2                	mov    %eax,%edx
  1007e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e9:	01 d0                	add    %edx,%eax
  1007eb:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007ef:	3c 84                	cmp    $0x84,%al
  1007f1:	74 39                	je     10082c <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1007f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f6:	89 c2                	mov    %eax,%edx
  1007f8:	89 d0                	mov    %edx,%eax
  1007fa:	01 c0                	add    %eax,%eax
  1007fc:	01 d0                	add    %edx,%eax
  1007fe:	c1 e0 02             	shl    $0x2,%eax
  100801:	89 c2                	mov    %eax,%edx
  100803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100806:	01 d0                	add    %edx,%eax
  100808:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10080c:	3c 64                	cmp    $0x64,%al
  10080e:	75 b3                	jne    1007c3 <debuginfo_eip+0x1fa>
  100810:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100813:	89 c2                	mov    %eax,%edx
  100815:	89 d0                	mov    %edx,%eax
  100817:	01 c0                	add    %eax,%eax
  100819:	01 d0                	add    %edx,%eax
  10081b:	c1 e0 02             	shl    $0x2,%eax
  10081e:	89 c2                	mov    %eax,%edx
  100820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100823:	01 d0                	add    %edx,%eax
  100825:	8b 40 08             	mov    0x8(%eax),%eax
  100828:	85 c0                	test   %eax,%eax
  10082a:	74 97                	je     1007c3 <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10082c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100832:	39 c2                	cmp    %eax,%edx
  100834:	7c 46                	jl     10087c <debuginfo_eip+0x2b3>
  100836:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100839:	89 c2                	mov    %eax,%edx
  10083b:	89 d0                	mov    %edx,%eax
  10083d:	01 c0                	add    %eax,%eax
  10083f:	01 d0                	add    %edx,%eax
  100841:	c1 e0 02             	shl    $0x2,%eax
  100844:	89 c2                	mov    %eax,%edx
  100846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100849:	01 d0                	add    %edx,%eax
  10084b:	8b 00                	mov    (%eax),%eax
  10084d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100850:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100853:	29 d1                	sub    %edx,%ecx
  100855:	89 ca                	mov    %ecx,%edx
  100857:	39 d0                	cmp    %edx,%eax
  100859:	73 21                	jae    10087c <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10085b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085e:	89 c2                	mov    %eax,%edx
  100860:	89 d0                	mov    %edx,%eax
  100862:	01 c0                	add    %eax,%eax
  100864:	01 d0                	add    %edx,%eax
  100866:	c1 e0 02             	shl    $0x2,%eax
  100869:	89 c2                	mov    %eax,%edx
  10086b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086e:	01 d0                	add    %edx,%eax
  100870:	8b 10                	mov    (%eax),%edx
  100872:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100875:	01 c2                	add    %eax,%edx
  100877:	8b 45 0c             	mov    0xc(%ebp),%eax
  10087a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10087c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10087f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100882:	39 c2                	cmp    %eax,%edx
  100884:	7d 4a                	jge    1008d0 <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  100886:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100889:	83 c0 01             	add    $0x1,%eax
  10088c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10088f:	eb 18                	jmp    1008a9 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100891:	8b 45 0c             	mov    0xc(%ebp),%eax
  100894:	8b 40 14             	mov    0x14(%eax),%eax
  100897:	8d 50 01             	lea    0x1(%eax),%edx
  10089a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10089d:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008a3:	83 c0 01             	add    $0x1,%eax
  1008a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008af:	39 c2                	cmp    %eax,%edx
  1008b1:	7d 1d                	jge    1008d0 <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b6:	89 c2                	mov    %eax,%edx
  1008b8:	89 d0                	mov    %edx,%eax
  1008ba:	01 c0                	add    %eax,%eax
  1008bc:	01 d0                	add    %edx,%eax
  1008be:	c1 e0 02             	shl    $0x2,%eax
  1008c1:	89 c2                	mov    %eax,%edx
  1008c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c6:	01 d0                	add    %edx,%eax
  1008c8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008cc:	3c a0                	cmp    $0xa0,%al
  1008ce:	74 c1                	je     100891 <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008d5:	c9                   	leave  
  1008d6:	c3                   	ret    

001008d7 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008d7:	55                   	push   %ebp
  1008d8:	89 e5                	mov    %esp,%ebp
  1008da:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008dd:	83 ec 0c             	sub    $0xc,%esp
  1008e0:	68 b2 35 10 00       	push   $0x1035b2
  1008e5:	e8 63 f9 ff ff       	call   10024d <cprintf>
  1008ea:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008ed:	83 ec 08             	sub    $0x8,%esp
  1008f0:	68 00 00 10 00       	push   $0x100000
  1008f5:	68 cb 35 10 00       	push   $0x1035cb
  1008fa:	e8 4e f9 ff ff       	call   10024d <cprintf>
  1008ff:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100902:	83 ec 08             	sub    $0x8,%esp
  100905:	68 a6 34 10 00       	push   $0x1034a6
  10090a:	68 e3 35 10 00       	push   $0x1035e3
  10090f:	e8 39 f9 ff ff       	call   10024d <cprintf>
  100914:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100917:	83 ec 08             	sub    $0x8,%esp
  10091a:	68 16 ea 10 00       	push   $0x10ea16
  10091f:	68 fb 35 10 00       	push   $0x1035fb
  100924:	e8 24 f9 ff ff       	call   10024d <cprintf>
  100929:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10092c:	83 ec 08             	sub    $0x8,%esp
  10092f:	68 00 fe 10 00       	push   $0x10fe00
  100934:	68 13 36 10 00       	push   $0x103613
  100939:	e8 0f f9 ff ff       	call   10024d <cprintf>
  10093e:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100941:	b8 00 fe 10 00       	mov    $0x10fe00,%eax
  100946:	05 ff 03 00 00       	add    $0x3ff,%eax
  10094b:	ba 00 00 10 00       	mov    $0x100000,%edx
  100950:	29 d0                	sub    %edx,%eax
  100952:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100958:	85 c0                	test   %eax,%eax
  10095a:	0f 48 c2             	cmovs  %edx,%eax
  10095d:	c1 f8 0a             	sar    $0xa,%eax
  100960:	83 ec 08             	sub    $0x8,%esp
  100963:	50                   	push   %eax
  100964:	68 2c 36 10 00       	push   $0x10362c
  100969:	e8 df f8 ff ff       	call   10024d <cprintf>
  10096e:	83 c4 10             	add    $0x10,%esp
}
  100971:	90                   	nop
  100972:	c9                   	leave  
  100973:	c3                   	ret    

00100974 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100974:	55                   	push   %ebp
  100975:	89 e5                	mov    %esp,%ebp
  100977:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10097d:	83 ec 08             	sub    $0x8,%esp
  100980:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100983:	50                   	push   %eax
  100984:	ff 75 08             	pushl  0x8(%ebp)
  100987:	e8 3d fc ff ff       	call   1005c9 <debuginfo_eip>
  10098c:	83 c4 10             	add    $0x10,%esp
  10098f:	85 c0                	test   %eax,%eax
  100991:	74 15                	je     1009a8 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100993:	83 ec 08             	sub    $0x8,%esp
  100996:	ff 75 08             	pushl  0x8(%ebp)
  100999:	68 56 36 10 00       	push   $0x103656
  10099e:	e8 aa f8 ff ff       	call   10024d <cprintf>
  1009a3:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a6:	eb 65                	jmp    100a0d <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009af:	eb 1c                	jmp    1009cd <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009b7:	01 d0                	add    %edx,%eax
  1009b9:	0f b6 00             	movzbl (%eax),%eax
  1009bc:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009c5:	01 ca                	add    %ecx,%edx
  1009c7:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009d3:	7f dc                	jg     1009b1 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009d5:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009de:	01 d0                	add    %edx,%eax
  1009e0:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  1009e6:	8b 55 08             	mov    0x8(%ebp),%edx
  1009e9:	89 d1                	mov    %edx,%ecx
  1009eb:	29 c1                	sub    %eax,%ecx
  1009ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1009f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009f3:	83 ec 0c             	sub    $0xc,%esp
  1009f6:	51                   	push   %ecx
  1009f7:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009fd:	51                   	push   %ecx
  1009fe:	52                   	push   %edx
  1009ff:	50                   	push   %eax
  100a00:	68 72 36 10 00       	push   $0x103672
  100a05:	e8 43 f8 ff ff       	call   10024d <cprintf>
  100a0a:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  100a0d:	90                   	nop
  100a0e:	c9                   	leave  
  100a0f:	c3                   	ret    

00100a10 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a10:	55                   	push   %ebp
  100a11:	89 e5                	mov    %esp,%ebp
  100a13:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a16:	8b 45 04             	mov    0x4(%ebp),%eax
  100a19:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a1f:	c9                   	leave  
  100a20:	c3                   	ret    

00100a21 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a21:	55                   	push   %ebp
  100a22:	89 e5                	mov    %esp,%ebp
  100a24:	53                   	push   %ebx
  100a25:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a28:	89 e8                	mov    %ebp,%eax
  100a2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100a2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    // 1. read_ebp
    uint32_t stack_val_ebp = read_ebp();
  100a30:	89 45 f4             	mov    %eax,-0xc(%ebp)

    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
  100a33:	e8 d8 ff ff ff       	call   100a10 <read_eip>
  100a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  100a3b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a42:	e9 93 00 00 00       	jmp    100ada <print_stackframe+0xb9>
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);
  100a47:	83 ec 04             	sub    $0x4,%esp
  100a4a:	ff 75 f0             	pushl  -0x10(%ebp)
  100a4d:	ff 75 f4             	pushl  -0xc(%ebp)
  100a50:	68 84 36 10 00       	push   $0x103684
  100a55:	e8 f3 f7 ff ff       	call   10024d <cprintf>
  100a5a:	83 c4 10             	add    $0x10,%esp

        // get args
        for (int j = 0; j < 4; j++) {
  100a5d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a64:	eb 1f                	jmp    100a85 <print_stackframe+0x64>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
  100a66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a73:	01 d0                	add    %edx,%eax
  100a75:	83 c0 08             	add    $0x8,%eax
  100a78:	8b 10                	mov    (%eax),%edx
  100a7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a7d:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);

        // get args
        for (int j = 0; j < 4; j++) {
  100a81:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a85:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a89:	7e db                	jle    100a66 <print_stackframe+0x45>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
        }

        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", stack_val_args[0], 
  100a8b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  100a8e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  100a91:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100a94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a97:	83 ec 0c             	sub    $0xc,%esp
  100a9a:	53                   	push   %ebx
  100a9b:	51                   	push   %ecx
  100a9c:	52                   	push   %edx
  100a9d:	50                   	push   %eax
  100a9e:	68 9c 36 10 00       	push   $0x10369c
  100aa3:	e8 a5 f7 ff ff       	call   10024d <cprintf>
  100aa8:	83 c4 20             	add    $0x20,%esp
                stack_val_args[1], stack_val_args[2], stack_val_args[3]);

        // print function info
        print_debuginfo(stack_val_eip - 1);
  100aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aae:	83 e8 01             	sub    $0x1,%eax
  100ab1:	83 ec 0c             	sub    $0xc,%esp
  100ab4:	50                   	push   %eax
  100ab5:	e8 ba fe ff ff       	call   100974 <print_debuginfo>
  100aba:	83 c4 10             	add    $0x10,%esp

        // pop up stackframe, refresh ebp & eip
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
  100abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac0:	83 c0 04             	add    $0x4,%eax
  100ac3:	8b 00                	mov    (%eax),%eax
  100ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));
  100ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100acb:	8b 00                	mov    (%eax),%eax
  100acd:	89 45 f4             	mov    %eax,-0xc(%ebp)

        // ebp should be valid
        if (stack_val_ebp <= 0) {
  100ad0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ad4:	74 10                	je     100ae6 <print_stackframe+0xc5>
    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
    
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  100ad6:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ada:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100ade:	0f 8e 63 ff ff ff    	jle    100a47 <print_stackframe+0x26>
        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
        }
    }
}
  100ae4:	eb 01                	jmp    100ae7 <print_stackframe+0xc6>
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));

        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
  100ae6:	90                   	nop
        }
    }
}
  100ae7:	90                   	nop
  100ae8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100aeb:	c9                   	leave  
  100aec:	c3                   	ret    

00100aed <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100aed:	55                   	push   %ebp
  100aee:	89 e5                	mov    %esp,%ebp
  100af0:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100af3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100afa:	eb 0c                	jmp    100b08 <parse+0x1b>
            *buf ++ = '\0';
  100afc:	8b 45 08             	mov    0x8(%ebp),%eax
  100aff:	8d 50 01             	lea    0x1(%eax),%edx
  100b02:	89 55 08             	mov    %edx,0x8(%ebp)
  100b05:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b08:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0b:	0f b6 00             	movzbl (%eax),%eax
  100b0e:	84 c0                	test   %al,%al
  100b10:	74 1e                	je     100b30 <parse+0x43>
  100b12:	8b 45 08             	mov    0x8(%ebp),%eax
  100b15:	0f b6 00             	movzbl (%eax),%eax
  100b18:	0f be c0             	movsbl %al,%eax
  100b1b:	83 ec 08             	sub    $0x8,%esp
  100b1e:	50                   	push   %eax
  100b1f:	68 40 37 10 00       	push   $0x103740
  100b24:	e8 27 20 00 00       	call   102b50 <strchr>
  100b29:	83 c4 10             	add    $0x10,%esp
  100b2c:	85 c0                	test   %eax,%eax
  100b2e:	75 cc                	jne    100afc <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b30:	8b 45 08             	mov    0x8(%ebp),%eax
  100b33:	0f b6 00             	movzbl (%eax),%eax
  100b36:	84 c0                	test   %al,%al
  100b38:	74 69                	je     100ba3 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b3e:	75 12                	jne    100b52 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b40:	83 ec 08             	sub    $0x8,%esp
  100b43:	6a 10                	push   $0x10
  100b45:	68 45 37 10 00       	push   $0x103745
  100b4a:	e8 fe f6 ff ff       	call   10024d <cprintf>
  100b4f:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b55:	8d 50 01             	lea    0x1(%eax),%edx
  100b58:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b65:	01 c2                	add    %eax,%edx
  100b67:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6a:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b6c:	eb 04                	jmp    100b72 <parse+0x85>
            buf ++;
  100b6e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b72:	8b 45 08             	mov    0x8(%ebp),%eax
  100b75:	0f b6 00             	movzbl (%eax),%eax
  100b78:	84 c0                	test   %al,%al
  100b7a:	0f 84 7a ff ff ff    	je     100afa <parse+0xd>
  100b80:	8b 45 08             	mov    0x8(%ebp),%eax
  100b83:	0f b6 00             	movzbl (%eax),%eax
  100b86:	0f be c0             	movsbl %al,%eax
  100b89:	83 ec 08             	sub    $0x8,%esp
  100b8c:	50                   	push   %eax
  100b8d:	68 40 37 10 00       	push   $0x103740
  100b92:	e8 b9 1f 00 00       	call   102b50 <strchr>
  100b97:	83 c4 10             	add    $0x10,%esp
  100b9a:	85 c0                	test   %eax,%eax
  100b9c:	74 d0                	je     100b6e <parse+0x81>
            buf ++;
        }
    }
  100b9e:	e9 57 ff ff ff       	jmp    100afa <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100ba3:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100ba7:	c9                   	leave  
  100ba8:	c3                   	ret    

00100ba9 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ba9:	55                   	push   %ebp
  100baa:	89 e5                	mov    %esp,%ebp
  100bac:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100baf:	83 ec 08             	sub    $0x8,%esp
  100bb2:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bb5:	50                   	push   %eax
  100bb6:	ff 75 08             	pushl  0x8(%ebp)
  100bb9:	e8 2f ff ff ff       	call   100aed <parse>
  100bbe:	83 c4 10             	add    $0x10,%esp
  100bc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bc8:	75 0a                	jne    100bd4 <runcmd+0x2b>
        return 0;
  100bca:	b8 00 00 00 00       	mov    $0x0,%eax
  100bcf:	e9 83 00 00 00       	jmp    100c57 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bd4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bdb:	eb 59                	jmp    100c36 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bdd:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100be3:	89 d0                	mov    %edx,%eax
  100be5:	01 c0                	add    %eax,%eax
  100be7:	01 d0                	add    %edx,%eax
  100be9:	c1 e0 02             	shl    $0x2,%eax
  100bec:	05 00 e0 10 00       	add    $0x10e000,%eax
  100bf1:	8b 00                	mov    (%eax),%eax
  100bf3:	83 ec 08             	sub    $0x8,%esp
  100bf6:	51                   	push   %ecx
  100bf7:	50                   	push   %eax
  100bf8:	e8 b3 1e 00 00       	call   102ab0 <strcmp>
  100bfd:	83 c4 10             	add    $0x10,%esp
  100c00:	85 c0                	test   %eax,%eax
  100c02:	75 2e                	jne    100c32 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c07:	89 d0                	mov    %edx,%eax
  100c09:	01 c0                	add    %eax,%eax
  100c0b:	01 d0                	add    %edx,%eax
  100c0d:	c1 e0 02             	shl    $0x2,%eax
  100c10:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c15:	8b 10                	mov    (%eax),%edx
  100c17:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c1a:	83 c0 04             	add    $0x4,%eax
  100c1d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c20:	83 e9 01             	sub    $0x1,%ecx
  100c23:	83 ec 04             	sub    $0x4,%esp
  100c26:	ff 75 0c             	pushl  0xc(%ebp)
  100c29:	50                   	push   %eax
  100c2a:	51                   	push   %ecx
  100c2b:	ff d2                	call   *%edx
  100c2d:	83 c4 10             	add    $0x10,%esp
  100c30:	eb 25                	jmp    100c57 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c39:	83 f8 02             	cmp    $0x2,%eax
  100c3c:	76 9f                	jbe    100bdd <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c3e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c41:	83 ec 08             	sub    $0x8,%esp
  100c44:	50                   	push   %eax
  100c45:	68 63 37 10 00       	push   $0x103763
  100c4a:	e8 fe f5 ff ff       	call   10024d <cprintf>
  100c4f:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c57:	c9                   	leave  
  100c58:	c3                   	ret    

00100c59 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c59:	55                   	push   %ebp
  100c5a:	89 e5                	mov    %esp,%ebp
  100c5c:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c5f:	83 ec 0c             	sub    $0xc,%esp
  100c62:	68 7c 37 10 00       	push   $0x10377c
  100c67:	e8 e1 f5 ff ff       	call   10024d <cprintf>
  100c6c:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c6f:	83 ec 0c             	sub    $0xc,%esp
  100c72:	68 a4 37 10 00       	push   $0x1037a4
  100c77:	e8 d1 f5 ff ff       	call   10024d <cprintf>
  100c7c:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c83:	74 0e                	je     100c93 <kmonitor+0x3a>
        print_trapframe(tf);
  100c85:	83 ec 0c             	sub    $0xc,%esp
  100c88:	ff 75 08             	pushl  0x8(%ebp)
  100c8b:	e8 d3 0c 00 00       	call   101963 <print_trapframe>
  100c90:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c93:	83 ec 0c             	sub    $0xc,%esp
  100c96:	68 c9 37 10 00       	push   $0x1037c9
  100c9b:	e8 51 f6 ff ff       	call   1002f1 <readline>
  100ca0:	83 c4 10             	add    $0x10,%esp
  100ca3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ca6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100caa:	74 e7                	je     100c93 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100cac:	83 ec 08             	sub    $0x8,%esp
  100caf:	ff 75 08             	pushl  0x8(%ebp)
  100cb2:	ff 75 f4             	pushl  -0xc(%ebp)
  100cb5:	e8 ef fe ff ff       	call   100ba9 <runcmd>
  100cba:	83 c4 10             	add    $0x10,%esp
  100cbd:	85 c0                	test   %eax,%eax
  100cbf:	78 02                	js     100cc3 <kmonitor+0x6a>
                break;
            }
        }
    }
  100cc1:	eb d0                	jmp    100c93 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100cc3:	90                   	nop
            }
        }
    }
}
  100cc4:	90                   	nop
  100cc5:	c9                   	leave  
  100cc6:	c3                   	ret    

00100cc7 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cc7:	55                   	push   %ebp
  100cc8:	89 e5                	mov    %esp,%ebp
  100cca:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ccd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cd4:	eb 3c                	jmp    100d12 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cd9:	89 d0                	mov    %edx,%eax
  100cdb:	01 c0                	add    %eax,%eax
  100cdd:	01 d0                	add    %edx,%eax
  100cdf:	c1 e0 02             	shl    $0x2,%eax
  100ce2:	05 04 e0 10 00       	add    $0x10e004,%eax
  100ce7:	8b 08                	mov    (%eax),%ecx
  100ce9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cec:	89 d0                	mov    %edx,%eax
  100cee:	01 c0                	add    %eax,%eax
  100cf0:	01 d0                	add    %edx,%eax
  100cf2:	c1 e0 02             	shl    $0x2,%eax
  100cf5:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cfa:	8b 00                	mov    (%eax),%eax
  100cfc:	83 ec 04             	sub    $0x4,%esp
  100cff:	51                   	push   %ecx
  100d00:	50                   	push   %eax
  100d01:	68 cd 37 10 00       	push   $0x1037cd
  100d06:	e8 42 f5 ff ff       	call   10024d <cprintf>
  100d0b:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d0e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d15:	83 f8 02             	cmp    $0x2,%eax
  100d18:	76 bc                	jbe    100cd6 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d1f:	c9                   	leave  
  100d20:	c3                   	ret    

00100d21 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d21:	55                   	push   %ebp
  100d22:	89 e5                	mov    %esp,%ebp
  100d24:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d27:	e8 ab fb ff ff       	call   1008d7 <print_kerninfo>
    return 0;
  100d2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d31:	c9                   	leave  
  100d32:	c3                   	ret    

00100d33 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d33:	55                   	push   %ebp
  100d34:	89 e5                	mov    %esp,%ebp
  100d36:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d39:	e8 e3 fc ff ff       	call   100a21 <print_stackframe>
    return 0;
  100d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d43:	c9                   	leave  
  100d44:	c3                   	ret    

00100d45 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d45:	55                   	push   %ebp
  100d46:	89 e5                	mov    %esp,%ebp
  100d48:	83 ec 18             	sub    $0x18,%esp
  100d4b:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d51:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d55:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d59:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d5d:	ee                   	out    %al,(%dx)
  100d5e:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d64:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d68:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d6c:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d70:	ee                   	out    %al,(%dx)
  100d71:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d77:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d7b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d7f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d83:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d84:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d8b:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d8e:	83 ec 0c             	sub    $0xc,%esp
  100d91:	68 d6 37 10 00       	push   $0x1037d6
  100d96:	e8 b2 f4 ff ff       	call   10024d <cprintf>
  100d9b:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d9e:	83 ec 0c             	sub    $0xc,%esp
  100da1:	6a 00                	push   $0x0
  100da3:	e8 ce 08 00 00       	call   101676 <pic_enable>
  100da8:	83 c4 10             	add    $0x10,%esp
}
  100dab:	90                   	nop
  100dac:	c9                   	leave  
  100dad:	c3                   	ret    

00100dae <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dae:	55                   	push   %ebp
  100daf:	89 e5                	mov    %esp,%ebp
  100db1:	83 ec 10             	sub    $0x10,%esp
  100db4:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dba:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dbe:	89 c2                	mov    %eax,%edx
  100dc0:	ec                   	in     (%dx),%al
  100dc1:	88 45 f4             	mov    %al,-0xc(%ebp)
  100dc4:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100dca:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100dce:	89 c2                	mov    %eax,%edx
  100dd0:	ec                   	in     (%dx),%al
  100dd1:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dd4:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dda:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dde:	89 c2                	mov    %eax,%edx
  100de0:	ec                   	in     (%dx),%al
  100de1:	88 45 f6             	mov    %al,-0xa(%ebp)
  100de4:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100dea:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100dee:	89 c2                	mov    %eax,%edx
  100df0:	ec                   	in     (%dx),%al
  100df1:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100df4:	90                   	nop
  100df5:	c9                   	leave  
  100df6:	c3                   	ret    

00100df7 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100df7:	55                   	push   %ebp
  100df8:	89 e5                	mov    %esp,%ebp
  100dfa:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100dfd:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e07:	0f b7 00             	movzwl (%eax),%eax
  100e0a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e11:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e19:	0f b7 00             	movzwl (%eax),%eax
  100e1c:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e20:	74 12                	je     100e34 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e22:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e29:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e30:	b4 03 
  100e32:	eb 13                	jmp    100e47 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e37:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e3b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e3e:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e45:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e47:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e4e:	0f b7 c0             	movzwl %ax,%eax
  100e51:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100e55:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e59:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100e5d:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100e61:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e62:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e69:	83 c0 01             	add    $0x1,%eax
  100e6c:	0f b7 c0             	movzwl %ax,%eax
  100e6f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e73:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e77:	89 c2                	mov    %eax,%edx
  100e79:	ec                   	in     (%dx),%al
  100e7a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100e7d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100e81:	0f b6 c0             	movzbl %al,%eax
  100e84:	c1 e0 08             	shl    $0x8,%eax
  100e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e8a:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e91:	0f b7 c0             	movzwl %ax,%eax
  100e94:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100e98:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e9c:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100ea0:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100ea4:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ea5:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eac:	83 c0 01             	add    $0x1,%eax
  100eaf:	0f b7 c0             	movzwl %ax,%eax
  100eb2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eba:	89 c2                	mov    %eax,%edx
  100ebc:	ec                   	in     (%dx),%al
  100ebd:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ec0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ec4:	0f b6 c0             	movzbl %al,%eax
  100ec7:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ecd:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ed5:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100edb:	90                   	nop
  100edc:	c9                   	leave  
  100edd:	c3                   	ret    

00100ede <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ede:	55                   	push   %ebp
  100edf:	89 e5                	mov    %esp,%ebp
  100ee1:	83 ec 28             	sub    $0x28,%esp
  100ee4:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100eea:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eee:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100ef2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ef6:	ee                   	out    %al,(%dx)
  100ef7:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100efd:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100f01:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100f05:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100f09:	ee                   	out    %al,(%dx)
  100f0a:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f10:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f14:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f18:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f1c:	ee                   	out    %al,(%dx)
  100f1d:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f23:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f27:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f2b:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f2f:	ee                   	out    %al,(%dx)
  100f30:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f36:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f3a:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f3e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f42:	ee                   	out    %al,(%dx)
  100f43:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f49:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f4d:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100f51:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100f55:	ee                   	out    %al,(%dx)
  100f56:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f5c:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100f60:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100f64:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f68:	ee                   	out    %al,(%dx)
  100f69:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f6f:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100f73:	89 c2                	mov    %eax,%edx
  100f75:	ec                   	in     (%dx),%al
  100f76:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100f79:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f7d:	3c ff                	cmp    $0xff,%al
  100f7f:	0f 95 c0             	setne  %al
  100f82:	0f b6 c0             	movzbl %al,%eax
  100f85:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f8a:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f90:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f94:	89 c2                	mov    %eax,%edx
  100f96:	ec                   	in     (%dx),%al
  100f97:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100f9a:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100fa0:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100fa4:	89 c2                	mov    %eax,%edx
  100fa6:	ec                   	in     (%dx),%al
  100fa7:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100faa:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100faf:	85 c0                	test   %eax,%eax
  100fb1:	74 0d                	je     100fc0 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100fb3:	83 ec 0c             	sub    $0xc,%esp
  100fb6:	6a 04                	push   $0x4
  100fb8:	e8 b9 06 00 00       	call   101676 <pic_enable>
  100fbd:	83 c4 10             	add    $0x10,%esp
    }
}
  100fc0:	90                   	nop
  100fc1:	c9                   	leave  
  100fc2:	c3                   	ret    

00100fc3 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fc3:	55                   	push   %ebp
  100fc4:	89 e5                	mov    %esp,%ebp
  100fc6:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fd0:	eb 09                	jmp    100fdb <lpt_putc_sub+0x18>
        delay();
  100fd2:	e8 d7 fd ff ff       	call   100dae <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fdb:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100fe1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100fe5:	89 c2                	mov    %eax,%edx
  100fe7:	ec                   	in     (%dx),%al
  100fe8:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100feb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100fef:	84 c0                	test   %al,%al
  100ff1:	78 09                	js     100ffc <lpt_putc_sub+0x39>
  100ff3:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100ffa:	7e d6                	jle    100fd2 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  100fff:	0f b6 c0             	movzbl %al,%eax
  101002:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  101008:	88 45 f0             	mov    %al,-0x10(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10100b:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  10100f:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  101013:	ee                   	out    %al,(%dx)
  101014:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10101a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10101e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101022:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101026:	ee                   	out    %al,(%dx)
  101027:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  10102d:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  101031:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  101035:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101039:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10103a:	90                   	nop
  10103b:	c9                   	leave  
  10103c:	c3                   	ret    

0010103d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10103d:	55                   	push   %ebp
  10103e:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101040:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101044:	74 0d                	je     101053 <lpt_putc+0x16>
        lpt_putc_sub(c);
  101046:	ff 75 08             	pushl  0x8(%ebp)
  101049:	e8 75 ff ff ff       	call   100fc3 <lpt_putc_sub>
  10104e:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101051:	eb 1e                	jmp    101071 <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  101053:	6a 08                	push   $0x8
  101055:	e8 69 ff ff ff       	call   100fc3 <lpt_putc_sub>
  10105a:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  10105d:	6a 20                	push   $0x20
  10105f:	e8 5f ff ff ff       	call   100fc3 <lpt_putc_sub>
  101064:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101067:	6a 08                	push   $0x8
  101069:	e8 55 ff ff ff       	call   100fc3 <lpt_putc_sub>
  10106e:	83 c4 04             	add    $0x4,%esp
    }
}
  101071:	90                   	nop
  101072:	c9                   	leave  
  101073:	c3                   	ret    

00101074 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101074:	55                   	push   %ebp
  101075:	89 e5                	mov    %esp,%ebp
  101077:	53                   	push   %ebx
  101078:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10107b:	8b 45 08             	mov    0x8(%ebp),%eax
  10107e:	b0 00                	mov    $0x0,%al
  101080:	85 c0                	test   %eax,%eax
  101082:	75 07                	jne    10108b <cga_putc+0x17>
        c |= 0x0700;
  101084:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10108b:	8b 45 08             	mov    0x8(%ebp),%eax
  10108e:	0f b6 c0             	movzbl %al,%eax
  101091:	83 f8 0a             	cmp    $0xa,%eax
  101094:	74 4e                	je     1010e4 <cga_putc+0x70>
  101096:	83 f8 0d             	cmp    $0xd,%eax
  101099:	74 59                	je     1010f4 <cga_putc+0x80>
  10109b:	83 f8 08             	cmp    $0x8,%eax
  10109e:	0f 85 8a 00 00 00    	jne    10112e <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  1010a4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010ab:	66 85 c0             	test   %ax,%ax
  1010ae:	0f 84 a0 00 00 00    	je     101154 <cga_putc+0xe0>
            crt_pos --;
  1010b4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010bb:	83 e8 01             	sub    $0x1,%eax
  1010be:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010c4:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010c9:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010d0:	0f b7 d2             	movzwl %dx,%edx
  1010d3:	01 d2                	add    %edx,%edx
  1010d5:	01 d0                	add    %edx,%eax
  1010d7:	8b 55 08             	mov    0x8(%ebp),%edx
  1010da:	b2 00                	mov    $0x0,%dl
  1010dc:	83 ca 20             	or     $0x20,%edx
  1010df:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010e2:	eb 70                	jmp    101154 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  1010e4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010eb:	83 c0 50             	add    $0x50,%eax
  1010ee:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010f4:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010fb:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101102:	0f b7 c1             	movzwl %cx,%eax
  101105:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10110b:	c1 e8 10             	shr    $0x10,%eax
  10110e:	89 c2                	mov    %eax,%edx
  101110:	66 c1 ea 06          	shr    $0x6,%dx
  101114:	89 d0                	mov    %edx,%eax
  101116:	c1 e0 02             	shl    $0x2,%eax
  101119:	01 d0                	add    %edx,%eax
  10111b:	c1 e0 04             	shl    $0x4,%eax
  10111e:	29 c1                	sub    %eax,%ecx
  101120:	89 ca                	mov    %ecx,%edx
  101122:	89 d8                	mov    %ebx,%eax
  101124:	29 d0                	sub    %edx,%eax
  101126:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10112c:	eb 27                	jmp    101155 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10112e:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101134:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10113b:	8d 50 01             	lea    0x1(%eax),%edx
  10113e:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101145:	0f b7 c0             	movzwl %ax,%eax
  101148:	01 c0                	add    %eax,%eax
  10114a:	01 c8                	add    %ecx,%eax
  10114c:	8b 55 08             	mov    0x8(%ebp),%edx
  10114f:	66 89 10             	mov    %dx,(%eax)
        break;
  101152:	eb 01                	jmp    101155 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  101154:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101155:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10115c:	66 3d cf 07          	cmp    $0x7cf,%ax
  101160:	76 59                	jbe    1011bb <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101162:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101167:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10116d:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101172:	83 ec 04             	sub    $0x4,%esp
  101175:	68 00 0f 00 00       	push   $0xf00
  10117a:	52                   	push   %edx
  10117b:	50                   	push   %eax
  10117c:	e8 ce 1b 00 00       	call   102d4f <memmove>
  101181:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101184:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10118b:	eb 15                	jmp    1011a2 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  10118d:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101192:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101195:	01 d2                	add    %edx,%edx
  101197:	01 d0                	add    %edx,%eax
  101199:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10119e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011a2:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011a9:	7e e2                	jle    10118d <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011ab:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011b2:	83 e8 50             	sub    $0x50,%eax
  1011b5:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011bb:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011c2:	0f b7 c0             	movzwl %ax,%eax
  1011c5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011c9:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  1011cd:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1011d1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011d5:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011d6:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011dd:	66 c1 e8 08          	shr    $0x8,%ax
  1011e1:	0f b6 c0             	movzbl %al,%eax
  1011e4:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011eb:	83 c2 01             	add    $0x1,%edx
  1011ee:	0f b7 d2             	movzwl %dx,%edx
  1011f1:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  1011f5:	88 45 e9             	mov    %al,-0x17(%ebp)
  1011f8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011fc:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101200:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101201:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101208:	0f b7 c0             	movzwl %ax,%eax
  10120b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10120f:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  101213:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101217:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10121b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10121c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101223:	0f b6 c0             	movzbl %al,%eax
  101226:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10122d:	83 c2 01             	add    $0x1,%edx
  101230:	0f b7 d2             	movzwl %dx,%edx
  101233:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101237:	88 45 eb             	mov    %al,-0x15(%ebp)
  10123a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10123e:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101242:	ee                   	out    %al,(%dx)
}
  101243:	90                   	nop
  101244:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101247:	c9                   	leave  
  101248:	c3                   	ret    

00101249 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101249:	55                   	push   %ebp
  10124a:	89 e5                	mov    %esp,%ebp
  10124c:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10124f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101256:	eb 09                	jmp    101261 <serial_putc_sub+0x18>
        delay();
  101258:	e8 51 fb ff ff       	call   100dae <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10125d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101261:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101267:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  10126b:	89 c2                	mov    %eax,%edx
  10126d:	ec                   	in     (%dx),%al
  10126e:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  101271:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  101275:	0f b6 c0             	movzbl %al,%eax
  101278:	83 e0 20             	and    $0x20,%eax
  10127b:	85 c0                	test   %eax,%eax
  10127d:	75 09                	jne    101288 <serial_putc_sub+0x3f>
  10127f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101286:	7e d0                	jle    101258 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101288:	8b 45 08             	mov    0x8(%ebp),%eax
  10128b:	0f b6 c0             	movzbl %al,%eax
  10128e:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  101294:	88 45 f6             	mov    %al,-0xa(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101297:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  10129b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10129f:	ee                   	out    %al,(%dx)
}
  1012a0:	90                   	nop
  1012a1:	c9                   	leave  
  1012a2:	c3                   	ret    

001012a3 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012a3:	55                   	push   %ebp
  1012a4:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012a6:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012aa:	74 0d                	je     1012b9 <serial_putc+0x16>
        serial_putc_sub(c);
  1012ac:	ff 75 08             	pushl  0x8(%ebp)
  1012af:	e8 95 ff ff ff       	call   101249 <serial_putc_sub>
  1012b4:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012b7:	eb 1e                	jmp    1012d7 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  1012b9:	6a 08                	push   $0x8
  1012bb:	e8 89 ff ff ff       	call   101249 <serial_putc_sub>
  1012c0:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012c3:	6a 20                	push   $0x20
  1012c5:	e8 7f ff ff ff       	call   101249 <serial_putc_sub>
  1012ca:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012cd:	6a 08                	push   $0x8
  1012cf:	e8 75 ff ff ff       	call   101249 <serial_putc_sub>
  1012d4:	83 c4 04             	add    $0x4,%esp
    }
}
  1012d7:	90                   	nop
  1012d8:	c9                   	leave  
  1012d9:	c3                   	ret    

001012da <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012da:	55                   	push   %ebp
  1012db:	89 e5                	mov    %esp,%ebp
  1012dd:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012e0:	eb 33                	jmp    101315 <cons_intr+0x3b>
        if (c != 0) {
  1012e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012e6:	74 2d                	je     101315 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012e8:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012ed:	8d 50 01             	lea    0x1(%eax),%edx
  1012f0:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1012f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012f9:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012ff:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101304:	3d 00 02 00 00       	cmp    $0x200,%eax
  101309:	75 0a                	jne    101315 <cons_intr+0x3b>
                cons.wpos = 0;
  10130b:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101312:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101315:	8b 45 08             	mov    0x8(%ebp),%eax
  101318:	ff d0                	call   *%eax
  10131a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10131d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101321:	75 bf                	jne    1012e2 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101323:	90                   	nop
  101324:	c9                   	leave  
  101325:	c3                   	ret    

00101326 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101326:	55                   	push   %ebp
  101327:	89 e5                	mov    %esp,%ebp
  101329:	83 ec 10             	sub    $0x10,%esp
  10132c:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101332:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101336:	89 c2                	mov    %eax,%edx
  101338:	ec                   	in     (%dx),%al
  101339:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10133c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101340:	0f b6 c0             	movzbl %al,%eax
  101343:	83 e0 01             	and    $0x1,%eax
  101346:	85 c0                	test   %eax,%eax
  101348:	75 07                	jne    101351 <serial_proc_data+0x2b>
        return -1;
  10134a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10134f:	eb 2a                	jmp    10137b <serial_proc_data+0x55>
  101351:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101357:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10135b:	89 c2                	mov    %eax,%edx
  10135d:	ec                   	in     (%dx),%al
  10135e:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  101361:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101365:	0f b6 c0             	movzbl %al,%eax
  101368:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10136b:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10136f:	75 07                	jne    101378 <serial_proc_data+0x52>
        c = '\b';
  101371:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101378:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10137b:	c9                   	leave  
  10137c:	c3                   	ret    

0010137d <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10137d:	55                   	push   %ebp
  10137e:	89 e5                	mov    %esp,%ebp
  101380:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  101383:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101388:	85 c0                	test   %eax,%eax
  10138a:	74 10                	je     10139c <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  10138c:	83 ec 0c             	sub    $0xc,%esp
  10138f:	68 26 13 10 00       	push   $0x101326
  101394:	e8 41 ff ff ff       	call   1012da <cons_intr>
  101399:	83 c4 10             	add    $0x10,%esp
    }
}
  10139c:	90                   	nop
  10139d:	c9                   	leave  
  10139e:	c3                   	ret    

0010139f <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10139f:	55                   	push   %ebp
  1013a0:	89 e5                	mov    %esp,%ebp
  1013a2:	83 ec 18             	sub    $0x18,%esp
  1013a5:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ab:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013af:	89 c2                	mov    %eax,%edx
  1013b1:	ec                   	in     (%dx),%al
  1013b2:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013b5:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013b9:	0f b6 c0             	movzbl %al,%eax
  1013bc:	83 e0 01             	and    $0x1,%eax
  1013bf:	85 c0                	test   %eax,%eax
  1013c1:	75 0a                	jne    1013cd <kbd_proc_data+0x2e>
        return -1;
  1013c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013c8:	e9 5d 01 00 00       	jmp    10152a <kbd_proc_data+0x18b>
  1013cd:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013d3:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013d7:	89 c2                	mov    %eax,%edx
  1013d9:	ec                   	in     (%dx),%al
  1013da:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  1013dd:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013e1:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013e4:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013e8:	75 17                	jne    101401 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013ea:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013ef:	83 c8 40             	or     $0x40,%eax
  1013f2:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013f7:	b8 00 00 00 00       	mov    $0x0,%eax
  1013fc:	e9 29 01 00 00       	jmp    10152a <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  101401:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101405:	84 c0                	test   %al,%al
  101407:	79 47                	jns    101450 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101409:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10140e:	83 e0 40             	and    $0x40,%eax
  101411:	85 c0                	test   %eax,%eax
  101413:	75 09                	jne    10141e <kbd_proc_data+0x7f>
  101415:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101419:	83 e0 7f             	and    $0x7f,%eax
  10141c:	eb 04                	jmp    101422 <kbd_proc_data+0x83>
  10141e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101422:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101425:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101429:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101430:	83 c8 40             	or     $0x40,%eax
  101433:	0f b6 c0             	movzbl %al,%eax
  101436:	f7 d0                	not    %eax
  101438:	89 c2                	mov    %eax,%edx
  10143a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10143f:	21 d0                	and    %edx,%eax
  101441:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101446:	b8 00 00 00 00       	mov    $0x0,%eax
  10144b:	e9 da 00 00 00       	jmp    10152a <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  101450:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101455:	83 e0 40             	and    $0x40,%eax
  101458:	85 c0                	test   %eax,%eax
  10145a:	74 11                	je     10146d <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10145c:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101460:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101465:	83 e0 bf             	and    $0xffffffbf,%eax
  101468:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10146d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101471:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101478:	0f b6 d0             	movzbl %al,%edx
  10147b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101480:	09 d0                	or     %edx,%eax
  101482:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101487:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148b:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  101492:	0f b6 d0             	movzbl %al,%edx
  101495:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10149a:	31 d0                	xor    %edx,%eax
  10149c:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014a1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a6:	83 e0 03             	and    $0x3,%eax
  1014a9:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014b0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b4:	01 d0                	add    %edx,%eax
  1014b6:	0f b6 00             	movzbl (%eax),%eax
  1014b9:	0f b6 c0             	movzbl %al,%eax
  1014bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014bf:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c4:	83 e0 08             	and    $0x8,%eax
  1014c7:	85 c0                	test   %eax,%eax
  1014c9:	74 22                	je     1014ed <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014cb:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014cf:	7e 0c                	jle    1014dd <kbd_proc_data+0x13e>
  1014d1:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014d5:	7f 06                	jg     1014dd <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014d7:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014db:	eb 10                	jmp    1014ed <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014dd:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014e1:	7e 0a                	jle    1014ed <kbd_proc_data+0x14e>
  1014e3:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014e7:	7f 04                	jg     1014ed <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014e9:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014ed:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014f2:	f7 d0                	not    %eax
  1014f4:	83 e0 06             	and    $0x6,%eax
  1014f7:	85 c0                	test   %eax,%eax
  1014f9:	75 2c                	jne    101527 <kbd_proc_data+0x188>
  1014fb:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101502:	75 23                	jne    101527 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  101504:	83 ec 0c             	sub    $0xc,%esp
  101507:	68 f1 37 10 00       	push   $0x1037f1
  10150c:	e8 3c ed ff ff       	call   10024d <cprintf>
  101511:	83 c4 10             	add    $0x10,%esp
  101514:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  10151a:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10151e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101522:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101526:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101527:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10152a:	c9                   	leave  
  10152b:	c3                   	ret    

0010152c <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10152c:	55                   	push   %ebp
  10152d:	89 e5                	mov    %esp,%ebp
  10152f:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  101532:	83 ec 0c             	sub    $0xc,%esp
  101535:	68 9f 13 10 00       	push   $0x10139f
  10153a:	e8 9b fd ff ff       	call   1012da <cons_intr>
  10153f:	83 c4 10             	add    $0x10,%esp
}
  101542:	90                   	nop
  101543:	c9                   	leave  
  101544:	c3                   	ret    

00101545 <kbd_init>:

static void
kbd_init(void) {
  101545:	55                   	push   %ebp
  101546:	89 e5                	mov    %esp,%ebp
  101548:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  10154b:	e8 dc ff ff ff       	call   10152c <kbd_intr>
    pic_enable(IRQ_KBD);
  101550:	83 ec 0c             	sub    $0xc,%esp
  101553:	6a 01                	push   $0x1
  101555:	e8 1c 01 00 00       	call   101676 <pic_enable>
  10155a:	83 c4 10             	add    $0x10,%esp
}
  10155d:	90                   	nop
  10155e:	c9                   	leave  
  10155f:	c3                   	ret    

00101560 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101560:	55                   	push   %ebp
  101561:	89 e5                	mov    %esp,%ebp
  101563:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101566:	e8 8c f8 ff ff       	call   100df7 <cga_init>
    serial_init();
  10156b:	e8 6e f9 ff ff       	call   100ede <serial_init>
    kbd_init();
  101570:	e8 d0 ff ff ff       	call   101545 <kbd_init>
    if (!serial_exists) {
  101575:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10157a:	85 c0                	test   %eax,%eax
  10157c:	75 10                	jne    10158e <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10157e:	83 ec 0c             	sub    $0xc,%esp
  101581:	68 fd 37 10 00       	push   $0x1037fd
  101586:	e8 c2 ec ff ff       	call   10024d <cprintf>
  10158b:	83 c4 10             	add    $0x10,%esp
    }
}
  10158e:	90                   	nop
  10158f:	c9                   	leave  
  101590:	c3                   	ret    

00101591 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101591:	55                   	push   %ebp
  101592:	89 e5                	mov    %esp,%ebp
  101594:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  101597:	ff 75 08             	pushl  0x8(%ebp)
  10159a:	e8 9e fa ff ff       	call   10103d <lpt_putc>
  10159f:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1015a2:	83 ec 0c             	sub    $0xc,%esp
  1015a5:	ff 75 08             	pushl  0x8(%ebp)
  1015a8:	e8 c7 fa ff ff       	call   101074 <cga_putc>
  1015ad:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1015b0:	83 ec 0c             	sub    $0xc,%esp
  1015b3:	ff 75 08             	pushl  0x8(%ebp)
  1015b6:	e8 e8 fc ff ff       	call   1012a3 <serial_putc>
  1015bb:	83 c4 10             	add    $0x10,%esp
}
  1015be:	90                   	nop
  1015bf:	c9                   	leave  
  1015c0:	c3                   	ret    

001015c1 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015c1:	55                   	push   %ebp
  1015c2:	89 e5                	mov    %esp,%ebp
  1015c4:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015c7:	e8 b1 fd ff ff       	call   10137d <serial_intr>
    kbd_intr();
  1015cc:	e8 5b ff ff ff       	call   10152c <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015d1:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015d7:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015dc:	39 c2                	cmp    %eax,%edx
  1015de:	74 36                	je     101616 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015e0:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015e5:	8d 50 01             	lea    0x1(%eax),%edx
  1015e8:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015ee:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015f5:	0f b6 c0             	movzbl %al,%eax
  1015f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015fb:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101600:	3d 00 02 00 00       	cmp    $0x200,%eax
  101605:	75 0a                	jne    101611 <cons_getc+0x50>
            cons.rpos = 0;
  101607:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10160e:	00 00 00 
        }
        return c;
  101611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101614:	eb 05                	jmp    10161b <cons_getc+0x5a>
    }
    return 0;
  101616:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10161b:	c9                   	leave  
  10161c:	c3                   	ret    

0010161d <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10161d:	55                   	push   %ebp
  10161e:	89 e5                	mov    %esp,%ebp
  101620:	83 ec 14             	sub    $0x14,%esp
  101623:	8b 45 08             	mov    0x8(%ebp),%eax
  101626:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10162a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10162e:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101634:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101639:	85 c0                	test   %eax,%eax
  10163b:	74 36                	je     101673 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10163d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101641:	0f b6 c0             	movzbl %al,%eax
  101644:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10164a:	88 45 fa             	mov    %al,-0x6(%ebp)
  10164d:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  101651:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101655:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101656:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10165a:	66 c1 e8 08          	shr    $0x8,%ax
  10165e:	0f b6 c0             	movzbl %al,%eax
  101661:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101667:	88 45 fb             	mov    %al,-0x5(%ebp)
  10166a:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  10166e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  101672:	ee                   	out    %al,(%dx)
    }
}
  101673:	90                   	nop
  101674:	c9                   	leave  
  101675:	c3                   	ret    

00101676 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101676:	55                   	push   %ebp
  101677:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101679:	8b 45 08             	mov    0x8(%ebp),%eax
  10167c:	ba 01 00 00 00       	mov    $0x1,%edx
  101681:	89 c1                	mov    %eax,%ecx
  101683:	d3 e2                	shl    %cl,%edx
  101685:	89 d0                	mov    %edx,%eax
  101687:	f7 d0                	not    %eax
  101689:	89 c2                	mov    %eax,%edx
  10168b:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101692:	21 d0                	and    %edx,%eax
  101694:	0f b7 c0             	movzwl %ax,%eax
  101697:	50                   	push   %eax
  101698:	e8 80 ff ff ff       	call   10161d <pic_setmask>
  10169d:	83 c4 04             	add    $0x4,%esp
}
  1016a0:	90                   	nop
  1016a1:	c9                   	leave  
  1016a2:	c3                   	ret    

001016a3 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016a3:	55                   	push   %ebp
  1016a4:	89 e5                	mov    %esp,%ebp
  1016a6:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  1016a9:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016b0:	00 00 00 
  1016b3:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016b9:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1016bd:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1016c1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016c5:	ee                   	out    %al,(%dx)
  1016c6:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016cc:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1016d0:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1016d4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016d8:	ee                   	out    %al,(%dx)
  1016d9:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1016df:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  1016e3:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  1016e7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016eb:	ee                   	out    %al,(%dx)
  1016ec:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  1016f2:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  1016f6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1016fa:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1016fe:	ee                   	out    %al,(%dx)
  1016ff:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  101705:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101709:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  10170d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101711:	ee                   	out    %al,(%dx)
  101712:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101718:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  10171c:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  101720:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  101724:	ee                   	out    %al,(%dx)
  101725:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  10172b:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  10172f:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  101733:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101737:	ee                   	out    %al,(%dx)
  101738:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  10173e:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  101742:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101746:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10174a:	ee                   	out    %al,(%dx)
  10174b:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101751:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  101755:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  101759:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10175d:	ee                   	out    %al,(%dx)
  10175e:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  101764:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  101768:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  10176c:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101770:	ee                   	out    %al,(%dx)
  101771:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  101777:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  10177b:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  10177f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101783:	ee                   	out    %al,(%dx)
  101784:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  10178a:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  10178e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101792:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101796:	ee                   	out    %al,(%dx)
  101797:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10179d:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  1017a1:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  1017a5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017a9:	ee                   	out    %al,(%dx)
  1017aa:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  1017b0:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  1017b4:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1017b8:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1017bc:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017bd:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017c4:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017c8:	74 13                	je     1017dd <pic_init+0x13a>
        pic_setmask(irq_mask);
  1017ca:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d1:	0f b7 c0             	movzwl %ax,%eax
  1017d4:	50                   	push   %eax
  1017d5:	e8 43 fe ff ff       	call   10161d <pic_setmask>
  1017da:	83 c4 04             	add    $0x4,%esp
    }
}
  1017dd:	90                   	nop
  1017de:	c9                   	leave  
  1017df:	c3                   	ret    

001017e0 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017e0:	55                   	push   %ebp
  1017e1:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017e3:	fb                   	sti    
    sti();
}
  1017e4:	90                   	nop
  1017e5:	5d                   	pop    %ebp
  1017e6:	c3                   	ret    

001017e7 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017e7:	55                   	push   %ebp
  1017e8:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017ea:	fa                   	cli    
    cli();
}
  1017eb:	90                   	nop
  1017ec:	5d                   	pop    %ebp
  1017ed:	c3                   	ret    

001017ee <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017ee:	55                   	push   %ebp
  1017ef:	89 e5                	mov    %esp,%ebp
  1017f1:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017f4:	83 ec 08             	sub    $0x8,%esp
  1017f7:	6a 64                	push   $0x64
  1017f9:	68 20 38 10 00       	push   $0x103820
  1017fe:	e8 4a ea ff ff       	call   10024d <cprintf>
  101803:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101806:	83 ec 0c             	sub    $0xc,%esp
  101809:	68 2a 38 10 00       	push   $0x10382a
  10180e:	e8 3a ea ff ff       	call   10024d <cprintf>
  101813:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  101816:	83 ec 04             	sub    $0x4,%esp
  101819:	68 38 38 10 00       	push   $0x103838
  10181e:	6a 12                	push   $0x12
  101820:	68 4e 38 10 00       	push   $0x10384e
  101825:	e8 89 eb ff ff       	call   1003b3 <__panic>

0010182a <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10182a:	55                   	push   %ebp
  10182b:	89 e5                	mov    %esp,%ebp
  10182d:	83 ec 10             	sub    $0x10,%esp
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
  101830:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101837:	e9 c3 00 00 00       	jmp    1018ff <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10183c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10183f:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101846:	89 c2                	mov    %eax,%edx
  101848:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184b:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101852:	00 
  101853:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101856:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10185d:	00 08 00 
  101860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101863:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10186a:	00 
  10186b:	83 e2 e0             	and    $0xffffffe0,%edx
  10186e:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101875:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101878:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10187f:	00 
  101880:	83 e2 1f             	and    $0x1f,%edx
  101883:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10188a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188d:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101894:	00 
  101895:	83 e2 f0             	and    $0xfffffff0,%edx
  101898:	83 ca 0e             	or     $0xe,%edx
  10189b:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a5:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018ac:	00 
  1018ad:	83 e2 ef             	and    $0xffffffef,%edx
  1018b0:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ba:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018c1:	00 
  1018c2:	83 e2 9f             	and    $0xffffff9f,%edx
  1018c5:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018cf:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018d6:	00 
  1018d7:	83 ca 80             	or     $0xffffff80,%edx
  1018da:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e4:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018eb:	c1 e8 10             	shr    $0x10,%eax
  1018ee:	89 c2                	mov    %eax,%edx
  1018f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f3:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018fa:	00 
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
  1018fb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018ff:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101906:	0f 8e 30 ff ff ff    	jle    10183c <idt_init+0x12>
  10190c:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101913:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101916:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }

    // 3. LIDT
    lidt(&idt_pd);
}
  101919:	90                   	nop
  10191a:	c9                   	leave  
  10191b:	c3                   	ret    

0010191c <trapname>:

static const char *
trapname(int trapno) {
  10191c:	55                   	push   %ebp
  10191d:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  10191f:	8b 45 08             	mov    0x8(%ebp),%eax
  101922:	83 f8 13             	cmp    $0x13,%eax
  101925:	77 0c                	ja     101933 <trapname+0x17>
        return excnames[trapno];
  101927:	8b 45 08             	mov    0x8(%ebp),%eax
  10192a:	8b 04 85 a0 3b 10 00 	mov    0x103ba0(,%eax,4),%eax
  101931:	eb 18                	jmp    10194b <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101933:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101937:	7e 0d                	jle    101946 <trapname+0x2a>
  101939:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10193d:	7f 07                	jg     101946 <trapname+0x2a>
        return "Hardware Interrupt";
  10193f:	b8 5f 38 10 00       	mov    $0x10385f,%eax
  101944:	eb 05                	jmp    10194b <trapname+0x2f>
    }
    return "(unknown trap)";
  101946:	b8 72 38 10 00       	mov    $0x103872,%eax
}
  10194b:	5d                   	pop    %ebp
  10194c:	c3                   	ret    

0010194d <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10194d:	55                   	push   %ebp
  10194e:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101950:	8b 45 08             	mov    0x8(%ebp),%eax
  101953:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101957:	66 83 f8 08          	cmp    $0x8,%ax
  10195b:	0f 94 c0             	sete   %al
  10195e:	0f b6 c0             	movzbl %al,%eax
}
  101961:	5d                   	pop    %ebp
  101962:	c3                   	ret    

00101963 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101963:	55                   	push   %ebp
  101964:	89 e5                	mov    %esp,%ebp
  101966:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101969:	83 ec 08             	sub    $0x8,%esp
  10196c:	ff 75 08             	pushl  0x8(%ebp)
  10196f:	68 b3 38 10 00       	push   $0x1038b3
  101974:	e8 d4 e8 ff ff       	call   10024d <cprintf>
  101979:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  10197c:	8b 45 08             	mov    0x8(%ebp),%eax
  10197f:	83 ec 0c             	sub    $0xc,%esp
  101982:	50                   	push   %eax
  101983:	e8 b8 01 00 00       	call   101b40 <print_regs>
  101988:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  10198b:	8b 45 08             	mov    0x8(%ebp),%eax
  10198e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101992:	0f b7 c0             	movzwl %ax,%eax
  101995:	83 ec 08             	sub    $0x8,%esp
  101998:	50                   	push   %eax
  101999:	68 c4 38 10 00       	push   $0x1038c4
  10199e:	e8 aa e8 ff ff       	call   10024d <cprintf>
  1019a3:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a9:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1019ad:	0f b7 c0             	movzwl %ax,%eax
  1019b0:	83 ec 08             	sub    $0x8,%esp
  1019b3:	50                   	push   %eax
  1019b4:	68 d7 38 10 00       	push   $0x1038d7
  1019b9:	e8 8f e8 ff ff       	call   10024d <cprintf>
  1019be:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c4:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1019c8:	0f b7 c0             	movzwl %ax,%eax
  1019cb:	83 ec 08             	sub    $0x8,%esp
  1019ce:	50                   	push   %eax
  1019cf:	68 ea 38 10 00       	push   $0x1038ea
  1019d4:	e8 74 e8 ff ff       	call   10024d <cprintf>
  1019d9:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1019df:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  1019e3:	0f b7 c0             	movzwl %ax,%eax
  1019e6:	83 ec 08             	sub    $0x8,%esp
  1019e9:	50                   	push   %eax
  1019ea:	68 fd 38 10 00       	push   $0x1038fd
  1019ef:	e8 59 e8 ff ff       	call   10024d <cprintf>
  1019f4:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fa:	8b 40 30             	mov    0x30(%eax),%eax
  1019fd:	83 ec 0c             	sub    $0xc,%esp
  101a00:	50                   	push   %eax
  101a01:	e8 16 ff ff ff       	call   10191c <trapname>
  101a06:	83 c4 10             	add    $0x10,%esp
  101a09:	89 c2                	mov    %eax,%edx
  101a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0e:	8b 40 30             	mov    0x30(%eax),%eax
  101a11:	83 ec 04             	sub    $0x4,%esp
  101a14:	52                   	push   %edx
  101a15:	50                   	push   %eax
  101a16:	68 10 39 10 00       	push   $0x103910
  101a1b:	e8 2d e8 ff ff       	call   10024d <cprintf>
  101a20:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a23:	8b 45 08             	mov    0x8(%ebp),%eax
  101a26:	8b 40 34             	mov    0x34(%eax),%eax
  101a29:	83 ec 08             	sub    $0x8,%esp
  101a2c:	50                   	push   %eax
  101a2d:	68 22 39 10 00       	push   $0x103922
  101a32:	e8 16 e8 ff ff       	call   10024d <cprintf>
  101a37:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3d:	8b 40 38             	mov    0x38(%eax),%eax
  101a40:	83 ec 08             	sub    $0x8,%esp
  101a43:	50                   	push   %eax
  101a44:	68 31 39 10 00       	push   $0x103931
  101a49:	e8 ff e7 ff ff       	call   10024d <cprintf>
  101a4e:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a51:	8b 45 08             	mov    0x8(%ebp),%eax
  101a54:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a58:	0f b7 c0             	movzwl %ax,%eax
  101a5b:	83 ec 08             	sub    $0x8,%esp
  101a5e:	50                   	push   %eax
  101a5f:	68 40 39 10 00       	push   $0x103940
  101a64:	e8 e4 e7 ff ff       	call   10024d <cprintf>
  101a69:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6f:	8b 40 40             	mov    0x40(%eax),%eax
  101a72:	83 ec 08             	sub    $0x8,%esp
  101a75:	50                   	push   %eax
  101a76:	68 53 39 10 00       	push   $0x103953
  101a7b:	e8 cd e7 ff ff       	call   10024d <cprintf>
  101a80:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101a8a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101a91:	eb 3f                	jmp    101ad2 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101a93:	8b 45 08             	mov    0x8(%ebp),%eax
  101a96:	8b 50 40             	mov    0x40(%eax),%edx
  101a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a9c:	21 d0                	and    %edx,%eax
  101a9e:	85 c0                	test   %eax,%eax
  101aa0:	74 29                	je     101acb <print_trapframe+0x168>
  101aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101aa5:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101aac:	85 c0                	test   %eax,%eax
  101aae:	74 1b                	je     101acb <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ab3:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101aba:	83 ec 08             	sub    $0x8,%esp
  101abd:	50                   	push   %eax
  101abe:	68 62 39 10 00       	push   $0x103962
  101ac3:	e8 85 e7 ff ff       	call   10024d <cprintf>
  101ac8:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101acb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101acf:	d1 65 f0             	shll   -0x10(%ebp)
  101ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ad5:	83 f8 17             	cmp    $0x17,%eax
  101ad8:	76 b9                	jbe    101a93 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101ada:	8b 45 08             	mov    0x8(%ebp),%eax
  101add:	8b 40 40             	mov    0x40(%eax),%eax
  101ae0:	25 00 30 00 00       	and    $0x3000,%eax
  101ae5:	c1 e8 0c             	shr    $0xc,%eax
  101ae8:	83 ec 08             	sub    $0x8,%esp
  101aeb:	50                   	push   %eax
  101aec:	68 66 39 10 00       	push   $0x103966
  101af1:	e8 57 e7 ff ff       	call   10024d <cprintf>
  101af6:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101af9:	83 ec 0c             	sub    $0xc,%esp
  101afc:	ff 75 08             	pushl  0x8(%ebp)
  101aff:	e8 49 fe ff ff       	call   10194d <trap_in_kernel>
  101b04:	83 c4 10             	add    $0x10,%esp
  101b07:	85 c0                	test   %eax,%eax
  101b09:	75 32                	jne    101b3d <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0e:	8b 40 44             	mov    0x44(%eax),%eax
  101b11:	83 ec 08             	sub    $0x8,%esp
  101b14:	50                   	push   %eax
  101b15:	68 6f 39 10 00       	push   $0x10396f
  101b1a:	e8 2e e7 ff ff       	call   10024d <cprintf>
  101b1f:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b22:	8b 45 08             	mov    0x8(%ebp),%eax
  101b25:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b29:	0f b7 c0             	movzwl %ax,%eax
  101b2c:	83 ec 08             	sub    $0x8,%esp
  101b2f:	50                   	push   %eax
  101b30:	68 7e 39 10 00       	push   $0x10397e
  101b35:	e8 13 e7 ff ff       	call   10024d <cprintf>
  101b3a:	83 c4 10             	add    $0x10,%esp
    }
}
  101b3d:	90                   	nop
  101b3e:	c9                   	leave  
  101b3f:	c3                   	ret    

00101b40 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b40:	55                   	push   %ebp
  101b41:	89 e5                	mov    %esp,%ebp
  101b43:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b46:	8b 45 08             	mov    0x8(%ebp),%eax
  101b49:	8b 00                	mov    (%eax),%eax
  101b4b:	83 ec 08             	sub    $0x8,%esp
  101b4e:	50                   	push   %eax
  101b4f:	68 91 39 10 00       	push   $0x103991
  101b54:	e8 f4 e6 ff ff       	call   10024d <cprintf>
  101b59:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5f:	8b 40 04             	mov    0x4(%eax),%eax
  101b62:	83 ec 08             	sub    $0x8,%esp
  101b65:	50                   	push   %eax
  101b66:	68 a0 39 10 00       	push   $0x1039a0
  101b6b:	e8 dd e6 ff ff       	call   10024d <cprintf>
  101b70:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101b73:	8b 45 08             	mov    0x8(%ebp),%eax
  101b76:	8b 40 08             	mov    0x8(%eax),%eax
  101b79:	83 ec 08             	sub    $0x8,%esp
  101b7c:	50                   	push   %eax
  101b7d:	68 af 39 10 00       	push   $0x1039af
  101b82:	e8 c6 e6 ff ff       	call   10024d <cprintf>
  101b87:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8d:	8b 40 0c             	mov    0xc(%eax),%eax
  101b90:	83 ec 08             	sub    $0x8,%esp
  101b93:	50                   	push   %eax
  101b94:	68 be 39 10 00       	push   $0x1039be
  101b99:	e8 af e6 ff ff       	call   10024d <cprintf>
  101b9e:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba4:	8b 40 10             	mov    0x10(%eax),%eax
  101ba7:	83 ec 08             	sub    $0x8,%esp
  101baa:	50                   	push   %eax
  101bab:	68 cd 39 10 00       	push   $0x1039cd
  101bb0:	e8 98 e6 ff ff       	call   10024d <cprintf>
  101bb5:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbb:	8b 40 14             	mov    0x14(%eax),%eax
  101bbe:	83 ec 08             	sub    $0x8,%esp
  101bc1:	50                   	push   %eax
  101bc2:	68 dc 39 10 00       	push   $0x1039dc
  101bc7:	e8 81 e6 ff ff       	call   10024d <cprintf>
  101bcc:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd2:	8b 40 18             	mov    0x18(%eax),%eax
  101bd5:	83 ec 08             	sub    $0x8,%esp
  101bd8:	50                   	push   %eax
  101bd9:	68 eb 39 10 00       	push   $0x1039eb
  101bde:	e8 6a e6 ff ff       	call   10024d <cprintf>
  101be3:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101be6:	8b 45 08             	mov    0x8(%ebp),%eax
  101be9:	8b 40 1c             	mov    0x1c(%eax),%eax
  101bec:	83 ec 08             	sub    $0x8,%esp
  101bef:	50                   	push   %eax
  101bf0:	68 fa 39 10 00       	push   $0x1039fa
  101bf5:	e8 53 e6 ff ff       	call   10024d <cprintf>
  101bfa:	83 c4 10             	add    $0x10,%esp
}
  101bfd:	90                   	nop
  101bfe:	c9                   	leave  
  101bff:	c3                   	ret    

00101c00 <trap_dispatch>:
struct trapframe tf_k_u;
struct trapframe* tf_u_k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c00:	55                   	push   %ebp
  101c01:	89 e5                	mov    %esp,%ebp
  101c03:	57                   	push   %edi
  101c04:	56                   	push   %esi
  101c05:	53                   	push   %ebx
  101c06:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    switch (tf->tf_trapno) {
  101c09:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0c:	8b 40 30             	mov    0x30(%eax),%eax
  101c0f:	83 f8 2f             	cmp    $0x2f,%eax
  101c12:	77 1d                	ja     101c31 <trap_dispatch+0x31>
  101c14:	83 f8 2e             	cmp    $0x2e,%eax
  101c17:	0f 83 c6 01 00 00    	jae    101de3 <trap_dispatch+0x1e3>
  101c1d:	83 f8 21             	cmp    $0x21,%eax
  101c20:	74 7c                	je     101c9e <trap_dispatch+0x9e>
  101c22:	83 f8 24             	cmp    $0x24,%eax
  101c25:	74 50                	je     101c77 <trap_dispatch+0x77>
  101c27:	83 f8 20             	cmp    $0x20,%eax
  101c2a:	74 1c                	je     101c48 <trap_dispatch+0x48>
  101c2c:	e9 7c 01 00 00       	jmp    101dad <trap_dispatch+0x1ad>
  101c31:	83 f8 78             	cmp    $0x78,%eax
  101c34:	0f 84 8b 00 00 00    	je     101cc5 <trap_dispatch+0xc5>
  101c3a:	83 f8 79             	cmp    $0x79,%eax
  101c3d:	0f 84 05 01 00 00    	je     101d48 <trap_dispatch+0x148>
  101c43:	e9 65 01 00 00       	jmp    101dad <trap_dispatch+0x1ad>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        // 1. record
        ticks++;
  101c48:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c4d:	83 c0 01             	add    $0x1,%eax
  101c50:	a3 08 f9 10 00       	mov    %eax,0x10f908

        // 2. print
        if (ticks >= 100) {
  101c55:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c5a:	83 f8 63             	cmp    $0x63,%eax
  101c5d:	0f 86 83 01 00 00    	jbe    101de6 <trap_dispatch+0x1e6>
            print_ticks();
  101c63:	e8 86 fb ff ff       	call   1017ee <print_ticks>
            ticks = 0;
  101c68:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  101c6f:	00 00 00 
        }

        // 3. too simple ?!
        break;
  101c72:	e9 6f 01 00 00       	jmp    101de6 <trap_dispatch+0x1e6>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101c77:	e8 45 f9 ff ff       	call   1015c1 <cons_getc>
  101c7c:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101c7f:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101c83:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101c87:	83 ec 04             	sub    $0x4,%esp
  101c8a:	52                   	push   %edx
  101c8b:	50                   	push   %eax
  101c8c:	68 09 3a 10 00       	push   $0x103a09
  101c91:	e8 b7 e5 ff ff       	call   10024d <cprintf>
  101c96:	83 c4 10             	add    $0x10,%esp
        break;
  101c99:	e9 49 01 00 00       	jmp    101de7 <trap_dispatch+0x1e7>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101c9e:	e8 1e f9 ff ff       	call   1015c1 <cons_getc>
  101ca3:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101ca6:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101caa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101cae:	83 ec 04             	sub    $0x4,%esp
  101cb1:	52                   	push   %edx
  101cb2:	50                   	push   %eax
  101cb3:	68 1b 3a 10 00       	push   $0x103a1b
  101cb8:	e8 90 e5 ff ff       	call   10024d <cprintf>
  101cbd:	83 c4 10             	add    $0x10,%esp
        break;
  101cc0:	e9 22 01 00 00       	jmp    101de7 <trap_dispatch+0x1e7>
    //LAB1 CHALLENGE 1 : 2015010062 you should modify below codes.
    case T_SWITCH_TOU:
        tf_k_u = *tf;
  101cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  101cc8:	b8 40 f9 10 00       	mov    $0x10f940,%eax
  101ccd:	89 d3                	mov    %edx,%ebx
  101ccf:	ba 4c 00 00 00       	mov    $0x4c,%edx
  101cd4:	8b 0b                	mov    (%ebx),%ecx
  101cd6:	89 08                	mov    %ecx,(%eax)
  101cd8:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  101cdc:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  101ce0:	8d 78 04             	lea    0x4(%eax),%edi
  101ce3:	83 e7 fc             	and    $0xfffffffc,%edi
  101ce6:	29 f8                	sub    %edi,%eax
  101ce8:	29 c3                	sub    %eax,%ebx
  101cea:	01 c2                	add    %eax,%edx
  101cec:	83 e2 fc             	and    $0xfffffffc,%edx
  101cef:	89 d0                	mov    %edx,%eax
  101cf1:	c1 e8 02             	shr    $0x2,%eax
  101cf4:	89 de                	mov    %ebx,%esi
  101cf6:	89 c1                	mov    %eax,%ecx
  101cf8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        tf_k_u.tf_cs = USER_CS;
  101cfa:	66 c7 05 7c f9 10 00 	movw   $0x1b,0x10f97c
  101d01:	1b 00 
        tf_k_u.tf_ds = USER_DS;
  101d03:	66 c7 05 6c f9 10 00 	movw   $0x23,0x10f96c
  101d0a:	23 00 
        tf_k_u.tf_es = USER_DS;
  101d0c:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101d13:	23 00 
        tf_k_u.tf_ss = USER_DS;
  101d15:	66 c7 05 88 f9 10 00 	movw   $0x23,0x10f988
  101d1c:	23 00 

        tf_k_u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d21:	83 c0 44             	add    $0x44,%eax
  101d24:	a3 84 f9 10 00       	mov    %eax,0x10f984
		
        // set eflags, make sure ucore can use io under user mode.
        // if CPL > IOPL, then cpu will generate a general protection.
        tf_k_u.tf_eflags |= FL_IOPL_MASK;
  101d29:	a1 80 f9 10 00       	mov    0x10f980,%eax
  101d2e:	80 cc 30             	or     $0x30,%ah
  101d31:	a3 80 f9 10 00       	mov    %eax,0x10f980
    
        // set temporary stack
        // then iret will jump to the right stack
        *((uint32_t *)tf - 1) = (uint32_t)&tf_k_u;
  101d36:	8b 45 08             	mov    0x8(%ebp),%eax
  101d39:	83 e8 04             	sub    $0x4,%eax
  101d3c:	ba 40 f9 10 00       	mov    $0x10f940,%edx
  101d41:	89 10                	mov    %edx,(%eax)
        break;
  101d43:	e9 9f 00 00 00       	jmp    101de7 <trap_dispatch+0x1e7>
    case T_SWITCH_TOK:
        // panic("T_SWITCH_** ??\n");
        tf->tf_cs = KERNEL_CS;
  101d48:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4b:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = tf->tf_es = KERNEL_DS;
  101d51:	8b 45 08             	mov    0x8(%ebp),%eax
  101d54:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5d:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101d61:	8b 45 08             	mov    0x8(%ebp),%eax
  101d64:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
  101d68:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6b:	8b 40 40             	mov    0x40(%eax),%eax
  101d6e:	80 e4 cf             	and    $0xcf,%ah
  101d71:	89 c2                	mov    %eax,%edx
  101d73:	8b 45 08             	mov    0x8(%ebp),%eax
  101d76:	89 50 40             	mov    %edx,0x40(%eax)
        tf_u_k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101d79:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7c:	8b 40 44             	mov    0x44(%eax),%eax
  101d7f:	83 e8 44             	sub    $0x44,%eax
  101d82:	a3 20 f9 10 00       	mov    %eax,0x10f920
        memmove(tf_u_k, tf, sizeof(struct trapframe) - 8);
  101d87:	a1 20 f9 10 00       	mov    0x10f920,%eax
  101d8c:	83 ec 04             	sub    $0x4,%esp
  101d8f:	6a 44                	push   $0x44
  101d91:	ff 75 08             	pushl  0x8(%ebp)
  101d94:	50                   	push   %eax
  101d95:	e8 b5 0f 00 00       	call   102d4f <memmove>
  101d9a:	83 c4 10             	add    $0x10,%esp
        *((uint32_t *)tf - 1) = (uint32_t)tf_u_k;
  101d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101da0:	83 e8 04             	sub    $0x4,%eax
  101da3:	8b 15 20 f9 10 00    	mov    0x10f920,%edx
  101da9:	89 10                	mov    %edx,(%eax)
        break;
  101dab:	eb 3a                	jmp    101de7 <trap_dispatch+0x1e7>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101dad:	8b 45 08             	mov    0x8(%ebp),%eax
  101db0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101db4:	0f b7 c0             	movzwl %ax,%eax
  101db7:	83 e0 03             	and    $0x3,%eax
  101dba:	85 c0                	test   %eax,%eax
  101dbc:	75 29                	jne    101de7 <trap_dispatch+0x1e7>
            print_trapframe(tf);
  101dbe:	83 ec 0c             	sub    $0xc,%esp
  101dc1:	ff 75 08             	pushl  0x8(%ebp)
  101dc4:	e8 9a fb ff ff       	call   101963 <print_trapframe>
  101dc9:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101dcc:	83 ec 04             	sub    $0x4,%esp
  101dcf:	68 2a 3a 10 00       	push   $0x103a2a
  101dd4:	68 db 00 00 00       	push   $0xdb
  101dd9:	68 4e 38 10 00       	push   $0x10384e
  101dde:	e8 d0 e5 ff ff       	call   1003b3 <__panic>
        *((uint32_t *)tf - 1) = (uint32_t)tf_u_k;
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101de3:	90                   	nop
  101de4:	eb 01                	jmp    101de7 <trap_dispatch+0x1e7>
            print_ticks();
            ticks = 0;
        }

        // 3. too simple ?!
        break;
  101de6:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101de7:	90                   	nop
  101de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  101deb:	5b                   	pop    %ebx
  101dec:	5e                   	pop    %esi
  101ded:	5f                   	pop    %edi
  101dee:	5d                   	pop    %ebp
  101def:	c3                   	ret    

00101df0 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101df0:	55                   	push   %ebp
  101df1:	89 e5                	mov    %esp,%ebp
  101df3:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101df6:	83 ec 0c             	sub    $0xc,%esp
  101df9:	ff 75 08             	pushl  0x8(%ebp)
  101dfc:	e8 ff fd ff ff       	call   101c00 <trap_dispatch>
  101e01:	83 c4 10             	add    $0x10,%esp
}
  101e04:	90                   	nop
  101e05:	c9                   	leave  
  101e06:	c3                   	ret    

00101e07 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e07:	6a 00                	push   $0x0
  pushl $0
  101e09:	6a 00                	push   $0x0
  jmp __alltraps
  101e0b:	e9 69 0a 00 00       	jmp    102879 <__alltraps>

00101e10 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e10:	6a 00                	push   $0x0
  pushl $1
  101e12:	6a 01                	push   $0x1
  jmp __alltraps
  101e14:	e9 60 0a 00 00       	jmp    102879 <__alltraps>

00101e19 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e19:	6a 00                	push   $0x0
  pushl $2
  101e1b:	6a 02                	push   $0x2
  jmp __alltraps
  101e1d:	e9 57 0a 00 00       	jmp    102879 <__alltraps>

00101e22 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e22:	6a 00                	push   $0x0
  pushl $3
  101e24:	6a 03                	push   $0x3
  jmp __alltraps
  101e26:	e9 4e 0a 00 00       	jmp    102879 <__alltraps>

00101e2b <vector4>:
.globl vector4
vector4:
  pushl $0
  101e2b:	6a 00                	push   $0x0
  pushl $4
  101e2d:	6a 04                	push   $0x4
  jmp __alltraps
  101e2f:	e9 45 0a 00 00       	jmp    102879 <__alltraps>

00101e34 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e34:	6a 00                	push   $0x0
  pushl $5
  101e36:	6a 05                	push   $0x5
  jmp __alltraps
  101e38:	e9 3c 0a 00 00       	jmp    102879 <__alltraps>

00101e3d <vector6>:
.globl vector6
vector6:
  pushl $0
  101e3d:	6a 00                	push   $0x0
  pushl $6
  101e3f:	6a 06                	push   $0x6
  jmp __alltraps
  101e41:	e9 33 0a 00 00       	jmp    102879 <__alltraps>

00101e46 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e46:	6a 00                	push   $0x0
  pushl $7
  101e48:	6a 07                	push   $0x7
  jmp __alltraps
  101e4a:	e9 2a 0a 00 00       	jmp    102879 <__alltraps>

00101e4f <vector8>:
.globl vector8
vector8:
  pushl $8
  101e4f:	6a 08                	push   $0x8
  jmp __alltraps
  101e51:	e9 23 0a 00 00       	jmp    102879 <__alltraps>

00101e56 <vector9>:
.globl vector9
vector9:
  pushl $0
  101e56:	6a 00                	push   $0x0
  pushl $9
  101e58:	6a 09                	push   $0x9
  jmp __alltraps
  101e5a:	e9 1a 0a 00 00       	jmp    102879 <__alltraps>

00101e5f <vector10>:
.globl vector10
vector10:
  pushl $10
  101e5f:	6a 0a                	push   $0xa
  jmp __alltraps
  101e61:	e9 13 0a 00 00       	jmp    102879 <__alltraps>

00101e66 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e66:	6a 0b                	push   $0xb
  jmp __alltraps
  101e68:	e9 0c 0a 00 00       	jmp    102879 <__alltraps>

00101e6d <vector12>:
.globl vector12
vector12:
  pushl $12
  101e6d:	6a 0c                	push   $0xc
  jmp __alltraps
  101e6f:	e9 05 0a 00 00       	jmp    102879 <__alltraps>

00101e74 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e74:	6a 0d                	push   $0xd
  jmp __alltraps
  101e76:	e9 fe 09 00 00       	jmp    102879 <__alltraps>

00101e7b <vector14>:
.globl vector14
vector14:
  pushl $14
  101e7b:	6a 0e                	push   $0xe
  jmp __alltraps
  101e7d:	e9 f7 09 00 00       	jmp    102879 <__alltraps>

00101e82 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e82:	6a 00                	push   $0x0
  pushl $15
  101e84:	6a 0f                	push   $0xf
  jmp __alltraps
  101e86:	e9 ee 09 00 00       	jmp    102879 <__alltraps>

00101e8b <vector16>:
.globl vector16
vector16:
  pushl $0
  101e8b:	6a 00                	push   $0x0
  pushl $16
  101e8d:	6a 10                	push   $0x10
  jmp __alltraps
  101e8f:	e9 e5 09 00 00       	jmp    102879 <__alltraps>

00101e94 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e94:	6a 11                	push   $0x11
  jmp __alltraps
  101e96:	e9 de 09 00 00       	jmp    102879 <__alltraps>

00101e9b <vector18>:
.globl vector18
vector18:
  pushl $0
  101e9b:	6a 00                	push   $0x0
  pushl $18
  101e9d:	6a 12                	push   $0x12
  jmp __alltraps
  101e9f:	e9 d5 09 00 00       	jmp    102879 <__alltraps>

00101ea4 <vector19>:
.globl vector19
vector19:
  pushl $0
  101ea4:	6a 00                	push   $0x0
  pushl $19
  101ea6:	6a 13                	push   $0x13
  jmp __alltraps
  101ea8:	e9 cc 09 00 00       	jmp    102879 <__alltraps>

00101ead <vector20>:
.globl vector20
vector20:
  pushl $0
  101ead:	6a 00                	push   $0x0
  pushl $20
  101eaf:	6a 14                	push   $0x14
  jmp __alltraps
  101eb1:	e9 c3 09 00 00       	jmp    102879 <__alltraps>

00101eb6 <vector21>:
.globl vector21
vector21:
  pushl $0
  101eb6:	6a 00                	push   $0x0
  pushl $21
  101eb8:	6a 15                	push   $0x15
  jmp __alltraps
  101eba:	e9 ba 09 00 00       	jmp    102879 <__alltraps>

00101ebf <vector22>:
.globl vector22
vector22:
  pushl $0
  101ebf:	6a 00                	push   $0x0
  pushl $22
  101ec1:	6a 16                	push   $0x16
  jmp __alltraps
  101ec3:	e9 b1 09 00 00       	jmp    102879 <__alltraps>

00101ec8 <vector23>:
.globl vector23
vector23:
  pushl $0
  101ec8:	6a 00                	push   $0x0
  pushl $23
  101eca:	6a 17                	push   $0x17
  jmp __alltraps
  101ecc:	e9 a8 09 00 00       	jmp    102879 <__alltraps>

00101ed1 <vector24>:
.globl vector24
vector24:
  pushl $0
  101ed1:	6a 00                	push   $0x0
  pushl $24
  101ed3:	6a 18                	push   $0x18
  jmp __alltraps
  101ed5:	e9 9f 09 00 00       	jmp    102879 <__alltraps>

00101eda <vector25>:
.globl vector25
vector25:
  pushl $0
  101eda:	6a 00                	push   $0x0
  pushl $25
  101edc:	6a 19                	push   $0x19
  jmp __alltraps
  101ede:	e9 96 09 00 00       	jmp    102879 <__alltraps>

00101ee3 <vector26>:
.globl vector26
vector26:
  pushl $0
  101ee3:	6a 00                	push   $0x0
  pushl $26
  101ee5:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ee7:	e9 8d 09 00 00       	jmp    102879 <__alltraps>

00101eec <vector27>:
.globl vector27
vector27:
  pushl $0
  101eec:	6a 00                	push   $0x0
  pushl $27
  101eee:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ef0:	e9 84 09 00 00       	jmp    102879 <__alltraps>

00101ef5 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ef5:	6a 00                	push   $0x0
  pushl $28
  101ef7:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ef9:	e9 7b 09 00 00       	jmp    102879 <__alltraps>

00101efe <vector29>:
.globl vector29
vector29:
  pushl $0
  101efe:	6a 00                	push   $0x0
  pushl $29
  101f00:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f02:	e9 72 09 00 00       	jmp    102879 <__alltraps>

00101f07 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f07:	6a 00                	push   $0x0
  pushl $30
  101f09:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f0b:	e9 69 09 00 00       	jmp    102879 <__alltraps>

00101f10 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f10:	6a 00                	push   $0x0
  pushl $31
  101f12:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f14:	e9 60 09 00 00       	jmp    102879 <__alltraps>

00101f19 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f19:	6a 00                	push   $0x0
  pushl $32
  101f1b:	6a 20                	push   $0x20
  jmp __alltraps
  101f1d:	e9 57 09 00 00       	jmp    102879 <__alltraps>

00101f22 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f22:	6a 00                	push   $0x0
  pushl $33
  101f24:	6a 21                	push   $0x21
  jmp __alltraps
  101f26:	e9 4e 09 00 00       	jmp    102879 <__alltraps>

00101f2b <vector34>:
.globl vector34
vector34:
  pushl $0
  101f2b:	6a 00                	push   $0x0
  pushl $34
  101f2d:	6a 22                	push   $0x22
  jmp __alltraps
  101f2f:	e9 45 09 00 00       	jmp    102879 <__alltraps>

00101f34 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f34:	6a 00                	push   $0x0
  pushl $35
  101f36:	6a 23                	push   $0x23
  jmp __alltraps
  101f38:	e9 3c 09 00 00       	jmp    102879 <__alltraps>

00101f3d <vector36>:
.globl vector36
vector36:
  pushl $0
  101f3d:	6a 00                	push   $0x0
  pushl $36
  101f3f:	6a 24                	push   $0x24
  jmp __alltraps
  101f41:	e9 33 09 00 00       	jmp    102879 <__alltraps>

00101f46 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $37
  101f48:	6a 25                	push   $0x25
  jmp __alltraps
  101f4a:	e9 2a 09 00 00       	jmp    102879 <__alltraps>

00101f4f <vector38>:
.globl vector38
vector38:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $38
  101f51:	6a 26                	push   $0x26
  jmp __alltraps
  101f53:	e9 21 09 00 00       	jmp    102879 <__alltraps>

00101f58 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $39
  101f5a:	6a 27                	push   $0x27
  jmp __alltraps
  101f5c:	e9 18 09 00 00       	jmp    102879 <__alltraps>

00101f61 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $40
  101f63:	6a 28                	push   $0x28
  jmp __alltraps
  101f65:	e9 0f 09 00 00       	jmp    102879 <__alltraps>

00101f6a <vector41>:
.globl vector41
vector41:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $41
  101f6c:	6a 29                	push   $0x29
  jmp __alltraps
  101f6e:	e9 06 09 00 00       	jmp    102879 <__alltraps>

00101f73 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $42
  101f75:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f77:	e9 fd 08 00 00       	jmp    102879 <__alltraps>

00101f7c <vector43>:
.globl vector43
vector43:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $43
  101f7e:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f80:	e9 f4 08 00 00       	jmp    102879 <__alltraps>

00101f85 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $44
  101f87:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f89:	e9 eb 08 00 00       	jmp    102879 <__alltraps>

00101f8e <vector45>:
.globl vector45
vector45:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $45
  101f90:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f92:	e9 e2 08 00 00       	jmp    102879 <__alltraps>

00101f97 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $46
  101f99:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f9b:	e9 d9 08 00 00       	jmp    102879 <__alltraps>

00101fa0 <vector47>:
.globl vector47
vector47:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $47
  101fa2:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fa4:	e9 d0 08 00 00       	jmp    102879 <__alltraps>

00101fa9 <vector48>:
.globl vector48
vector48:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $48
  101fab:	6a 30                	push   $0x30
  jmp __alltraps
  101fad:	e9 c7 08 00 00       	jmp    102879 <__alltraps>

00101fb2 <vector49>:
.globl vector49
vector49:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $49
  101fb4:	6a 31                	push   $0x31
  jmp __alltraps
  101fb6:	e9 be 08 00 00       	jmp    102879 <__alltraps>

00101fbb <vector50>:
.globl vector50
vector50:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $50
  101fbd:	6a 32                	push   $0x32
  jmp __alltraps
  101fbf:	e9 b5 08 00 00       	jmp    102879 <__alltraps>

00101fc4 <vector51>:
.globl vector51
vector51:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $51
  101fc6:	6a 33                	push   $0x33
  jmp __alltraps
  101fc8:	e9 ac 08 00 00       	jmp    102879 <__alltraps>

00101fcd <vector52>:
.globl vector52
vector52:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $52
  101fcf:	6a 34                	push   $0x34
  jmp __alltraps
  101fd1:	e9 a3 08 00 00       	jmp    102879 <__alltraps>

00101fd6 <vector53>:
.globl vector53
vector53:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $53
  101fd8:	6a 35                	push   $0x35
  jmp __alltraps
  101fda:	e9 9a 08 00 00       	jmp    102879 <__alltraps>

00101fdf <vector54>:
.globl vector54
vector54:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $54
  101fe1:	6a 36                	push   $0x36
  jmp __alltraps
  101fe3:	e9 91 08 00 00       	jmp    102879 <__alltraps>

00101fe8 <vector55>:
.globl vector55
vector55:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $55
  101fea:	6a 37                	push   $0x37
  jmp __alltraps
  101fec:	e9 88 08 00 00       	jmp    102879 <__alltraps>

00101ff1 <vector56>:
.globl vector56
vector56:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $56
  101ff3:	6a 38                	push   $0x38
  jmp __alltraps
  101ff5:	e9 7f 08 00 00       	jmp    102879 <__alltraps>

00101ffa <vector57>:
.globl vector57
vector57:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $57
  101ffc:	6a 39                	push   $0x39
  jmp __alltraps
  101ffe:	e9 76 08 00 00       	jmp    102879 <__alltraps>

00102003 <vector58>:
.globl vector58
vector58:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $58
  102005:	6a 3a                	push   $0x3a
  jmp __alltraps
  102007:	e9 6d 08 00 00       	jmp    102879 <__alltraps>

0010200c <vector59>:
.globl vector59
vector59:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $59
  10200e:	6a 3b                	push   $0x3b
  jmp __alltraps
  102010:	e9 64 08 00 00       	jmp    102879 <__alltraps>

00102015 <vector60>:
.globl vector60
vector60:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $60
  102017:	6a 3c                	push   $0x3c
  jmp __alltraps
  102019:	e9 5b 08 00 00       	jmp    102879 <__alltraps>

0010201e <vector61>:
.globl vector61
vector61:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $61
  102020:	6a 3d                	push   $0x3d
  jmp __alltraps
  102022:	e9 52 08 00 00       	jmp    102879 <__alltraps>

00102027 <vector62>:
.globl vector62
vector62:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $62
  102029:	6a 3e                	push   $0x3e
  jmp __alltraps
  10202b:	e9 49 08 00 00       	jmp    102879 <__alltraps>

00102030 <vector63>:
.globl vector63
vector63:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $63
  102032:	6a 3f                	push   $0x3f
  jmp __alltraps
  102034:	e9 40 08 00 00       	jmp    102879 <__alltraps>

00102039 <vector64>:
.globl vector64
vector64:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $64
  10203b:	6a 40                	push   $0x40
  jmp __alltraps
  10203d:	e9 37 08 00 00       	jmp    102879 <__alltraps>

00102042 <vector65>:
.globl vector65
vector65:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $65
  102044:	6a 41                	push   $0x41
  jmp __alltraps
  102046:	e9 2e 08 00 00       	jmp    102879 <__alltraps>

0010204b <vector66>:
.globl vector66
vector66:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $66
  10204d:	6a 42                	push   $0x42
  jmp __alltraps
  10204f:	e9 25 08 00 00       	jmp    102879 <__alltraps>

00102054 <vector67>:
.globl vector67
vector67:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $67
  102056:	6a 43                	push   $0x43
  jmp __alltraps
  102058:	e9 1c 08 00 00       	jmp    102879 <__alltraps>

0010205d <vector68>:
.globl vector68
vector68:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $68
  10205f:	6a 44                	push   $0x44
  jmp __alltraps
  102061:	e9 13 08 00 00       	jmp    102879 <__alltraps>

00102066 <vector69>:
.globl vector69
vector69:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $69
  102068:	6a 45                	push   $0x45
  jmp __alltraps
  10206a:	e9 0a 08 00 00       	jmp    102879 <__alltraps>

0010206f <vector70>:
.globl vector70
vector70:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $70
  102071:	6a 46                	push   $0x46
  jmp __alltraps
  102073:	e9 01 08 00 00       	jmp    102879 <__alltraps>

00102078 <vector71>:
.globl vector71
vector71:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $71
  10207a:	6a 47                	push   $0x47
  jmp __alltraps
  10207c:	e9 f8 07 00 00       	jmp    102879 <__alltraps>

00102081 <vector72>:
.globl vector72
vector72:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $72
  102083:	6a 48                	push   $0x48
  jmp __alltraps
  102085:	e9 ef 07 00 00       	jmp    102879 <__alltraps>

0010208a <vector73>:
.globl vector73
vector73:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $73
  10208c:	6a 49                	push   $0x49
  jmp __alltraps
  10208e:	e9 e6 07 00 00       	jmp    102879 <__alltraps>

00102093 <vector74>:
.globl vector74
vector74:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $74
  102095:	6a 4a                	push   $0x4a
  jmp __alltraps
  102097:	e9 dd 07 00 00       	jmp    102879 <__alltraps>

0010209c <vector75>:
.globl vector75
vector75:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $75
  10209e:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020a0:	e9 d4 07 00 00       	jmp    102879 <__alltraps>

001020a5 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $76
  1020a7:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020a9:	e9 cb 07 00 00       	jmp    102879 <__alltraps>

001020ae <vector77>:
.globl vector77
vector77:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $77
  1020b0:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020b2:	e9 c2 07 00 00       	jmp    102879 <__alltraps>

001020b7 <vector78>:
.globl vector78
vector78:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $78
  1020b9:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020bb:	e9 b9 07 00 00       	jmp    102879 <__alltraps>

001020c0 <vector79>:
.globl vector79
vector79:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $79
  1020c2:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020c4:	e9 b0 07 00 00       	jmp    102879 <__alltraps>

001020c9 <vector80>:
.globl vector80
vector80:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $80
  1020cb:	6a 50                	push   $0x50
  jmp __alltraps
  1020cd:	e9 a7 07 00 00       	jmp    102879 <__alltraps>

001020d2 <vector81>:
.globl vector81
vector81:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $81
  1020d4:	6a 51                	push   $0x51
  jmp __alltraps
  1020d6:	e9 9e 07 00 00       	jmp    102879 <__alltraps>

001020db <vector82>:
.globl vector82
vector82:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $82
  1020dd:	6a 52                	push   $0x52
  jmp __alltraps
  1020df:	e9 95 07 00 00       	jmp    102879 <__alltraps>

001020e4 <vector83>:
.globl vector83
vector83:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $83
  1020e6:	6a 53                	push   $0x53
  jmp __alltraps
  1020e8:	e9 8c 07 00 00       	jmp    102879 <__alltraps>

001020ed <vector84>:
.globl vector84
vector84:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $84
  1020ef:	6a 54                	push   $0x54
  jmp __alltraps
  1020f1:	e9 83 07 00 00       	jmp    102879 <__alltraps>

001020f6 <vector85>:
.globl vector85
vector85:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $85
  1020f8:	6a 55                	push   $0x55
  jmp __alltraps
  1020fa:	e9 7a 07 00 00       	jmp    102879 <__alltraps>

001020ff <vector86>:
.globl vector86
vector86:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $86
  102101:	6a 56                	push   $0x56
  jmp __alltraps
  102103:	e9 71 07 00 00       	jmp    102879 <__alltraps>

00102108 <vector87>:
.globl vector87
vector87:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $87
  10210a:	6a 57                	push   $0x57
  jmp __alltraps
  10210c:	e9 68 07 00 00       	jmp    102879 <__alltraps>

00102111 <vector88>:
.globl vector88
vector88:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $88
  102113:	6a 58                	push   $0x58
  jmp __alltraps
  102115:	e9 5f 07 00 00       	jmp    102879 <__alltraps>

0010211a <vector89>:
.globl vector89
vector89:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $89
  10211c:	6a 59                	push   $0x59
  jmp __alltraps
  10211e:	e9 56 07 00 00       	jmp    102879 <__alltraps>

00102123 <vector90>:
.globl vector90
vector90:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $90
  102125:	6a 5a                	push   $0x5a
  jmp __alltraps
  102127:	e9 4d 07 00 00       	jmp    102879 <__alltraps>

0010212c <vector91>:
.globl vector91
vector91:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $91
  10212e:	6a 5b                	push   $0x5b
  jmp __alltraps
  102130:	e9 44 07 00 00       	jmp    102879 <__alltraps>

00102135 <vector92>:
.globl vector92
vector92:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $92
  102137:	6a 5c                	push   $0x5c
  jmp __alltraps
  102139:	e9 3b 07 00 00       	jmp    102879 <__alltraps>

0010213e <vector93>:
.globl vector93
vector93:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $93
  102140:	6a 5d                	push   $0x5d
  jmp __alltraps
  102142:	e9 32 07 00 00       	jmp    102879 <__alltraps>

00102147 <vector94>:
.globl vector94
vector94:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $94
  102149:	6a 5e                	push   $0x5e
  jmp __alltraps
  10214b:	e9 29 07 00 00       	jmp    102879 <__alltraps>

00102150 <vector95>:
.globl vector95
vector95:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $95
  102152:	6a 5f                	push   $0x5f
  jmp __alltraps
  102154:	e9 20 07 00 00       	jmp    102879 <__alltraps>

00102159 <vector96>:
.globl vector96
vector96:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $96
  10215b:	6a 60                	push   $0x60
  jmp __alltraps
  10215d:	e9 17 07 00 00       	jmp    102879 <__alltraps>

00102162 <vector97>:
.globl vector97
vector97:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $97
  102164:	6a 61                	push   $0x61
  jmp __alltraps
  102166:	e9 0e 07 00 00       	jmp    102879 <__alltraps>

0010216b <vector98>:
.globl vector98
vector98:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $98
  10216d:	6a 62                	push   $0x62
  jmp __alltraps
  10216f:	e9 05 07 00 00       	jmp    102879 <__alltraps>

00102174 <vector99>:
.globl vector99
vector99:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $99
  102176:	6a 63                	push   $0x63
  jmp __alltraps
  102178:	e9 fc 06 00 00       	jmp    102879 <__alltraps>

0010217d <vector100>:
.globl vector100
vector100:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $100
  10217f:	6a 64                	push   $0x64
  jmp __alltraps
  102181:	e9 f3 06 00 00       	jmp    102879 <__alltraps>

00102186 <vector101>:
.globl vector101
vector101:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $101
  102188:	6a 65                	push   $0x65
  jmp __alltraps
  10218a:	e9 ea 06 00 00       	jmp    102879 <__alltraps>

0010218f <vector102>:
.globl vector102
vector102:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $102
  102191:	6a 66                	push   $0x66
  jmp __alltraps
  102193:	e9 e1 06 00 00       	jmp    102879 <__alltraps>

00102198 <vector103>:
.globl vector103
vector103:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $103
  10219a:	6a 67                	push   $0x67
  jmp __alltraps
  10219c:	e9 d8 06 00 00       	jmp    102879 <__alltraps>

001021a1 <vector104>:
.globl vector104
vector104:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $104
  1021a3:	6a 68                	push   $0x68
  jmp __alltraps
  1021a5:	e9 cf 06 00 00       	jmp    102879 <__alltraps>

001021aa <vector105>:
.globl vector105
vector105:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $105
  1021ac:	6a 69                	push   $0x69
  jmp __alltraps
  1021ae:	e9 c6 06 00 00       	jmp    102879 <__alltraps>

001021b3 <vector106>:
.globl vector106
vector106:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $106
  1021b5:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021b7:	e9 bd 06 00 00       	jmp    102879 <__alltraps>

001021bc <vector107>:
.globl vector107
vector107:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $107
  1021be:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021c0:	e9 b4 06 00 00       	jmp    102879 <__alltraps>

001021c5 <vector108>:
.globl vector108
vector108:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $108
  1021c7:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021c9:	e9 ab 06 00 00       	jmp    102879 <__alltraps>

001021ce <vector109>:
.globl vector109
vector109:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $109
  1021d0:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021d2:	e9 a2 06 00 00       	jmp    102879 <__alltraps>

001021d7 <vector110>:
.globl vector110
vector110:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $110
  1021d9:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021db:	e9 99 06 00 00       	jmp    102879 <__alltraps>

001021e0 <vector111>:
.globl vector111
vector111:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $111
  1021e2:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021e4:	e9 90 06 00 00       	jmp    102879 <__alltraps>

001021e9 <vector112>:
.globl vector112
vector112:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $112
  1021eb:	6a 70                	push   $0x70
  jmp __alltraps
  1021ed:	e9 87 06 00 00       	jmp    102879 <__alltraps>

001021f2 <vector113>:
.globl vector113
vector113:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $113
  1021f4:	6a 71                	push   $0x71
  jmp __alltraps
  1021f6:	e9 7e 06 00 00       	jmp    102879 <__alltraps>

001021fb <vector114>:
.globl vector114
vector114:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $114
  1021fd:	6a 72                	push   $0x72
  jmp __alltraps
  1021ff:	e9 75 06 00 00       	jmp    102879 <__alltraps>

00102204 <vector115>:
.globl vector115
vector115:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $115
  102206:	6a 73                	push   $0x73
  jmp __alltraps
  102208:	e9 6c 06 00 00       	jmp    102879 <__alltraps>

0010220d <vector116>:
.globl vector116
vector116:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $116
  10220f:	6a 74                	push   $0x74
  jmp __alltraps
  102211:	e9 63 06 00 00       	jmp    102879 <__alltraps>

00102216 <vector117>:
.globl vector117
vector117:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $117
  102218:	6a 75                	push   $0x75
  jmp __alltraps
  10221a:	e9 5a 06 00 00       	jmp    102879 <__alltraps>

0010221f <vector118>:
.globl vector118
vector118:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $118
  102221:	6a 76                	push   $0x76
  jmp __alltraps
  102223:	e9 51 06 00 00       	jmp    102879 <__alltraps>

00102228 <vector119>:
.globl vector119
vector119:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $119
  10222a:	6a 77                	push   $0x77
  jmp __alltraps
  10222c:	e9 48 06 00 00       	jmp    102879 <__alltraps>

00102231 <vector120>:
.globl vector120
vector120:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $120
  102233:	6a 78                	push   $0x78
  jmp __alltraps
  102235:	e9 3f 06 00 00       	jmp    102879 <__alltraps>

0010223a <vector121>:
.globl vector121
vector121:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $121
  10223c:	6a 79                	push   $0x79
  jmp __alltraps
  10223e:	e9 36 06 00 00       	jmp    102879 <__alltraps>

00102243 <vector122>:
.globl vector122
vector122:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $122
  102245:	6a 7a                	push   $0x7a
  jmp __alltraps
  102247:	e9 2d 06 00 00       	jmp    102879 <__alltraps>

0010224c <vector123>:
.globl vector123
vector123:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $123
  10224e:	6a 7b                	push   $0x7b
  jmp __alltraps
  102250:	e9 24 06 00 00       	jmp    102879 <__alltraps>

00102255 <vector124>:
.globl vector124
vector124:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $124
  102257:	6a 7c                	push   $0x7c
  jmp __alltraps
  102259:	e9 1b 06 00 00       	jmp    102879 <__alltraps>

0010225e <vector125>:
.globl vector125
vector125:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $125
  102260:	6a 7d                	push   $0x7d
  jmp __alltraps
  102262:	e9 12 06 00 00       	jmp    102879 <__alltraps>

00102267 <vector126>:
.globl vector126
vector126:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $126
  102269:	6a 7e                	push   $0x7e
  jmp __alltraps
  10226b:	e9 09 06 00 00       	jmp    102879 <__alltraps>

00102270 <vector127>:
.globl vector127
vector127:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $127
  102272:	6a 7f                	push   $0x7f
  jmp __alltraps
  102274:	e9 00 06 00 00       	jmp    102879 <__alltraps>

00102279 <vector128>:
.globl vector128
vector128:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $128
  10227b:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102280:	e9 f4 05 00 00       	jmp    102879 <__alltraps>

00102285 <vector129>:
.globl vector129
vector129:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $129
  102287:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10228c:	e9 e8 05 00 00       	jmp    102879 <__alltraps>

00102291 <vector130>:
.globl vector130
vector130:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $130
  102293:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102298:	e9 dc 05 00 00       	jmp    102879 <__alltraps>

0010229d <vector131>:
.globl vector131
vector131:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $131
  10229f:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022a4:	e9 d0 05 00 00       	jmp    102879 <__alltraps>

001022a9 <vector132>:
.globl vector132
vector132:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $132
  1022ab:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022b0:	e9 c4 05 00 00       	jmp    102879 <__alltraps>

001022b5 <vector133>:
.globl vector133
vector133:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $133
  1022b7:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022bc:	e9 b8 05 00 00       	jmp    102879 <__alltraps>

001022c1 <vector134>:
.globl vector134
vector134:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $134
  1022c3:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022c8:	e9 ac 05 00 00       	jmp    102879 <__alltraps>

001022cd <vector135>:
.globl vector135
vector135:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $135
  1022cf:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022d4:	e9 a0 05 00 00       	jmp    102879 <__alltraps>

001022d9 <vector136>:
.globl vector136
vector136:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $136
  1022db:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022e0:	e9 94 05 00 00       	jmp    102879 <__alltraps>

001022e5 <vector137>:
.globl vector137
vector137:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $137
  1022e7:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022ec:	e9 88 05 00 00       	jmp    102879 <__alltraps>

001022f1 <vector138>:
.globl vector138
vector138:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $138
  1022f3:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022f8:	e9 7c 05 00 00       	jmp    102879 <__alltraps>

001022fd <vector139>:
.globl vector139
vector139:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $139
  1022ff:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102304:	e9 70 05 00 00       	jmp    102879 <__alltraps>

00102309 <vector140>:
.globl vector140
vector140:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $140
  10230b:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102310:	e9 64 05 00 00       	jmp    102879 <__alltraps>

00102315 <vector141>:
.globl vector141
vector141:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $141
  102317:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10231c:	e9 58 05 00 00       	jmp    102879 <__alltraps>

00102321 <vector142>:
.globl vector142
vector142:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $142
  102323:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102328:	e9 4c 05 00 00       	jmp    102879 <__alltraps>

0010232d <vector143>:
.globl vector143
vector143:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $143
  10232f:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102334:	e9 40 05 00 00       	jmp    102879 <__alltraps>

00102339 <vector144>:
.globl vector144
vector144:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $144
  10233b:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102340:	e9 34 05 00 00       	jmp    102879 <__alltraps>

00102345 <vector145>:
.globl vector145
vector145:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $145
  102347:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10234c:	e9 28 05 00 00       	jmp    102879 <__alltraps>

00102351 <vector146>:
.globl vector146
vector146:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $146
  102353:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102358:	e9 1c 05 00 00       	jmp    102879 <__alltraps>

0010235d <vector147>:
.globl vector147
vector147:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $147
  10235f:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102364:	e9 10 05 00 00       	jmp    102879 <__alltraps>

00102369 <vector148>:
.globl vector148
vector148:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $148
  10236b:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102370:	e9 04 05 00 00       	jmp    102879 <__alltraps>

00102375 <vector149>:
.globl vector149
vector149:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $149
  102377:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10237c:	e9 f8 04 00 00       	jmp    102879 <__alltraps>

00102381 <vector150>:
.globl vector150
vector150:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $150
  102383:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102388:	e9 ec 04 00 00       	jmp    102879 <__alltraps>

0010238d <vector151>:
.globl vector151
vector151:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $151
  10238f:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102394:	e9 e0 04 00 00       	jmp    102879 <__alltraps>

00102399 <vector152>:
.globl vector152
vector152:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $152
  10239b:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023a0:	e9 d4 04 00 00       	jmp    102879 <__alltraps>

001023a5 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $153
  1023a7:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023ac:	e9 c8 04 00 00       	jmp    102879 <__alltraps>

001023b1 <vector154>:
.globl vector154
vector154:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $154
  1023b3:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023b8:	e9 bc 04 00 00       	jmp    102879 <__alltraps>

001023bd <vector155>:
.globl vector155
vector155:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $155
  1023bf:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023c4:	e9 b0 04 00 00       	jmp    102879 <__alltraps>

001023c9 <vector156>:
.globl vector156
vector156:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $156
  1023cb:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023d0:	e9 a4 04 00 00       	jmp    102879 <__alltraps>

001023d5 <vector157>:
.globl vector157
vector157:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $157
  1023d7:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023dc:	e9 98 04 00 00       	jmp    102879 <__alltraps>

001023e1 <vector158>:
.globl vector158
vector158:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $158
  1023e3:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023e8:	e9 8c 04 00 00       	jmp    102879 <__alltraps>

001023ed <vector159>:
.globl vector159
vector159:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $159
  1023ef:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023f4:	e9 80 04 00 00       	jmp    102879 <__alltraps>

001023f9 <vector160>:
.globl vector160
vector160:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $160
  1023fb:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102400:	e9 74 04 00 00       	jmp    102879 <__alltraps>

00102405 <vector161>:
.globl vector161
vector161:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $161
  102407:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10240c:	e9 68 04 00 00       	jmp    102879 <__alltraps>

00102411 <vector162>:
.globl vector162
vector162:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $162
  102413:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102418:	e9 5c 04 00 00       	jmp    102879 <__alltraps>

0010241d <vector163>:
.globl vector163
vector163:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $163
  10241f:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102424:	e9 50 04 00 00       	jmp    102879 <__alltraps>

00102429 <vector164>:
.globl vector164
vector164:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $164
  10242b:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102430:	e9 44 04 00 00       	jmp    102879 <__alltraps>

00102435 <vector165>:
.globl vector165
vector165:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $165
  102437:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10243c:	e9 38 04 00 00       	jmp    102879 <__alltraps>

00102441 <vector166>:
.globl vector166
vector166:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $166
  102443:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102448:	e9 2c 04 00 00       	jmp    102879 <__alltraps>

0010244d <vector167>:
.globl vector167
vector167:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $167
  10244f:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102454:	e9 20 04 00 00       	jmp    102879 <__alltraps>

00102459 <vector168>:
.globl vector168
vector168:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $168
  10245b:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102460:	e9 14 04 00 00       	jmp    102879 <__alltraps>

00102465 <vector169>:
.globl vector169
vector169:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $169
  102467:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10246c:	e9 08 04 00 00       	jmp    102879 <__alltraps>

00102471 <vector170>:
.globl vector170
vector170:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $170
  102473:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102478:	e9 fc 03 00 00       	jmp    102879 <__alltraps>

0010247d <vector171>:
.globl vector171
vector171:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $171
  10247f:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102484:	e9 f0 03 00 00       	jmp    102879 <__alltraps>

00102489 <vector172>:
.globl vector172
vector172:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $172
  10248b:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102490:	e9 e4 03 00 00       	jmp    102879 <__alltraps>

00102495 <vector173>:
.globl vector173
vector173:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $173
  102497:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10249c:	e9 d8 03 00 00       	jmp    102879 <__alltraps>

001024a1 <vector174>:
.globl vector174
vector174:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $174
  1024a3:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024a8:	e9 cc 03 00 00       	jmp    102879 <__alltraps>

001024ad <vector175>:
.globl vector175
vector175:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $175
  1024af:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024b4:	e9 c0 03 00 00       	jmp    102879 <__alltraps>

001024b9 <vector176>:
.globl vector176
vector176:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $176
  1024bb:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024c0:	e9 b4 03 00 00       	jmp    102879 <__alltraps>

001024c5 <vector177>:
.globl vector177
vector177:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $177
  1024c7:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024cc:	e9 a8 03 00 00       	jmp    102879 <__alltraps>

001024d1 <vector178>:
.globl vector178
vector178:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $178
  1024d3:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024d8:	e9 9c 03 00 00       	jmp    102879 <__alltraps>

001024dd <vector179>:
.globl vector179
vector179:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $179
  1024df:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024e4:	e9 90 03 00 00       	jmp    102879 <__alltraps>

001024e9 <vector180>:
.globl vector180
vector180:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $180
  1024eb:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024f0:	e9 84 03 00 00       	jmp    102879 <__alltraps>

001024f5 <vector181>:
.globl vector181
vector181:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $181
  1024f7:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024fc:	e9 78 03 00 00       	jmp    102879 <__alltraps>

00102501 <vector182>:
.globl vector182
vector182:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $182
  102503:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102508:	e9 6c 03 00 00       	jmp    102879 <__alltraps>

0010250d <vector183>:
.globl vector183
vector183:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $183
  10250f:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102514:	e9 60 03 00 00       	jmp    102879 <__alltraps>

00102519 <vector184>:
.globl vector184
vector184:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $184
  10251b:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102520:	e9 54 03 00 00       	jmp    102879 <__alltraps>

00102525 <vector185>:
.globl vector185
vector185:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $185
  102527:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10252c:	e9 48 03 00 00       	jmp    102879 <__alltraps>

00102531 <vector186>:
.globl vector186
vector186:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $186
  102533:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102538:	e9 3c 03 00 00       	jmp    102879 <__alltraps>

0010253d <vector187>:
.globl vector187
vector187:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $187
  10253f:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102544:	e9 30 03 00 00       	jmp    102879 <__alltraps>

00102549 <vector188>:
.globl vector188
vector188:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $188
  10254b:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102550:	e9 24 03 00 00       	jmp    102879 <__alltraps>

00102555 <vector189>:
.globl vector189
vector189:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $189
  102557:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10255c:	e9 18 03 00 00       	jmp    102879 <__alltraps>

00102561 <vector190>:
.globl vector190
vector190:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $190
  102563:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102568:	e9 0c 03 00 00       	jmp    102879 <__alltraps>

0010256d <vector191>:
.globl vector191
vector191:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $191
  10256f:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102574:	e9 00 03 00 00       	jmp    102879 <__alltraps>

00102579 <vector192>:
.globl vector192
vector192:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $192
  10257b:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102580:	e9 f4 02 00 00       	jmp    102879 <__alltraps>

00102585 <vector193>:
.globl vector193
vector193:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $193
  102587:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10258c:	e9 e8 02 00 00       	jmp    102879 <__alltraps>

00102591 <vector194>:
.globl vector194
vector194:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $194
  102593:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102598:	e9 dc 02 00 00       	jmp    102879 <__alltraps>

0010259d <vector195>:
.globl vector195
vector195:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $195
  10259f:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025a4:	e9 d0 02 00 00       	jmp    102879 <__alltraps>

001025a9 <vector196>:
.globl vector196
vector196:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $196
  1025ab:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025b0:	e9 c4 02 00 00       	jmp    102879 <__alltraps>

001025b5 <vector197>:
.globl vector197
vector197:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $197
  1025b7:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025bc:	e9 b8 02 00 00       	jmp    102879 <__alltraps>

001025c1 <vector198>:
.globl vector198
vector198:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $198
  1025c3:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025c8:	e9 ac 02 00 00       	jmp    102879 <__alltraps>

001025cd <vector199>:
.globl vector199
vector199:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $199
  1025cf:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025d4:	e9 a0 02 00 00       	jmp    102879 <__alltraps>

001025d9 <vector200>:
.globl vector200
vector200:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $200
  1025db:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025e0:	e9 94 02 00 00       	jmp    102879 <__alltraps>

001025e5 <vector201>:
.globl vector201
vector201:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $201
  1025e7:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025ec:	e9 88 02 00 00       	jmp    102879 <__alltraps>

001025f1 <vector202>:
.globl vector202
vector202:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $202
  1025f3:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025f8:	e9 7c 02 00 00       	jmp    102879 <__alltraps>

001025fd <vector203>:
.globl vector203
vector203:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $203
  1025ff:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102604:	e9 70 02 00 00       	jmp    102879 <__alltraps>

00102609 <vector204>:
.globl vector204
vector204:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $204
  10260b:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102610:	e9 64 02 00 00       	jmp    102879 <__alltraps>

00102615 <vector205>:
.globl vector205
vector205:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $205
  102617:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10261c:	e9 58 02 00 00       	jmp    102879 <__alltraps>

00102621 <vector206>:
.globl vector206
vector206:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $206
  102623:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102628:	e9 4c 02 00 00       	jmp    102879 <__alltraps>

0010262d <vector207>:
.globl vector207
vector207:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $207
  10262f:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102634:	e9 40 02 00 00       	jmp    102879 <__alltraps>

00102639 <vector208>:
.globl vector208
vector208:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $208
  10263b:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102640:	e9 34 02 00 00       	jmp    102879 <__alltraps>

00102645 <vector209>:
.globl vector209
vector209:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $209
  102647:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10264c:	e9 28 02 00 00       	jmp    102879 <__alltraps>

00102651 <vector210>:
.globl vector210
vector210:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $210
  102653:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102658:	e9 1c 02 00 00       	jmp    102879 <__alltraps>

0010265d <vector211>:
.globl vector211
vector211:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $211
  10265f:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102664:	e9 10 02 00 00       	jmp    102879 <__alltraps>

00102669 <vector212>:
.globl vector212
vector212:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $212
  10266b:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102670:	e9 04 02 00 00       	jmp    102879 <__alltraps>

00102675 <vector213>:
.globl vector213
vector213:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $213
  102677:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10267c:	e9 f8 01 00 00       	jmp    102879 <__alltraps>

00102681 <vector214>:
.globl vector214
vector214:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $214
  102683:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102688:	e9 ec 01 00 00       	jmp    102879 <__alltraps>

0010268d <vector215>:
.globl vector215
vector215:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $215
  10268f:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102694:	e9 e0 01 00 00       	jmp    102879 <__alltraps>

00102699 <vector216>:
.globl vector216
vector216:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $216
  10269b:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026a0:	e9 d4 01 00 00       	jmp    102879 <__alltraps>

001026a5 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $217
  1026a7:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026ac:	e9 c8 01 00 00       	jmp    102879 <__alltraps>

001026b1 <vector218>:
.globl vector218
vector218:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $218
  1026b3:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026b8:	e9 bc 01 00 00       	jmp    102879 <__alltraps>

001026bd <vector219>:
.globl vector219
vector219:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $219
  1026bf:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026c4:	e9 b0 01 00 00       	jmp    102879 <__alltraps>

001026c9 <vector220>:
.globl vector220
vector220:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $220
  1026cb:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026d0:	e9 a4 01 00 00       	jmp    102879 <__alltraps>

001026d5 <vector221>:
.globl vector221
vector221:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $221
  1026d7:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026dc:	e9 98 01 00 00       	jmp    102879 <__alltraps>

001026e1 <vector222>:
.globl vector222
vector222:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $222
  1026e3:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026e8:	e9 8c 01 00 00       	jmp    102879 <__alltraps>

001026ed <vector223>:
.globl vector223
vector223:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $223
  1026ef:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026f4:	e9 80 01 00 00       	jmp    102879 <__alltraps>

001026f9 <vector224>:
.globl vector224
vector224:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $224
  1026fb:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102700:	e9 74 01 00 00       	jmp    102879 <__alltraps>

00102705 <vector225>:
.globl vector225
vector225:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $225
  102707:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10270c:	e9 68 01 00 00       	jmp    102879 <__alltraps>

00102711 <vector226>:
.globl vector226
vector226:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $226
  102713:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102718:	e9 5c 01 00 00       	jmp    102879 <__alltraps>

0010271d <vector227>:
.globl vector227
vector227:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $227
  10271f:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102724:	e9 50 01 00 00       	jmp    102879 <__alltraps>

00102729 <vector228>:
.globl vector228
vector228:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $228
  10272b:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102730:	e9 44 01 00 00       	jmp    102879 <__alltraps>

00102735 <vector229>:
.globl vector229
vector229:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $229
  102737:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10273c:	e9 38 01 00 00       	jmp    102879 <__alltraps>

00102741 <vector230>:
.globl vector230
vector230:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $230
  102743:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102748:	e9 2c 01 00 00       	jmp    102879 <__alltraps>

0010274d <vector231>:
.globl vector231
vector231:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $231
  10274f:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102754:	e9 20 01 00 00       	jmp    102879 <__alltraps>

00102759 <vector232>:
.globl vector232
vector232:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $232
  10275b:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102760:	e9 14 01 00 00       	jmp    102879 <__alltraps>

00102765 <vector233>:
.globl vector233
vector233:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $233
  102767:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10276c:	e9 08 01 00 00       	jmp    102879 <__alltraps>

00102771 <vector234>:
.globl vector234
vector234:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $234
  102773:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102778:	e9 fc 00 00 00       	jmp    102879 <__alltraps>

0010277d <vector235>:
.globl vector235
vector235:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $235
  10277f:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102784:	e9 f0 00 00 00       	jmp    102879 <__alltraps>

00102789 <vector236>:
.globl vector236
vector236:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $236
  10278b:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102790:	e9 e4 00 00 00       	jmp    102879 <__alltraps>

00102795 <vector237>:
.globl vector237
vector237:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $237
  102797:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10279c:	e9 d8 00 00 00       	jmp    102879 <__alltraps>

001027a1 <vector238>:
.globl vector238
vector238:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $238
  1027a3:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027a8:	e9 cc 00 00 00       	jmp    102879 <__alltraps>

001027ad <vector239>:
.globl vector239
vector239:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $239
  1027af:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027b4:	e9 c0 00 00 00       	jmp    102879 <__alltraps>

001027b9 <vector240>:
.globl vector240
vector240:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $240
  1027bb:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027c0:	e9 b4 00 00 00       	jmp    102879 <__alltraps>

001027c5 <vector241>:
.globl vector241
vector241:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $241
  1027c7:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027cc:	e9 a8 00 00 00       	jmp    102879 <__alltraps>

001027d1 <vector242>:
.globl vector242
vector242:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $242
  1027d3:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027d8:	e9 9c 00 00 00       	jmp    102879 <__alltraps>

001027dd <vector243>:
.globl vector243
vector243:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $243
  1027df:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027e4:	e9 90 00 00 00       	jmp    102879 <__alltraps>

001027e9 <vector244>:
.globl vector244
vector244:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $244
  1027eb:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027f0:	e9 84 00 00 00       	jmp    102879 <__alltraps>

001027f5 <vector245>:
.globl vector245
vector245:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $245
  1027f7:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027fc:	e9 78 00 00 00       	jmp    102879 <__alltraps>

00102801 <vector246>:
.globl vector246
vector246:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $246
  102803:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102808:	e9 6c 00 00 00       	jmp    102879 <__alltraps>

0010280d <vector247>:
.globl vector247
vector247:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $247
  10280f:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102814:	e9 60 00 00 00       	jmp    102879 <__alltraps>

00102819 <vector248>:
.globl vector248
vector248:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $248
  10281b:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102820:	e9 54 00 00 00       	jmp    102879 <__alltraps>

00102825 <vector249>:
.globl vector249
vector249:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $249
  102827:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10282c:	e9 48 00 00 00       	jmp    102879 <__alltraps>

00102831 <vector250>:
.globl vector250
vector250:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $250
  102833:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102838:	e9 3c 00 00 00       	jmp    102879 <__alltraps>

0010283d <vector251>:
.globl vector251
vector251:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $251
  10283f:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102844:	e9 30 00 00 00       	jmp    102879 <__alltraps>

00102849 <vector252>:
.globl vector252
vector252:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $252
  10284b:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102850:	e9 24 00 00 00       	jmp    102879 <__alltraps>

00102855 <vector253>:
.globl vector253
vector253:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $253
  102857:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10285c:	e9 18 00 00 00       	jmp    102879 <__alltraps>

00102861 <vector254>:
.globl vector254
vector254:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $254
  102863:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102868:	e9 0c 00 00 00       	jmp    102879 <__alltraps>

0010286d <vector255>:
.globl vector255
vector255:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $255
  10286f:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102874:	e9 00 00 00 00       	jmp    102879 <__alltraps>

00102879 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102879:	1e                   	push   %ds
    pushl %es
  10287a:	06                   	push   %es
    pushl %fs
  10287b:	0f a0                	push   %fs
    pushl %gs
  10287d:	0f a8                	push   %gs
    pushal
  10287f:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102880:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102885:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102887:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102889:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10288a:	e8 61 f5 ff ff       	call   101df0 <trap>

    # pop the pushed stack pointer
    popl %esp
  10288f:	5c                   	pop    %esp

00102890 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102890:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102891:	0f a9                	pop    %gs
    popl %fs
  102893:	0f a1                	pop    %fs
    popl %es
  102895:	07                   	pop    %es
    popl %ds
  102896:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102897:	83 c4 08             	add    $0x8,%esp
    iret
  10289a:	cf                   	iret   

0010289b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10289b:	55                   	push   %ebp
  10289c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10289e:	8b 45 08             	mov    0x8(%ebp),%eax
  1028a1:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1028a4:	b8 23 00 00 00       	mov    $0x23,%eax
  1028a9:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1028ab:	b8 23 00 00 00       	mov    $0x23,%eax
  1028b0:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1028b2:	b8 10 00 00 00       	mov    $0x10,%eax
  1028b7:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1028b9:	b8 10 00 00 00       	mov    $0x10,%eax
  1028be:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1028c0:	b8 10 00 00 00       	mov    $0x10,%eax
  1028c5:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1028c7:	ea ce 28 10 00 08 00 	ljmp   $0x8,$0x1028ce
}
  1028ce:	90                   	nop
  1028cf:	5d                   	pop    %ebp
  1028d0:	c3                   	ret    

001028d1 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1028d1:	55                   	push   %ebp
  1028d2:	89 e5                	mov    %esp,%ebp
  1028d4:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1028d7:	b8 00 fa 10 00       	mov    $0x10fa00,%eax
  1028dc:	05 00 04 00 00       	add    $0x400,%eax
  1028e1:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1028e6:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1028ed:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1028ef:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1028f6:	68 00 
  1028f8:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1028fd:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102903:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102908:	c1 e8 10             	shr    $0x10,%eax
  10290b:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102910:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102917:	83 e0 f0             	and    $0xfffffff0,%eax
  10291a:	83 c8 09             	or     $0x9,%eax
  10291d:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102922:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102929:	83 c8 10             	or     $0x10,%eax
  10292c:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102931:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102938:	83 e0 9f             	and    $0xffffff9f,%eax
  10293b:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102940:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102947:	83 c8 80             	or     $0xffffff80,%eax
  10294a:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10294f:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102956:	83 e0 f0             	and    $0xfffffff0,%eax
  102959:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10295e:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102965:	83 e0 ef             	and    $0xffffffef,%eax
  102968:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10296d:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102974:	83 e0 df             	and    $0xffffffdf,%eax
  102977:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10297c:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102983:	83 c8 40             	or     $0x40,%eax
  102986:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10298b:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102992:	83 e0 7f             	and    $0x7f,%eax
  102995:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10299a:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10299f:	c1 e8 18             	shr    $0x18,%eax
  1029a2:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  1029a7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029ae:	83 e0 ef             	and    $0xffffffef,%eax
  1029b1:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  1029b6:	68 10 ea 10 00       	push   $0x10ea10
  1029bb:	e8 db fe ff ff       	call   10289b <lgdt>
  1029c0:	83 c4 04             	add    $0x4,%esp
  1029c3:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  1029c9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1029cd:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1029d0:	90                   	nop
  1029d1:	c9                   	leave  
  1029d2:	c3                   	ret    

001029d3 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1029d3:	55                   	push   %ebp
  1029d4:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1029d6:	e8 f6 fe ff ff       	call   1028d1 <gdt_init>
}
  1029db:	90                   	nop
  1029dc:	5d                   	pop    %ebp
  1029dd:	c3                   	ret    

001029de <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1029de:	55                   	push   %ebp
  1029df:	89 e5                	mov    %esp,%ebp
  1029e1:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1029e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1029eb:	eb 04                	jmp    1029f1 <strlen+0x13>
        cnt ++;
  1029ed:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f4:	8d 50 01             	lea    0x1(%eax),%edx
  1029f7:	89 55 08             	mov    %edx,0x8(%ebp)
  1029fa:	0f b6 00             	movzbl (%eax),%eax
  1029fd:	84 c0                	test   %al,%al
  1029ff:	75 ec                	jne    1029ed <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102a04:	c9                   	leave  
  102a05:	c3                   	ret    

00102a06 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102a06:	55                   	push   %ebp
  102a07:	89 e5                	mov    %esp,%ebp
  102a09:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102a0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102a13:	eb 04                	jmp    102a19 <strnlen+0x13>
        cnt ++;
  102a15:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102a19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a1c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102a1f:	73 10                	jae    102a31 <strnlen+0x2b>
  102a21:	8b 45 08             	mov    0x8(%ebp),%eax
  102a24:	8d 50 01             	lea    0x1(%eax),%edx
  102a27:	89 55 08             	mov    %edx,0x8(%ebp)
  102a2a:	0f b6 00             	movzbl (%eax),%eax
  102a2d:	84 c0                	test   %al,%al
  102a2f:	75 e4                	jne    102a15 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102a34:	c9                   	leave  
  102a35:	c3                   	ret    

00102a36 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102a36:	55                   	push   %ebp
  102a37:	89 e5                	mov    %esp,%ebp
  102a39:	57                   	push   %edi
  102a3a:	56                   	push   %esi
  102a3b:	83 ec 20             	sub    $0x20,%esp
  102a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102a4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a50:	89 d1                	mov    %edx,%ecx
  102a52:	89 c2                	mov    %eax,%edx
  102a54:	89 ce                	mov    %ecx,%esi
  102a56:	89 d7                	mov    %edx,%edi
  102a58:	ac                   	lods   %ds:(%esi),%al
  102a59:	aa                   	stos   %al,%es:(%edi)
  102a5a:	84 c0                	test   %al,%al
  102a5c:	75 fa                	jne    102a58 <strcpy+0x22>
  102a5e:	89 fa                	mov    %edi,%edx
  102a60:	89 f1                	mov    %esi,%ecx
  102a62:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102a65:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102a68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102a6e:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102a6f:	83 c4 20             	add    $0x20,%esp
  102a72:	5e                   	pop    %esi
  102a73:	5f                   	pop    %edi
  102a74:	5d                   	pop    %ebp
  102a75:	c3                   	ret    

00102a76 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102a76:	55                   	push   %ebp
  102a77:	89 e5                	mov    %esp,%ebp
  102a79:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102a82:	eb 21                	jmp    102aa5 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a87:	0f b6 10             	movzbl (%eax),%edx
  102a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a8d:	88 10                	mov    %dl,(%eax)
  102a8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a92:	0f b6 00             	movzbl (%eax),%eax
  102a95:	84 c0                	test   %al,%al
  102a97:	74 04                	je     102a9d <strncpy+0x27>
            src ++;
  102a99:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102a9d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102aa1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  102aa5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102aa9:	75 d9                	jne    102a84 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  102aab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102aae:	c9                   	leave  
  102aaf:	c3                   	ret    

00102ab0 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102ab0:	55                   	push   %ebp
  102ab1:	89 e5                	mov    %esp,%ebp
  102ab3:	57                   	push   %edi
  102ab4:	56                   	push   %esi
  102ab5:	83 ec 20             	sub    $0x20,%esp
  102ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  102abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102abe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ac1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102ac4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aca:	89 d1                	mov    %edx,%ecx
  102acc:	89 c2                	mov    %eax,%edx
  102ace:	89 ce                	mov    %ecx,%esi
  102ad0:	89 d7                	mov    %edx,%edi
  102ad2:	ac                   	lods   %ds:(%esi),%al
  102ad3:	ae                   	scas   %es:(%edi),%al
  102ad4:	75 08                	jne    102ade <strcmp+0x2e>
  102ad6:	84 c0                	test   %al,%al
  102ad8:	75 f8                	jne    102ad2 <strcmp+0x22>
  102ada:	31 c0                	xor    %eax,%eax
  102adc:	eb 04                	jmp    102ae2 <strcmp+0x32>
  102ade:	19 c0                	sbb    %eax,%eax
  102ae0:	0c 01                	or     $0x1,%al
  102ae2:	89 fa                	mov    %edi,%edx
  102ae4:	89 f1                	mov    %esi,%ecx
  102ae6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ae9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102aec:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  102aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102af2:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102af3:	83 c4 20             	add    $0x20,%esp
  102af6:	5e                   	pop    %esi
  102af7:	5f                   	pop    %edi
  102af8:	5d                   	pop    %ebp
  102af9:	c3                   	ret    

00102afa <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102afa:	55                   	push   %ebp
  102afb:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102afd:	eb 0c                	jmp    102b0b <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102aff:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102b03:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b07:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102b0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b0f:	74 1a                	je     102b2b <strncmp+0x31>
  102b11:	8b 45 08             	mov    0x8(%ebp),%eax
  102b14:	0f b6 00             	movzbl (%eax),%eax
  102b17:	84 c0                	test   %al,%al
  102b19:	74 10                	je     102b2b <strncmp+0x31>
  102b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b1e:	0f b6 10             	movzbl (%eax),%edx
  102b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b24:	0f b6 00             	movzbl (%eax),%eax
  102b27:	38 c2                	cmp    %al,%dl
  102b29:	74 d4                	je     102aff <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102b2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b2f:	74 18                	je     102b49 <strncmp+0x4f>
  102b31:	8b 45 08             	mov    0x8(%ebp),%eax
  102b34:	0f b6 00             	movzbl (%eax),%eax
  102b37:	0f b6 d0             	movzbl %al,%edx
  102b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b3d:	0f b6 00             	movzbl (%eax),%eax
  102b40:	0f b6 c0             	movzbl %al,%eax
  102b43:	29 c2                	sub    %eax,%edx
  102b45:	89 d0                	mov    %edx,%eax
  102b47:	eb 05                	jmp    102b4e <strncmp+0x54>
  102b49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b4e:	5d                   	pop    %ebp
  102b4f:	c3                   	ret    

00102b50 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102b50:	55                   	push   %ebp
  102b51:	89 e5                	mov    %esp,%ebp
  102b53:	83 ec 04             	sub    $0x4,%esp
  102b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b59:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102b5c:	eb 14                	jmp    102b72 <strchr+0x22>
        if (*s == c) {
  102b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b61:	0f b6 00             	movzbl (%eax),%eax
  102b64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102b67:	75 05                	jne    102b6e <strchr+0x1e>
            return (char *)s;
  102b69:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6c:	eb 13                	jmp    102b81 <strchr+0x31>
        }
        s ++;
  102b6e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102b72:	8b 45 08             	mov    0x8(%ebp),%eax
  102b75:	0f b6 00             	movzbl (%eax),%eax
  102b78:	84 c0                	test   %al,%al
  102b7a:	75 e2                	jne    102b5e <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102b7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b81:	c9                   	leave  
  102b82:	c3                   	ret    

00102b83 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102b83:	55                   	push   %ebp
  102b84:	89 e5                	mov    %esp,%ebp
  102b86:	83 ec 04             	sub    $0x4,%esp
  102b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b8c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102b8f:	eb 0f                	jmp    102ba0 <strfind+0x1d>
        if (*s == c) {
  102b91:	8b 45 08             	mov    0x8(%ebp),%eax
  102b94:	0f b6 00             	movzbl (%eax),%eax
  102b97:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102b9a:	74 10                	je     102bac <strfind+0x29>
            break;
        }
        s ++;
  102b9c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba3:	0f b6 00             	movzbl (%eax),%eax
  102ba6:	84 c0                	test   %al,%al
  102ba8:	75 e7                	jne    102b91 <strfind+0xe>
  102baa:	eb 01                	jmp    102bad <strfind+0x2a>
        if (*s == c) {
            break;
  102bac:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  102bad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102bb0:	c9                   	leave  
  102bb1:	c3                   	ret    

00102bb2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102bb2:	55                   	push   %ebp
  102bb3:	89 e5                	mov    %esp,%ebp
  102bb5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102bb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102bbf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102bc6:	eb 04                	jmp    102bcc <strtol+0x1a>
        s ++;
  102bc8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  102bcf:	0f b6 00             	movzbl (%eax),%eax
  102bd2:	3c 20                	cmp    $0x20,%al
  102bd4:	74 f2                	je     102bc8 <strtol+0x16>
  102bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd9:	0f b6 00             	movzbl (%eax),%eax
  102bdc:	3c 09                	cmp    $0x9,%al
  102bde:	74 e8                	je     102bc8 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  102be0:	8b 45 08             	mov    0x8(%ebp),%eax
  102be3:	0f b6 00             	movzbl (%eax),%eax
  102be6:	3c 2b                	cmp    $0x2b,%al
  102be8:	75 06                	jne    102bf0 <strtol+0x3e>
        s ++;
  102bea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102bee:	eb 15                	jmp    102c05 <strtol+0x53>
    }
    else if (*s == '-') {
  102bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf3:	0f b6 00             	movzbl (%eax),%eax
  102bf6:	3c 2d                	cmp    $0x2d,%al
  102bf8:	75 0b                	jne    102c05 <strtol+0x53>
        s ++, neg = 1;
  102bfa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102bfe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102c05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c09:	74 06                	je     102c11 <strtol+0x5f>
  102c0b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102c0f:	75 24                	jne    102c35 <strtol+0x83>
  102c11:	8b 45 08             	mov    0x8(%ebp),%eax
  102c14:	0f b6 00             	movzbl (%eax),%eax
  102c17:	3c 30                	cmp    $0x30,%al
  102c19:	75 1a                	jne    102c35 <strtol+0x83>
  102c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1e:	83 c0 01             	add    $0x1,%eax
  102c21:	0f b6 00             	movzbl (%eax),%eax
  102c24:	3c 78                	cmp    $0x78,%al
  102c26:	75 0d                	jne    102c35 <strtol+0x83>
        s += 2, base = 16;
  102c28:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102c2c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102c33:	eb 2a                	jmp    102c5f <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102c35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c39:	75 17                	jne    102c52 <strtol+0xa0>
  102c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3e:	0f b6 00             	movzbl (%eax),%eax
  102c41:	3c 30                	cmp    $0x30,%al
  102c43:	75 0d                	jne    102c52 <strtol+0xa0>
        s ++, base = 8;
  102c45:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c49:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102c50:	eb 0d                	jmp    102c5f <strtol+0xad>
    }
    else if (base == 0) {
  102c52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c56:	75 07                	jne    102c5f <strtol+0xad>
        base = 10;
  102c58:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c62:	0f b6 00             	movzbl (%eax),%eax
  102c65:	3c 2f                	cmp    $0x2f,%al
  102c67:	7e 1b                	jle    102c84 <strtol+0xd2>
  102c69:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6c:	0f b6 00             	movzbl (%eax),%eax
  102c6f:	3c 39                	cmp    $0x39,%al
  102c71:	7f 11                	jg     102c84 <strtol+0xd2>
            dig = *s - '0';
  102c73:	8b 45 08             	mov    0x8(%ebp),%eax
  102c76:	0f b6 00             	movzbl (%eax),%eax
  102c79:	0f be c0             	movsbl %al,%eax
  102c7c:	83 e8 30             	sub    $0x30,%eax
  102c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c82:	eb 48                	jmp    102ccc <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102c84:	8b 45 08             	mov    0x8(%ebp),%eax
  102c87:	0f b6 00             	movzbl (%eax),%eax
  102c8a:	3c 60                	cmp    $0x60,%al
  102c8c:	7e 1b                	jle    102ca9 <strtol+0xf7>
  102c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c91:	0f b6 00             	movzbl (%eax),%eax
  102c94:	3c 7a                	cmp    $0x7a,%al
  102c96:	7f 11                	jg     102ca9 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102c98:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9b:	0f b6 00             	movzbl (%eax),%eax
  102c9e:	0f be c0             	movsbl %al,%eax
  102ca1:	83 e8 57             	sub    $0x57,%eax
  102ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ca7:	eb 23                	jmp    102ccc <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  102cac:	0f b6 00             	movzbl (%eax),%eax
  102caf:	3c 40                	cmp    $0x40,%al
  102cb1:	7e 3c                	jle    102cef <strtol+0x13d>
  102cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb6:	0f b6 00             	movzbl (%eax),%eax
  102cb9:	3c 5a                	cmp    $0x5a,%al
  102cbb:	7f 32                	jg     102cef <strtol+0x13d>
            dig = *s - 'A' + 10;
  102cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc0:	0f b6 00             	movzbl (%eax),%eax
  102cc3:	0f be c0             	movsbl %al,%eax
  102cc6:	83 e8 37             	sub    $0x37,%eax
  102cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ccf:	3b 45 10             	cmp    0x10(%ebp),%eax
  102cd2:	7d 1a                	jge    102cee <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102cd4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102cd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102cdb:	0f af 45 10          	imul   0x10(%ebp),%eax
  102cdf:	89 c2                	mov    %eax,%edx
  102ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ce4:	01 d0                	add    %edx,%eax
  102ce6:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102ce9:	e9 71 ff ff ff       	jmp    102c5f <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  102cee:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  102cef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102cf3:	74 08                	je     102cfd <strtol+0x14b>
        *endptr = (char *) s;
  102cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  102cfb:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102cfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102d01:	74 07                	je     102d0a <strtol+0x158>
  102d03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d06:	f7 d8                	neg    %eax
  102d08:	eb 03                	jmp    102d0d <strtol+0x15b>
  102d0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102d0d:	c9                   	leave  
  102d0e:	c3                   	ret    

00102d0f <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102d0f:	55                   	push   %ebp
  102d10:	89 e5                	mov    %esp,%ebp
  102d12:	57                   	push   %edi
  102d13:	83 ec 24             	sub    $0x24,%esp
  102d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d19:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102d1c:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102d20:	8b 55 08             	mov    0x8(%ebp),%edx
  102d23:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102d26:	88 45 f7             	mov    %al,-0x9(%ebp)
  102d29:	8b 45 10             	mov    0x10(%ebp),%eax
  102d2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102d2f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102d32:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102d36:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102d39:	89 d7                	mov    %edx,%edi
  102d3b:	f3 aa                	rep stos %al,%es:(%edi)
  102d3d:	89 fa                	mov    %edi,%edx
  102d3f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102d42:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102d45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d48:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102d49:	83 c4 24             	add    $0x24,%esp
  102d4c:	5f                   	pop    %edi
  102d4d:	5d                   	pop    %ebp
  102d4e:	c3                   	ret    

00102d4f <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102d4f:	55                   	push   %ebp
  102d50:	89 e5                	mov    %esp,%ebp
  102d52:	57                   	push   %edi
  102d53:	56                   	push   %esi
  102d54:	53                   	push   %ebx
  102d55:	83 ec 30             	sub    $0x30,%esp
  102d58:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d61:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d64:	8b 45 10             	mov    0x10(%ebp),%eax
  102d67:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d6d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102d70:	73 42                	jae    102db4 <memmove+0x65>
  102d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d81:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102d84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d87:	c1 e8 02             	shr    $0x2,%eax
  102d8a:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102d8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d92:	89 d7                	mov    %edx,%edi
  102d94:	89 c6                	mov    %eax,%esi
  102d96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102d98:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102d9b:	83 e1 03             	and    $0x3,%ecx
  102d9e:	74 02                	je     102da2 <memmove+0x53>
  102da0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102da2:	89 f0                	mov    %esi,%eax
  102da4:	89 fa                	mov    %edi,%edx
  102da6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102da9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102dac:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102daf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102db2:	eb 36                	jmp    102dea <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102db4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102db7:	8d 50 ff             	lea    -0x1(%eax),%edx
  102dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102dbd:	01 c2                	add    %eax,%edx
  102dbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dc2:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dc8:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  102dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dce:	89 c1                	mov    %eax,%ecx
  102dd0:	89 d8                	mov    %ebx,%eax
  102dd2:	89 d6                	mov    %edx,%esi
  102dd4:	89 c7                	mov    %eax,%edi
  102dd6:	fd                   	std    
  102dd7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102dd9:	fc                   	cld    
  102dda:	89 f8                	mov    %edi,%eax
  102ddc:	89 f2                	mov    %esi,%edx
  102dde:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102de1:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102de4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  102de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102dea:	83 c4 30             	add    $0x30,%esp
  102ded:	5b                   	pop    %ebx
  102dee:	5e                   	pop    %esi
  102def:	5f                   	pop    %edi
  102df0:	5d                   	pop    %ebp
  102df1:	c3                   	ret    

00102df2 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102df2:	55                   	push   %ebp
  102df3:	89 e5                	mov    %esp,%ebp
  102df5:	57                   	push   %edi
  102df6:	56                   	push   %esi
  102df7:	83 ec 20             	sub    $0x20,%esp
  102dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e00:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e06:	8b 45 10             	mov    0x10(%ebp),%eax
  102e09:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e0f:	c1 e8 02             	shr    $0x2,%eax
  102e12:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102e14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e1a:	89 d7                	mov    %edx,%edi
  102e1c:	89 c6                	mov    %eax,%esi
  102e1e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102e20:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102e23:	83 e1 03             	and    $0x3,%ecx
  102e26:	74 02                	je     102e2a <memcpy+0x38>
  102e28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e2a:	89 f0                	mov    %esi,%eax
  102e2c:	89 fa                	mov    %edi,%edx
  102e2e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102e31:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102e34:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102e3a:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102e3b:	83 c4 20             	add    $0x20,%esp
  102e3e:	5e                   	pop    %esi
  102e3f:	5f                   	pop    %edi
  102e40:	5d                   	pop    %ebp
  102e41:	c3                   	ret    

00102e42 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102e42:	55                   	push   %ebp
  102e43:	89 e5                	mov    %esp,%ebp
  102e45:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102e48:	8b 45 08             	mov    0x8(%ebp),%eax
  102e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e51:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102e54:	eb 30                	jmp    102e86 <memcmp+0x44>
        if (*s1 != *s2) {
  102e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e59:	0f b6 10             	movzbl (%eax),%edx
  102e5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e5f:	0f b6 00             	movzbl (%eax),%eax
  102e62:	38 c2                	cmp    %al,%dl
  102e64:	74 18                	je     102e7e <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102e66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e69:	0f b6 00             	movzbl (%eax),%eax
  102e6c:	0f b6 d0             	movzbl %al,%edx
  102e6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e72:	0f b6 00             	movzbl (%eax),%eax
  102e75:	0f b6 c0             	movzbl %al,%eax
  102e78:	29 c2                	sub    %eax,%edx
  102e7a:	89 d0                	mov    %edx,%eax
  102e7c:	eb 1a                	jmp    102e98 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102e7e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102e82:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  102e86:	8b 45 10             	mov    0x10(%ebp),%eax
  102e89:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e8c:	89 55 10             	mov    %edx,0x10(%ebp)
  102e8f:	85 c0                	test   %eax,%eax
  102e91:	75 c3                	jne    102e56 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  102e93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e98:	c9                   	leave  
  102e99:	c3                   	ret    

00102e9a <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102e9a:	55                   	push   %ebp
  102e9b:	89 e5                	mov    %esp,%ebp
  102e9d:	83 ec 38             	sub    $0x38,%esp
  102ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  102ea3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ea6:	8b 45 14             	mov    0x14(%ebp),%eax
  102ea9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102eac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102eaf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102eb2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102eb5:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102eb8:	8b 45 18             	mov    0x18(%ebp),%eax
  102ebb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102ebe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ec1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ec4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ec7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ed0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102ed4:	74 1c                	je     102ef2 <printnum+0x58>
  102ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ed9:	ba 00 00 00 00       	mov    $0x0,%edx
  102ede:	f7 75 e4             	divl   -0x1c(%ebp)
  102ee1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ee7:	ba 00 00 00 00       	mov    $0x0,%edx
  102eec:	f7 75 e4             	divl   -0x1c(%ebp)
  102eef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ef2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ef8:	f7 75 e4             	divl   -0x1c(%ebp)
  102efb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102efe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102f01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102f07:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f0a:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102f0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f10:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102f13:	8b 45 18             	mov    0x18(%ebp),%eax
  102f16:	ba 00 00 00 00       	mov    $0x0,%edx
  102f1b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102f1e:	77 41                	ja     102f61 <printnum+0xc7>
  102f20:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102f23:	72 05                	jb     102f2a <printnum+0x90>
  102f25:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102f28:	77 37                	ja     102f61 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102f2a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102f2d:	83 e8 01             	sub    $0x1,%eax
  102f30:	83 ec 04             	sub    $0x4,%esp
  102f33:	ff 75 20             	pushl  0x20(%ebp)
  102f36:	50                   	push   %eax
  102f37:	ff 75 18             	pushl  0x18(%ebp)
  102f3a:	ff 75 ec             	pushl  -0x14(%ebp)
  102f3d:	ff 75 e8             	pushl  -0x18(%ebp)
  102f40:	ff 75 0c             	pushl  0xc(%ebp)
  102f43:	ff 75 08             	pushl  0x8(%ebp)
  102f46:	e8 4f ff ff ff       	call   102e9a <printnum>
  102f4b:	83 c4 20             	add    $0x20,%esp
  102f4e:	eb 1b                	jmp    102f6b <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102f50:	83 ec 08             	sub    $0x8,%esp
  102f53:	ff 75 0c             	pushl  0xc(%ebp)
  102f56:	ff 75 20             	pushl  0x20(%ebp)
  102f59:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5c:	ff d0                	call   *%eax
  102f5e:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102f61:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102f65:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102f69:	7f e5                	jg     102f50 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102f6b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102f6e:	05 70 3c 10 00       	add    $0x103c70,%eax
  102f73:	0f b6 00             	movzbl (%eax),%eax
  102f76:	0f be c0             	movsbl %al,%eax
  102f79:	83 ec 08             	sub    $0x8,%esp
  102f7c:	ff 75 0c             	pushl  0xc(%ebp)
  102f7f:	50                   	push   %eax
  102f80:	8b 45 08             	mov    0x8(%ebp),%eax
  102f83:	ff d0                	call   *%eax
  102f85:	83 c4 10             	add    $0x10,%esp
}
  102f88:	90                   	nop
  102f89:	c9                   	leave  
  102f8a:	c3                   	ret    

00102f8b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102f8b:	55                   	push   %ebp
  102f8c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102f8e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102f92:	7e 14                	jle    102fa8 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102f94:	8b 45 08             	mov    0x8(%ebp),%eax
  102f97:	8b 00                	mov    (%eax),%eax
  102f99:	8d 48 08             	lea    0x8(%eax),%ecx
  102f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  102f9f:	89 0a                	mov    %ecx,(%edx)
  102fa1:	8b 50 04             	mov    0x4(%eax),%edx
  102fa4:	8b 00                	mov    (%eax),%eax
  102fa6:	eb 30                	jmp    102fd8 <getuint+0x4d>
    }
    else if (lflag) {
  102fa8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102fac:	74 16                	je     102fc4 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102fae:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb1:	8b 00                	mov    (%eax),%eax
  102fb3:	8d 48 04             	lea    0x4(%eax),%ecx
  102fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  102fb9:	89 0a                	mov    %ecx,(%edx)
  102fbb:	8b 00                	mov    (%eax),%eax
  102fbd:	ba 00 00 00 00       	mov    $0x0,%edx
  102fc2:	eb 14                	jmp    102fd8 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc7:	8b 00                	mov    (%eax),%eax
  102fc9:	8d 48 04             	lea    0x4(%eax),%ecx
  102fcc:	8b 55 08             	mov    0x8(%ebp),%edx
  102fcf:	89 0a                	mov    %ecx,(%edx)
  102fd1:	8b 00                	mov    (%eax),%eax
  102fd3:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102fd8:	5d                   	pop    %ebp
  102fd9:	c3                   	ret    

00102fda <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102fda:	55                   	push   %ebp
  102fdb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102fdd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102fe1:	7e 14                	jle    102ff7 <getint+0x1d>
        return va_arg(*ap, long long);
  102fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe6:	8b 00                	mov    (%eax),%eax
  102fe8:	8d 48 08             	lea    0x8(%eax),%ecx
  102feb:	8b 55 08             	mov    0x8(%ebp),%edx
  102fee:	89 0a                	mov    %ecx,(%edx)
  102ff0:	8b 50 04             	mov    0x4(%eax),%edx
  102ff3:	8b 00                	mov    (%eax),%eax
  102ff5:	eb 28                	jmp    10301f <getint+0x45>
    }
    else if (lflag) {
  102ff7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ffb:	74 12                	je     10300f <getint+0x35>
        return va_arg(*ap, long);
  102ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  103000:	8b 00                	mov    (%eax),%eax
  103002:	8d 48 04             	lea    0x4(%eax),%ecx
  103005:	8b 55 08             	mov    0x8(%ebp),%edx
  103008:	89 0a                	mov    %ecx,(%edx)
  10300a:	8b 00                	mov    (%eax),%eax
  10300c:	99                   	cltd   
  10300d:	eb 10                	jmp    10301f <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10300f:	8b 45 08             	mov    0x8(%ebp),%eax
  103012:	8b 00                	mov    (%eax),%eax
  103014:	8d 48 04             	lea    0x4(%eax),%ecx
  103017:	8b 55 08             	mov    0x8(%ebp),%edx
  10301a:	89 0a                	mov    %ecx,(%edx)
  10301c:	8b 00                	mov    (%eax),%eax
  10301e:	99                   	cltd   
    }
}
  10301f:	5d                   	pop    %ebp
  103020:	c3                   	ret    

00103021 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  103021:	55                   	push   %ebp
  103022:	89 e5                	mov    %esp,%ebp
  103024:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  103027:	8d 45 14             	lea    0x14(%ebp),%eax
  10302a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103030:	50                   	push   %eax
  103031:	ff 75 10             	pushl  0x10(%ebp)
  103034:	ff 75 0c             	pushl  0xc(%ebp)
  103037:	ff 75 08             	pushl  0x8(%ebp)
  10303a:	e8 06 00 00 00       	call   103045 <vprintfmt>
  10303f:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  103042:	90                   	nop
  103043:	c9                   	leave  
  103044:	c3                   	ret    

00103045 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  103045:	55                   	push   %ebp
  103046:	89 e5                	mov    %esp,%ebp
  103048:	56                   	push   %esi
  103049:	53                   	push   %ebx
  10304a:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10304d:	eb 17                	jmp    103066 <vprintfmt+0x21>
            if (ch == '\0') {
  10304f:	85 db                	test   %ebx,%ebx
  103051:	0f 84 8e 03 00 00    	je     1033e5 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  103057:	83 ec 08             	sub    $0x8,%esp
  10305a:	ff 75 0c             	pushl  0xc(%ebp)
  10305d:	53                   	push   %ebx
  10305e:	8b 45 08             	mov    0x8(%ebp),%eax
  103061:	ff d0                	call   *%eax
  103063:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103066:	8b 45 10             	mov    0x10(%ebp),%eax
  103069:	8d 50 01             	lea    0x1(%eax),%edx
  10306c:	89 55 10             	mov    %edx,0x10(%ebp)
  10306f:	0f b6 00             	movzbl (%eax),%eax
  103072:	0f b6 d8             	movzbl %al,%ebx
  103075:	83 fb 25             	cmp    $0x25,%ebx
  103078:	75 d5                	jne    10304f <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  10307a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10307e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  103085:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103088:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10308b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103092:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103095:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103098:	8b 45 10             	mov    0x10(%ebp),%eax
  10309b:	8d 50 01             	lea    0x1(%eax),%edx
  10309e:	89 55 10             	mov    %edx,0x10(%ebp)
  1030a1:	0f b6 00             	movzbl (%eax),%eax
  1030a4:	0f b6 d8             	movzbl %al,%ebx
  1030a7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1030aa:	83 f8 55             	cmp    $0x55,%eax
  1030ad:	0f 87 05 03 00 00    	ja     1033b8 <vprintfmt+0x373>
  1030b3:	8b 04 85 94 3c 10 00 	mov    0x103c94(,%eax,4),%eax
  1030ba:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1030bc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1030c0:	eb d6                	jmp    103098 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1030c2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1030c6:	eb d0                	jmp    103098 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1030c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1030cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1030d2:	89 d0                	mov    %edx,%eax
  1030d4:	c1 e0 02             	shl    $0x2,%eax
  1030d7:	01 d0                	add    %edx,%eax
  1030d9:	01 c0                	add    %eax,%eax
  1030db:	01 d8                	add    %ebx,%eax
  1030dd:	83 e8 30             	sub    $0x30,%eax
  1030e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1030e3:	8b 45 10             	mov    0x10(%ebp),%eax
  1030e6:	0f b6 00             	movzbl (%eax),%eax
  1030e9:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1030ec:	83 fb 2f             	cmp    $0x2f,%ebx
  1030ef:	7e 39                	jle    10312a <vprintfmt+0xe5>
  1030f1:	83 fb 39             	cmp    $0x39,%ebx
  1030f4:	7f 34                	jg     10312a <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1030f6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1030fa:	eb d3                	jmp    1030cf <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1030fc:	8b 45 14             	mov    0x14(%ebp),%eax
  1030ff:	8d 50 04             	lea    0x4(%eax),%edx
  103102:	89 55 14             	mov    %edx,0x14(%ebp)
  103105:	8b 00                	mov    (%eax),%eax
  103107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  10310a:	eb 1f                	jmp    10312b <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  10310c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103110:	79 86                	jns    103098 <vprintfmt+0x53>
                width = 0;
  103112:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103119:	e9 7a ff ff ff       	jmp    103098 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  10311e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  103125:	e9 6e ff ff ff       	jmp    103098 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  10312a:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  10312b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10312f:	0f 89 63 ff ff ff    	jns    103098 <vprintfmt+0x53>
                width = precision, precision = -1;
  103135:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103138:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10313b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103142:	e9 51 ff ff ff       	jmp    103098 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  103147:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  10314b:	e9 48 ff ff ff       	jmp    103098 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103150:	8b 45 14             	mov    0x14(%ebp),%eax
  103153:	8d 50 04             	lea    0x4(%eax),%edx
  103156:	89 55 14             	mov    %edx,0x14(%ebp)
  103159:	8b 00                	mov    (%eax),%eax
  10315b:	83 ec 08             	sub    $0x8,%esp
  10315e:	ff 75 0c             	pushl  0xc(%ebp)
  103161:	50                   	push   %eax
  103162:	8b 45 08             	mov    0x8(%ebp),%eax
  103165:	ff d0                	call   *%eax
  103167:	83 c4 10             	add    $0x10,%esp
            break;
  10316a:	e9 71 02 00 00       	jmp    1033e0 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10316f:	8b 45 14             	mov    0x14(%ebp),%eax
  103172:	8d 50 04             	lea    0x4(%eax),%edx
  103175:	89 55 14             	mov    %edx,0x14(%ebp)
  103178:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10317a:	85 db                	test   %ebx,%ebx
  10317c:	79 02                	jns    103180 <vprintfmt+0x13b>
                err = -err;
  10317e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103180:	83 fb 06             	cmp    $0x6,%ebx
  103183:	7f 0b                	jg     103190 <vprintfmt+0x14b>
  103185:	8b 34 9d 54 3c 10 00 	mov    0x103c54(,%ebx,4),%esi
  10318c:	85 f6                	test   %esi,%esi
  10318e:	75 19                	jne    1031a9 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  103190:	53                   	push   %ebx
  103191:	68 81 3c 10 00       	push   $0x103c81
  103196:	ff 75 0c             	pushl  0xc(%ebp)
  103199:	ff 75 08             	pushl  0x8(%ebp)
  10319c:	e8 80 fe ff ff       	call   103021 <printfmt>
  1031a1:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1031a4:	e9 37 02 00 00       	jmp    1033e0 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  1031a9:	56                   	push   %esi
  1031aa:	68 8a 3c 10 00       	push   $0x103c8a
  1031af:	ff 75 0c             	pushl  0xc(%ebp)
  1031b2:	ff 75 08             	pushl  0x8(%ebp)
  1031b5:	e8 67 fe ff ff       	call   103021 <printfmt>
  1031ba:	83 c4 10             	add    $0x10,%esp
            }
            break;
  1031bd:	e9 1e 02 00 00       	jmp    1033e0 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1031c2:	8b 45 14             	mov    0x14(%ebp),%eax
  1031c5:	8d 50 04             	lea    0x4(%eax),%edx
  1031c8:	89 55 14             	mov    %edx,0x14(%ebp)
  1031cb:	8b 30                	mov    (%eax),%esi
  1031cd:	85 f6                	test   %esi,%esi
  1031cf:	75 05                	jne    1031d6 <vprintfmt+0x191>
                p = "(null)";
  1031d1:	be 8d 3c 10 00       	mov    $0x103c8d,%esi
            }
            if (width > 0 && padc != '-') {
  1031d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031da:	7e 76                	jle    103252 <vprintfmt+0x20d>
  1031dc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1031e0:	74 70                	je     103252 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1031e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031e5:	83 ec 08             	sub    $0x8,%esp
  1031e8:	50                   	push   %eax
  1031e9:	56                   	push   %esi
  1031ea:	e8 17 f8 ff ff       	call   102a06 <strnlen>
  1031ef:	83 c4 10             	add    $0x10,%esp
  1031f2:	89 c2                	mov    %eax,%edx
  1031f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031f7:	29 d0                	sub    %edx,%eax
  1031f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031fc:	eb 17                	jmp    103215 <vprintfmt+0x1d0>
                    putch(padc, putdat);
  1031fe:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103202:	83 ec 08             	sub    $0x8,%esp
  103205:	ff 75 0c             	pushl  0xc(%ebp)
  103208:	50                   	push   %eax
  103209:	8b 45 08             	mov    0x8(%ebp),%eax
  10320c:	ff d0                	call   *%eax
  10320e:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  103211:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103215:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103219:	7f e3                	jg     1031fe <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10321b:	eb 35                	jmp    103252 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  10321d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103221:	74 1c                	je     10323f <vprintfmt+0x1fa>
  103223:	83 fb 1f             	cmp    $0x1f,%ebx
  103226:	7e 05                	jle    10322d <vprintfmt+0x1e8>
  103228:	83 fb 7e             	cmp    $0x7e,%ebx
  10322b:	7e 12                	jle    10323f <vprintfmt+0x1fa>
                    putch('?', putdat);
  10322d:	83 ec 08             	sub    $0x8,%esp
  103230:	ff 75 0c             	pushl  0xc(%ebp)
  103233:	6a 3f                	push   $0x3f
  103235:	8b 45 08             	mov    0x8(%ebp),%eax
  103238:	ff d0                	call   *%eax
  10323a:	83 c4 10             	add    $0x10,%esp
  10323d:	eb 0f                	jmp    10324e <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  10323f:	83 ec 08             	sub    $0x8,%esp
  103242:	ff 75 0c             	pushl  0xc(%ebp)
  103245:	53                   	push   %ebx
  103246:	8b 45 08             	mov    0x8(%ebp),%eax
  103249:	ff d0                	call   *%eax
  10324b:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10324e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103252:	89 f0                	mov    %esi,%eax
  103254:	8d 70 01             	lea    0x1(%eax),%esi
  103257:	0f b6 00             	movzbl (%eax),%eax
  10325a:	0f be d8             	movsbl %al,%ebx
  10325d:	85 db                	test   %ebx,%ebx
  10325f:	74 26                	je     103287 <vprintfmt+0x242>
  103261:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103265:	78 b6                	js     10321d <vprintfmt+0x1d8>
  103267:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10326b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10326f:	79 ac                	jns    10321d <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  103271:	eb 14                	jmp    103287 <vprintfmt+0x242>
                putch(' ', putdat);
  103273:	83 ec 08             	sub    $0x8,%esp
  103276:	ff 75 0c             	pushl  0xc(%ebp)
  103279:	6a 20                	push   $0x20
  10327b:	8b 45 08             	mov    0x8(%ebp),%eax
  10327e:	ff d0                	call   *%eax
  103280:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  103283:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103287:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10328b:	7f e6                	jg     103273 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  10328d:	e9 4e 01 00 00       	jmp    1033e0 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103292:	83 ec 08             	sub    $0x8,%esp
  103295:	ff 75 e0             	pushl  -0x20(%ebp)
  103298:	8d 45 14             	lea    0x14(%ebp),%eax
  10329b:	50                   	push   %eax
  10329c:	e8 39 fd ff ff       	call   102fda <getint>
  1032a1:	83 c4 10             	add    $0x10,%esp
  1032a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1032aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032b0:	85 d2                	test   %edx,%edx
  1032b2:	79 23                	jns    1032d7 <vprintfmt+0x292>
                putch('-', putdat);
  1032b4:	83 ec 08             	sub    $0x8,%esp
  1032b7:	ff 75 0c             	pushl  0xc(%ebp)
  1032ba:	6a 2d                	push   $0x2d
  1032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1032bf:	ff d0                	call   *%eax
  1032c1:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  1032c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032ca:	f7 d8                	neg    %eax
  1032cc:	83 d2 00             	adc    $0x0,%edx
  1032cf:	f7 da                	neg    %edx
  1032d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1032d7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1032de:	e9 9f 00 00 00       	jmp    103382 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1032e3:	83 ec 08             	sub    $0x8,%esp
  1032e6:	ff 75 e0             	pushl  -0x20(%ebp)
  1032e9:	8d 45 14             	lea    0x14(%ebp),%eax
  1032ec:	50                   	push   %eax
  1032ed:	e8 99 fc ff ff       	call   102f8b <getuint>
  1032f2:	83 c4 10             	add    $0x10,%esp
  1032f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1032fb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103302:	eb 7e                	jmp    103382 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103304:	83 ec 08             	sub    $0x8,%esp
  103307:	ff 75 e0             	pushl  -0x20(%ebp)
  10330a:	8d 45 14             	lea    0x14(%ebp),%eax
  10330d:	50                   	push   %eax
  10330e:	e8 78 fc ff ff       	call   102f8b <getuint>
  103313:	83 c4 10             	add    $0x10,%esp
  103316:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103319:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10331c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103323:	eb 5d                	jmp    103382 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  103325:	83 ec 08             	sub    $0x8,%esp
  103328:	ff 75 0c             	pushl  0xc(%ebp)
  10332b:	6a 30                	push   $0x30
  10332d:	8b 45 08             	mov    0x8(%ebp),%eax
  103330:	ff d0                	call   *%eax
  103332:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  103335:	83 ec 08             	sub    $0x8,%esp
  103338:	ff 75 0c             	pushl  0xc(%ebp)
  10333b:	6a 78                	push   $0x78
  10333d:	8b 45 08             	mov    0x8(%ebp),%eax
  103340:	ff d0                	call   *%eax
  103342:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  103345:	8b 45 14             	mov    0x14(%ebp),%eax
  103348:	8d 50 04             	lea    0x4(%eax),%edx
  10334b:	89 55 14             	mov    %edx,0x14(%ebp)
  10334e:	8b 00                	mov    (%eax),%eax
  103350:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103353:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10335a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103361:	eb 1f                	jmp    103382 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103363:	83 ec 08             	sub    $0x8,%esp
  103366:	ff 75 e0             	pushl  -0x20(%ebp)
  103369:	8d 45 14             	lea    0x14(%ebp),%eax
  10336c:	50                   	push   %eax
  10336d:	e8 19 fc ff ff       	call   102f8b <getuint>
  103372:	83 c4 10             	add    $0x10,%esp
  103375:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103378:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10337b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103382:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103386:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103389:	83 ec 04             	sub    $0x4,%esp
  10338c:	52                   	push   %edx
  10338d:	ff 75 e8             	pushl  -0x18(%ebp)
  103390:	50                   	push   %eax
  103391:	ff 75 f4             	pushl  -0xc(%ebp)
  103394:	ff 75 f0             	pushl  -0x10(%ebp)
  103397:	ff 75 0c             	pushl  0xc(%ebp)
  10339a:	ff 75 08             	pushl  0x8(%ebp)
  10339d:	e8 f8 fa ff ff       	call   102e9a <printnum>
  1033a2:	83 c4 20             	add    $0x20,%esp
            break;
  1033a5:	eb 39                	jmp    1033e0 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1033a7:	83 ec 08             	sub    $0x8,%esp
  1033aa:	ff 75 0c             	pushl  0xc(%ebp)
  1033ad:	53                   	push   %ebx
  1033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b1:	ff d0                	call   *%eax
  1033b3:	83 c4 10             	add    $0x10,%esp
            break;
  1033b6:	eb 28                	jmp    1033e0 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1033b8:	83 ec 08             	sub    $0x8,%esp
  1033bb:	ff 75 0c             	pushl  0xc(%ebp)
  1033be:	6a 25                	push   $0x25
  1033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c3:	ff d0                	call   *%eax
  1033c5:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  1033c8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1033cc:	eb 04                	jmp    1033d2 <vprintfmt+0x38d>
  1033ce:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1033d2:	8b 45 10             	mov    0x10(%ebp),%eax
  1033d5:	83 e8 01             	sub    $0x1,%eax
  1033d8:	0f b6 00             	movzbl (%eax),%eax
  1033db:	3c 25                	cmp    $0x25,%al
  1033dd:	75 ef                	jne    1033ce <vprintfmt+0x389>
                /* do nothing */;
            break;
  1033df:	90                   	nop
        }
    }
  1033e0:	e9 68 fc ff ff       	jmp    10304d <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  1033e5:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1033e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1033e9:	5b                   	pop    %ebx
  1033ea:	5e                   	pop    %esi
  1033eb:	5d                   	pop    %ebp
  1033ec:	c3                   	ret    

001033ed <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1033ed:	55                   	push   %ebp
  1033ee:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1033f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033f3:	8b 40 08             	mov    0x8(%eax),%eax
  1033f6:	8d 50 01             	lea    0x1(%eax),%edx
  1033f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033fc:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1033ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  103402:	8b 10                	mov    (%eax),%edx
  103404:	8b 45 0c             	mov    0xc(%ebp),%eax
  103407:	8b 40 04             	mov    0x4(%eax),%eax
  10340a:	39 c2                	cmp    %eax,%edx
  10340c:	73 12                	jae    103420 <sprintputch+0x33>
        *b->buf ++ = ch;
  10340e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103411:	8b 00                	mov    (%eax),%eax
  103413:	8d 48 01             	lea    0x1(%eax),%ecx
  103416:	8b 55 0c             	mov    0xc(%ebp),%edx
  103419:	89 0a                	mov    %ecx,(%edx)
  10341b:	8b 55 08             	mov    0x8(%ebp),%edx
  10341e:	88 10                	mov    %dl,(%eax)
    }
}
  103420:	90                   	nop
  103421:	5d                   	pop    %ebp
  103422:	c3                   	ret    

00103423 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103423:	55                   	push   %ebp
  103424:	89 e5                	mov    %esp,%ebp
  103426:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103429:	8d 45 14             	lea    0x14(%ebp),%eax
  10342c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10342f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103432:	50                   	push   %eax
  103433:	ff 75 10             	pushl  0x10(%ebp)
  103436:	ff 75 0c             	pushl  0xc(%ebp)
  103439:	ff 75 08             	pushl  0x8(%ebp)
  10343c:	e8 0b 00 00 00       	call   10344c <vsnprintf>
  103441:	83 c4 10             	add    $0x10,%esp
  103444:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103447:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10344a:	c9                   	leave  
  10344b:	c3                   	ret    

0010344c <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10344c:	55                   	push   %ebp
  10344d:	89 e5                	mov    %esp,%ebp
  10344f:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103452:	8b 45 08             	mov    0x8(%ebp),%eax
  103455:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103458:	8b 45 0c             	mov    0xc(%ebp),%eax
  10345b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10345e:	8b 45 08             	mov    0x8(%ebp),%eax
  103461:	01 d0                	add    %edx,%eax
  103463:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103466:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10346d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103471:	74 0a                	je     10347d <vsnprintf+0x31>
  103473:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103479:	39 c2                	cmp    %eax,%edx
  10347b:	76 07                	jbe    103484 <vsnprintf+0x38>
        return -E_INVAL;
  10347d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103482:	eb 20                	jmp    1034a4 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103484:	ff 75 14             	pushl  0x14(%ebp)
  103487:	ff 75 10             	pushl  0x10(%ebp)
  10348a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10348d:	50                   	push   %eax
  10348e:	68 ed 33 10 00       	push   $0x1033ed
  103493:	e8 ad fb ff ff       	call   103045 <vprintfmt>
  103498:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  10349b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10349e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1034a4:	c9                   	leave  
  1034a5:	c3                   	ret    
