
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
  10001f:	e8 d1 2b 00 00       	call   102bf5 <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 24 15 00 00       	call   101550 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 a0 33 10 00 	movl   $0x1033a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 bc 33 10 00       	push   $0x1033bc
  10003e:	e8 fa 01 00 00       	call   10023d <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 7c 08 00 00       	call   1008c7 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 74 00 00 00       	call   1000c4 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 64 28 00 00       	call   1028b9 <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 39 16 00 00       	call   101693 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 9a 17 00 00       	call   1017f9 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 d1 0c 00 00       	call   100d35 <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 67 17 00 00       	call   1017d0 <intr_enable>
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
  10007a:	e8 a4 0c 00 00       	call   100d23 <mon_backtrace>
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
  10010d:	68 c1 33 10 00       	push   $0x1033c1
  100112:	e8 26 01 00 00       	call   10023d <cprintf>
  100117:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011e:	0f b7 d0             	movzwl %ax,%edx
  100121:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100126:	83 ec 04             	sub    $0x4,%esp
  100129:	52                   	push   %edx
  10012a:	50                   	push   %eax
  10012b:	68 cf 33 10 00       	push   $0x1033cf
  100130:	e8 08 01 00 00       	call   10023d <cprintf>
  100135:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100138:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10013c:	0f b7 d0             	movzwl %ax,%edx
  10013f:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100144:	83 ec 04             	sub    $0x4,%esp
  100147:	52                   	push   %edx
  100148:	50                   	push   %eax
  100149:	68 dd 33 10 00       	push   $0x1033dd
  10014e:	e8 ea 00 00 00       	call   10023d <cprintf>
  100153:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100156:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015a:	0f b7 d0             	movzwl %ax,%edx
  10015d:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100162:	83 ec 04             	sub    $0x4,%esp
  100165:	52                   	push   %edx
  100166:	50                   	push   %eax
  100167:	68 eb 33 10 00       	push   $0x1033eb
  10016c:	e8 cc 00 00 00       	call   10023d <cprintf>
  100171:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100174:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100178:	0f b7 d0             	movzwl %ax,%edx
  10017b:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100180:	83 ec 04             	sub    $0x4,%esp
  100183:	52                   	push   %edx
  100184:	50                   	push   %eax
  100185:	68 f9 33 10 00       	push   $0x1033f9
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
  1001bc:	68 08 34 10 00       	push   $0x103408
  1001c1:	e8 77 00 00 00       	call   10023d <cprintf>
  1001c6:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001c9:	e8 d4 ff ff ff       	call   1001a2 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ce:	e8 12 ff ff ff       	call   1000e5 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001d3:	83 ec 0c             	sub    $0xc,%esp
  1001d6:	68 28 34 10 00       	push   $0x103428
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
  1001fc:	e8 80 13 00 00       	call   101581 <cons_putc>
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
  100230:	e8 f6 2c 00 00       	call   102f2b <vprintfmt>
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
  10026f:	e8 0d 13 00 00       	call   101581 <cons_putc>
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
  1002ce:	e8 de 12 00 00       	call   1015b1 <cons_getc>
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
  1002f3:	68 47 34 10 00       	push   $0x103447
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
  1003cb:	68 4a 34 10 00       	push   $0x10344a
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
  1003ed:	68 66 34 10 00       	push   $0x103466
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
  1003fd:	e8 d5 13 00 00       	call   1017d7 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100402:	83 ec 0c             	sub    $0xc,%esp
  100405:	6a 00                	push   $0x0
  100407:	e8 3d 08 00 00       	call   100c49 <kmonitor>
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
  100426:	68 68 34 10 00       	push   $0x103468
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
  100448:	68 66 34 10 00       	push   $0x103466
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
  1005c2:	c7 00 88 34 10 00    	movl   $0x103488,(%eax)
    info->eip_line = 0;
  1005c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d5:	c7 40 08 88 34 10 00 	movl   $0x103488,0x8(%eax)
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
  1005f9:	c7 45 f4 ac 3c 10 00 	movl   $0x103cac,-0xc(%ebp)
    stab_end = __STAB_END__;
  100600:	c7 45 f0 44 b6 10 00 	movl   $0x10b644,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100607:	c7 45 ec 45 b6 10 00 	movl   $0x10b645,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10060e:	c7 45 e8 ad d6 10 00 	movl   $0x10d6ad,-0x18(%ebp)

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
  100748:	e8 1c 23 00 00       	call   102a69 <strfind>
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
  1008d0:	68 92 34 10 00       	push   $0x103492
  1008d5:	e8 63 f9 ff ff       	call   10023d <cprintf>
  1008da:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008dd:	83 ec 08             	sub    $0x8,%esp
  1008e0:	68 00 00 10 00       	push   $0x100000
  1008e5:	68 ab 34 10 00       	push   $0x1034ab
  1008ea:	e8 4e f9 ff ff       	call   10023d <cprintf>
  1008ef:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008f2:	83 ec 08             	sub    $0x8,%esp
  1008f5:	68 8c 33 10 00       	push   $0x10338c
  1008fa:	68 c3 34 10 00       	push   $0x1034c3
  1008ff:	e8 39 f9 ff ff       	call   10023d <cprintf>
  100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100907:	83 ec 08             	sub    $0x8,%esp
  10090a:	68 16 ea 10 00       	push   $0x10ea16
  10090f:	68 db 34 10 00       	push   $0x1034db
  100914:	e8 24 f9 ff ff       	call   10023d <cprintf>
  100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10091c:	83 ec 08             	sub    $0x8,%esp
  10091f:	68 20 fd 10 00       	push   $0x10fd20
  100924:	68 f3 34 10 00       	push   $0x1034f3
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
  100954:	68 0c 35 10 00       	push   $0x10350c
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
  100989:	68 36 35 10 00       	push   $0x103536
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
  1009f0:	68 52 35 10 00       	push   $0x103552
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
  100a32:	e9 93 00 00 00       	jmp    100aca <print_stackframe+0xb9>
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);
  100a37:	83 ec 04             	sub    $0x4,%esp
  100a3a:	ff 75 f0             	pushl  -0x10(%ebp)
  100a3d:	ff 75 f4             	pushl  -0xc(%ebp)
  100a40:	68 64 35 10 00       	push   $0x103564
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
  100a8e:	68 7c 35 10 00       	push   $0x10357c
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
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));
  100ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100abb:	8b 00                	mov    (%eax),%eax
  100abd:	89 45 f4             	mov    %eax,-0xc(%ebp)

        // ebp should be valid
        if (stack_val_ebp <= 0) {
  100ac0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ac4:	74 10                	je     100ad6 <print_stackframe+0xc5>
    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
    
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  100ac6:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100aca:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100ace:	0f 8e 63 ff ff ff    	jle    100a37 <print_stackframe+0x26>
        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
        }
    }
}
  100ad4:	eb 01                	jmp    100ad7 <print_stackframe+0xc6>
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));

        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
  100ad6:	90                   	nop
        }
    }
}
  100ad7:	90                   	nop
  100ad8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100adb:	c9                   	leave  
  100adc:	c3                   	ret    

00100add <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100add:	55                   	push   %ebp
  100ade:	89 e5                	mov    %esp,%ebp
  100ae0:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100ae3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aea:	eb 0c                	jmp    100af8 <parse+0x1b>
            *buf ++ = '\0';
  100aec:	8b 45 08             	mov    0x8(%ebp),%eax
  100aef:	8d 50 01             	lea    0x1(%eax),%edx
  100af2:	89 55 08             	mov    %edx,0x8(%ebp)
  100af5:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100af8:	8b 45 08             	mov    0x8(%ebp),%eax
  100afb:	0f b6 00             	movzbl (%eax),%eax
  100afe:	84 c0                	test   %al,%al
  100b00:	74 1e                	je     100b20 <parse+0x43>
  100b02:	8b 45 08             	mov    0x8(%ebp),%eax
  100b05:	0f b6 00             	movzbl (%eax),%eax
  100b08:	0f be c0             	movsbl %al,%eax
  100b0b:	83 ec 08             	sub    $0x8,%esp
  100b0e:	50                   	push   %eax
  100b0f:	68 20 36 10 00       	push   $0x103620
  100b14:	e8 1d 1f 00 00       	call   102a36 <strchr>
  100b19:	83 c4 10             	add    $0x10,%esp
  100b1c:	85 c0                	test   %eax,%eax
  100b1e:	75 cc                	jne    100aec <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b20:	8b 45 08             	mov    0x8(%ebp),%eax
  100b23:	0f b6 00             	movzbl (%eax),%eax
  100b26:	84 c0                	test   %al,%al
  100b28:	74 69                	je     100b93 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b2a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b2e:	75 12                	jne    100b42 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b30:	83 ec 08             	sub    $0x8,%esp
  100b33:	6a 10                	push   $0x10
  100b35:	68 25 36 10 00       	push   $0x103625
  100b3a:	e8 fe f6 ff ff       	call   10023d <cprintf>
  100b3f:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b45:	8d 50 01             	lea    0x1(%eax),%edx
  100b48:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b4b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b55:	01 c2                	add    %eax,%edx
  100b57:	8b 45 08             	mov    0x8(%ebp),%eax
  100b5a:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b5c:	eb 04                	jmp    100b62 <parse+0x85>
            buf ++;
  100b5e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b62:	8b 45 08             	mov    0x8(%ebp),%eax
  100b65:	0f b6 00             	movzbl (%eax),%eax
  100b68:	84 c0                	test   %al,%al
  100b6a:	0f 84 7a ff ff ff    	je     100aea <parse+0xd>
  100b70:	8b 45 08             	mov    0x8(%ebp),%eax
  100b73:	0f b6 00             	movzbl (%eax),%eax
  100b76:	0f be c0             	movsbl %al,%eax
  100b79:	83 ec 08             	sub    $0x8,%esp
  100b7c:	50                   	push   %eax
  100b7d:	68 20 36 10 00       	push   $0x103620
  100b82:	e8 af 1e 00 00       	call   102a36 <strchr>
  100b87:	83 c4 10             	add    $0x10,%esp
  100b8a:	85 c0                	test   %eax,%eax
  100b8c:	74 d0                	je     100b5e <parse+0x81>
            buf ++;
        }
    }
  100b8e:	e9 57 ff ff ff       	jmp    100aea <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100b93:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b97:	c9                   	leave  
  100b98:	c3                   	ret    

00100b99 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b99:	55                   	push   %ebp
  100b9a:	89 e5                	mov    %esp,%ebp
  100b9c:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b9f:	83 ec 08             	sub    $0x8,%esp
  100ba2:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100ba5:	50                   	push   %eax
  100ba6:	ff 75 08             	pushl  0x8(%ebp)
  100ba9:	e8 2f ff ff ff       	call   100add <parse>
  100bae:	83 c4 10             	add    $0x10,%esp
  100bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bb8:	75 0a                	jne    100bc4 <runcmd+0x2b>
        return 0;
  100bba:	b8 00 00 00 00       	mov    $0x0,%eax
  100bbf:	e9 83 00 00 00       	jmp    100c47 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bcb:	eb 59                	jmp    100c26 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bcd:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bd3:	89 d0                	mov    %edx,%eax
  100bd5:	01 c0                	add    %eax,%eax
  100bd7:	01 d0                	add    %edx,%eax
  100bd9:	c1 e0 02             	shl    $0x2,%eax
  100bdc:	05 00 e0 10 00       	add    $0x10e000,%eax
  100be1:	8b 00                	mov    (%eax),%eax
  100be3:	83 ec 08             	sub    $0x8,%esp
  100be6:	51                   	push   %ecx
  100be7:	50                   	push   %eax
  100be8:	e8 a9 1d 00 00       	call   102996 <strcmp>
  100bed:	83 c4 10             	add    $0x10,%esp
  100bf0:	85 c0                	test   %eax,%eax
  100bf2:	75 2e                	jne    100c22 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100bf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bf7:	89 d0                	mov    %edx,%eax
  100bf9:	01 c0                	add    %eax,%eax
  100bfb:	01 d0                	add    %edx,%eax
  100bfd:	c1 e0 02             	shl    $0x2,%eax
  100c00:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c05:	8b 10                	mov    (%eax),%edx
  100c07:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c0a:	83 c0 04             	add    $0x4,%eax
  100c0d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c10:	83 e9 01             	sub    $0x1,%ecx
  100c13:	83 ec 04             	sub    $0x4,%esp
  100c16:	ff 75 0c             	pushl  0xc(%ebp)
  100c19:	50                   	push   %eax
  100c1a:	51                   	push   %ecx
  100c1b:	ff d2                	call   *%edx
  100c1d:	83 c4 10             	add    $0x10,%esp
  100c20:	eb 25                	jmp    100c47 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c29:	83 f8 02             	cmp    $0x2,%eax
  100c2c:	76 9f                	jbe    100bcd <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c2e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c31:	83 ec 08             	sub    $0x8,%esp
  100c34:	50                   	push   %eax
  100c35:	68 43 36 10 00       	push   $0x103643
  100c3a:	e8 fe f5 ff ff       	call   10023d <cprintf>
  100c3f:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c47:	c9                   	leave  
  100c48:	c3                   	ret    

00100c49 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c49:	55                   	push   %ebp
  100c4a:	89 e5                	mov    %esp,%ebp
  100c4c:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c4f:	83 ec 0c             	sub    $0xc,%esp
  100c52:	68 5c 36 10 00       	push   $0x10365c
  100c57:	e8 e1 f5 ff ff       	call   10023d <cprintf>
  100c5c:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c5f:	83 ec 0c             	sub    $0xc,%esp
  100c62:	68 84 36 10 00       	push   $0x103684
  100c67:	e8 d1 f5 ff ff       	call   10023d <cprintf>
  100c6c:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c73:	74 0e                	je     100c83 <kmonitor+0x3a>
        print_trapframe(tf);
  100c75:	83 ec 0c             	sub    $0xc,%esp
  100c78:	ff 75 08             	pushl  0x8(%ebp)
  100c7b:	e8 b2 0c 00 00       	call   101932 <print_trapframe>
  100c80:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c83:	83 ec 0c             	sub    $0xc,%esp
  100c86:	68 a9 36 10 00       	push   $0x1036a9
  100c8b:	e8 51 f6 ff ff       	call   1002e1 <readline>
  100c90:	83 c4 10             	add    $0x10,%esp
  100c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c9a:	74 e7                	je     100c83 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100c9c:	83 ec 08             	sub    $0x8,%esp
  100c9f:	ff 75 08             	pushl  0x8(%ebp)
  100ca2:	ff 75 f4             	pushl  -0xc(%ebp)
  100ca5:	e8 ef fe ff ff       	call   100b99 <runcmd>
  100caa:	83 c4 10             	add    $0x10,%esp
  100cad:	85 c0                	test   %eax,%eax
  100caf:	78 02                	js     100cb3 <kmonitor+0x6a>
                break;
            }
        }
    }
  100cb1:	eb d0                	jmp    100c83 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100cb3:	90                   	nop
            }
        }
    }
}
  100cb4:	90                   	nop
  100cb5:	c9                   	leave  
  100cb6:	c3                   	ret    

00100cb7 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cb7:	55                   	push   %ebp
  100cb8:	89 e5                	mov    %esp,%ebp
  100cba:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cc4:	eb 3c                	jmp    100d02 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cc9:	89 d0                	mov    %edx,%eax
  100ccb:	01 c0                	add    %eax,%eax
  100ccd:	01 d0                	add    %edx,%eax
  100ccf:	c1 e0 02             	shl    $0x2,%eax
  100cd2:	05 04 e0 10 00       	add    $0x10e004,%eax
  100cd7:	8b 08                	mov    (%eax),%ecx
  100cd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cdc:	89 d0                	mov    %edx,%eax
  100cde:	01 c0                	add    %eax,%eax
  100ce0:	01 d0                	add    %edx,%eax
  100ce2:	c1 e0 02             	shl    $0x2,%eax
  100ce5:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cea:	8b 00                	mov    (%eax),%eax
  100cec:	83 ec 04             	sub    $0x4,%esp
  100cef:	51                   	push   %ecx
  100cf0:	50                   	push   %eax
  100cf1:	68 ad 36 10 00       	push   $0x1036ad
  100cf6:	e8 42 f5 ff ff       	call   10023d <cprintf>
  100cfb:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cfe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d05:	83 f8 02             	cmp    $0x2,%eax
  100d08:	76 bc                	jbe    100cc6 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d0f:	c9                   	leave  
  100d10:	c3                   	ret    

00100d11 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d11:	55                   	push   %ebp
  100d12:	89 e5                	mov    %esp,%ebp
  100d14:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d17:	e8 ab fb ff ff       	call   1008c7 <print_kerninfo>
    return 0;
  100d1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d21:	c9                   	leave  
  100d22:	c3                   	ret    

00100d23 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d23:	55                   	push   %ebp
  100d24:	89 e5                	mov    %esp,%ebp
  100d26:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d29:	e8 e3 fc ff ff       	call   100a11 <print_stackframe>
    return 0;
  100d2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d33:	c9                   	leave  
  100d34:	c3                   	ret    

00100d35 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d35:	55                   	push   %ebp
  100d36:	89 e5                	mov    %esp,%ebp
  100d38:	83 ec 18             	sub    $0x18,%esp
  100d3b:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d41:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d45:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d49:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d4d:	ee                   	out    %al,(%dx)
  100d4e:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d54:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d58:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d5c:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d60:	ee                   	out    %al,(%dx)
  100d61:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d67:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d6b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d6f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d73:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d74:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d7b:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d7e:	83 ec 0c             	sub    $0xc,%esp
  100d81:	68 b6 36 10 00       	push   $0x1036b6
  100d86:	e8 b2 f4 ff ff       	call   10023d <cprintf>
  100d8b:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d8e:	83 ec 0c             	sub    $0xc,%esp
  100d91:	6a 00                	push   $0x0
  100d93:	e8 ce 08 00 00       	call   101666 <pic_enable>
  100d98:	83 c4 10             	add    $0x10,%esp
}
  100d9b:	90                   	nop
  100d9c:	c9                   	leave  
  100d9d:	c3                   	ret    

00100d9e <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d9e:	55                   	push   %ebp
  100d9f:	89 e5                	mov    %esp,%ebp
  100da1:	83 ec 10             	sub    $0x10,%esp
  100da4:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100daa:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dae:	89 c2                	mov    %eax,%edx
  100db0:	ec                   	in     (%dx),%al
  100db1:	88 45 f4             	mov    %al,-0xc(%ebp)
  100db4:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100dba:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100dbe:	89 c2                	mov    %eax,%edx
  100dc0:	ec                   	in     (%dx),%al
  100dc1:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dc4:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dca:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dce:	89 c2                	mov    %eax,%edx
  100dd0:	ec                   	in     (%dx),%al
  100dd1:	88 45 f6             	mov    %al,-0xa(%ebp)
  100dd4:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100dda:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100dde:	89 c2                	mov    %eax,%edx
  100de0:	ec                   	in     (%dx),%al
  100de1:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100de4:	90                   	nop
  100de5:	c9                   	leave  
  100de6:	c3                   	ret    

00100de7 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100de7:	55                   	push   %ebp
  100de8:	89 e5                	mov    %esp,%ebp
  100dea:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100ded:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100df7:	0f b7 00             	movzwl (%eax),%eax
  100dfa:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100dfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e01:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e09:	0f b7 00             	movzwl (%eax),%eax
  100e0c:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e10:	74 12                	je     100e24 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e12:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e19:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e20:	b4 03 
  100e22:	eb 13                	jmp    100e37 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e27:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e2b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e2e:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e35:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e37:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e3e:	0f b7 c0             	movzwl %ax,%eax
  100e41:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100e45:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e49:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100e4d:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100e51:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e52:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e59:	83 c0 01             	add    $0x1,%eax
  100e5c:	0f b7 c0             	movzwl %ax,%eax
  100e5f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e63:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e67:	89 c2                	mov    %eax,%edx
  100e69:	ec                   	in     (%dx),%al
  100e6a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100e6d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100e71:	0f b6 c0             	movzbl %al,%eax
  100e74:	c1 e0 08             	shl    $0x8,%eax
  100e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e7a:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e81:	0f b7 c0             	movzwl %ax,%eax
  100e84:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100e88:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e8c:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100e90:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100e94:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100e95:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e9c:	83 c0 01             	add    $0x1,%eax
  100e9f:	0f b7 c0             	movzwl %ax,%eax
  100ea2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ea6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eaa:	89 c2                	mov    %eax,%edx
  100eac:	ec                   	in     (%dx),%al
  100ead:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100eb0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eb4:	0f b6 c0             	movzbl %al,%eax
  100eb7:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100eba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ebd:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ec5:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ecb:	90                   	nop
  100ecc:	c9                   	leave  
  100ecd:	c3                   	ret    

00100ece <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ece:	55                   	push   %ebp
  100ecf:	89 e5                	mov    %esp,%ebp
  100ed1:	83 ec 28             	sub    $0x28,%esp
  100ed4:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100eda:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ede:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100ee2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ee6:	ee                   	out    %al,(%dx)
  100ee7:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100eed:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100ef1:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100ef5:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100ef9:	ee                   	out    %al,(%dx)
  100efa:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f00:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f04:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f08:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f0c:	ee                   	out    %al,(%dx)
  100f0d:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f13:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f17:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f1b:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f1f:	ee                   	out    %al,(%dx)
  100f20:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f26:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f2a:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f2e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f32:	ee                   	out    %al,(%dx)
  100f33:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f39:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f3d:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100f41:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100f45:	ee                   	out    %al,(%dx)
  100f46:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f4c:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100f50:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100f54:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f58:	ee                   	out    %al,(%dx)
  100f59:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f5f:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100f63:	89 c2                	mov    %eax,%edx
  100f65:	ec                   	in     (%dx),%al
  100f66:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100f69:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f6d:	3c ff                	cmp    $0xff,%al
  100f6f:	0f 95 c0             	setne  %al
  100f72:	0f b6 c0             	movzbl %al,%eax
  100f75:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f7a:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f80:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f84:	89 c2                	mov    %eax,%edx
  100f86:	ec                   	in     (%dx),%al
  100f87:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100f8a:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100f90:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100f94:	89 c2                	mov    %eax,%edx
  100f96:	ec                   	in     (%dx),%al
  100f97:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f9a:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100f9f:	85 c0                	test   %eax,%eax
  100fa1:	74 0d                	je     100fb0 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100fa3:	83 ec 0c             	sub    $0xc,%esp
  100fa6:	6a 04                	push   $0x4
  100fa8:	e8 b9 06 00 00       	call   101666 <pic_enable>
  100fad:	83 c4 10             	add    $0x10,%esp
    }
}
  100fb0:	90                   	nop
  100fb1:	c9                   	leave  
  100fb2:	c3                   	ret    

