
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
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 ea 10 00       	push   $0x10ea16
  10001f:	e8 be 2a 00 00       	call   102ae2 <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 2f 15 00 00       	call   10155b <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 80 32 10 00 	movl   $0x103280,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 9c 32 10 00       	push   $0x10329c
  10003e:	e8 fa 01 00 00       	call   10023d <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 7c 08 00 00       	call   1008c7 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 74 00 00 00       	call   1000c4 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 51 27 00 00       	call   1027a6 <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 44 16 00 00       	call   10169e <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 a5 17 00 00       	call   101804 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 dc 0c 00 00       	call   100d40 <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 72 17 00 00       	call   1017db <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100069:	eb fe                	jmp    100069 <kern_init+0x69>

0010006b <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10006b:	55                   	push   %ebp
  10006c:	89 e5                	mov    %esp,%ebp
  10006e:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100071:	83 ec 04             	sub    $0x4,%esp
  100074:	6a 00                	push   $0x0
  100076:	6a 00                	push   $0x0
  100078:	6a 00                	push   $0x0
  10007a:	e8 af 0c 00 00       	call   100d2e <mon_backtrace>
  10007f:	83 c4 10             	add    $0x10,%esp
}
  100082:	90                   	nop
  100083:	c9                   	leave  
  100084:	c3                   	ret    

00100085 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100085:	55                   	push   %ebp
  100086:	89 e5                	mov    %esp,%ebp
  100088:	53                   	push   %ebx
  100089:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10008c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  10008f:	8b 55 0c             	mov    0xc(%ebp),%edx
  100092:	8d 5d 08             	lea    0x8(%ebp),%ebx
  100095:	8b 45 08             	mov    0x8(%ebp),%eax
  100098:	51                   	push   %ecx
  100099:	52                   	push   %edx
  10009a:	53                   	push   %ebx
  10009b:	50                   	push   %eax
  10009c:	e8 ca ff ff ff       	call   10006b <grade_backtrace2>
  1000a1:	83 c4 10             	add    $0x10,%esp
}
  1000a4:	90                   	nop
  1000a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000a8:	c9                   	leave  
  1000a9:	c3                   	ret    

001000aa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000aa:	55                   	push   %ebp
  1000ab:	89 e5                	mov    %esp,%ebp
  1000ad:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b0:	83 ec 08             	sub    $0x8,%esp
  1000b3:	ff 75 10             	pushl  0x10(%ebp)
  1000b6:	ff 75 08             	pushl  0x8(%ebp)
  1000b9:	e8 c7 ff ff ff       	call   100085 <grade_backtrace1>
  1000be:	83 c4 10             	add    $0x10,%esp
}
  1000c1:	90                   	nop
  1000c2:	c9                   	leave  
  1000c3:	c3                   	ret    

001000c4 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c4:	55                   	push   %ebp
  1000c5:	89 e5                	mov    %esp,%ebp
  1000c7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000ca:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000cf:	83 ec 04             	sub    $0x4,%esp
  1000d2:	68 00 00 ff ff       	push   $0xffff0000
  1000d7:	50                   	push   %eax
  1000d8:	6a 00                	push   $0x0
  1000da:	e8 cb ff ff ff       	call   1000aa <grade_backtrace0>
  1000df:	83 c4 10             	add    $0x10,%esp
}
  1000e2:	90                   	nop
  1000e3:	c9                   	leave  
  1000e4:	c3                   	ret    

001000e5 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000e5:	55                   	push   %ebp
  1000e6:	89 e5                	mov    %esp,%ebp
  1000e8:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000eb:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000ee:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f1:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f4:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000f7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1000fb:	0f b7 c0             	movzwl %ax,%eax
  1000fe:	83 e0 03             	and    $0x3,%eax
  100101:	89 c2                	mov    %eax,%edx
  100103:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100108:	83 ec 04             	sub    $0x4,%esp
  10010b:	52                   	push   %edx
  10010c:	50                   	push   %eax
  10010d:	68 a1 32 10 00       	push   $0x1032a1
  100112:	e8 26 01 00 00       	call   10023d <cprintf>
  100117:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011e:	0f b7 d0             	movzwl %ax,%edx
  100121:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100126:	83 ec 04             	sub    $0x4,%esp
  100129:	52                   	push   %edx
  10012a:	50                   	push   %eax
  10012b:	68 af 32 10 00       	push   $0x1032af
  100130:	e8 08 01 00 00       	call   10023d <cprintf>
  100135:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100138:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10013c:	0f b7 d0             	movzwl %ax,%edx
  10013f:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100144:	83 ec 04             	sub    $0x4,%esp
  100147:	52                   	push   %edx
  100148:	50                   	push   %eax
  100149:	68 bd 32 10 00       	push   $0x1032bd
  10014e:	e8 ea 00 00 00       	call   10023d <cprintf>
  100153:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100156:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015a:	0f b7 d0             	movzwl %ax,%edx
  10015d:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100162:	83 ec 04             	sub    $0x4,%esp
  100165:	52                   	push   %edx
  100166:	50                   	push   %eax
  100167:	68 cb 32 10 00       	push   $0x1032cb
  10016c:	e8 cc 00 00 00       	call   10023d <cprintf>
  100171:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100174:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100178:	0f b7 d0             	movzwl %ax,%edx
  10017b:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100180:	83 ec 04             	sub    $0x4,%esp
  100183:	52                   	push   %edx
  100184:	50                   	push   %eax
  100185:	68 d9 32 10 00       	push   $0x1032d9
  10018a:	e8 ae 00 00 00       	call   10023d <cprintf>
  10018f:	83 c4 10             	add    $0x10,%esp
    round ++;
  100192:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100197:	83 c0 01             	add    $0x1,%eax
  10019a:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  10019f:	90                   	nop
  1001a0:	c9                   	leave  
  1001a1:	c3                   	ret    

001001a2 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001a2:	55                   	push   %ebp
  1001a3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001a5:	90                   	nop
  1001a6:	5d                   	pop    %ebp
  1001a7:	c3                   	ret    

001001a8 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001a8:	55                   	push   %ebp
  1001a9:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ab:	90                   	nop
  1001ac:	5d                   	pop    %ebp
  1001ad:	c3                   	ret    

001001ae <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001ae:	55                   	push   %ebp
  1001af:	89 e5                	mov    %esp,%ebp
  1001b1:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001b4:	e8 2c ff ff ff       	call   1000e5 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001b9:	83 ec 0c             	sub    $0xc,%esp
  1001bc:	68 e8 32 10 00       	push   $0x1032e8
  1001c1:	e8 77 00 00 00       	call   10023d <cprintf>
  1001c6:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001c9:	e8 d4 ff ff ff       	call   1001a2 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ce:	e8 12 ff ff ff       	call   1000e5 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001d3:	83 ec 0c             	sub    $0xc,%esp
  1001d6:	68 08 33 10 00       	push   $0x103308
  1001db:	e8 5d 00 00 00       	call   10023d <cprintf>
  1001e0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001e3:	e8 c0 ff ff ff       	call   1001a8 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001e8:	e8 f8 fe ff ff       	call   1000e5 <lab1_print_cur_status>
}
  1001ed:	90                   	nop
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
  1001f3:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  1001f6:	83 ec 0c             	sub    $0xc,%esp
  1001f9:	ff 75 08             	pushl  0x8(%ebp)
  1001fc:	e8 8b 13 00 00       	call   10158c <cons_putc>
  100201:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100204:	8b 45 0c             	mov    0xc(%ebp),%eax
  100207:	8b 00                	mov    (%eax),%eax
  100209:	8d 50 01             	lea    0x1(%eax),%edx
  10020c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10020f:	89 10                	mov    %edx,(%eax)
}
  100211:	90                   	nop
  100212:	c9                   	leave  
  100213:	c3                   	ret    

00100214 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100214:	55                   	push   %ebp
  100215:	89 e5                	mov    %esp,%ebp
  100217:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10021a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100221:	ff 75 0c             	pushl  0xc(%ebp)
  100224:	ff 75 08             	pushl  0x8(%ebp)
  100227:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10022a:	50                   	push   %eax
  10022b:	68 f0 01 10 00       	push   $0x1001f0
  100230:	e8 e3 2b 00 00       	call   102e18 <vprintfmt>
  100235:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100238:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10023b:	c9                   	leave  
  10023c:	c3                   	ret    

0010023d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10023d:	55                   	push   %ebp
  10023e:	89 e5                	mov    %esp,%ebp
  100240:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100243:	8d 45 0c             	lea    0xc(%ebp),%eax
  100246:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10024c:	83 ec 08             	sub    $0x8,%esp
  10024f:	50                   	push   %eax
  100250:	ff 75 08             	pushl  0x8(%ebp)
  100253:	e8 bc ff ff ff       	call   100214 <vcprintf>
  100258:	83 c4 10             	add    $0x10,%esp
  10025b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100261:	c9                   	leave  
  100262:	c3                   	ret    

00100263 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100263:	55                   	push   %ebp
  100264:	89 e5                	mov    %esp,%ebp
  100266:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100269:	83 ec 0c             	sub    $0xc,%esp
  10026c:	ff 75 08             	pushl  0x8(%ebp)
  10026f:	e8 18 13 00 00       	call   10158c <cons_putc>
  100274:	83 c4 10             	add    $0x10,%esp
}
  100277:	90                   	nop
  100278:	c9                   	leave  
  100279:	c3                   	ret    

0010027a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10027a:	55                   	push   %ebp
  10027b:	89 e5                	mov    %esp,%ebp
  10027d:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100280:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100287:	eb 14                	jmp    10029d <cputs+0x23>
        cputch(c, &cnt);
  100289:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10028d:	83 ec 08             	sub    $0x8,%esp
  100290:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100293:	52                   	push   %edx
  100294:	50                   	push   %eax
  100295:	e8 56 ff ff ff       	call   1001f0 <cputch>
  10029a:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10029d:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a0:	8d 50 01             	lea    0x1(%eax),%edx
  1002a3:	89 55 08             	mov    %edx,0x8(%ebp)
  1002a6:	0f b6 00             	movzbl (%eax),%eax
  1002a9:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002ac:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002b0:	75 d7                	jne    100289 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002b2:	83 ec 08             	sub    $0x8,%esp
  1002b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002b8:	50                   	push   %eax
  1002b9:	6a 0a                	push   $0xa
  1002bb:	e8 30 ff ff ff       	call   1001f0 <cputch>
  1002c0:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002c6:	c9                   	leave  
  1002c7:	c3                   	ret    

001002c8 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002c8:	55                   	push   %ebp
  1002c9:	89 e5                	mov    %esp,%ebp
  1002cb:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002ce:	e8 e9 12 00 00       	call   1015bc <cons_getc>
  1002d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002da:	74 f2                	je     1002ce <getchar+0x6>
        /* do nothing */;
    return c;
  1002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002df:	c9                   	leave  
  1002e0:	c3                   	ret    

001002e1 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002e1:	55                   	push   %ebp
  1002e2:	89 e5                	mov    %esp,%ebp
  1002e4:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  1002e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002eb:	74 13                	je     100300 <readline+0x1f>
        cprintf("%s", prompt);
  1002ed:	83 ec 08             	sub    $0x8,%esp
  1002f0:	ff 75 08             	pushl  0x8(%ebp)
  1002f3:	68 27 33 10 00       	push   $0x103327
  1002f8:	e8 40 ff ff ff       	call   10023d <cprintf>
  1002fd:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100300:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100307:	e8 bc ff ff ff       	call   1002c8 <getchar>
  10030c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10030f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100313:	79 0a                	jns    10031f <readline+0x3e>
            return NULL;
  100315:	b8 00 00 00 00       	mov    $0x0,%eax
  10031a:	e9 82 00 00 00       	jmp    1003a1 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10031f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100323:	7e 2b                	jle    100350 <readline+0x6f>
  100325:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10032c:	7f 22                	jg     100350 <readline+0x6f>
            cputchar(c);
  10032e:	83 ec 0c             	sub    $0xc,%esp
  100331:	ff 75 f0             	pushl  -0x10(%ebp)
  100334:	e8 2a ff ff ff       	call   100263 <cputchar>
  100339:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10033c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10033f:	8d 50 01             	lea    0x1(%eax),%edx
  100342:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100345:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100348:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  10034e:	eb 4c                	jmp    10039c <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  100350:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100354:	75 1a                	jne    100370 <readline+0x8f>
  100356:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10035a:	7e 14                	jle    100370 <readline+0x8f>
            cputchar(c);
  10035c:	83 ec 0c             	sub    $0xc,%esp
  10035f:	ff 75 f0             	pushl  -0x10(%ebp)
  100362:	e8 fc fe ff ff       	call   100263 <cputchar>
  100367:	83 c4 10             	add    $0x10,%esp
            i --;
  10036a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10036e:	eb 2c                	jmp    10039c <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  100370:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100374:	74 06                	je     10037c <readline+0x9b>
  100376:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10037a:	75 8b                	jne    100307 <readline+0x26>
            cputchar(c);
  10037c:	83 ec 0c             	sub    $0xc,%esp
  10037f:	ff 75 f0             	pushl  -0x10(%ebp)
  100382:	e8 dc fe ff ff       	call   100263 <cputchar>
  100387:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  10038a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10038d:	05 40 ea 10 00       	add    $0x10ea40,%eax
  100392:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100395:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  10039a:	eb 05                	jmp    1003a1 <readline+0xc0>
        }
    }
  10039c:	e9 66 ff ff ff       	jmp    100307 <readline+0x26>
}
  1003a1:	c9                   	leave  
  1003a2:	c3                   	ret    

001003a3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003a3:	55                   	push   %ebp
  1003a4:	89 e5                	mov    %esp,%ebp
  1003a6:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003a9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003ae:	85 c0                	test   %eax,%eax
  1003b0:	75 4a                	jne    1003fc <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003b2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003b9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003bc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003c2:	83 ec 04             	sub    $0x4,%esp
  1003c5:	ff 75 0c             	pushl  0xc(%ebp)
  1003c8:	ff 75 08             	pushl  0x8(%ebp)
  1003cb:	68 2a 33 10 00       	push   $0x10332a
  1003d0:	e8 68 fe ff ff       	call   10023d <cprintf>
  1003d5:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003db:	83 ec 08             	sub    $0x8,%esp
  1003de:	50                   	push   %eax
  1003df:	ff 75 10             	pushl  0x10(%ebp)
  1003e2:	e8 2d fe ff ff       	call   100214 <vcprintf>
  1003e7:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1003ea:	83 ec 0c             	sub    $0xc,%esp
  1003ed:	68 46 33 10 00       	push   $0x103346
  1003f2:	e8 46 fe ff ff       	call   10023d <cprintf>
  1003f7:	83 c4 10             	add    $0x10,%esp
  1003fa:	eb 01                	jmp    1003fd <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  1003fc:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  1003fd:	e8 e0 13 00 00       	call   1017e2 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100402:	83 ec 0c             	sub    $0xc,%esp
  100405:	6a 00                	push   $0x0
  100407:	e8 48 08 00 00       	call   100c54 <kmonitor>
  10040c:	83 c4 10             	add    $0x10,%esp
    }
  10040f:	eb f1                	jmp    100402 <__panic+0x5f>

00100411 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100411:	55                   	push   %ebp
  100412:	89 e5                	mov    %esp,%ebp
  100414:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100417:	8d 45 14             	lea    0x14(%ebp),%eax
  10041a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10041d:	83 ec 04             	sub    $0x4,%esp
  100420:	ff 75 0c             	pushl  0xc(%ebp)
  100423:	ff 75 08             	pushl  0x8(%ebp)
  100426:	68 48 33 10 00       	push   $0x103348
  10042b:	e8 0d fe ff ff       	call   10023d <cprintf>
  100430:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100436:	83 ec 08             	sub    $0x8,%esp
  100439:	50                   	push   %eax
  10043a:	ff 75 10             	pushl  0x10(%ebp)
  10043d:	e8 d2 fd ff ff       	call   100214 <vcprintf>
  100442:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100445:	83 ec 0c             	sub    $0xc,%esp
  100448:	68 46 33 10 00       	push   $0x103346
  10044d:	e8 eb fd ff ff       	call   10023d <cprintf>
  100452:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100455:	90                   	nop
  100456:	c9                   	leave  
  100457:	c3                   	ret    

00100458 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100458:	55                   	push   %ebp
  100459:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10045b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100460:	5d                   	pop    %ebp
  100461:	c3                   	ret    

00100462 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100462:	55                   	push   %ebp
  100463:	89 e5                	mov    %esp,%ebp
  100465:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100468:	8b 45 0c             	mov    0xc(%ebp),%eax
  10046b:	8b 00                	mov    (%eax),%eax
  10046d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100470:	8b 45 10             	mov    0x10(%ebp),%eax
  100473:	8b 00                	mov    (%eax),%eax
  100475:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100478:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10047f:	e9 d2 00 00 00       	jmp    100556 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  100484:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100487:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10048a:	01 d0                	add    %edx,%eax
  10048c:	89 c2                	mov    %eax,%edx
  10048e:	c1 ea 1f             	shr    $0x1f,%edx
  100491:	01 d0                	add    %edx,%eax
  100493:	d1 f8                	sar    %eax
  100495:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100498:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10049b:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10049e:	eb 04                	jmp    1004a4 <stab_binsearch+0x42>
            m --;
  1004a0:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004aa:	7c 1f                	jl     1004cb <stab_binsearch+0x69>
  1004ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004af:	89 d0                	mov    %edx,%eax
  1004b1:	01 c0                	add    %eax,%eax
  1004b3:	01 d0                	add    %edx,%eax
  1004b5:	c1 e0 02             	shl    $0x2,%eax
  1004b8:	89 c2                	mov    %eax,%edx
  1004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1004bd:	01 d0                	add    %edx,%eax
  1004bf:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004c3:	0f b6 c0             	movzbl %al,%eax
  1004c6:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004c9:	75 d5                	jne    1004a0 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d1:	7d 0b                	jge    1004de <stab_binsearch+0x7c>
            l = true_m + 1;
  1004d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004d6:	83 c0 01             	add    $0x1,%eax
  1004d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004dc:	eb 78                	jmp    100556 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004de:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  1004e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004e8:	89 d0                	mov    %edx,%eax
  1004ea:	01 c0                	add    %eax,%eax
  1004ec:	01 d0                	add    %edx,%eax
  1004ee:	c1 e0 02             	shl    $0x2,%eax
  1004f1:	89 c2                	mov    %eax,%edx
  1004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f6:	01 d0                	add    %edx,%eax
  1004f8:	8b 40 08             	mov    0x8(%eax),%eax
  1004fb:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004fe:	73 13                	jae    100513 <stab_binsearch+0xb1>
            *region_left = m;
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100506:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10050b:	83 c0 01             	add    $0x1,%eax
  10050e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100511:	eb 43                	jmp    100556 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100513:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100516:	89 d0                	mov    %edx,%eax
  100518:	01 c0                	add    %eax,%eax
  10051a:	01 d0                	add    %edx,%eax
  10051c:	c1 e0 02             	shl    $0x2,%eax
  10051f:	89 c2                	mov    %eax,%edx
  100521:	8b 45 08             	mov    0x8(%ebp),%eax
  100524:	01 d0                	add    %edx,%eax
  100526:	8b 40 08             	mov    0x8(%eax),%eax
  100529:	3b 45 18             	cmp    0x18(%ebp),%eax
  10052c:	76 16                	jbe    100544 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10052e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100531:	8d 50 ff             	lea    -0x1(%eax),%edx
  100534:	8b 45 10             	mov    0x10(%ebp),%eax
  100537:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10053c:	83 e8 01             	sub    $0x1,%eax
  10053f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100542:	eb 12                	jmp    100556 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10054a:	89 10                	mov    %edx,(%eax)
            l = m;
  10054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100552:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100556:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100559:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10055c:	0f 8e 22 ff ff ff    	jle    100484 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  100562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100566:	75 0f                	jne    100577 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100568:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056b:	8b 00                	mov    (%eax),%eax
  10056d:	8d 50 ff             	lea    -0x1(%eax),%edx
  100570:	8b 45 10             	mov    0x10(%ebp),%eax
  100573:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100575:	eb 3f                	jmp    1005b6 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100577:	8b 45 10             	mov    0x10(%ebp),%eax
  10057a:	8b 00                	mov    (%eax),%eax
  10057c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10057f:	eb 04                	jmp    100585 <stab_binsearch+0x123>
  100581:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100585:	8b 45 0c             	mov    0xc(%ebp),%eax
  100588:	8b 00                	mov    (%eax),%eax
  10058a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10058d:	7d 1f                	jge    1005ae <stab_binsearch+0x14c>
  10058f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100592:	89 d0                	mov    %edx,%eax
  100594:	01 c0                	add    %eax,%eax
  100596:	01 d0                	add    %edx,%eax
  100598:	c1 e0 02             	shl    $0x2,%eax
  10059b:	89 c2                	mov    %eax,%edx
  10059d:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a0:	01 d0                	add    %edx,%eax
  1005a2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005a6:	0f b6 c0             	movzbl %al,%eax
  1005a9:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005ac:	75 d3                	jne    100581 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005b4:	89 10                	mov    %edx,(%eax)
    }
}
  1005b6:	90                   	nop
  1005b7:	c9                   	leave  
  1005b8:	c3                   	ret    