00100fb3 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fb3:	55                   	push   %ebp
  100fb4:	89 e5                	mov    %esp,%ebp
  100fb6:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fc0:	eb 09                	jmp    100fcb <lpt_putc_sub+0x18>
        delay();
  100fc2:	e8 d7 fd ff ff       	call   100d9e <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fcb:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100fd1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100fd5:	89 c2                	mov    %eax,%edx
  100fd7:	ec                   	in     (%dx),%al
  100fd8:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100fdb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100fdf:	84 c0                	test   %al,%al
  100fe1:	78 09                	js     100fec <lpt_putc_sub+0x39>
  100fe3:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fea:	7e d6                	jle    100fc2 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100fec:	8b 45 08             	mov    0x8(%ebp),%eax
  100fef:	0f b6 c0             	movzbl %al,%eax
  100ff2:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  100ff8:	88 45 f0             	mov    %al,-0x10(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ffb:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100fff:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  101003:	ee                   	out    %al,(%dx)
  101004:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10100a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10100e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101012:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101016:	ee                   	out    %al,(%dx)
  101017:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  10101d:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  101021:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  101025:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101029:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10102a:	90                   	nop
  10102b:	c9                   	leave  
  10102c:	c3                   	ret    

0010102d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10102d:	55                   	push   %ebp
  10102e:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101030:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101034:	74 0d                	je     101043 <lpt_putc+0x16>
        lpt_putc_sub(c);
  101036:	ff 75 08             	pushl  0x8(%ebp)
  101039:	e8 75 ff ff ff       	call   100fb3 <lpt_putc_sub>
  10103e:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101041:	eb 1e                	jmp    101061 <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  101043:	6a 08                	push   $0x8
  101045:	e8 69 ff ff ff       	call   100fb3 <lpt_putc_sub>
  10104a:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  10104d:	6a 20                	push   $0x20
  10104f:	e8 5f ff ff ff       	call   100fb3 <lpt_putc_sub>
  101054:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101057:	6a 08                	push   $0x8
  101059:	e8 55 ff ff ff       	call   100fb3 <lpt_putc_sub>
  10105e:	83 c4 04             	add    $0x4,%esp
    }
}
  101061:	90                   	nop
  101062:	c9                   	leave  
  101063:	c3                   	ret    

00101064 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101064:	55                   	push   %ebp
  101065:	89 e5                	mov    %esp,%ebp
  101067:	53                   	push   %ebx
  101068:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10106b:	8b 45 08             	mov    0x8(%ebp),%eax
  10106e:	b0 00                	mov    $0x0,%al
  101070:	85 c0                	test   %eax,%eax
  101072:	75 07                	jne    10107b <cga_putc+0x17>
        c |= 0x0700;
  101074:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10107b:	8b 45 08             	mov    0x8(%ebp),%eax
  10107e:	0f b6 c0             	movzbl %al,%eax
  101081:	83 f8 0a             	cmp    $0xa,%eax
  101084:	74 4e                	je     1010d4 <cga_putc+0x70>
  101086:	83 f8 0d             	cmp    $0xd,%eax
  101089:	74 59                	je     1010e4 <cga_putc+0x80>
  10108b:	83 f8 08             	cmp    $0x8,%eax
  10108e:	0f 85 8a 00 00 00    	jne    10111e <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  101094:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10109b:	66 85 c0             	test   %ax,%ax
  10109e:	0f 84 a0 00 00 00    	je     101144 <cga_putc+0xe0>
            crt_pos --;
  1010a4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010ab:	83 e8 01             	sub    $0x1,%eax
  1010ae:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010b4:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010b9:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010c0:	0f b7 d2             	movzwl %dx,%edx
  1010c3:	01 d2                	add    %edx,%edx
  1010c5:	01 d0                	add    %edx,%eax
  1010c7:	8b 55 08             	mov    0x8(%ebp),%edx
  1010ca:	b2 00                	mov    $0x0,%dl
  1010cc:	83 ca 20             	or     $0x20,%edx
  1010cf:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010d2:	eb 70                	jmp    101144 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  1010d4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010db:	83 c0 50             	add    $0x50,%eax
  1010de:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010e4:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010eb:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010f2:	0f b7 c1             	movzwl %cx,%eax
  1010f5:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1010fb:	c1 e8 10             	shr    $0x10,%eax
  1010fe:	89 c2                	mov    %eax,%edx
  101100:	66 c1 ea 06          	shr    $0x6,%dx
  101104:	89 d0                	mov    %edx,%eax
  101106:	c1 e0 02             	shl    $0x2,%eax
  101109:	01 d0                	add    %edx,%eax
  10110b:	c1 e0 04             	shl    $0x4,%eax
  10110e:	29 c1                	sub    %eax,%ecx
  101110:	89 ca                	mov    %ecx,%edx
  101112:	89 d8                	mov    %ebx,%eax
  101114:	29 d0                	sub    %edx,%eax
  101116:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10111c:	eb 27                	jmp    101145 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10111e:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101124:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10112b:	8d 50 01             	lea    0x1(%eax),%edx
  10112e:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101135:	0f b7 c0             	movzwl %ax,%eax
  101138:	01 c0                	add    %eax,%eax
  10113a:	01 c8                	add    %ecx,%eax
  10113c:	8b 55 08             	mov    0x8(%ebp),%edx
  10113f:	66 89 10             	mov    %dx,(%eax)
        break;
  101142:	eb 01                	jmp    101145 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  101144:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101145:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10114c:	66 3d cf 07          	cmp    $0x7cf,%ax
  101150:	76 59                	jbe    1011ab <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101152:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101157:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10115d:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101162:	83 ec 04             	sub    $0x4,%esp
  101165:	68 00 0f 00 00       	push   $0xf00
  10116a:	52                   	push   %edx
  10116b:	50                   	push   %eax
  10116c:	e8 c4 1a 00 00       	call   102c35 <memmove>
  101171:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101174:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10117b:	eb 15                	jmp    101192 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  10117d:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101182:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101185:	01 d2                	add    %edx,%edx
  101187:	01 d0                	add    %edx,%eax
  101189:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10118e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101192:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101199:	7e e2                	jle    10117d <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10119b:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011a2:	83 e8 50             	sub    $0x50,%eax
  1011a5:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011ab:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011b2:	0f b7 c0             	movzwl %ax,%eax
  1011b5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011b9:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  1011bd:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1011c1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011c5:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011c6:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011cd:	66 c1 e8 08          	shr    $0x8,%ax
  1011d1:	0f b6 c0             	movzbl %al,%eax
  1011d4:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011db:	83 c2 01             	add    $0x1,%edx
  1011de:	0f b7 d2             	movzwl %dx,%edx
  1011e1:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  1011e5:	88 45 e9             	mov    %al,-0x17(%ebp)
  1011e8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011ec:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1011f0:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011f1:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011f8:	0f b7 c0             	movzwl %ax,%eax
  1011fb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1011ff:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  101203:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101207:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10120b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10120c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101213:	0f b6 c0             	movzbl %al,%eax
  101216:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10121d:	83 c2 01             	add    $0x1,%edx
  101220:	0f b7 d2             	movzwl %dx,%edx
  101223:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101227:	88 45 eb             	mov    %al,-0x15(%ebp)
  10122a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10122e:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101232:	ee                   	out    %al,(%dx)
}
  101233:	90                   	nop
  101234:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101237:	c9                   	leave  
  101238:	c3                   	ret    

00101239 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101239:	55                   	push   %ebp
  10123a:	89 e5                	mov    %esp,%ebp
  10123c:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10123f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101246:	eb 09                	jmp    101251 <serial_putc_sub+0x18>
        delay();
  101248:	e8 51 fb ff ff       	call   100d9e <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10124d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101251:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101257:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  10125b:	89 c2                	mov    %eax,%edx
  10125d:	ec                   	in     (%dx),%al
  10125e:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  101261:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  101265:	0f b6 c0             	movzbl %al,%eax
  101268:	83 e0 20             	and    $0x20,%eax
  10126b:	85 c0                	test   %eax,%eax
  10126d:	75 09                	jne    101278 <serial_putc_sub+0x3f>
  10126f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101276:	7e d0                	jle    101248 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101278:	8b 45 08             	mov    0x8(%ebp),%eax
  10127b:	0f b6 c0             	movzbl %al,%eax
  10127e:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  101284:	88 45 f6             	mov    %al,-0xa(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101287:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  10128b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10128f:	ee                   	out    %al,(%dx)
}
  101290:	90                   	nop
  101291:	c9                   	leave  
  101292:	c3                   	ret    

00101293 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101293:	55                   	push   %ebp
  101294:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101296:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10129a:	74 0d                	je     1012a9 <serial_putc+0x16>
        serial_putc_sub(c);
  10129c:	ff 75 08             	pushl  0x8(%ebp)
  10129f:	e8 95 ff ff ff       	call   101239 <serial_putc_sub>
  1012a4:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012a7:	eb 1e                	jmp    1012c7 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  1012a9:	6a 08                	push   $0x8
  1012ab:	e8 89 ff ff ff       	call   101239 <serial_putc_sub>
  1012b0:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012b3:	6a 20                	push   $0x20
  1012b5:	e8 7f ff ff ff       	call   101239 <serial_putc_sub>
  1012ba:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012bd:	6a 08                	push   $0x8
  1012bf:	e8 75 ff ff ff       	call   101239 <serial_putc_sub>
  1012c4:	83 c4 04             	add    $0x4,%esp
    }
}
  1012c7:	90                   	nop
  1012c8:	c9                   	leave  
  1012c9:	c3                   	ret    

001012ca <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012ca:	55                   	push   %ebp
  1012cb:	89 e5                	mov    %esp,%ebp
  1012cd:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012d0:	eb 33                	jmp    101305 <cons_intr+0x3b>
        if (c != 0) {
  1012d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012d6:	74 2d                	je     101305 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012d8:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012dd:	8d 50 01             	lea    0x1(%eax),%edx
  1012e0:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1012e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012e9:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012ef:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012f4:	3d 00 02 00 00       	cmp    $0x200,%eax
  1012f9:	75 0a                	jne    101305 <cons_intr+0x3b>
                cons.wpos = 0;
  1012fb:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101302:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101305:	8b 45 08             	mov    0x8(%ebp),%eax
  101308:	ff d0                	call   *%eax
  10130a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10130d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101311:	75 bf                	jne    1012d2 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101313:	90                   	nop
  101314:	c9                   	leave  
  101315:	c3                   	ret    

00101316 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101316:	55                   	push   %ebp
  101317:	89 e5                	mov    %esp,%ebp
  101319:	83 ec 10             	sub    $0x10,%esp
  10131c:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101322:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101326:	89 c2                	mov    %eax,%edx
  101328:	ec                   	in     (%dx),%al
  101329:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10132c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101330:	0f b6 c0             	movzbl %al,%eax
  101333:	83 e0 01             	and    $0x1,%eax
  101336:	85 c0                	test   %eax,%eax
  101338:	75 07                	jne    101341 <serial_proc_data+0x2b>
        return -1;
  10133a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10133f:	eb 2a                	jmp    10136b <serial_proc_data+0x55>
  101341:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101347:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10134b:	89 c2                	mov    %eax,%edx
  10134d:	ec                   	in     (%dx),%al
  10134e:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  101351:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101355:	0f b6 c0             	movzbl %al,%eax
  101358:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10135b:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10135f:	75 07                	jne    101368 <serial_proc_data+0x52>
        c = '\b';
  101361:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101368:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10136b:	c9                   	leave  
  10136c:	c3                   	ret    

0010136d <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10136d:	55                   	push   %ebp
  10136e:	89 e5                	mov    %esp,%ebp
  101370:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  101373:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101378:	85 c0                	test   %eax,%eax
  10137a:	74 10                	je     10138c <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  10137c:	83 ec 0c             	sub    $0xc,%esp
  10137f:	68 16 13 10 00       	push   $0x101316
  101384:	e8 41 ff ff ff       	call   1012ca <cons_intr>
  101389:	83 c4 10             	add    $0x10,%esp
    }
}
  10138c:	90                   	nop
  10138d:	c9                   	leave  
  10138e:	c3                   	ret    

0010138f <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10138f:	55                   	push   %ebp
  101390:	89 e5                	mov    %esp,%ebp
  101392:	83 ec 18             	sub    $0x18,%esp
  101395:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10139b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10139f:	89 c2                	mov    %eax,%edx
  1013a1:	ec                   	in     (%dx),%al
  1013a2:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013a5:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013a9:	0f b6 c0             	movzbl %al,%eax
  1013ac:	83 e0 01             	and    $0x1,%eax
  1013af:	85 c0                	test   %eax,%eax
  1013b1:	75 0a                	jne    1013bd <kbd_proc_data+0x2e>
        return -1;
  1013b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013b8:	e9 5d 01 00 00       	jmp    10151a <kbd_proc_data+0x18b>
  1013bd:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013c3:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013c7:	89 c2                	mov    %eax,%edx
  1013c9:	ec                   	in     (%dx),%al
  1013ca:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  1013cd:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013d1:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013d4:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013d8:	75 17                	jne    1013f1 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013da:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013df:	83 c8 40             	or     $0x40,%eax
  1013e2:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013e7:	b8 00 00 00 00       	mov    $0x0,%eax
  1013ec:	e9 29 01 00 00       	jmp    10151a <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  1013f1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013f5:	84 c0                	test   %al,%al
  1013f7:	79 47                	jns    101440 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1013f9:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013fe:	83 e0 40             	and    $0x40,%eax
  101401:	85 c0                	test   %eax,%eax
  101403:	75 09                	jne    10140e <kbd_proc_data+0x7f>
  101405:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101409:	83 e0 7f             	and    $0x7f,%eax
  10140c:	eb 04                	jmp    101412 <kbd_proc_data+0x83>
  10140e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101412:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101415:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101419:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101420:	83 c8 40             	or     $0x40,%eax
  101423:	0f b6 c0             	movzbl %al,%eax
  101426:	f7 d0                	not    %eax
  101428:	89 c2                	mov    %eax,%edx
  10142a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10142f:	21 d0                	and    %edx,%eax
  101431:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101436:	b8 00 00 00 00       	mov    $0x0,%eax
  10143b:	e9 da 00 00 00       	jmp    10151a <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  101440:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101445:	83 e0 40             	and    $0x40,%eax
  101448:	85 c0                	test   %eax,%eax
  10144a:	74 11                	je     10145d <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10144c:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101450:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101455:	83 e0 bf             	and    $0xffffffbf,%eax
  101458:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10145d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101461:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101468:	0f b6 d0             	movzbl %al,%edx
  10146b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101470:	09 d0                	or     %edx,%eax
  101472:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101477:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147b:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  101482:	0f b6 d0             	movzbl %al,%edx
  101485:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148a:	31 d0                	xor    %edx,%eax
  10148c:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  101491:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101496:	83 e0 03             	and    $0x3,%eax
  101499:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a4:	01 d0                	add    %edx,%eax
  1014a6:	0f b6 00             	movzbl (%eax),%eax
  1014a9:	0f b6 c0             	movzbl %al,%eax
  1014ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014af:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b4:	83 e0 08             	and    $0x8,%eax
  1014b7:	85 c0                	test   %eax,%eax
  1014b9:	74 22                	je     1014dd <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014bb:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014bf:	7e 0c                	jle    1014cd <kbd_proc_data+0x13e>
  1014c1:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014c5:	7f 06                	jg     1014cd <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014c7:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014cb:	eb 10                	jmp    1014dd <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014cd:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014d1:	7e 0a                	jle    1014dd <kbd_proc_data+0x14e>
  1014d3:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014d7:	7f 04                	jg     1014dd <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014d9:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014dd:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014e2:	f7 d0                	not    %eax
  1014e4:	83 e0 06             	and    $0x6,%eax
  1014e7:	85 c0                	test   %eax,%eax
  1014e9:	75 2c                	jne    101517 <kbd_proc_data+0x188>
  1014eb:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014f2:	75 23                	jne    101517 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  1014f4:	83 ec 0c             	sub    $0xc,%esp
  1014f7:	68 d1 36 10 00       	push   $0x1036d1
  1014fc:	e8 3c ed ff ff       	call   10023d <cprintf>
  101501:	83 c4 10             	add    $0x10,%esp
  101504:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  10150a:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10150e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101512:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101516:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101517:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10151a:	c9                   	leave  
  10151b:	c3                   	ret    

0010151c <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10151c:	55                   	push   %ebp
  10151d:	89 e5                	mov    %esp,%ebp
  10151f:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  101522:	83 ec 0c             	sub    $0xc,%esp
  101525:	68 8f 13 10 00       	push   $0x10138f
  10152a:	e8 9b fd ff ff       	call   1012ca <cons_intr>
  10152f:	83 c4 10             	add    $0x10,%esp
}
  101532:	90                   	nop
  101533:	c9                   	leave  
  101534:	c3                   	ret    

00101535 <kbd_init>:

static void
kbd_init(void) {
  101535:	55                   	push   %ebp
  101536:	89 e5                	mov    %esp,%ebp
  101538:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  10153b:	e8 dc ff ff ff       	call   10151c <kbd_intr>
    pic_enable(IRQ_KBD);
  101540:	83 ec 0c             	sub    $0xc,%esp
  101543:	6a 01                	push   $0x1
  101545:	e8 1c 01 00 00       	call   101666 <pic_enable>
  10154a:	83 c4 10             	add    $0x10,%esp
}
  10154d:	90                   	nop
  10154e:	c9                   	leave  
  10154f:	c3                   	ret    

00101550 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101550:	55                   	push   %ebp
  101551:	89 e5                	mov    %esp,%ebp
  101553:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101556:	e8 8c f8 ff ff       	call   100de7 <cga_init>
    serial_init();
  10155b:	e8 6e f9 ff ff       	call   100ece <serial_init>
    kbd_init();
  101560:	e8 d0 ff ff ff       	call   101535 <kbd_init>
    if (!serial_exists) {
  101565:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10156a:	85 c0                	test   %eax,%eax
  10156c:	75 10                	jne    10157e <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10156e:	83 ec 0c             	sub    $0xc,%esp
  101571:	68 dd 36 10 00       	push   $0x1036dd
  101576:	e8 c2 ec ff ff       	call   10023d <cprintf>
  10157b:	83 c4 10             	add    $0x10,%esp
    }
}
  10157e:	90                   	nop
  10157f:	c9                   	leave  
  101580:	c3                   	ret    

00101581 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101581:	55                   	push   %ebp
  101582:	89 e5                	mov    %esp,%ebp
  101584:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  101587:	ff 75 08             	pushl  0x8(%ebp)
  10158a:	e8 9e fa ff ff       	call   10102d <lpt_putc>
  10158f:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  101592:	83 ec 0c             	sub    $0xc,%esp
  101595:	ff 75 08             	pushl  0x8(%ebp)
  101598:	e8 c7 fa ff ff       	call   101064 <cga_putc>
  10159d:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1015a0:	83 ec 0c             	sub    $0xc,%esp
  1015a3:	ff 75 08             	pushl  0x8(%ebp)
  1015a6:	e8 e8 fc ff ff       	call   101293 <serial_putc>
  1015ab:	83 c4 10             	add    $0x10,%esp
}
  1015ae:	90                   	nop
  1015af:	c9                   	leave  
  1015b0:	c3                   	ret    

001015b1 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015b1:	55                   	push   %ebp
  1015b2:	89 e5                	mov    %esp,%ebp
  1015b4:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015b7:	e8 b1 fd ff ff       	call   10136d <serial_intr>
    kbd_intr();
  1015bc:	e8 5b ff ff ff       	call   10151c <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015c1:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015c7:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015cc:	39 c2                	cmp    %eax,%edx
  1015ce:	74 36                	je     101606 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015d0:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015d5:	8d 50 01             	lea    0x1(%eax),%edx
  1015d8:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015de:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015e5:	0f b6 c0             	movzbl %al,%eax
  1015e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015eb:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f0:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015f5:	75 0a                	jne    101601 <cons_getc+0x50>
            cons.rpos = 0;
  1015f7:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  1015fe:	00 00 00 
        }
        return c;
  101601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101604:	eb 05                	jmp    10160b <cons_getc+0x5a>
    }
    return 0;
  101606:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10160b:	c9                   	leave  
  10160c:	c3                   	ret    

0010160d <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10160d:	55                   	push   %ebp
  10160e:	89 e5                	mov    %esp,%ebp
  101610:	83 ec 14             	sub    $0x14,%esp
  101613:	8b 45 08             	mov    0x8(%ebp),%eax
  101616:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10161a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10161e:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101624:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101629:	85 c0                	test   %eax,%eax
  10162b:	74 36                	je     101663 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10162d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101631:	0f b6 c0             	movzbl %al,%eax
  101634:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10163a:	88 45 fa             	mov    %al,-0x6(%ebp)
  10163d:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  101641:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101645:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101646:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10164a:	66 c1 e8 08          	shr    $0x8,%ax
  10164e:	0f b6 c0             	movzbl %al,%eax
  101651:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101657:	88 45 fb             	mov    %al,-0x5(%ebp)
  10165a:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  10165e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  101662:	ee                   	out    %al,(%dx)
    }
}
  101663:	90                   	nop
  101664:	c9                   	leave  
  101665:	c3                   	ret    