001005b9 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005b9:	55                   	push   %ebp
  1005ba:	89 e5                	mov    %esp,%ebp
  1005bc:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c2:	c7 00 68 33 10 00    	movl   $0x103368,(%eax)
    info->eip_line = 0;
  1005c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d5:	c7 40 08 68 33 10 00 	movl   $0x103368,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005df:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e9:	8b 55 08             	mov    0x8(%ebp),%edx
  1005ec:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  1005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  1005f9:	c7 45 f4 8c 3b 10 00 	movl   $0x103b8c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100600:	c7 45 f0 7c b4 10 00 	movl   $0x10b47c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100607:	c7 45 ec 7d b4 10 00 	movl   $0x10b47d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10060e:	c7 45 e8 e5 d4 10 00 	movl   $0x10d4e5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100615:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100618:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10061b:	76 0d                	jbe    10062a <debuginfo_eip+0x71>
  10061d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100620:	83 e8 01             	sub    $0x1,%eax
  100623:	0f b6 00             	movzbl (%eax),%eax
  100626:	84 c0                	test   %al,%al
  100628:	74 0a                	je     100634 <debuginfo_eip+0x7b>
        return -1;
  10062a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10062f:	e9 91 02 00 00       	jmp    1008c5 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100634:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10063b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10063e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100641:	29 c2                	sub    %eax,%edx
  100643:	89 d0                	mov    %edx,%eax
  100645:	c1 f8 02             	sar    $0x2,%eax
  100648:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10064e:	83 e8 01             	sub    $0x1,%eax
  100651:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100654:	ff 75 08             	pushl  0x8(%ebp)
  100657:	6a 64                	push   $0x64
  100659:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10065c:	50                   	push   %eax
  10065d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100660:	50                   	push   %eax
  100661:	ff 75 f4             	pushl  -0xc(%ebp)
  100664:	e8 f9 fd ff ff       	call   100462 <stab_binsearch>
  100669:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  10066c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10066f:	85 c0                	test   %eax,%eax
  100671:	75 0a                	jne    10067d <debuginfo_eip+0xc4>
        return -1;
  100673:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100678:	e9 48 02 00 00       	jmp    1008c5 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10067d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100680:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100683:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100686:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100689:	ff 75 08             	pushl  0x8(%ebp)
  10068c:	6a 24                	push   $0x24
  10068e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100691:	50                   	push   %eax
  100692:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100695:	50                   	push   %eax
  100696:	ff 75 f4             	pushl  -0xc(%ebp)
  100699:	e8 c4 fd ff ff       	call   100462 <stab_binsearch>
  10069e:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006a7:	39 c2                	cmp    %eax,%edx
  1006a9:	7f 7c                	jg     100727 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006ae:	89 c2                	mov    %eax,%edx
  1006b0:	89 d0                	mov    %edx,%eax
  1006b2:	01 c0                	add    %eax,%eax
  1006b4:	01 d0                	add    %edx,%eax
  1006b6:	c1 e0 02             	shl    $0x2,%eax
  1006b9:	89 c2                	mov    %eax,%edx
  1006bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006be:	01 d0                	add    %edx,%eax
  1006c0:	8b 00                	mov    (%eax),%eax
  1006c2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006c8:	29 d1                	sub    %edx,%ecx
  1006ca:	89 ca                	mov    %ecx,%edx
  1006cc:	39 d0                	cmp    %edx,%eax
  1006ce:	73 22                	jae    1006f2 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006d3:	89 c2                	mov    %eax,%edx
  1006d5:	89 d0                	mov    %edx,%eax
  1006d7:	01 c0                	add    %eax,%eax
  1006d9:	01 d0                	add    %edx,%eax
  1006db:	c1 e0 02             	shl    $0x2,%eax
  1006de:	89 c2                	mov    %eax,%edx
  1006e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e3:	01 d0                	add    %edx,%eax
  1006e5:	8b 10                	mov    (%eax),%edx
  1006e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006ea:	01 c2                	add    %eax,%edx
  1006ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ef:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1006f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006f5:	89 c2                	mov    %eax,%edx
  1006f7:	89 d0                	mov    %edx,%eax
  1006f9:	01 c0                	add    %eax,%eax
  1006fb:	01 d0                	add    %edx,%eax
  1006fd:	c1 e0 02             	shl    $0x2,%eax
  100700:	89 c2                	mov    %eax,%edx
  100702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100705:	01 d0                	add    %edx,%eax
  100707:	8b 50 08             	mov    0x8(%eax),%edx
  10070a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10070d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100710:	8b 45 0c             	mov    0xc(%ebp),%eax
  100713:	8b 40 10             	mov    0x10(%eax),%eax
  100716:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100719:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10071c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10071f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100722:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100725:	eb 15                	jmp    10073c <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100727:	8b 45 0c             	mov    0xc(%ebp),%eax
  10072a:	8b 55 08             	mov    0x8(%ebp),%edx
  10072d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100733:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100736:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100739:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10073c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073f:	8b 40 08             	mov    0x8(%eax),%eax
  100742:	83 ec 08             	sub    $0x8,%esp
  100745:	6a 3a                	push   $0x3a
  100747:	50                   	push   %eax
  100748:	e8 09 22 00 00       	call   102956 <strfind>
  10074d:	83 c4 10             	add    $0x10,%esp
  100750:	89 c2                	mov    %eax,%edx
  100752:	8b 45 0c             	mov    0xc(%ebp),%eax
  100755:	8b 40 08             	mov    0x8(%eax),%eax
  100758:	29 c2                	sub    %eax,%edx
  10075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075d:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100760:	83 ec 0c             	sub    $0xc,%esp
  100763:	ff 75 08             	pushl  0x8(%ebp)
  100766:	6a 44                	push   $0x44
  100768:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10076b:	50                   	push   %eax
  10076c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10076f:	50                   	push   %eax
  100770:	ff 75 f4             	pushl  -0xc(%ebp)
  100773:	e8 ea fc ff ff       	call   100462 <stab_binsearch>
  100778:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  10077b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10077e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100781:	39 c2                	cmp    %eax,%edx
  100783:	7f 24                	jg     1007a9 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  100785:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100788:	89 c2                	mov    %eax,%edx
  10078a:	89 d0                	mov    %edx,%eax
  10078c:	01 c0                	add    %eax,%eax
  10078e:	01 d0                	add    %edx,%eax
  100790:	c1 e0 02             	shl    $0x2,%eax
  100793:	89 c2                	mov    %eax,%edx
  100795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100798:	01 d0                	add    %edx,%eax
  10079a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10079e:	0f b7 d0             	movzwl %ax,%edx
  1007a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a4:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007a7:	eb 13                	jmp    1007bc <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ae:	e9 12 01 00 00       	jmp    1008c5 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b6:	83 e8 01             	sub    $0x1,%eax
  1007b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007c2:	39 c2                	cmp    %eax,%edx
  1007c4:	7c 56                	jl     10081c <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007c9:	89 c2                	mov    %eax,%edx
  1007cb:	89 d0                	mov    %edx,%eax
  1007cd:	01 c0                	add    %eax,%eax
  1007cf:	01 d0                	add    %edx,%eax
  1007d1:	c1 e0 02             	shl    $0x2,%eax
  1007d4:	89 c2                	mov    %eax,%edx
  1007d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007d9:	01 d0                	add    %edx,%eax
  1007db:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007df:	3c 84                	cmp    $0x84,%al
  1007e1:	74 39                	je     10081c <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1007e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e6:	89 c2                	mov    %eax,%edx
  1007e8:	89 d0                	mov    %edx,%eax
  1007ea:	01 c0                	add    %eax,%eax
  1007ec:	01 d0                	add    %edx,%eax
  1007ee:	c1 e0 02             	shl    $0x2,%eax
  1007f1:	89 c2                	mov    %eax,%edx
  1007f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f6:	01 d0                	add    %edx,%eax
  1007f8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007fc:	3c 64                	cmp    $0x64,%al
  1007fe:	75 b3                	jne    1007b3 <debuginfo_eip+0x1fa>
  100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100803:	89 c2                	mov    %eax,%edx
  100805:	89 d0                	mov    %edx,%eax
  100807:	01 c0                	add    %eax,%eax
  100809:	01 d0                	add    %edx,%eax
  10080b:	c1 e0 02             	shl    $0x2,%eax
  10080e:	89 c2                	mov    %eax,%edx
  100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100813:	01 d0                	add    %edx,%eax
  100815:	8b 40 08             	mov    0x8(%eax),%eax
  100818:	85 c0                	test   %eax,%eax
  10081a:	74 97                	je     1007b3 <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10081c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100822:	39 c2                	cmp    %eax,%edx
  100824:	7c 46                	jl     10086c <debuginfo_eip+0x2b3>
  100826:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100829:	89 c2                	mov    %eax,%edx
  10082b:	89 d0                	mov    %edx,%eax
  10082d:	01 c0                	add    %eax,%eax
  10082f:	01 d0                	add    %edx,%eax
  100831:	c1 e0 02             	shl    $0x2,%eax
  100834:	89 c2                	mov    %eax,%edx
  100836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100839:	01 d0                	add    %edx,%eax
  10083b:	8b 00                	mov    (%eax),%eax
  10083d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100840:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100843:	29 d1                	sub    %edx,%ecx
  100845:	89 ca                	mov    %ecx,%edx
  100847:	39 d0                	cmp    %edx,%eax
  100849:	73 21                	jae    10086c <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10084b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084e:	89 c2                	mov    %eax,%edx
  100850:	89 d0                	mov    %edx,%eax
  100852:	01 c0                	add    %eax,%eax
  100854:	01 d0                	add    %edx,%eax
  100856:	c1 e0 02             	shl    $0x2,%eax
  100859:	89 c2                	mov    %eax,%edx
  10085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085e:	01 d0                	add    %edx,%eax
  100860:	8b 10                	mov    (%eax),%edx
  100862:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100865:	01 c2                	add    %eax,%edx
  100867:	8b 45 0c             	mov    0xc(%ebp),%eax
  10086a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10086c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10086f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100872:	39 c2                	cmp    %eax,%edx
  100874:	7d 4a                	jge    1008c0 <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  100876:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100879:	83 c0 01             	add    $0x1,%eax
  10087c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10087f:	eb 18                	jmp    100899 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100881:	8b 45 0c             	mov    0xc(%ebp),%eax
  100884:	8b 40 14             	mov    0x14(%eax),%eax
  100887:	8d 50 01             	lea    0x1(%eax),%edx
  10088a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10088d:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100890:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100893:	83 c0 01             	add    $0x1,%eax
  100896:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100899:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10089c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10089f:	39 c2                	cmp    %eax,%edx
  1008a1:	7d 1d                	jge    1008c0 <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008a6:	89 c2                	mov    %eax,%edx
  1008a8:	89 d0                	mov    %edx,%eax
  1008aa:	01 c0                	add    %eax,%eax
  1008ac:	01 d0                	add    %edx,%eax
  1008ae:	c1 e0 02             	shl    $0x2,%eax
  1008b1:	89 c2                	mov    %eax,%edx
  1008b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008b6:	01 d0                	add    %edx,%eax
  1008b8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008bc:	3c a0                	cmp    $0xa0,%al
  1008be:	74 c1                	je     100881 <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008c5:	c9                   	leave  
  1008c6:	c3                   	ret    

001008c7 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008c7:	55                   	push   %ebp
  1008c8:	89 e5                	mov    %esp,%ebp
  1008ca:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008cd:	83 ec 0c             	sub    $0xc,%esp
  1008d0:	68 72 33 10 00       	push   $0x103372
  1008d5:	e8 63 f9 ff ff       	call   10023d <cprintf>
  1008da:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008dd:	83 ec 08             	sub    $0x8,%esp
  1008e0:	68 00 00 10 00       	push   $0x100000
  1008e5:	68 8b 33 10 00       	push   $0x10338b
  1008ea:	e8 4e f9 ff ff       	call   10023d <cprintf>
  1008ef:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008f2:	83 ec 08             	sub    $0x8,%esp
  1008f5:	68 79 32 10 00       	push   $0x103279
  1008fa:	68 a3 33 10 00       	push   $0x1033a3
  1008ff:	e8 39 f9 ff ff       	call   10023d <cprintf>
  100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100907:	83 ec 08             	sub    $0x8,%esp
  10090a:	68 16 ea 10 00       	push   $0x10ea16
  10090f:	68 bb 33 10 00       	push   $0x1033bb
  100914:	e8 24 f9 ff ff       	call   10023d <cprintf>
  100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10091c:	83 ec 08             	sub    $0x8,%esp
  10091f:	68 20 fd 10 00       	push   $0x10fd20
  100924:	68 d3 33 10 00       	push   $0x1033d3
  100929:	e8 0f f9 ff ff       	call   10023d <cprintf>
  10092e:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100931:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  100936:	05 ff 03 00 00       	add    $0x3ff,%eax
  10093b:	ba 00 00 10 00       	mov    $0x100000,%edx
  100940:	29 d0                	sub    %edx,%eax
  100942:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100948:	85 c0                	test   %eax,%eax
  10094a:	0f 48 c2             	cmovs  %edx,%eax
  10094d:	c1 f8 0a             	sar    $0xa,%eax
  100950:	83 ec 08             	sub    $0x8,%esp
  100953:	50                   	push   %eax
  100954:	68 ec 33 10 00       	push   $0x1033ec
  100959:	e8 df f8 ff ff       	call   10023d <cprintf>
  10095e:	83 c4 10             	add    $0x10,%esp
}
  100961:	90                   	nop
  100962:	c9                   	leave  
  100963:	c3                   	ret    

00100964 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100964:	55                   	push   %ebp
  100965:	89 e5                	mov    %esp,%ebp
  100967:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10096d:	83 ec 08             	sub    $0x8,%esp
  100970:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100973:	50                   	push   %eax
  100974:	ff 75 08             	pushl  0x8(%ebp)
  100977:	e8 3d fc ff ff       	call   1005b9 <debuginfo_eip>
  10097c:	83 c4 10             	add    $0x10,%esp
  10097f:	85 c0                	test   %eax,%eax
  100981:	74 15                	je     100998 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100983:	83 ec 08             	sub    $0x8,%esp
  100986:	ff 75 08             	pushl  0x8(%ebp)
  100989:	68 16 34 10 00       	push   $0x103416
  10098e:	e8 aa f8 ff ff       	call   10023d <cprintf>
  100993:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100996:	eb 65                	jmp    1009fd <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100998:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10099f:	eb 1c                	jmp    1009bd <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009a7:	01 d0                	add    %edx,%eax
  1009a9:	0f b6 00             	movzbl (%eax),%eax
  1009ac:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009b5:	01 ca                	add    %ecx,%edx
  1009b7:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009c3:	7f dc                	jg     1009a1 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009c5:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ce:	01 d0                	add    %edx,%eax
  1009d0:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  1009d6:	8b 55 08             	mov    0x8(%ebp),%edx
  1009d9:	89 d1                	mov    %edx,%ecx
  1009db:	29 c1                	sub    %eax,%ecx
  1009dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1009e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009e3:	83 ec 0c             	sub    $0xc,%esp
  1009e6:	51                   	push   %ecx
  1009e7:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009ed:	51                   	push   %ecx
  1009ee:	52                   	push   %edx
  1009ef:	50                   	push   %eax
  1009f0:	68 32 34 10 00       	push   $0x103432
  1009f5:	e8 43 f8 ff ff       	call   10023d <cprintf>
  1009fa:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  1009fd:	90                   	nop
  1009fe:	c9                   	leave  
  1009ff:	c3                   	ret    

00100a00 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a00:	55                   	push   %ebp
  100a01:	89 e5                	mov    %esp,%ebp
  100a03:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a06:	8b 45 04             	mov    0x4(%ebp),%eax
  100a09:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a0f:	c9                   	leave  
  100a10:	c3                   	ret    

00100a11 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a11:	55                   	push   %ebp
  100a12:	89 e5                	mov    %esp,%ebp
  100a14:	53                   	push   %ebx
  100a15:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a18:	89 e8                	mov    %ebp,%eax
  100a1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    // 1. read_ebp
    uint32_t stack_val_ebp = read_ebp();
  100a20:	89 45 f4             	mov    %eax,-0xc(%ebp)

    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
  100a23:	e8 d8 ff ff ff       	call   100a00 <read_eip>
  100a28:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  100a2b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a32:	e9 9e 00 00 00       	jmp    100ad5 <print_stackframe+0xc4>
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);
  100a37:	83 ec 04             	sub    $0x4,%esp
  100a3a:	ff 75 f0             	pushl  -0x10(%ebp)
  100a3d:	ff 75 f4             	pushl  -0xc(%ebp)
  100a40:	68 44 34 10 00       	push   $0x103444
  100a45:	e8 f3 f7 ff ff       	call   10023d <cprintf>
  100a4a:	83 c4 10             	add    $0x10,%esp

        // get args
        for (int j = 0; j < 4; j++) {
  100a4d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a54:	eb 1f                	jmp    100a75 <print_stackframe+0x64>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
  100a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a63:	01 d0                	add    %edx,%eax
  100a65:	83 c0 08             	add    $0x8,%eax
  100a68:	8b 10                	mov    (%eax),%edx
  100a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a6d:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);

        // get args
        for (int j = 0; j < 4; j++) {
  100a71:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a75:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a79:	7e db                	jle    100a56 <print_stackframe+0x45>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
        }

        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", stack_val_args[0], 
  100a7b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  100a7e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  100a81:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100a84:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a87:	83 ec 0c             	sub    $0xc,%esp
  100a8a:	53                   	push   %ebx
  100a8b:	51                   	push   %ecx
  100a8c:	52                   	push   %edx
  100a8d:	50                   	push   %eax
  100a8e:	68 5c 34 10 00       	push   $0x10345c
  100a93:	e8 a5 f7 ff ff       	call   10023d <cprintf>
  100a98:	83 c4 20             	add    $0x20,%esp
                stack_val_args[1], stack_val_args[2], stack_val_args[3]);

        // print function info
        print_debuginfo(stack_val_eip - 1);
  100a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a9e:	83 e8 01             	sub    $0x1,%eax
  100aa1:	83 ec 0c             	sub    $0xc,%esp
  100aa4:	50                   	push   %eax
  100aa5:	e8 ba fe ff ff       	call   100964 <print_debuginfo>
  100aaa:	83 c4 10             	add    $0x10,%esp

        // pop up stackframe, refresh ebp & eip
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
  100aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab0:	83 c0 04             	add    $0x4,%eax
  100ab3:	8b 00                	mov    (%eax),%eax
  100ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stack_val_eip = ((uint32_t *)stack_val_ebp)[1];
  100ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100abb:	83 c0 04             	add    $0x4,%eax
  100abe:	8b 00                	mov    (%eax),%eax
  100ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));
  100ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac6:	8b 00                	mov    (%eax),%eax
  100ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)

        // ebp should be valid
        if (stack_val_ebp <= 0) {
  100acb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100acf:	74 10                	je     100ae1 <print_stackframe+0xd0>
    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
    
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  100ad1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ad5:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100ad9:	0f 8e 58 ff ff ff    	jle    100a37 <print_stackframe+0x26>
        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
        }
    }
}
  100adf:	eb 01                	jmp    100ae2 <print_stackframe+0xd1>
        stack_val_eip = ((uint32_t *)stack_val_ebp)[1];
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));

        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
  100ae1:	90                   	nop
        }
    }
}
  100ae2:	90                   	nop
  100ae3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100ae6:	c9                   	leave  
  100ae7:	c3                   	ret    

00100ae8 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100ae8:	55                   	push   %ebp
  100ae9:	89 e5                	mov    %esp,%ebp
  100aeb:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100aee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100af5:	eb 0c                	jmp    100b03 <parse+0x1b>
            *buf ++ = '\0';
  100af7:	8b 45 08             	mov    0x8(%ebp),%eax
  100afa:	8d 50 01             	lea    0x1(%eax),%edx
  100afd:	89 55 08             	mov    %edx,0x8(%ebp)
  100b00:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b03:	8b 45 08             	mov    0x8(%ebp),%eax
  100b06:	0f b6 00             	movzbl (%eax),%eax
  100b09:	84 c0                	test   %al,%al
  100b0b:	74 1e                	je     100b2b <parse+0x43>
  100b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b10:	0f b6 00             	movzbl (%eax),%eax
  100b13:	0f be c0             	movsbl %al,%eax
  100b16:	83 ec 08             	sub    $0x8,%esp
  100b19:	50                   	push   %eax
  100b1a:	68 00 35 10 00       	push   $0x103500
  100b1f:	e8 ff 1d 00 00       	call   102923 <strchr>
  100b24:	83 c4 10             	add    $0x10,%esp
  100b27:	85 c0                	test   %eax,%eax
  100b29:	75 cc                	jne    100af7 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2e:	0f b6 00             	movzbl (%eax),%eax
  100b31:	84 c0                	test   %al,%al
  100b33:	74 69                	je     100b9e <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b35:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b39:	75 12                	jne    100b4d <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b3b:	83 ec 08             	sub    $0x8,%esp
  100b3e:	6a 10                	push   $0x10
  100b40:	68 05 35 10 00       	push   $0x103505
  100b45:	e8 f3 f6 ff ff       	call   10023d <cprintf>
  100b4a:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b50:	8d 50 01             	lea    0x1(%eax),%edx
  100b53:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b56:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b60:	01 c2                	add    %eax,%edx
  100b62:	8b 45 08             	mov    0x8(%ebp),%eax
  100b65:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b67:	eb 04                	jmp    100b6d <parse+0x85>
            buf ++;
  100b69:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b70:	0f b6 00             	movzbl (%eax),%eax
  100b73:	84 c0                	test   %al,%al
  100b75:	0f 84 7a ff ff ff    	je     100af5 <parse+0xd>
  100b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7e:	0f b6 00             	movzbl (%eax),%eax
  100b81:	0f be c0             	movsbl %al,%eax
  100b84:	83 ec 08             	sub    $0x8,%esp
  100b87:	50                   	push   %eax
  100b88:	68 00 35 10 00       	push   $0x103500
  100b8d:	e8 91 1d 00 00       	call   102923 <strchr>
  100b92:	83 c4 10             	add    $0x10,%esp
  100b95:	85 c0                	test   %eax,%eax
  100b97:	74 d0                	je     100b69 <parse+0x81>
            buf ++;
        }
    }
  100b99:	e9 57 ff ff ff       	jmp    100af5 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100b9e:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100ba2:	c9                   	leave  
  100ba3:	c3                   	ret    

00100ba4 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ba4:	55                   	push   %ebp
  100ba5:	89 e5                	mov    %esp,%ebp
  100ba7:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100baa:	83 ec 08             	sub    $0x8,%esp
  100bad:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bb0:	50                   	push   %eax
  100bb1:	ff 75 08             	pushl  0x8(%ebp)
  100bb4:	e8 2f ff ff ff       	call   100ae8 <parse>
  100bb9:	83 c4 10             	add    $0x10,%esp
  100bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bc3:	75 0a                	jne    100bcf <runcmd+0x2b>
        return 0;
  100bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  100bca:	e9 83 00 00 00       	jmp    100c52 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bd6:	eb 59                	jmp    100c31 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bd8:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bde:	89 d0                	mov    %edx,%eax
  100be0:	01 c0                	add    %eax,%eax
  100be2:	01 d0                	add    %edx,%eax
  100be4:	c1 e0 02             	shl    $0x2,%eax
  100be7:	05 00 e0 10 00       	add    $0x10e000,%eax
  100bec:	8b 00                	mov    (%eax),%eax
  100bee:	83 ec 08             	sub    $0x8,%esp
  100bf1:	51                   	push   %ecx
  100bf2:	50                   	push   %eax
  100bf3:	e8 8b 1c 00 00       	call   102883 <strcmp>
  100bf8:	83 c4 10             	add    $0x10,%esp
  100bfb:	85 c0                	test   %eax,%eax
  100bfd:	75 2e                	jne    100c2d <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100bff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c02:	89 d0                	mov    %edx,%eax
  100c04:	01 c0                	add    %eax,%eax
  100c06:	01 d0                	add    %edx,%eax
  100c08:	c1 e0 02             	shl    $0x2,%eax
  100c0b:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c10:	8b 10                	mov    (%eax),%edx
  100c12:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c15:	83 c0 04             	add    $0x4,%eax
  100c18:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c1b:	83 e9 01             	sub    $0x1,%ecx
  100c1e:	83 ec 04             	sub    $0x4,%esp
  100c21:	ff 75 0c             	pushl  0xc(%ebp)
  100c24:	50                   	push   %eax
  100c25:	51                   	push   %ecx
  100c26:	ff d2                	call   *%edx
  100c28:	83 c4 10             	add    $0x10,%esp
  100c2b:	eb 25                	jmp    100c52 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c34:	83 f8 02             	cmp    $0x2,%eax
  100c37:	76 9f                	jbe    100bd8 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c39:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c3c:	83 ec 08             	sub    $0x8,%esp
  100c3f:	50                   	push   %eax
  100c40:	68 23 35 10 00       	push   $0x103523
  100c45:	e8 f3 f5 ff ff       	call   10023d <cprintf>
  100c4a:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c52:	c9                   	leave  
  100c53:	c3                   	ret    

00100c54 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c54:	55                   	push   %ebp
  100c55:	89 e5                	mov    %esp,%ebp
  100c57:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c5a:	83 ec 0c             	sub    $0xc,%esp
  100c5d:	68 3c 35 10 00       	push   $0x10353c
  100c62:	e8 d6 f5 ff ff       	call   10023d <cprintf>
  100c67:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c6a:	83 ec 0c             	sub    $0xc,%esp
  100c6d:	68 64 35 10 00       	push   $0x103564
  100c72:	e8 c6 f5 ff ff       	call   10023d <cprintf>
  100c77:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c7e:	74 0e                	je     100c8e <kmonitor+0x3a>
        print_trapframe(tf);
  100c80:	83 ec 0c             	sub    $0xc,%esp
  100c83:	ff 75 08             	pushl  0x8(%ebp)
  100c86:	e8 c6 0b 00 00       	call   101851 <print_trapframe>
  100c8b:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c8e:	83 ec 0c             	sub    $0xc,%esp
  100c91:	68 89 35 10 00       	push   $0x103589
  100c96:	e8 46 f6 ff ff       	call   1002e1 <readline>
  100c9b:	83 c4 10             	add    $0x10,%esp
  100c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ca1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ca5:	74 e7                	je     100c8e <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100ca7:	83 ec 08             	sub    $0x8,%esp
  100caa:	ff 75 08             	pushl  0x8(%ebp)
  100cad:	ff 75 f4             	pushl  -0xc(%ebp)
  100cb0:	e8 ef fe ff ff       	call   100ba4 <runcmd>
  100cb5:	83 c4 10             	add    $0x10,%esp
  100cb8:	85 c0                	test   %eax,%eax
  100cba:	78 02                	js     100cbe <kmonitor+0x6a>
                break;
            }
        }
    }
  100cbc:	eb d0                	jmp    100c8e <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100cbe:	90                   	nop
            }
        }
    }
}
  100cbf:	90                   	nop
  100cc0:	c9                   	leave  
  100cc1:	c3                   	ret    

00100cc2 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cc2:	55                   	push   %ebp
  100cc3:	89 e5                	mov    %esp,%ebp
  100cc5:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ccf:	eb 3c                	jmp    100d0d <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cd4:	89 d0                	mov    %edx,%eax
  100cd6:	01 c0                	add    %eax,%eax
  100cd8:	01 d0                	add    %edx,%eax
  100cda:	c1 e0 02             	shl    $0x2,%eax
  100cdd:	05 04 e0 10 00       	add    $0x10e004,%eax
  100ce2:	8b 08                	mov    (%eax),%ecx
  100ce4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce7:	89 d0                	mov    %edx,%eax
  100ce9:	01 c0                	add    %eax,%eax
  100ceb:	01 d0                	add    %edx,%eax
  100ced:	c1 e0 02             	shl    $0x2,%eax
  100cf0:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cf5:	8b 00                	mov    (%eax),%eax
  100cf7:	83 ec 04             	sub    $0x4,%esp
  100cfa:	51                   	push   %ecx
  100cfb:	50                   	push   %eax
  100cfc:	68 8d 35 10 00       	push   $0x10358d
  100d01:	e8 37 f5 ff ff       	call   10023d <cprintf>
  100d06:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d09:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d10:	83 f8 02             	cmp    $0x2,%eax
  100d13:	76 bc                	jbe    100cd1 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d1a:	c9                   	leave  
  100d1b:	c3                   	ret    

00100d1c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d1c:	55                   	push   %ebp
  100d1d:	89 e5                	mov    %esp,%ebp
  100d1f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d22:	e8 a0 fb ff ff       	call   1008c7 <print_kerninfo>
    return 0;
  100d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d2c:	c9                   	leave  
  100d2d:	c3                   	ret    

00100d2e <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d2e:	55                   	push   %ebp
  100d2f:	89 e5                	mov    %esp,%ebp
  100d31:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d34:	e8 d8 fc ff ff       	call   100a11 <print_stackframe>
    return 0;
  100d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d3e:	c9                   	leave  
  100d3f:	c3                   	ret    

00100d40 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d40:	55                   	push   %ebp
  100d41:	89 e5                	mov    %esp,%ebp
  100d43:	83 ec 18             	sub    $0x18,%esp
  100d46:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d4c:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d50:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d54:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d58:	ee                   	out    %al,(%dx)
  100d59:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d5f:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d63:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d67:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d6b:	ee                   	out    %al,(%dx)
  100d6c:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d72:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d76:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d7a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d7e:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d7f:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d86:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d89:	83 ec 0c             	sub    $0xc,%esp
  100d8c:	68 96 35 10 00       	push   $0x103596
  100d91:	e8 a7 f4 ff ff       	call   10023d <cprintf>
  100d96:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d99:	83 ec 0c             	sub    $0xc,%esp
  100d9c:	6a 00                	push   $0x0
  100d9e:	e8 ce 08 00 00       	call   101671 <pic_enable>
  100da3:	83 c4 10             	add    $0x10,%esp
}
  100da6:	90                   	nop
  100da7:	c9                   	leave  
  100da8:	c3                   	ret    

00100da9 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100da9:	55                   	push   %ebp
  100daa:	89 e5                	mov    %esp,%ebp
  100dac:	83 ec 10             	sub    $0x10,%esp
  100daf:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100db5:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100db9:	89 c2                	mov    %eax,%edx
  100dbb:	ec                   	in     (%dx),%al
  100dbc:	88 45 f4             	mov    %al,-0xc(%ebp)
  100dbf:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100dc5:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100dc9:	89 c2                	mov    %eax,%edx
  100dcb:	ec                   	in     (%dx),%al
  100dcc:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dcf:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dd5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dd9:	89 c2                	mov    %eax,%edx
  100ddb:	ec                   	in     (%dx),%al
  100ddc:	88 45 f6             	mov    %al,-0xa(%ebp)
  100ddf:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100de5:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100de9:	89 c2                	mov    %eax,%edx
  100deb:	ec                   	in     (%dx),%al
  100dec:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100def:	90                   	nop
  100df0:	c9                   	leave  
  100df1:	c3                   	ret    

00100df2 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100df2:	55                   	push   %ebp
  100df3:	89 e5                	mov    %esp,%ebp
  100df5:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100df8:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100dff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e02:	0f b7 00             	movzwl (%eax),%eax
  100e05:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e0c:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e14:	0f b7 00             	movzwl (%eax),%eax
  100e17:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e1b:	74 12                	je     100e2f <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e1d:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e24:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e2b:	b4 03 
  100e2d:	eb 13                	jmp    100e42 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e32:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e36:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e39:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e40:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e42:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e49:	0f b7 c0             	movzwl %ax,%eax
  100e4c:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100e50:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e54:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100e58:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100e5c:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e5d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e64:	83 c0 01             	add    $0x1,%eax
  100e67:	0f b7 c0             	movzwl %ax,%eax
  100e6a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e6e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e72:	89 c2                	mov    %eax,%edx
  100e74:	ec                   	in     (%dx),%al
  100e75:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100e78:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100e7c:	0f b6 c0             	movzbl %al,%eax
  100e7f:	c1 e0 08             	shl    $0x8,%eax
  100e82:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e85:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e8c:	0f b7 c0             	movzwl %ax,%eax
  100e8f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100e93:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e97:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100e9b:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100e9f:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ea0:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ea7:	83 c0 01             	add    $0x1,%eax
  100eaa:	0f b7 c0             	movzwl %ax,%eax
  100ead:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb1:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eb5:	89 c2                	mov    %eax,%edx
  100eb7:	ec                   	in     (%dx),%al
  100eb8:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ebb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ebf:	0f b6 c0             	movzbl %al,%eax
  100ec2:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ec5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec8:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ed0:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ed6:	90                   	nop
  100ed7:	c9                   	leave  
  100ed8:	c3                   	ret    

00100ed9 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ed9:	55                   	push   %ebp
  100eda:	89 e5                	mov    %esp,%ebp
  100edc:	83 ec 28             	sub    $0x28,%esp
  100edf:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ee5:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ee9:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100eed:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ef1:	ee                   	out    %al,(%dx)
  100ef2:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100ef8:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100efc:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100f00:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100f04:	ee                   	out    %al,(%dx)
  100f05:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f0b:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f0f:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f13:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f17:	ee                   	out    %al,(%dx)
  100f18:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f1e:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f22:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f26:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f2a:	ee                   	out    %al,(%dx)
  100f2b:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f31:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f35:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f39:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f3d:	ee                   	out    %al,(%dx)
  100f3e:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f44:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f48:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100f4c:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100f50:	ee                   	out    %al,(%dx)
  100f51:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f57:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100f5b:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100f5f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f63:	ee                   	out    %al,(%dx)
  100f64:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f6a:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100f6e:	89 c2                	mov    %eax,%edx
  100f70:	ec                   	in     (%dx),%al
  100f71:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100f74:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f78:	3c ff                	cmp    $0xff,%al
  100f7a:	0f 95 c0             	setne  %al
  100f7d:	0f b6 c0             	movzbl %al,%eax
  100f80:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f85:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f8b:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f8f:	89 c2                	mov    %eax,%edx
  100f91:	ec                   	in     (%dx),%al
  100f92:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100f95:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100f9b:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100f9f:	89 c2                	mov    %eax,%edx
  100fa1:	ec                   	in     (%dx),%al
  100fa2:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fa5:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100faa:	85 c0                	test   %eax,%eax
  100fac:	74 0d                	je     100fbb <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100fae:	83 ec 0c             	sub    $0xc,%esp
  100fb1:	6a 04                	push   $0x4
  100fb3:	e8 b9 06 00 00       	call   101671 <pic_enable>
  100fb8:	83 c4 10             	add    $0x10,%esp
    }
}
  100fbb:	90                   	nop
  100fbc:	c9                   	leave  
  100fbd:	c3                   	ret    

00100fbe <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fbe:	55                   	push   %ebp
  100fbf:	89 e5                	mov    %esp,%ebp
  100fc1:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fcb:	eb 09                	jmp    100fd6 <lpt_putc_sub+0x18>
        delay();
  100fcd:	e8 d7 fd ff ff       	call   100da9 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fd6:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100fdc:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100fe0:	89 c2                	mov    %eax,%edx
  100fe2:	ec                   	in     (%dx),%al
  100fe3:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100fe6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100fea:	84 c0                	test   %al,%al
  100fec:	78 09                	js     100ff7 <lpt_putc_sub+0x39>
  100fee:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100ff5:	7e d6                	jle    100fcd <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  100ffa:	0f b6 c0             	movzbl %al,%eax
  100ffd:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  101003:	88 45 f0             	mov    %al,-0x10(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101006:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  10100a:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10100e:	ee                   	out    %al,(%dx)
  10100f:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101015:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101019:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10101d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101021:	ee                   	out    %al,(%dx)
  101022:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  101028:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  10102c:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  101030:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101034:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101035:	90                   	nop
  101036:	c9                   	leave  
  101037:	c3                   	ret    

00101038 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101038:	55                   	push   %ebp
  101039:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10103b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10103f:	74 0d                	je     10104e <lpt_putc+0x16>
        lpt_putc_sub(c);
  101041:	ff 75 08             	pushl  0x8(%ebp)
  101044:	e8 75 ff ff ff       	call   100fbe <lpt_putc_sub>
  101049:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10104c:	eb 1e                	jmp    10106c <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  10104e:	6a 08                	push   $0x8
  101050:	e8 69 ff ff ff       	call   100fbe <lpt_putc_sub>
  101055:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  101058:	6a 20                	push   $0x20
  10105a:	e8 5f ff ff ff       	call   100fbe <lpt_putc_sub>
  10105f:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101062:	6a 08                	push   $0x8
  101064:	e8 55 ff ff ff       	call   100fbe <lpt_putc_sub>
  101069:	83 c4 04             	add    $0x4,%esp
    }
}
  10106c:	90                   	nop
  10106d:	c9                   	leave  
  10106e:	c3                   	ret    

0010106f <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10106f:	55                   	push   %ebp
  101070:	89 e5                	mov    %esp,%ebp
  101072:	53                   	push   %ebx
  101073:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101076:	8b 45 08             	mov    0x8(%ebp),%eax
  101079:	b0 00                	mov    $0x0,%al
  10107b:	85 c0                	test   %eax,%eax
  10107d:	75 07                	jne    101086 <cga_putc+0x17>
        c |= 0x0700;
  10107f:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101086:	8b 45 08             	mov    0x8(%ebp),%eax
  101089:	0f b6 c0             	movzbl %al,%eax
  10108c:	83 f8 0a             	cmp    $0xa,%eax
  10108f:	74 4e                	je     1010df <cga_putc+0x70>
  101091:	83 f8 0d             	cmp    $0xd,%eax
  101094:	74 59                	je     1010ef <cga_putc+0x80>
  101096:	83 f8 08             	cmp    $0x8,%eax
  101099:	0f 85 8a 00 00 00    	jne    101129 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  10109f:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010a6:	66 85 c0             	test   %ax,%ax
  1010a9:	0f 84 a0 00 00 00    	je     10114f <cga_putc+0xe0>
            crt_pos --;
  1010af:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010b6:	83 e8 01             	sub    $0x1,%eax
  1010b9:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010bf:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010c4:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010cb:	0f b7 d2             	movzwl %dx,%edx
  1010ce:	01 d2                	add    %edx,%edx
  1010d0:	01 d0                	add    %edx,%eax
  1010d2:	8b 55 08             	mov    0x8(%ebp),%edx
  1010d5:	b2 00                	mov    $0x0,%dl
  1010d7:	83 ca 20             	or     $0x20,%edx
  1010da:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010dd:	eb 70                	jmp    10114f <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  1010df:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010e6:	83 c0 50             	add    $0x50,%eax
  1010e9:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010ef:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010f6:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010fd:	0f b7 c1             	movzwl %cx,%eax
  101100:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101106:	c1 e8 10             	shr    $0x10,%eax
  101109:	89 c2                	mov    %eax,%edx
  10110b:	66 c1 ea 06          	shr    $0x6,%dx
  10110f:	89 d0                	mov    %edx,%eax
  101111:	c1 e0 02             	shl    $0x2,%eax
  101114:	01 d0                	add    %edx,%eax
  101116:	c1 e0 04             	shl    $0x4,%eax
  101119:	29 c1                	sub    %eax,%ecx
  10111b:	89 ca                	mov    %ecx,%edx
  10111d:	89 d8                	mov    %ebx,%eax
  10111f:	29 d0                	sub    %edx,%eax
  101121:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101127:	eb 27                	jmp    101150 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101129:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10112f:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101136:	8d 50 01             	lea    0x1(%eax),%edx
  101139:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101140:	0f b7 c0             	movzwl %ax,%eax
  101143:	01 c0                	add    %eax,%eax
  101145:	01 c8                	add    %ecx,%eax
  101147:	8b 55 08             	mov    0x8(%ebp),%edx
  10114a:	66 89 10             	mov    %dx,(%eax)
        break;
  10114d:	eb 01                	jmp    101150 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  10114f:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101150:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101157:	66 3d cf 07          	cmp    $0x7cf,%ax
  10115b:	76 59                	jbe    1011b6 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10115d:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101162:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101168:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10116d:	83 ec 04             	sub    $0x4,%esp
  101170:	68 00 0f 00 00       	push   $0xf00
  101175:	52                   	push   %edx
  101176:	50                   	push   %eax
  101177:	e8 a6 19 00 00       	call   102b22 <memmove>
  10117c:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10117f:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101186:	eb 15                	jmp    10119d <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  101188:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10118d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101190:	01 d2                	add    %edx,%edx
  101192:	01 d0                	add    %edx,%eax
  101194:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101199:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10119d:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011a4:	7e e2                	jle    101188 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011a6:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011ad:	83 e8 50             	sub    $0x50,%eax
  1011b0:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011b6:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011bd:	0f b7 c0             	movzwl %ax,%eax
  1011c0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011c4:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  1011c8:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1011cc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011d0:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011d1:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d8:	66 c1 e8 08          	shr    $0x8,%ax
  1011dc:	0f b6 c0             	movzbl %al,%eax
  1011df:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011e6:	83 c2 01             	add    $0x1,%edx
  1011e9:	0f b7 d2             	movzwl %dx,%edx
  1011ec:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  1011f0:	88 45 e9             	mov    %al,-0x17(%ebp)
  1011f3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011f7:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1011fb:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011fc:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101203:	0f b7 c0             	movzwl %ax,%eax
  101206:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10120a:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  10120e:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101212:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101216:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101217:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10121e:	0f b6 c0             	movzbl %al,%eax
  101221:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101228:	83 c2 01             	add    $0x1,%edx
  10122b:	0f b7 d2             	movzwl %dx,%edx
  10122e:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101232:	88 45 eb             	mov    %al,-0x15(%ebp)
  101235:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  101239:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10123d:	ee                   	out    %al,(%dx)
}
  10123e:	90                   	nop
  10123f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101242:	c9                   	leave  
  101243:	c3                   	ret    

00101244 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101244:	55                   	push   %ebp
  101245:	89 e5                	mov    %esp,%ebp
  101247:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10124a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101251:	eb 09                	jmp    10125c <serial_putc_sub+0x18>
        delay();
  101253:	e8 51 fb ff ff       	call   100da9 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101258:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10125c:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101262:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101266:	89 c2                	mov    %eax,%edx
  101268:	ec                   	in     (%dx),%al
  101269:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10126c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  101270:	0f b6 c0             	movzbl %al,%eax
  101273:	83 e0 20             	and    $0x20,%eax
  101276:	85 c0                	test   %eax,%eax
  101278:	75 09                	jne    101283 <serial_putc_sub+0x3f>
  10127a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101281:	7e d0                	jle    101253 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101283:	8b 45 08             	mov    0x8(%ebp),%eax
  101286:	0f b6 c0             	movzbl %al,%eax
  101289:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  10128f:	88 45 f6             	mov    %al,-0xa(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101292:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  101296:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10129a:	ee                   	out    %al,(%dx)
}
  10129b:	90                   	nop
  10129c:	c9                   	leave  
  10129d:	c3                   	ret    

0010129e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10129e:	55                   	push   %ebp
  10129f:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012a1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012a5:	74 0d                	je     1012b4 <serial_putc+0x16>
        serial_putc_sub(c);
  1012a7:	ff 75 08             	pushl  0x8(%ebp)
  1012aa:	e8 95 ff ff ff       	call   101244 <serial_putc_sub>
  1012af:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012b2:	eb 1e                	jmp    1012d2 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  1012b4:	6a 08                	push   $0x8
  1012b6:	e8 89 ff ff ff       	call   101244 <serial_putc_sub>
  1012bb:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012be:	6a 20                	push   $0x20
  1012c0:	e8 7f ff ff ff       	call   101244 <serial_putc_sub>
  1012c5:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012c8:	6a 08                	push   $0x8
  1012ca:	e8 75 ff ff ff       	call   101244 <serial_putc_sub>
  1012cf:	83 c4 04             	add    $0x4,%esp
    }
}
  1012d2:	90                   	nop
  1012d3:	c9                   	leave  
  1012d4:	c3                   	ret    

001012d5 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012d5:	55                   	push   %ebp
  1012d6:	89 e5                	mov    %esp,%ebp
  1012d8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012db:	eb 33                	jmp    101310 <cons_intr+0x3b>
        if (c != 0) {
  1012dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012e1:	74 2d                	je     101310 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012e3:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012e8:	8d 50 01             	lea    0x1(%eax),%edx
  1012eb:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1012f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012f4:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012fa:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  101304:	75 0a                	jne    101310 <cons_intr+0x3b>
                cons.wpos = 0;
  101306:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10130d:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101310:	8b 45 08             	mov    0x8(%ebp),%eax
  101313:	ff d0                	call   *%eax
  101315:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101318:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10131c:	75 bf                	jne    1012dd <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10131e:	90                   	nop
  10131f:	c9                   	leave  
  101320:	c3                   	ret    

00101321 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101321:	55                   	push   %ebp
  101322:	89 e5                	mov    %esp,%ebp
  101324:	83 ec 10             	sub    $0x10,%esp
  101327:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10132d:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101331:	89 c2                	mov    %eax,%edx
  101333:	ec                   	in     (%dx),%al
  101334:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  101337:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10133b:	0f b6 c0             	movzbl %al,%eax
  10133e:	83 e0 01             	and    $0x1,%eax
  101341:	85 c0                	test   %eax,%eax
  101343:	75 07                	jne    10134c <serial_proc_data+0x2b>
        return -1;
  101345:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10134a:	eb 2a                	jmp    101376 <serial_proc_data+0x55>
  10134c:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101352:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101356:	89 c2                	mov    %eax,%edx
  101358:	ec                   	in     (%dx),%al
  101359:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  10135c:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101360:	0f b6 c0             	movzbl %al,%eax
  101363:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101366:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10136a:	75 07                	jne    101373 <serial_proc_data+0x52>
        c = '\b';
  10136c:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101373:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101376:	c9                   	leave  
  101377:	c3                   	ret    

00101378 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101378:	55                   	push   %ebp
  101379:	89 e5                	mov    %esp,%ebp
  10137b:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  10137e:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101383:	85 c0                	test   %eax,%eax
  101385:	74 10                	je     101397 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101387:	83 ec 0c             	sub    $0xc,%esp
  10138a:	68 21 13 10 00       	push   $0x101321
  10138f:	e8 41 ff ff ff       	call   1012d5 <cons_intr>
  101394:	83 c4 10             	add    $0x10,%esp
    }
}
  101397:	90                   	nop
  101398:	c9                   	leave  
  101399:	c3                   	ret    

0010139a <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10139a:	55                   	push   %ebp
  10139b:	89 e5                	mov    %esp,%ebp
  10139d:	83 ec 18             	sub    $0x18,%esp
  1013a0:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013a6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013aa:	89 c2                	mov    %eax,%edx
  1013ac:	ec                   	in     (%dx),%al
  1013ad:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013b0:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013b4:	0f b6 c0             	movzbl %al,%eax
  1013b7:	83 e0 01             	and    $0x1,%eax
  1013ba:	85 c0                	test   %eax,%eax
  1013bc:	75 0a                	jne    1013c8 <kbd_proc_data+0x2e>
        return -1;
  1013be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013c3:	e9 5d 01 00 00       	jmp    101525 <kbd_proc_data+0x18b>
  1013c8:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ce:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013d2:	89 c2                	mov    %eax,%edx
  1013d4:	ec                   	in     (%dx),%al
  1013d5:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  1013d8:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013dc:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013df:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013e3:	75 17                	jne    1013fc <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013e5:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013ea:	83 c8 40             	or     $0x40,%eax
  1013ed:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013f2:	b8 00 00 00 00       	mov    $0x0,%eax
  1013f7:	e9 29 01 00 00       	jmp    101525 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  1013fc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101400:	84 c0                	test   %al,%al
  101402:	79 47                	jns    10144b <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101404:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101409:	83 e0 40             	and    $0x40,%eax
  10140c:	85 c0                	test   %eax,%eax
  10140e:	75 09                	jne    101419 <kbd_proc_data+0x7f>
  101410:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101414:	83 e0 7f             	and    $0x7f,%eax
  101417:	eb 04                	jmp    10141d <kbd_proc_data+0x83>
  101419:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10141d:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101420:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101424:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10142b:	83 c8 40             	or     $0x40,%eax
  10142e:	0f b6 c0             	movzbl %al,%eax
  101431:	f7 d0                	not    %eax
  101433:	89 c2                	mov    %eax,%edx
  101435:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10143a:	21 d0                	and    %edx,%eax
  10143c:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101441:	b8 00 00 00 00       	mov    $0x0,%eax
  101446:	e9 da 00 00 00       	jmp    101525 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  10144b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101450:	83 e0 40             	and    $0x40,%eax
  101453:	85 c0                	test   %eax,%eax
  101455:	74 11                	je     101468 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101457:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10145b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101460:	83 e0 bf             	and    $0xffffffbf,%eax
  101463:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101468:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10146c:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101473:	0f b6 d0             	movzbl %al,%edx
  101476:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147b:	09 d0                	or     %edx,%eax
  10147d:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101482:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101486:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  10148d:	0f b6 d0             	movzbl %al,%edx
  101490:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101495:	31 d0                	xor    %edx,%eax
  101497:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  10149c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a1:	83 e0 03             	and    $0x3,%eax
  1014a4:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014af:	01 d0                	add    %edx,%eax
  1014b1:	0f b6 00             	movzbl (%eax),%eax
  1014b4:	0f b6 c0             	movzbl %al,%eax
  1014b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014ba:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014bf:	83 e0 08             	and    $0x8,%eax
  1014c2:	85 c0                	test   %eax,%eax
  1014c4:	74 22                	je     1014e8 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014c6:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014ca:	7e 0c                	jle    1014d8 <kbd_proc_data+0x13e>
  1014cc:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014d0:	7f 06                	jg     1014d8 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014d2:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014d6:	eb 10                	jmp    1014e8 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014d8:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014dc:	7e 0a                	jle    1014e8 <kbd_proc_data+0x14e>
  1014de:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014e2:	7f 04                	jg     1014e8 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014e4:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014e8:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ed:	f7 d0                	not    %eax
  1014ef:	83 e0 06             	and    $0x6,%eax
  1014f2:	85 c0                	test   %eax,%eax
  1014f4:	75 2c                	jne    101522 <kbd_proc_data+0x188>
  1014f6:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014fd:	75 23                	jne    101522 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  1014ff:	83 ec 0c             	sub    $0xc,%esp
  101502:	68 b1 35 10 00       	push   $0x1035b1
  101507:	e8 31 ed ff ff       	call   10023d <cprintf>
  10150c:	83 c4 10             	add    $0x10,%esp
  10150f:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  101515:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101519:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10151d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101521:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101522:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101525:	c9                   	leave  
  101526:	c3                   	ret    

00101527 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101527:	55                   	push   %ebp
  101528:	89 e5                	mov    %esp,%ebp
  10152a:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10152d:	83 ec 0c             	sub    $0xc,%esp
  101530:	68 9a 13 10 00       	push   $0x10139a
  101535:	e8 9b fd ff ff       	call   1012d5 <cons_intr>
  10153a:	83 c4 10             	add    $0x10,%esp
}
  10153d:	90                   	nop
  10153e:	c9                   	leave  
  10153f:	c3                   	ret    

00101540 <kbd_init>:

static void
kbd_init(void) {
  101540:	55                   	push   %ebp
  101541:	89 e5                	mov    %esp,%ebp
  101543:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101546:	e8 dc ff ff ff       	call   101527 <kbd_intr>
    pic_enable(IRQ_KBD);
  10154b:	83 ec 0c             	sub    $0xc,%esp
  10154e:	6a 01                	push   $0x1
  101550:	e8 1c 01 00 00       	call   101671 <pic_enable>
  101555:	83 c4 10             	add    $0x10,%esp
}
  101558:	90                   	nop
  101559:	c9                   	leave  
  10155a:	c3                   	ret    

0010155b <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10155b:	55                   	push   %ebp
  10155c:	89 e5                	mov    %esp,%ebp
  10155e:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101561:	e8 8c f8 ff ff       	call   100df2 <cga_init>
    serial_init();
  101566:	e8 6e f9 ff ff       	call   100ed9 <serial_init>
    kbd_init();
  10156b:	e8 d0 ff ff ff       	call   101540 <kbd_init>
    if (!serial_exists) {
  101570:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101575:	85 c0                	test   %eax,%eax
  101577:	75 10                	jne    101589 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101579:	83 ec 0c             	sub    $0xc,%esp
  10157c:	68 bd 35 10 00       	push   $0x1035bd
  101581:	e8 b7 ec ff ff       	call   10023d <cprintf>
  101586:	83 c4 10             	add    $0x10,%esp
    }
}
  101589:	90                   	nop
  10158a:	c9                   	leave  
  10158b:	c3                   	ret    

0010158c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10158c:	55                   	push   %ebp
  10158d:	89 e5                	mov    %esp,%ebp
  10158f:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  101592:	ff 75 08             	pushl  0x8(%ebp)
  101595:	e8 9e fa ff ff       	call   101038 <lpt_putc>
  10159a:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  10159d:	83 ec 0c             	sub    $0xc,%esp
  1015a0:	ff 75 08             	pushl  0x8(%ebp)
  1015a3:	e8 c7 fa ff ff       	call   10106f <cga_putc>
  1015a8:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1015ab:	83 ec 0c             	sub    $0xc,%esp
  1015ae:	ff 75 08             	pushl  0x8(%ebp)
  1015b1:	e8 e8 fc ff ff       	call   10129e <serial_putc>
  1015b6:	83 c4 10             	add    $0x10,%esp
}
  1015b9:	90                   	nop
  1015ba:	c9                   	leave  
  1015bb:	c3                   	ret    

001015bc <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015bc:	55                   	push   %ebp
  1015bd:	89 e5                	mov    %esp,%ebp
  1015bf:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015c2:	e8 b1 fd ff ff       	call   101378 <serial_intr>
    kbd_intr();
  1015c7:	e8 5b ff ff ff       	call   101527 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015cc:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015d2:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015d7:	39 c2                	cmp    %eax,%edx
  1015d9:	74 36                	je     101611 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015db:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015e0:	8d 50 01             	lea    0x1(%eax),%edx
  1015e3:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015e9:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015f0:	0f b6 c0             	movzbl %al,%eax
  1015f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015f6:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015fb:	3d 00 02 00 00       	cmp    $0x200,%eax
  101600:	75 0a                	jne    10160c <cons_getc+0x50>
            cons.rpos = 0;
  101602:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101609:	00 00 00 
        }
        return c;
  10160c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10160f:	eb 05                	jmp    101616 <cons_getc+0x5a>
    }
    return 0;
  101611:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101616:	c9                   	leave  
  101617:	c3                   	ret    