00101666 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101666:	55                   	push   %ebp
  101667:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101669:	8b 45 08             	mov    0x8(%ebp),%eax
  10166c:	ba 01 00 00 00       	mov    $0x1,%edx
  101671:	89 c1                	mov    %eax,%ecx
  101673:	d3 e2                	shl    %cl,%edx
  101675:	89 d0                	mov    %edx,%eax
  101677:	f7 d0                	not    %eax
  101679:	89 c2                	mov    %eax,%edx
  10167b:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101682:	21 d0                	and    %edx,%eax
  101684:	0f b7 c0             	movzwl %ax,%eax
  101687:	50                   	push   %eax
  101688:	e8 80 ff ff ff       	call   10160d <pic_setmask>
  10168d:	83 c4 04             	add    $0x4,%esp
}
  101690:	90                   	nop
  101691:	c9                   	leave  
  101692:	c3                   	ret    

00101693 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101693:	55                   	push   %ebp
  101694:	89 e5                	mov    %esp,%ebp
  101696:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  101699:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016a0:	00 00 00 
  1016a3:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016a9:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1016ad:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1016b1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016b5:	ee                   	out    %al,(%dx)
  1016b6:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016bc:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1016c0:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1016c4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016c8:	ee                   	out    %al,(%dx)
  1016c9:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1016cf:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  1016d3:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  1016d7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016db:	ee                   	out    %al,(%dx)
  1016dc:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  1016e2:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  1016e6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1016ea:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1016ee:	ee                   	out    %al,(%dx)
  1016ef:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  1016f5:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  1016f9:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  1016fd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101701:	ee                   	out    %al,(%dx)
  101702:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101708:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  10170c:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  101710:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  101714:	ee                   	out    %al,(%dx)
  101715:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  10171b:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  10171f:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  101723:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101727:	ee                   	out    %al,(%dx)
  101728:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  10172e:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  101732:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101736:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10173a:	ee                   	out    %al,(%dx)
  10173b:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101741:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  101745:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  101749:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10174d:	ee                   	out    %al,(%dx)
  10174e:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  101754:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  101758:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  10175c:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101760:	ee                   	out    %al,(%dx)
  101761:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  101767:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  10176b:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  10176f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101773:	ee                   	out    %al,(%dx)
  101774:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  10177a:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  10177e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101782:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101786:	ee                   	out    %al,(%dx)
  101787:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10178d:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  101791:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  101795:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101799:	ee                   	out    %al,(%dx)
  10179a:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  1017a0:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  1017a4:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1017a8:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1017ac:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017ad:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017b4:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017b8:	74 13                	je     1017cd <pic_init+0x13a>
        pic_setmask(irq_mask);
  1017ba:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017c1:	0f b7 c0             	movzwl %ax,%eax
  1017c4:	50                   	push   %eax
  1017c5:	e8 43 fe ff ff       	call   10160d <pic_setmask>
  1017ca:	83 c4 04             	add    $0x4,%esp
    }
}
  1017cd:	90                   	nop
  1017ce:	c9                   	leave  
  1017cf:	c3                   	ret    

001017d0 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017d0:	55                   	push   %ebp
  1017d1:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017d3:	fb                   	sti    
    sti();
}
  1017d4:	90                   	nop
  1017d5:	5d                   	pop    %ebp
  1017d6:	c3                   	ret    

001017d7 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017d7:	55                   	push   %ebp
  1017d8:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017da:	fa                   	cli    
    cli();
}
  1017db:	90                   	nop
  1017dc:	5d                   	pop    %ebp
  1017dd:	c3                   	ret    

001017de <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017de:	55                   	push   %ebp
  1017df:	89 e5                	mov    %esp,%ebp
  1017e1:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017e4:	83 ec 08             	sub    $0x8,%esp
  1017e7:	6a 64                	push   $0x64
  1017e9:	68 00 37 10 00       	push   $0x103700
  1017ee:	e8 4a ea ff ff       	call   10023d <cprintf>
  1017f3:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017f6:	90                   	nop
  1017f7:	c9                   	leave  
  1017f8:	c3                   	ret    

001017f9 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017f9:	55                   	push   %ebp
  1017fa:	89 e5                	mov    %esp,%ebp
  1017fc:	83 ec 10             	sub    $0x10,%esp
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
  1017ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101806:	e9 c3 00 00 00       	jmp    1018ce <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10180b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10180e:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101815:	89 c2                	mov    %eax,%edx
  101817:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10181a:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101821:	00 
  101822:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101825:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10182c:	00 08 00 
  10182f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101832:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101839:	00 
  10183a:	83 e2 e0             	and    $0xffffffe0,%edx
  10183d:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101844:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101847:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10184e:	00 
  10184f:	83 e2 1f             	and    $0x1f,%edx
  101852:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101859:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185c:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101863:	00 
  101864:	83 e2 f0             	and    $0xfffffff0,%edx
  101867:	83 ca 0e             	or     $0xe,%edx
  10186a:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101871:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101874:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10187b:	00 
  10187c:	83 e2 ef             	and    $0xffffffef,%edx
  10187f:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101886:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101889:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101890:	00 
  101891:	83 e2 9f             	and    $0xffffff9f,%edx
  101894:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10189b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189e:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018a5:	00 
  1018a6:	83 ca 80             	or     $0xffffff80,%edx
  1018a9:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b3:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018ba:	c1 e8 10             	shr    $0x10,%eax
  1018bd:	89 c2                	mov    %eax,%edx
  1018bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c2:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018c9:	00 
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
  1018ca:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018ce:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1018d5:	0f 8e 30 ff ff ff    	jle    10180b <idt_init+0x12>
  1018db:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  1018e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018e5:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }

    // 3. LIDT
    lidt(&idt_pd);
}
  1018e8:	90                   	nop
  1018e9:	c9                   	leave  
  1018ea:	c3                   	ret    

001018eb <trapname>:

static const char *
trapname(int trapno) {
  1018eb:	55                   	push   %ebp
  1018ec:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1018f1:	83 f8 13             	cmp    $0x13,%eax
  1018f4:	77 0c                	ja     101902 <trapname+0x17>
        return excnames[trapno];
  1018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1018f9:	8b 04 85 60 3a 10 00 	mov    0x103a60(,%eax,4),%eax
  101900:	eb 18                	jmp    10191a <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101902:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101906:	7e 0d                	jle    101915 <trapname+0x2a>
  101908:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10190c:	7f 07                	jg     101915 <trapname+0x2a>
        return "Hardware Interrupt";
  10190e:	b8 0a 37 10 00       	mov    $0x10370a,%eax
  101913:	eb 05                	jmp    10191a <trapname+0x2f>
    }
    return "(unknown trap)";
  101915:	b8 1d 37 10 00       	mov    $0x10371d,%eax
}
  10191a:	5d                   	pop    %ebp
  10191b:	c3                   	ret    

0010191c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10191c:	55                   	push   %ebp
  10191d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  10191f:	8b 45 08             	mov    0x8(%ebp),%eax
  101922:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101926:	66 83 f8 08          	cmp    $0x8,%ax
  10192a:	0f 94 c0             	sete   %al
  10192d:	0f b6 c0             	movzbl %al,%eax
}
  101930:	5d                   	pop    %ebp
  101931:	c3                   	ret    

00101932 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101932:	55                   	push   %ebp
  101933:	89 e5                	mov    %esp,%ebp
  101935:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101938:	83 ec 08             	sub    $0x8,%esp
  10193b:	ff 75 08             	pushl  0x8(%ebp)
  10193e:	68 5e 37 10 00       	push   $0x10375e
  101943:	e8 f5 e8 ff ff       	call   10023d <cprintf>
  101948:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  10194b:	8b 45 08             	mov    0x8(%ebp),%eax
  10194e:	83 ec 0c             	sub    $0xc,%esp
  101951:	50                   	push   %eax
  101952:	e8 b8 01 00 00       	call   101b0f <print_regs>
  101957:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  10195a:	8b 45 08             	mov    0x8(%ebp),%eax
  10195d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101961:	0f b7 c0             	movzwl %ax,%eax
  101964:	83 ec 08             	sub    $0x8,%esp
  101967:	50                   	push   %eax
  101968:	68 6f 37 10 00       	push   $0x10376f
  10196d:	e8 cb e8 ff ff       	call   10023d <cprintf>
  101972:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101975:	8b 45 08             	mov    0x8(%ebp),%eax
  101978:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  10197c:	0f b7 c0             	movzwl %ax,%eax
  10197f:	83 ec 08             	sub    $0x8,%esp
  101982:	50                   	push   %eax
  101983:	68 82 37 10 00       	push   $0x103782
  101988:	e8 b0 e8 ff ff       	call   10023d <cprintf>
  10198d:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101990:	8b 45 08             	mov    0x8(%ebp),%eax
  101993:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101997:	0f b7 c0             	movzwl %ax,%eax
  10199a:	83 ec 08             	sub    $0x8,%esp
  10199d:	50                   	push   %eax
  10199e:	68 95 37 10 00       	push   $0x103795
  1019a3:	e8 95 e8 ff ff       	call   10023d <cprintf>
  1019a8:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ae:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  1019b2:	0f b7 c0             	movzwl %ax,%eax
  1019b5:	83 ec 08             	sub    $0x8,%esp
  1019b8:	50                   	push   %eax
  1019b9:	68 a8 37 10 00       	push   $0x1037a8
  1019be:	e8 7a e8 ff ff       	call   10023d <cprintf>
  1019c3:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c9:	8b 40 30             	mov    0x30(%eax),%eax
  1019cc:	83 ec 0c             	sub    $0xc,%esp
  1019cf:	50                   	push   %eax
  1019d0:	e8 16 ff ff ff       	call   1018eb <trapname>
  1019d5:	83 c4 10             	add    $0x10,%esp
  1019d8:	89 c2                	mov    %eax,%edx
  1019da:	8b 45 08             	mov    0x8(%ebp),%eax
  1019dd:	8b 40 30             	mov    0x30(%eax),%eax
  1019e0:	83 ec 04             	sub    $0x4,%esp
  1019e3:	52                   	push   %edx
  1019e4:	50                   	push   %eax
  1019e5:	68 bb 37 10 00       	push   $0x1037bb
  1019ea:	e8 4e e8 ff ff       	call   10023d <cprintf>
  1019ef:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  1019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f5:	8b 40 34             	mov    0x34(%eax),%eax
  1019f8:	83 ec 08             	sub    $0x8,%esp
  1019fb:	50                   	push   %eax
  1019fc:	68 cd 37 10 00       	push   $0x1037cd
  101a01:	e8 37 e8 ff ff       	call   10023d <cprintf>
  101a06:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a09:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0c:	8b 40 38             	mov    0x38(%eax),%eax
  101a0f:	83 ec 08             	sub    $0x8,%esp
  101a12:	50                   	push   %eax
  101a13:	68 dc 37 10 00       	push   $0x1037dc
  101a18:	e8 20 e8 ff ff       	call   10023d <cprintf>
  101a1d:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a20:	8b 45 08             	mov    0x8(%ebp),%eax
  101a23:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a27:	0f b7 c0             	movzwl %ax,%eax
  101a2a:	83 ec 08             	sub    $0x8,%esp
  101a2d:	50                   	push   %eax
  101a2e:	68 eb 37 10 00       	push   $0x1037eb
  101a33:	e8 05 e8 ff ff       	call   10023d <cprintf>
  101a38:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3e:	8b 40 40             	mov    0x40(%eax),%eax
  101a41:	83 ec 08             	sub    $0x8,%esp
  101a44:	50                   	push   %eax
  101a45:	68 fe 37 10 00       	push   $0x1037fe
  101a4a:	e8 ee e7 ff ff       	call   10023d <cprintf>
  101a4f:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101a59:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101a60:	eb 3f                	jmp    101aa1 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101a62:	8b 45 08             	mov    0x8(%ebp),%eax
  101a65:	8b 50 40             	mov    0x40(%eax),%edx
  101a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a6b:	21 d0                	and    %edx,%eax
  101a6d:	85 c0                	test   %eax,%eax
  101a6f:	74 29                	je     101a9a <print_trapframe+0x168>
  101a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a74:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101a7b:	85 c0                	test   %eax,%eax
  101a7d:	74 1b                	je     101a9a <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a82:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101a89:	83 ec 08             	sub    $0x8,%esp
  101a8c:	50                   	push   %eax
  101a8d:	68 0d 38 10 00       	push   $0x10380d
  101a92:	e8 a6 e7 ff ff       	call   10023d <cprintf>
  101a97:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101a9e:	d1 65 f0             	shll   -0x10(%ebp)
  101aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101aa4:	83 f8 17             	cmp    $0x17,%eax
  101aa7:	76 b9                	jbe    101a62 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aac:	8b 40 40             	mov    0x40(%eax),%eax
  101aaf:	25 00 30 00 00       	and    $0x3000,%eax
  101ab4:	c1 e8 0c             	shr    $0xc,%eax
  101ab7:	83 ec 08             	sub    $0x8,%esp
  101aba:	50                   	push   %eax
  101abb:	68 11 38 10 00       	push   $0x103811
  101ac0:	e8 78 e7 ff ff       	call   10023d <cprintf>
  101ac5:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101ac8:	83 ec 0c             	sub    $0xc,%esp
  101acb:	ff 75 08             	pushl  0x8(%ebp)
  101ace:	e8 49 fe ff ff       	call   10191c <trap_in_kernel>
  101ad3:	83 c4 10             	add    $0x10,%esp
  101ad6:	85 c0                	test   %eax,%eax
  101ad8:	75 32                	jne    101b0c <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101ada:	8b 45 08             	mov    0x8(%ebp),%eax
  101add:	8b 40 44             	mov    0x44(%eax),%eax
  101ae0:	83 ec 08             	sub    $0x8,%esp
  101ae3:	50                   	push   %eax
  101ae4:	68 1a 38 10 00       	push   $0x10381a
  101ae9:	e8 4f e7 ff ff       	call   10023d <cprintf>
  101aee:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101af1:	8b 45 08             	mov    0x8(%ebp),%eax
  101af4:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101af8:	0f b7 c0             	movzwl %ax,%eax
  101afb:	83 ec 08             	sub    $0x8,%esp
  101afe:	50                   	push   %eax
  101aff:	68 29 38 10 00       	push   $0x103829
  101b04:	e8 34 e7 ff ff       	call   10023d <cprintf>
  101b09:	83 c4 10             	add    $0x10,%esp
    }
}
  101b0c:	90                   	nop
  101b0d:	c9                   	leave  
  101b0e:	c3                   	ret    

00101b0f <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b0f:	55                   	push   %ebp
  101b10:	89 e5                	mov    %esp,%ebp
  101b12:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b15:	8b 45 08             	mov    0x8(%ebp),%eax
  101b18:	8b 00                	mov    (%eax),%eax
  101b1a:	83 ec 08             	sub    $0x8,%esp
  101b1d:	50                   	push   %eax
  101b1e:	68 3c 38 10 00       	push   $0x10383c
  101b23:	e8 15 e7 ff ff       	call   10023d <cprintf>
  101b28:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2e:	8b 40 04             	mov    0x4(%eax),%eax
  101b31:	83 ec 08             	sub    $0x8,%esp
  101b34:	50                   	push   %eax
  101b35:	68 4b 38 10 00       	push   $0x10384b
  101b3a:	e8 fe e6 ff ff       	call   10023d <cprintf>
  101b3f:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101b42:	8b 45 08             	mov    0x8(%ebp),%eax
  101b45:	8b 40 08             	mov    0x8(%eax),%eax
  101b48:	83 ec 08             	sub    $0x8,%esp
  101b4b:	50                   	push   %eax
  101b4c:	68 5a 38 10 00       	push   $0x10385a
  101b51:	e8 e7 e6 ff ff       	call   10023d <cprintf>
  101b56:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101b59:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5c:	8b 40 0c             	mov    0xc(%eax),%eax
  101b5f:	83 ec 08             	sub    $0x8,%esp
  101b62:	50                   	push   %eax
  101b63:	68 69 38 10 00       	push   $0x103869
  101b68:	e8 d0 e6 ff ff       	call   10023d <cprintf>
  101b6d:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101b70:	8b 45 08             	mov    0x8(%ebp),%eax
  101b73:	8b 40 10             	mov    0x10(%eax),%eax
  101b76:	83 ec 08             	sub    $0x8,%esp
  101b79:	50                   	push   %eax
  101b7a:	68 78 38 10 00       	push   $0x103878
  101b7f:	e8 b9 e6 ff ff       	call   10023d <cprintf>
  101b84:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101b87:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8a:	8b 40 14             	mov    0x14(%eax),%eax
  101b8d:	83 ec 08             	sub    $0x8,%esp
  101b90:	50                   	push   %eax
  101b91:	68 87 38 10 00       	push   $0x103887
  101b96:	e8 a2 e6 ff ff       	call   10023d <cprintf>
  101b9b:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba1:	8b 40 18             	mov    0x18(%eax),%eax
  101ba4:	83 ec 08             	sub    $0x8,%esp
  101ba7:	50                   	push   %eax
  101ba8:	68 96 38 10 00       	push   $0x103896
  101bad:	e8 8b e6 ff ff       	call   10023d <cprintf>
  101bb2:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb8:	8b 40 1c             	mov    0x1c(%eax),%eax
  101bbb:	83 ec 08             	sub    $0x8,%esp
  101bbe:	50                   	push   %eax
  101bbf:	68 a5 38 10 00       	push   $0x1038a5
  101bc4:	e8 74 e6 ff ff       	call   10023d <cprintf>
  101bc9:	83 c4 10             	add    $0x10,%esp
}
  101bcc:	90                   	nop
  101bcd:	c9                   	leave  
  101bce:	c3                   	ret    

00101bcf <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101bcf:	55                   	push   %ebp
  101bd0:	89 e5                	mov    %esp,%ebp
  101bd2:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd8:	8b 40 30             	mov    0x30(%eax),%eax
  101bdb:	83 f8 2f             	cmp    $0x2f,%eax
  101bde:	77 1d                	ja     101bfd <trap_dispatch+0x2e>
  101be0:	83 f8 2e             	cmp    $0x2e,%eax
  101be3:	0f 83 e6 00 00 00    	jae    101ccf <trap_dispatch+0x100>
  101be9:	83 f8 21             	cmp    $0x21,%eax
  101bec:	74 70                	je     101c5e <trap_dispatch+0x8f>
  101bee:	83 f8 24             	cmp    $0x24,%eax
  101bf1:	74 47                	je     101c3a <trap_dispatch+0x6b>
  101bf3:	83 f8 20             	cmp    $0x20,%eax
  101bf6:	74 13                	je     101c0b <trap_dispatch+0x3c>
  101bf8:	e9 9c 00 00 00       	jmp    101c99 <trap_dispatch+0xca>
  101bfd:	83 e8 78             	sub    $0x78,%eax
  101c00:	83 f8 01             	cmp    $0x1,%eax
  101c03:	0f 87 90 00 00 00    	ja     101c99 <trap_dispatch+0xca>
  101c09:	eb 77                	jmp    101c82 <trap_dispatch+0xb3>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        // 1. record
        ticks++;
  101c0b:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c10:	83 c0 01             	add    $0x1,%eax
  101c13:	a3 08 f9 10 00       	mov    %eax,0x10f908

        // 2. print
        if (ticks >= 100) {
  101c18:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c1d:	83 f8 63             	cmp    $0x63,%eax
  101c20:	0f 86 ac 00 00 00    	jbe    101cd2 <trap_dispatch+0x103>
            print_ticks();
  101c26:	e8 b3 fb ff ff       	call   1017de <print_ticks>
            ticks = 0;
  101c2b:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  101c32:	00 00 00 
        }

        // 3. too simple ?!
        break;
  101c35:	e9 98 00 00 00       	jmp    101cd2 <trap_dispatch+0x103>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101c3a:	e8 72 f9 ff ff       	call   1015b1 <cons_getc>
  101c3f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101c42:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c46:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c4a:	83 ec 04             	sub    $0x4,%esp
  101c4d:	52                   	push   %edx
  101c4e:	50                   	push   %eax
  101c4f:	68 b4 38 10 00       	push   $0x1038b4
  101c54:	e8 e4 e5 ff ff       	call   10023d <cprintf>
  101c59:	83 c4 10             	add    $0x10,%esp
        break;
  101c5c:	eb 75                	jmp    101cd3 <trap_dispatch+0x104>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101c5e:	e8 4e f9 ff ff       	call   1015b1 <cons_getc>
  101c63:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101c66:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c6a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c6e:	83 ec 04             	sub    $0x4,%esp
  101c71:	52                   	push   %edx
  101c72:	50                   	push   %eax
  101c73:	68 c6 38 10 00       	push   $0x1038c6
  101c78:	e8 c0 e5 ff ff       	call   10023d <cprintf>
  101c7d:	83 c4 10             	add    $0x10,%esp
        break;
  101c80:	eb 51                	jmp    101cd3 <trap_dispatch+0x104>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101c82:	83 ec 04             	sub    $0x4,%esp
  101c85:	68 d5 38 10 00       	push   $0x1038d5
  101c8a:	68 b6 00 00 00       	push   $0xb6
  101c8f:	68 e5 38 10 00       	push   $0x1038e5
  101c94:	e8 0a e7 ff ff       	call   1003a3 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101c99:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ca0:	0f b7 c0             	movzwl %ax,%eax
  101ca3:	83 e0 03             	and    $0x3,%eax
  101ca6:	85 c0                	test   %eax,%eax
  101ca8:	75 29                	jne    101cd3 <trap_dispatch+0x104>
            print_trapframe(tf);
  101caa:	83 ec 0c             	sub    $0xc,%esp
  101cad:	ff 75 08             	pushl  0x8(%ebp)
  101cb0:	e8 7d fc ff ff       	call   101932 <print_trapframe>
  101cb5:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101cb8:	83 ec 04             	sub    $0x4,%esp
  101cbb:	68 f6 38 10 00       	push   $0x1038f6
  101cc0:	68 c0 00 00 00       	push   $0xc0
  101cc5:	68 e5 38 10 00       	push   $0x1038e5
  101cca:	e8 d4 e6 ff ff       	call   1003a3 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101ccf:	90                   	nop
  101cd0:	eb 01                	jmp    101cd3 <trap_dispatch+0x104>
            print_ticks();
            ticks = 0;
        }

        // 3. too simple ?!
        break;
  101cd2:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101cd3:	90                   	nop
  101cd4:	c9                   	leave  
  101cd5:	c3                   	ret    