00101618 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101618:	55                   	push   %ebp
  101619:	89 e5                	mov    %esp,%ebp
  10161b:	83 ec 14             	sub    $0x14,%esp
  10161e:	8b 45 08             	mov    0x8(%ebp),%eax
  101621:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101625:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101629:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10162f:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101634:	85 c0                	test   %eax,%eax
  101636:	74 36                	je     10166e <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101638:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163c:	0f b6 c0             	movzbl %al,%eax
  10163f:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101645:	88 45 fa             	mov    %al,-0x6(%ebp)
  101648:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  10164c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101650:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101651:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101655:	66 c1 e8 08          	shr    $0x8,%ax
  101659:	0f b6 c0             	movzbl %al,%eax
  10165c:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101662:	88 45 fb             	mov    %al,-0x5(%ebp)
  101665:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  101669:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  10166d:	ee                   	out    %al,(%dx)
    }
}
  10166e:	90                   	nop
  10166f:	c9                   	leave  
  101670:	c3                   	ret    

00101671 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101671:	55                   	push   %ebp
  101672:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101674:	8b 45 08             	mov    0x8(%ebp),%eax
  101677:	ba 01 00 00 00       	mov    $0x1,%edx
  10167c:	89 c1                	mov    %eax,%ecx
  10167e:	d3 e2                	shl    %cl,%edx
  101680:	89 d0                	mov    %edx,%eax
  101682:	f7 d0                	not    %eax
  101684:	89 c2                	mov    %eax,%edx
  101686:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10168d:	21 d0                	and    %edx,%eax
  10168f:	0f b7 c0             	movzwl %ax,%eax
  101692:	50                   	push   %eax
  101693:	e8 80 ff ff ff       	call   101618 <pic_setmask>
  101698:	83 c4 04             	add    $0x4,%esp
}
  10169b:	90                   	nop
  10169c:	c9                   	leave  
  10169d:	c3                   	ret    

0010169e <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10169e:	55                   	push   %ebp
  10169f:	89 e5                	mov    %esp,%ebp
  1016a1:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  1016a4:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016ab:	00 00 00 
  1016ae:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016b4:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1016b8:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1016bc:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016c0:	ee                   	out    %al,(%dx)
  1016c1:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016c7:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1016cb:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1016cf:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016d3:	ee                   	out    %al,(%dx)
  1016d4:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1016da:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  1016de:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  1016e2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e6:	ee                   	out    %al,(%dx)
  1016e7:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  1016ed:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  1016f1:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1016f5:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1016f9:	ee                   	out    %al,(%dx)
  1016fa:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  101700:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101704:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  101708:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10170c:	ee                   	out    %al,(%dx)
  10170d:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101713:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  101717:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  10171b:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  10171f:	ee                   	out    %al,(%dx)
  101720:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  101726:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  10172a:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  10172e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101732:	ee                   	out    %al,(%dx)
  101733:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  101739:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  10173d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101741:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101745:	ee                   	out    %al,(%dx)
  101746:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10174c:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  101750:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  101754:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101758:	ee                   	out    %al,(%dx)
  101759:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  10175f:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  101763:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  101767:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10176b:	ee                   	out    %al,(%dx)
  10176c:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  101772:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  101776:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  10177a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10177e:	ee                   	out    %al,(%dx)
  10177f:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  101785:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  101789:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10178d:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101791:	ee                   	out    %al,(%dx)
  101792:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101798:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  10179c:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  1017a0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017a4:	ee                   	out    %al,(%dx)
  1017a5:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  1017ab:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  1017af:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1017b3:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1017b7:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017b8:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017bf:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017c3:	74 13                	je     1017d8 <pic_init+0x13a>
        pic_setmask(irq_mask);
  1017c5:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017cc:	0f b7 c0             	movzwl %ax,%eax
  1017cf:	50                   	push   %eax
  1017d0:	e8 43 fe ff ff       	call   101618 <pic_setmask>
  1017d5:	83 c4 04             	add    $0x4,%esp
    }
}
  1017d8:	90                   	nop
  1017d9:	c9                   	leave  
  1017da:	c3                   	ret    

001017db <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017db:	55                   	push   %ebp
  1017dc:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017de:	fb                   	sti    
    sti();
}
  1017df:	90                   	nop
  1017e0:	5d                   	pop    %ebp
  1017e1:	c3                   	ret    

001017e2 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017e2:	55                   	push   %ebp
  1017e3:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017e5:	fa                   	cli    
    cli();
}
  1017e6:	90                   	nop
  1017e7:	5d                   	pop    %ebp
  1017e8:	c3                   	ret    

001017e9 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017e9:	55                   	push   %ebp
  1017ea:	89 e5                	mov    %esp,%ebp
  1017ec:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017ef:	83 ec 08             	sub    $0x8,%esp
  1017f2:	6a 64                	push   $0x64
  1017f4:	68 e0 35 10 00       	push   $0x1035e0
  1017f9:	e8 3f ea ff ff       	call   10023d <cprintf>
  1017fe:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101801:	90                   	nop
  101802:	c9                   	leave  
  101803:	c3                   	ret    

00101804 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101804:	55                   	push   %ebp
  101805:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  101807:	90                   	nop
  101808:	5d                   	pop    %ebp
  101809:	c3                   	ret    

0010180a <trapname>:

static const char *
trapname(int trapno) {
  10180a:	55                   	push   %ebp
  10180b:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  10180d:	8b 45 08             	mov    0x8(%ebp),%eax
  101810:	83 f8 13             	cmp    $0x13,%eax
  101813:	77 0c                	ja     101821 <trapname+0x17>
        return excnames[trapno];
  101815:	8b 45 08             	mov    0x8(%ebp),%eax
  101818:	8b 04 85 40 39 10 00 	mov    0x103940(,%eax,4),%eax
  10181f:	eb 18                	jmp    101839 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101821:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101825:	7e 0d                	jle    101834 <trapname+0x2a>
  101827:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10182b:	7f 07                	jg     101834 <trapname+0x2a>
        return "Hardware Interrupt";
  10182d:	b8 ea 35 10 00       	mov    $0x1035ea,%eax
  101832:	eb 05                	jmp    101839 <trapname+0x2f>
    }
    return "(unknown trap)";
  101834:	b8 fd 35 10 00       	mov    $0x1035fd,%eax
}
  101839:	5d                   	pop    %ebp
  10183a:	c3                   	ret    

0010183b <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10183b:	55                   	push   %ebp
  10183c:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  10183e:	8b 45 08             	mov    0x8(%ebp),%eax
  101841:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101845:	66 83 f8 08          	cmp    $0x8,%ax
  101849:	0f 94 c0             	sete   %al
  10184c:	0f b6 c0             	movzbl %al,%eax
}
  10184f:	5d                   	pop    %ebp
  101850:	c3                   	ret    

00101851 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101851:	55                   	push   %ebp
  101852:	89 e5                	mov    %esp,%ebp
  101854:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101857:	83 ec 08             	sub    $0x8,%esp
  10185a:	ff 75 08             	pushl  0x8(%ebp)
  10185d:	68 3e 36 10 00       	push   $0x10363e
  101862:	e8 d6 e9 ff ff       	call   10023d <cprintf>
  101867:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  10186a:	8b 45 08             	mov    0x8(%ebp),%eax
  10186d:	83 ec 0c             	sub    $0xc,%esp
  101870:	50                   	push   %eax
  101871:	e8 b8 01 00 00       	call   101a2e <print_regs>
  101876:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101879:	8b 45 08             	mov    0x8(%ebp),%eax
  10187c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101880:	0f b7 c0             	movzwl %ax,%eax
  101883:	83 ec 08             	sub    $0x8,%esp
  101886:	50                   	push   %eax
  101887:	68 4f 36 10 00       	push   $0x10364f
  10188c:	e8 ac e9 ff ff       	call   10023d <cprintf>
  101891:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101894:	8b 45 08             	mov    0x8(%ebp),%eax
  101897:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  10189b:	0f b7 c0             	movzwl %ax,%eax
  10189e:	83 ec 08             	sub    $0x8,%esp
  1018a1:	50                   	push   %eax
  1018a2:	68 62 36 10 00       	push   $0x103662
  1018a7:	e8 91 e9 ff ff       	call   10023d <cprintf>
  1018ac:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1018af:	8b 45 08             	mov    0x8(%ebp),%eax
  1018b2:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1018b6:	0f b7 c0             	movzwl %ax,%eax
  1018b9:	83 ec 08             	sub    $0x8,%esp
  1018bc:	50                   	push   %eax
  1018bd:	68 75 36 10 00       	push   $0x103675
  1018c2:	e8 76 e9 ff ff       	call   10023d <cprintf>
  1018c7:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1018cd:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  1018d1:	0f b7 c0             	movzwl %ax,%eax
  1018d4:	83 ec 08             	sub    $0x8,%esp
  1018d7:	50                   	push   %eax
  1018d8:	68 88 36 10 00       	push   $0x103688
  1018dd:	e8 5b e9 ff ff       	call   10023d <cprintf>
  1018e2:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1018e8:	8b 40 30             	mov    0x30(%eax),%eax
  1018eb:	83 ec 0c             	sub    $0xc,%esp
  1018ee:	50                   	push   %eax
  1018ef:	e8 16 ff ff ff       	call   10180a <trapname>
  1018f4:	83 c4 10             	add    $0x10,%esp
  1018f7:	89 c2                	mov    %eax,%edx
  1018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1018fc:	8b 40 30             	mov    0x30(%eax),%eax
  1018ff:	83 ec 04             	sub    $0x4,%esp
  101902:	52                   	push   %edx
  101903:	50                   	push   %eax
  101904:	68 9b 36 10 00       	push   $0x10369b
  101909:	e8 2f e9 ff ff       	call   10023d <cprintf>
  10190e:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101911:	8b 45 08             	mov    0x8(%ebp),%eax
  101914:	8b 40 34             	mov    0x34(%eax),%eax
  101917:	83 ec 08             	sub    $0x8,%esp
  10191a:	50                   	push   %eax
  10191b:	68 ad 36 10 00       	push   $0x1036ad
  101920:	e8 18 e9 ff ff       	call   10023d <cprintf>
  101925:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101928:	8b 45 08             	mov    0x8(%ebp),%eax
  10192b:	8b 40 38             	mov    0x38(%eax),%eax
  10192e:	83 ec 08             	sub    $0x8,%esp
  101931:	50                   	push   %eax
  101932:	68 bc 36 10 00       	push   $0x1036bc
  101937:	e8 01 e9 ff ff       	call   10023d <cprintf>
  10193c:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  10193f:	8b 45 08             	mov    0x8(%ebp),%eax
  101942:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101946:	0f b7 c0             	movzwl %ax,%eax
  101949:	83 ec 08             	sub    $0x8,%esp
  10194c:	50                   	push   %eax
  10194d:	68 cb 36 10 00       	push   $0x1036cb
  101952:	e8 e6 e8 ff ff       	call   10023d <cprintf>
  101957:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  10195a:	8b 45 08             	mov    0x8(%ebp),%eax
  10195d:	8b 40 40             	mov    0x40(%eax),%eax
  101960:	83 ec 08             	sub    $0x8,%esp
  101963:	50                   	push   %eax
  101964:	68 de 36 10 00       	push   $0x1036de
  101969:	e8 cf e8 ff ff       	call   10023d <cprintf>
  10196e:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101971:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101978:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  10197f:	eb 3f                	jmp    1019c0 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101981:	8b 45 08             	mov    0x8(%ebp),%eax
  101984:	8b 50 40             	mov    0x40(%eax),%edx
  101987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10198a:	21 d0                	and    %edx,%eax
  10198c:	85 c0                	test   %eax,%eax
  10198e:	74 29                	je     1019b9 <print_trapframe+0x168>
  101990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101993:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  10199a:	85 c0                	test   %eax,%eax
  10199c:	74 1b                	je     1019b9 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  10199e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019a1:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  1019a8:	83 ec 08             	sub    $0x8,%esp
  1019ab:	50                   	push   %eax
  1019ac:	68 ed 36 10 00       	push   $0x1036ed
  1019b1:	e8 87 e8 ff ff       	call   10023d <cprintf>
  1019b6:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1019b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1019bd:	d1 65 f0             	shll   -0x10(%ebp)
  1019c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019c3:	83 f8 17             	cmp    $0x17,%eax
  1019c6:	76 b9                	jbe    101981 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  1019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019cb:	8b 40 40             	mov    0x40(%eax),%eax
  1019ce:	25 00 30 00 00       	and    $0x3000,%eax
  1019d3:	c1 e8 0c             	shr    $0xc,%eax
  1019d6:	83 ec 08             	sub    $0x8,%esp
  1019d9:	50                   	push   %eax
  1019da:	68 f1 36 10 00       	push   $0x1036f1
  1019df:	e8 59 e8 ff ff       	call   10023d <cprintf>
  1019e4:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  1019e7:	83 ec 0c             	sub    $0xc,%esp
  1019ea:	ff 75 08             	pushl  0x8(%ebp)
  1019ed:	e8 49 fe ff ff       	call   10183b <trap_in_kernel>
  1019f2:	83 c4 10             	add    $0x10,%esp
  1019f5:	85 c0                	test   %eax,%eax
  1019f7:	75 32                	jne    101a2b <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  1019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fc:	8b 40 44             	mov    0x44(%eax),%eax
  1019ff:	83 ec 08             	sub    $0x8,%esp
  101a02:	50                   	push   %eax
  101a03:	68 fa 36 10 00       	push   $0x1036fa
  101a08:	e8 30 e8 ff ff       	call   10023d <cprintf>
  101a0d:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101a10:	8b 45 08             	mov    0x8(%ebp),%eax
  101a13:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101a17:	0f b7 c0             	movzwl %ax,%eax
  101a1a:	83 ec 08             	sub    $0x8,%esp
  101a1d:	50                   	push   %eax
  101a1e:	68 09 37 10 00       	push   $0x103709
  101a23:	e8 15 e8 ff ff       	call   10023d <cprintf>
  101a28:	83 c4 10             	add    $0x10,%esp
    }
}
  101a2b:	90                   	nop
  101a2c:	c9                   	leave  
  101a2d:	c3                   	ret    

00101a2e <print_regs>:

void
print_regs(struct pushregs *regs) {
  101a2e:	55                   	push   %ebp
  101a2f:	89 e5                	mov    %esp,%ebp
  101a31:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101a34:	8b 45 08             	mov    0x8(%ebp),%eax
  101a37:	8b 00                	mov    (%eax),%eax
  101a39:	83 ec 08             	sub    $0x8,%esp
  101a3c:	50                   	push   %eax
  101a3d:	68 1c 37 10 00       	push   $0x10371c
  101a42:	e8 f6 e7 ff ff       	call   10023d <cprintf>
  101a47:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4d:	8b 40 04             	mov    0x4(%eax),%eax
  101a50:	83 ec 08             	sub    $0x8,%esp
  101a53:	50                   	push   %eax
  101a54:	68 2b 37 10 00       	push   $0x10372b
  101a59:	e8 df e7 ff ff       	call   10023d <cprintf>
  101a5e:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101a61:	8b 45 08             	mov    0x8(%ebp),%eax
  101a64:	8b 40 08             	mov    0x8(%eax),%eax
  101a67:	83 ec 08             	sub    $0x8,%esp
  101a6a:	50                   	push   %eax
  101a6b:	68 3a 37 10 00       	push   $0x10373a
  101a70:	e8 c8 e7 ff ff       	call   10023d <cprintf>
  101a75:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101a78:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7b:	8b 40 0c             	mov    0xc(%eax),%eax
  101a7e:	83 ec 08             	sub    $0x8,%esp
  101a81:	50                   	push   %eax
  101a82:	68 49 37 10 00       	push   $0x103749
  101a87:	e8 b1 e7 ff ff       	call   10023d <cprintf>
  101a8c:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a92:	8b 40 10             	mov    0x10(%eax),%eax
  101a95:	83 ec 08             	sub    $0x8,%esp
  101a98:	50                   	push   %eax
  101a99:	68 58 37 10 00       	push   $0x103758
  101a9e:	e8 9a e7 ff ff       	call   10023d <cprintf>
  101aa3:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa9:	8b 40 14             	mov    0x14(%eax),%eax
  101aac:	83 ec 08             	sub    $0x8,%esp
  101aaf:	50                   	push   %eax
  101ab0:	68 67 37 10 00       	push   $0x103767
  101ab5:	e8 83 e7 ff ff       	call   10023d <cprintf>
  101aba:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101abd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac0:	8b 40 18             	mov    0x18(%eax),%eax
  101ac3:	83 ec 08             	sub    $0x8,%esp
  101ac6:	50                   	push   %eax
  101ac7:	68 76 37 10 00       	push   $0x103776
  101acc:	e8 6c e7 ff ff       	call   10023d <cprintf>
  101ad1:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad7:	8b 40 1c             	mov    0x1c(%eax),%eax
  101ada:	83 ec 08             	sub    $0x8,%esp
  101add:	50                   	push   %eax
  101ade:	68 85 37 10 00       	push   $0x103785
  101ae3:	e8 55 e7 ff ff       	call   10023d <cprintf>
  101ae8:	83 c4 10             	add    $0x10,%esp
}
  101aeb:	90                   	nop
  101aec:	c9                   	leave  
  101aed:	c3                   	ret    

00101aee <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101aee:	55                   	push   %ebp
  101aef:	89 e5                	mov    %esp,%ebp
  101af1:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101af4:	8b 45 08             	mov    0x8(%ebp),%eax
  101af7:	8b 40 30             	mov    0x30(%eax),%eax
  101afa:	83 f8 2f             	cmp    $0x2f,%eax
  101afd:	77 1e                	ja     101b1d <trap_dispatch+0x2f>
  101aff:	83 f8 2e             	cmp    $0x2e,%eax
  101b02:	0f 83 b4 00 00 00    	jae    101bbc <trap_dispatch+0xce>
  101b08:	83 f8 21             	cmp    $0x21,%eax
  101b0b:	74 3e                	je     101b4b <trap_dispatch+0x5d>
  101b0d:	83 f8 24             	cmp    $0x24,%eax
  101b10:	74 15                	je     101b27 <trap_dispatch+0x39>
  101b12:	83 f8 20             	cmp    $0x20,%eax
  101b15:	0f 84 a4 00 00 00    	je     101bbf <trap_dispatch+0xd1>
  101b1b:	eb 69                	jmp    101b86 <trap_dispatch+0x98>
  101b1d:	83 e8 78             	sub    $0x78,%eax
  101b20:	83 f8 01             	cmp    $0x1,%eax
  101b23:	77 61                	ja     101b86 <trap_dispatch+0x98>
  101b25:	eb 48                	jmp    101b6f <trap_dispatch+0x81>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101b27:	e8 90 fa ff ff       	call   1015bc <cons_getc>
  101b2c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101b2f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b33:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b37:	83 ec 04             	sub    $0x4,%esp
  101b3a:	52                   	push   %edx
  101b3b:	50                   	push   %eax
  101b3c:	68 94 37 10 00       	push   $0x103794
  101b41:	e8 f7 e6 ff ff       	call   10023d <cprintf>
  101b46:	83 c4 10             	add    $0x10,%esp
        break;
  101b49:	eb 75                	jmp    101bc0 <trap_dispatch+0xd2>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101b4b:	e8 6c fa ff ff       	call   1015bc <cons_getc>
  101b50:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101b53:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b57:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b5b:	83 ec 04             	sub    $0x4,%esp
  101b5e:	52                   	push   %edx
  101b5f:	50                   	push   %eax
  101b60:	68 a6 37 10 00       	push   $0x1037a6
  101b65:	e8 d3 e6 ff ff       	call   10023d <cprintf>
  101b6a:	83 c4 10             	add    $0x10,%esp
        break;
  101b6d:	eb 51                	jmp    101bc0 <trap_dispatch+0xd2>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101b6f:	83 ec 04             	sub    $0x4,%esp
  101b72:	68 b5 37 10 00       	push   $0x1037b5
  101b77:	68 a2 00 00 00       	push   $0xa2
  101b7c:	68 c5 37 10 00       	push   $0x1037c5
  101b81:	e8 1d e8 ff ff       	call   1003a3 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101b86:	8b 45 08             	mov    0x8(%ebp),%eax
  101b89:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b8d:	0f b7 c0             	movzwl %ax,%eax
  101b90:	83 e0 03             	and    $0x3,%eax
  101b93:	85 c0                	test   %eax,%eax
  101b95:	75 29                	jne    101bc0 <trap_dispatch+0xd2>
            print_trapframe(tf);
  101b97:	83 ec 0c             	sub    $0xc,%esp
  101b9a:	ff 75 08             	pushl  0x8(%ebp)
  101b9d:	e8 af fc ff ff       	call   101851 <print_trapframe>
  101ba2:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101ba5:	83 ec 04             	sub    $0x4,%esp
  101ba8:	68 d6 37 10 00       	push   $0x1037d6
  101bad:	68 ac 00 00 00       	push   $0xac
  101bb2:	68 c5 37 10 00       	push   $0x1037c5
  101bb7:	e8 e7 e7 ff ff       	call   1003a3 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101bbc:	90                   	nop
  101bbd:	eb 01                	jmp    101bc0 <trap_dispatch+0xd2>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
  101bbf:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101bc0:	90                   	nop
  101bc1:	c9                   	leave  
  101bc2:	c3                   	ret    

00101bc3 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101bc3:	55                   	push   %ebp
  101bc4:	89 e5                	mov    %esp,%ebp
  101bc6:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101bc9:	83 ec 0c             	sub    $0xc,%esp
  101bcc:	ff 75 08             	pushl  0x8(%ebp)
  101bcf:	e8 1a ff ff ff       	call   101aee <trap_dispatch>
  101bd4:	83 c4 10             	add    $0x10,%esp
}
  101bd7:	90                   	nop
  101bd8:	c9                   	leave  
  101bd9:	c3                   	ret    

00101bda <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101bda:	6a 00                	push   $0x0
  pushl $0
  101bdc:	6a 00                	push   $0x0
  jmp __alltraps
  101bde:	e9 69 0a 00 00       	jmp    10264c <__alltraps>

00101be3 <vector1>:
.globl vector1
vector1:
  pushl $0
  101be3:	6a 00                	push   $0x0
  pushl $1
  101be5:	6a 01                	push   $0x1
  jmp __alltraps
  101be7:	e9 60 0a 00 00       	jmp    10264c <__alltraps>

00101bec <vector2>:
.globl vector2
vector2:
  pushl $0
  101bec:	6a 00                	push   $0x0
  pushl $2
  101bee:	6a 02                	push   $0x2
  jmp __alltraps
  101bf0:	e9 57 0a 00 00       	jmp    10264c <__alltraps>

00101bf5 <vector3>:
.globl vector3
vector3:
  pushl $0
  101bf5:	6a 00                	push   $0x0
  pushl $3
  101bf7:	6a 03                	push   $0x3
  jmp __alltraps
  101bf9:	e9 4e 0a 00 00       	jmp    10264c <__alltraps>

00101bfe <vector4>:
.globl vector4
vector4:
  pushl $0
  101bfe:	6a 00                	push   $0x0
  pushl $4
  101c00:	6a 04                	push   $0x4
  jmp __alltraps
  101c02:	e9 45 0a 00 00       	jmp    10264c <__alltraps>

00101c07 <vector5>:
.globl vector5
vector5:
  pushl $0
  101c07:	6a 00                	push   $0x0
  pushl $5
  101c09:	6a 05                	push   $0x5
  jmp __alltraps
  101c0b:	e9 3c 0a 00 00       	jmp    10264c <__alltraps>

00101c10 <vector6>:
.globl vector6
vector6:
  pushl $0
  101c10:	6a 00                	push   $0x0
  pushl $6
  101c12:	6a 06                	push   $0x6
  jmp __alltraps
  101c14:	e9 33 0a 00 00       	jmp    10264c <__alltraps>

00101c19 <vector7>:
.globl vector7
vector7:
  pushl $0
  101c19:	6a 00                	push   $0x0
  pushl $7
  101c1b:	6a 07                	push   $0x7
  jmp __alltraps
  101c1d:	e9 2a 0a 00 00       	jmp    10264c <__alltraps>

00101c22 <vector8>:
.globl vector8
vector8:
  pushl $8
  101c22:	6a 08                	push   $0x8
  jmp __alltraps
  101c24:	e9 23 0a 00 00       	jmp    10264c <__alltraps>

00101c29 <vector9>:
.globl vector9
vector9:
  pushl $0
  101c29:	6a 00                	push   $0x0
  pushl $9
  101c2b:	6a 09                	push   $0x9
  jmp __alltraps
  101c2d:	e9 1a 0a 00 00       	jmp    10264c <__alltraps>

00101c32 <vector10>:
.globl vector10
vector10:
  pushl $10
  101c32:	6a 0a                	push   $0xa
  jmp __alltraps
  101c34:	e9 13 0a 00 00       	jmp    10264c <__alltraps>

00101c39 <vector11>:
.globl vector11
vector11:
  pushl $11
  101c39:	6a 0b                	push   $0xb
  jmp __alltraps
  101c3b:	e9 0c 0a 00 00       	jmp    10264c <__alltraps>

00101c40 <vector12>:
.globl vector12
vector12:
  pushl $12
  101c40:	6a 0c                	push   $0xc
  jmp __alltraps
  101c42:	e9 05 0a 00 00       	jmp    10264c <__alltraps>

00101c47 <vector13>:
.globl vector13
vector13:
  pushl $13
  101c47:	6a 0d                	push   $0xd
  jmp __alltraps
  101c49:	e9 fe 09 00 00       	jmp    10264c <__alltraps>

00101c4e <vector14>:
.globl vector14
vector14:
  pushl $14
  101c4e:	6a 0e                	push   $0xe
  jmp __alltraps
  101c50:	e9 f7 09 00 00       	jmp    10264c <__alltraps>

00101c55 <vector15>:
.globl vector15
vector15:
  pushl $0
  101c55:	6a 00                	push   $0x0
  pushl $15
  101c57:	6a 0f                	push   $0xf
  jmp __alltraps
  101c59:	e9 ee 09 00 00       	jmp    10264c <__alltraps>

00101c5e <vector16>:
.globl vector16
vector16:
  pushl $0
  101c5e:	6a 00                	push   $0x0
  pushl $16
  101c60:	6a 10                	push   $0x10
  jmp __alltraps
  101c62:	e9 e5 09 00 00       	jmp    10264c <__alltraps>

00101c67 <vector17>:
.globl vector17
vector17:
  pushl $17
  101c67:	6a 11                	push   $0x11
  jmp __alltraps
  101c69:	e9 de 09 00 00       	jmp    10264c <__alltraps>

00101c6e <vector18>:
.globl vector18
vector18:
  pushl $0
  101c6e:	6a 00                	push   $0x0
  pushl $18
  101c70:	6a 12                	push   $0x12
  jmp __alltraps
  101c72:	e9 d5 09 00 00       	jmp    10264c <__alltraps>

00101c77 <vector19>:
.globl vector19
vector19:
  pushl $0
  101c77:	6a 00                	push   $0x0
  pushl $19
  101c79:	6a 13                	push   $0x13
  jmp __alltraps
  101c7b:	e9 cc 09 00 00       	jmp    10264c <__alltraps>

00101c80 <vector20>:
.globl vector20
vector20:
  pushl $0
  101c80:	6a 00                	push   $0x0
  pushl $20
  101c82:	6a 14                	push   $0x14
  jmp __alltraps
  101c84:	e9 c3 09 00 00       	jmp    10264c <__alltraps>

00101c89 <vector21>:
.globl vector21
vector21:
  pushl $0
  101c89:	6a 00                	push   $0x0
  pushl $21
  101c8b:	6a 15                	push   $0x15
  jmp __alltraps
  101c8d:	e9 ba 09 00 00       	jmp    10264c <__alltraps>

00101c92 <vector22>:
.globl vector22
vector22:
  pushl $0
  101c92:	6a 00                	push   $0x0
  pushl $22
  101c94:	6a 16                	push   $0x16
  jmp __alltraps
  101c96:	e9 b1 09 00 00       	jmp    10264c <__alltraps>

00101c9b <vector23>:
.globl vector23
vector23:
  pushl $0
  101c9b:	6a 00                	push   $0x0
  pushl $23
  101c9d:	6a 17                	push   $0x17
  jmp __alltraps
  101c9f:	e9 a8 09 00 00       	jmp    10264c <__alltraps>

00101ca4 <vector24>:
.globl vector24
vector24:
  pushl $0
  101ca4:	6a 00                	push   $0x0
  pushl $24
  101ca6:	6a 18                	push   $0x18
  jmp __alltraps
  101ca8:	e9 9f 09 00 00       	jmp    10264c <__alltraps>

00101cad <vector25>:
.globl vector25
vector25:
  pushl $0
  101cad:	6a 00                	push   $0x0
  pushl $25
  101caf:	6a 19                	push   $0x19
  jmp __alltraps
  101cb1:	e9 96 09 00 00       	jmp    10264c <__alltraps>

00101cb6 <vector26>:
.globl vector26
vector26:
  pushl $0
  101cb6:	6a 00                	push   $0x0
  pushl $26
  101cb8:	6a 1a                	push   $0x1a
  jmp __alltraps
  101cba:	e9 8d 09 00 00       	jmp    10264c <__alltraps>

00101cbf <vector27>:
.globl vector27
vector27:
  pushl $0
  101cbf:	6a 00                	push   $0x0
  pushl $27
  101cc1:	6a 1b                	push   $0x1b
  jmp __alltraps
  101cc3:	e9 84 09 00 00       	jmp    10264c <__alltraps>

00101cc8 <vector28>:
.globl vector28
vector28:
  pushl $0
  101cc8:	6a 00                	push   $0x0
  pushl $28
  101cca:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ccc:	e9 7b 09 00 00       	jmp    10264c <__alltraps>

00101cd1 <vector29>:
.globl vector29
vector29:
  pushl $0
  101cd1:	6a 00                	push   $0x0
  pushl $29
  101cd3:	6a 1d                	push   $0x1d
  jmp __alltraps
  101cd5:	e9 72 09 00 00       	jmp    10264c <__alltraps>

00101cda <vector30>:
.globl vector30
vector30:
  pushl $0
  101cda:	6a 00                	push   $0x0
  pushl $30
  101cdc:	6a 1e                	push   $0x1e
  jmp __alltraps
  101cde:	e9 69 09 00 00       	jmp    10264c <__alltraps>

00101ce3 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ce3:	6a 00                	push   $0x0
  pushl $31
  101ce5:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ce7:	e9 60 09 00 00       	jmp    10264c <__alltraps>

00101cec <vector32>:
.globl vector32
vector32:
  pushl $0
  101cec:	6a 00                	push   $0x0
  pushl $32
  101cee:	6a 20                	push   $0x20
  jmp __alltraps
  101cf0:	e9 57 09 00 00       	jmp    10264c <__alltraps>

00101cf5 <vector33>:
.globl vector33
vector33:
  pushl $0
  101cf5:	6a 00                	push   $0x0
  pushl $33
  101cf7:	6a 21                	push   $0x21
  jmp __alltraps
  101cf9:	e9 4e 09 00 00       	jmp    10264c <__alltraps>

00101cfe <vector34>:
.globl vector34
vector34:
  pushl $0
  101cfe:	6a 00                	push   $0x0
  pushl $34
  101d00:	6a 22                	push   $0x22
  jmp __alltraps
  101d02:	e9 45 09 00 00       	jmp    10264c <__alltraps>

00101d07 <vector35>:
.globl vector35
vector35:
  pushl $0
  101d07:	6a 00                	push   $0x0
  pushl $35
  101d09:	6a 23                	push   $0x23
  jmp __alltraps
  101d0b:	e9 3c 09 00 00       	jmp    10264c <__alltraps>

00101d10 <vector36>:
.globl vector36
vector36:
  pushl $0
  101d10:	6a 00                	push   $0x0
  pushl $36
  101d12:	6a 24                	push   $0x24
  jmp __alltraps
  101d14:	e9 33 09 00 00       	jmp    10264c <__alltraps>

00101d19 <vector37>:
.globl vector37
vector37:
  pushl $0
  101d19:	6a 00                	push   $0x0
  pushl $37
  101d1b:	6a 25                	push   $0x25
  jmp __alltraps
  101d1d:	e9 2a 09 00 00       	jmp    10264c <__alltraps>

00101d22 <vector38>:
.globl vector38
vector38:
  pushl $0
  101d22:	6a 00                	push   $0x0
  pushl $38
  101d24:	6a 26                	push   $0x26
  jmp __alltraps
  101d26:	e9 21 09 00 00       	jmp    10264c <__alltraps>

00101d2b <vector39>:
.globl vector39
vector39:
  pushl $0
  101d2b:	6a 00                	push   $0x0
  pushl $39
  101d2d:	6a 27                	push   $0x27
  jmp __alltraps
  101d2f:	e9 18 09 00 00       	jmp    10264c <__alltraps>

00101d34 <vector40>:
.globl vector40
vector40:
  pushl $0
  101d34:	6a 00                	push   $0x0
  pushl $40
  101d36:	6a 28                	push   $0x28
  jmp __alltraps
  101d38:	e9 0f 09 00 00       	jmp    10264c <__alltraps>

00101d3d <vector41>:
.globl vector41
vector41:
  pushl $0
  101d3d:	6a 00                	push   $0x0
  pushl $41
  101d3f:	6a 29                	push   $0x29
  jmp __alltraps
  101d41:	e9 06 09 00 00       	jmp    10264c <__alltraps>

00101d46 <vector42>:
.globl vector42
vector42:
  pushl $0
  101d46:	6a 00                	push   $0x0
  pushl $42
  101d48:	6a 2a                	push   $0x2a
  jmp __alltraps
  101d4a:	e9 fd 08 00 00       	jmp    10264c <__alltraps>

00101d4f <vector43>:
.globl vector43
vector43:
  pushl $0
  101d4f:	6a 00                	push   $0x0
  pushl $43
  101d51:	6a 2b                	push   $0x2b
  jmp __alltraps
  101d53:	e9 f4 08 00 00       	jmp    10264c <__alltraps>

00101d58 <vector44>:
.globl vector44
vector44:
  pushl $0
  101d58:	6a 00                	push   $0x0
  pushl $44
  101d5a:	6a 2c                	push   $0x2c
  jmp __alltraps
  101d5c:	e9 eb 08 00 00       	jmp    10264c <__alltraps>

00101d61 <vector45>:
.globl vector45
vector45:
  pushl $0
  101d61:	6a 00                	push   $0x0
  pushl $45
  101d63:	6a 2d                	push   $0x2d
  jmp __alltraps
  101d65:	e9 e2 08 00 00       	jmp    10264c <__alltraps>

00101d6a <vector46>:
.globl vector46
vector46:
  pushl $0
  101d6a:	6a 00                	push   $0x0
  pushl $46
  101d6c:	6a 2e                	push   $0x2e
  jmp __alltraps
  101d6e:	e9 d9 08 00 00       	jmp    10264c <__alltraps>

00101d73 <vector47>:
.globl vector47
vector47:
  pushl $0
  101d73:	6a 00                	push   $0x0
  pushl $47
  101d75:	6a 2f                	push   $0x2f
  jmp __alltraps
  101d77:	e9 d0 08 00 00       	jmp    10264c <__alltraps>

00101d7c <vector48>:
.globl vector48
vector48:
  pushl $0
  101d7c:	6a 00                	push   $0x0
  pushl $48
  101d7e:	6a 30                	push   $0x30
  jmp __alltraps
  101d80:	e9 c7 08 00 00       	jmp    10264c <__alltraps>

00101d85 <vector49>:
.globl vector49
vector49:
  pushl $0
  101d85:	6a 00                	push   $0x0
  pushl $49
  101d87:	6a 31                	push   $0x31
  jmp __alltraps
  101d89:	e9 be 08 00 00       	jmp    10264c <__alltraps>

00101d8e <vector50>:
.globl vector50
vector50:
  pushl $0
  101d8e:	6a 00                	push   $0x0
  pushl $50
  101d90:	6a 32                	push   $0x32
  jmp __alltraps
  101d92:	e9 b5 08 00 00       	jmp    10264c <__alltraps>

00101d97 <vector51>:
.globl vector51
vector51:
  pushl $0
  101d97:	6a 00                	push   $0x0
  pushl $51
  101d99:	6a 33                	push   $0x33
  jmp __alltraps
  101d9b:	e9 ac 08 00 00       	jmp    10264c <__alltraps>

00101da0 <vector52>:
.globl vector52
vector52:
  pushl $0
  101da0:	6a 00                	push   $0x0
  pushl $52
  101da2:	6a 34                	push   $0x34
  jmp __alltraps
  101da4:	e9 a3 08 00 00       	jmp    10264c <__alltraps>

00101da9 <vector53>:
.globl vector53
vector53:
  pushl $0
  101da9:	6a 00                	push   $0x0
  pushl $53
  101dab:	6a 35                	push   $0x35
  jmp __alltraps
  101dad:	e9 9a 08 00 00       	jmp    10264c <__alltraps>

00101db2 <vector54>:
.globl vector54
vector54:
  pushl $0
  101db2:	6a 00                	push   $0x0
  pushl $54
  101db4:	6a 36                	push   $0x36
  jmp __alltraps
  101db6:	e9 91 08 00 00       	jmp    10264c <__alltraps>

00101dbb <vector55>:
.globl vector55
vector55:
  pushl $0
  101dbb:	6a 00                	push   $0x0
  pushl $55
  101dbd:	6a 37                	push   $0x37
  jmp __alltraps
  101dbf:	e9 88 08 00 00       	jmp    10264c <__alltraps>

00101dc4 <vector56>:
.globl vector56
vector56:
  pushl $0
  101dc4:	6a 00                	push   $0x0
  pushl $56
  101dc6:	6a 38                	push   $0x38
  jmp __alltraps
  101dc8:	e9 7f 08 00 00       	jmp    10264c <__alltraps>

00101dcd <vector57>:
.globl vector57
vector57:
  pushl $0
  101dcd:	6a 00                	push   $0x0
  pushl $57
  101dcf:	6a 39                	push   $0x39
  jmp __alltraps
  101dd1:	e9 76 08 00 00       	jmp    10264c <__alltraps>

00101dd6 <vector58>:
.globl vector58
vector58:
  pushl $0
  101dd6:	6a 00                	push   $0x0
  pushl $58
  101dd8:	6a 3a                	push   $0x3a
  jmp __alltraps
  101dda:	e9 6d 08 00 00       	jmp    10264c <__alltraps>

00101ddf <vector59>:
.globl vector59
vector59:
  pushl $0
  101ddf:	6a 00                	push   $0x0
  pushl $59
  101de1:	6a 3b                	push   $0x3b
  jmp __alltraps
  101de3:	e9 64 08 00 00       	jmp    10264c <__alltraps>

00101de8 <vector60>:
.globl vector60
vector60:
  pushl $0
  101de8:	6a 00                	push   $0x0
  pushl $60
  101dea:	6a 3c                	push   $0x3c
  jmp __alltraps
  101dec:	e9 5b 08 00 00       	jmp    10264c <__alltraps>

00101df1 <vector61>:
.globl vector61
vector61:
  pushl $0
  101df1:	6a 00                	push   $0x0
  pushl $61
  101df3:	6a 3d                	push   $0x3d
  jmp __alltraps
  101df5:	e9 52 08 00 00       	jmp    10264c <__alltraps>

00101dfa <vector62>:
.globl vector62
vector62:
  pushl $0
  101dfa:	6a 00                	push   $0x0
  pushl $62
  101dfc:	6a 3e                	push   $0x3e
  jmp __alltraps
  101dfe:	e9 49 08 00 00       	jmp    10264c <__alltraps>

00101e03 <vector63>:
.globl vector63
vector63:
  pushl $0
  101e03:	6a 00                	push   $0x0
  pushl $63
  101e05:	6a 3f                	push   $0x3f
  jmp __alltraps
  101e07:	e9 40 08 00 00       	jmp    10264c <__alltraps>

00101e0c <vector64>:
.globl vector64
vector64:
  pushl $0
  101e0c:	6a 00                	push   $0x0
  pushl $64
  101e0e:	6a 40                	push   $0x40
  jmp __alltraps
  101e10:	e9 37 08 00 00       	jmp    10264c <__alltraps>

00101e15 <vector65>:
.globl vector65
vector65:
  pushl $0
  101e15:	6a 00                	push   $0x0
  pushl $65
  101e17:	6a 41                	push   $0x41
  jmp __alltraps
  101e19:	e9 2e 08 00 00       	jmp    10264c <__alltraps>

00101e1e <vector66>:
.globl vector66
vector66:
  pushl $0
  101e1e:	6a 00                	push   $0x0
  pushl $66
  101e20:	6a 42                	push   $0x42
  jmp __alltraps
  101e22:	e9 25 08 00 00       	jmp    10264c <__alltraps>

00101e27 <vector67>:
.globl vector67
vector67:
  pushl $0
  101e27:	6a 00                	push   $0x0
  pushl $67
  101e29:	6a 43                	push   $0x43
  jmp __alltraps
  101e2b:	e9 1c 08 00 00       	jmp    10264c <__alltraps>

00101e30 <vector68>:
.globl vector68
vector68:
  pushl $0
  101e30:	6a 00                	push   $0x0
  pushl $68
  101e32:	6a 44                	push   $0x44
  jmp __alltraps
  101e34:	e9 13 08 00 00       	jmp    10264c <__alltraps>

00101e39 <vector69>:
.globl vector69
vector69:
  pushl $0
  101e39:	6a 00                	push   $0x0
  pushl $69
  101e3b:	6a 45                	push   $0x45
  jmp __alltraps
  101e3d:	e9 0a 08 00 00       	jmp    10264c <__alltraps>

00101e42 <vector70>:
.globl vector70
vector70:
  pushl $0
  101e42:	6a 00                	push   $0x0
  pushl $70
  101e44:	6a 46                	push   $0x46
  jmp __alltraps
  101e46:	e9 01 08 00 00       	jmp    10264c <__alltraps>

00101e4b <vector71>:
.globl vector71
vector71:
  pushl $0
  101e4b:	6a 00                	push   $0x0
  pushl $71
  101e4d:	6a 47                	push   $0x47
  jmp __alltraps
  101e4f:	e9 f8 07 00 00       	jmp    10264c <__alltraps>

00101e54 <vector72>:
.globl vector72
vector72:
  pushl $0
  101e54:	6a 00                	push   $0x0
  pushl $72
  101e56:	6a 48                	push   $0x48
  jmp __alltraps
  101e58:	e9 ef 07 00 00       	jmp    10264c <__alltraps>

00101e5d <vector73>:
.globl vector73
vector73:
  pushl $0
  101e5d:	6a 00                	push   $0x0
  pushl $73
  101e5f:	6a 49                	push   $0x49
  jmp __alltraps
  101e61:	e9 e6 07 00 00       	jmp    10264c <__alltraps>

00101e66 <vector74>:
.globl vector74
vector74:
  pushl $0
  101e66:	6a 00                	push   $0x0
  pushl $74
  101e68:	6a 4a                	push   $0x4a
  jmp __alltraps
  101e6a:	e9 dd 07 00 00       	jmp    10264c <__alltraps>

00101e6f <vector75>:
.globl vector75
vector75:
  pushl $0
  101e6f:	6a 00                	push   $0x0
  pushl $75
  101e71:	6a 4b                	push   $0x4b
  jmp __alltraps
  101e73:	e9 d4 07 00 00       	jmp    10264c <__alltraps>

00101e78 <vector76>:
.globl vector76
vector76:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $76
  101e7a:	6a 4c                	push   $0x4c
  jmp __alltraps
  101e7c:	e9 cb 07 00 00       	jmp    10264c <__alltraps>

00101e81 <vector77>:
.globl vector77
vector77:
  pushl $0
  101e81:	6a 00                	push   $0x0
  pushl $77
  101e83:	6a 4d                	push   $0x4d
  jmp __alltraps
  101e85:	e9 c2 07 00 00       	jmp    10264c <__alltraps>

00101e8a <vector78>:
.globl vector78
vector78:
  pushl $0
  101e8a:	6a 00                	push   $0x0
  pushl $78
  101e8c:	6a 4e                	push   $0x4e
  jmp __alltraps
  101e8e:	e9 b9 07 00 00       	jmp    10264c <__alltraps>

00101e93 <vector79>:
.globl vector79
vector79:
  pushl $0
  101e93:	6a 00                	push   $0x0
  pushl $79
  101e95:	6a 4f                	push   $0x4f
  jmp __alltraps
  101e97:	e9 b0 07 00 00       	jmp    10264c <__alltraps>

00101e9c <vector80>:
.globl vector80
vector80:
  pushl $0
  101e9c:	6a 00                	push   $0x0
  pushl $80
  101e9e:	6a 50                	push   $0x50
  jmp __alltraps
  101ea0:	e9 a7 07 00 00       	jmp    10264c <__alltraps>

00101ea5 <vector81>:
.globl vector81
vector81:
  pushl $0
  101ea5:	6a 00                	push   $0x0
  pushl $81
  101ea7:	6a 51                	push   $0x51
  jmp __alltraps
  101ea9:	e9 9e 07 00 00       	jmp    10264c <__alltraps>

00101eae <vector82>:
.globl vector82
vector82:
  pushl $0
  101eae:	6a 00                	push   $0x0
  pushl $82
  101eb0:	6a 52                	push   $0x52
  jmp __alltraps
  101eb2:	e9 95 07 00 00       	jmp    10264c <__alltraps>

00101eb7 <vector83>:
.globl vector83
vector83:
  pushl $0
  101eb7:	6a 00                	push   $0x0
  pushl $83
  101eb9:	6a 53                	push   $0x53
  jmp __alltraps
  101ebb:	e9 8c 07 00 00       	jmp    10264c <__alltraps>

00101ec0 <vector84>:
.globl vector84
vector84:
  pushl $0
  101ec0:	6a 00                	push   $0x0
  pushl $84
  101ec2:	6a 54                	push   $0x54
  jmp __alltraps
  101ec4:	e9 83 07 00 00       	jmp    10264c <__alltraps>

00101ec9 <vector85>:
.globl vector85
vector85:
  pushl $0
  101ec9:	6a 00                	push   $0x0
  pushl $85
  101ecb:	6a 55                	push   $0x55
  jmp __alltraps
  101ecd:	e9 7a 07 00 00       	jmp    10264c <__alltraps>

00101ed2 <vector86>:
.globl vector86
vector86:
  pushl $0
  101ed2:	6a 00                	push   $0x0
  pushl $86
  101ed4:	6a 56                	push   $0x56
  jmp __alltraps
  101ed6:	e9 71 07 00 00       	jmp    10264c <__alltraps>

00101edb <vector87>:
.globl vector87
vector87:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $87
  101edd:	6a 57                	push   $0x57
  jmp __alltraps
  101edf:	e9 68 07 00 00       	jmp    10264c <__alltraps>

00101ee4 <vector88>:
.globl vector88
vector88:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $88
  101ee6:	6a 58                	push   $0x58
  jmp __alltraps
  101ee8:	e9 5f 07 00 00       	jmp    10264c <__alltraps>

00101eed <vector89>:
.globl vector89
vector89:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $89
  101eef:	6a 59                	push   $0x59
  jmp __alltraps
  101ef1:	e9 56 07 00 00       	jmp    10264c <__alltraps>

00101ef6 <vector90>:
.globl vector90
vector90:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $90
  101ef8:	6a 5a                	push   $0x5a
  jmp __alltraps
  101efa:	e9 4d 07 00 00       	jmp    10264c <__alltraps>

00101eff <vector91>:
.globl vector91
vector91:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $91
  101f01:	6a 5b                	push   $0x5b
  jmp __alltraps
  101f03:	e9 44 07 00 00       	jmp    10264c <__alltraps>

00101f08 <vector92>:
.globl vector92
vector92:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $92
  101f0a:	6a 5c                	push   $0x5c
  jmp __alltraps
  101f0c:	e9 3b 07 00 00       	jmp    10264c <__alltraps>

00101f11 <vector93>:
.globl vector93
vector93:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $93
  101f13:	6a 5d                	push   $0x5d
  jmp __alltraps
  101f15:	e9 32 07 00 00       	jmp    10264c <__alltraps>

00101f1a <vector94>:
.globl vector94
vector94:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $94
  101f1c:	6a 5e                	push   $0x5e
  jmp __alltraps
  101f1e:	e9 29 07 00 00       	jmp    10264c <__alltraps>

00101f23 <vector95>:
.globl vector95
vector95:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $95
  101f25:	6a 5f                	push   $0x5f
  jmp __alltraps
  101f27:	e9 20 07 00 00       	jmp    10264c <__alltraps>

00101f2c <vector96>:
.globl vector96
vector96:
  pushl $0
  101f2c:	6a 00                	push   $0x0
  pushl $96
  101f2e:	6a 60                	push   $0x60
  jmp __alltraps
  101f30:	e9 17 07 00 00       	jmp    10264c <__alltraps>

00101f35 <vector97>:
.globl vector97
vector97:
  pushl $0
  101f35:	6a 00                	push   $0x0
  pushl $97
  101f37:	6a 61                	push   $0x61
  jmp __alltraps
  101f39:	e9 0e 07 00 00       	jmp    10264c <__alltraps>

00101f3e <vector98>:
.globl vector98
vector98:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $98
  101f40:	6a 62                	push   $0x62
  jmp __alltraps
  101f42:	e9 05 07 00 00       	jmp    10264c <__alltraps>

00101f47 <vector99>:
.globl vector99
vector99:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $99
  101f49:	6a 63                	push   $0x63
  jmp __alltraps
  101f4b:	e9 fc 06 00 00       	jmp    10264c <__alltraps>

00101f50 <vector100>:
.globl vector100
vector100:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $100
  101f52:	6a 64                	push   $0x64
  jmp __alltraps
  101f54:	e9 f3 06 00 00       	jmp    10264c <__alltraps>