00101cd6 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101cd6:	55                   	push   %ebp
  101cd7:	89 e5                	mov    %esp,%ebp
  101cd9:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101cdc:	83 ec 0c             	sub    $0xc,%esp
  101cdf:	ff 75 08             	pushl  0x8(%ebp)
  101ce2:	e8 e8 fe ff ff       	call   101bcf <trap_dispatch>
  101ce7:	83 c4 10             	add    $0x10,%esp
}
  101cea:	90                   	nop
  101ceb:	c9                   	leave  
  101cec:	c3                   	ret    

00101ced <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ced:	6a 00                	push   $0x0
  pushl $0
  101cef:	6a 00                	push   $0x0
  jmp __alltraps
  101cf1:	e9 69 0a 00 00       	jmp    10275f <__alltraps>

00101cf6 <vector1>:
.globl vector1
vector1:
  pushl $0
  101cf6:	6a 00                	push   $0x0
  pushl $1
  101cf8:	6a 01                	push   $0x1
  jmp __alltraps
  101cfa:	e9 60 0a 00 00       	jmp    10275f <__alltraps>

00101cff <vector2>:
.globl vector2
vector2:
  pushl $0
  101cff:	6a 00                	push   $0x0
  pushl $2
  101d01:	6a 02                	push   $0x2
  jmp __alltraps
  101d03:	e9 57 0a 00 00       	jmp    10275f <__alltraps>

00101d08 <vector3>:
.globl vector3
vector3:
  pushl $0
  101d08:	6a 00                	push   $0x0
  pushl $3
  101d0a:	6a 03                	push   $0x3
  jmp __alltraps
  101d0c:	e9 4e 0a 00 00       	jmp    10275f <__alltraps>

00101d11 <vector4>:
.globl vector4
vector4:
  pushl $0
  101d11:	6a 00                	push   $0x0
  pushl $4
  101d13:	6a 04                	push   $0x4
  jmp __alltraps
  101d15:	e9 45 0a 00 00       	jmp    10275f <__alltraps>

00101d1a <vector5>:
.globl vector5
vector5:
  pushl $0
  101d1a:	6a 00                	push   $0x0
  pushl $5
  101d1c:	6a 05                	push   $0x5
  jmp __alltraps
  101d1e:	e9 3c 0a 00 00       	jmp    10275f <__alltraps>

00101d23 <vector6>:
.globl vector6
vector6:
  pushl $0
  101d23:	6a 00                	push   $0x0
  pushl $6
  101d25:	6a 06                	push   $0x6
  jmp __alltraps
  101d27:	e9 33 0a 00 00       	jmp    10275f <__alltraps>

00101d2c <vector7>:
.globl vector7
vector7:
  pushl $0
  101d2c:	6a 00                	push   $0x0
  pushl $7
  101d2e:	6a 07                	push   $0x7
  jmp __alltraps
  101d30:	e9 2a 0a 00 00       	jmp    10275f <__alltraps>

00101d35 <vector8>:
.globl vector8
vector8:
  pushl $8
  101d35:	6a 08                	push   $0x8
  jmp __alltraps
  101d37:	e9 23 0a 00 00       	jmp    10275f <__alltraps>

00101d3c <vector9>:
.globl vector9
vector9:
  pushl $0
  101d3c:	6a 00                	push   $0x0
  pushl $9
  101d3e:	6a 09                	push   $0x9
  jmp __alltraps
  101d40:	e9 1a 0a 00 00       	jmp    10275f <__alltraps>

00101d45 <vector10>:
.globl vector10
vector10:
  pushl $10
  101d45:	6a 0a                	push   $0xa
  jmp __alltraps
  101d47:	e9 13 0a 00 00       	jmp    10275f <__alltraps>

00101d4c <vector11>:
.globl vector11
vector11:
  pushl $11
  101d4c:	6a 0b                	push   $0xb
  jmp __alltraps
  101d4e:	e9 0c 0a 00 00       	jmp    10275f <__alltraps>

00101d53 <vector12>:
.globl vector12
vector12:
  pushl $12
  101d53:	6a 0c                	push   $0xc
  jmp __alltraps
  101d55:	e9 05 0a 00 00       	jmp    10275f <__alltraps>

00101d5a <vector13>:
.globl vector13
vector13:
  pushl $13
  101d5a:	6a 0d                	push   $0xd
  jmp __alltraps
  101d5c:	e9 fe 09 00 00       	jmp    10275f <__alltraps>

00101d61 <vector14>:
.globl vector14
vector14:
  pushl $14
  101d61:	6a 0e                	push   $0xe
  jmp __alltraps
  101d63:	e9 f7 09 00 00       	jmp    10275f <__alltraps>

00101d68 <vector15>:
.globl vector15
vector15:
  pushl $0
  101d68:	6a 00                	push   $0x0
  pushl $15
  101d6a:	6a 0f                	push   $0xf
  jmp __alltraps
  101d6c:	e9 ee 09 00 00       	jmp    10275f <__alltraps>

00101d71 <vector16>:
.globl vector16
vector16:
  pushl $0
  101d71:	6a 00                	push   $0x0
  pushl $16
  101d73:	6a 10                	push   $0x10
  jmp __alltraps
  101d75:	e9 e5 09 00 00       	jmp    10275f <__alltraps>

00101d7a <vector17>:
.globl vector17
vector17:
  pushl $17
  101d7a:	6a 11                	push   $0x11
  jmp __alltraps
  101d7c:	e9 de 09 00 00       	jmp    10275f <__alltraps>

00101d81 <vector18>:
.globl vector18
vector18:
  pushl $0
  101d81:	6a 00                	push   $0x0
  pushl $18
  101d83:	6a 12                	push   $0x12
  jmp __alltraps
  101d85:	e9 d5 09 00 00       	jmp    10275f <__alltraps>

00101d8a <vector19>:
.globl vector19
vector19:
  pushl $0
  101d8a:	6a 00                	push   $0x0
  pushl $19
  101d8c:	6a 13                	push   $0x13
  jmp __alltraps
  101d8e:	e9 cc 09 00 00       	jmp    10275f <__alltraps>

00101d93 <vector20>:
.globl vector20
vector20:
  pushl $0
  101d93:	6a 00                	push   $0x0
  pushl $20
  101d95:	6a 14                	push   $0x14
  jmp __alltraps
  101d97:	e9 c3 09 00 00       	jmp    10275f <__alltraps>

00101d9c <vector21>:
.globl vector21
vector21:
  pushl $0
  101d9c:	6a 00                	push   $0x0
  pushl $21
  101d9e:	6a 15                	push   $0x15
  jmp __alltraps
  101da0:	e9 ba 09 00 00       	jmp    10275f <__alltraps>

00101da5 <vector22>:
.globl vector22
vector22:
  pushl $0
  101da5:	6a 00                	push   $0x0
  pushl $22
  101da7:	6a 16                	push   $0x16
  jmp __alltraps
  101da9:	e9 b1 09 00 00       	jmp    10275f <__alltraps>

00101dae <vector23>:
.globl vector23
vector23:
  pushl $0
  101dae:	6a 00                	push   $0x0
  pushl $23
  101db0:	6a 17                	push   $0x17
  jmp __alltraps
  101db2:	e9 a8 09 00 00       	jmp    10275f <__alltraps>

00101db7 <vector24>:
.globl vector24
vector24:
  pushl $0
  101db7:	6a 00                	push   $0x0
  pushl $24
  101db9:	6a 18                	push   $0x18
  jmp __alltraps
  101dbb:	e9 9f 09 00 00       	jmp    10275f <__alltraps>

00101dc0 <vector25>:
.globl vector25
vector25:
  pushl $0
  101dc0:	6a 00                	push   $0x0
  pushl $25
  101dc2:	6a 19                	push   $0x19
  jmp __alltraps
  101dc4:	e9 96 09 00 00       	jmp    10275f <__alltraps>

00101dc9 <vector26>:
.globl vector26
vector26:
  pushl $0
  101dc9:	6a 00                	push   $0x0
  pushl $26
  101dcb:	6a 1a                	push   $0x1a
  jmp __alltraps
  101dcd:	e9 8d 09 00 00       	jmp    10275f <__alltraps>

00101dd2 <vector27>:
.globl vector27
vector27:
  pushl $0
  101dd2:	6a 00                	push   $0x0
  pushl $27
  101dd4:	6a 1b                	push   $0x1b
  jmp __alltraps
  101dd6:	e9 84 09 00 00       	jmp    10275f <__alltraps>

00101ddb <vector28>:
.globl vector28
vector28:
  pushl $0
  101ddb:	6a 00                	push   $0x0
  pushl $28
  101ddd:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ddf:	e9 7b 09 00 00       	jmp    10275f <__alltraps>

00101de4 <vector29>:
.globl vector29
vector29:
  pushl $0
  101de4:	6a 00                	push   $0x0
  pushl $29
  101de6:	6a 1d                	push   $0x1d
  jmp __alltraps
  101de8:	e9 72 09 00 00       	jmp    10275f <__alltraps>

00101ded <vector30>:
.globl vector30
vector30:
  pushl $0
  101ded:	6a 00                	push   $0x0
  pushl $30
  101def:	6a 1e                	push   $0x1e
  jmp __alltraps
  101df1:	e9 69 09 00 00       	jmp    10275f <__alltraps>

00101df6 <vector31>:
.globl vector31
vector31:
  pushl $0
  101df6:	6a 00                	push   $0x0
  pushl $31
  101df8:	6a 1f                	push   $0x1f
  jmp __alltraps
  101dfa:	e9 60 09 00 00       	jmp    10275f <__alltraps>

00101dff <vector32>:
.globl vector32
vector32:
  pushl $0
  101dff:	6a 00                	push   $0x0
  pushl $32
  101e01:	6a 20                	push   $0x20
  jmp __alltraps
  101e03:	e9 57 09 00 00       	jmp    10275f <__alltraps>

00101e08 <vector33>:
.globl vector33
vector33:
  pushl $0
  101e08:	6a 00                	push   $0x0
  pushl $33
  101e0a:	6a 21                	push   $0x21
  jmp __alltraps
  101e0c:	e9 4e 09 00 00       	jmp    10275f <__alltraps>

00101e11 <vector34>:
.globl vector34
vector34:
  pushl $0
  101e11:	6a 00                	push   $0x0
  pushl $34
  101e13:	6a 22                	push   $0x22
  jmp __alltraps
  101e15:	e9 45 09 00 00       	jmp    10275f <__alltraps>

00101e1a <vector35>:
.globl vector35
vector35:
  pushl $0
  101e1a:	6a 00                	push   $0x0
  pushl $35
  101e1c:	6a 23                	push   $0x23
  jmp __alltraps
  101e1e:	e9 3c 09 00 00       	jmp    10275f <__alltraps>

00101e23 <vector36>:
.globl vector36
vector36:
  pushl $0
  101e23:	6a 00                	push   $0x0
  pushl $36
  101e25:	6a 24                	push   $0x24
  jmp __alltraps
  101e27:	e9 33 09 00 00       	jmp    10275f <__alltraps>

00101e2c <vector37>:
.globl vector37
vector37:
  pushl $0
  101e2c:	6a 00                	push   $0x0
  pushl $37
  101e2e:	6a 25                	push   $0x25
  jmp __alltraps
  101e30:	e9 2a 09 00 00       	jmp    10275f <__alltraps>

00101e35 <vector38>:
.globl vector38
vector38:
  pushl $0
  101e35:	6a 00                	push   $0x0
  pushl $38
  101e37:	6a 26                	push   $0x26
  jmp __alltraps
  101e39:	e9 21 09 00 00       	jmp    10275f <__alltraps>

00101e3e <vector39>:
.globl vector39
vector39:
  pushl $0
  101e3e:	6a 00                	push   $0x0
  pushl $39
  101e40:	6a 27                	push   $0x27
  jmp __alltraps
  101e42:	e9 18 09 00 00       	jmp    10275f <__alltraps>

00101e47 <vector40>:
.globl vector40
vector40:
  pushl $0
  101e47:	6a 00                	push   $0x0
  pushl $40
  101e49:	6a 28                	push   $0x28
  jmp __alltraps
  101e4b:	e9 0f 09 00 00       	jmp    10275f <__alltraps>

00101e50 <vector41>:
.globl vector41
vector41:
  pushl $0
  101e50:	6a 00                	push   $0x0
  pushl $41
  101e52:	6a 29                	push   $0x29
  jmp __alltraps
  101e54:	e9 06 09 00 00       	jmp    10275f <__alltraps>

00101e59 <vector42>:
.globl vector42
vector42:
  pushl $0
  101e59:	6a 00                	push   $0x0
  pushl $42
  101e5b:	6a 2a                	push   $0x2a
  jmp __alltraps
  101e5d:	e9 fd 08 00 00       	jmp    10275f <__alltraps>

00101e62 <vector43>:
.globl vector43
vector43:
  pushl $0
  101e62:	6a 00                	push   $0x0
  pushl $43
  101e64:	6a 2b                	push   $0x2b
  jmp __alltraps
  101e66:	e9 f4 08 00 00       	jmp    10275f <__alltraps>

00101e6b <vector44>:
.globl vector44
vector44:
  pushl $0
  101e6b:	6a 00                	push   $0x0
  pushl $44
  101e6d:	6a 2c                	push   $0x2c
  jmp __alltraps
  101e6f:	e9 eb 08 00 00       	jmp    10275f <__alltraps>

00101e74 <vector45>:
.globl vector45
vector45:
  pushl $0
  101e74:	6a 00                	push   $0x0
  pushl $45
  101e76:	6a 2d                	push   $0x2d
  jmp __alltraps
  101e78:	e9 e2 08 00 00       	jmp    10275f <__alltraps>

00101e7d <vector46>:
.globl vector46
vector46:
  pushl $0
  101e7d:	6a 00                	push   $0x0
  pushl $46
  101e7f:	6a 2e                	push   $0x2e
  jmp __alltraps
  101e81:	e9 d9 08 00 00       	jmp    10275f <__alltraps>

00101e86 <vector47>:
.globl vector47
vector47:
  pushl $0
  101e86:	6a 00                	push   $0x0
  pushl $47
  101e88:	6a 2f                	push   $0x2f
  jmp __alltraps
  101e8a:	e9 d0 08 00 00       	jmp    10275f <__alltraps>

00101e8f <vector48>:
.globl vector48
vector48:
  pushl $0
  101e8f:	6a 00                	push   $0x0
  pushl $48
  101e91:	6a 30                	push   $0x30
  jmp __alltraps
  101e93:	e9 c7 08 00 00       	jmp    10275f <__alltraps>

00101e98 <vector49>:
.globl vector49
vector49:
  pushl $0
  101e98:	6a 00                	push   $0x0
  pushl $49
  101e9a:	6a 31                	push   $0x31
  jmp __alltraps
  101e9c:	e9 be 08 00 00       	jmp    10275f <__alltraps>

00101ea1 <vector50>:
.globl vector50
vector50:
  pushl $0
  101ea1:	6a 00                	push   $0x0
  pushl $50
  101ea3:	6a 32                	push   $0x32
  jmp __alltraps
  101ea5:	e9 b5 08 00 00       	jmp    10275f <__alltraps>

00101eaa <vector51>:
.globl vector51
vector51:
  pushl $0
  101eaa:	6a 00                	push   $0x0
  pushl $51
  101eac:	6a 33                	push   $0x33
  jmp __alltraps
  101eae:	e9 ac 08 00 00       	jmp    10275f <__alltraps>

00101eb3 <vector52>:
.globl vector52
vector52:
  pushl $0
  101eb3:	6a 00                	push   $0x0
  pushl $52
  101eb5:	6a 34                	push   $0x34
  jmp __alltraps
  101eb7:	e9 a3 08 00 00       	jmp    10275f <__alltraps>

00101ebc <vector53>:
.globl vector53
vector53:
  pushl $0
  101ebc:	6a 00                	push   $0x0
  pushl $53
  101ebe:	6a 35                	push   $0x35
  jmp __alltraps
  101ec0:	e9 9a 08 00 00       	jmp    10275f <__alltraps>

00101ec5 <vector54>:
.globl vector54
vector54:
  pushl $0
  101ec5:	6a 00                	push   $0x0
  pushl $54
  101ec7:	6a 36                	push   $0x36
  jmp __alltraps
  101ec9:	e9 91 08 00 00       	jmp    10275f <__alltraps>

00101ece <vector55>:
.globl vector55
vector55:
  pushl $0
  101ece:	6a 00                	push   $0x0
  pushl $55
  101ed0:	6a 37                	push   $0x37
  jmp __alltraps
  101ed2:	e9 88 08 00 00       	jmp    10275f <__alltraps>

00101ed7 <vector56>:
.globl vector56
vector56:
  pushl $0
  101ed7:	6a 00                	push   $0x0
  pushl $56
  101ed9:	6a 38                	push   $0x38
  jmp __alltraps
  101edb:	e9 7f 08 00 00       	jmp    10275f <__alltraps>

00101ee0 <vector57>:
.globl vector57
vector57:
  pushl $0
  101ee0:	6a 00                	push   $0x0
  pushl $57
  101ee2:	6a 39                	push   $0x39
  jmp __alltraps
  101ee4:	e9 76 08 00 00       	jmp    10275f <__alltraps>

00101ee9 <vector58>:
.globl vector58
vector58:
  pushl $0
  101ee9:	6a 00                	push   $0x0
  pushl $58
  101eeb:	6a 3a                	push   $0x3a
  jmp __alltraps
  101eed:	e9 6d 08 00 00       	jmp    10275f <__alltraps>

00101ef2 <vector59>:
.globl vector59
vector59:
  pushl $0
  101ef2:	6a 00                	push   $0x0
  pushl $59
  101ef4:	6a 3b                	push   $0x3b
  jmp __alltraps
  101ef6:	e9 64 08 00 00       	jmp    10275f <__alltraps>

00101efb <vector60>:
.globl vector60
vector60:
  pushl $0
  101efb:	6a 00                	push   $0x0
  pushl $60
  101efd:	6a 3c                	push   $0x3c
  jmp __alltraps
  101eff:	e9 5b 08 00 00       	jmp    10275f <__alltraps>

00101f04 <vector61>:
.globl vector61
vector61:
  pushl $0
  101f04:	6a 00                	push   $0x0
  pushl $61
  101f06:	6a 3d                	push   $0x3d
  jmp __alltraps
  101f08:	e9 52 08 00 00       	jmp    10275f <__alltraps>

00101f0d <vector62>:
.globl vector62
vector62:
  pushl $0
  101f0d:	6a 00                	push   $0x0
  pushl $62
  101f0f:	6a 3e                	push   $0x3e
  jmp __alltraps
  101f11:	e9 49 08 00 00       	jmp    10275f <__alltraps>

00101f16 <vector63>:
.globl vector63
vector63:
  pushl $0
  101f16:	6a 00                	push   $0x0
  pushl $63
  101f18:	6a 3f                	push   $0x3f
  jmp __alltraps
  101f1a:	e9 40 08 00 00       	jmp    10275f <__alltraps>

00101f1f <vector64>:
.globl vector64
vector64:
  pushl $0
  101f1f:	6a 00                	push   $0x0
  pushl $64
  101f21:	6a 40                	push   $0x40
  jmp __alltraps
  101f23:	e9 37 08 00 00       	jmp    10275f <__alltraps>

00101f28 <vector65>:
.globl vector65
vector65:
  pushl $0
  101f28:	6a 00                	push   $0x0
  pushl $65
  101f2a:	6a 41                	push   $0x41
  jmp __alltraps
  101f2c:	e9 2e 08 00 00       	jmp    10275f <__alltraps>

00101f31 <vector66>:
.globl vector66
vector66:
  pushl $0
  101f31:	6a 00                	push   $0x0
  pushl $66
  101f33:	6a 42                	push   $0x42
  jmp __alltraps
  101f35:	e9 25 08 00 00       	jmp    10275f <__alltraps>

00101f3a <vector67>:
.globl vector67
vector67:
  pushl $0
  101f3a:	6a 00                	push   $0x0
  pushl $67
  101f3c:	6a 43                	push   $0x43
  jmp __alltraps
  101f3e:	e9 1c 08 00 00       	jmp    10275f <__alltraps>

00101f43 <vector68>:
.globl vector68
vector68:
  pushl $0
  101f43:	6a 00                	push   $0x0
  pushl $68
  101f45:	6a 44                	push   $0x44
  jmp __alltraps
  101f47:	e9 13 08 00 00       	jmp    10275f <__alltraps>

00101f4c <vector69>:
.globl vector69
vector69:
  pushl $0
  101f4c:	6a 00                	push   $0x0
  pushl $69
  101f4e:	6a 45                	push   $0x45
  jmp __alltraps
  101f50:	e9 0a 08 00 00       	jmp    10275f <__alltraps>

00101f55 <vector70>:
.globl vector70
vector70:
  pushl $0
  101f55:	6a 00                	push   $0x0
  pushl $70
  101f57:	6a 46                	push   $0x46
  jmp __alltraps
  101f59:	e9 01 08 00 00       	jmp    10275f <__alltraps>

00101f5e <vector71>:
.globl vector71
vector71:
  pushl $0
  101f5e:	6a 00                	push   $0x0
  pushl $71
  101f60:	6a 47                	push   $0x47
  jmp __alltraps
  101f62:	e9 f8 07 00 00       	jmp    10275f <__alltraps>