00101f59 <vector101>:
.globl vector101
vector101:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $101
  101f5b:	6a 65                	push   $0x65
  jmp __alltraps
  101f5d:	e9 ea 06 00 00       	jmp    10264c <__alltraps>

00101f62 <vector102>:
.globl vector102
vector102:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $102
  101f64:	6a 66                	push   $0x66
  jmp __alltraps
  101f66:	e9 e1 06 00 00       	jmp    10264c <__alltraps>

00101f6b <vector103>:
.globl vector103
vector103:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $103
  101f6d:	6a 67                	push   $0x67
  jmp __alltraps
  101f6f:	e9 d8 06 00 00       	jmp    10264c <__alltraps>

00101f74 <vector104>:
.globl vector104
vector104:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $104
  101f76:	6a 68                	push   $0x68
  jmp __alltraps
  101f78:	e9 cf 06 00 00       	jmp    10264c <__alltraps>

00101f7d <vector105>:
.globl vector105
vector105:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $105
  101f7f:	6a 69                	push   $0x69
  jmp __alltraps
  101f81:	e9 c6 06 00 00       	jmp    10264c <__alltraps>

00101f86 <vector106>:
.globl vector106
vector106:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $106
  101f88:	6a 6a                	push   $0x6a
  jmp __alltraps
  101f8a:	e9 bd 06 00 00       	jmp    10264c <__alltraps>

00101f8f <vector107>:
.globl vector107
vector107:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $107
  101f91:	6a 6b                	push   $0x6b
  jmp __alltraps
  101f93:	e9 b4 06 00 00       	jmp    10264c <__alltraps>

00101f98 <vector108>:
.globl vector108
vector108:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $108
  101f9a:	6a 6c                	push   $0x6c
  jmp __alltraps
  101f9c:	e9 ab 06 00 00       	jmp    10264c <__alltraps>

00101fa1 <vector109>:
.globl vector109
vector109:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $109
  101fa3:	6a 6d                	push   $0x6d
  jmp __alltraps
  101fa5:	e9 a2 06 00 00       	jmp    10264c <__alltraps>

00101faa <vector110>:
.globl vector110
vector110:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $110
  101fac:	6a 6e                	push   $0x6e
  jmp __alltraps
  101fae:	e9 99 06 00 00       	jmp    10264c <__alltraps>

00101fb3 <vector111>:
.globl vector111
vector111:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $111
  101fb5:	6a 6f                	push   $0x6f
  jmp __alltraps
  101fb7:	e9 90 06 00 00       	jmp    10264c <__alltraps>

00101fbc <vector112>:
.globl vector112
vector112:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $112
  101fbe:	6a 70                	push   $0x70
  jmp __alltraps
  101fc0:	e9 87 06 00 00       	jmp    10264c <__alltraps>

00101fc5 <vector113>:
.globl vector113
vector113:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $113
  101fc7:	6a 71                	push   $0x71
  jmp __alltraps
  101fc9:	e9 7e 06 00 00       	jmp    10264c <__alltraps>

00101fce <vector114>:
.globl vector114
vector114:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $114
  101fd0:	6a 72                	push   $0x72
  jmp __alltraps
  101fd2:	e9 75 06 00 00       	jmp    10264c <__alltraps>

00101fd7 <vector115>:
.globl vector115
vector115:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $115
  101fd9:	6a 73                	push   $0x73
  jmp __alltraps
  101fdb:	e9 6c 06 00 00       	jmp    10264c <__alltraps>

00101fe0 <vector116>:
.globl vector116
vector116:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $116
  101fe2:	6a 74                	push   $0x74
  jmp __alltraps
  101fe4:	e9 63 06 00 00       	jmp    10264c <__alltraps>

00101fe9 <vector117>:
.globl vector117
vector117:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $117
  101feb:	6a 75                	push   $0x75
  jmp __alltraps
  101fed:	e9 5a 06 00 00       	jmp    10264c <__alltraps>

00101ff2 <vector118>:
.globl vector118
vector118:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $118
  101ff4:	6a 76                	push   $0x76
  jmp __alltraps
  101ff6:	e9 51 06 00 00       	jmp    10264c <__alltraps>

00101ffb <vector119>:
.globl vector119
vector119:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $119
  101ffd:	6a 77                	push   $0x77
  jmp __alltraps
  101fff:	e9 48 06 00 00       	jmp    10264c <__alltraps>

00102004 <vector120>:
.globl vector120
vector120:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $120
  102006:	6a 78                	push   $0x78
  jmp __alltraps
  102008:	e9 3f 06 00 00       	jmp    10264c <__alltraps>

0010200d <vector121>:
.globl vector121
vector121:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $121
  10200f:	6a 79                	push   $0x79
  jmp __alltraps
  102011:	e9 36 06 00 00       	jmp    10264c <__alltraps>

00102016 <vector122>:
.globl vector122
vector122:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $122
  102018:	6a 7a                	push   $0x7a
  jmp __alltraps
  10201a:	e9 2d 06 00 00       	jmp    10264c <__alltraps>

0010201f <vector123>:
.globl vector123
vector123:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $123
  102021:	6a 7b                	push   $0x7b
  jmp __alltraps
  102023:	e9 24 06 00 00       	jmp    10264c <__alltraps>

00102028 <vector124>:
.globl vector124
vector124:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $124
  10202a:	6a 7c                	push   $0x7c
  jmp __alltraps
  10202c:	e9 1b 06 00 00       	jmp    10264c <__alltraps>

00102031 <vector125>:
.globl vector125
vector125:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $125
  102033:	6a 7d                	push   $0x7d
  jmp __alltraps
  102035:	e9 12 06 00 00       	jmp    10264c <__alltraps>

0010203a <vector126>:
.globl vector126
vector126:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $126
  10203c:	6a 7e                	push   $0x7e
  jmp __alltraps
  10203e:	e9 09 06 00 00       	jmp    10264c <__alltraps>

00102043 <vector127>:
.globl vector127
vector127:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $127
  102045:	6a 7f                	push   $0x7f
  jmp __alltraps
  102047:	e9 00 06 00 00       	jmp    10264c <__alltraps>

0010204c <vector128>:
.globl vector128
vector128:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $128
  10204e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102053:	e9 f4 05 00 00       	jmp    10264c <__alltraps>

00102058 <vector129>:
.globl vector129
vector129:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $129
  10205a:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10205f:	e9 e8 05 00 00       	jmp    10264c <__alltraps>

00102064 <vector130>:
.globl vector130
vector130:
  pushl $0
  102064:	6a 00                	push   $0x0
  pushl $130
  102066:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10206b:	e9 dc 05 00 00       	jmp    10264c <__alltraps>

00102070 <vector131>:
.globl vector131
vector131:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $131
  102072:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102077:	e9 d0 05 00 00       	jmp    10264c <__alltraps>

0010207c <vector132>:
.globl vector132
vector132:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $132
  10207e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102083:	e9 c4 05 00 00       	jmp    10264c <__alltraps>

00102088 <vector133>:
.globl vector133
vector133:
  pushl $0
  102088:	6a 00                	push   $0x0
  pushl $133
  10208a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10208f:	e9 b8 05 00 00       	jmp    10264c <__alltraps>

00102094 <vector134>:
.globl vector134
vector134:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $134
  102096:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10209b:	e9 ac 05 00 00       	jmp    10264c <__alltraps>

001020a0 <vector135>:
.globl vector135
vector135:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $135
  1020a2:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1020a7:	e9 a0 05 00 00       	jmp    10264c <__alltraps>

001020ac <vector136>:
.globl vector136
vector136:
  pushl $0
  1020ac:	6a 00                	push   $0x0
  pushl $136
  1020ae:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1020b3:	e9 94 05 00 00       	jmp    10264c <__alltraps>

001020b8 <vector137>:
.globl vector137
vector137:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $137
  1020ba:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1020bf:	e9 88 05 00 00       	jmp    10264c <__alltraps>

001020c4 <vector138>:
.globl vector138
vector138:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $138
  1020c6:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1020cb:	e9 7c 05 00 00       	jmp    10264c <__alltraps>

001020d0 <vector139>:
.globl vector139
vector139:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $139
  1020d2:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1020d7:	e9 70 05 00 00       	jmp    10264c <__alltraps>

001020dc <vector140>:
.globl vector140
vector140:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $140
  1020de:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1020e3:	e9 64 05 00 00       	jmp    10264c <__alltraps>

001020e8 <vector141>:
.globl vector141
vector141:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $141
  1020ea:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1020ef:	e9 58 05 00 00       	jmp    10264c <__alltraps>

001020f4 <vector142>:
.globl vector142
vector142:
  pushl $0
  1020f4:	6a 00                	push   $0x0
  pushl $142
  1020f6:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1020fb:	e9 4c 05 00 00       	jmp    10264c <__alltraps>

00102100 <vector143>:
.globl vector143
vector143:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $143
  102102:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102107:	e9 40 05 00 00       	jmp    10264c <__alltraps>

0010210c <vector144>:
.globl vector144
vector144:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $144
  10210e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102113:	e9 34 05 00 00       	jmp    10264c <__alltraps>

00102118 <vector145>:
.globl vector145
vector145:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $145
  10211a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10211f:	e9 28 05 00 00       	jmp    10264c <__alltraps>

00102124 <vector146>:
.globl vector146
vector146:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $146
  102126:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10212b:	e9 1c 05 00 00       	jmp    10264c <__alltraps>

00102130 <vector147>:
.globl vector147
vector147:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $147
  102132:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102137:	e9 10 05 00 00       	jmp    10264c <__alltraps>

0010213c <vector148>:
.globl vector148
vector148:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $148
  10213e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102143:	e9 04 05 00 00       	jmp    10264c <__alltraps>

00102148 <vector149>:
.globl vector149
vector149:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $149
  10214a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10214f:	e9 f8 04 00 00       	jmp    10264c <__alltraps>

00102154 <vector150>:
.globl vector150
vector150:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $150
  102156:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10215b:	e9 ec 04 00 00       	jmp    10264c <__alltraps>

00102160 <vector151>:
.globl vector151
vector151:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $151
  102162:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102167:	e9 e0 04 00 00       	jmp    10264c <__alltraps>

0010216c <vector152>:
.globl vector152
vector152:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $152
  10216e:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102173:	e9 d4 04 00 00       	jmp    10264c <__alltraps>

00102178 <vector153>:
.globl vector153
vector153:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $153
  10217a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10217f:	e9 c8 04 00 00       	jmp    10264c <__alltraps>

00102184 <vector154>:
.globl vector154
vector154:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $154
  102186:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10218b:	e9 bc 04 00 00       	jmp    10264c <__alltraps>

00102190 <vector155>:
.globl vector155
vector155:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $155
  102192:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102197:	e9 b0 04 00 00       	jmp    10264c <__alltraps>

0010219c <vector156>:
.globl vector156
vector156:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $156
  10219e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1021a3:	e9 a4 04 00 00       	jmp    10264c <__alltraps>

001021a8 <vector157>:
.globl vector157
vector157:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $157
  1021aa:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1021af:	e9 98 04 00 00       	jmp    10264c <__alltraps>

001021b4 <vector158>:
.globl vector158
vector158:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $158
  1021b6:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1021bb:	e9 8c 04 00 00       	jmp    10264c <__alltraps>

001021c0 <vector159>:
.globl vector159
vector159:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $159
  1021c2:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1021c7:	e9 80 04 00 00       	jmp    10264c <__alltraps>

001021cc <vector160>:
.globl vector160
vector160:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $160
  1021ce:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1021d3:	e9 74 04 00 00       	jmp    10264c <__alltraps>

001021d8 <vector161>:
.globl vector161
vector161:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $161
  1021da:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1021df:	e9 68 04 00 00       	jmp    10264c <__alltraps>

001021e4 <vector162>:
.globl vector162
vector162:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $162
  1021e6:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1021eb:	e9 5c 04 00 00       	jmp    10264c <__alltraps>

001021f0 <vector163>:
.globl vector163
vector163:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $163
  1021f2:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1021f7:	e9 50 04 00 00       	jmp    10264c <__alltraps>

001021fc <vector164>:
.globl vector164
vector164:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $164
  1021fe:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102203:	e9 44 04 00 00       	jmp    10264c <__alltraps>

00102208 <vector165>:
.globl vector165
vector165:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $165
  10220a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10220f:	e9 38 04 00 00       	jmp    10264c <__alltraps>

00102214 <vector166>:
.globl vector166
vector166:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $166
  102216:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10221b:	e9 2c 04 00 00       	jmp    10264c <__alltraps>

00102220 <vector167>:
.globl vector167
vector167:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $167
  102222:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102227:	e9 20 04 00 00       	jmp    10264c <__alltraps>

0010222c <vector168>:
.globl vector168
vector168:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $168
  10222e:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102233:	e9 14 04 00 00       	jmp    10264c <__alltraps>

00102238 <vector169>:
.globl vector169
vector169:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $169
  10223a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10223f:	e9 08 04 00 00       	jmp    10264c <__alltraps>

00102244 <vector170>:
.globl vector170
vector170:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $170
  102246:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10224b:	e9 fc 03 00 00       	jmp    10264c <__alltraps>

00102250 <vector171>:
.globl vector171
vector171:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $171
  102252:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102257:	e9 f0 03 00 00       	jmp    10264c <__alltraps>

0010225c <vector172>:
.globl vector172
vector172:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $172
  10225e:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102263:	e9 e4 03 00 00       	jmp    10264c <__alltraps>

00102268 <vector173>:
.globl vector173
vector173:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $173
  10226a:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10226f:	e9 d8 03 00 00       	jmp    10264c <__alltraps>

00102274 <vector174>:
.globl vector174
vector174:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $174
  102276:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10227b:	e9 cc 03 00 00       	jmp    10264c <__alltraps>

00102280 <vector175>:
.globl vector175
vector175:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $175
  102282:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102287:	e9 c0 03 00 00       	jmp    10264c <__alltraps>

0010228c <vector176>:
.globl vector176
vector176:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $176
  10228e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102293:	e9 b4 03 00 00       	jmp    10264c <__alltraps>

00102298 <vector177>:
.globl vector177
vector177:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $177
  10229a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10229f:	e9 a8 03 00 00       	jmp    10264c <__alltraps>

001022a4 <vector178>:
.globl vector178
vector178:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $178
  1022a6:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1022ab:	e9 9c 03 00 00       	jmp    10264c <__alltraps>

001022b0 <vector179>:
.globl vector179
vector179:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $179
  1022b2:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1022b7:	e9 90 03 00 00       	jmp    10264c <__alltraps>

001022bc <vector180>:
.globl vector180
vector180:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $180
  1022be:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1022c3:	e9 84 03 00 00       	jmp    10264c <__alltraps>

001022c8 <vector181>:
.globl vector181
vector181:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $181
  1022ca:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1022cf:	e9 78 03 00 00       	jmp    10264c <__alltraps>

001022d4 <vector182>:
.globl vector182
vector182:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $182
  1022d6:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1022db:	e9 6c 03 00 00       	jmp    10264c <__alltraps>

001022e0 <vector183>:
.globl vector183
vector183:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $183
  1022e2:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1022e7:	e9 60 03 00 00       	jmp    10264c <__alltraps>

001022ec <vector184>:
.globl vector184
vector184:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $184
  1022ee:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1022f3:	e9 54 03 00 00       	jmp    10264c <__alltraps>

001022f8 <vector185>:
.globl vector185
vector185:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $185
  1022fa:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1022ff:	e9 48 03 00 00       	jmp    10264c <__alltraps>

00102304 <vector186>:
.globl vector186
vector186:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $186
  102306:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10230b:	e9 3c 03 00 00       	jmp    10264c <__alltraps>

00102310 <vector187>:
.globl vector187
vector187:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $187
  102312:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102317:	e9 30 03 00 00       	jmp    10264c <__alltraps>

0010231c <vector188>:
.globl vector188
vector188:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $188
  10231e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102323:	e9 24 03 00 00       	jmp    10264c <__alltraps>

00102328 <vector189>:
.globl vector189
vector189:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $189
  10232a:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10232f:	e9 18 03 00 00       	jmp    10264c <__alltraps>

00102334 <vector190>:
.globl vector190
vector190:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $190
  102336:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10233b:	e9 0c 03 00 00       	jmp    10264c <__alltraps>

00102340 <vector191>:
.globl vector191
vector191:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $191
  102342:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102347:	e9 00 03 00 00       	jmp    10264c <__alltraps>

0010234c <vector192>:
.globl vector192
vector192:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $192
  10234e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102353:	e9 f4 02 00 00       	jmp    10264c <__alltraps>

00102358 <vector193>:
.globl vector193
vector193:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $193
  10235a:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10235f:	e9 e8 02 00 00       	jmp    10264c <__alltraps>

00102364 <vector194>:
.globl vector194
vector194:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $194
  102366:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10236b:	e9 dc 02 00 00       	jmp    10264c <__alltraps>

00102370 <vector195>:
.globl vector195
vector195:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $195
  102372:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102377:	e9 d0 02 00 00       	jmp    10264c <__alltraps>

0010237c <vector196>:
.globl vector196
vector196:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $196
  10237e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102383:	e9 c4 02 00 00       	jmp    10264c <__alltraps>

00102388 <vector197>:
.globl vector197
vector197:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $197
  10238a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10238f:	e9 b8 02 00 00       	jmp    10264c <__alltraps>

00102394 <vector198>:
.globl vector198
vector198:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $198
  102396:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10239b:	e9 ac 02 00 00       	jmp    10264c <__alltraps>

001023a0 <vector199>:
.globl vector199
vector199:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $199
  1023a2:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1023a7:	e9 a0 02 00 00       	jmp    10264c <__alltraps>

001023ac <vector200>:
.globl vector200
vector200:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $200
  1023ae:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1023b3:	e9 94 02 00 00       	jmp    10264c <__alltraps>

001023b8 <vector201>:
.globl vector201
vector201:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $201
  1023ba:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1023bf:	e9 88 02 00 00       	jmp    10264c <__alltraps>

001023c4 <vector202>:
.globl vector202
vector202:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $202
  1023c6:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1023cb:	e9 7c 02 00 00       	jmp    10264c <__alltraps>

001023d0 <vector203>:
.globl vector203
vector203:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $203
  1023d2:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1023d7:	e9 70 02 00 00       	jmp    10264c <__alltraps>

001023dc <vector204>:
.globl vector204
vector204:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $204
  1023de:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1023e3:	e9 64 02 00 00       	jmp    10264c <__alltraps>

001023e8 <vector205>:
.globl vector205
vector205:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $205
  1023ea:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1023ef:	e9 58 02 00 00       	jmp    10264c <__alltraps>

001023f4 <vector206>:
.globl vector206
vector206:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $206
  1023f6:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1023fb:	e9 4c 02 00 00       	jmp    10264c <__alltraps>

00102400 <vector207>:
.globl vector207
vector207:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $207
  102402:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102407:	e9 40 02 00 00       	jmp    10264c <__alltraps>

0010240c <vector208>:
.globl vector208
vector208:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $208
  10240e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102413:	e9 34 02 00 00       	jmp    10264c <__alltraps>

00102418 <vector209>:
.globl vector209
vector209:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $209
  10241a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10241f:	e9 28 02 00 00       	jmp    10264c <__alltraps>

00102424 <vector210>:
.globl vector210
vector210:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $210
  102426:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10242b:	e9 1c 02 00 00       	jmp    10264c <__alltraps>

00102430 <vector211>:
.globl vector211
vector211:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $211
  102432:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102437:	e9 10 02 00 00       	jmp    10264c <__alltraps>

0010243c <vector212>:
.globl vector212
vector212:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $212
  10243e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102443:	e9 04 02 00 00       	jmp    10264c <__alltraps>

00102448 <vector213>:
.globl vector213
vector213:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $213
  10244a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10244f:	e9 f8 01 00 00       	jmp    10264c <__alltraps>

00102454 <vector214>:
.globl vector214
vector214:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $214
  102456:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10245b:	e9 ec 01 00 00       	jmp    10264c <__alltraps>

00102460 <vector215>:
.globl vector215
vector215:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $215
  102462:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102467:	e9 e0 01 00 00       	jmp    10264c <__alltraps>

0010246c <vector216>:
.globl vector216
vector216:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $216
  10246e:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102473:	e9 d4 01 00 00       	jmp    10264c <__alltraps>

00102478 <vector217>:
.globl vector217
vector217:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $217
  10247a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10247f:	e9 c8 01 00 00       	jmp    10264c <__alltraps>

00102484 <vector218>:
.globl vector218
vector218:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $218
  102486:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10248b:	e9 bc 01 00 00       	jmp    10264c <__alltraps>

00102490 <vector219>:
.globl vector219
vector219:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $219
  102492:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102497:	e9 b0 01 00 00       	jmp    10264c <__alltraps>

0010249c <vector220>:
.globl vector220
vector220:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $220
  10249e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1024a3:	e9 a4 01 00 00       	jmp    10264c <__alltraps>

001024a8 <vector221>:
.globl vector221
vector221:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $221
  1024aa:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1024af:	e9 98 01 00 00       	jmp    10264c <__alltraps>

001024b4 <vector222>:
.globl vector222
vector222:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $222
  1024b6:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1024bb:	e9 8c 01 00 00       	jmp    10264c <__alltraps>

001024c0 <vector223>:
.globl vector223
vector223:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $223
  1024c2:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1024c7:	e9 80 01 00 00       	jmp    10264c <__alltraps>

001024cc <vector224>:
.globl vector224
vector224:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $224
  1024ce:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1024d3:	e9 74 01 00 00       	jmp    10264c <__alltraps>

001024d8 <vector225>:
.globl vector225
vector225:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $225
  1024da:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1024df:	e9 68 01 00 00       	jmp    10264c <__alltraps>

001024e4 <vector226>:
.globl vector226
vector226:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $226
  1024e6:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1024eb:	e9 5c 01 00 00       	jmp    10264c <__alltraps>

001024f0 <vector227>:
.globl vector227
vector227:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $227
  1024f2:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1024f7:	e9 50 01 00 00       	jmp    10264c <__alltraps>

001024fc <vector228>:
.globl vector228
vector228:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $228
  1024fe:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102503:	e9 44 01 00 00       	jmp    10264c <__alltraps>

00102508 <vector229>:
.globl vector229
vector229:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $229
  10250a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10250f:	e9 38 01 00 00       	jmp    10264c <__alltraps>

00102514 <vector230>:
.globl vector230
vector230:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $230
  102516:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10251b:	e9 2c 01 00 00       	jmp    10264c <__alltraps>

00102520 <vector231>:
.globl vector231
vector231:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $231
  102522:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102527:	e9 20 01 00 00       	jmp    10264c <__alltraps>

0010252c <vector232>:
.globl vector232
vector232:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $232
  10252e:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102533:	e9 14 01 00 00       	jmp    10264c <__alltraps>

00102538 <vector233>:
.globl vector233
vector233:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $233
  10253a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10253f:	e9 08 01 00 00       	jmp    10264c <__alltraps>

00102544 <vector234>:
.globl vector234
vector234:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $234
  102546:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10254b:	e9 fc 00 00 00       	jmp    10264c <__alltraps>

00102550 <vector235>:
.globl vector235
vector235:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $235
  102552:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102557:	e9 f0 00 00 00       	jmp    10264c <__alltraps>

0010255c <vector236>:
.globl vector236
vector236:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $236
  10255e:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102563:	e9 e4 00 00 00       	jmp    10264c <__alltraps>

00102568 <vector237>:
.globl vector237
vector237:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $237
  10256a:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10256f:	e9 d8 00 00 00       	jmp    10264c <__alltraps>

00102574 <vector238>:
.globl vector238
vector238:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $238
  102576:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10257b:	e9 cc 00 00 00       	jmp    10264c <__alltraps>

00102580 <vector239>:
.globl vector239
vector239:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $239
  102582:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102587:	e9 c0 00 00 00       	jmp    10264c <__alltraps>

0010258c <vector240>:
.globl vector240
vector240:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $240
  10258e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102593:	e9 b4 00 00 00       	jmp    10264c <__alltraps>

00102598 <vector241>:
.globl vector241
vector241:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $241
  10259a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10259f:	e9 a8 00 00 00       	jmp    10264c <__alltraps>

001025a4 <vector242>:
.globl vector242
vector242:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $242
  1025a6:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1025ab:	e9 9c 00 00 00       	jmp    10264c <__alltraps>

001025b0 <vector243>:
.globl vector243
vector243:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $243
  1025b2:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1025b7:	e9 90 00 00 00       	jmp    10264c <__alltraps>

001025bc <vector244>:
.globl vector244
vector244:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $244
  1025be:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1025c3:	e9 84 00 00 00       	jmp    10264c <__alltraps>

001025c8 <vector245>:
.globl vector245
vector245:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $245
  1025ca:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1025cf:	e9 78 00 00 00       	jmp    10264c <__alltraps>

001025d4 <vector246>:
.globl vector246
vector246:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $246
  1025d6:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1025db:	e9 6c 00 00 00       	jmp    10264c <__alltraps>

001025e0 <vector247>:
.globl vector247
vector247:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $247
  1025e2:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1025e7:	e9 60 00 00 00       	jmp    10264c <__alltraps>

001025ec <vector248>:
.globl vector248
vector248:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $248
  1025ee:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1025f3:	e9 54 00 00 00       	jmp    10264c <__alltraps>