00101f67 <vector72>:
.globl vector72
vector72:
  pushl $0
  101f67:	6a 00                	push   $0x0
  pushl $72
  101f69:	6a 48                	push   $0x48
  jmp __alltraps
  101f6b:	e9 ef 07 00 00       	jmp    10275f <__alltraps>

00101f70 <vector73>:
.globl vector73
vector73:
  pushl $0
  101f70:	6a 00                	push   $0x0
  pushl $73
  101f72:	6a 49                	push   $0x49
  jmp __alltraps
  101f74:	e9 e6 07 00 00       	jmp    10275f <__alltraps>

00101f79 <vector74>:
.globl vector74
vector74:
  pushl $0
  101f79:	6a 00                	push   $0x0
  pushl $74
  101f7b:	6a 4a                	push   $0x4a
  jmp __alltraps
  101f7d:	e9 dd 07 00 00       	jmp    10275f <__alltraps>

00101f82 <vector75>:
.globl vector75
vector75:
  pushl $0
  101f82:	6a 00                	push   $0x0
  pushl $75
  101f84:	6a 4b                	push   $0x4b
  jmp __alltraps
  101f86:	e9 d4 07 00 00       	jmp    10275f <__alltraps>

00101f8b <vector76>:
.globl vector76
vector76:
  pushl $0
  101f8b:	6a 00                	push   $0x0
  pushl $76
  101f8d:	6a 4c                	push   $0x4c
  jmp __alltraps
  101f8f:	e9 cb 07 00 00       	jmp    10275f <__alltraps>

00101f94 <vector77>:
.globl vector77
vector77:
  pushl $0
  101f94:	6a 00                	push   $0x0
  pushl $77
  101f96:	6a 4d                	push   $0x4d
  jmp __alltraps
  101f98:	e9 c2 07 00 00       	jmp    10275f <__alltraps>

00101f9d <vector78>:
.globl vector78
vector78:
  pushl $0
  101f9d:	6a 00                	push   $0x0
  pushl $78
  101f9f:	6a 4e                	push   $0x4e
  jmp __alltraps
  101fa1:	e9 b9 07 00 00       	jmp    10275f <__alltraps>

00101fa6 <vector79>:
.globl vector79
vector79:
  pushl $0
  101fa6:	6a 00                	push   $0x0
  pushl $79
  101fa8:	6a 4f                	push   $0x4f
  jmp __alltraps
  101faa:	e9 b0 07 00 00       	jmp    10275f <__alltraps>

00101faf <vector80>:
.globl vector80
vector80:
  pushl $0
  101faf:	6a 00                	push   $0x0
  pushl $80
  101fb1:	6a 50                	push   $0x50
  jmp __alltraps
  101fb3:	e9 a7 07 00 00       	jmp    10275f <__alltraps>

00101fb8 <vector81>:
.globl vector81
vector81:
  pushl $0
  101fb8:	6a 00                	push   $0x0
  pushl $81
  101fba:	6a 51                	push   $0x51
  jmp __alltraps
  101fbc:	e9 9e 07 00 00       	jmp    10275f <__alltraps>

00101fc1 <vector82>:
.globl vector82
vector82:
  pushl $0
  101fc1:	6a 00                	push   $0x0
  pushl $82
  101fc3:	6a 52                	push   $0x52
  jmp __alltraps
  101fc5:	e9 95 07 00 00       	jmp    10275f <__alltraps>

00101fca <vector83>:
.globl vector83
vector83:
  pushl $0
  101fca:	6a 00                	push   $0x0
  pushl $83
  101fcc:	6a 53                	push   $0x53
  jmp __alltraps
  101fce:	e9 8c 07 00 00       	jmp    10275f <__alltraps>

00101fd3 <vector84>:
.globl vector84
vector84:
  pushl $0
  101fd3:	6a 00                	push   $0x0
  pushl $84
  101fd5:	6a 54                	push   $0x54
  jmp __alltraps
  101fd7:	e9 83 07 00 00       	jmp    10275f <__alltraps>

00101fdc <vector85>:
.globl vector85
vector85:
  pushl $0
  101fdc:	6a 00                	push   $0x0
  pushl $85
  101fde:	6a 55                	push   $0x55
  jmp __alltraps
  101fe0:	e9 7a 07 00 00       	jmp    10275f <__alltraps>

00101fe5 <vector86>:
.globl vector86
vector86:
  pushl $0
  101fe5:	6a 00                	push   $0x0
  pushl $86
  101fe7:	6a 56                	push   $0x56
  jmp __alltraps
  101fe9:	e9 71 07 00 00       	jmp    10275f <__alltraps>

00101fee <vector87>:
.globl vector87
vector87:
  pushl $0
  101fee:	6a 00                	push   $0x0
  pushl $87
  101ff0:	6a 57                	push   $0x57
  jmp __alltraps
  101ff2:	e9 68 07 00 00       	jmp    10275f <__alltraps>

00101ff7 <vector88>:
.globl vector88
vector88:
  pushl $0
  101ff7:	6a 00                	push   $0x0
  pushl $88
  101ff9:	6a 58                	push   $0x58
  jmp __alltraps
  101ffb:	e9 5f 07 00 00       	jmp    10275f <__alltraps>

00102000 <vector89>:
.globl vector89
vector89:
  pushl $0
  102000:	6a 00                	push   $0x0
  pushl $89
  102002:	6a 59                	push   $0x59
  jmp __alltraps
  102004:	e9 56 07 00 00       	jmp    10275f <__alltraps>

00102009 <vector90>:
.globl vector90
vector90:
  pushl $0
  102009:	6a 00                	push   $0x0
  pushl $90
  10200b:	6a 5a                	push   $0x5a
  jmp __alltraps
  10200d:	e9 4d 07 00 00       	jmp    10275f <__alltraps>

00102012 <vector91>:
.globl vector91
vector91:
  pushl $0
  102012:	6a 00                	push   $0x0
  pushl $91
  102014:	6a 5b                	push   $0x5b
  jmp __alltraps
  102016:	e9 44 07 00 00       	jmp    10275f <__alltraps>

0010201b <vector92>:
.globl vector92
vector92:
  pushl $0
  10201b:	6a 00                	push   $0x0
  pushl $92
  10201d:	6a 5c                	push   $0x5c
  jmp __alltraps
  10201f:	e9 3b 07 00 00       	jmp    10275f <__alltraps>

00102024 <vector93>:
.globl vector93
vector93:
  pushl $0
  102024:	6a 00                	push   $0x0
  pushl $93
  102026:	6a 5d                	push   $0x5d
  jmp __alltraps
  102028:	e9 32 07 00 00       	jmp    10275f <__alltraps>

0010202d <vector94>:
.globl vector94
vector94:
  pushl $0
  10202d:	6a 00                	push   $0x0
  pushl $94
  10202f:	6a 5e                	push   $0x5e
  jmp __alltraps
  102031:	e9 29 07 00 00       	jmp    10275f <__alltraps>

00102036 <vector95>:
.globl vector95
vector95:
  pushl $0
  102036:	6a 00                	push   $0x0
  pushl $95
  102038:	6a 5f                	push   $0x5f
  jmp __alltraps
  10203a:	e9 20 07 00 00       	jmp    10275f <__alltraps>

0010203f <vector96>:
.globl vector96
vector96:
  pushl $0
  10203f:	6a 00                	push   $0x0
  pushl $96
  102041:	6a 60                	push   $0x60
  jmp __alltraps
  102043:	e9 17 07 00 00       	jmp    10275f <__alltraps>

00102048 <vector97>:
.globl vector97
vector97:
  pushl $0
  102048:	6a 00                	push   $0x0
  pushl $97
  10204a:	6a 61                	push   $0x61
  jmp __alltraps
  10204c:	e9 0e 07 00 00       	jmp    10275f <__alltraps>

00102051 <vector98>:
.globl vector98
vector98:
  pushl $0
  102051:	6a 00                	push   $0x0
  pushl $98
  102053:	6a 62                	push   $0x62
  jmp __alltraps
  102055:	e9 05 07 00 00       	jmp    10275f <__alltraps>

0010205a <vector99>:
.globl vector99
vector99:
  pushl $0
  10205a:	6a 00                	push   $0x0
  pushl $99
  10205c:	6a 63                	push   $0x63
  jmp __alltraps
  10205e:	e9 fc 06 00 00       	jmp    10275f <__alltraps>

00102063 <vector100>:
.globl vector100
vector100:
  pushl $0
  102063:	6a 00                	push   $0x0
  pushl $100
  102065:	6a 64                	push   $0x64
  jmp __alltraps
  102067:	e9 f3 06 00 00       	jmp    10275f <__alltraps>

0010206c <vector101>:
.globl vector101
vector101:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $101
  10206e:	6a 65                	push   $0x65
  jmp __alltraps
  102070:	e9 ea 06 00 00       	jmp    10275f <__alltraps>

00102075 <vector102>:
.globl vector102
vector102:
  pushl $0
  102075:	6a 00                	push   $0x0
  pushl $102
  102077:	6a 66                	push   $0x66
  jmp __alltraps
  102079:	e9 e1 06 00 00       	jmp    10275f <__alltraps>

0010207e <vector103>:
.globl vector103
vector103:
  pushl $0
  10207e:	6a 00                	push   $0x0
  pushl $103
  102080:	6a 67                	push   $0x67
  jmp __alltraps
  102082:	e9 d8 06 00 00       	jmp    10275f <__alltraps>

00102087 <vector104>:
.globl vector104
vector104:
  pushl $0
  102087:	6a 00                	push   $0x0
  pushl $104
  102089:	6a 68                	push   $0x68
  jmp __alltraps
  10208b:	e9 cf 06 00 00       	jmp    10275f <__alltraps>

00102090 <vector105>:
.globl vector105
vector105:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $105
  102092:	6a 69                	push   $0x69
  jmp __alltraps
  102094:	e9 c6 06 00 00       	jmp    10275f <__alltraps>

00102099 <vector106>:
.globl vector106
vector106:
  pushl $0
  102099:	6a 00                	push   $0x0
  pushl $106
  10209b:	6a 6a                	push   $0x6a
  jmp __alltraps
  10209d:	e9 bd 06 00 00       	jmp    10275f <__alltraps>

001020a2 <vector107>:
.globl vector107
vector107:
  pushl $0
  1020a2:	6a 00                	push   $0x0
  pushl $107
  1020a4:	6a 6b                	push   $0x6b
  jmp __alltraps
  1020a6:	e9 b4 06 00 00       	jmp    10275f <__alltraps>

001020ab <vector108>:
.globl vector108
vector108:
  pushl $0
  1020ab:	6a 00                	push   $0x0
  pushl $108
  1020ad:	6a 6c                	push   $0x6c
  jmp __alltraps
  1020af:	e9 ab 06 00 00       	jmp    10275f <__alltraps>

001020b4 <vector109>:
.globl vector109
vector109:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $109
  1020b6:	6a 6d                	push   $0x6d
  jmp __alltraps
  1020b8:	e9 a2 06 00 00       	jmp    10275f <__alltraps>

001020bd <vector110>:
.globl vector110
vector110:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $110
  1020bf:	6a 6e                	push   $0x6e
  jmp __alltraps
  1020c1:	e9 99 06 00 00       	jmp    10275f <__alltraps>

001020c6 <vector111>:
.globl vector111
vector111:
  pushl $0
  1020c6:	6a 00                	push   $0x0
  pushl $111
  1020c8:	6a 6f                	push   $0x6f
  jmp __alltraps
  1020ca:	e9 90 06 00 00       	jmp    10275f <__alltraps>

001020cf <vector112>:
.globl vector112
vector112:
  pushl $0
  1020cf:	6a 00                	push   $0x0
  pushl $112
  1020d1:	6a 70                	push   $0x70
  jmp __alltraps
  1020d3:	e9 87 06 00 00       	jmp    10275f <__alltraps>

001020d8 <vector113>:
.globl vector113
vector113:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $113
  1020da:	6a 71                	push   $0x71
  jmp __alltraps
  1020dc:	e9 7e 06 00 00       	jmp    10275f <__alltraps>

001020e1 <vector114>:
.globl vector114
vector114:
  pushl $0
  1020e1:	6a 00                	push   $0x0
  pushl $114
  1020e3:	6a 72                	push   $0x72
  jmp __alltraps
  1020e5:	e9 75 06 00 00       	jmp    10275f <__alltraps>

001020ea <vector115>:
.globl vector115
vector115:
  pushl $0
  1020ea:	6a 00                	push   $0x0
  pushl $115
  1020ec:	6a 73                	push   $0x73
  jmp __alltraps
  1020ee:	e9 6c 06 00 00       	jmp    10275f <__alltraps>

001020f3 <vector116>:
.globl vector116
vector116:
  pushl $0
  1020f3:	6a 00                	push   $0x0
  pushl $116
  1020f5:	6a 74                	push   $0x74
  jmp __alltraps
  1020f7:	e9 63 06 00 00       	jmp    10275f <__alltraps>

001020fc <vector117>:
.globl vector117
vector117:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $117
  1020fe:	6a 75                	push   $0x75
  jmp __alltraps
  102100:	e9 5a 06 00 00       	jmp    10275f <__alltraps>

00102105 <vector118>:
.globl vector118
vector118:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $118
  102107:	6a 76                	push   $0x76
  jmp __alltraps
  102109:	e9 51 06 00 00       	jmp    10275f <__alltraps>

0010210e <vector119>:
.globl vector119
vector119:
  pushl $0
  10210e:	6a 00                	push   $0x0
  pushl $119
  102110:	6a 77                	push   $0x77
  jmp __alltraps
  102112:	e9 48 06 00 00       	jmp    10275f <__alltraps>

00102117 <vector120>:
.globl vector120
vector120:
  pushl $0
  102117:	6a 00                	push   $0x0
  pushl $120
  102119:	6a 78                	push   $0x78
  jmp __alltraps
  10211b:	e9 3f 06 00 00       	jmp    10275f <__alltraps>

00102120 <vector121>:
.globl vector121
vector121:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $121
  102122:	6a 79                	push   $0x79
  jmp __alltraps
  102124:	e9 36 06 00 00       	jmp    10275f <__alltraps>

00102129 <vector122>:
.globl vector122
vector122:
  pushl $0
  102129:	6a 00                	push   $0x0
  pushl $122
  10212b:	6a 7a                	push   $0x7a
  jmp __alltraps
  10212d:	e9 2d 06 00 00       	jmp    10275f <__alltraps>

00102132 <vector123>:
.globl vector123
vector123:
  pushl $0
  102132:	6a 00                	push   $0x0
  pushl $123
  102134:	6a 7b                	push   $0x7b
  jmp __alltraps
  102136:	e9 24 06 00 00       	jmp    10275f <__alltraps>

0010213b <vector124>:
.globl vector124
vector124:
  pushl $0
  10213b:	6a 00                	push   $0x0
  pushl $124
  10213d:	6a 7c                	push   $0x7c
  jmp __alltraps
  10213f:	e9 1b 06 00 00       	jmp    10275f <__alltraps>

00102144 <vector125>:
.globl vector125
vector125:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $125
  102146:	6a 7d                	push   $0x7d
  jmp __alltraps
  102148:	e9 12 06 00 00       	jmp    10275f <__alltraps>

0010214d <vector126>:
.globl vector126
vector126:
  pushl $0
  10214d:	6a 00                	push   $0x0
  pushl $126
  10214f:	6a 7e                	push   $0x7e
  jmp __alltraps
  102151:	e9 09 06 00 00       	jmp    10275f <__alltraps>

00102156 <vector127>:
.globl vector127
vector127:
  pushl $0
  102156:	6a 00                	push   $0x0
  pushl $127
  102158:	6a 7f                	push   $0x7f
  jmp __alltraps
  10215a:	e9 00 06 00 00       	jmp    10275f <__alltraps>

0010215f <vector128>:
.globl vector128
vector128:
  pushl $0
  10215f:	6a 00                	push   $0x0
  pushl $128
  102161:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102166:	e9 f4 05 00 00       	jmp    10275f <__alltraps>

0010216b <vector129>:
.globl vector129
vector129:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $129
  10216d:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102172:	e9 e8 05 00 00       	jmp    10275f <__alltraps>

00102177 <vector130>:
.globl vector130
vector130:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $130
  102179:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10217e:	e9 dc 05 00 00       	jmp    10275f <__alltraps>

00102183 <vector131>:
.globl vector131
vector131:
  pushl $0
  102183:	6a 00                	push   $0x0
  pushl $131
  102185:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10218a:	e9 d0 05 00 00       	jmp    10275f <__alltraps>

0010218f <vector132>:
.globl vector132
vector132:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $132
  102191:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102196:	e9 c4 05 00 00       	jmp    10275f <__alltraps>

0010219b <vector133>:
.globl vector133
vector133:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $133
  10219d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1021a2:	e9 b8 05 00 00       	jmp    10275f <__alltraps>

001021a7 <vector134>:
.globl vector134
vector134:
  pushl $0
  1021a7:	6a 00                	push   $0x0
  pushl $134
  1021a9:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1021ae:	e9 ac 05 00 00       	jmp    10275f <__alltraps>

001021b3 <vector135>:
.globl vector135
vector135:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $135
  1021b5:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1021ba:	e9 a0 05 00 00       	jmp    10275f <__alltraps>

001021bf <vector136>:
.globl vector136
vector136:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $136
  1021c1:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1021c6:	e9 94 05 00 00       	jmp    10275f <__alltraps>

001021cb <vector137>:
.globl vector137
vector137:
  pushl $0
  1021cb:	6a 00                	push   $0x0
  pushl $137
  1021cd:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1021d2:	e9 88 05 00 00       	jmp    10275f <__alltraps>

001021d7 <vector138>:
.globl vector138
vector138:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $138
  1021d9:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1021de:	e9 7c 05 00 00       	jmp    10275f <__alltraps>

001021e3 <vector139>:
.globl vector139
vector139:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $139
  1021e5:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1021ea:	e9 70 05 00 00       	jmp    10275f <__alltraps>

001021ef <vector140>:
.globl vector140
vector140:
  pushl $0
  1021ef:	6a 00                	push   $0x0
  pushl $140
  1021f1:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1021f6:	e9 64 05 00 00       	jmp    10275f <__alltraps>

001021fb <vector141>:
.globl vector141
vector141:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $141
  1021fd:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102202:	e9 58 05 00 00       	jmp    10275f <__alltraps>

00102207 <vector142>:
.globl vector142
vector142:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $142
  102209:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10220e:	e9 4c 05 00 00       	jmp    10275f <__alltraps>

00102213 <vector143>:
.globl vector143
vector143:
  pushl $0
  102213:	6a 00                	push   $0x0
  pushl $143
  102215:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10221a:	e9 40 05 00 00       	jmp    10275f <__alltraps>

0010221f <vector144>:
.globl vector144
vector144:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $144
  102221:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102226:	e9 34 05 00 00       	jmp    10275f <__alltraps>

0010222b <vector145>:
.globl vector145
vector145:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $145
  10222d:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102232:	e9 28 05 00 00       	jmp    10275f <__alltraps>

00102237 <vector146>:
.globl vector146
vector146:
  pushl $0
  102237:	6a 00                	push   $0x0
  pushl $146
  102239:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10223e:	e9 1c 05 00 00       	jmp    10275f <__alltraps>

00102243 <vector147>:
.globl vector147
vector147:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $147
  102245:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10224a:	e9 10 05 00 00       	jmp    10275f <__alltraps>

0010224f <vector148>:
.globl vector148
vector148:
  pushl $0
  10224f:	6a 00                	push   $0x0
  pushl $148
  102251:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102256:	e9 04 05 00 00       	jmp    10275f <__alltraps>

0010225b <vector149>:
.globl vector149
vector149:
  pushl $0
  10225b:	6a 00                	push   $0x0
  pushl $149
  10225d:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102262:	e9 f8 04 00 00       	jmp    10275f <__alltraps>

00102267 <vector150>:
.globl vector150
vector150:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $150
  102269:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10226e:	e9 ec 04 00 00       	jmp    10275f <__alltraps>

00102273 <vector151>:
.globl vector151
vector151:
  pushl $0
  102273:	6a 00                	push   $0x0
  pushl $151
  102275:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10227a:	e9 e0 04 00 00       	jmp    10275f <__alltraps>

0010227f <vector152>:
.globl vector152
vector152:
  pushl $0
  10227f:	6a 00                	push   $0x0
  pushl $152
  102281:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102286:	e9 d4 04 00 00       	jmp    10275f <__alltraps>

0010228b <vector153>:
.globl vector153
vector153:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $153
  10228d:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102292:	e9 c8 04 00 00       	jmp    10275f <__alltraps>

00102297 <vector154>:
.globl vector154
vector154:
  pushl $0
  102297:	6a 00                	push   $0x0
  pushl $154
  102299:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10229e:	e9 bc 04 00 00       	jmp    10275f <__alltraps>

001022a3 <vector155>:
.globl vector155
vector155:
  pushl $0
  1022a3:	6a 00                	push   $0x0
  pushl $155
  1022a5:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1022aa:	e9 b0 04 00 00       	jmp    10275f <__alltraps>

001022af <vector156>:
.globl vector156
vector156:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $156
  1022b1:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1022b6:	e9 a4 04 00 00       	jmp    10275f <__alltraps>

001022bb <vector157>:
.globl vector157
vector157:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $157
  1022bd:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1022c2:	e9 98 04 00 00       	jmp    10275f <__alltraps>

001022c7 <vector158>:
.globl vector158
vector158:
  pushl $0
  1022c7:	6a 00                	push   $0x0
  pushl $158
  1022c9:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1022ce:	e9 8c 04 00 00       	jmp    10275f <__alltraps>

001022d3 <vector159>:
.globl vector159
vector159:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $159
  1022d5:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1022da:	e9 80 04 00 00       	jmp    10275f <__alltraps>

001022df <vector160>:
.globl vector160
vector160:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $160
  1022e1:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1022e6:	e9 74 04 00 00       	jmp    10275f <__alltraps>