001025f8 <vector249>:
.globl vector249
vector249:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $249
  1025fa:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1025ff:	e9 48 00 00 00       	jmp    10264c <__alltraps>

00102604 <vector250>:
.globl vector250
vector250:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $250
  102606:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10260b:	e9 3c 00 00 00       	jmp    10264c <__alltraps>

00102610 <vector251>:
.globl vector251
vector251:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $251
  102612:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102617:	e9 30 00 00 00       	jmp    10264c <__alltraps>

0010261c <vector252>:
.globl vector252
vector252:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $252
  10261e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102623:	e9 24 00 00 00       	jmp    10264c <__alltraps>

00102628 <vector253>:
.globl vector253
vector253:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $253
  10262a:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10262f:	e9 18 00 00 00       	jmp    10264c <__alltraps>

00102634 <vector254>:
.globl vector254
vector254:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $254
  102636:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10263b:	e9 0c 00 00 00       	jmp    10264c <__alltraps>

00102640 <vector255>:
.globl vector255
vector255:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $255
  102642:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102647:	e9 00 00 00 00       	jmp    10264c <__alltraps>

0010264c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10264c:	1e                   	push   %ds
    pushl %es
  10264d:	06                   	push   %es
    pushl %fs
  10264e:	0f a0                	push   %fs
    pushl %gs
  102650:	0f a8                	push   %gs
    pushal
  102652:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102653:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102658:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10265a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10265c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10265d:	e8 61 f5 ff ff       	call   101bc3 <trap>

    # pop the pushed stack pointer
    popl %esp
  102662:	5c                   	pop    %esp

00102663 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102663:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102664:	0f a9                	pop    %gs
    popl %fs
  102666:	0f a1                	pop    %fs
    popl %es
  102668:	07                   	pop    %es
    popl %ds
  102669:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10266a:	83 c4 08             	add    $0x8,%esp
    iret
  10266d:	cf                   	iret   

0010266e <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10266e:	55                   	push   %ebp
  10266f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102671:	8b 45 08             	mov    0x8(%ebp),%eax
  102674:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102677:	b8 23 00 00 00       	mov    $0x23,%eax
  10267c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10267e:	b8 23 00 00 00       	mov    $0x23,%eax
  102683:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102685:	b8 10 00 00 00       	mov    $0x10,%eax
  10268a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10268c:	b8 10 00 00 00       	mov    $0x10,%eax
  102691:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102693:	b8 10 00 00 00       	mov    $0x10,%eax
  102698:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10269a:	ea a1 26 10 00 08 00 	ljmp   $0x8,$0x1026a1
}
  1026a1:	90                   	nop
  1026a2:	5d                   	pop    %ebp
  1026a3:	c3                   	ret    

001026a4 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1026a4:	55                   	push   %ebp
  1026a5:	89 e5                	mov    %esp,%ebp
  1026a7:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1026aa:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  1026af:	05 00 04 00 00       	add    $0x400,%eax
  1026b4:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1026b9:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1026c0:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1026c2:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1026c9:	68 00 
  1026cb:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1026d0:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1026d6:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1026db:	c1 e8 10             	shr    $0x10,%eax
  1026de:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1026e3:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026ea:	83 e0 f0             	and    $0xfffffff0,%eax
  1026ed:	83 c8 09             	or     $0x9,%eax
  1026f0:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1026f5:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026fc:	83 c8 10             	or     $0x10,%eax
  1026ff:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102704:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10270b:	83 e0 9f             	and    $0xffffff9f,%eax
  10270e:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102713:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10271a:	83 c8 80             	or     $0xffffff80,%eax
  10271d:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102722:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102729:	83 e0 f0             	and    $0xfffffff0,%eax
  10272c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102731:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102738:	83 e0 ef             	and    $0xffffffef,%eax
  10273b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102740:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102747:	83 e0 df             	and    $0xffffffdf,%eax
  10274a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10274f:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102756:	83 c8 40             	or     $0x40,%eax
  102759:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10275e:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102765:	83 e0 7f             	and    $0x7f,%eax
  102768:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10276d:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102772:	c1 e8 18             	shr    $0x18,%eax
  102775:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  10277a:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102781:	83 e0 ef             	and    $0xffffffef,%eax
  102784:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102789:	68 10 ea 10 00       	push   $0x10ea10
  10278e:	e8 db fe ff ff       	call   10266e <lgdt>
  102793:	83 c4 04             	add    $0x4,%esp
  102796:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  10279c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1027a0:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1027a3:	90                   	nop
  1027a4:	c9                   	leave  
  1027a5:	c3                   	ret    

001027a6 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1027a6:	55                   	push   %ebp
  1027a7:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1027a9:	e8 f6 fe ff ff       	call   1026a4 <gdt_init>
}
  1027ae:	90                   	nop
  1027af:	5d                   	pop    %ebp
  1027b0:	c3                   	ret    

001027b1 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1027b1:	55                   	push   %ebp
  1027b2:	89 e5                	mov    %esp,%ebp
  1027b4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1027b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1027be:	eb 04                	jmp    1027c4 <strlen+0x13>
        cnt ++;
  1027c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1027c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1027c7:	8d 50 01             	lea    0x1(%eax),%edx
  1027ca:	89 55 08             	mov    %edx,0x8(%ebp)
  1027cd:	0f b6 00             	movzbl (%eax),%eax
  1027d0:	84 c0                	test   %al,%al
  1027d2:	75 ec                	jne    1027c0 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  1027d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1027d7:	c9                   	leave  
  1027d8:	c3                   	ret    

001027d9 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1027d9:	55                   	push   %ebp
  1027da:	89 e5                	mov    %esp,%ebp
  1027dc:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1027df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1027e6:	eb 04                	jmp    1027ec <strnlen+0x13>
        cnt ++;
  1027e8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  1027ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1027ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1027f2:	73 10                	jae    102804 <strnlen+0x2b>
  1027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1027f7:	8d 50 01             	lea    0x1(%eax),%edx
  1027fa:	89 55 08             	mov    %edx,0x8(%ebp)
  1027fd:	0f b6 00             	movzbl (%eax),%eax
  102800:	84 c0                	test   %al,%al
  102802:	75 e4                	jne    1027e8 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102804:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102807:	c9                   	leave  
  102808:	c3                   	ret    

00102809 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102809:	55                   	push   %ebp
  10280a:	89 e5                	mov    %esp,%ebp
  10280c:	57                   	push   %edi
  10280d:	56                   	push   %esi
  10280e:	83 ec 20             	sub    $0x20,%esp
  102811:	8b 45 08             	mov    0x8(%ebp),%eax
  102814:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102817:	8b 45 0c             	mov    0xc(%ebp),%eax
  10281a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10281d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102823:	89 d1                	mov    %edx,%ecx
  102825:	89 c2                	mov    %eax,%edx
  102827:	89 ce                	mov    %ecx,%esi
  102829:	89 d7                	mov    %edx,%edi
  10282b:	ac                   	lods   %ds:(%esi),%al
  10282c:	aa                   	stos   %al,%es:(%edi)
  10282d:	84 c0                	test   %al,%al
  10282f:	75 fa                	jne    10282b <strcpy+0x22>
  102831:	89 fa                	mov    %edi,%edx
  102833:	89 f1                	mov    %esi,%ecx
  102835:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102838:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10283b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102841:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102842:	83 c4 20             	add    $0x20,%esp
  102845:	5e                   	pop    %esi
  102846:	5f                   	pop    %edi
  102847:	5d                   	pop    %ebp
  102848:	c3                   	ret    

00102849 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102849:	55                   	push   %ebp
  10284a:	89 e5                	mov    %esp,%ebp
  10284c:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10284f:	8b 45 08             	mov    0x8(%ebp),%eax
  102852:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102855:	eb 21                	jmp    102878 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102857:	8b 45 0c             	mov    0xc(%ebp),%eax
  10285a:	0f b6 10             	movzbl (%eax),%edx
  10285d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102860:	88 10                	mov    %dl,(%eax)
  102862:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102865:	0f b6 00             	movzbl (%eax),%eax
  102868:	84 c0                	test   %al,%al
  10286a:	74 04                	je     102870 <strncpy+0x27>
            src ++;
  10286c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102870:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102874:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  102878:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10287c:	75 d9                	jne    102857 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  10287e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102881:	c9                   	leave  
  102882:	c3                   	ret    

00102883 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102883:	55                   	push   %ebp
  102884:	89 e5                	mov    %esp,%ebp
  102886:	57                   	push   %edi
  102887:	56                   	push   %esi
  102888:	83 ec 20             	sub    $0x20,%esp
  10288b:	8b 45 08             	mov    0x8(%ebp),%eax
  10288e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102891:	8b 45 0c             	mov    0xc(%ebp),%eax
  102894:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10289a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10289d:	89 d1                	mov    %edx,%ecx
  10289f:	89 c2                	mov    %eax,%edx
  1028a1:	89 ce                	mov    %ecx,%esi
  1028a3:	89 d7                	mov    %edx,%edi
  1028a5:	ac                   	lods   %ds:(%esi),%al
  1028a6:	ae                   	scas   %es:(%edi),%al
  1028a7:	75 08                	jne    1028b1 <strcmp+0x2e>
  1028a9:	84 c0                	test   %al,%al
  1028ab:	75 f8                	jne    1028a5 <strcmp+0x22>
  1028ad:	31 c0                	xor    %eax,%eax
  1028af:	eb 04                	jmp    1028b5 <strcmp+0x32>
  1028b1:	19 c0                	sbb    %eax,%eax
  1028b3:	0c 01                	or     $0x1,%al
  1028b5:	89 fa                	mov    %edi,%edx
  1028b7:	89 f1                	mov    %esi,%ecx
  1028b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1028bc:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1028bf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1028c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  1028c5:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1028c6:	83 c4 20             	add    $0x20,%esp
  1028c9:	5e                   	pop    %esi
  1028ca:	5f                   	pop    %edi
  1028cb:	5d                   	pop    %ebp
  1028cc:	c3                   	ret    

001028cd <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1028cd:	55                   	push   %ebp
  1028ce:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1028d0:	eb 0c                	jmp    1028de <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1028d2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1028d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1028da:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1028de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1028e2:	74 1a                	je     1028fe <strncmp+0x31>
  1028e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1028e7:	0f b6 00             	movzbl (%eax),%eax
  1028ea:	84 c0                	test   %al,%al
  1028ec:	74 10                	je     1028fe <strncmp+0x31>
  1028ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1028f1:	0f b6 10             	movzbl (%eax),%edx
  1028f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1028f7:	0f b6 00             	movzbl (%eax),%eax
  1028fa:	38 c2                	cmp    %al,%dl
  1028fc:	74 d4                	je     1028d2 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1028fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102902:	74 18                	je     10291c <strncmp+0x4f>
  102904:	8b 45 08             	mov    0x8(%ebp),%eax
  102907:	0f b6 00             	movzbl (%eax),%eax
  10290a:	0f b6 d0             	movzbl %al,%edx
  10290d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102910:	0f b6 00             	movzbl (%eax),%eax
  102913:	0f b6 c0             	movzbl %al,%eax
  102916:	29 c2                	sub    %eax,%edx
  102918:	89 d0                	mov    %edx,%eax
  10291a:	eb 05                	jmp    102921 <strncmp+0x54>
  10291c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102921:	5d                   	pop    %ebp
  102922:	c3                   	ret    

00102923 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102923:	55                   	push   %ebp
  102924:	89 e5                	mov    %esp,%ebp
  102926:	83 ec 04             	sub    $0x4,%esp
  102929:	8b 45 0c             	mov    0xc(%ebp),%eax
  10292c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10292f:	eb 14                	jmp    102945 <strchr+0x22>
        if (*s == c) {
  102931:	8b 45 08             	mov    0x8(%ebp),%eax
  102934:	0f b6 00             	movzbl (%eax),%eax
  102937:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10293a:	75 05                	jne    102941 <strchr+0x1e>
            return (char *)s;
  10293c:	8b 45 08             	mov    0x8(%ebp),%eax
  10293f:	eb 13                	jmp    102954 <strchr+0x31>
        }
        s ++;
  102941:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102945:	8b 45 08             	mov    0x8(%ebp),%eax
  102948:	0f b6 00             	movzbl (%eax),%eax
  10294b:	84 c0                	test   %al,%al
  10294d:	75 e2                	jne    102931 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  10294f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102954:	c9                   	leave  
  102955:	c3                   	ret    

00102956 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102956:	55                   	push   %ebp
  102957:	89 e5                	mov    %esp,%ebp
  102959:	83 ec 04             	sub    $0x4,%esp
  10295c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10295f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102962:	eb 0f                	jmp    102973 <strfind+0x1d>
        if (*s == c) {
  102964:	8b 45 08             	mov    0x8(%ebp),%eax
  102967:	0f b6 00             	movzbl (%eax),%eax
  10296a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10296d:	74 10                	je     10297f <strfind+0x29>
            break;
        }
        s ++;
  10296f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102973:	8b 45 08             	mov    0x8(%ebp),%eax
  102976:	0f b6 00             	movzbl (%eax),%eax
  102979:	84 c0                	test   %al,%al
  10297b:	75 e7                	jne    102964 <strfind+0xe>
  10297d:	eb 01                	jmp    102980 <strfind+0x2a>
        if (*s == c) {
            break;
  10297f:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  102980:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102983:	c9                   	leave  
  102984:	c3                   	ret    

00102985 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102985:	55                   	push   %ebp
  102986:	89 e5                	mov    %esp,%ebp
  102988:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10298b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102992:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102999:	eb 04                	jmp    10299f <strtol+0x1a>
        s ++;
  10299b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10299f:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a2:	0f b6 00             	movzbl (%eax),%eax
  1029a5:	3c 20                	cmp    $0x20,%al
  1029a7:	74 f2                	je     10299b <strtol+0x16>
  1029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ac:	0f b6 00             	movzbl (%eax),%eax
  1029af:	3c 09                	cmp    $0x9,%al
  1029b1:	74 e8                	je     10299b <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b6:	0f b6 00             	movzbl (%eax),%eax
  1029b9:	3c 2b                	cmp    $0x2b,%al
  1029bb:	75 06                	jne    1029c3 <strtol+0x3e>
        s ++;
  1029bd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1029c1:	eb 15                	jmp    1029d8 <strtol+0x53>
    }
    else if (*s == '-') {
  1029c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1029c6:	0f b6 00             	movzbl (%eax),%eax
  1029c9:	3c 2d                	cmp    $0x2d,%al
  1029cb:	75 0b                	jne    1029d8 <strtol+0x53>
        s ++, neg = 1;
  1029cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1029d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1029d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1029dc:	74 06                	je     1029e4 <strtol+0x5f>
  1029de:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1029e2:	75 24                	jne    102a08 <strtol+0x83>
  1029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e7:	0f b6 00             	movzbl (%eax),%eax
  1029ea:	3c 30                	cmp    $0x30,%al
  1029ec:	75 1a                	jne    102a08 <strtol+0x83>
  1029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f1:	83 c0 01             	add    $0x1,%eax
  1029f4:	0f b6 00             	movzbl (%eax),%eax
  1029f7:	3c 78                	cmp    $0x78,%al
  1029f9:	75 0d                	jne    102a08 <strtol+0x83>
        s += 2, base = 16;
  1029fb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1029ff:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102a06:	eb 2a                	jmp    102a32 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102a08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a0c:	75 17                	jne    102a25 <strtol+0xa0>
  102a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a11:	0f b6 00             	movzbl (%eax),%eax
  102a14:	3c 30                	cmp    $0x30,%al
  102a16:	75 0d                	jne    102a25 <strtol+0xa0>
        s ++, base = 8;
  102a18:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102a1c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102a23:	eb 0d                	jmp    102a32 <strtol+0xad>
    }
    else if (base == 0) {
  102a25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a29:	75 07                	jne    102a32 <strtol+0xad>
        base = 10;
  102a2b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102a32:	8b 45 08             	mov    0x8(%ebp),%eax
  102a35:	0f b6 00             	movzbl (%eax),%eax
  102a38:	3c 2f                	cmp    $0x2f,%al
  102a3a:	7e 1b                	jle    102a57 <strtol+0xd2>
  102a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3f:	0f b6 00             	movzbl (%eax),%eax
  102a42:	3c 39                	cmp    $0x39,%al
  102a44:	7f 11                	jg     102a57 <strtol+0xd2>
            dig = *s - '0';
  102a46:	8b 45 08             	mov    0x8(%ebp),%eax
  102a49:	0f b6 00             	movzbl (%eax),%eax
  102a4c:	0f be c0             	movsbl %al,%eax
  102a4f:	83 e8 30             	sub    $0x30,%eax
  102a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a55:	eb 48                	jmp    102a9f <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102a57:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5a:	0f b6 00             	movzbl (%eax),%eax
  102a5d:	3c 60                	cmp    $0x60,%al
  102a5f:	7e 1b                	jle    102a7c <strtol+0xf7>
  102a61:	8b 45 08             	mov    0x8(%ebp),%eax
  102a64:	0f b6 00             	movzbl (%eax),%eax
  102a67:	3c 7a                	cmp    $0x7a,%al
  102a69:	7f 11                	jg     102a7c <strtol+0xf7>
            dig = *s - 'a' + 10;
  102a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6e:	0f b6 00             	movzbl (%eax),%eax
  102a71:	0f be c0             	movsbl %al,%eax
  102a74:	83 e8 57             	sub    $0x57,%eax
  102a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a7a:	eb 23                	jmp    102a9f <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a7f:	0f b6 00             	movzbl (%eax),%eax
  102a82:	3c 40                	cmp    $0x40,%al
  102a84:	7e 3c                	jle    102ac2 <strtol+0x13d>
  102a86:	8b 45 08             	mov    0x8(%ebp),%eax
  102a89:	0f b6 00             	movzbl (%eax),%eax
  102a8c:	3c 5a                	cmp    $0x5a,%al
  102a8e:	7f 32                	jg     102ac2 <strtol+0x13d>
            dig = *s - 'A' + 10;
  102a90:	8b 45 08             	mov    0x8(%ebp),%eax
  102a93:	0f b6 00             	movzbl (%eax),%eax
  102a96:	0f be c0             	movsbl %al,%eax
  102a99:	83 e8 37             	sub    $0x37,%eax
  102a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aa2:	3b 45 10             	cmp    0x10(%ebp),%eax
  102aa5:	7d 1a                	jge    102ac1 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102aa7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102aab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102aae:	0f af 45 10          	imul   0x10(%ebp),%eax
  102ab2:	89 c2                	mov    %eax,%edx
  102ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ab7:	01 d0                	add    %edx,%eax
  102ab9:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102abc:	e9 71 ff ff ff       	jmp    102a32 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  102ac1:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  102ac2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ac6:	74 08                	je     102ad0 <strtol+0x14b>
        *endptr = (char *) s;
  102ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102acb:	8b 55 08             	mov    0x8(%ebp),%edx
  102ace:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102ad0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102ad4:	74 07                	je     102add <strtol+0x158>
  102ad6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ad9:	f7 d8                	neg    %eax
  102adb:	eb 03                	jmp    102ae0 <strtol+0x15b>
  102add:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102ae0:	c9                   	leave  
  102ae1:	c3                   	ret    

00102ae2 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102ae2:	55                   	push   %ebp
  102ae3:	89 e5                	mov    %esp,%ebp
  102ae5:	57                   	push   %edi
  102ae6:	83 ec 24             	sub    $0x24,%esp
  102ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102aec:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102aef:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102af3:	8b 55 08             	mov    0x8(%ebp),%edx
  102af6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102af9:	88 45 f7             	mov    %al,-0x9(%ebp)
  102afc:	8b 45 10             	mov    0x10(%ebp),%eax
  102aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102b02:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102b05:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102b09:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102b0c:	89 d7                	mov    %edx,%edi
  102b0e:	f3 aa                	rep stos %al,%es:(%edi)
  102b10:	89 fa                	mov    %edi,%edx
  102b12:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102b15:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102b18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102b1b:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102b1c:	83 c4 24             	add    $0x24,%esp
  102b1f:	5f                   	pop    %edi
  102b20:	5d                   	pop    %ebp
  102b21:	c3                   	ret    

00102b22 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102b22:	55                   	push   %ebp
  102b23:	89 e5                	mov    %esp,%ebp
  102b25:	57                   	push   %edi
  102b26:	56                   	push   %esi
  102b27:	53                   	push   %ebx
  102b28:	83 ec 30             	sub    $0x30,%esp
  102b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102b37:	8b 45 10             	mov    0x10(%ebp),%eax
  102b3a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b40:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102b43:	73 42                	jae    102b87 <memmove+0x65>
  102b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b4e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b54:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102b57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b5a:	c1 e8 02             	shr    $0x2,%eax
  102b5d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102b5f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102b62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b65:	89 d7                	mov    %edx,%edi
  102b67:	89 c6                	mov    %eax,%esi
  102b69:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102b6b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102b6e:	83 e1 03             	and    $0x3,%ecx
  102b71:	74 02                	je     102b75 <memmove+0x53>
  102b73:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102b75:	89 f0                	mov    %esi,%eax
  102b77:	89 fa                	mov    %edi,%edx
  102b79:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102b7c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102b7f:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102b82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102b85:	eb 36                	jmp    102bbd <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102b87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b90:	01 c2                	add    %eax,%edx
  102b92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b95:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b9b:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  102b9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ba1:	89 c1                	mov    %eax,%ecx
  102ba3:	89 d8                	mov    %ebx,%eax
  102ba5:	89 d6                	mov    %edx,%esi
  102ba7:	89 c7                	mov    %eax,%edi
  102ba9:	fd                   	std    
  102baa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102bac:	fc                   	cld    
  102bad:	89 f8                	mov    %edi,%eax
  102baf:	89 f2                	mov    %esi,%edx
  102bb1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102bb4:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102bb7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  102bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102bbd:	83 c4 30             	add    $0x30,%esp
  102bc0:	5b                   	pop    %ebx
  102bc1:	5e                   	pop    %esi
  102bc2:	5f                   	pop    %edi
  102bc3:	5d                   	pop    %ebp
  102bc4:	c3                   	ret    

00102bc5 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102bc5:	55                   	push   %ebp
  102bc6:	89 e5                	mov    %esp,%ebp
  102bc8:	57                   	push   %edi
  102bc9:	56                   	push   %esi
  102bca:	83 ec 20             	sub    $0x20,%esp
  102bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bd9:	8b 45 10             	mov    0x10(%ebp),%eax
  102bdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102bdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102be2:	c1 e8 02             	shr    $0x2,%eax
  102be5:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bed:	89 d7                	mov    %edx,%edi
  102bef:	89 c6                	mov    %eax,%esi
  102bf1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102bf3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102bf6:	83 e1 03             	and    $0x3,%ecx
  102bf9:	74 02                	je     102bfd <memcpy+0x38>
  102bfb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102bfd:	89 f0                	mov    %esi,%eax
  102bff:	89 fa                	mov    %edi,%edx
  102c01:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102c04:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102c07:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102c0d:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102c0e:	83 c4 20             	add    $0x20,%esp
  102c11:	5e                   	pop    %esi
  102c12:	5f                   	pop    %edi
  102c13:	5d                   	pop    %ebp
  102c14:	c3                   	ret    

00102c15 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102c15:	55                   	push   %ebp
  102c16:	89 e5                	mov    %esp,%ebp
  102c18:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c24:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102c27:	eb 30                	jmp    102c59 <memcmp+0x44>
        if (*s1 != *s2) {
  102c29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c2c:	0f b6 10             	movzbl (%eax),%edx
  102c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c32:	0f b6 00             	movzbl (%eax),%eax
  102c35:	38 c2                	cmp    %al,%dl
  102c37:	74 18                	je     102c51 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102c39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c3c:	0f b6 00             	movzbl (%eax),%eax
  102c3f:	0f b6 d0             	movzbl %al,%edx
  102c42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c45:	0f b6 00             	movzbl (%eax),%eax
  102c48:	0f b6 c0             	movzbl %al,%eax
  102c4b:	29 c2                	sub    %eax,%edx
  102c4d:	89 d0                	mov    %edx,%eax
  102c4f:	eb 1a                	jmp    102c6b <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102c51:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102c55:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  102c59:	8b 45 10             	mov    0x10(%ebp),%eax
  102c5c:	8d 50 ff             	lea    -0x1(%eax),%edx
  102c5f:	89 55 10             	mov    %edx,0x10(%ebp)
  102c62:	85 c0                	test   %eax,%eax
  102c64:	75 c3                	jne    102c29 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  102c66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c6b:	c9                   	leave  
  102c6c:	c3                   	ret    

00102c6d <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102c6d:	55                   	push   %ebp
  102c6e:	89 e5                	mov    %esp,%ebp
  102c70:	83 ec 38             	sub    $0x38,%esp
  102c73:	8b 45 10             	mov    0x10(%ebp),%eax
  102c76:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102c79:	8b 45 14             	mov    0x14(%ebp),%eax
  102c7c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102c7f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c82:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c85:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c88:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102c8b:	8b 45 18             	mov    0x18(%ebp),%eax
  102c8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102c91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c94:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c97:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c9a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ca0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ca3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102ca7:	74 1c                	je     102cc5 <printnum+0x58>
  102ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cac:	ba 00 00 00 00       	mov    $0x0,%edx
  102cb1:	f7 75 e4             	divl   -0x1c(%ebp)
  102cb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cba:	ba 00 00 00 00       	mov    $0x0,%edx
  102cbf:	f7 75 e4             	divl   -0x1c(%ebp)
  102cc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ccb:	f7 75 e4             	divl   -0x1c(%ebp)
  102cce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102cd1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102cd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cd7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102cda:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102cdd:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102ce0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ce3:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102ce6:	8b 45 18             	mov    0x18(%ebp),%eax
  102ce9:	ba 00 00 00 00       	mov    $0x0,%edx
  102cee:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102cf1:	77 41                	ja     102d34 <printnum+0xc7>
  102cf3:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102cf6:	72 05                	jb     102cfd <printnum+0x90>
  102cf8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102cfb:	77 37                	ja     102d34 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102cfd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102d00:	83 e8 01             	sub    $0x1,%eax
  102d03:	83 ec 04             	sub    $0x4,%esp
  102d06:	ff 75 20             	pushl  0x20(%ebp)
  102d09:	50                   	push   %eax
  102d0a:	ff 75 18             	pushl  0x18(%ebp)
  102d0d:	ff 75 ec             	pushl  -0x14(%ebp)
  102d10:	ff 75 e8             	pushl  -0x18(%ebp)
  102d13:	ff 75 0c             	pushl  0xc(%ebp)
  102d16:	ff 75 08             	pushl  0x8(%ebp)
  102d19:	e8 4f ff ff ff       	call   102c6d <printnum>
  102d1e:	83 c4 20             	add    $0x20,%esp
  102d21:	eb 1b                	jmp    102d3e <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102d23:	83 ec 08             	sub    $0x8,%esp
  102d26:	ff 75 0c             	pushl  0xc(%ebp)
  102d29:	ff 75 20             	pushl  0x20(%ebp)
  102d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2f:	ff d0                	call   *%eax
  102d31:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102d34:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102d38:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102d3c:	7f e5                	jg     102d23 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102d3e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102d41:	05 10 3a 10 00       	add    $0x103a10,%eax
  102d46:	0f b6 00             	movzbl (%eax),%eax
  102d49:	0f be c0             	movsbl %al,%eax
  102d4c:	83 ec 08             	sub    $0x8,%esp
  102d4f:	ff 75 0c             	pushl  0xc(%ebp)
  102d52:	50                   	push   %eax
  102d53:	8b 45 08             	mov    0x8(%ebp),%eax
  102d56:	ff d0                	call   *%eax
  102d58:	83 c4 10             	add    $0x10,%esp
}
  102d5b:	90                   	nop
  102d5c:	c9                   	leave  
  102d5d:	c3                   	ret    

00102d5e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102d5e:	55                   	push   %ebp
  102d5f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102d61:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102d65:	7e 14                	jle    102d7b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102d67:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6a:	8b 00                	mov    (%eax),%eax
  102d6c:	8d 48 08             	lea    0x8(%eax),%ecx
  102d6f:	8b 55 08             	mov    0x8(%ebp),%edx
  102d72:	89 0a                	mov    %ecx,(%edx)
  102d74:	8b 50 04             	mov    0x4(%eax),%edx
  102d77:	8b 00                	mov    (%eax),%eax
  102d79:	eb 30                	jmp    102dab <getuint+0x4d>
    }
    else if (lflag) {
  102d7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102d7f:	74 16                	je     102d97 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102d81:	8b 45 08             	mov    0x8(%ebp),%eax
  102d84:	8b 00                	mov    (%eax),%eax
  102d86:	8d 48 04             	lea    0x4(%eax),%ecx
  102d89:	8b 55 08             	mov    0x8(%ebp),%edx
  102d8c:	89 0a                	mov    %ecx,(%edx)
  102d8e:	8b 00                	mov    (%eax),%eax
  102d90:	ba 00 00 00 00       	mov    $0x0,%edx
  102d95:	eb 14                	jmp    102dab <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102d97:	8b 45 08             	mov    0x8(%ebp),%eax
  102d9a:	8b 00                	mov    (%eax),%eax
  102d9c:	8d 48 04             	lea    0x4(%eax),%ecx
  102d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  102da2:	89 0a                	mov    %ecx,(%edx)
  102da4:	8b 00                	mov    (%eax),%eax
  102da6:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102dab:	5d                   	pop    %ebp
  102dac:	c3                   	ret    

00102dad <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102dad:	55                   	push   %ebp
  102dae:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102db0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102db4:	7e 14                	jle    102dca <getint+0x1d>
        return va_arg(*ap, long long);
  102db6:	8b 45 08             	mov    0x8(%ebp),%eax
  102db9:	8b 00                	mov    (%eax),%eax
  102dbb:	8d 48 08             	lea    0x8(%eax),%ecx
  102dbe:	8b 55 08             	mov    0x8(%ebp),%edx
  102dc1:	89 0a                	mov    %ecx,(%edx)
  102dc3:	8b 50 04             	mov    0x4(%eax),%edx
  102dc6:	8b 00                	mov    (%eax),%eax
  102dc8:	eb 28                	jmp    102df2 <getint+0x45>
    }
    else if (lflag) {
  102dca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102dce:	74 12                	je     102de2 <getint+0x35>
        return va_arg(*ap, long);
  102dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd3:	8b 00                	mov    (%eax),%eax
  102dd5:	8d 48 04             	lea    0x4(%eax),%ecx
  102dd8:	8b 55 08             	mov    0x8(%ebp),%edx
  102ddb:	89 0a                	mov    %ecx,(%edx)
  102ddd:	8b 00                	mov    (%eax),%eax
  102ddf:	99                   	cltd   
  102de0:	eb 10                	jmp    102df2 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102de2:	8b 45 08             	mov    0x8(%ebp),%eax
  102de5:	8b 00                	mov    (%eax),%eax
  102de7:	8d 48 04             	lea    0x4(%eax),%ecx
  102dea:	8b 55 08             	mov    0x8(%ebp),%edx
  102ded:	89 0a                	mov    %ecx,(%edx)
  102def:	8b 00                	mov    (%eax),%eax
  102df1:	99                   	cltd   
    }
}
  102df2:	5d                   	pop    %ebp
  102df3:	c3                   	ret    