001022eb <vector161>:
.globl vector161
vector161:
  pushl $0
  1022eb:	6a 00                	push   $0x0
  pushl $161
  1022ed:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1022f2:	e9 68 04 00 00       	jmp    10275f <__alltraps>

001022f7 <vector162>:
.globl vector162
vector162:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $162
  1022f9:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1022fe:	e9 5c 04 00 00       	jmp    10275f <__alltraps>

00102303 <vector163>:
.globl vector163
vector163:
  pushl $0
  102303:	6a 00                	push   $0x0
  pushl $163
  102305:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10230a:	e9 50 04 00 00       	jmp    10275f <__alltraps>

0010230f <vector164>:
.globl vector164
vector164:
  pushl $0
  10230f:	6a 00                	push   $0x0
  pushl $164
  102311:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102316:	e9 44 04 00 00       	jmp    10275f <__alltraps>

0010231b <vector165>:
.globl vector165
vector165:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $165
  10231d:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102322:	e9 38 04 00 00       	jmp    10275f <__alltraps>

00102327 <vector166>:
.globl vector166
vector166:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $166
  102329:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10232e:	e9 2c 04 00 00       	jmp    10275f <__alltraps>

00102333 <vector167>:
.globl vector167
vector167:
  pushl $0
  102333:	6a 00                	push   $0x0
  pushl $167
  102335:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10233a:	e9 20 04 00 00       	jmp    10275f <__alltraps>

0010233f <vector168>:
.globl vector168
vector168:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $168
  102341:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102346:	e9 14 04 00 00       	jmp    10275f <__alltraps>

0010234b <vector169>:
.globl vector169
vector169:
  pushl $0
  10234b:	6a 00                	push   $0x0
  pushl $169
  10234d:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102352:	e9 08 04 00 00       	jmp    10275f <__alltraps>

00102357 <vector170>:
.globl vector170
vector170:
  pushl $0
  102357:	6a 00                	push   $0x0
  pushl $170
  102359:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10235e:	e9 fc 03 00 00       	jmp    10275f <__alltraps>

00102363 <vector171>:
.globl vector171
vector171:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $171
  102365:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10236a:	e9 f0 03 00 00       	jmp    10275f <__alltraps>

0010236f <vector172>:
.globl vector172
vector172:
  pushl $0
  10236f:	6a 00                	push   $0x0
  pushl $172
  102371:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102376:	e9 e4 03 00 00       	jmp    10275f <__alltraps>

0010237b <vector173>:
.globl vector173
vector173:
  pushl $0
  10237b:	6a 00                	push   $0x0
  pushl $173
  10237d:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102382:	e9 d8 03 00 00       	jmp    10275f <__alltraps>

00102387 <vector174>:
.globl vector174
vector174:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $174
  102389:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10238e:	e9 cc 03 00 00       	jmp    10275f <__alltraps>

00102393 <vector175>:
.globl vector175
vector175:
  pushl $0
  102393:	6a 00                	push   $0x0
  pushl $175
  102395:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10239a:	e9 c0 03 00 00       	jmp    10275f <__alltraps>

0010239f <vector176>:
.globl vector176
vector176:
  pushl $0
  10239f:	6a 00                	push   $0x0
  pushl $176
  1023a1:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1023a6:	e9 b4 03 00 00       	jmp    10275f <__alltraps>

001023ab <vector177>:
.globl vector177
vector177:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $177
  1023ad:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1023b2:	e9 a8 03 00 00       	jmp    10275f <__alltraps>

001023b7 <vector178>:
.globl vector178
vector178:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $178
  1023b9:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1023be:	e9 9c 03 00 00       	jmp    10275f <__alltraps>

001023c3 <vector179>:
.globl vector179
vector179:
  pushl $0
  1023c3:	6a 00                	push   $0x0
  pushl $179
  1023c5:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1023ca:	e9 90 03 00 00       	jmp    10275f <__alltraps>

001023cf <vector180>:
.globl vector180
vector180:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $180
  1023d1:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1023d6:	e9 84 03 00 00       	jmp    10275f <__alltraps>

001023db <vector181>:
.globl vector181
vector181:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $181
  1023dd:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1023e2:	e9 78 03 00 00       	jmp    10275f <__alltraps>

001023e7 <vector182>:
.globl vector182
vector182:
  pushl $0
  1023e7:	6a 00                	push   $0x0
  pushl $182
  1023e9:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1023ee:	e9 6c 03 00 00       	jmp    10275f <__alltraps>

001023f3 <vector183>:
.globl vector183
vector183:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $183
  1023f5:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1023fa:	e9 60 03 00 00       	jmp    10275f <__alltraps>

001023ff <vector184>:
.globl vector184
vector184:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $184
  102401:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102406:	e9 54 03 00 00       	jmp    10275f <__alltraps>

0010240b <vector185>:
.globl vector185
vector185:
  pushl $0
  10240b:	6a 00                	push   $0x0
  pushl $185
  10240d:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102412:	e9 48 03 00 00       	jmp    10275f <__alltraps>

00102417 <vector186>:
.globl vector186
vector186:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $186
  102419:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10241e:	e9 3c 03 00 00       	jmp    10275f <__alltraps>

00102423 <vector187>:
.globl vector187
vector187:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $187
  102425:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10242a:	e9 30 03 00 00       	jmp    10275f <__alltraps>

0010242f <vector188>:
.globl vector188
vector188:
  pushl $0
  10242f:	6a 00                	push   $0x0
  pushl $188
  102431:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102436:	e9 24 03 00 00       	jmp    10275f <__alltraps>

0010243b <vector189>:
.globl vector189
vector189:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $189
  10243d:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102442:	e9 18 03 00 00       	jmp    10275f <__alltraps>

00102447 <vector190>:
.globl vector190
vector190:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $190
  102449:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10244e:	e9 0c 03 00 00       	jmp    10275f <__alltraps>

00102453 <vector191>:
.globl vector191
vector191:
  pushl $0
  102453:	6a 00                	push   $0x0
  pushl $191
  102455:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10245a:	e9 00 03 00 00       	jmp    10275f <__alltraps>

0010245f <vector192>:
.globl vector192
vector192:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $192
  102461:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102466:	e9 f4 02 00 00       	jmp    10275f <__alltraps>

0010246b <vector193>:
.globl vector193
vector193:
  pushl $0
  10246b:	6a 00                	push   $0x0
  pushl $193
  10246d:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102472:	e9 e8 02 00 00       	jmp    10275f <__alltraps>

00102477 <vector194>:
.globl vector194
vector194:
  pushl $0
  102477:	6a 00                	push   $0x0
  pushl $194
  102479:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10247e:	e9 dc 02 00 00       	jmp    10275f <__alltraps>

00102483 <vector195>:
.globl vector195
vector195:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $195
  102485:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10248a:	e9 d0 02 00 00       	jmp    10275f <__alltraps>

0010248f <vector196>:
.globl vector196
vector196:
  pushl $0
  10248f:	6a 00                	push   $0x0
  pushl $196
  102491:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102496:	e9 c4 02 00 00       	jmp    10275f <__alltraps>

0010249b <vector197>:
.globl vector197
vector197:
  pushl $0
  10249b:	6a 00                	push   $0x0
  pushl $197
  10249d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1024a2:	e9 b8 02 00 00       	jmp    10275f <__alltraps>

001024a7 <vector198>:
.globl vector198
vector198:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $198
  1024a9:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1024ae:	e9 ac 02 00 00       	jmp    10275f <__alltraps>

001024b3 <vector199>:
.globl vector199
vector199:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $199
  1024b5:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1024ba:	e9 a0 02 00 00       	jmp    10275f <__alltraps>

001024bf <vector200>:
.globl vector200
vector200:
  pushl $0
  1024bf:	6a 00                	push   $0x0
  pushl $200
  1024c1:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1024c6:	e9 94 02 00 00       	jmp    10275f <__alltraps>

001024cb <vector201>:
.globl vector201
vector201:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $201
  1024cd:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1024d2:	e9 88 02 00 00       	jmp    10275f <__alltraps>

001024d7 <vector202>:
.globl vector202
vector202:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $202
  1024d9:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1024de:	e9 7c 02 00 00       	jmp    10275f <__alltraps>

001024e3 <vector203>:
.globl vector203
vector203:
  pushl $0
  1024e3:	6a 00                	push   $0x0
  pushl $203
  1024e5:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1024ea:	e9 70 02 00 00       	jmp    10275f <__alltraps>

001024ef <vector204>:
.globl vector204
vector204:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $204
  1024f1:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1024f6:	e9 64 02 00 00       	jmp    10275f <__alltraps>

001024fb <vector205>:
.globl vector205
vector205:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $205
  1024fd:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102502:	e9 58 02 00 00       	jmp    10275f <__alltraps>

00102507 <vector206>:
.globl vector206
vector206:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $206
  102509:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10250e:	e9 4c 02 00 00       	jmp    10275f <__alltraps>

00102513 <vector207>:
.globl vector207
vector207:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $207
  102515:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10251a:	e9 40 02 00 00       	jmp    10275f <__alltraps>

0010251f <vector208>:
.globl vector208
vector208:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $208
  102521:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102526:	e9 34 02 00 00       	jmp    10275f <__alltraps>

0010252b <vector209>:
.globl vector209
vector209:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $209
  10252d:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102532:	e9 28 02 00 00       	jmp    10275f <__alltraps>

00102537 <vector210>:
.globl vector210
vector210:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $210
  102539:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10253e:	e9 1c 02 00 00       	jmp    10275f <__alltraps>

00102543 <vector211>:
.globl vector211
vector211:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $211
  102545:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10254a:	e9 10 02 00 00       	jmp    10275f <__alltraps>

0010254f <vector212>:
.globl vector212
vector212:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $212
  102551:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102556:	e9 04 02 00 00       	jmp    10275f <__alltraps>

0010255b <vector213>:
.globl vector213
vector213:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $213
  10255d:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102562:	e9 f8 01 00 00       	jmp    10275f <__alltraps>

00102567 <vector214>:
.globl vector214
vector214:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $214
  102569:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10256e:	e9 ec 01 00 00       	jmp    10275f <__alltraps>

00102573 <vector215>:
.globl vector215
vector215:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $215
  102575:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10257a:	e9 e0 01 00 00       	jmp    10275f <__alltraps>

0010257f <vector216>:
.globl vector216
vector216:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $216
  102581:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102586:	e9 d4 01 00 00       	jmp    10275f <__alltraps>

0010258b <vector217>:
.globl vector217
vector217:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $217
  10258d:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102592:	e9 c8 01 00 00       	jmp    10275f <__alltraps>

00102597 <vector218>:
.globl vector218
vector218:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $218
  102599:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10259e:	e9 bc 01 00 00       	jmp    10275f <__alltraps>

001025a3 <vector219>:
.globl vector219
vector219:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $219
  1025a5:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1025aa:	e9 b0 01 00 00       	jmp    10275f <__alltraps>

001025af <vector220>:
.globl vector220
vector220:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $220
  1025b1:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1025b6:	e9 a4 01 00 00       	jmp    10275f <__alltraps>

001025bb <vector221>:
.globl vector221
vector221:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $221
  1025bd:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1025c2:	e9 98 01 00 00       	jmp    10275f <__alltraps>

001025c7 <vector222>:
.globl vector222
vector222:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $222
  1025c9:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1025ce:	e9 8c 01 00 00       	jmp    10275f <__alltraps>

001025d3 <vector223>:
.globl vector223
vector223:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $223
  1025d5:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1025da:	e9 80 01 00 00       	jmp    10275f <__alltraps>

001025df <vector224>:
.globl vector224
vector224:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $224
  1025e1:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1025e6:	e9 74 01 00 00       	jmp    10275f <__alltraps>

001025eb <vector225>:
.globl vector225
vector225:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $225
  1025ed:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1025f2:	e9 68 01 00 00       	jmp    10275f <__alltraps>

001025f7 <vector226>:
.globl vector226
vector226:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $226
  1025f9:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1025fe:	e9 5c 01 00 00       	jmp    10275f <__alltraps>

00102603 <vector227>:
.globl vector227
vector227:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $227
  102605:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10260a:	e9 50 01 00 00       	jmp    10275f <__alltraps>

0010260f <vector228>:
.globl vector228
vector228:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $228
  102611:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102616:	e9 44 01 00 00       	jmp    10275f <__alltraps>

0010261b <vector229>:
.globl vector229
vector229:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $229
  10261d:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102622:	e9 38 01 00 00       	jmp    10275f <__alltraps>

00102627 <vector230>:
.globl vector230
vector230:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $230
  102629:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10262e:	e9 2c 01 00 00       	jmp    10275f <__alltraps>

00102633 <vector231>:
.globl vector231
vector231:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $231
  102635:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10263a:	e9 20 01 00 00       	jmp    10275f <__alltraps>

0010263f <vector232>:
.globl vector232
vector232:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $232
  102641:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102646:	e9 14 01 00 00       	jmp    10275f <__alltraps>

0010264b <vector233>:
.globl vector233
vector233:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $233
  10264d:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102652:	e9 08 01 00 00       	jmp    10275f <__alltraps>

00102657 <vector234>:
.globl vector234
vector234:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $234
  102659:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10265e:	e9 fc 00 00 00       	jmp    10275f <__alltraps>

00102663 <vector235>:
.globl vector235
vector235:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $235
  102665:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10266a:	e9 f0 00 00 00       	jmp    10275f <__alltraps>

0010266f <vector236>:
.globl vector236
vector236:
  pushl $0
  10266f:	6a 00                	push   $0x0
  pushl $236
  102671:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102676:	e9 e4 00 00 00       	jmp    10275f <__alltraps>

0010267b <vector237>:
.globl vector237
vector237:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $237
  10267d:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102682:	e9 d8 00 00 00       	jmp    10275f <__alltraps>

00102687 <vector238>:
.globl vector238
vector238:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $238
  102689:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10268e:	e9 cc 00 00 00       	jmp    10275f <__alltraps>

00102693 <vector239>:
.globl vector239
vector239:
  pushl $0
  102693:	6a 00                	push   $0x0
  pushl $239
  102695:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10269a:	e9 c0 00 00 00       	jmp    10275f <__alltraps>

0010269f <vector240>:
.globl vector240
vector240:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $240
  1026a1:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1026a6:	e9 b4 00 00 00       	jmp    10275f <__alltraps>

001026ab <vector241>:
.globl vector241
vector241:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $241
  1026ad:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1026b2:	e9 a8 00 00 00       	jmp    10275f <__alltraps>

001026b7 <vector242>:
.globl vector242
vector242:
  pushl $0
  1026b7:	6a 00                	push   $0x0
  pushl $242
  1026b9:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1026be:	e9 9c 00 00 00       	jmp    10275f <__alltraps>

001026c3 <vector243>:
.globl vector243
vector243:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $243
  1026c5:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1026ca:	e9 90 00 00 00       	jmp    10275f <__alltraps>

001026cf <vector244>:
.globl vector244
vector244:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $244
  1026d1:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1026d6:	e9 84 00 00 00       	jmp    10275f <__alltraps>

001026db <vector245>:
.globl vector245
vector245:
  pushl $0
  1026db:	6a 00                	push   $0x0
  pushl $245
  1026dd:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1026e2:	e9 78 00 00 00       	jmp    10275f <__alltraps>

001026e7 <vector246>:
.globl vector246
vector246:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $246
  1026e9:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1026ee:	e9 6c 00 00 00       	jmp    10275f <__alltraps>

001026f3 <vector247>:
.globl vector247
vector247:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $247
  1026f5:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1026fa:	e9 60 00 00 00       	jmp    10275f <__alltraps>

001026ff <vector248>:
.globl vector248
vector248:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $248
  102701:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102706:	e9 54 00 00 00       	jmp    10275f <__alltraps>

0010270b <vector249>:
.globl vector249
vector249:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $249
  10270d:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102712:	e9 48 00 00 00       	jmp    10275f <__alltraps>

00102717 <vector250>:
.globl vector250
vector250:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $250
  102719:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10271e:	e9 3c 00 00 00       	jmp    10275f <__alltraps>

00102723 <vector251>:
.globl vector251
vector251:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $251
  102725:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10272a:	e9 30 00 00 00       	jmp    10275f <__alltraps>

0010272f <vector252>:
.globl vector252
vector252:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $252
  102731:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102736:	e9 24 00 00 00       	jmp    10275f <__alltraps>

0010273b <vector253>:
.globl vector253
vector253:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $253
  10273d:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102742:	e9 18 00 00 00       	jmp    10275f <__alltraps>

00102747 <vector254>:
.globl vector254
vector254:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $254
  102749:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10274e:	e9 0c 00 00 00       	jmp    10275f <__alltraps>

00102753 <vector255>:
.globl vector255
vector255:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $255
  102755:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10275a:	e9 00 00 00 00       	jmp    10275f <__alltraps>

0010275f <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10275f:	1e                   	push   %ds
    pushl %es
  102760:	06                   	push   %es
    pushl %fs
  102761:	0f a0                	push   %fs
    pushl %gs
  102763:	0f a8                	push   %gs
    pushal
  102765:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102766:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10276b:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10276d:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10276f:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102770:	e8 61 f5 ff ff       	call   101cd6 <trap>

    # pop the pushed stack pointer
    popl %esp
  102775:	5c                   	pop    %esp

00102776 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102776:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102777:	0f a9                	pop    %gs
    popl %fs
  102779:	0f a1                	pop    %fs
    popl %es
  10277b:	07                   	pop    %es
    popl %ds
  10277c:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10277d:	83 c4 08             	add    $0x8,%esp
    iret
  102780:	cf                   	iret   

00102781 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102781:	55                   	push   %ebp
  102782:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102784:	8b 45 08             	mov    0x8(%ebp),%eax
  102787:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10278a:	b8 23 00 00 00       	mov    $0x23,%eax
  10278f:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102791:	b8 23 00 00 00       	mov    $0x23,%eax
  102796:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102798:	b8 10 00 00 00       	mov    $0x10,%eax
  10279d:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10279f:	b8 10 00 00 00       	mov    $0x10,%eax
  1027a4:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1027a6:	b8 10 00 00 00       	mov    $0x10,%eax
  1027ab:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1027ad:	ea b4 27 10 00 08 00 	ljmp   $0x8,$0x1027b4
}
  1027b4:	90                   	nop
  1027b5:	5d                   	pop    %ebp
  1027b6:	c3                   	ret    

001027b7 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1027b7:	55                   	push   %ebp
  1027b8:	89 e5                	mov    %esp,%ebp
  1027ba:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1027bd:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  1027c2:	05 00 04 00 00       	add    $0x400,%eax
  1027c7:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1027cc:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1027d3:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1027d5:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1027dc:	68 00 
  1027de:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1027e3:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1027e9:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1027ee:	c1 e8 10             	shr    $0x10,%eax
  1027f1:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1027f6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1027fd:	83 e0 f0             	and    $0xfffffff0,%eax
  102800:	83 c8 09             	or     $0x9,%eax
  102803:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102808:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10280f:	83 c8 10             	or     $0x10,%eax
  102812:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102817:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10281e:	83 e0 9f             	and    $0xffffff9f,%eax
  102821:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102826:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10282d:	83 c8 80             	or     $0xffffff80,%eax
  102830:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102835:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10283c:	83 e0 f0             	and    $0xfffffff0,%eax
  10283f:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102844:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10284b:	83 e0 ef             	and    $0xffffffef,%eax
  10284e:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102853:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10285a:	83 e0 df             	and    $0xffffffdf,%eax
  10285d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102862:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102869:	83 c8 40             	or     $0x40,%eax
  10286c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102871:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102878:	83 e0 7f             	and    $0x7f,%eax
  10287b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102880:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102885:	c1 e8 18             	shr    $0x18,%eax
  102888:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  10288d:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102894:	83 e0 ef             	and    $0xffffffef,%eax
  102897:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  10289c:	68 10 ea 10 00       	push   $0x10ea10
  1028a1:	e8 db fe ff ff       	call   102781 <lgdt>
  1028a6:	83 c4 04             	add    $0x4,%esp
  1028a9:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  1028af:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1028b3:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1028b6:	90                   	nop
  1028b7:	c9                   	leave  
  1028b8:	c3                   	ret    

001028b9 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1028b9:	55                   	push   %ebp
  1028ba:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1028bc:	e8 f6 fe ff ff       	call   1027b7 <gdt_init>
}
  1028c1:	90                   	nop
  1028c2:	5d                   	pop    %ebp
  1028c3:	c3                   	ret    

001028c4 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1028c4:	55                   	push   %ebp
  1028c5:	89 e5                	mov    %esp,%ebp
  1028c7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1028ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1028d1:	eb 04                	jmp    1028d7 <strlen+0x13>
        cnt ++;
  1028d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1028d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1028da:	8d 50 01             	lea    0x1(%eax),%edx
  1028dd:	89 55 08             	mov    %edx,0x8(%ebp)
  1028e0:	0f b6 00             	movzbl (%eax),%eax
  1028e3:	84 c0                	test   %al,%al
  1028e5:	75 ec                	jne    1028d3 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  1028e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1028ea:	c9                   	leave  
  1028eb:	c3                   	ret    

001028ec <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1028ec:	55                   	push   %ebp
  1028ed:	89 e5                	mov    %esp,%ebp
  1028ef:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1028f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1028f9:	eb 04                	jmp    1028ff <strnlen+0x13>
        cnt ++;
  1028fb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  1028ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102902:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102905:	73 10                	jae    102917 <strnlen+0x2b>
  102907:	8b 45 08             	mov    0x8(%ebp),%eax
  10290a:	8d 50 01             	lea    0x1(%eax),%edx
  10290d:	89 55 08             	mov    %edx,0x8(%ebp)
  102910:	0f b6 00             	movzbl (%eax),%eax
  102913:	84 c0                	test   %al,%al
  102915:	75 e4                	jne    1028fb <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102917:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10291a:	c9                   	leave  
  10291b:	c3                   	ret    

0010291c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10291c:	55                   	push   %ebp
  10291d:	89 e5                	mov    %esp,%ebp
  10291f:	57                   	push   %edi
  102920:	56                   	push   %esi
  102921:	83 ec 20             	sub    $0x20,%esp
  102924:	8b 45 08             	mov    0x8(%ebp),%eax
  102927:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10292a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10292d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102930:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102936:	89 d1                	mov    %edx,%ecx
  102938:	89 c2                	mov    %eax,%edx
  10293a:	89 ce                	mov    %ecx,%esi
  10293c:	89 d7                	mov    %edx,%edi
  10293e:	ac                   	lods   %ds:(%esi),%al
  10293f:	aa                   	stos   %al,%es:(%edi)
  102940:	84 c0                	test   %al,%al
  102942:	75 fa                	jne    10293e <strcpy+0x22>
  102944:	89 fa                	mov    %edi,%edx
  102946:	89 f1                	mov    %esi,%ecx
  102948:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10294b:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10294e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102951:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102954:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102955:	83 c4 20             	add    $0x20,%esp
  102958:	5e                   	pop    %esi
  102959:	5f                   	pop    %edi
  10295a:	5d                   	pop    %ebp
  10295b:	c3                   	ret    

0010295c <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10295c:	55                   	push   %ebp
  10295d:	89 e5                	mov    %esp,%ebp
  10295f:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102962:	8b 45 08             	mov    0x8(%ebp),%eax
  102965:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102968:	eb 21                	jmp    10298b <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10296a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10296d:	0f b6 10             	movzbl (%eax),%edx
  102970:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102973:	88 10                	mov    %dl,(%eax)
  102975:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102978:	0f b6 00             	movzbl (%eax),%eax
  10297b:	84 c0                	test   %al,%al
  10297d:	74 04                	je     102983 <strncpy+0x27>
            src ++;
  10297f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102983:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102987:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  10298b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10298f:	75 d9                	jne    10296a <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  102991:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102994:	c9                   	leave  
  102995:	c3                   	ret    

00102996 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102996:	55                   	push   %ebp
  102997:	89 e5                	mov    %esp,%ebp
  102999:	57                   	push   %edi
  10299a:	56                   	push   %esi
  10299b:	83 ec 20             	sub    $0x20,%esp
  10299e:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1029aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1029ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029b0:	89 d1                	mov    %edx,%ecx
  1029b2:	89 c2                	mov    %eax,%edx
  1029b4:	89 ce                	mov    %ecx,%esi
  1029b6:	89 d7                	mov    %edx,%edi
  1029b8:	ac                   	lods   %ds:(%esi),%al
  1029b9:	ae                   	scas   %es:(%edi),%al
  1029ba:	75 08                	jne    1029c4 <strcmp+0x2e>
  1029bc:	84 c0                	test   %al,%al
  1029be:	75 f8                	jne    1029b8 <strcmp+0x22>
  1029c0:	31 c0                	xor    %eax,%eax
  1029c2:	eb 04                	jmp    1029c8 <strcmp+0x32>
  1029c4:	19 c0                	sbb    %eax,%eax
  1029c6:	0c 01                	or     $0x1,%al
  1029c8:	89 fa                	mov    %edi,%edx
  1029ca:	89 f1                	mov    %esi,%ecx
  1029cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1029cf:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1029d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1029d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  1029d8:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1029d9:	83 c4 20             	add    $0x20,%esp
  1029dc:	5e                   	pop    %esi
  1029dd:	5f                   	pop    %edi
  1029de:	5d                   	pop    %ebp
  1029df:	c3                   	ret    

001029e0 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1029e0:	55                   	push   %ebp
  1029e1:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1029e3:	eb 0c                	jmp    1029f1 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1029e5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1029e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1029ed:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1029f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1029f5:	74 1a                	je     102a11 <strncmp+0x31>
  1029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1029fa:	0f b6 00             	movzbl (%eax),%eax
  1029fd:	84 c0                	test   %al,%al
  1029ff:	74 10                	je     102a11 <strncmp+0x31>
  102a01:	8b 45 08             	mov    0x8(%ebp),%eax
  102a04:	0f b6 10             	movzbl (%eax),%edx
  102a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a0a:	0f b6 00             	movzbl (%eax),%eax
  102a0d:	38 c2                	cmp    %al,%dl
  102a0f:	74 d4                	je     1029e5 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102a11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a15:	74 18                	je     102a2f <strncmp+0x4f>
  102a17:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1a:	0f b6 00             	movzbl (%eax),%eax
  102a1d:	0f b6 d0             	movzbl %al,%edx
  102a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a23:	0f b6 00             	movzbl (%eax),%eax
  102a26:	0f b6 c0             	movzbl %al,%eax
  102a29:	29 c2                	sub    %eax,%edx
  102a2b:	89 d0                	mov    %edx,%eax
  102a2d:	eb 05                	jmp    102a34 <strncmp+0x54>
  102a2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102a34:	5d                   	pop    %ebp
  102a35:	c3                   	ret    

00102a36 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102a36:	55                   	push   %ebp
  102a37:	89 e5                	mov    %esp,%ebp
  102a39:	83 ec 04             	sub    $0x4,%esp
  102a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a3f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102a42:	eb 14                	jmp    102a58 <strchr+0x22>
        if (*s == c) {
  102a44:	8b 45 08             	mov    0x8(%ebp),%eax
  102a47:	0f b6 00             	movzbl (%eax),%eax
  102a4a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102a4d:	75 05                	jne    102a54 <strchr+0x1e>
            return (char *)s;
  102a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a52:	eb 13                	jmp    102a67 <strchr+0x31>
        }
        s ++;
  102a54:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102a58:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5b:	0f b6 00             	movzbl (%eax),%eax
  102a5e:	84 c0                	test   %al,%al
  102a60:	75 e2                	jne    102a44 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102a62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102a67:	c9                   	leave  
  102a68:	c3                   	ret    

00102a69 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102a69:	55                   	push   %ebp
  102a6a:	89 e5                	mov    %esp,%ebp
  102a6c:	83 ec 04             	sub    $0x4,%esp
  102a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a72:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102a75:	eb 0f                	jmp    102a86 <strfind+0x1d>
        if (*s == c) {
  102a77:	8b 45 08             	mov    0x8(%ebp),%eax
  102a7a:	0f b6 00             	movzbl (%eax),%eax
  102a7d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102a80:	74 10                	je     102a92 <strfind+0x29>
            break;
        }
        s ++;
  102a82:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102a86:	8b 45 08             	mov    0x8(%ebp),%eax
  102a89:	0f b6 00             	movzbl (%eax),%eax
  102a8c:	84 c0                	test   %al,%al
  102a8e:	75 e7                	jne    102a77 <strfind+0xe>
  102a90:	eb 01                	jmp    102a93 <strfind+0x2a>
        if (*s == c) {
            break;
  102a92:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  102a93:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102a96:	c9                   	leave  
  102a97:	c3                   	ret    

00102a98 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102a98:	55                   	push   %ebp
  102a99:	89 e5                	mov    %esp,%ebp
  102a9b:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102a9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102aa5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102aac:	eb 04                	jmp    102ab2 <strtol+0x1a>
        s ++;
  102aae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab5:	0f b6 00             	movzbl (%eax),%eax
  102ab8:	3c 20                	cmp    $0x20,%al
  102aba:	74 f2                	je     102aae <strtol+0x16>
  102abc:	8b 45 08             	mov    0x8(%ebp),%eax
  102abf:	0f b6 00             	movzbl (%eax),%eax
  102ac2:	3c 09                	cmp    $0x9,%al
  102ac4:	74 e8                	je     102aae <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  102ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac9:	0f b6 00             	movzbl (%eax),%eax
  102acc:	3c 2b                	cmp    $0x2b,%al
  102ace:	75 06                	jne    102ad6 <strtol+0x3e>
        s ++;
  102ad0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ad4:	eb 15                	jmp    102aeb <strtol+0x53>
    }
    else if (*s == '-') {
  102ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad9:	0f b6 00             	movzbl (%eax),%eax
  102adc:	3c 2d                	cmp    $0x2d,%al
  102ade:	75 0b                	jne    102aeb <strtol+0x53>
        s ++, neg = 1;
  102ae0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ae4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102aeb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102aef:	74 06                	je     102af7 <strtol+0x5f>
  102af1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102af5:	75 24                	jne    102b1b <strtol+0x83>
  102af7:	8b 45 08             	mov    0x8(%ebp),%eax
  102afa:	0f b6 00             	movzbl (%eax),%eax
  102afd:	3c 30                	cmp    $0x30,%al
  102aff:	75 1a                	jne    102b1b <strtol+0x83>
  102b01:	8b 45 08             	mov    0x8(%ebp),%eax
  102b04:	83 c0 01             	add    $0x1,%eax
  102b07:	0f b6 00             	movzbl (%eax),%eax
  102b0a:	3c 78                	cmp    $0x78,%al
  102b0c:	75 0d                	jne    102b1b <strtol+0x83>
        s += 2, base = 16;
  102b0e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102b12:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102b19:	eb 2a                	jmp    102b45 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102b1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b1f:	75 17                	jne    102b38 <strtol+0xa0>
  102b21:	8b 45 08             	mov    0x8(%ebp),%eax
  102b24:	0f b6 00             	movzbl (%eax),%eax
  102b27:	3c 30                	cmp    $0x30,%al
  102b29:	75 0d                	jne    102b38 <strtol+0xa0>
        s ++, base = 8;
  102b2b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b2f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102b36:	eb 0d                	jmp    102b45 <strtol+0xad>
    }
    else if (base == 0) {
  102b38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b3c:	75 07                	jne    102b45 <strtol+0xad>
        base = 10;
  102b3e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102b45:	8b 45 08             	mov    0x8(%ebp),%eax
  102b48:	0f b6 00             	movzbl (%eax),%eax
  102b4b:	3c 2f                	cmp    $0x2f,%al
  102b4d:	7e 1b                	jle    102b6a <strtol+0xd2>
  102b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b52:	0f b6 00             	movzbl (%eax),%eax
  102b55:	3c 39                	cmp    $0x39,%al
  102b57:	7f 11                	jg     102b6a <strtol+0xd2>
            dig = *s - '0';
  102b59:	8b 45 08             	mov    0x8(%ebp),%eax
  102b5c:	0f b6 00             	movzbl (%eax),%eax
  102b5f:	0f be c0             	movsbl %al,%eax
  102b62:	83 e8 30             	sub    $0x30,%eax
  102b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b68:	eb 48                	jmp    102bb2 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6d:	0f b6 00             	movzbl (%eax),%eax
  102b70:	3c 60                	cmp    $0x60,%al
  102b72:	7e 1b                	jle    102b8f <strtol+0xf7>
  102b74:	8b 45 08             	mov    0x8(%ebp),%eax
  102b77:	0f b6 00             	movzbl (%eax),%eax
  102b7a:	3c 7a                	cmp    $0x7a,%al
  102b7c:	7f 11                	jg     102b8f <strtol+0xf7>
            dig = *s - 'a' + 10;
  102b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b81:	0f b6 00             	movzbl (%eax),%eax
  102b84:	0f be c0             	movsbl %al,%eax
  102b87:	83 e8 57             	sub    $0x57,%eax
  102b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b8d:	eb 23                	jmp    102bb2 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b92:	0f b6 00             	movzbl (%eax),%eax
  102b95:	3c 40                	cmp    $0x40,%al
  102b97:	7e 3c                	jle    102bd5 <strtol+0x13d>
  102b99:	8b 45 08             	mov    0x8(%ebp),%eax
  102b9c:	0f b6 00             	movzbl (%eax),%eax
  102b9f:	3c 5a                	cmp    $0x5a,%al
  102ba1:	7f 32                	jg     102bd5 <strtol+0x13d>
            dig = *s - 'A' + 10;
  102ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba6:	0f b6 00             	movzbl (%eax),%eax
  102ba9:	0f be c0             	movsbl %al,%eax
  102bac:	83 e8 37             	sub    $0x37,%eax
  102baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bb5:	3b 45 10             	cmp    0x10(%ebp),%eax
  102bb8:	7d 1a                	jge    102bd4 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102bba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102bbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102bc1:	0f af 45 10          	imul   0x10(%ebp),%eax
  102bc5:	89 c2                	mov    %eax,%edx
  102bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bca:	01 d0                	add    %edx,%eax
  102bcc:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102bcf:	e9 71 ff ff ff       	jmp    102b45 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  102bd4:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  102bd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bd9:	74 08                	je     102be3 <strtol+0x14b>
        *endptr = (char *) s;
  102bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bde:	8b 55 08             	mov    0x8(%ebp),%edx
  102be1:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102be3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102be7:	74 07                	je     102bf0 <strtol+0x158>
  102be9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102bec:	f7 d8                	neg    %eax
  102bee:	eb 03                	jmp    102bf3 <strtol+0x15b>
  102bf0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102bf3:	c9                   	leave  
  102bf4:	c3                   	ret    

00102bf5 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102bf5:	55                   	push   %ebp
  102bf6:	89 e5                	mov    %esp,%ebp
  102bf8:	57                   	push   %edi
  102bf9:	83 ec 24             	sub    $0x24,%esp
  102bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bff:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102c02:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102c06:	8b 55 08             	mov    0x8(%ebp),%edx
  102c09:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102c0c:	88 45 f7             	mov    %al,-0x9(%ebp)
  102c0f:	8b 45 10             	mov    0x10(%ebp),%eax
  102c12:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102c15:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102c18:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102c1c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102c1f:	89 d7                	mov    %edx,%edi
  102c21:	f3 aa                	rep stos %al,%es:(%edi)
  102c23:	89 fa                	mov    %edi,%edx
  102c25:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102c28:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102c2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c2e:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102c2f:	83 c4 24             	add    $0x24,%esp
  102c32:	5f                   	pop    %edi
  102c33:	5d                   	pop    %ebp
  102c34:	c3                   	ret    

00102c35 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102c35:	55                   	push   %ebp
  102c36:	89 e5                	mov    %esp,%ebp
  102c38:	57                   	push   %edi
  102c39:	56                   	push   %esi
  102c3a:	53                   	push   %ebx
  102c3b:	83 ec 30             	sub    $0x30,%esp
  102c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  102c4d:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c53:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102c56:	73 42                	jae    102c9a <memmove+0x65>
  102c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102c5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c67:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102c6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c6d:	c1 e8 02             	shr    $0x2,%eax
  102c70:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102c72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102c75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c78:	89 d7                	mov    %edx,%edi
  102c7a:	89 c6                	mov    %eax,%esi
  102c7c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102c7e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102c81:	83 e1 03             	and    $0x3,%ecx
  102c84:	74 02                	je     102c88 <memmove+0x53>
  102c86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102c88:	89 f0                	mov    %esi,%eax
  102c8a:	89 fa                	mov    %edi,%edx
  102c8c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102c8f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102c92:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102c95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102c98:	eb 36                	jmp    102cd0 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102c9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ca3:	01 c2                	add    %eax,%edx
  102ca5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ca8:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cae:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  102cb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cb4:	89 c1                	mov    %eax,%ecx
  102cb6:	89 d8                	mov    %ebx,%eax
  102cb8:	89 d6                	mov    %edx,%esi
  102cba:	89 c7                	mov    %eax,%edi
  102cbc:	fd                   	std    
  102cbd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102cbf:	fc                   	cld    
  102cc0:	89 f8                	mov    %edi,%eax
  102cc2:	89 f2                	mov    %esi,%edx
  102cc4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102cc7:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102cca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  102ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102cd0:	83 c4 30             	add    $0x30,%esp
  102cd3:	5b                   	pop    %ebx
  102cd4:	5e                   	pop    %esi
  102cd5:	5f                   	pop    %edi
  102cd6:	5d                   	pop    %ebp
  102cd7:	c3                   	ret    

00102cd8 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102cd8:	55                   	push   %ebp
  102cd9:	89 e5                	mov    %esp,%ebp
  102cdb:	57                   	push   %edi
  102cdc:	56                   	push   %esi
  102cdd:	83 ec 20             	sub    $0x20,%esp
  102ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cec:	8b 45 10             	mov    0x10(%ebp),%eax
  102cef:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102cf5:	c1 e8 02             	shr    $0x2,%eax
  102cf8:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d00:	89 d7                	mov    %edx,%edi
  102d02:	89 c6                	mov    %eax,%esi
  102d04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102d06:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102d09:	83 e1 03             	and    $0x3,%ecx
  102d0c:	74 02                	je     102d10 <memcpy+0x38>
  102d0e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102d10:	89 f0                	mov    %esi,%eax
  102d12:	89 fa                	mov    %edi,%edx
  102d14:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d17:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102d1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102d20:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102d21:	83 c4 20             	add    $0x20,%esp
  102d24:	5e                   	pop    %esi
  102d25:	5f                   	pop    %edi
  102d26:	5d                   	pop    %ebp
  102d27:	c3                   	ret    

00102d28 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102d28:	55                   	push   %ebp
  102d29:	89 e5                	mov    %esp,%ebp
  102d2b:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d31:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d37:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102d3a:	eb 30                	jmp    102d6c <memcmp+0x44>
        if (*s1 != *s2) {
  102d3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d3f:	0f b6 10             	movzbl (%eax),%edx
  102d42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d45:	0f b6 00             	movzbl (%eax),%eax
  102d48:	38 c2                	cmp    %al,%dl
  102d4a:	74 18                	je     102d64 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102d4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d4f:	0f b6 00             	movzbl (%eax),%eax
  102d52:	0f b6 d0             	movzbl %al,%edx
  102d55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d58:	0f b6 00             	movzbl (%eax),%eax
  102d5b:	0f b6 c0             	movzbl %al,%eax
  102d5e:	29 c2                	sub    %eax,%edx
  102d60:	89 d0                	mov    %edx,%eax
  102d62:	eb 1a                	jmp    102d7e <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102d64:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102d68:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  102d6c:	8b 45 10             	mov    0x10(%ebp),%eax
  102d6f:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d72:	89 55 10             	mov    %edx,0x10(%ebp)
  102d75:	85 c0                	test   %eax,%eax
  102d77:	75 c3                	jne    102d3c <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  102d79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d7e:	c9                   	leave  
  102d7f:	c3                   	ret    

00102d80 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102d80:	55                   	push   %ebp
  102d81:	89 e5                	mov    %esp,%ebp
  102d83:	83 ec 38             	sub    $0x38,%esp
  102d86:	8b 45 10             	mov    0x10(%ebp),%eax
  102d89:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102d8c:	8b 45 14             	mov    0x14(%ebp),%eax
  102d8f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102d92:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d95:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102d98:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d9b:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102d9e:	8b 45 18             	mov    0x18(%ebp),%eax
  102da1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102da4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102da7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102daa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102dad:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102db6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102dba:	74 1c                	je     102dd8 <printnum+0x58>
  102dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dbf:	ba 00 00 00 00       	mov    $0x0,%edx
  102dc4:	f7 75 e4             	divl   -0x1c(%ebp)
  102dc7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dcd:	ba 00 00 00 00       	mov    $0x0,%edx
  102dd2:	f7 75 e4             	divl   -0x1c(%ebp)
  102dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ddb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102dde:	f7 75 e4             	divl   -0x1c(%ebp)
  102de1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102de4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102de7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ded:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102df0:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102df3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102df6:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102df9:	8b 45 18             	mov    0x18(%ebp),%eax
  102dfc:	ba 00 00 00 00       	mov    $0x0,%edx
  102e01:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102e04:	77 41                	ja     102e47 <printnum+0xc7>
  102e06:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102e09:	72 05                	jb     102e10 <printnum+0x90>
  102e0b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102e0e:	77 37                	ja     102e47 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102e10:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102e13:	83 e8 01             	sub    $0x1,%eax
  102e16:	83 ec 04             	sub    $0x4,%esp
  102e19:	ff 75 20             	pushl  0x20(%ebp)
  102e1c:	50                   	push   %eax
  102e1d:	ff 75 18             	pushl  0x18(%ebp)
  102e20:	ff 75 ec             	pushl  -0x14(%ebp)
  102e23:	ff 75 e8             	pushl  -0x18(%ebp)
  102e26:	ff 75 0c             	pushl  0xc(%ebp)
  102e29:	ff 75 08             	pushl  0x8(%ebp)
  102e2c:	e8 4f ff ff ff       	call   102d80 <printnum>
  102e31:	83 c4 20             	add    $0x20,%esp
  102e34:	eb 1b                	jmp    102e51 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102e36:	83 ec 08             	sub    $0x8,%esp
  102e39:	ff 75 0c             	pushl  0xc(%ebp)
  102e3c:	ff 75 20             	pushl  0x20(%ebp)
  102e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e42:	ff d0                	call   *%eax
  102e44:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102e47:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102e4b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102e4f:	7f e5                	jg     102e36 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102e51:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102e54:	05 30 3b 10 00       	add    $0x103b30,%eax
  102e59:	0f b6 00             	movzbl (%eax),%eax
  102e5c:	0f be c0             	movsbl %al,%eax
  102e5f:	83 ec 08             	sub    $0x8,%esp
  102e62:	ff 75 0c             	pushl  0xc(%ebp)
  102e65:	50                   	push   %eax
  102e66:	8b 45 08             	mov    0x8(%ebp),%eax
  102e69:	ff d0                	call   *%eax
  102e6b:	83 c4 10             	add    $0x10,%esp
}
  102e6e:	90                   	nop
  102e6f:	c9                   	leave  
  102e70:	c3                   	ret    

00102e71 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102e71:	55                   	push   %ebp
  102e72:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102e74:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102e78:	7e 14                	jle    102e8e <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7d:	8b 00                	mov    (%eax),%eax
  102e7f:	8d 48 08             	lea    0x8(%eax),%ecx
  102e82:	8b 55 08             	mov    0x8(%ebp),%edx
  102e85:	89 0a                	mov    %ecx,(%edx)
  102e87:	8b 50 04             	mov    0x4(%eax),%edx
  102e8a:	8b 00                	mov    (%eax),%eax
  102e8c:	eb 30                	jmp    102ebe <getuint+0x4d>
    }
    else if (lflag) {
  102e8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102e92:	74 16                	je     102eaa <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102e94:	8b 45 08             	mov    0x8(%ebp),%eax
  102e97:	8b 00                	mov    (%eax),%eax
  102e99:	8d 48 04             	lea    0x4(%eax),%ecx
  102e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  102e9f:	89 0a                	mov    %ecx,(%edx)
  102ea1:	8b 00                	mov    (%eax),%eax
  102ea3:	ba 00 00 00 00       	mov    $0x0,%edx
  102ea8:	eb 14                	jmp    102ebe <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  102ead:	8b 00                	mov    (%eax),%eax
  102eaf:	8d 48 04             	lea    0x4(%eax),%ecx
  102eb2:	8b 55 08             	mov    0x8(%ebp),%edx
  102eb5:	89 0a                	mov    %ecx,(%edx)
  102eb7:	8b 00                	mov    (%eax),%eax
  102eb9:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102ebe:	5d                   	pop    %ebp
  102ebf:	c3                   	ret    

00102ec0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102ec0:	55                   	push   %ebp
  102ec1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102ec3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102ec7:	7e 14                	jle    102edd <getint+0x1d>
        return va_arg(*ap, long long);
  102ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  102ecc:	8b 00                	mov    (%eax),%eax
  102ece:	8d 48 08             	lea    0x8(%eax),%ecx
  102ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  102ed4:	89 0a                	mov    %ecx,(%edx)
  102ed6:	8b 50 04             	mov    0x4(%eax),%edx
  102ed9:	8b 00                	mov    (%eax),%eax
  102edb:	eb 28                	jmp    102f05 <getint+0x45>
    }
    else if (lflag) {
  102edd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ee1:	74 12                	je     102ef5 <getint+0x35>
        return va_arg(*ap, long);
  102ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee6:	8b 00                	mov    (%eax),%eax
  102ee8:	8d 48 04             	lea    0x4(%eax),%ecx
  102eeb:	8b 55 08             	mov    0x8(%ebp),%edx
  102eee:	89 0a                	mov    %ecx,(%edx)
  102ef0:	8b 00                	mov    (%eax),%eax
  102ef2:	99                   	cltd   
  102ef3:	eb 10                	jmp    102f05 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef8:	8b 00                	mov    (%eax),%eax
  102efa:	8d 48 04             	lea    0x4(%eax),%ecx
  102efd:	8b 55 08             	mov    0x8(%ebp),%edx
  102f00:	89 0a                	mov    %ecx,(%edx)
  102f02:	8b 00                	mov    (%eax),%eax
  102f04:	99                   	cltd   
    }
}
  102f05:	5d                   	pop    %ebp
  102f06:	c3                   	ret    