00102df4 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102df4:	55                   	push   %ebp
  102df5:	89 e5                	mov    %esp,%ebp
  102df7:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  102dfa:	8d 45 14             	lea    0x14(%ebp),%eax
  102dfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e03:	50                   	push   %eax
  102e04:	ff 75 10             	pushl  0x10(%ebp)
  102e07:	ff 75 0c             	pushl  0xc(%ebp)
  102e0a:	ff 75 08             	pushl  0x8(%ebp)
  102e0d:	e8 06 00 00 00       	call   102e18 <vprintfmt>
  102e12:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  102e15:	90                   	nop
  102e16:	c9                   	leave  
  102e17:	c3                   	ret    

00102e18 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102e18:	55                   	push   %ebp
  102e19:	89 e5                	mov    %esp,%ebp
  102e1b:	56                   	push   %esi
  102e1c:	53                   	push   %ebx
  102e1d:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102e20:	eb 17                	jmp    102e39 <vprintfmt+0x21>
            if (ch == '\0') {
  102e22:	85 db                	test   %ebx,%ebx
  102e24:	0f 84 8e 03 00 00    	je     1031b8 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  102e2a:	83 ec 08             	sub    $0x8,%esp
  102e2d:	ff 75 0c             	pushl  0xc(%ebp)
  102e30:	53                   	push   %ebx
  102e31:	8b 45 08             	mov    0x8(%ebp),%eax
  102e34:	ff d0                	call   *%eax
  102e36:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102e39:	8b 45 10             	mov    0x10(%ebp),%eax
  102e3c:	8d 50 01             	lea    0x1(%eax),%edx
  102e3f:	89 55 10             	mov    %edx,0x10(%ebp)
  102e42:	0f b6 00             	movzbl (%eax),%eax
  102e45:	0f b6 d8             	movzbl %al,%ebx
  102e48:	83 fb 25             	cmp    $0x25,%ebx
  102e4b:	75 d5                	jne    102e22 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102e4d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102e51:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102e5e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e68:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  102e6e:	8d 50 01             	lea    0x1(%eax),%edx
  102e71:	89 55 10             	mov    %edx,0x10(%ebp)
  102e74:	0f b6 00             	movzbl (%eax),%eax
  102e77:	0f b6 d8             	movzbl %al,%ebx
  102e7a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102e7d:	83 f8 55             	cmp    $0x55,%eax
  102e80:	0f 87 05 03 00 00    	ja     10318b <vprintfmt+0x373>
  102e86:	8b 04 85 34 3a 10 00 	mov    0x103a34(,%eax,4),%eax
  102e8d:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102e8f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102e93:	eb d6                	jmp    102e6b <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102e95:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102e99:	eb d0                	jmp    102e6b <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102e9b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102ea2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ea5:	89 d0                	mov    %edx,%eax
  102ea7:	c1 e0 02             	shl    $0x2,%eax
  102eaa:	01 d0                	add    %edx,%eax
  102eac:	01 c0                	add    %eax,%eax
  102eae:	01 d8                	add    %ebx,%eax
  102eb0:	83 e8 30             	sub    $0x30,%eax
  102eb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102eb6:	8b 45 10             	mov    0x10(%ebp),%eax
  102eb9:	0f b6 00             	movzbl (%eax),%eax
  102ebc:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102ebf:	83 fb 2f             	cmp    $0x2f,%ebx
  102ec2:	7e 39                	jle    102efd <vprintfmt+0xe5>
  102ec4:	83 fb 39             	cmp    $0x39,%ebx
  102ec7:	7f 34                	jg     102efd <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102ec9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102ecd:	eb d3                	jmp    102ea2 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102ecf:	8b 45 14             	mov    0x14(%ebp),%eax
  102ed2:	8d 50 04             	lea    0x4(%eax),%edx
  102ed5:	89 55 14             	mov    %edx,0x14(%ebp)
  102ed8:	8b 00                	mov    (%eax),%eax
  102eda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102edd:	eb 1f                	jmp    102efe <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  102edf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ee3:	79 86                	jns    102e6b <vprintfmt+0x53>
                width = 0;
  102ee5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102eec:	e9 7a ff ff ff       	jmp    102e6b <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102ef1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102ef8:	e9 6e ff ff ff       	jmp    102e6b <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  102efd:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  102efe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f02:	0f 89 63 ff ff ff    	jns    102e6b <vprintfmt+0x53>
                width = precision, precision = -1;
  102f08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102f0b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f0e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102f15:	e9 51 ff ff ff       	jmp    102e6b <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102f1a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102f1e:	e9 48 ff ff ff       	jmp    102e6b <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102f23:	8b 45 14             	mov    0x14(%ebp),%eax
  102f26:	8d 50 04             	lea    0x4(%eax),%edx
  102f29:	89 55 14             	mov    %edx,0x14(%ebp)
  102f2c:	8b 00                	mov    (%eax),%eax
  102f2e:	83 ec 08             	sub    $0x8,%esp
  102f31:	ff 75 0c             	pushl  0xc(%ebp)
  102f34:	50                   	push   %eax
  102f35:	8b 45 08             	mov    0x8(%ebp),%eax
  102f38:	ff d0                	call   *%eax
  102f3a:	83 c4 10             	add    $0x10,%esp
            break;
  102f3d:	e9 71 02 00 00       	jmp    1031b3 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102f42:	8b 45 14             	mov    0x14(%ebp),%eax
  102f45:	8d 50 04             	lea    0x4(%eax),%edx
  102f48:	89 55 14             	mov    %edx,0x14(%ebp)
  102f4b:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102f4d:	85 db                	test   %ebx,%ebx
  102f4f:	79 02                	jns    102f53 <vprintfmt+0x13b>
                err = -err;
  102f51:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102f53:	83 fb 06             	cmp    $0x6,%ebx
  102f56:	7f 0b                	jg     102f63 <vprintfmt+0x14b>
  102f58:	8b 34 9d f4 39 10 00 	mov    0x1039f4(,%ebx,4),%esi
  102f5f:	85 f6                	test   %esi,%esi
  102f61:	75 19                	jne    102f7c <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  102f63:	53                   	push   %ebx
  102f64:	68 21 3a 10 00       	push   $0x103a21
  102f69:	ff 75 0c             	pushl  0xc(%ebp)
  102f6c:	ff 75 08             	pushl  0x8(%ebp)
  102f6f:	e8 80 fe ff ff       	call   102df4 <printfmt>
  102f74:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102f77:	e9 37 02 00 00       	jmp    1031b3 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102f7c:	56                   	push   %esi
  102f7d:	68 2a 3a 10 00       	push   $0x103a2a
  102f82:	ff 75 0c             	pushl  0xc(%ebp)
  102f85:	ff 75 08             	pushl  0x8(%ebp)
  102f88:	e8 67 fe ff ff       	call   102df4 <printfmt>
  102f8d:	83 c4 10             	add    $0x10,%esp
            }
            break;
  102f90:	e9 1e 02 00 00       	jmp    1031b3 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102f95:	8b 45 14             	mov    0x14(%ebp),%eax
  102f98:	8d 50 04             	lea    0x4(%eax),%edx
  102f9b:	89 55 14             	mov    %edx,0x14(%ebp)
  102f9e:	8b 30                	mov    (%eax),%esi
  102fa0:	85 f6                	test   %esi,%esi
  102fa2:	75 05                	jne    102fa9 <vprintfmt+0x191>
                p = "(null)";
  102fa4:	be 2d 3a 10 00       	mov    $0x103a2d,%esi
            }
            if (width > 0 && padc != '-') {
  102fa9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102fad:	7e 76                	jle    103025 <vprintfmt+0x20d>
  102faf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102fb3:	74 70                	je     103025 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102fb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102fb8:	83 ec 08             	sub    $0x8,%esp
  102fbb:	50                   	push   %eax
  102fbc:	56                   	push   %esi
  102fbd:	e8 17 f8 ff ff       	call   1027d9 <strnlen>
  102fc2:	83 c4 10             	add    $0x10,%esp
  102fc5:	89 c2                	mov    %eax,%edx
  102fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fca:	29 d0                	sub    %edx,%eax
  102fcc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102fcf:	eb 17                	jmp    102fe8 <vprintfmt+0x1d0>
                    putch(padc, putdat);
  102fd1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102fd5:	83 ec 08             	sub    $0x8,%esp
  102fd8:	ff 75 0c             	pushl  0xc(%ebp)
  102fdb:	50                   	push   %eax
  102fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  102fdf:	ff d0                	call   *%eax
  102fe1:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102fe4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102fe8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102fec:	7f e3                	jg     102fd1 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102fee:	eb 35                	jmp    103025 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  102ff0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102ff4:	74 1c                	je     103012 <vprintfmt+0x1fa>
  102ff6:	83 fb 1f             	cmp    $0x1f,%ebx
  102ff9:	7e 05                	jle    103000 <vprintfmt+0x1e8>
  102ffb:	83 fb 7e             	cmp    $0x7e,%ebx
  102ffe:	7e 12                	jle    103012 <vprintfmt+0x1fa>
                    putch('?', putdat);
  103000:	83 ec 08             	sub    $0x8,%esp
  103003:	ff 75 0c             	pushl  0xc(%ebp)
  103006:	6a 3f                	push   $0x3f
  103008:	8b 45 08             	mov    0x8(%ebp),%eax
  10300b:	ff d0                	call   *%eax
  10300d:	83 c4 10             	add    $0x10,%esp
  103010:	eb 0f                	jmp    103021 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  103012:	83 ec 08             	sub    $0x8,%esp
  103015:	ff 75 0c             	pushl  0xc(%ebp)
  103018:	53                   	push   %ebx
  103019:	8b 45 08             	mov    0x8(%ebp),%eax
  10301c:	ff d0                	call   *%eax
  10301e:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103021:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103025:	89 f0                	mov    %esi,%eax
  103027:	8d 70 01             	lea    0x1(%eax),%esi
  10302a:	0f b6 00             	movzbl (%eax),%eax
  10302d:	0f be d8             	movsbl %al,%ebx
  103030:	85 db                	test   %ebx,%ebx
  103032:	74 26                	je     10305a <vprintfmt+0x242>
  103034:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103038:	78 b6                	js     102ff0 <vprintfmt+0x1d8>
  10303a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10303e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103042:	79 ac                	jns    102ff0 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  103044:	eb 14                	jmp    10305a <vprintfmt+0x242>
                putch(' ', putdat);
  103046:	83 ec 08             	sub    $0x8,%esp
  103049:	ff 75 0c             	pushl  0xc(%ebp)
  10304c:	6a 20                	push   $0x20
  10304e:	8b 45 08             	mov    0x8(%ebp),%eax
  103051:	ff d0                	call   *%eax
  103053:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  103056:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10305a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10305e:	7f e6                	jg     103046 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  103060:	e9 4e 01 00 00       	jmp    1031b3 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103065:	83 ec 08             	sub    $0x8,%esp
  103068:	ff 75 e0             	pushl  -0x20(%ebp)
  10306b:	8d 45 14             	lea    0x14(%ebp),%eax
  10306e:	50                   	push   %eax
  10306f:	e8 39 fd ff ff       	call   102dad <getint>
  103074:	83 c4 10             	add    $0x10,%esp
  103077:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10307a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10307d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103080:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103083:	85 d2                	test   %edx,%edx
  103085:	79 23                	jns    1030aa <vprintfmt+0x292>
                putch('-', putdat);
  103087:	83 ec 08             	sub    $0x8,%esp
  10308a:	ff 75 0c             	pushl  0xc(%ebp)
  10308d:	6a 2d                	push   $0x2d
  10308f:	8b 45 08             	mov    0x8(%ebp),%eax
  103092:	ff d0                	call   *%eax
  103094:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  103097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10309a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10309d:	f7 d8                	neg    %eax
  10309f:	83 d2 00             	adc    $0x0,%edx
  1030a2:	f7 da                	neg    %edx
  1030a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1030aa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1030b1:	e9 9f 00 00 00       	jmp    103155 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1030b6:	83 ec 08             	sub    $0x8,%esp
  1030b9:	ff 75 e0             	pushl  -0x20(%ebp)
  1030bc:	8d 45 14             	lea    0x14(%ebp),%eax
  1030bf:	50                   	push   %eax
  1030c0:	e8 99 fc ff ff       	call   102d5e <getuint>
  1030c5:	83 c4 10             	add    $0x10,%esp
  1030c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1030ce:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1030d5:	eb 7e                	jmp    103155 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1030d7:	83 ec 08             	sub    $0x8,%esp
  1030da:	ff 75 e0             	pushl  -0x20(%ebp)
  1030dd:	8d 45 14             	lea    0x14(%ebp),%eax
  1030e0:	50                   	push   %eax
  1030e1:	e8 78 fc ff ff       	call   102d5e <getuint>
  1030e6:	83 c4 10             	add    $0x10,%esp
  1030e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1030ef:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1030f6:	eb 5d                	jmp    103155 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  1030f8:	83 ec 08             	sub    $0x8,%esp
  1030fb:	ff 75 0c             	pushl  0xc(%ebp)
  1030fe:	6a 30                	push   $0x30
  103100:	8b 45 08             	mov    0x8(%ebp),%eax
  103103:	ff d0                	call   *%eax
  103105:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  103108:	83 ec 08             	sub    $0x8,%esp
  10310b:	ff 75 0c             	pushl  0xc(%ebp)
  10310e:	6a 78                	push   $0x78
  103110:	8b 45 08             	mov    0x8(%ebp),%eax
  103113:	ff d0                	call   *%eax
  103115:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  103118:	8b 45 14             	mov    0x14(%ebp),%eax
  10311b:	8d 50 04             	lea    0x4(%eax),%edx
  10311e:	89 55 14             	mov    %edx,0x14(%ebp)
  103121:	8b 00                	mov    (%eax),%eax
  103123:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103126:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10312d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103134:	eb 1f                	jmp    103155 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103136:	83 ec 08             	sub    $0x8,%esp
  103139:	ff 75 e0             	pushl  -0x20(%ebp)
  10313c:	8d 45 14             	lea    0x14(%ebp),%eax
  10313f:	50                   	push   %eax
  103140:	e8 19 fc ff ff       	call   102d5e <getuint>
  103145:	83 c4 10             	add    $0x10,%esp
  103148:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10314b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10314e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103155:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10315c:	83 ec 04             	sub    $0x4,%esp
  10315f:	52                   	push   %edx
  103160:	ff 75 e8             	pushl  -0x18(%ebp)
  103163:	50                   	push   %eax
  103164:	ff 75 f4             	pushl  -0xc(%ebp)
  103167:	ff 75 f0             	pushl  -0x10(%ebp)
  10316a:	ff 75 0c             	pushl  0xc(%ebp)
  10316d:	ff 75 08             	pushl  0x8(%ebp)
  103170:	e8 f8 fa ff ff       	call   102c6d <printnum>
  103175:	83 c4 20             	add    $0x20,%esp
            break;
  103178:	eb 39                	jmp    1031b3 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10317a:	83 ec 08             	sub    $0x8,%esp
  10317d:	ff 75 0c             	pushl  0xc(%ebp)
  103180:	53                   	push   %ebx
  103181:	8b 45 08             	mov    0x8(%ebp),%eax
  103184:	ff d0                	call   *%eax
  103186:	83 c4 10             	add    $0x10,%esp
            break;
  103189:	eb 28                	jmp    1031b3 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10318b:	83 ec 08             	sub    $0x8,%esp
  10318e:	ff 75 0c             	pushl  0xc(%ebp)
  103191:	6a 25                	push   $0x25
  103193:	8b 45 08             	mov    0x8(%ebp),%eax
  103196:	ff d0                	call   *%eax
  103198:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  10319b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10319f:	eb 04                	jmp    1031a5 <vprintfmt+0x38d>
  1031a1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1031a5:	8b 45 10             	mov    0x10(%ebp),%eax
  1031a8:	83 e8 01             	sub    $0x1,%eax
  1031ab:	0f b6 00             	movzbl (%eax),%eax
  1031ae:	3c 25                	cmp    $0x25,%al
  1031b0:	75 ef                	jne    1031a1 <vprintfmt+0x389>
                /* do nothing */;
            break;
  1031b2:	90                   	nop
        }
    }
  1031b3:	e9 68 fc ff ff       	jmp    102e20 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  1031b8:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1031b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1031bc:	5b                   	pop    %ebx
  1031bd:	5e                   	pop    %esi
  1031be:	5d                   	pop    %ebp
  1031bf:	c3                   	ret    

001031c0 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1031c0:	55                   	push   %ebp
  1031c1:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1031c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031c6:	8b 40 08             	mov    0x8(%eax),%eax
  1031c9:	8d 50 01             	lea    0x1(%eax),%edx
  1031cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031cf:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1031d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031d5:	8b 10                	mov    (%eax),%edx
  1031d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031da:	8b 40 04             	mov    0x4(%eax),%eax
  1031dd:	39 c2                	cmp    %eax,%edx
  1031df:	73 12                	jae    1031f3 <sprintputch+0x33>
        *b->buf ++ = ch;
  1031e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031e4:	8b 00                	mov    (%eax),%eax
  1031e6:	8d 48 01             	lea    0x1(%eax),%ecx
  1031e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1031ec:	89 0a                	mov    %ecx,(%edx)
  1031ee:	8b 55 08             	mov    0x8(%ebp),%edx
  1031f1:	88 10                	mov    %dl,(%eax)
    }
}
  1031f3:	90                   	nop
  1031f4:	5d                   	pop    %ebp
  1031f5:	c3                   	ret    

001031f6 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1031f6:	55                   	push   %ebp
  1031f7:	89 e5                	mov    %esp,%ebp
  1031f9:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1031fc:	8d 45 14             	lea    0x14(%ebp),%eax
  1031ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103205:	50                   	push   %eax
  103206:	ff 75 10             	pushl  0x10(%ebp)
  103209:	ff 75 0c             	pushl  0xc(%ebp)
  10320c:	ff 75 08             	pushl  0x8(%ebp)
  10320f:	e8 0b 00 00 00       	call   10321f <vsnprintf>
  103214:	83 c4 10             	add    $0x10,%esp
  103217:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10321a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10321d:	c9                   	leave  
  10321e:	c3                   	ret    

0010321f <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10321f:	55                   	push   %ebp
  103220:	89 e5                	mov    %esp,%ebp
  103222:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103225:	8b 45 08             	mov    0x8(%ebp),%eax
  103228:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10322b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10322e:	8d 50 ff             	lea    -0x1(%eax),%edx
  103231:	8b 45 08             	mov    0x8(%ebp),%eax
  103234:	01 d0                	add    %edx,%eax
  103236:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103239:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103240:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103244:	74 0a                	je     103250 <vsnprintf+0x31>
  103246:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10324c:	39 c2                	cmp    %eax,%edx
  10324e:	76 07                	jbe    103257 <vsnprintf+0x38>
        return -E_INVAL;
  103250:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103255:	eb 20                	jmp    103277 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103257:	ff 75 14             	pushl  0x14(%ebp)
  10325a:	ff 75 10             	pushl  0x10(%ebp)
  10325d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103260:	50                   	push   %eax
  103261:	68 c0 31 10 00       	push   $0x1031c0
  103266:	e8 ad fb ff ff       	call   102e18 <vprintfmt>
  10326b:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  10326e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103271:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103274:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103277:	c9                   	leave  
  103278:	c3                   	ret    