00102f07 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102f07:	55                   	push   %ebp
  102f08:	89 e5                	mov    %esp,%ebp
  102f0a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  102f0d:	8d 45 14             	lea    0x14(%ebp),%eax
  102f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f16:	50                   	push   %eax
  102f17:	ff 75 10             	pushl  0x10(%ebp)
  102f1a:	ff 75 0c             	pushl  0xc(%ebp)
  102f1d:	ff 75 08             	pushl  0x8(%ebp)
  102f20:	e8 06 00 00 00       	call   102f2b <vprintfmt>
  102f25:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  102f28:	90                   	nop
  102f29:	c9                   	leave  
  102f2a:	c3                   	ret    

00102f2b <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102f2b:	55                   	push   %ebp
  102f2c:	89 e5                	mov    %esp,%ebp
  102f2e:	56                   	push   %esi
  102f2f:	53                   	push   %ebx
  102f30:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102f33:	eb 17                	jmp    102f4c <vprintfmt+0x21>
            if (ch == '\0') {
  102f35:	85 db                	test   %ebx,%ebx
  102f37:	0f 84 8e 03 00 00    	je     1032cb <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  102f3d:	83 ec 08             	sub    $0x8,%esp
  102f40:	ff 75 0c             	pushl  0xc(%ebp)
  102f43:	53                   	push   %ebx
  102f44:	8b 45 08             	mov    0x8(%ebp),%eax
  102f47:	ff d0                	call   *%eax
  102f49:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102f4c:	8b 45 10             	mov    0x10(%ebp),%eax
  102f4f:	8d 50 01             	lea    0x1(%eax),%edx
  102f52:	89 55 10             	mov    %edx,0x10(%ebp)
  102f55:	0f b6 00             	movzbl (%eax),%eax
  102f58:	0f b6 d8             	movzbl %al,%ebx
  102f5b:	83 fb 25             	cmp    $0x25,%ebx
  102f5e:	75 d5                	jne    102f35 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102f60:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102f64:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102f6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102f6e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102f71:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f7b:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102f7e:	8b 45 10             	mov    0x10(%ebp),%eax
  102f81:	8d 50 01             	lea    0x1(%eax),%edx
  102f84:	89 55 10             	mov    %edx,0x10(%ebp)
  102f87:	0f b6 00             	movzbl (%eax),%eax
  102f8a:	0f b6 d8             	movzbl %al,%ebx
  102f8d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102f90:	83 f8 55             	cmp    $0x55,%eax
  102f93:	0f 87 05 03 00 00    	ja     10329e <vprintfmt+0x373>
  102f99:	8b 04 85 54 3b 10 00 	mov    0x103b54(,%eax,4),%eax
  102fa0:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102fa2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102fa6:	eb d6                	jmp    102f7e <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102fa8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102fac:	eb d0                	jmp    102f7e <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102fae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102fb5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102fb8:	89 d0                	mov    %edx,%eax
  102fba:	c1 e0 02             	shl    $0x2,%eax
  102fbd:	01 d0                	add    %edx,%eax
  102fbf:	01 c0                	add    %eax,%eax
  102fc1:	01 d8                	add    %ebx,%eax
  102fc3:	83 e8 30             	sub    $0x30,%eax
  102fc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  102fcc:	0f b6 00             	movzbl (%eax),%eax
  102fcf:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102fd2:	83 fb 2f             	cmp    $0x2f,%ebx
  102fd5:	7e 39                	jle    103010 <vprintfmt+0xe5>
  102fd7:	83 fb 39             	cmp    $0x39,%ebx
  102fda:	7f 34                	jg     103010 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102fdc:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102fe0:	eb d3                	jmp    102fb5 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102fe2:	8b 45 14             	mov    0x14(%ebp),%eax
  102fe5:	8d 50 04             	lea    0x4(%eax),%edx
  102fe8:	89 55 14             	mov    %edx,0x14(%ebp)
  102feb:	8b 00                	mov    (%eax),%eax
  102fed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102ff0:	eb 1f                	jmp    103011 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  102ff2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ff6:	79 86                	jns    102f7e <vprintfmt+0x53>
                width = 0;
  102ff8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102fff:	e9 7a ff ff ff       	jmp    102f7e <vprintfmt+0x53>

        case '#':
            altflag = 1;
  103004:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10300b:	e9 6e ff ff ff       	jmp    102f7e <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  103010:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  103011:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103015:	0f 89 63 ff ff ff    	jns    102f7e <vprintfmt+0x53>
                width = precision, precision = -1;
  10301b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10301e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103021:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103028:	e9 51 ff ff ff       	jmp    102f7e <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10302d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  103031:	e9 48 ff ff ff       	jmp    102f7e <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103036:	8b 45 14             	mov    0x14(%ebp),%eax
  103039:	8d 50 04             	lea    0x4(%eax),%edx
  10303c:	89 55 14             	mov    %edx,0x14(%ebp)
  10303f:	8b 00                	mov    (%eax),%eax
  103041:	83 ec 08             	sub    $0x8,%esp
  103044:	ff 75 0c             	pushl  0xc(%ebp)
  103047:	50                   	push   %eax
  103048:	8b 45 08             	mov    0x8(%ebp),%eax
  10304b:	ff d0                	call   *%eax
  10304d:	83 c4 10             	add    $0x10,%esp
            break;
  103050:	e9 71 02 00 00       	jmp    1032c6 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103055:	8b 45 14             	mov    0x14(%ebp),%eax
  103058:	8d 50 04             	lea    0x4(%eax),%edx
  10305b:	89 55 14             	mov    %edx,0x14(%ebp)
  10305e:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103060:	85 db                	test   %ebx,%ebx
  103062:	79 02                	jns    103066 <vprintfmt+0x13b>
                err = -err;
  103064:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103066:	83 fb 06             	cmp    $0x6,%ebx
  103069:	7f 0b                	jg     103076 <vprintfmt+0x14b>
  10306b:	8b 34 9d 14 3b 10 00 	mov    0x103b14(,%ebx,4),%esi
  103072:	85 f6                	test   %esi,%esi
  103074:	75 19                	jne    10308f <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  103076:	53                   	push   %ebx
  103077:	68 41 3b 10 00       	push   $0x103b41
  10307c:	ff 75 0c             	pushl  0xc(%ebp)
  10307f:	ff 75 08             	pushl  0x8(%ebp)
  103082:	e8 80 fe ff ff       	call   102f07 <printfmt>
  103087:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10308a:	e9 37 02 00 00       	jmp    1032c6 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  10308f:	56                   	push   %esi
  103090:	68 4a 3b 10 00       	push   $0x103b4a
  103095:	ff 75 0c             	pushl  0xc(%ebp)
  103098:	ff 75 08             	pushl  0x8(%ebp)
  10309b:	e8 67 fe ff ff       	call   102f07 <printfmt>
  1030a0:	83 c4 10             	add    $0x10,%esp
            }
            break;
  1030a3:	e9 1e 02 00 00       	jmp    1032c6 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1030a8:	8b 45 14             	mov    0x14(%ebp),%eax
  1030ab:	8d 50 04             	lea    0x4(%eax),%edx
  1030ae:	89 55 14             	mov    %edx,0x14(%ebp)
  1030b1:	8b 30                	mov    (%eax),%esi
  1030b3:	85 f6                	test   %esi,%esi
  1030b5:	75 05                	jne    1030bc <vprintfmt+0x191>
                p = "(null)";
  1030b7:	be 4d 3b 10 00       	mov    $0x103b4d,%esi
            }
            if (width > 0 && padc != '-') {
  1030bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1030c0:	7e 76                	jle    103138 <vprintfmt+0x20d>
  1030c2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1030c6:	74 70                	je     103138 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1030c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030cb:	83 ec 08             	sub    $0x8,%esp
  1030ce:	50                   	push   %eax
  1030cf:	56                   	push   %esi
  1030d0:	e8 17 f8 ff ff       	call   1028ec <strnlen>
  1030d5:	83 c4 10             	add    $0x10,%esp
  1030d8:	89 c2                	mov    %eax,%edx
  1030da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030dd:	29 d0                	sub    %edx,%eax
  1030df:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030e2:	eb 17                	jmp    1030fb <vprintfmt+0x1d0>
                    putch(padc, putdat);
  1030e4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1030e8:	83 ec 08             	sub    $0x8,%esp
  1030eb:	ff 75 0c             	pushl  0xc(%ebp)
  1030ee:	50                   	push   %eax
  1030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f2:	ff d0                	call   *%eax
  1030f4:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1030f7:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1030fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1030ff:	7f e3                	jg     1030e4 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103101:	eb 35                	jmp    103138 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  103103:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103107:	74 1c                	je     103125 <vprintfmt+0x1fa>
  103109:	83 fb 1f             	cmp    $0x1f,%ebx
  10310c:	7e 05                	jle    103113 <vprintfmt+0x1e8>
  10310e:	83 fb 7e             	cmp    $0x7e,%ebx
  103111:	7e 12                	jle    103125 <vprintfmt+0x1fa>
                    putch('?', putdat);
  103113:	83 ec 08             	sub    $0x8,%esp
  103116:	ff 75 0c             	pushl  0xc(%ebp)
  103119:	6a 3f                	push   $0x3f
  10311b:	8b 45 08             	mov    0x8(%ebp),%eax
  10311e:	ff d0                	call   *%eax
  103120:	83 c4 10             	add    $0x10,%esp
  103123:	eb 0f                	jmp    103134 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  103125:	83 ec 08             	sub    $0x8,%esp
  103128:	ff 75 0c             	pushl  0xc(%ebp)
  10312b:	53                   	push   %ebx
  10312c:	8b 45 08             	mov    0x8(%ebp),%eax
  10312f:	ff d0                	call   *%eax
  103131:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103134:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103138:	89 f0                	mov    %esi,%eax
  10313a:	8d 70 01             	lea    0x1(%eax),%esi
  10313d:	0f b6 00             	movzbl (%eax),%eax
  103140:	0f be d8             	movsbl %al,%ebx
  103143:	85 db                	test   %ebx,%ebx
  103145:	74 26                	je     10316d <vprintfmt+0x242>
  103147:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10314b:	78 b6                	js     103103 <vprintfmt+0x1d8>
  10314d:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  103151:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103155:	79 ac                	jns    103103 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  103157:	eb 14                	jmp    10316d <vprintfmt+0x242>
                putch(' ', putdat);
  103159:	83 ec 08             	sub    $0x8,%esp
  10315c:	ff 75 0c             	pushl  0xc(%ebp)
  10315f:	6a 20                	push   $0x20
  103161:	8b 45 08             	mov    0x8(%ebp),%eax
  103164:	ff d0                	call   *%eax
  103166:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  103169:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10316d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103171:	7f e6                	jg     103159 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  103173:	e9 4e 01 00 00       	jmp    1032c6 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103178:	83 ec 08             	sub    $0x8,%esp
  10317b:	ff 75 e0             	pushl  -0x20(%ebp)
  10317e:	8d 45 14             	lea    0x14(%ebp),%eax
  103181:	50                   	push   %eax
  103182:	e8 39 fd ff ff       	call   102ec0 <getint>
  103187:	83 c4 10             	add    $0x10,%esp
  10318a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10318d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103193:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103196:	85 d2                	test   %edx,%edx
  103198:	79 23                	jns    1031bd <vprintfmt+0x292>
                putch('-', putdat);
  10319a:	83 ec 08             	sub    $0x8,%esp
  10319d:	ff 75 0c             	pushl  0xc(%ebp)
  1031a0:	6a 2d                	push   $0x2d
  1031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a5:	ff d0                	call   *%eax
  1031a7:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  1031aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031b0:	f7 d8                	neg    %eax
  1031b2:	83 d2 00             	adc    $0x0,%edx
  1031b5:	f7 da                	neg    %edx
  1031b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1031bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1031c4:	e9 9f 00 00 00       	jmp    103268 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1031c9:	83 ec 08             	sub    $0x8,%esp
  1031cc:	ff 75 e0             	pushl  -0x20(%ebp)
  1031cf:	8d 45 14             	lea    0x14(%ebp),%eax
  1031d2:	50                   	push   %eax
  1031d3:	e8 99 fc ff ff       	call   102e71 <getuint>
  1031d8:	83 c4 10             	add    $0x10,%esp
  1031db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031de:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1031e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1031e8:	eb 7e                	jmp    103268 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1031ea:	83 ec 08             	sub    $0x8,%esp
  1031ed:	ff 75 e0             	pushl  -0x20(%ebp)
  1031f0:	8d 45 14             	lea    0x14(%ebp),%eax
  1031f3:	50                   	push   %eax
  1031f4:	e8 78 fc ff ff       	call   102e71 <getuint>
  1031f9:	83 c4 10             	add    $0x10,%esp
  1031fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103202:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103209:	eb 5d                	jmp    103268 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  10320b:	83 ec 08             	sub    $0x8,%esp
  10320e:	ff 75 0c             	pushl  0xc(%ebp)
  103211:	6a 30                	push   $0x30
  103213:	8b 45 08             	mov    0x8(%ebp),%eax
  103216:	ff d0                	call   *%eax
  103218:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  10321b:	83 ec 08             	sub    $0x8,%esp
  10321e:	ff 75 0c             	pushl  0xc(%ebp)
  103221:	6a 78                	push   $0x78
  103223:	8b 45 08             	mov    0x8(%ebp),%eax
  103226:	ff d0                	call   *%eax
  103228:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10322b:	8b 45 14             	mov    0x14(%ebp),%eax
  10322e:	8d 50 04             	lea    0x4(%eax),%edx
  103231:	89 55 14             	mov    %edx,0x14(%ebp)
  103234:	8b 00                	mov    (%eax),%eax
  103236:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103239:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103240:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103247:	eb 1f                	jmp    103268 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103249:	83 ec 08             	sub    $0x8,%esp
  10324c:	ff 75 e0             	pushl  -0x20(%ebp)
  10324f:	8d 45 14             	lea    0x14(%ebp),%eax
  103252:	50                   	push   %eax
  103253:	e8 19 fc ff ff       	call   102e71 <getuint>
  103258:	83 c4 10             	add    $0x10,%esp
  10325b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10325e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103261:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103268:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10326c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10326f:	83 ec 04             	sub    $0x4,%esp
  103272:	52                   	push   %edx
  103273:	ff 75 e8             	pushl  -0x18(%ebp)
  103276:	50                   	push   %eax
  103277:	ff 75 f4             	pushl  -0xc(%ebp)
  10327a:	ff 75 f0             	pushl  -0x10(%ebp)
  10327d:	ff 75 0c             	pushl  0xc(%ebp)
  103280:	ff 75 08             	pushl  0x8(%ebp)
  103283:	e8 f8 fa ff ff       	call   102d80 <printnum>
  103288:	83 c4 20             	add    $0x20,%esp
            break;
  10328b:	eb 39                	jmp    1032c6 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10328d:	83 ec 08             	sub    $0x8,%esp
  103290:	ff 75 0c             	pushl  0xc(%ebp)
  103293:	53                   	push   %ebx
  103294:	8b 45 08             	mov    0x8(%ebp),%eax
  103297:	ff d0                	call   *%eax
  103299:	83 c4 10             	add    $0x10,%esp
            break;
  10329c:	eb 28                	jmp    1032c6 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10329e:	83 ec 08             	sub    $0x8,%esp
  1032a1:	ff 75 0c             	pushl  0xc(%ebp)
  1032a4:	6a 25                	push   $0x25
  1032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a9:	ff d0                	call   *%eax
  1032ab:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  1032ae:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1032b2:	eb 04                	jmp    1032b8 <vprintfmt+0x38d>
  1032b4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1032b8:	8b 45 10             	mov    0x10(%ebp),%eax
  1032bb:	83 e8 01             	sub    $0x1,%eax
  1032be:	0f b6 00             	movzbl (%eax),%eax
  1032c1:	3c 25                	cmp    $0x25,%al
  1032c3:	75 ef                	jne    1032b4 <vprintfmt+0x389>
                /* do nothing */;
            break;
  1032c5:	90                   	nop
        }
    }
  1032c6:	e9 68 fc ff ff       	jmp    102f33 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  1032cb:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1032cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1032cf:	5b                   	pop    %ebx
  1032d0:	5e                   	pop    %esi
  1032d1:	5d                   	pop    %ebp
  1032d2:	c3                   	ret    

001032d3 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1032d3:	55                   	push   %ebp
  1032d4:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1032d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032d9:	8b 40 08             	mov    0x8(%eax),%eax
  1032dc:	8d 50 01             	lea    0x1(%eax),%edx
  1032df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032e2:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1032e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032e8:	8b 10                	mov    (%eax),%edx
  1032ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032ed:	8b 40 04             	mov    0x4(%eax),%eax
  1032f0:	39 c2                	cmp    %eax,%edx
  1032f2:	73 12                	jae    103306 <sprintputch+0x33>
        *b->buf ++ = ch;
  1032f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032f7:	8b 00                	mov    (%eax),%eax
  1032f9:	8d 48 01             	lea    0x1(%eax),%ecx
  1032fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1032ff:	89 0a                	mov    %ecx,(%edx)
  103301:	8b 55 08             	mov    0x8(%ebp),%edx
  103304:	88 10                	mov    %dl,(%eax)
    }
}
  103306:	90                   	nop
  103307:	5d                   	pop    %ebp
  103308:	c3                   	ret    

00103309 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103309:	55                   	push   %ebp
  10330a:	89 e5                	mov    %esp,%ebp
  10330c:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10330f:	8d 45 14             	lea    0x14(%ebp),%eax
  103312:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103318:	50                   	push   %eax
  103319:	ff 75 10             	pushl  0x10(%ebp)
  10331c:	ff 75 0c             	pushl  0xc(%ebp)
  10331f:	ff 75 08             	pushl  0x8(%ebp)
  103322:	e8 0b 00 00 00       	call   103332 <vsnprintf>
  103327:	83 c4 10             	add    $0x10,%esp
  10332a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10332d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103330:	c9                   	leave  
  103331:	c3                   	ret    

00103332 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103332:	55                   	push   %ebp
  103333:	89 e5                	mov    %esp,%ebp
  103335:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103338:	8b 45 08             	mov    0x8(%ebp),%eax
  10333b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10333e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103341:	8d 50 ff             	lea    -0x1(%eax),%edx
  103344:	8b 45 08             	mov    0x8(%ebp),%eax
  103347:	01 d0                	add    %edx,%eax
  103349:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10334c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103353:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103357:	74 0a                	je     103363 <vsnprintf+0x31>
  103359:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10335c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10335f:	39 c2                	cmp    %eax,%edx
  103361:	76 07                	jbe    10336a <vsnprintf+0x38>
        return -E_INVAL;
  103363:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103368:	eb 20                	jmp    10338a <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10336a:	ff 75 14             	pushl  0x14(%ebp)
  10336d:	ff 75 10             	pushl  0x10(%ebp)
  103370:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103373:	50                   	push   %eax
  103374:	68 d3 32 10 00       	push   $0x1032d3
  103379:	e8 ad fb ff ff       	call   102f2b <vprintfmt>
  10337e:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  103381:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103384:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103387:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10338a:	c9                   	leave  
  10338b:	c3                   	ret    
