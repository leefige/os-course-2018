
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
  10001f:	e8 ed 29 00 00       	call   102a11 <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 5e 14 00 00       	call   10148a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 c0 31 10 00 	movl   $0x1031c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 dc 31 10 00       	push   $0x1031dc
  10003e:	e8 fa 01 00 00       	call   10023d <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 7c 08 00 00       	call   1008c7 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 74 00 00 00       	call   1000c4 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 80 26 00 00       	call   1026d5 <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 73 15 00 00       	call   1015cd <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 d4 16 00 00       	call   101733 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 0b 0c 00 00       	call   100c6f <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 a1 16 00 00       	call   10170a <intr_enable>
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
  10007a:	e8 de 0b 00 00       	call   100c5d <mon_backtrace>
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
  10010d:	68 e1 31 10 00       	push   $0x1031e1
  100112:	e8 26 01 00 00       	call   10023d <cprintf>
  100117:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011e:	0f b7 d0             	movzwl %ax,%edx
  100121:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100126:	83 ec 04             	sub    $0x4,%esp
  100129:	52                   	push   %edx
  10012a:	50                   	push   %eax
  10012b:	68 ef 31 10 00       	push   $0x1031ef
  100130:	e8 08 01 00 00       	call   10023d <cprintf>
  100135:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100138:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10013c:	0f b7 d0             	movzwl %ax,%edx
  10013f:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100144:	83 ec 04             	sub    $0x4,%esp
  100147:	52                   	push   %edx
  100148:	50                   	push   %eax
  100149:	68 fd 31 10 00       	push   $0x1031fd
  10014e:	e8 ea 00 00 00       	call   10023d <cprintf>
  100153:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100156:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015a:	0f b7 d0             	movzwl %ax,%edx
  10015d:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100162:	83 ec 04             	sub    $0x4,%esp
  100165:	52                   	push   %edx
  100166:	50                   	push   %eax
  100167:	68 0b 32 10 00       	push   $0x10320b
  10016c:	e8 cc 00 00 00       	call   10023d <cprintf>
  100171:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100174:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100178:	0f b7 d0             	movzwl %ax,%edx
  10017b:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100180:	83 ec 04             	sub    $0x4,%esp
  100183:	52                   	push   %edx
  100184:	50                   	push   %eax
  100185:	68 19 32 10 00       	push   $0x103219
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
  1001bc:	68 28 32 10 00       	push   $0x103228
  1001c1:	e8 77 00 00 00       	call   10023d <cprintf>
  1001c6:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001c9:	e8 d4 ff ff ff       	call   1001a2 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ce:	e8 12 ff ff ff       	call   1000e5 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001d3:	83 ec 0c             	sub    $0xc,%esp
  1001d6:	68 48 32 10 00       	push   $0x103248
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
  1001fc:	e8 ba 12 00 00       	call   1014bb <cons_putc>
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
  100230:	e8 12 2b 00 00       	call   102d47 <vprintfmt>
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
  10026f:	e8 47 12 00 00       	call   1014bb <cons_putc>
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
  1002ce:	e8 18 12 00 00       	call   1014eb <cons_getc>
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
  1002f3:	68 67 32 10 00       	push   $0x103267
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
  1003cb:	68 6a 32 10 00       	push   $0x10326a
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
  1003ed:	68 86 32 10 00       	push   $0x103286
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
  1003fd:	e8 0f 13 00 00       	call   101711 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100402:	83 ec 0c             	sub    $0xc,%esp
  100405:	6a 00                	push   $0x0
  100407:	e8 77 07 00 00       	call   100b83 <kmonitor>
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
  100426:	68 88 32 10 00       	push   $0x103288
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
  100448:	68 86 32 10 00       	push   $0x103286
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
  1005c2:	c7 00 a8 32 10 00    	movl   $0x1032a8,(%eax)
    info->eip_line = 0;
  1005c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d5:	c7 40 08 a8 32 10 00 	movl   $0x1032a8,0x8(%eax)
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
  1005f9:	c7 45 f4 8c 3a 10 00 	movl   $0x103a8c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100600:	c7 45 f0 cc b1 10 00 	movl   $0x10b1cc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100607:	c7 45 ec cd b1 10 00 	movl   $0x10b1cd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10060e:	c7 45 e8 e4 d1 10 00 	movl   $0x10d1e4,-0x18(%ebp)

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
  100748:	e8 38 21 00 00       	call   102885 <strfind>
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
  1008d0:	68 b2 32 10 00       	push   $0x1032b2
  1008d5:	e8 63 f9 ff ff       	call   10023d <cprintf>
  1008da:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008dd:	83 ec 08             	sub    $0x8,%esp
  1008e0:	68 00 00 10 00       	push   $0x100000
  1008e5:	68 cb 32 10 00       	push   $0x1032cb
  1008ea:	e8 4e f9 ff ff       	call   10023d <cprintf>
  1008ef:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008f2:	83 ec 08             	sub    $0x8,%esp
  1008f5:	68 a8 31 10 00       	push   $0x1031a8
  1008fa:	68 e3 32 10 00       	push   $0x1032e3
  1008ff:	e8 39 f9 ff ff       	call   10023d <cprintf>
  100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100907:	83 ec 08             	sub    $0x8,%esp
  10090a:	68 16 ea 10 00       	push   $0x10ea16
  10090f:	68 fb 32 10 00       	push   $0x1032fb
  100914:	e8 24 f9 ff ff       	call   10023d <cprintf>
  100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10091c:	83 ec 08             	sub    $0x8,%esp
  10091f:	68 20 fd 10 00       	push   $0x10fd20
  100924:	68 13 33 10 00       	push   $0x103313
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
  100954:	68 2c 33 10 00       	push   $0x10332c
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
  100989:	68 56 33 10 00       	push   $0x103356
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
  1009f0:	68 72 33 10 00       	push   $0x103372
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
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100a14:	90                   	nop
  100a15:	5d                   	pop    %ebp
  100a16:	c3                   	ret    

00100a17 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a17:	55                   	push   %ebp
  100a18:	89 e5                	mov    %esp,%ebp
  100a1a:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100a1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a24:	eb 0c                	jmp    100a32 <parse+0x1b>
            *buf ++ = '\0';
  100a26:	8b 45 08             	mov    0x8(%ebp),%eax
  100a29:	8d 50 01             	lea    0x1(%eax),%edx
  100a2c:	89 55 08             	mov    %edx,0x8(%ebp)
  100a2f:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a32:	8b 45 08             	mov    0x8(%ebp),%eax
  100a35:	0f b6 00             	movzbl (%eax),%eax
  100a38:	84 c0                	test   %al,%al
  100a3a:	74 1e                	je     100a5a <parse+0x43>
  100a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a3f:	0f b6 00             	movzbl (%eax),%eax
  100a42:	0f be c0             	movsbl %al,%eax
  100a45:	83 ec 08             	sub    $0x8,%esp
  100a48:	50                   	push   %eax
  100a49:	68 04 34 10 00       	push   $0x103404
  100a4e:	e8 ff 1d 00 00       	call   102852 <strchr>
  100a53:	83 c4 10             	add    $0x10,%esp
  100a56:	85 c0                	test   %eax,%eax
  100a58:	75 cc                	jne    100a26 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a5d:	0f b6 00             	movzbl (%eax),%eax
  100a60:	84 c0                	test   %al,%al
  100a62:	74 69                	je     100acd <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a64:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a68:	75 12                	jne    100a7c <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a6a:	83 ec 08             	sub    $0x8,%esp
  100a6d:	6a 10                	push   $0x10
  100a6f:	68 09 34 10 00       	push   $0x103409
  100a74:	e8 c4 f7 ff ff       	call   10023d <cprintf>
  100a79:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a7f:	8d 50 01             	lea    0x1(%eax),%edx
  100a82:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100a85:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a8f:	01 c2                	add    %eax,%edx
  100a91:	8b 45 08             	mov    0x8(%ebp),%eax
  100a94:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a96:	eb 04                	jmp    100a9c <parse+0x85>
            buf ++;
  100a98:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9f:	0f b6 00             	movzbl (%eax),%eax
  100aa2:	84 c0                	test   %al,%al
  100aa4:	0f 84 7a ff ff ff    	je     100a24 <parse+0xd>
  100aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  100aad:	0f b6 00             	movzbl (%eax),%eax
  100ab0:	0f be c0             	movsbl %al,%eax
  100ab3:	83 ec 08             	sub    $0x8,%esp
  100ab6:	50                   	push   %eax
  100ab7:	68 04 34 10 00       	push   $0x103404
  100abc:	e8 91 1d 00 00       	call   102852 <strchr>
  100ac1:	83 c4 10             	add    $0x10,%esp
  100ac4:	85 c0                	test   %eax,%eax
  100ac6:	74 d0                	je     100a98 <parse+0x81>
            buf ++;
        }
    }
  100ac8:	e9 57 ff ff ff       	jmp    100a24 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100acd:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100ad1:	c9                   	leave  
  100ad2:	c3                   	ret    

00100ad3 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ad3:	55                   	push   %ebp
  100ad4:	89 e5                	mov    %esp,%ebp
  100ad6:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100ad9:	83 ec 08             	sub    $0x8,%esp
  100adc:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100adf:	50                   	push   %eax
  100ae0:	ff 75 08             	pushl  0x8(%ebp)
  100ae3:	e8 2f ff ff ff       	call   100a17 <parse>
  100ae8:	83 c4 10             	add    $0x10,%esp
  100aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100aee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100af2:	75 0a                	jne    100afe <runcmd+0x2b>
        return 0;
  100af4:	b8 00 00 00 00       	mov    $0x0,%eax
  100af9:	e9 83 00 00 00       	jmp    100b81 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100afe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b05:	eb 59                	jmp    100b60 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b07:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b0d:	89 d0                	mov    %edx,%eax
  100b0f:	01 c0                	add    %eax,%eax
  100b11:	01 d0                	add    %edx,%eax
  100b13:	c1 e0 02             	shl    $0x2,%eax
  100b16:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b1b:	8b 00                	mov    (%eax),%eax
  100b1d:	83 ec 08             	sub    $0x8,%esp
  100b20:	51                   	push   %ecx
  100b21:	50                   	push   %eax
  100b22:	e8 8b 1c 00 00       	call   1027b2 <strcmp>
  100b27:	83 c4 10             	add    $0x10,%esp
  100b2a:	85 c0                	test   %eax,%eax
  100b2c:	75 2e                	jne    100b5c <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b31:	89 d0                	mov    %edx,%eax
  100b33:	01 c0                	add    %eax,%eax
  100b35:	01 d0                	add    %edx,%eax
  100b37:	c1 e0 02             	shl    $0x2,%eax
  100b3a:	05 08 e0 10 00       	add    $0x10e008,%eax
  100b3f:	8b 10                	mov    (%eax),%edx
  100b41:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b44:	83 c0 04             	add    $0x4,%eax
  100b47:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100b4a:	83 e9 01             	sub    $0x1,%ecx
  100b4d:	83 ec 04             	sub    $0x4,%esp
  100b50:	ff 75 0c             	pushl  0xc(%ebp)
  100b53:	50                   	push   %eax
  100b54:	51                   	push   %ecx
  100b55:	ff d2                	call   *%edx
  100b57:	83 c4 10             	add    $0x10,%esp
  100b5a:	eb 25                	jmp    100b81 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b63:	83 f8 02             	cmp    $0x2,%eax
  100b66:	76 9f                	jbe    100b07 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b68:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b6b:	83 ec 08             	sub    $0x8,%esp
  100b6e:	50                   	push   %eax
  100b6f:	68 27 34 10 00       	push   $0x103427
  100b74:	e8 c4 f6 ff ff       	call   10023d <cprintf>
  100b79:	83 c4 10             	add    $0x10,%esp
    return 0;
  100b7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b81:	c9                   	leave  
  100b82:	c3                   	ret    

00100b83 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100b83:	55                   	push   %ebp
  100b84:	89 e5                	mov    %esp,%ebp
  100b86:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100b89:	83 ec 0c             	sub    $0xc,%esp
  100b8c:	68 40 34 10 00       	push   $0x103440
  100b91:	e8 a7 f6 ff ff       	call   10023d <cprintf>
  100b96:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100b99:	83 ec 0c             	sub    $0xc,%esp
  100b9c:	68 68 34 10 00       	push   $0x103468
  100ba1:	e8 97 f6 ff ff       	call   10023d <cprintf>
  100ba6:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100ba9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bad:	74 0e                	je     100bbd <kmonitor+0x3a>
        print_trapframe(tf);
  100baf:	83 ec 0c             	sub    $0xc,%esp
  100bb2:	ff 75 08             	pushl  0x8(%ebp)
  100bb5:	e8 c6 0b 00 00       	call   101780 <print_trapframe>
  100bba:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bbd:	83 ec 0c             	sub    $0xc,%esp
  100bc0:	68 8d 34 10 00       	push   $0x10348d
  100bc5:	e8 17 f7 ff ff       	call   1002e1 <readline>
  100bca:	83 c4 10             	add    $0x10,%esp
  100bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bd4:	74 e7                	je     100bbd <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100bd6:	83 ec 08             	sub    $0x8,%esp
  100bd9:	ff 75 08             	pushl  0x8(%ebp)
  100bdc:	ff 75 f4             	pushl  -0xc(%ebp)
  100bdf:	e8 ef fe ff ff       	call   100ad3 <runcmd>
  100be4:	83 c4 10             	add    $0x10,%esp
  100be7:	85 c0                	test   %eax,%eax
  100be9:	78 02                	js     100bed <kmonitor+0x6a>
                break;
            }
        }
    }
  100beb:	eb d0                	jmp    100bbd <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100bed:	90                   	nop
            }
        }
    }
}
  100bee:	90                   	nop
  100bef:	c9                   	leave  
  100bf0:	c3                   	ret    

00100bf1 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100bf1:	55                   	push   %ebp
  100bf2:	89 e5                	mov    %esp,%ebp
  100bf4:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bfe:	eb 3c                	jmp    100c3c <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c03:	89 d0                	mov    %edx,%eax
  100c05:	01 c0                	add    %eax,%eax
  100c07:	01 d0                	add    %edx,%eax
  100c09:	c1 e0 02             	shl    $0x2,%eax
  100c0c:	05 04 e0 10 00       	add    $0x10e004,%eax
  100c11:	8b 08                	mov    (%eax),%ecx
  100c13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c16:	89 d0                	mov    %edx,%eax
  100c18:	01 c0                	add    %eax,%eax
  100c1a:	01 d0                	add    %edx,%eax
  100c1c:	c1 e0 02             	shl    $0x2,%eax
  100c1f:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c24:	8b 00                	mov    (%eax),%eax
  100c26:	83 ec 04             	sub    $0x4,%esp
  100c29:	51                   	push   %ecx
  100c2a:	50                   	push   %eax
  100c2b:	68 91 34 10 00       	push   $0x103491
  100c30:	e8 08 f6 ff ff       	call   10023d <cprintf>
  100c35:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c38:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3f:	83 f8 02             	cmp    $0x2,%eax
  100c42:	76 bc                	jbe    100c00 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c49:	c9                   	leave  
  100c4a:	c3                   	ret    

00100c4b <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c4b:	55                   	push   %ebp
  100c4c:	89 e5                	mov    %esp,%ebp
  100c4e:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c51:	e8 71 fc ff ff       	call   1008c7 <print_kerninfo>
    return 0;
  100c56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c5b:	c9                   	leave  
  100c5c:	c3                   	ret    

00100c5d <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c5d:	55                   	push   %ebp
  100c5e:	89 e5                	mov    %esp,%ebp
  100c60:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c63:	e8 a9 fd ff ff       	call   100a11 <print_stackframe>
    return 0;
  100c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c6d:	c9                   	leave  
  100c6e:	c3                   	ret    

00100c6f <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100c6f:	55                   	push   %ebp
  100c70:	89 e5                	mov    %esp,%ebp
  100c72:	83 ec 18             	sub    $0x18,%esp
  100c75:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100c7b:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100c7f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100c83:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100c87:	ee                   	out    %al,(%dx)
  100c88:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100c8e:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100c92:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100c96:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100c9a:	ee                   	out    %al,(%dx)
  100c9b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100ca1:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100ca5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ca9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100cad:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100cae:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100cb5:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100cb8:	83 ec 0c             	sub    $0xc,%esp
  100cbb:	68 9a 34 10 00       	push   $0x10349a
  100cc0:	e8 78 f5 ff ff       	call   10023d <cprintf>
  100cc5:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100cc8:	83 ec 0c             	sub    $0xc,%esp
  100ccb:	6a 00                	push   $0x0
  100ccd:	e8 ce 08 00 00       	call   1015a0 <pic_enable>
  100cd2:	83 c4 10             	add    $0x10,%esp
}
  100cd5:	90                   	nop
  100cd6:	c9                   	leave  
  100cd7:	c3                   	ret    

00100cd8 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100cd8:	55                   	push   %ebp
  100cd9:	89 e5                	mov    %esp,%ebp
  100cdb:	83 ec 10             	sub    $0x10,%esp
  100cde:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ce4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ce8:	89 c2                	mov    %eax,%edx
  100cea:	ec                   	in     (%dx),%al
  100ceb:	88 45 f4             	mov    %al,-0xc(%ebp)
  100cee:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100cf4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100cf8:	89 c2                	mov    %eax,%edx
  100cfa:	ec                   	in     (%dx),%al
  100cfb:	88 45 f5             	mov    %al,-0xb(%ebp)
  100cfe:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100d04:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100d08:	89 c2                	mov    %eax,%edx
  100d0a:	ec                   	in     (%dx),%al
  100d0b:	88 45 f6             	mov    %al,-0xa(%ebp)
  100d0e:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100d14:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100d18:	89 c2                	mov    %eax,%edx
  100d1a:	ec                   	in     (%dx),%al
  100d1b:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100d1e:	90                   	nop
  100d1f:	c9                   	leave  
  100d20:	c3                   	ret    

00100d21 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100d21:	55                   	push   %ebp
  100d22:	89 e5                	mov    %esp,%ebp
  100d24:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100d27:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100d2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d31:	0f b7 00             	movzwl (%eax),%eax
  100d34:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100d38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d3b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100d40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d43:	0f b7 00             	movzwl (%eax),%eax
  100d46:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100d4a:	74 12                	je     100d5e <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100d4c:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100d53:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100d5a:	b4 03 
  100d5c:	eb 13                	jmp    100d71 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100d5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d61:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100d65:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100d68:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100d6f:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100d71:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100d78:	0f b7 c0             	movzwl %ax,%eax
  100d7b:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100d7f:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d83:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100d87:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100d8b:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100d8c:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100d93:	83 c0 01             	add    $0x1,%eax
  100d96:	0f b7 c0             	movzwl %ax,%eax
  100d99:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100d9d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100da1:	89 c2                	mov    %eax,%edx
  100da3:	ec                   	in     (%dx),%al
  100da4:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100da7:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100dab:	0f b6 c0             	movzbl %al,%eax
  100dae:	c1 e0 08             	shl    $0x8,%eax
  100db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100db4:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100dbb:	0f b7 c0             	movzwl %ax,%eax
  100dbe:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100dc2:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dc6:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100dca:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100dce:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100dcf:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100dd6:	83 c0 01             	add    $0x1,%eax
  100dd9:	0f b7 c0             	movzwl %ax,%eax
  100ddc:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100de0:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100de4:	89 c2                	mov    %eax,%edx
  100de6:	ec                   	in     (%dx),%al
  100de7:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100dea:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dee:	0f b6 c0             	movzbl %al,%eax
  100df1:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100df7:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100dff:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100e05:	90                   	nop
  100e06:	c9                   	leave  
  100e07:	c3                   	ret    

00100e08 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100e08:	55                   	push   %ebp
  100e09:	89 e5                	mov    %esp,%ebp
  100e0b:	83 ec 28             	sub    $0x28,%esp
  100e0e:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100e14:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e18:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100e1c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e20:	ee                   	out    %al,(%dx)
  100e21:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100e27:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100e2b:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100e2f:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100e33:	ee                   	out    %al,(%dx)
  100e34:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100e3a:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100e3e:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100e42:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e46:	ee                   	out    %al,(%dx)
  100e47:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100e4d:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100e51:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100e55:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100e59:	ee                   	out    %al,(%dx)
  100e5a:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100e60:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100e64:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100e68:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e6c:	ee                   	out    %al,(%dx)
  100e6d:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100e73:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100e77:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100e7b:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100e7f:	ee                   	out    %al,(%dx)
  100e80:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100e86:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100e8a:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100e8e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e92:	ee                   	out    %al,(%dx)
  100e93:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e99:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100e9d:	89 c2                	mov    %eax,%edx
  100e9f:	ec                   	in     (%dx),%al
  100ea0:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100ea3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ea7:	3c ff                	cmp    $0xff,%al
  100ea9:	0f 95 c0             	setne  %al
  100eac:	0f b6 c0             	movzbl %al,%eax
  100eaf:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100eb4:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eba:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ebe:	89 c2                	mov    %eax,%edx
  100ec0:	ec                   	in     (%dx),%al
  100ec1:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100ec4:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100eca:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100ece:	89 c2                	mov    %eax,%edx
  100ed0:	ec                   	in     (%dx),%al
  100ed1:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100ed4:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100ed9:	85 c0                	test   %eax,%eax
  100edb:	74 0d                	je     100eea <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100edd:	83 ec 0c             	sub    $0xc,%esp
  100ee0:	6a 04                	push   $0x4
  100ee2:	e8 b9 06 00 00       	call   1015a0 <pic_enable>
  100ee7:	83 c4 10             	add    $0x10,%esp
    }
}
  100eea:	90                   	nop
  100eeb:	c9                   	leave  
  100eec:	c3                   	ret    

00100eed <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100eed:	55                   	push   %ebp
  100eee:	89 e5                	mov    %esp,%ebp
  100ef0:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ef3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100efa:	eb 09                	jmp    100f05 <lpt_putc_sub+0x18>
        delay();
  100efc:	e8 d7 fd ff ff       	call   100cd8 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f01:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100f05:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100f0b:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100f0f:	89 c2                	mov    %eax,%edx
  100f11:	ec                   	in     (%dx),%al
  100f12:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100f15:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100f19:	84 c0                	test   %al,%al
  100f1b:	78 09                	js     100f26 <lpt_putc_sub+0x39>
  100f1d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100f24:	7e d6                	jle    100efc <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100f26:	8b 45 08             	mov    0x8(%ebp),%eax
  100f29:	0f b6 c0             	movzbl %al,%eax
  100f2c:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  100f32:	88 45 f0             	mov    %al,-0x10(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f35:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100f39:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100f3d:	ee                   	out    %al,(%dx)
  100f3e:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  100f44:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100f48:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f4c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f50:	ee                   	out    %al,(%dx)
  100f51:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  100f57:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  100f5b:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  100f5f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f63:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  100f64:	90                   	nop
  100f65:	c9                   	leave  
  100f66:	c3                   	ret    

00100f67 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  100f67:	55                   	push   %ebp
  100f68:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  100f6a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  100f6e:	74 0d                	je     100f7d <lpt_putc+0x16>
        lpt_putc_sub(c);
  100f70:	ff 75 08             	pushl  0x8(%ebp)
  100f73:	e8 75 ff ff ff       	call   100eed <lpt_putc_sub>
  100f78:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  100f7b:	eb 1e                	jmp    100f9b <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  100f7d:	6a 08                	push   $0x8
  100f7f:	e8 69 ff ff ff       	call   100eed <lpt_putc_sub>
  100f84:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  100f87:	6a 20                	push   $0x20
  100f89:	e8 5f ff ff ff       	call   100eed <lpt_putc_sub>
  100f8e:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  100f91:	6a 08                	push   $0x8
  100f93:	e8 55 ff ff ff       	call   100eed <lpt_putc_sub>
  100f98:	83 c4 04             	add    $0x4,%esp
    }
}
  100f9b:	90                   	nop
  100f9c:	c9                   	leave  
  100f9d:	c3                   	ret    

00100f9e <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  100f9e:	55                   	push   %ebp
  100f9f:	89 e5                	mov    %esp,%ebp
  100fa1:	53                   	push   %ebx
  100fa2:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  100fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  100fa8:	b0 00                	mov    $0x0,%al
  100faa:	85 c0                	test   %eax,%eax
  100fac:	75 07                	jne    100fb5 <cga_putc+0x17>
        c |= 0x0700;
  100fae:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  100fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  100fb8:	0f b6 c0             	movzbl %al,%eax
  100fbb:	83 f8 0a             	cmp    $0xa,%eax
  100fbe:	74 4e                	je     10100e <cga_putc+0x70>
  100fc0:	83 f8 0d             	cmp    $0xd,%eax
  100fc3:	74 59                	je     10101e <cga_putc+0x80>
  100fc5:	83 f8 08             	cmp    $0x8,%eax
  100fc8:	0f 85 8a 00 00 00    	jne    101058 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  100fce:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  100fd5:	66 85 c0             	test   %ax,%ax
  100fd8:	0f 84 a0 00 00 00    	je     10107e <cga_putc+0xe0>
            crt_pos --;
  100fde:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  100fe5:	83 e8 01             	sub    $0x1,%eax
  100fe8:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  100fee:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  100ff3:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  100ffa:	0f b7 d2             	movzwl %dx,%edx
  100ffd:	01 d2                	add    %edx,%edx
  100fff:	01 d0                	add    %edx,%eax
  101001:	8b 55 08             	mov    0x8(%ebp),%edx
  101004:	b2 00                	mov    $0x0,%dl
  101006:	83 ca 20             	or     $0x20,%edx
  101009:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  10100c:	eb 70                	jmp    10107e <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  10100e:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101015:	83 c0 50             	add    $0x50,%eax
  101018:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10101e:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101025:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10102c:	0f b7 c1             	movzwl %cx,%eax
  10102f:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101035:	c1 e8 10             	shr    $0x10,%eax
  101038:	89 c2                	mov    %eax,%edx
  10103a:	66 c1 ea 06          	shr    $0x6,%dx
  10103e:	89 d0                	mov    %edx,%eax
  101040:	c1 e0 02             	shl    $0x2,%eax
  101043:	01 d0                	add    %edx,%eax
  101045:	c1 e0 04             	shl    $0x4,%eax
  101048:	29 c1                	sub    %eax,%ecx
  10104a:	89 ca                	mov    %ecx,%edx
  10104c:	89 d8                	mov    %ebx,%eax
  10104e:	29 d0                	sub    %edx,%eax
  101050:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101056:	eb 27                	jmp    10107f <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101058:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10105e:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101065:	8d 50 01             	lea    0x1(%eax),%edx
  101068:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  10106f:	0f b7 c0             	movzwl %ax,%eax
  101072:	01 c0                	add    %eax,%eax
  101074:	01 c8                	add    %ecx,%eax
  101076:	8b 55 08             	mov    0x8(%ebp),%edx
  101079:	66 89 10             	mov    %dx,(%eax)
        break;
  10107c:	eb 01                	jmp    10107f <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  10107e:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10107f:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101086:	66 3d cf 07          	cmp    $0x7cf,%ax
  10108a:	76 59                	jbe    1010e5 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10108c:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101091:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101097:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10109c:	83 ec 04             	sub    $0x4,%esp
  10109f:	68 00 0f 00 00       	push   $0xf00
  1010a4:	52                   	push   %edx
  1010a5:	50                   	push   %eax
  1010a6:	e8 a6 19 00 00       	call   102a51 <memmove>
  1010ab:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1010ae:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1010b5:	eb 15                	jmp    1010cc <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  1010b7:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1010bf:	01 d2                	add    %edx,%edx
  1010c1:	01 d0                	add    %edx,%eax
  1010c3:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1010c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1010cc:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1010d3:	7e e2                	jle    1010b7 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1010d5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010dc:	83 e8 50             	sub    $0x50,%eax
  1010df:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1010e5:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1010ec:	0f b7 c0             	movzwl %ax,%eax
  1010ef:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1010f3:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  1010f7:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1010fb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010ff:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101100:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101107:	66 c1 e8 08          	shr    $0x8,%ax
  10110b:	0f b6 c0             	movzbl %al,%eax
  10110e:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101115:	83 c2 01             	add    $0x1,%edx
  101118:	0f b7 d2             	movzwl %dx,%edx
  10111b:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  10111f:	88 45 e9             	mov    %al,-0x17(%ebp)
  101122:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101126:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10112a:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10112b:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101132:	0f b7 c0             	movzwl %ax,%eax
  101135:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101139:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  10113d:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101141:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101145:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101146:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10114d:	0f b6 c0             	movzbl %al,%eax
  101150:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101157:	83 c2 01             	add    $0x1,%edx
  10115a:	0f b7 d2             	movzwl %dx,%edx
  10115d:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101161:	88 45 eb             	mov    %al,-0x15(%ebp)
  101164:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  101168:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10116c:	ee                   	out    %al,(%dx)
}
  10116d:	90                   	nop
  10116e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101171:	c9                   	leave  
  101172:	c3                   	ret    

00101173 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101173:	55                   	push   %ebp
  101174:	89 e5                	mov    %esp,%ebp
  101176:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101179:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101180:	eb 09                	jmp    10118b <serial_putc_sub+0x18>
        delay();
  101182:	e8 51 fb ff ff       	call   100cd8 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101187:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10118b:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101191:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101195:	89 c2                	mov    %eax,%edx
  101197:	ec                   	in     (%dx),%al
  101198:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10119b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10119f:	0f b6 c0             	movzbl %al,%eax
  1011a2:	83 e0 20             	and    $0x20,%eax
  1011a5:	85 c0                	test   %eax,%eax
  1011a7:	75 09                	jne    1011b2 <serial_putc_sub+0x3f>
  1011a9:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1011b0:	7e d0                	jle    101182 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1011b5:	0f b6 c0             	movzbl %al,%eax
  1011b8:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1011be:	88 45 f6             	mov    %al,-0xa(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1011c1:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  1011c5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1011c9:	ee                   	out    %al,(%dx)
}
  1011ca:	90                   	nop
  1011cb:	c9                   	leave  
  1011cc:	c3                   	ret    

001011cd <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1011cd:	55                   	push   %ebp
  1011ce:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1011d0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1011d4:	74 0d                	je     1011e3 <serial_putc+0x16>
        serial_putc_sub(c);
  1011d6:	ff 75 08             	pushl  0x8(%ebp)
  1011d9:	e8 95 ff ff ff       	call   101173 <serial_putc_sub>
  1011de:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1011e1:	eb 1e                	jmp    101201 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  1011e3:	6a 08                	push   $0x8
  1011e5:	e8 89 ff ff ff       	call   101173 <serial_putc_sub>
  1011ea:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1011ed:	6a 20                	push   $0x20
  1011ef:	e8 7f ff ff ff       	call   101173 <serial_putc_sub>
  1011f4:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1011f7:	6a 08                	push   $0x8
  1011f9:	e8 75 ff ff ff       	call   101173 <serial_putc_sub>
  1011fe:	83 c4 04             	add    $0x4,%esp
    }
}
  101201:	90                   	nop
  101202:	c9                   	leave  
  101203:	c3                   	ret    

00101204 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101204:	55                   	push   %ebp
  101205:	89 e5                	mov    %esp,%ebp
  101207:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10120a:	eb 33                	jmp    10123f <cons_intr+0x3b>
        if (c != 0) {
  10120c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101210:	74 2d                	je     10123f <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101212:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101217:	8d 50 01             	lea    0x1(%eax),%edx
  10121a:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101220:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101223:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101229:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10122e:	3d 00 02 00 00       	cmp    $0x200,%eax
  101233:	75 0a                	jne    10123f <cons_intr+0x3b>
                cons.wpos = 0;
  101235:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10123c:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10123f:	8b 45 08             	mov    0x8(%ebp),%eax
  101242:	ff d0                	call   *%eax
  101244:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101247:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10124b:	75 bf                	jne    10120c <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10124d:	90                   	nop
  10124e:	c9                   	leave  
  10124f:	c3                   	ret    

00101250 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101250:	55                   	push   %ebp
  101251:	89 e5                	mov    %esp,%ebp
  101253:	83 ec 10             	sub    $0x10,%esp
  101256:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10125c:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101260:	89 c2                	mov    %eax,%edx
  101262:	ec                   	in     (%dx),%al
  101263:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  101266:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10126a:	0f b6 c0             	movzbl %al,%eax
  10126d:	83 e0 01             	and    $0x1,%eax
  101270:	85 c0                	test   %eax,%eax
  101272:	75 07                	jne    10127b <serial_proc_data+0x2b>
        return -1;
  101274:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101279:	eb 2a                	jmp    1012a5 <serial_proc_data+0x55>
  10127b:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101281:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101285:	89 c2                	mov    %eax,%edx
  101287:	ec                   	in     (%dx),%al
  101288:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  10128b:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10128f:	0f b6 c0             	movzbl %al,%eax
  101292:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101295:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101299:	75 07                	jne    1012a2 <serial_proc_data+0x52>
        c = '\b';
  10129b:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1012a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1012a5:	c9                   	leave  
  1012a6:	c3                   	ret    

001012a7 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1012a7:	55                   	push   %ebp
  1012a8:	89 e5                	mov    %esp,%ebp
  1012aa:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  1012ad:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1012b2:	85 c0                	test   %eax,%eax
  1012b4:	74 10                	je     1012c6 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1012b6:	83 ec 0c             	sub    $0xc,%esp
  1012b9:	68 50 12 10 00       	push   $0x101250
  1012be:	e8 41 ff ff ff       	call   101204 <cons_intr>
  1012c3:	83 c4 10             	add    $0x10,%esp
    }
}
  1012c6:	90                   	nop
  1012c7:	c9                   	leave  
  1012c8:	c3                   	ret    

001012c9 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1012c9:	55                   	push   %ebp
  1012ca:	89 e5                	mov    %esp,%ebp
  1012cc:	83 ec 18             	sub    $0x18,%esp
  1012cf:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012d5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1012d9:	89 c2                	mov    %eax,%edx
  1012db:	ec                   	in     (%dx),%al
  1012dc:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1012df:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1012e3:	0f b6 c0             	movzbl %al,%eax
  1012e6:	83 e0 01             	and    $0x1,%eax
  1012e9:	85 c0                	test   %eax,%eax
  1012eb:	75 0a                	jne    1012f7 <kbd_proc_data+0x2e>
        return -1;
  1012ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1012f2:	e9 5d 01 00 00       	jmp    101454 <kbd_proc_data+0x18b>
  1012f7:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012fd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101301:	89 c2                	mov    %eax,%edx
  101303:	ec                   	in     (%dx),%al
  101304:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  101307:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  10130b:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10130e:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101312:	75 17                	jne    10132b <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101314:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101319:	83 c8 40             	or     $0x40,%eax
  10131c:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101321:	b8 00 00 00 00       	mov    $0x0,%eax
  101326:	e9 29 01 00 00       	jmp    101454 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  10132b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10132f:	84 c0                	test   %al,%al
  101331:	79 47                	jns    10137a <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101333:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101338:	83 e0 40             	and    $0x40,%eax
  10133b:	85 c0                	test   %eax,%eax
  10133d:	75 09                	jne    101348 <kbd_proc_data+0x7f>
  10133f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101343:	83 e0 7f             	and    $0x7f,%eax
  101346:	eb 04                	jmp    10134c <kbd_proc_data+0x83>
  101348:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10134c:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10134f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101353:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10135a:	83 c8 40             	or     $0x40,%eax
  10135d:	0f b6 c0             	movzbl %al,%eax
  101360:	f7 d0                	not    %eax
  101362:	89 c2                	mov    %eax,%edx
  101364:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101369:	21 d0                	and    %edx,%eax
  10136b:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101370:	b8 00 00 00 00       	mov    $0x0,%eax
  101375:	e9 da 00 00 00       	jmp    101454 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  10137a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10137f:	83 e0 40             	and    $0x40,%eax
  101382:	85 c0                	test   %eax,%eax
  101384:	74 11                	je     101397 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101386:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10138a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10138f:	83 e0 bf             	and    $0xffffffbf,%eax
  101392:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101397:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10139b:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1013a2:	0f b6 d0             	movzbl %al,%edx
  1013a5:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013aa:	09 d0                	or     %edx,%eax
  1013ac:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1013b1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013b5:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1013bc:	0f b6 d0             	movzbl %al,%edx
  1013bf:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013c4:	31 d0                	xor    %edx,%eax
  1013c6:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1013cb:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013d0:	83 e0 03             	and    $0x3,%eax
  1013d3:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1013da:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013de:	01 d0                	add    %edx,%eax
  1013e0:	0f b6 00             	movzbl (%eax),%eax
  1013e3:	0f b6 c0             	movzbl %al,%eax
  1013e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1013e9:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013ee:	83 e0 08             	and    $0x8,%eax
  1013f1:	85 c0                	test   %eax,%eax
  1013f3:	74 22                	je     101417 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1013f5:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1013f9:	7e 0c                	jle    101407 <kbd_proc_data+0x13e>
  1013fb:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1013ff:	7f 06                	jg     101407 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101401:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101405:	eb 10                	jmp    101417 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101407:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10140b:	7e 0a                	jle    101417 <kbd_proc_data+0x14e>
  10140d:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101411:	7f 04                	jg     101417 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101413:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101417:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10141c:	f7 d0                	not    %eax
  10141e:	83 e0 06             	and    $0x6,%eax
  101421:	85 c0                	test   %eax,%eax
  101423:	75 2c                	jne    101451 <kbd_proc_data+0x188>
  101425:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10142c:	75 23                	jne    101451 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  10142e:	83 ec 0c             	sub    $0xc,%esp
  101431:	68 b5 34 10 00       	push   $0x1034b5
  101436:	e8 02 ee ff ff       	call   10023d <cprintf>
  10143b:	83 c4 10             	add    $0x10,%esp
  10143e:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  101444:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101448:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10144c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101450:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101451:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101454:	c9                   	leave  
  101455:	c3                   	ret    

00101456 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101456:	55                   	push   %ebp
  101457:	89 e5                	mov    %esp,%ebp
  101459:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10145c:	83 ec 0c             	sub    $0xc,%esp
  10145f:	68 c9 12 10 00       	push   $0x1012c9
  101464:	e8 9b fd ff ff       	call   101204 <cons_intr>
  101469:	83 c4 10             	add    $0x10,%esp
}
  10146c:	90                   	nop
  10146d:	c9                   	leave  
  10146e:	c3                   	ret    

0010146f <kbd_init>:

static void
kbd_init(void) {
  10146f:	55                   	push   %ebp
  101470:	89 e5                	mov    %esp,%ebp
  101472:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101475:	e8 dc ff ff ff       	call   101456 <kbd_intr>
    pic_enable(IRQ_KBD);
  10147a:	83 ec 0c             	sub    $0xc,%esp
  10147d:	6a 01                	push   $0x1
  10147f:	e8 1c 01 00 00       	call   1015a0 <pic_enable>
  101484:	83 c4 10             	add    $0x10,%esp
}
  101487:	90                   	nop
  101488:	c9                   	leave  
  101489:	c3                   	ret    

0010148a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10148a:	55                   	push   %ebp
  10148b:	89 e5                	mov    %esp,%ebp
  10148d:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101490:	e8 8c f8 ff ff       	call   100d21 <cga_init>
    serial_init();
  101495:	e8 6e f9 ff ff       	call   100e08 <serial_init>
    kbd_init();
  10149a:	e8 d0 ff ff ff       	call   10146f <kbd_init>
    if (!serial_exists) {
  10149f:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1014a4:	85 c0                	test   %eax,%eax
  1014a6:	75 10                	jne    1014b8 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1014a8:	83 ec 0c             	sub    $0xc,%esp
  1014ab:	68 c1 34 10 00       	push   $0x1034c1
  1014b0:	e8 88 ed ff ff       	call   10023d <cprintf>
  1014b5:	83 c4 10             	add    $0x10,%esp
    }
}
  1014b8:	90                   	nop
  1014b9:	c9                   	leave  
  1014ba:	c3                   	ret    

001014bb <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1014bb:	55                   	push   %ebp
  1014bc:	89 e5                	mov    %esp,%ebp
  1014be:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  1014c1:	ff 75 08             	pushl  0x8(%ebp)
  1014c4:	e8 9e fa ff ff       	call   100f67 <lpt_putc>
  1014c9:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1014cc:	83 ec 0c             	sub    $0xc,%esp
  1014cf:	ff 75 08             	pushl  0x8(%ebp)
  1014d2:	e8 c7 fa ff ff       	call   100f9e <cga_putc>
  1014d7:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1014da:	83 ec 0c             	sub    $0xc,%esp
  1014dd:	ff 75 08             	pushl  0x8(%ebp)
  1014e0:	e8 e8 fc ff ff       	call   1011cd <serial_putc>
  1014e5:	83 c4 10             	add    $0x10,%esp
}
  1014e8:	90                   	nop
  1014e9:	c9                   	leave  
  1014ea:	c3                   	ret    

001014eb <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1014eb:	55                   	push   %ebp
  1014ec:	89 e5                	mov    %esp,%ebp
  1014ee:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1014f1:	e8 b1 fd ff ff       	call   1012a7 <serial_intr>
    kbd_intr();
  1014f6:	e8 5b ff ff ff       	call   101456 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1014fb:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  101501:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101506:	39 c2                	cmp    %eax,%edx
  101508:	74 36                	je     101540 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  10150a:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10150f:	8d 50 01             	lea    0x1(%eax),%edx
  101512:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  101518:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  10151f:	0f b6 c0             	movzbl %al,%eax
  101522:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101525:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10152a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10152f:	75 0a                	jne    10153b <cons_getc+0x50>
            cons.rpos = 0;
  101531:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101538:	00 00 00 
        }
        return c;
  10153b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10153e:	eb 05                	jmp    101545 <cons_getc+0x5a>
    }
    return 0;
  101540:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101545:	c9                   	leave  
  101546:	c3                   	ret    

00101547 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101547:	55                   	push   %ebp
  101548:	89 e5                	mov    %esp,%ebp
  10154a:	83 ec 14             	sub    $0x14,%esp
  10154d:	8b 45 08             	mov    0x8(%ebp),%eax
  101550:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101554:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101558:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10155e:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101563:	85 c0                	test   %eax,%eax
  101565:	74 36                	je     10159d <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101567:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10156b:	0f b6 c0             	movzbl %al,%eax
  10156e:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101574:	88 45 fa             	mov    %al,-0x6(%ebp)
  101577:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  10157b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10157f:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101580:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101584:	66 c1 e8 08          	shr    $0x8,%ax
  101588:	0f b6 c0             	movzbl %al,%eax
  10158b:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101591:	88 45 fb             	mov    %al,-0x5(%ebp)
  101594:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  101598:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  10159c:	ee                   	out    %al,(%dx)
    }
}
  10159d:	90                   	nop
  10159e:	c9                   	leave  
  10159f:	c3                   	ret    

001015a0 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1015a0:	55                   	push   %ebp
  1015a1:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  1015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1015a6:	ba 01 00 00 00       	mov    $0x1,%edx
  1015ab:	89 c1                	mov    %eax,%ecx
  1015ad:	d3 e2                	shl    %cl,%edx
  1015af:	89 d0                	mov    %edx,%eax
  1015b1:	f7 d0                	not    %eax
  1015b3:	89 c2                	mov    %eax,%edx
  1015b5:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1015bc:	21 d0                	and    %edx,%eax
  1015be:	0f b7 c0             	movzwl %ax,%eax
  1015c1:	50                   	push   %eax
  1015c2:	e8 80 ff ff ff       	call   101547 <pic_setmask>
  1015c7:	83 c4 04             	add    $0x4,%esp
}
  1015ca:	90                   	nop
  1015cb:	c9                   	leave  
  1015cc:	c3                   	ret    

001015cd <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1015cd:	55                   	push   %ebp
  1015ce:	89 e5                	mov    %esp,%ebp
  1015d0:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  1015d3:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1015da:	00 00 00 
  1015dd:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1015e3:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1015e7:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1015eb:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1015ef:	ee                   	out    %al,(%dx)
  1015f0:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1015f6:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1015fa:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1015fe:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  101602:	ee                   	out    %al,(%dx)
  101603:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  101609:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  10160d:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  101611:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101615:	ee                   	out    %al,(%dx)
  101616:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  10161c:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  101620:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101624:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  101628:	ee                   	out    %al,(%dx)
  101629:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  10162f:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101633:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  101637:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10163b:	ee                   	out    %al,(%dx)
  10163c:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101642:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  101646:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  10164a:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  10164e:	ee                   	out    %al,(%dx)
  10164f:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  101655:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  101659:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  10165d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101661:	ee                   	out    %al,(%dx)
  101662:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  101668:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  10166c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101670:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101674:	ee                   	out    %al,(%dx)
  101675:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10167b:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  10167f:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  101683:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101687:	ee                   	out    %al,(%dx)
  101688:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  10168e:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  101692:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  101696:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10169a:	ee                   	out    %al,(%dx)
  10169b:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  1016a1:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  1016a5:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  1016a9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1016ad:	ee                   	out    %al,(%dx)
  1016ae:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  1016b4:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  1016b8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1016bc:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1016c0:	ee                   	out    %al,(%dx)
  1016c1:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1016c7:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  1016cb:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  1016cf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1016d3:	ee                   	out    %al,(%dx)
  1016d4:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  1016da:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  1016de:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1016e2:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1016e6:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1016e7:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016ee:	66 83 f8 ff          	cmp    $0xffff,%ax
  1016f2:	74 13                	je     101707 <pic_init+0x13a>
        pic_setmask(irq_mask);
  1016f4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016fb:	0f b7 c0             	movzwl %ax,%eax
  1016fe:	50                   	push   %eax
  1016ff:	e8 43 fe ff ff       	call   101547 <pic_setmask>
  101704:	83 c4 04             	add    $0x4,%esp
    }
}
  101707:	90                   	nop
  101708:	c9                   	leave  
  101709:	c3                   	ret    

0010170a <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10170a:	55                   	push   %ebp
  10170b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10170d:	fb                   	sti    
    sti();
}
  10170e:	90                   	nop
  10170f:	5d                   	pop    %ebp
  101710:	c3                   	ret    

00101711 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101711:	55                   	push   %ebp
  101712:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101714:	fa                   	cli    
    cli();
}
  101715:	90                   	nop
  101716:	5d                   	pop    %ebp
  101717:	c3                   	ret    

00101718 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101718:	55                   	push   %ebp
  101719:	89 e5                	mov    %esp,%ebp
  10171b:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10171e:	83 ec 08             	sub    $0x8,%esp
  101721:	6a 64                	push   $0x64
  101723:	68 e0 34 10 00       	push   $0x1034e0
  101728:	e8 10 eb ff ff       	call   10023d <cprintf>
  10172d:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101730:	90                   	nop
  101731:	c9                   	leave  
  101732:	c3                   	ret    

00101733 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101733:	55                   	push   %ebp
  101734:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  101736:	90                   	nop
  101737:	5d                   	pop    %ebp
  101738:	c3                   	ret    

00101739 <trapname>:

static const char *
trapname(int trapno) {
  101739:	55                   	push   %ebp
  10173a:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  10173c:	8b 45 08             	mov    0x8(%ebp),%eax
  10173f:	83 f8 13             	cmp    $0x13,%eax
  101742:	77 0c                	ja     101750 <trapname+0x17>
        return excnames[trapno];
  101744:	8b 45 08             	mov    0x8(%ebp),%eax
  101747:	8b 04 85 40 38 10 00 	mov    0x103840(,%eax,4),%eax
  10174e:	eb 18                	jmp    101768 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101750:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101754:	7e 0d                	jle    101763 <trapname+0x2a>
  101756:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10175a:	7f 07                	jg     101763 <trapname+0x2a>
        return "Hardware Interrupt";
  10175c:	b8 ea 34 10 00       	mov    $0x1034ea,%eax
  101761:	eb 05                	jmp    101768 <trapname+0x2f>
    }
    return "(unknown trap)";
  101763:	b8 fd 34 10 00       	mov    $0x1034fd,%eax
}
  101768:	5d                   	pop    %ebp
  101769:	c3                   	ret    

0010176a <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10176a:	55                   	push   %ebp
  10176b:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  10176d:	8b 45 08             	mov    0x8(%ebp),%eax
  101770:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101774:	66 83 f8 08          	cmp    $0x8,%ax
  101778:	0f 94 c0             	sete   %al
  10177b:	0f b6 c0             	movzbl %al,%eax
}
  10177e:	5d                   	pop    %ebp
  10177f:	c3                   	ret    

00101780 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101780:	55                   	push   %ebp
  101781:	89 e5                	mov    %esp,%ebp
  101783:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101786:	83 ec 08             	sub    $0x8,%esp
  101789:	ff 75 08             	pushl  0x8(%ebp)
  10178c:	68 3e 35 10 00       	push   $0x10353e
  101791:	e8 a7 ea ff ff       	call   10023d <cprintf>
  101796:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101799:	8b 45 08             	mov    0x8(%ebp),%eax
  10179c:	83 ec 0c             	sub    $0xc,%esp
  10179f:	50                   	push   %eax
  1017a0:	e8 b8 01 00 00       	call   10195d <print_regs>
  1017a5:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1017ab:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1017af:	0f b7 c0             	movzwl %ax,%eax
  1017b2:	83 ec 08             	sub    $0x8,%esp
  1017b5:	50                   	push   %eax
  1017b6:	68 4f 35 10 00       	push   $0x10354f
  1017bb:	e8 7d ea ff ff       	call   10023d <cprintf>
  1017c0:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1017c6:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1017ca:	0f b7 c0             	movzwl %ax,%eax
  1017cd:	83 ec 08             	sub    $0x8,%esp
  1017d0:	50                   	push   %eax
  1017d1:	68 62 35 10 00       	push   $0x103562
  1017d6:	e8 62 ea ff ff       	call   10023d <cprintf>
  1017db:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1017de:	8b 45 08             	mov    0x8(%ebp),%eax
  1017e1:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1017e5:	0f b7 c0             	movzwl %ax,%eax
  1017e8:	83 ec 08             	sub    $0x8,%esp
  1017eb:	50                   	push   %eax
  1017ec:	68 75 35 10 00       	push   $0x103575
  1017f1:	e8 47 ea ff ff       	call   10023d <cprintf>
  1017f6:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1017fc:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101800:	0f b7 c0             	movzwl %ax,%eax
  101803:	83 ec 08             	sub    $0x8,%esp
  101806:	50                   	push   %eax
  101807:	68 88 35 10 00       	push   $0x103588
  10180c:	e8 2c ea ff ff       	call   10023d <cprintf>
  101811:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101814:	8b 45 08             	mov    0x8(%ebp),%eax
  101817:	8b 40 30             	mov    0x30(%eax),%eax
  10181a:	83 ec 0c             	sub    $0xc,%esp
  10181d:	50                   	push   %eax
  10181e:	e8 16 ff ff ff       	call   101739 <trapname>
  101823:	83 c4 10             	add    $0x10,%esp
  101826:	89 c2                	mov    %eax,%edx
  101828:	8b 45 08             	mov    0x8(%ebp),%eax
  10182b:	8b 40 30             	mov    0x30(%eax),%eax
  10182e:	83 ec 04             	sub    $0x4,%esp
  101831:	52                   	push   %edx
  101832:	50                   	push   %eax
  101833:	68 9b 35 10 00       	push   $0x10359b
  101838:	e8 00 ea ff ff       	call   10023d <cprintf>
  10183d:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101840:	8b 45 08             	mov    0x8(%ebp),%eax
  101843:	8b 40 34             	mov    0x34(%eax),%eax
  101846:	83 ec 08             	sub    $0x8,%esp
  101849:	50                   	push   %eax
  10184a:	68 ad 35 10 00       	push   $0x1035ad
  10184f:	e8 e9 e9 ff ff       	call   10023d <cprintf>
  101854:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101857:	8b 45 08             	mov    0x8(%ebp),%eax
  10185a:	8b 40 38             	mov    0x38(%eax),%eax
  10185d:	83 ec 08             	sub    $0x8,%esp
  101860:	50                   	push   %eax
  101861:	68 bc 35 10 00       	push   $0x1035bc
  101866:	e8 d2 e9 ff ff       	call   10023d <cprintf>
  10186b:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  10186e:	8b 45 08             	mov    0x8(%ebp),%eax
  101871:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101875:	0f b7 c0             	movzwl %ax,%eax
  101878:	83 ec 08             	sub    $0x8,%esp
  10187b:	50                   	push   %eax
  10187c:	68 cb 35 10 00       	push   $0x1035cb
  101881:	e8 b7 e9 ff ff       	call   10023d <cprintf>
  101886:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101889:	8b 45 08             	mov    0x8(%ebp),%eax
  10188c:	8b 40 40             	mov    0x40(%eax),%eax
  10188f:	83 ec 08             	sub    $0x8,%esp
  101892:	50                   	push   %eax
  101893:	68 de 35 10 00       	push   $0x1035de
  101898:	e8 a0 e9 ff ff       	call   10023d <cprintf>
  10189d:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1018a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1018a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  1018ae:	eb 3f                	jmp    1018ef <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  1018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1018b3:	8b 50 40             	mov    0x40(%eax),%edx
  1018b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1018b9:	21 d0                	and    %edx,%eax
  1018bb:	85 c0                	test   %eax,%eax
  1018bd:	74 29                	je     1018e8 <print_trapframe+0x168>
  1018bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1018c2:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  1018c9:	85 c0                	test   %eax,%eax
  1018cb:	74 1b                	je     1018e8 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  1018cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1018d0:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  1018d7:	83 ec 08             	sub    $0x8,%esp
  1018da:	50                   	push   %eax
  1018db:	68 ed 35 10 00       	push   $0x1035ed
  1018e0:	e8 58 e9 ff ff       	call   10023d <cprintf>
  1018e5:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1018e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1018ec:	d1 65 f0             	shll   -0x10(%ebp)
  1018ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1018f2:	83 f8 17             	cmp    $0x17,%eax
  1018f5:	76 b9                	jbe    1018b0 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  1018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1018fa:	8b 40 40             	mov    0x40(%eax),%eax
  1018fd:	25 00 30 00 00       	and    $0x3000,%eax
  101902:	c1 e8 0c             	shr    $0xc,%eax
  101905:	83 ec 08             	sub    $0x8,%esp
  101908:	50                   	push   %eax
  101909:	68 f1 35 10 00       	push   $0x1035f1
  10190e:	e8 2a e9 ff ff       	call   10023d <cprintf>
  101913:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101916:	83 ec 0c             	sub    $0xc,%esp
  101919:	ff 75 08             	pushl  0x8(%ebp)
  10191c:	e8 49 fe ff ff       	call   10176a <trap_in_kernel>
  101921:	83 c4 10             	add    $0x10,%esp
  101924:	85 c0                	test   %eax,%eax
  101926:	75 32                	jne    10195a <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101928:	8b 45 08             	mov    0x8(%ebp),%eax
  10192b:	8b 40 44             	mov    0x44(%eax),%eax
  10192e:	83 ec 08             	sub    $0x8,%esp
  101931:	50                   	push   %eax
  101932:	68 fa 35 10 00       	push   $0x1035fa
  101937:	e8 01 e9 ff ff       	call   10023d <cprintf>
  10193c:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  10193f:	8b 45 08             	mov    0x8(%ebp),%eax
  101942:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101946:	0f b7 c0             	movzwl %ax,%eax
  101949:	83 ec 08             	sub    $0x8,%esp
  10194c:	50                   	push   %eax
  10194d:	68 09 36 10 00       	push   $0x103609
  101952:	e8 e6 e8 ff ff       	call   10023d <cprintf>
  101957:	83 c4 10             	add    $0x10,%esp
    }
}
  10195a:	90                   	nop
  10195b:	c9                   	leave  
  10195c:	c3                   	ret    

0010195d <print_regs>:

void
print_regs(struct pushregs *regs) {
  10195d:	55                   	push   %ebp
  10195e:	89 e5                	mov    %esp,%ebp
  101960:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101963:	8b 45 08             	mov    0x8(%ebp),%eax
  101966:	8b 00                	mov    (%eax),%eax
  101968:	83 ec 08             	sub    $0x8,%esp
  10196b:	50                   	push   %eax
  10196c:	68 1c 36 10 00       	push   $0x10361c
  101971:	e8 c7 e8 ff ff       	call   10023d <cprintf>
  101976:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101979:	8b 45 08             	mov    0x8(%ebp),%eax
  10197c:	8b 40 04             	mov    0x4(%eax),%eax
  10197f:	83 ec 08             	sub    $0x8,%esp
  101982:	50                   	push   %eax
  101983:	68 2b 36 10 00       	push   $0x10362b
  101988:	e8 b0 e8 ff ff       	call   10023d <cprintf>
  10198d:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101990:	8b 45 08             	mov    0x8(%ebp),%eax
  101993:	8b 40 08             	mov    0x8(%eax),%eax
  101996:	83 ec 08             	sub    $0x8,%esp
  101999:	50                   	push   %eax
  10199a:	68 3a 36 10 00       	push   $0x10363a
  10199f:	e8 99 e8 ff ff       	call   10023d <cprintf>
  1019a4:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  1019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019aa:	8b 40 0c             	mov    0xc(%eax),%eax
  1019ad:	83 ec 08             	sub    $0x8,%esp
  1019b0:	50                   	push   %eax
  1019b1:	68 49 36 10 00       	push   $0x103649
  1019b6:	e8 82 e8 ff ff       	call   10023d <cprintf>
  1019bb:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  1019be:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c1:	8b 40 10             	mov    0x10(%eax),%eax
  1019c4:	83 ec 08             	sub    $0x8,%esp
  1019c7:	50                   	push   %eax
  1019c8:	68 58 36 10 00       	push   $0x103658
  1019cd:	e8 6b e8 ff ff       	call   10023d <cprintf>
  1019d2:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  1019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d8:	8b 40 14             	mov    0x14(%eax),%eax
  1019db:	83 ec 08             	sub    $0x8,%esp
  1019de:	50                   	push   %eax
  1019df:	68 67 36 10 00       	push   $0x103667
  1019e4:	e8 54 e8 ff ff       	call   10023d <cprintf>
  1019e9:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  1019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ef:	8b 40 18             	mov    0x18(%eax),%eax
  1019f2:	83 ec 08             	sub    $0x8,%esp
  1019f5:	50                   	push   %eax
  1019f6:	68 76 36 10 00       	push   $0x103676
  1019fb:	e8 3d e8 ff ff       	call   10023d <cprintf>
  101a00:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101a03:	8b 45 08             	mov    0x8(%ebp),%eax
  101a06:	8b 40 1c             	mov    0x1c(%eax),%eax
  101a09:	83 ec 08             	sub    $0x8,%esp
  101a0c:	50                   	push   %eax
  101a0d:	68 85 36 10 00       	push   $0x103685
  101a12:	e8 26 e8 ff ff       	call   10023d <cprintf>
  101a17:	83 c4 10             	add    $0x10,%esp
}
  101a1a:	90                   	nop
  101a1b:	c9                   	leave  
  101a1c:	c3                   	ret    

00101a1d <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101a1d:	55                   	push   %ebp
  101a1e:	89 e5                	mov    %esp,%ebp
  101a20:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101a23:	8b 45 08             	mov    0x8(%ebp),%eax
  101a26:	8b 40 30             	mov    0x30(%eax),%eax
  101a29:	83 f8 2f             	cmp    $0x2f,%eax
  101a2c:	77 1e                	ja     101a4c <trap_dispatch+0x2f>
  101a2e:	83 f8 2e             	cmp    $0x2e,%eax
  101a31:	0f 83 b4 00 00 00    	jae    101aeb <trap_dispatch+0xce>
  101a37:	83 f8 21             	cmp    $0x21,%eax
  101a3a:	74 3e                	je     101a7a <trap_dispatch+0x5d>
  101a3c:	83 f8 24             	cmp    $0x24,%eax
  101a3f:	74 15                	je     101a56 <trap_dispatch+0x39>
  101a41:	83 f8 20             	cmp    $0x20,%eax
  101a44:	0f 84 a4 00 00 00    	je     101aee <trap_dispatch+0xd1>
  101a4a:	eb 69                	jmp    101ab5 <trap_dispatch+0x98>
  101a4c:	83 e8 78             	sub    $0x78,%eax
  101a4f:	83 f8 01             	cmp    $0x1,%eax
  101a52:	77 61                	ja     101ab5 <trap_dispatch+0x98>
  101a54:	eb 48                	jmp    101a9e <trap_dispatch+0x81>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101a56:	e8 90 fa ff ff       	call   1014eb <cons_getc>
  101a5b:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101a5e:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101a62:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101a66:	83 ec 04             	sub    $0x4,%esp
  101a69:	52                   	push   %edx
  101a6a:	50                   	push   %eax
  101a6b:	68 94 36 10 00       	push   $0x103694
  101a70:	e8 c8 e7 ff ff       	call   10023d <cprintf>
  101a75:	83 c4 10             	add    $0x10,%esp
        break;
  101a78:	eb 75                	jmp    101aef <trap_dispatch+0xd2>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101a7a:	e8 6c fa ff ff       	call   1014eb <cons_getc>
  101a7f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101a82:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101a86:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101a8a:	83 ec 04             	sub    $0x4,%esp
  101a8d:	52                   	push   %edx
  101a8e:	50                   	push   %eax
  101a8f:	68 a6 36 10 00       	push   $0x1036a6
  101a94:	e8 a4 e7 ff ff       	call   10023d <cprintf>
  101a99:	83 c4 10             	add    $0x10,%esp
        break;
  101a9c:	eb 51                	jmp    101aef <trap_dispatch+0xd2>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101a9e:	83 ec 04             	sub    $0x4,%esp
  101aa1:	68 b5 36 10 00       	push   $0x1036b5
  101aa6:	68 a2 00 00 00       	push   $0xa2
  101aab:	68 c5 36 10 00       	push   $0x1036c5
  101ab0:	e8 ee e8 ff ff       	call   1003a3 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101abc:	0f b7 c0             	movzwl %ax,%eax
  101abf:	83 e0 03             	and    $0x3,%eax
  101ac2:	85 c0                	test   %eax,%eax
  101ac4:	75 29                	jne    101aef <trap_dispatch+0xd2>
            print_trapframe(tf);
  101ac6:	83 ec 0c             	sub    $0xc,%esp
  101ac9:	ff 75 08             	pushl  0x8(%ebp)
  101acc:	e8 af fc ff ff       	call   101780 <print_trapframe>
  101ad1:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101ad4:	83 ec 04             	sub    $0x4,%esp
  101ad7:	68 d6 36 10 00       	push   $0x1036d6
  101adc:	68 ac 00 00 00       	push   $0xac
  101ae1:	68 c5 36 10 00       	push   $0x1036c5
  101ae6:	e8 b8 e8 ff ff       	call   1003a3 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101aeb:	90                   	nop
  101aec:	eb 01                	jmp    101aef <trap_dispatch+0xd2>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
  101aee:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101aef:	90                   	nop
  101af0:	c9                   	leave  
  101af1:	c3                   	ret    

00101af2 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101af2:	55                   	push   %ebp
  101af3:	89 e5                	mov    %esp,%ebp
  101af5:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101af8:	83 ec 0c             	sub    $0xc,%esp
  101afb:	ff 75 08             	pushl  0x8(%ebp)
  101afe:	e8 1a ff ff ff       	call   101a1d <trap_dispatch>
  101b03:	83 c4 10             	add    $0x10,%esp
}
  101b06:	90                   	nop
  101b07:	c9                   	leave  
  101b08:	c3                   	ret    

00101b09 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101b09:	6a 00                	push   $0x0
  pushl $0
  101b0b:	6a 00                	push   $0x0
  jmp __alltraps
  101b0d:	e9 69 0a 00 00       	jmp    10257b <__alltraps>

00101b12 <vector1>:
.globl vector1
vector1:
  pushl $0
  101b12:	6a 00                	push   $0x0
  pushl $1
  101b14:	6a 01                	push   $0x1
  jmp __alltraps
  101b16:	e9 60 0a 00 00       	jmp    10257b <__alltraps>

00101b1b <vector2>:
.globl vector2
vector2:
  pushl $0
  101b1b:	6a 00                	push   $0x0
  pushl $2
  101b1d:	6a 02                	push   $0x2
  jmp __alltraps
  101b1f:	e9 57 0a 00 00       	jmp    10257b <__alltraps>

00101b24 <vector3>:
.globl vector3
vector3:
  pushl $0
  101b24:	6a 00                	push   $0x0
  pushl $3
  101b26:	6a 03                	push   $0x3
  jmp __alltraps
  101b28:	e9 4e 0a 00 00       	jmp    10257b <__alltraps>

00101b2d <vector4>:
.globl vector4
vector4:
  pushl $0
  101b2d:	6a 00                	push   $0x0
  pushl $4
  101b2f:	6a 04                	push   $0x4
  jmp __alltraps
  101b31:	e9 45 0a 00 00       	jmp    10257b <__alltraps>

00101b36 <vector5>:
.globl vector5
vector5:
  pushl $0
  101b36:	6a 00                	push   $0x0
  pushl $5
  101b38:	6a 05                	push   $0x5
  jmp __alltraps
  101b3a:	e9 3c 0a 00 00       	jmp    10257b <__alltraps>

00101b3f <vector6>:
.globl vector6
vector6:
  pushl $0
  101b3f:	6a 00                	push   $0x0
  pushl $6
  101b41:	6a 06                	push   $0x6
  jmp __alltraps
  101b43:	e9 33 0a 00 00       	jmp    10257b <__alltraps>

00101b48 <vector7>:
.globl vector7
vector7:
  pushl $0
  101b48:	6a 00                	push   $0x0
  pushl $7
  101b4a:	6a 07                	push   $0x7
  jmp __alltraps
  101b4c:	e9 2a 0a 00 00       	jmp    10257b <__alltraps>

00101b51 <vector8>:
.globl vector8
vector8:
  pushl $8
  101b51:	6a 08                	push   $0x8
  jmp __alltraps
  101b53:	e9 23 0a 00 00       	jmp    10257b <__alltraps>

00101b58 <vector9>:
.globl vector9
vector9:
  pushl $0
  101b58:	6a 00                	push   $0x0
  pushl $9
  101b5a:	6a 09                	push   $0x9
  jmp __alltraps
  101b5c:	e9 1a 0a 00 00       	jmp    10257b <__alltraps>

00101b61 <vector10>:
.globl vector10
vector10:
  pushl $10
  101b61:	6a 0a                	push   $0xa
  jmp __alltraps
  101b63:	e9 13 0a 00 00       	jmp    10257b <__alltraps>

00101b68 <vector11>:
.globl vector11
vector11:
  pushl $11
  101b68:	6a 0b                	push   $0xb
  jmp __alltraps
  101b6a:	e9 0c 0a 00 00       	jmp    10257b <__alltraps>

00101b6f <vector12>:
.globl vector12
vector12:
  pushl $12
  101b6f:	6a 0c                	push   $0xc
  jmp __alltraps
  101b71:	e9 05 0a 00 00       	jmp    10257b <__alltraps>

00101b76 <vector13>:
.globl vector13
vector13:
  pushl $13
  101b76:	6a 0d                	push   $0xd
  jmp __alltraps
  101b78:	e9 fe 09 00 00       	jmp    10257b <__alltraps>

00101b7d <vector14>:
.globl vector14
vector14:
  pushl $14
  101b7d:	6a 0e                	push   $0xe
  jmp __alltraps
  101b7f:	e9 f7 09 00 00       	jmp    10257b <__alltraps>

00101b84 <vector15>:
.globl vector15
vector15:
  pushl $0
  101b84:	6a 00                	push   $0x0
  pushl $15
  101b86:	6a 0f                	push   $0xf
  jmp __alltraps
  101b88:	e9 ee 09 00 00       	jmp    10257b <__alltraps>

00101b8d <vector16>:
.globl vector16
vector16:
  pushl $0
  101b8d:	6a 00                	push   $0x0
  pushl $16
  101b8f:	6a 10                	push   $0x10
  jmp __alltraps
  101b91:	e9 e5 09 00 00       	jmp    10257b <__alltraps>

00101b96 <vector17>:
.globl vector17
vector17:
  pushl $17
  101b96:	6a 11                	push   $0x11
  jmp __alltraps
  101b98:	e9 de 09 00 00       	jmp    10257b <__alltraps>

00101b9d <vector18>:
.globl vector18
vector18:
  pushl $0
  101b9d:	6a 00                	push   $0x0
  pushl $18
  101b9f:	6a 12                	push   $0x12
  jmp __alltraps
  101ba1:	e9 d5 09 00 00       	jmp    10257b <__alltraps>

00101ba6 <vector19>:
.globl vector19
vector19:
  pushl $0
  101ba6:	6a 00                	push   $0x0
  pushl $19
  101ba8:	6a 13                	push   $0x13
  jmp __alltraps
  101baa:	e9 cc 09 00 00       	jmp    10257b <__alltraps>

00101baf <vector20>:
.globl vector20
vector20:
  pushl $0
  101baf:	6a 00                	push   $0x0
  pushl $20
  101bb1:	6a 14                	push   $0x14
  jmp __alltraps
  101bb3:	e9 c3 09 00 00       	jmp    10257b <__alltraps>

00101bb8 <vector21>:
.globl vector21
vector21:
  pushl $0
  101bb8:	6a 00                	push   $0x0
  pushl $21
  101bba:	6a 15                	push   $0x15
  jmp __alltraps
  101bbc:	e9 ba 09 00 00       	jmp    10257b <__alltraps>

00101bc1 <vector22>:
.globl vector22
vector22:
  pushl $0
  101bc1:	6a 00                	push   $0x0
  pushl $22
  101bc3:	6a 16                	push   $0x16
  jmp __alltraps
  101bc5:	e9 b1 09 00 00       	jmp    10257b <__alltraps>

00101bca <vector23>:
.globl vector23
vector23:
  pushl $0
  101bca:	6a 00                	push   $0x0
  pushl $23
  101bcc:	6a 17                	push   $0x17
  jmp __alltraps
  101bce:	e9 a8 09 00 00       	jmp    10257b <__alltraps>

00101bd3 <vector24>:
.globl vector24
vector24:
  pushl $0
  101bd3:	6a 00                	push   $0x0
  pushl $24
  101bd5:	6a 18                	push   $0x18
  jmp __alltraps
  101bd7:	e9 9f 09 00 00       	jmp    10257b <__alltraps>

00101bdc <vector25>:
.globl vector25
vector25:
  pushl $0
  101bdc:	6a 00                	push   $0x0
  pushl $25
  101bde:	6a 19                	push   $0x19
  jmp __alltraps
  101be0:	e9 96 09 00 00       	jmp    10257b <__alltraps>

00101be5 <vector26>:
.globl vector26
vector26:
  pushl $0
  101be5:	6a 00                	push   $0x0
  pushl $26
  101be7:	6a 1a                	push   $0x1a
  jmp __alltraps
  101be9:	e9 8d 09 00 00       	jmp    10257b <__alltraps>

00101bee <vector27>:
.globl vector27
vector27:
  pushl $0
  101bee:	6a 00                	push   $0x0
  pushl $27
  101bf0:	6a 1b                	push   $0x1b
  jmp __alltraps
  101bf2:	e9 84 09 00 00       	jmp    10257b <__alltraps>

00101bf7 <vector28>:
.globl vector28
vector28:
  pushl $0
  101bf7:	6a 00                	push   $0x0
  pushl $28
  101bf9:	6a 1c                	push   $0x1c
  jmp __alltraps
  101bfb:	e9 7b 09 00 00       	jmp    10257b <__alltraps>

00101c00 <vector29>:
.globl vector29
vector29:
  pushl $0
  101c00:	6a 00                	push   $0x0
  pushl $29
  101c02:	6a 1d                	push   $0x1d
  jmp __alltraps
  101c04:	e9 72 09 00 00       	jmp    10257b <__alltraps>

00101c09 <vector30>:
.globl vector30
vector30:
  pushl $0
  101c09:	6a 00                	push   $0x0
  pushl $30
  101c0b:	6a 1e                	push   $0x1e
  jmp __alltraps
  101c0d:	e9 69 09 00 00       	jmp    10257b <__alltraps>

00101c12 <vector31>:
.globl vector31
vector31:
  pushl $0
  101c12:	6a 00                	push   $0x0
  pushl $31
  101c14:	6a 1f                	push   $0x1f
  jmp __alltraps
  101c16:	e9 60 09 00 00       	jmp    10257b <__alltraps>

00101c1b <vector32>:
.globl vector32
vector32:
  pushl $0
  101c1b:	6a 00                	push   $0x0
  pushl $32
  101c1d:	6a 20                	push   $0x20
  jmp __alltraps
  101c1f:	e9 57 09 00 00       	jmp    10257b <__alltraps>

00101c24 <vector33>:
.globl vector33
vector33:
  pushl $0
  101c24:	6a 00                	push   $0x0
  pushl $33
  101c26:	6a 21                	push   $0x21
  jmp __alltraps
  101c28:	e9 4e 09 00 00       	jmp    10257b <__alltraps>

00101c2d <vector34>:
.globl vector34
vector34:
  pushl $0
  101c2d:	6a 00                	push   $0x0
  pushl $34
  101c2f:	6a 22                	push   $0x22
  jmp __alltraps
  101c31:	e9 45 09 00 00       	jmp    10257b <__alltraps>

00101c36 <vector35>:
.globl vector35
vector35:
  pushl $0
  101c36:	6a 00                	push   $0x0
  pushl $35
  101c38:	6a 23                	push   $0x23
  jmp __alltraps
  101c3a:	e9 3c 09 00 00       	jmp    10257b <__alltraps>

00101c3f <vector36>:
.globl vector36
vector36:
  pushl $0
  101c3f:	6a 00                	push   $0x0
  pushl $36
  101c41:	6a 24                	push   $0x24
  jmp __alltraps
  101c43:	e9 33 09 00 00       	jmp    10257b <__alltraps>

00101c48 <vector37>:
.globl vector37
vector37:
  pushl $0
  101c48:	6a 00                	push   $0x0
  pushl $37
  101c4a:	6a 25                	push   $0x25
  jmp __alltraps
  101c4c:	e9 2a 09 00 00       	jmp    10257b <__alltraps>

00101c51 <vector38>:
.globl vector38
vector38:
  pushl $0
  101c51:	6a 00                	push   $0x0
  pushl $38
  101c53:	6a 26                	push   $0x26
  jmp __alltraps
  101c55:	e9 21 09 00 00       	jmp    10257b <__alltraps>

00101c5a <vector39>:
.globl vector39
vector39:
  pushl $0
  101c5a:	6a 00                	push   $0x0
  pushl $39
  101c5c:	6a 27                	push   $0x27
  jmp __alltraps
  101c5e:	e9 18 09 00 00       	jmp    10257b <__alltraps>

00101c63 <vector40>:
.globl vector40
vector40:
  pushl $0
  101c63:	6a 00                	push   $0x0
  pushl $40
  101c65:	6a 28                	push   $0x28
  jmp __alltraps
  101c67:	e9 0f 09 00 00       	jmp    10257b <__alltraps>

00101c6c <vector41>:
.globl vector41
vector41:
  pushl $0
  101c6c:	6a 00                	push   $0x0
  pushl $41
  101c6e:	6a 29                	push   $0x29
  jmp __alltraps
  101c70:	e9 06 09 00 00       	jmp    10257b <__alltraps>

00101c75 <vector42>:
.globl vector42
vector42:
  pushl $0
  101c75:	6a 00                	push   $0x0
  pushl $42
  101c77:	6a 2a                	push   $0x2a
  jmp __alltraps
  101c79:	e9 fd 08 00 00       	jmp    10257b <__alltraps>

00101c7e <vector43>:
.globl vector43
vector43:
  pushl $0
  101c7e:	6a 00                	push   $0x0
  pushl $43
  101c80:	6a 2b                	push   $0x2b
  jmp __alltraps
  101c82:	e9 f4 08 00 00       	jmp    10257b <__alltraps>

00101c87 <vector44>:
.globl vector44
vector44:
  pushl $0
  101c87:	6a 00                	push   $0x0
  pushl $44
  101c89:	6a 2c                	push   $0x2c
  jmp __alltraps
  101c8b:	e9 eb 08 00 00       	jmp    10257b <__alltraps>

00101c90 <vector45>:
.globl vector45
vector45:
  pushl $0
  101c90:	6a 00                	push   $0x0
  pushl $45
  101c92:	6a 2d                	push   $0x2d
  jmp __alltraps
  101c94:	e9 e2 08 00 00       	jmp    10257b <__alltraps>

00101c99 <vector46>:
.globl vector46
vector46:
  pushl $0
  101c99:	6a 00                	push   $0x0
  pushl $46
  101c9b:	6a 2e                	push   $0x2e
  jmp __alltraps
  101c9d:	e9 d9 08 00 00       	jmp    10257b <__alltraps>

00101ca2 <vector47>:
.globl vector47
vector47:
  pushl $0
  101ca2:	6a 00                	push   $0x0
  pushl $47
  101ca4:	6a 2f                	push   $0x2f
  jmp __alltraps
  101ca6:	e9 d0 08 00 00       	jmp    10257b <__alltraps>

00101cab <vector48>:
.globl vector48
vector48:
  pushl $0
  101cab:	6a 00                	push   $0x0
  pushl $48
  101cad:	6a 30                	push   $0x30
  jmp __alltraps
  101caf:	e9 c7 08 00 00       	jmp    10257b <__alltraps>

00101cb4 <vector49>:
.globl vector49
vector49:
  pushl $0
  101cb4:	6a 00                	push   $0x0
  pushl $49
  101cb6:	6a 31                	push   $0x31
  jmp __alltraps
  101cb8:	e9 be 08 00 00       	jmp    10257b <__alltraps>

00101cbd <vector50>:
.globl vector50
vector50:
  pushl $0
  101cbd:	6a 00                	push   $0x0
  pushl $50
  101cbf:	6a 32                	push   $0x32
  jmp __alltraps
  101cc1:	e9 b5 08 00 00       	jmp    10257b <__alltraps>

00101cc6 <vector51>:
.globl vector51
vector51:
  pushl $0
  101cc6:	6a 00                	push   $0x0
  pushl $51
  101cc8:	6a 33                	push   $0x33
  jmp __alltraps
  101cca:	e9 ac 08 00 00       	jmp    10257b <__alltraps>

00101ccf <vector52>:
.globl vector52
vector52:
  pushl $0
  101ccf:	6a 00                	push   $0x0
  pushl $52
  101cd1:	6a 34                	push   $0x34
  jmp __alltraps
  101cd3:	e9 a3 08 00 00       	jmp    10257b <__alltraps>

00101cd8 <vector53>:
.globl vector53
vector53:
  pushl $0
  101cd8:	6a 00                	push   $0x0
  pushl $53
  101cda:	6a 35                	push   $0x35
  jmp __alltraps
  101cdc:	e9 9a 08 00 00       	jmp    10257b <__alltraps>

00101ce1 <vector54>:
.globl vector54
vector54:
  pushl $0
  101ce1:	6a 00                	push   $0x0
  pushl $54
  101ce3:	6a 36                	push   $0x36
  jmp __alltraps
  101ce5:	e9 91 08 00 00       	jmp    10257b <__alltraps>

00101cea <vector55>:
.globl vector55
vector55:
  pushl $0
  101cea:	6a 00                	push   $0x0
  pushl $55
  101cec:	6a 37                	push   $0x37
  jmp __alltraps
  101cee:	e9 88 08 00 00       	jmp    10257b <__alltraps>

00101cf3 <vector56>:
.globl vector56
vector56:
  pushl $0
  101cf3:	6a 00                	push   $0x0
  pushl $56
  101cf5:	6a 38                	push   $0x38
  jmp __alltraps
  101cf7:	e9 7f 08 00 00       	jmp    10257b <__alltraps>

00101cfc <vector57>:
.globl vector57
vector57:
  pushl $0
  101cfc:	6a 00                	push   $0x0
  pushl $57
  101cfe:	6a 39                	push   $0x39
  jmp __alltraps
  101d00:	e9 76 08 00 00       	jmp    10257b <__alltraps>

00101d05 <vector58>:
.globl vector58
vector58:
  pushl $0
  101d05:	6a 00                	push   $0x0
  pushl $58
  101d07:	6a 3a                	push   $0x3a
  jmp __alltraps
  101d09:	e9 6d 08 00 00       	jmp    10257b <__alltraps>

00101d0e <vector59>:
.globl vector59
vector59:
  pushl $0
  101d0e:	6a 00                	push   $0x0
  pushl $59
  101d10:	6a 3b                	push   $0x3b
  jmp __alltraps
  101d12:	e9 64 08 00 00       	jmp    10257b <__alltraps>

00101d17 <vector60>:
.globl vector60
vector60:
  pushl $0
  101d17:	6a 00                	push   $0x0
  pushl $60
  101d19:	6a 3c                	push   $0x3c
  jmp __alltraps
  101d1b:	e9 5b 08 00 00       	jmp    10257b <__alltraps>

00101d20 <vector61>:
.globl vector61
vector61:
  pushl $0
  101d20:	6a 00                	push   $0x0
  pushl $61
  101d22:	6a 3d                	push   $0x3d
  jmp __alltraps
  101d24:	e9 52 08 00 00       	jmp    10257b <__alltraps>

00101d29 <vector62>:
.globl vector62
vector62:
  pushl $0
  101d29:	6a 00                	push   $0x0
  pushl $62
  101d2b:	6a 3e                	push   $0x3e
  jmp __alltraps
  101d2d:	e9 49 08 00 00       	jmp    10257b <__alltraps>

00101d32 <vector63>:
.globl vector63
vector63:
  pushl $0
  101d32:	6a 00                	push   $0x0
  pushl $63
  101d34:	6a 3f                	push   $0x3f
  jmp __alltraps
  101d36:	e9 40 08 00 00       	jmp    10257b <__alltraps>

00101d3b <vector64>:
.globl vector64
vector64:
  pushl $0
  101d3b:	6a 00                	push   $0x0
  pushl $64
  101d3d:	6a 40                	push   $0x40
  jmp __alltraps
  101d3f:	e9 37 08 00 00       	jmp    10257b <__alltraps>

00101d44 <vector65>:
.globl vector65
vector65:
  pushl $0
  101d44:	6a 00                	push   $0x0
  pushl $65
  101d46:	6a 41                	push   $0x41
  jmp __alltraps
  101d48:	e9 2e 08 00 00       	jmp    10257b <__alltraps>

00101d4d <vector66>:
.globl vector66
vector66:
  pushl $0
  101d4d:	6a 00                	push   $0x0
  pushl $66
  101d4f:	6a 42                	push   $0x42
  jmp __alltraps
  101d51:	e9 25 08 00 00       	jmp    10257b <__alltraps>

00101d56 <vector67>:
.globl vector67
vector67:
  pushl $0
  101d56:	6a 00                	push   $0x0
  pushl $67
  101d58:	6a 43                	push   $0x43
  jmp __alltraps
  101d5a:	e9 1c 08 00 00       	jmp    10257b <__alltraps>

00101d5f <vector68>:
.globl vector68
vector68:
  pushl $0
  101d5f:	6a 00                	push   $0x0
  pushl $68
  101d61:	6a 44                	push   $0x44
  jmp __alltraps
  101d63:	e9 13 08 00 00       	jmp    10257b <__alltraps>

00101d68 <vector69>:
.globl vector69
vector69:
  pushl $0
  101d68:	6a 00                	push   $0x0
  pushl $69
  101d6a:	6a 45                	push   $0x45
  jmp __alltraps
  101d6c:	e9 0a 08 00 00       	jmp    10257b <__alltraps>

00101d71 <vector70>:
.globl vector70
vector70:
  pushl $0
  101d71:	6a 00                	push   $0x0
  pushl $70
  101d73:	6a 46                	push   $0x46
  jmp __alltraps
  101d75:	e9 01 08 00 00       	jmp    10257b <__alltraps>

00101d7a <vector71>:
.globl vector71
vector71:
  pushl $0
  101d7a:	6a 00                	push   $0x0
  pushl $71
  101d7c:	6a 47                	push   $0x47
  jmp __alltraps
  101d7e:	e9 f8 07 00 00       	jmp    10257b <__alltraps>

00101d83 <vector72>:
.globl vector72
vector72:
  pushl $0
  101d83:	6a 00                	push   $0x0
  pushl $72
  101d85:	6a 48                	push   $0x48
  jmp __alltraps
  101d87:	e9 ef 07 00 00       	jmp    10257b <__alltraps>

00101d8c <vector73>:
.globl vector73
vector73:
  pushl $0
  101d8c:	6a 00                	push   $0x0
  pushl $73
  101d8e:	6a 49                	push   $0x49
  jmp __alltraps
  101d90:	e9 e6 07 00 00       	jmp    10257b <__alltraps>

00101d95 <vector74>:
.globl vector74
vector74:
  pushl $0
  101d95:	6a 00                	push   $0x0
  pushl $74
  101d97:	6a 4a                	push   $0x4a
  jmp __alltraps
  101d99:	e9 dd 07 00 00       	jmp    10257b <__alltraps>

00101d9e <vector75>:
.globl vector75
vector75:
  pushl $0
  101d9e:	6a 00                	push   $0x0
  pushl $75
  101da0:	6a 4b                	push   $0x4b
  jmp __alltraps
  101da2:	e9 d4 07 00 00       	jmp    10257b <__alltraps>

00101da7 <vector76>:
.globl vector76
vector76:
  pushl $0
  101da7:	6a 00                	push   $0x0
  pushl $76
  101da9:	6a 4c                	push   $0x4c
  jmp __alltraps
  101dab:	e9 cb 07 00 00       	jmp    10257b <__alltraps>

00101db0 <vector77>:
.globl vector77
vector77:
  pushl $0
  101db0:	6a 00                	push   $0x0
  pushl $77
  101db2:	6a 4d                	push   $0x4d
  jmp __alltraps
  101db4:	e9 c2 07 00 00       	jmp    10257b <__alltraps>

00101db9 <vector78>:
.globl vector78
vector78:
  pushl $0
  101db9:	6a 00                	push   $0x0
  pushl $78
  101dbb:	6a 4e                	push   $0x4e
  jmp __alltraps
  101dbd:	e9 b9 07 00 00       	jmp    10257b <__alltraps>

00101dc2 <vector79>:
.globl vector79
vector79:
  pushl $0
  101dc2:	6a 00                	push   $0x0
  pushl $79
  101dc4:	6a 4f                	push   $0x4f
  jmp __alltraps
  101dc6:	e9 b0 07 00 00       	jmp    10257b <__alltraps>

00101dcb <vector80>:
.globl vector80
vector80:
  pushl $0
  101dcb:	6a 00                	push   $0x0
  pushl $80
  101dcd:	6a 50                	push   $0x50
  jmp __alltraps
  101dcf:	e9 a7 07 00 00       	jmp    10257b <__alltraps>

00101dd4 <vector81>:
.globl vector81
vector81:
  pushl $0
  101dd4:	6a 00                	push   $0x0
  pushl $81
  101dd6:	6a 51                	push   $0x51
  jmp __alltraps
  101dd8:	e9 9e 07 00 00       	jmp    10257b <__alltraps>

00101ddd <vector82>:
.globl vector82
vector82:
  pushl $0
  101ddd:	6a 00                	push   $0x0
  pushl $82
  101ddf:	6a 52                	push   $0x52
  jmp __alltraps
  101de1:	e9 95 07 00 00       	jmp    10257b <__alltraps>

00101de6 <vector83>:
.globl vector83
vector83:
  pushl $0
  101de6:	6a 00                	push   $0x0
  pushl $83
  101de8:	6a 53                	push   $0x53
  jmp __alltraps
  101dea:	e9 8c 07 00 00       	jmp    10257b <__alltraps>

00101def <vector84>:
.globl vector84
vector84:
  pushl $0
  101def:	6a 00                	push   $0x0
  pushl $84
  101df1:	6a 54                	push   $0x54
  jmp __alltraps
  101df3:	e9 83 07 00 00       	jmp    10257b <__alltraps>

00101df8 <vector85>:
.globl vector85
vector85:
  pushl $0
  101df8:	6a 00                	push   $0x0
  pushl $85
  101dfa:	6a 55                	push   $0x55
  jmp __alltraps
  101dfc:	e9 7a 07 00 00       	jmp    10257b <__alltraps>

00101e01 <vector86>:
.globl vector86
vector86:
  pushl $0
  101e01:	6a 00                	push   $0x0
  pushl $86
  101e03:	6a 56                	push   $0x56
  jmp __alltraps
  101e05:	e9 71 07 00 00       	jmp    10257b <__alltraps>

00101e0a <vector87>:
.globl vector87
vector87:
  pushl $0
  101e0a:	6a 00                	push   $0x0
  pushl $87
  101e0c:	6a 57                	push   $0x57
  jmp __alltraps
  101e0e:	e9 68 07 00 00       	jmp    10257b <__alltraps>

00101e13 <vector88>:
.globl vector88
vector88:
  pushl $0
  101e13:	6a 00                	push   $0x0
  pushl $88
  101e15:	6a 58                	push   $0x58
  jmp __alltraps
  101e17:	e9 5f 07 00 00       	jmp    10257b <__alltraps>

00101e1c <vector89>:
.globl vector89
vector89:
  pushl $0
  101e1c:	6a 00                	push   $0x0
  pushl $89
  101e1e:	6a 59                	push   $0x59
  jmp __alltraps
  101e20:	e9 56 07 00 00       	jmp    10257b <__alltraps>

00101e25 <vector90>:
.globl vector90
vector90:
  pushl $0
  101e25:	6a 00                	push   $0x0
  pushl $90
  101e27:	6a 5a                	push   $0x5a
  jmp __alltraps
  101e29:	e9 4d 07 00 00       	jmp    10257b <__alltraps>

00101e2e <vector91>:
.globl vector91
vector91:
  pushl $0
  101e2e:	6a 00                	push   $0x0
  pushl $91
  101e30:	6a 5b                	push   $0x5b
  jmp __alltraps
  101e32:	e9 44 07 00 00       	jmp    10257b <__alltraps>

00101e37 <vector92>:
.globl vector92
vector92:
  pushl $0
  101e37:	6a 00                	push   $0x0
  pushl $92
  101e39:	6a 5c                	push   $0x5c
  jmp __alltraps
  101e3b:	e9 3b 07 00 00       	jmp    10257b <__alltraps>

00101e40 <vector93>:
.globl vector93
vector93:
  pushl $0
  101e40:	6a 00                	push   $0x0
  pushl $93
  101e42:	6a 5d                	push   $0x5d
  jmp __alltraps
  101e44:	e9 32 07 00 00       	jmp    10257b <__alltraps>

00101e49 <vector94>:
.globl vector94
vector94:
  pushl $0
  101e49:	6a 00                	push   $0x0
  pushl $94
  101e4b:	6a 5e                	push   $0x5e
  jmp __alltraps
  101e4d:	e9 29 07 00 00       	jmp    10257b <__alltraps>

00101e52 <vector95>:
.globl vector95
vector95:
  pushl $0
  101e52:	6a 00                	push   $0x0
  pushl $95
  101e54:	6a 5f                	push   $0x5f
  jmp __alltraps
  101e56:	e9 20 07 00 00       	jmp    10257b <__alltraps>

00101e5b <vector96>:
.globl vector96
vector96:
  pushl $0
  101e5b:	6a 00                	push   $0x0
  pushl $96
  101e5d:	6a 60                	push   $0x60
  jmp __alltraps
  101e5f:	e9 17 07 00 00       	jmp    10257b <__alltraps>

00101e64 <vector97>:
.globl vector97
vector97:
  pushl $0
  101e64:	6a 00                	push   $0x0
  pushl $97
  101e66:	6a 61                	push   $0x61
  jmp __alltraps
  101e68:	e9 0e 07 00 00       	jmp    10257b <__alltraps>

00101e6d <vector98>:
.globl vector98
vector98:
  pushl $0
  101e6d:	6a 00                	push   $0x0
  pushl $98
  101e6f:	6a 62                	push   $0x62
  jmp __alltraps
  101e71:	e9 05 07 00 00       	jmp    10257b <__alltraps>

00101e76 <vector99>:
.globl vector99
vector99:
  pushl $0
  101e76:	6a 00                	push   $0x0
  pushl $99
  101e78:	6a 63                	push   $0x63
  jmp __alltraps
  101e7a:	e9 fc 06 00 00       	jmp    10257b <__alltraps>

00101e7f <vector100>:
.globl vector100
vector100:
  pushl $0
  101e7f:	6a 00                	push   $0x0
  pushl $100
  101e81:	6a 64                	push   $0x64
  jmp __alltraps
  101e83:	e9 f3 06 00 00       	jmp    10257b <__alltraps>

00101e88 <vector101>:
.globl vector101
vector101:
  pushl $0
  101e88:	6a 00                	push   $0x0
  pushl $101
  101e8a:	6a 65                	push   $0x65
  jmp __alltraps
  101e8c:	e9 ea 06 00 00       	jmp    10257b <__alltraps>

00101e91 <vector102>:
.globl vector102
vector102:
  pushl $0
  101e91:	6a 00                	push   $0x0
  pushl $102
  101e93:	6a 66                	push   $0x66
  jmp __alltraps
  101e95:	e9 e1 06 00 00       	jmp    10257b <__alltraps>

00101e9a <vector103>:
.globl vector103
vector103:
  pushl $0
  101e9a:	6a 00                	push   $0x0
  pushl $103
  101e9c:	6a 67                	push   $0x67
  jmp __alltraps
  101e9e:	e9 d8 06 00 00       	jmp    10257b <__alltraps>

00101ea3 <vector104>:
.globl vector104
vector104:
  pushl $0
  101ea3:	6a 00                	push   $0x0
  pushl $104
  101ea5:	6a 68                	push   $0x68
  jmp __alltraps
  101ea7:	e9 cf 06 00 00       	jmp    10257b <__alltraps>

00101eac <vector105>:
.globl vector105
vector105:
  pushl $0
  101eac:	6a 00                	push   $0x0
  pushl $105
  101eae:	6a 69                	push   $0x69
  jmp __alltraps
  101eb0:	e9 c6 06 00 00       	jmp    10257b <__alltraps>

00101eb5 <vector106>:
.globl vector106
vector106:
  pushl $0
  101eb5:	6a 00                	push   $0x0
  pushl $106
  101eb7:	6a 6a                	push   $0x6a
  jmp __alltraps
  101eb9:	e9 bd 06 00 00       	jmp    10257b <__alltraps>

00101ebe <vector107>:
.globl vector107
vector107:
  pushl $0
  101ebe:	6a 00                	push   $0x0
  pushl $107
  101ec0:	6a 6b                	push   $0x6b
  jmp __alltraps
  101ec2:	e9 b4 06 00 00       	jmp    10257b <__alltraps>

00101ec7 <vector108>:
.globl vector108
vector108:
  pushl $0
  101ec7:	6a 00                	push   $0x0
  pushl $108
  101ec9:	6a 6c                	push   $0x6c
  jmp __alltraps
  101ecb:	e9 ab 06 00 00       	jmp    10257b <__alltraps>

00101ed0 <vector109>:
.globl vector109
vector109:
  pushl $0
  101ed0:	6a 00                	push   $0x0
  pushl $109
  101ed2:	6a 6d                	push   $0x6d
  jmp __alltraps
  101ed4:	e9 a2 06 00 00       	jmp    10257b <__alltraps>

00101ed9 <vector110>:
.globl vector110
vector110:
  pushl $0
  101ed9:	6a 00                	push   $0x0
  pushl $110
  101edb:	6a 6e                	push   $0x6e
  jmp __alltraps
  101edd:	e9 99 06 00 00       	jmp    10257b <__alltraps>

00101ee2 <vector111>:
.globl vector111
vector111:
  pushl $0
  101ee2:	6a 00                	push   $0x0
  pushl $111
  101ee4:	6a 6f                	push   $0x6f
  jmp __alltraps
  101ee6:	e9 90 06 00 00       	jmp    10257b <__alltraps>

00101eeb <vector112>:
.globl vector112
vector112:
  pushl $0
  101eeb:	6a 00                	push   $0x0
  pushl $112
  101eed:	6a 70                	push   $0x70
  jmp __alltraps
  101eef:	e9 87 06 00 00       	jmp    10257b <__alltraps>

00101ef4 <vector113>:
.globl vector113
vector113:
  pushl $0
  101ef4:	6a 00                	push   $0x0
  pushl $113
  101ef6:	6a 71                	push   $0x71
  jmp __alltraps
  101ef8:	e9 7e 06 00 00       	jmp    10257b <__alltraps>

00101efd <vector114>:
.globl vector114
vector114:
  pushl $0
  101efd:	6a 00                	push   $0x0
  pushl $114
  101eff:	6a 72                	push   $0x72
  jmp __alltraps
  101f01:	e9 75 06 00 00       	jmp    10257b <__alltraps>

00101f06 <vector115>:
.globl vector115
vector115:
  pushl $0
  101f06:	6a 00                	push   $0x0
  pushl $115
  101f08:	6a 73                	push   $0x73
  jmp __alltraps
  101f0a:	e9 6c 06 00 00       	jmp    10257b <__alltraps>

00101f0f <vector116>:
.globl vector116
vector116:
  pushl $0
  101f0f:	6a 00                	push   $0x0
  pushl $116
  101f11:	6a 74                	push   $0x74
  jmp __alltraps
  101f13:	e9 63 06 00 00       	jmp    10257b <__alltraps>

00101f18 <vector117>:
.globl vector117
vector117:
  pushl $0
  101f18:	6a 00                	push   $0x0
  pushl $117
  101f1a:	6a 75                	push   $0x75
  jmp __alltraps
  101f1c:	e9 5a 06 00 00       	jmp    10257b <__alltraps>

00101f21 <vector118>:
.globl vector118
vector118:
  pushl $0
  101f21:	6a 00                	push   $0x0
  pushl $118
  101f23:	6a 76                	push   $0x76
  jmp __alltraps
  101f25:	e9 51 06 00 00       	jmp    10257b <__alltraps>

00101f2a <vector119>:
.globl vector119
vector119:
  pushl $0
  101f2a:	6a 00                	push   $0x0
  pushl $119
  101f2c:	6a 77                	push   $0x77
  jmp __alltraps
  101f2e:	e9 48 06 00 00       	jmp    10257b <__alltraps>

00101f33 <vector120>:
.globl vector120
vector120:
  pushl $0
  101f33:	6a 00                	push   $0x0
  pushl $120
  101f35:	6a 78                	push   $0x78
  jmp __alltraps
  101f37:	e9 3f 06 00 00       	jmp    10257b <__alltraps>

00101f3c <vector121>:
.globl vector121
vector121:
  pushl $0
  101f3c:	6a 00                	push   $0x0
  pushl $121
  101f3e:	6a 79                	push   $0x79
  jmp __alltraps
  101f40:	e9 36 06 00 00       	jmp    10257b <__alltraps>

00101f45 <vector122>:
.globl vector122
vector122:
  pushl $0
  101f45:	6a 00                	push   $0x0
  pushl $122
  101f47:	6a 7a                	push   $0x7a
  jmp __alltraps
  101f49:	e9 2d 06 00 00       	jmp    10257b <__alltraps>

00101f4e <vector123>:
.globl vector123
vector123:
  pushl $0
  101f4e:	6a 00                	push   $0x0
  pushl $123
  101f50:	6a 7b                	push   $0x7b
  jmp __alltraps
  101f52:	e9 24 06 00 00       	jmp    10257b <__alltraps>

00101f57 <vector124>:
.globl vector124
vector124:
  pushl $0
  101f57:	6a 00                	push   $0x0
  pushl $124
  101f59:	6a 7c                	push   $0x7c
  jmp __alltraps
  101f5b:	e9 1b 06 00 00       	jmp    10257b <__alltraps>

00101f60 <vector125>:
.globl vector125
vector125:
  pushl $0
  101f60:	6a 00                	push   $0x0
  pushl $125
  101f62:	6a 7d                	push   $0x7d
  jmp __alltraps
  101f64:	e9 12 06 00 00       	jmp    10257b <__alltraps>

00101f69 <vector126>:
.globl vector126
vector126:
  pushl $0
  101f69:	6a 00                	push   $0x0
  pushl $126
  101f6b:	6a 7e                	push   $0x7e
  jmp __alltraps
  101f6d:	e9 09 06 00 00       	jmp    10257b <__alltraps>

00101f72 <vector127>:
.globl vector127
vector127:
  pushl $0
  101f72:	6a 00                	push   $0x0
  pushl $127
  101f74:	6a 7f                	push   $0x7f
  jmp __alltraps
  101f76:	e9 00 06 00 00       	jmp    10257b <__alltraps>

00101f7b <vector128>:
.globl vector128
vector128:
  pushl $0
  101f7b:	6a 00                	push   $0x0
  pushl $128
  101f7d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  101f82:	e9 f4 05 00 00       	jmp    10257b <__alltraps>

00101f87 <vector129>:
.globl vector129
vector129:
  pushl $0
  101f87:	6a 00                	push   $0x0
  pushl $129
  101f89:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  101f8e:	e9 e8 05 00 00       	jmp    10257b <__alltraps>

00101f93 <vector130>:
.globl vector130
vector130:
  pushl $0
  101f93:	6a 00                	push   $0x0
  pushl $130
  101f95:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  101f9a:	e9 dc 05 00 00       	jmp    10257b <__alltraps>

00101f9f <vector131>:
.globl vector131
vector131:
  pushl $0
  101f9f:	6a 00                	push   $0x0
  pushl $131
  101fa1:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  101fa6:	e9 d0 05 00 00       	jmp    10257b <__alltraps>

00101fab <vector132>:
.globl vector132
vector132:
  pushl $0
  101fab:	6a 00                	push   $0x0
  pushl $132
  101fad:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  101fb2:	e9 c4 05 00 00       	jmp    10257b <__alltraps>

00101fb7 <vector133>:
.globl vector133
vector133:
  pushl $0
  101fb7:	6a 00                	push   $0x0
  pushl $133
  101fb9:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  101fbe:	e9 b8 05 00 00       	jmp    10257b <__alltraps>

00101fc3 <vector134>:
.globl vector134
vector134:
  pushl $0
  101fc3:	6a 00                	push   $0x0
  pushl $134
  101fc5:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  101fca:	e9 ac 05 00 00       	jmp    10257b <__alltraps>

00101fcf <vector135>:
.globl vector135
vector135:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $135
  101fd1:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  101fd6:	e9 a0 05 00 00       	jmp    10257b <__alltraps>

00101fdb <vector136>:
.globl vector136
vector136:
  pushl $0
  101fdb:	6a 00                	push   $0x0
  pushl $136
  101fdd:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  101fe2:	e9 94 05 00 00       	jmp    10257b <__alltraps>

00101fe7 <vector137>:
.globl vector137
vector137:
  pushl $0
  101fe7:	6a 00                	push   $0x0
  pushl $137
  101fe9:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  101fee:	e9 88 05 00 00       	jmp    10257b <__alltraps>

00101ff3 <vector138>:
.globl vector138
vector138:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $138
  101ff5:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  101ffa:	e9 7c 05 00 00       	jmp    10257b <__alltraps>

00101fff <vector139>:
.globl vector139
vector139:
  pushl $0
  101fff:	6a 00                	push   $0x0
  pushl $139
  102001:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102006:	e9 70 05 00 00       	jmp    10257b <__alltraps>

0010200b <vector140>:
.globl vector140
vector140:
  pushl $0
  10200b:	6a 00                	push   $0x0
  pushl $140
  10200d:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102012:	e9 64 05 00 00       	jmp    10257b <__alltraps>

00102017 <vector141>:
.globl vector141
vector141:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $141
  102019:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10201e:	e9 58 05 00 00       	jmp    10257b <__alltraps>

00102023 <vector142>:
.globl vector142
vector142:
  pushl $0
  102023:	6a 00                	push   $0x0
  pushl $142
  102025:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10202a:	e9 4c 05 00 00       	jmp    10257b <__alltraps>

0010202f <vector143>:
.globl vector143
vector143:
  pushl $0
  10202f:	6a 00                	push   $0x0
  pushl $143
  102031:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102036:	e9 40 05 00 00       	jmp    10257b <__alltraps>

0010203b <vector144>:
.globl vector144
vector144:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $144
  10203d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102042:	e9 34 05 00 00       	jmp    10257b <__alltraps>

00102047 <vector145>:
.globl vector145
vector145:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $145
  102049:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10204e:	e9 28 05 00 00       	jmp    10257b <__alltraps>

00102053 <vector146>:
.globl vector146
vector146:
  pushl $0
  102053:	6a 00                	push   $0x0
  pushl $146
  102055:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10205a:	e9 1c 05 00 00       	jmp    10257b <__alltraps>

0010205f <vector147>:
.globl vector147
vector147:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $147
  102061:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102066:	e9 10 05 00 00       	jmp    10257b <__alltraps>

0010206b <vector148>:
.globl vector148
vector148:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $148
  10206d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102072:	e9 04 05 00 00       	jmp    10257b <__alltraps>

00102077 <vector149>:
.globl vector149
vector149:
  pushl $0
  102077:	6a 00                	push   $0x0
  pushl $149
  102079:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10207e:	e9 f8 04 00 00       	jmp    10257b <__alltraps>

00102083 <vector150>:
.globl vector150
vector150:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $150
  102085:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10208a:	e9 ec 04 00 00       	jmp    10257b <__alltraps>

0010208f <vector151>:
.globl vector151
vector151:
  pushl $0
  10208f:	6a 00                	push   $0x0
  pushl $151
  102091:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102096:	e9 e0 04 00 00       	jmp    10257b <__alltraps>

0010209b <vector152>:
.globl vector152
vector152:
  pushl $0
  10209b:	6a 00                	push   $0x0
  pushl $152
  10209d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1020a2:	e9 d4 04 00 00       	jmp    10257b <__alltraps>

001020a7 <vector153>:
.globl vector153
vector153:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $153
  1020a9:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1020ae:	e9 c8 04 00 00       	jmp    10257b <__alltraps>

001020b3 <vector154>:
.globl vector154
vector154:
  pushl $0
  1020b3:	6a 00                	push   $0x0
  pushl $154
  1020b5:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1020ba:	e9 bc 04 00 00       	jmp    10257b <__alltraps>

001020bf <vector155>:
.globl vector155
vector155:
  pushl $0
  1020bf:	6a 00                	push   $0x0
  pushl $155
  1020c1:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1020c6:	e9 b0 04 00 00       	jmp    10257b <__alltraps>

001020cb <vector156>:
.globl vector156
vector156:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $156
  1020cd:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1020d2:	e9 a4 04 00 00       	jmp    10257b <__alltraps>

001020d7 <vector157>:
.globl vector157
vector157:
  pushl $0
  1020d7:	6a 00                	push   $0x0
  pushl $157
  1020d9:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1020de:	e9 98 04 00 00       	jmp    10257b <__alltraps>

001020e3 <vector158>:
.globl vector158
vector158:
  pushl $0
  1020e3:	6a 00                	push   $0x0
  pushl $158
  1020e5:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1020ea:	e9 8c 04 00 00       	jmp    10257b <__alltraps>

001020ef <vector159>:
.globl vector159
vector159:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $159
  1020f1:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1020f6:	e9 80 04 00 00       	jmp    10257b <__alltraps>

001020fb <vector160>:
.globl vector160
vector160:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $160
  1020fd:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102102:	e9 74 04 00 00       	jmp    10257b <__alltraps>

00102107 <vector161>:
.globl vector161
vector161:
  pushl $0
  102107:	6a 00                	push   $0x0
  pushl $161
  102109:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10210e:	e9 68 04 00 00       	jmp    10257b <__alltraps>

00102113 <vector162>:
.globl vector162
vector162:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $162
  102115:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10211a:	e9 5c 04 00 00       	jmp    10257b <__alltraps>

0010211f <vector163>:
.globl vector163
vector163:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $163
  102121:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102126:	e9 50 04 00 00       	jmp    10257b <__alltraps>

0010212b <vector164>:
.globl vector164
vector164:
  pushl $0
  10212b:	6a 00                	push   $0x0
  pushl $164
  10212d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102132:	e9 44 04 00 00       	jmp    10257b <__alltraps>

00102137 <vector165>:
.globl vector165
vector165:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $165
  102139:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10213e:	e9 38 04 00 00       	jmp    10257b <__alltraps>

00102143 <vector166>:
.globl vector166
vector166:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $166
  102145:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10214a:	e9 2c 04 00 00       	jmp    10257b <__alltraps>

0010214f <vector167>:
.globl vector167
vector167:
  pushl $0
  10214f:	6a 00                	push   $0x0
  pushl $167
  102151:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102156:	e9 20 04 00 00       	jmp    10257b <__alltraps>

0010215b <vector168>:
.globl vector168
vector168:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $168
  10215d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102162:	e9 14 04 00 00       	jmp    10257b <__alltraps>

00102167 <vector169>:
.globl vector169
vector169:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $169
  102169:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10216e:	e9 08 04 00 00       	jmp    10257b <__alltraps>

00102173 <vector170>:
.globl vector170
vector170:
  pushl $0
  102173:	6a 00                	push   $0x0
  pushl $170
  102175:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10217a:	e9 fc 03 00 00       	jmp    10257b <__alltraps>

0010217f <vector171>:
.globl vector171
vector171:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $171
  102181:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102186:	e9 f0 03 00 00       	jmp    10257b <__alltraps>

0010218b <vector172>:
.globl vector172
vector172:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $172
  10218d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102192:	e9 e4 03 00 00       	jmp    10257b <__alltraps>

00102197 <vector173>:
.globl vector173
vector173:
  pushl $0
  102197:	6a 00                	push   $0x0
  pushl $173
  102199:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10219e:	e9 d8 03 00 00       	jmp    10257b <__alltraps>

001021a3 <vector174>:
.globl vector174
vector174:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $174
  1021a5:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1021aa:	e9 cc 03 00 00       	jmp    10257b <__alltraps>

001021af <vector175>:
.globl vector175
vector175:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $175
  1021b1:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1021b6:	e9 c0 03 00 00       	jmp    10257b <__alltraps>

001021bb <vector176>:
.globl vector176
vector176:
  pushl $0
  1021bb:	6a 00                	push   $0x0
  pushl $176
  1021bd:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1021c2:	e9 b4 03 00 00       	jmp    10257b <__alltraps>

001021c7 <vector177>:
.globl vector177
vector177:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $177
  1021c9:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1021ce:	e9 a8 03 00 00       	jmp    10257b <__alltraps>

001021d3 <vector178>:
.globl vector178
vector178:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $178
  1021d5:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1021da:	e9 9c 03 00 00       	jmp    10257b <__alltraps>

001021df <vector179>:
.globl vector179
vector179:
  pushl $0
  1021df:	6a 00                	push   $0x0
  pushl $179
  1021e1:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1021e6:	e9 90 03 00 00       	jmp    10257b <__alltraps>

001021eb <vector180>:
.globl vector180
vector180:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $180
  1021ed:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1021f2:	e9 84 03 00 00       	jmp    10257b <__alltraps>

001021f7 <vector181>:
.globl vector181
vector181:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $181
  1021f9:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1021fe:	e9 78 03 00 00       	jmp    10257b <__alltraps>

00102203 <vector182>:
.globl vector182
vector182:
  pushl $0
  102203:	6a 00                	push   $0x0
  pushl $182
  102205:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10220a:	e9 6c 03 00 00       	jmp    10257b <__alltraps>

0010220f <vector183>:
.globl vector183
vector183:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $183
  102211:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102216:	e9 60 03 00 00       	jmp    10257b <__alltraps>

0010221b <vector184>:
.globl vector184
vector184:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $184
  10221d:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102222:	e9 54 03 00 00       	jmp    10257b <__alltraps>

00102227 <vector185>:
.globl vector185
vector185:
  pushl $0
  102227:	6a 00                	push   $0x0
  pushl $185
  102229:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10222e:	e9 48 03 00 00       	jmp    10257b <__alltraps>

00102233 <vector186>:
.globl vector186
vector186:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $186
  102235:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10223a:	e9 3c 03 00 00       	jmp    10257b <__alltraps>

0010223f <vector187>:
.globl vector187
vector187:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $187
  102241:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102246:	e9 30 03 00 00       	jmp    10257b <__alltraps>

0010224b <vector188>:
.globl vector188
vector188:
  pushl $0
  10224b:	6a 00                	push   $0x0
  pushl $188
  10224d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102252:	e9 24 03 00 00       	jmp    10257b <__alltraps>

00102257 <vector189>:
.globl vector189
vector189:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $189
  102259:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10225e:	e9 18 03 00 00       	jmp    10257b <__alltraps>

00102263 <vector190>:
.globl vector190
vector190:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $190
  102265:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10226a:	e9 0c 03 00 00       	jmp    10257b <__alltraps>

0010226f <vector191>:
.globl vector191
vector191:
  pushl $0
  10226f:	6a 00                	push   $0x0
  pushl $191
  102271:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102276:	e9 00 03 00 00       	jmp    10257b <__alltraps>

0010227b <vector192>:
.globl vector192
vector192:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $192
  10227d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102282:	e9 f4 02 00 00       	jmp    10257b <__alltraps>

00102287 <vector193>:
.globl vector193
vector193:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $193
  102289:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10228e:	e9 e8 02 00 00       	jmp    10257b <__alltraps>

00102293 <vector194>:
.globl vector194
vector194:
  pushl $0
  102293:	6a 00                	push   $0x0
  pushl $194
  102295:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10229a:	e9 dc 02 00 00       	jmp    10257b <__alltraps>

0010229f <vector195>:
.globl vector195
vector195:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $195
  1022a1:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1022a6:	e9 d0 02 00 00       	jmp    10257b <__alltraps>

001022ab <vector196>:
.globl vector196
vector196:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $196
  1022ad:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1022b2:	e9 c4 02 00 00       	jmp    10257b <__alltraps>

001022b7 <vector197>:
.globl vector197
vector197:
  pushl $0
  1022b7:	6a 00                	push   $0x0
  pushl $197
  1022b9:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1022be:	e9 b8 02 00 00       	jmp    10257b <__alltraps>

001022c3 <vector198>:
.globl vector198
vector198:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $198
  1022c5:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1022ca:	e9 ac 02 00 00       	jmp    10257b <__alltraps>

001022cf <vector199>:
.globl vector199
vector199:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $199
  1022d1:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1022d6:	e9 a0 02 00 00       	jmp    10257b <__alltraps>

001022db <vector200>:
.globl vector200
vector200:
  pushl $0
  1022db:	6a 00                	push   $0x0
  pushl $200
  1022dd:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1022e2:	e9 94 02 00 00       	jmp    10257b <__alltraps>

001022e7 <vector201>:
.globl vector201
vector201:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $201
  1022e9:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1022ee:	e9 88 02 00 00       	jmp    10257b <__alltraps>

001022f3 <vector202>:
.globl vector202
vector202:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $202
  1022f5:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1022fa:	e9 7c 02 00 00       	jmp    10257b <__alltraps>

001022ff <vector203>:
.globl vector203
vector203:
  pushl $0
  1022ff:	6a 00                	push   $0x0
  pushl $203
  102301:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102306:	e9 70 02 00 00       	jmp    10257b <__alltraps>

0010230b <vector204>:
.globl vector204
vector204:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $204
  10230d:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102312:	e9 64 02 00 00       	jmp    10257b <__alltraps>

00102317 <vector205>:
.globl vector205
vector205:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $205
  102319:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10231e:	e9 58 02 00 00       	jmp    10257b <__alltraps>

00102323 <vector206>:
.globl vector206
vector206:
  pushl $0
  102323:	6a 00                	push   $0x0
  pushl $206
  102325:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10232a:	e9 4c 02 00 00       	jmp    10257b <__alltraps>

0010232f <vector207>:
.globl vector207
vector207:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $207
  102331:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102336:	e9 40 02 00 00       	jmp    10257b <__alltraps>

0010233b <vector208>:
.globl vector208
vector208:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $208
  10233d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102342:	e9 34 02 00 00       	jmp    10257b <__alltraps>

00102347 <vector209>:
.globl vector209
vector209:
  pushl $0
  102347:	6a 00                	push   $0x0
  pushl $209
  102349:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10234e:	e9 28 02 00 00       	jmp    10257b <__alltraps>

00102353 <vector210>:
.globl vector210
vector210:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $210
  102355:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10235a:	e9 1c 02 00 00       	jmp    10257b <__alltraps>

0010235f <vector211>:
.globl vector211
vector211:
  pushl $0
  10235f:	6a 00                	push   $0x0
  pushl $211
  102361:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102366:	e9 10 02 00 00       	jmp    10257b <__alltraps>

0010236b <vector212>:
.globl vector212
vector212:
  pushl $0
  10236b:	6a 00                	push   $0x0
  pushl $212
  10236d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102372:	e9 04 02 00 00       	jmp    10257b <__alltraps>

00102377 <vector213>:
.globl vector213
vector213:
  pushl $0
  102377:	6a 00                	push   $0x0
  pushl $213
  102379:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10237e:	e9 f8 01 00 00       	jmp    10257b <__alltraps>

00102383 <vector214>:
.globl vector214
vector214:
  pushl $0
  102383:	6a 00                	push   $0x0
  pushl $214
  102385:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10238a:	e9 ec 01 00 00       	jmp    10257b <__alltraps>

0010238f <vector215>:
.globl vector215
vector215:
  pushl $0
  10238f:	6a 00                	push   $0x0
  pushl $215
  102391:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102396:	e9 e0 01 00 00       	jmp    10257b <__alltraps>

0010239b <vector216>:
.globl vector216
vector216:
  pushl $0
  10239b:	6a 00                	push   $0x0
  pushl $216
  10239d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1023a2:	e9 d4 01 00 00       	jmp    10257b <__alltraps>

001023a7 <vector217>:
.globl vector217
vector217:
  pushl $0
  1023a7:	6a 00                	push   $0x0
  pushl $217
  1023a9:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1023ae:	e9 c8 01 00 00       	jmp    10257b <__alltraps>

001023b3 <vector218>:
.globl vector218
vector218:
  pushl $0
  1023b3:	6a 00                	push   $0x0
  pushl $218
  1023b5:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1023ba:	e9 bc 01 00 00       	jmp    10257b <__alltraps>

001023bf <vector219>:
.globl vector219
vector219:
  pushl $0
  1023bf:	6a 00                	push   $0x0
  pushl $219
  1023c1:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1023c6:	e9 b0 01 00 00       	jmp    10257b <__alltraps>

001023cb <vector220>:
.globl vector220
vector220:
  pushl $0
  1023cb:	6a 00                	push   $0x0
  pushl $220
  1023cd:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1023d2:	e9 a4 01 00 00       	jmp    10257b <__alltraps>

001023d7 <vector221>:
.globl vector221
vector221:
  pushl $0
  1023d7:	6a 00                	push   $0x0
  pushl $221
  1023d9:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1023de:	e9 98 01 00 00       	jmp    10257b <__alltraps>

001023e3 <vector222>:
.globl vector222
vector222:
  pushl $0
  1023e3:	6a 00                	push   $0x0
  pushl $222
  1023e5:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1023ea:	e9 8c 01 00 00       	jmp    10257b <__alltraps>

001023ef <vector223>:
.globl vector223
vector223:
  pushl $0
  1023ef:	6a 00                	push   $0x0
  pushl $223
  1023f1:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1023f6:	e9 80 01 00 00       	jmp    10257b <__alltraps>

001023fb <vector224>:
.globl vector224
vector224:
  pushl $0
  1023fb:	6a 00                	push   $0x0
  pushl $224
  1023fd:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102402:	e9 74 01 00 00       	jmp    10257b <__alltraps>

00102407 <vector225>:
.globl vector225
vector225:
  pushl $0
  102407:	6a 00                	push   $0x0
  pushl $225
  102409:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10240e:	e9 68 01 00 00       	jmp    10257b <__alltraps>

00102413 <vector226>:
.globl vector226
vector226:
  pushl $0
  102413:	6a 00                	push   $0x0
  pushl $226
  102415:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10241a:	e9 5c 01 00 00       	jmp    10257b <__alltraps>

0010241f <vector227>:
.globl vector227
vector227:
  pushl $0
  10241f:	6a 00                	push   $0x0
  pushl $227
  102421:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102426:	e9 50 01 00 00       	jmp    10257b <__alltraps>

0010242b <vector228>:
.globl vector228
vector228:
  pushl $0
  10242b:	6a 00                	push   $0x0
  pushl $228
  10242d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102432:	e9 44 01 00 00       	jmp    10257b <__alltraps>

00102437 <vector229>:
.globl vector229
vector229:
  pushl $0
  102437:	6a 00                	push   $0x0
  pushl $229
  102439:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10243e:	e9 38 01 00 00       	jmp    10257b <__alltraps>

00102443 <vector230>:
.globl vector230
vector230:
  pushl $0
  102443:	6a 00                	push   $0x0
  pushl $230
  102445:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10244a:	e9 2c 01 00 00       	jmp    10257b <__alltraps>

0010244f <vector231>:
.globl vector231
vector231:
  pushl $0
  10244f:	6a 00                	push   $0x0
  pushl $231
  102451:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102456:	e9 20 01 00 00       	jmp    10257b <__alltraps>

0010245b <vector232>:
.globl vector232
vector232:
  pushl $0
  10245b:	6a 00                	push   $0x0
  pushl $232
  10245d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102462:	e9 14 01 00 00       	jmp    10257b <__alltraps>

00102467 <vector233>:
.globl vector233
vector233:
  pushl $0
  102467:	6a 00                	push   $0x0
  pushl $233
  102469:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10246e:	e9 08 01 00 00       	jmp    10257b <__alltraps>

00102473 <vector234>:
.globl vector234
vector234:
  pushl $0
  102473:	6a 00                	push   $0x0
  pushl $234
  102475:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10247a:	e9 fc 00 00 00       	jmp    10257b <__alltraps>

0010247f <vector235>:
.globl vector235
vector235:
  pushl $0
  10247f:	6a 00                	push   $0x0
  pushl $235
  102481:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102486:	e9 f0 00 00 00       	jmp    10257b <__alltraps>

0010248b <vector236>:
.globl vector236
vector236:
  pushl $0
  10248b:	6a 00                	push   $0x0
  pushl $236
  10248d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102492:	e9 e4 00 00 00       	jmp    10257b <__alltraps>

00102497 <vector237>:
.globl vector237
vector237:
  pushl $0
  102497:	6a 00                	push   $0x0
  pushl $237
  102499:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10249e:	e9 d8 00 00 00       	jmp    10257b <__alltraps>

001024a3 <vector238>:
.globl vector238
vector238:
  pushl $0
  1024a3:	6a 00                	push   $0x0
  pushl $238
  1024a5:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1024aa:	e9 cc 00 00 00       	jmp    10257b <__alltraps>

001024af <vector239>:
.globl vector239
vector239:
  pushl $0
  1024af:	6a 00                	push   $0x0
  pushl $239
  1024b1:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1024b6:	e9 c0 00 00 00       	jmp    10257b <__alltraps>

001024bb <vector240>:
.globl vector240
vector240:
  pushl $0
  1024bb:	6a 00                	push   $0x0
  pushl $240
  1024bd:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1024c2:	e9 b4 00 00 00       	jmp    10257b <__alltraps>

001024c7 <vector241>:
.globl vector241
vector241:
  pushl $0
  1024c7:	6a 00                	push   $0x0
  pushl $241
  1024c9:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1024ce:	e9 a8 00 00 00       	jmp    10257b <__alltraps>

001024d3 <vector242>:
.globl vector242
vector242:
  pushl $0
  1024d3:	6a 00                	push   $0x0
  pushl $242
  1024d5:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1024da:	e9 9c 00 00 00       	jmp    10257b <__alltraps>

001024df <vector243>:
.globl vector243
vector243:
  pushl $0
  1024df:	6a 00                	push   $0x0
  pushl $243
  1024e1:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1024e6:	e9 90 00 00 00       	jmp    10257b <__alltraps>

001024eb <vector244>:
.globl vector244
vector244:
  pushl $0
  1024eb:	6a 00                	push   $0x0
  pushl $244
  1024ed:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1024f2:	e9 84 00 00 00       	jmp    10257b <__alltraps>

001024f7 <vector245>:
.globl vector245
vector245:
  pushl $0
  1024f7:	6a 00                	push   $0x0
  pushl $245
  1024f9:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1024fe:	e9 78 00 00 00       	jmp    10257b <__alltraps>

00102503 <vector246>:
.globl vector246
vector246:
  pushl $0
  102503:	6a 00                	push   $0x0
  pushl $246
  102505:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10250a:	e9 6c 00 00 00       	jmp    10257b <__alltraps>

0010250f <vector247>:
.globl vector247
vector247:
  pushl $0
  10250f:	6a 00                	push   $0x0
  pushl $247
  102511:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102516:	e9 60 00 00 00       	jmp    10257b <__alltraps>

0010251b <vector248>:
.globl vector248
vector248:
  pushl $0
  10251b:	6a 00                	push   $0x0
  pushl $248
  10251d:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102522:	e9 54 00 00 00       	jmp    10257b <__alltraps>

00102527 <vector249>:
.globl vector249
vector249:
  pushl $0
  102527:	6a 00                	push   $0x0
  pushl $249
  102529:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10252e:	e9 48 00 00 00       	jmp    10257b <__alltraps>

00102533 <vector250>:
.globl vector250
vector250:
  pushl $0
  102533:	6a 00                	push   $0x0
  pushl $250
  102535:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10253a:	e9 3c 00 00 00       	jmp    10257b <__alltraps>

0010253f <vector251>:
.globl vector251
vector251:
  pushl $0
  10253f:	6a 00                	push   $0x0
  pushl $251
  102541:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102546:	e9 30 00 00 00       	jmp    10257b <__alltraps>

0010254b <vector252>:
.globl vector252
vector252:
  pushl $0
  10254b:	6a 00                	push   $0x0
  pushl $252
  10254d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102552:	e9 24 00 00 00       	jmp    10257b <__alltraps>

00102557 <vector253>:
.globl vector253
vector253:
  pushl $0
  102557:	6a 00                	push   $0x0
  pushl $253
  102559:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10255e:	e9 18 00 00 00       	jmp    10257b <__alltraps>

00102563 <vector254>:
.globl vector254
vector254:
  pushl $0
  102563:	6a 00                	push   $0x0
  pushl $254
  102565:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10256a:	e9 0c 00 00 00       	jmp    10257b <__alltraps>

0010256f <vector255>:
.globl vector255
vector255:
  pushl $0
  10256f:	6a 00                	push   $0x0
  pushl $255
  102571:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102576:	e9 00 00 00 00       	jmp    10257b <__alltraps>

0010257b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10257b:	1e                   	push   %ds
    pushl %es
  10257c:	06                   	push   %es
    pushl %fs
  10257d:	0f a0                	push   %fs
    pushl %gs
  10257f:	0f a8                	push   %gs
    pushal
  102581:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102582:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102587:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102589:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10258b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10258c:	e8 61 f5 ff ff       	call   101af2 <trap>

    # pop the pushed stack pointer
    popl %esp
  102591:	5c                   	pop    %esp

00102592 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102592:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102593:	0f a9                	pop    %gs
    popl %fs
  102595:	0f a1                	pop    %fs
    popl %es
  102597:	07                   	pop    %es
    popl %ds
  102598:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102599:	83 c4 08             	add    $0x8,%esp
    iret
  10259c:	cf                   	iret   

0010259d <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10259d:	55                   	push   %ebp
  10259e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1025a3:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1025a6:	b8 23 00 00 00       	mov    $0x23,%eax
  1025ab:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1025ad:	b8 23 00 00 00       	mov    $0x23,%eax
  1025b2:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1025b4:	b8 10 00 00 00       	mov    $0x10,%eax
  1025b9:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1025bb:	b8 10 00 00 00       	mov    $0x10,%eax
  1025c0:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1025c2:	b8 10 00 00 00       	mov    $0x10,%eax
  1025c7:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1025c9:	ea d0 25 10 00 08 00 	ljmp   $0x8,$0x1025d0
}
  1025d0:	90                   	nop
  1025d1:	5d                   	pop    %ebp
  1025d2:	c3                   	ret    

001025d3 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1025d3:	55                   	push   %ebp
  1025d4:	89 e5                	mov    %esp,%ebp
  1025d6:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1025d9:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  1025de:	05 00 04 00 00       	add    $0x400,%eax
  1025e3:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1025e8:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1025ef:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1025f1:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1025f8:	68 00 
  1025fa:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1025ff:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102605:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10260a:	c1 e8 10             	shr    $0x10,%eax
  10260d:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102612:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102619:	83 e0 f0             	and    $0xfffffff0,%eax
  10261c:	83 c8 09             	or     $0x9,%eax
  10261f:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102624:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10262b:	83 c8 10             	or     $0x10,%eax
  10262e:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102633:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10263a:	83 e0 9f             	and    $0xffffff9f,%eax
  10263d:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102642:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102649:	83 c8 80             	or     $0xffffff80,%eax
  10264c:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102651:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102658:	83 e0 f0             	and    $0xfffffff0,%eax
  10265b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102660:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102667:	83 e0 ef             	and    $0xffffffef,%eax
  10266a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10266f:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102676:	83 e0 df             	and    $0xffffffdf,%eax
  102679:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10267e:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102685:	83 c8 40             	or     $0x40,%eax
  102688:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10268d:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102694:	83 e0 7f             	and    $0x7f,%eax
  102697:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10269c:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1026a1:	c1 e8 18             	shr    $0x18,%eax
  1026a4:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  1026a9:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026b0:	83 e0 ef             	and    $0xffffffef,%eax
  1026b3:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  1026b8:	68 10 ea 10 00       	push   $0x10ea10
  1026bd:	e8 db fe ff ff       	call   10259d <lgdt>
  1026c2:	83 c4 04             	add    $0x4,%esp
  1026c5:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  1026cb:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1026cf:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1026d2:	90                   	nop
  1026d3:	c9                   	leave  
  1026d4:	c3                   	ret    

001026d5 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1026d5:	55                   	push   %ebp
  1026d6:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1026d8:	e8 f6 fe ff ff       	call   1025d3 <gdt_init>
}
  1026dd:	90                   	nop
  1026de:	5d                   	pop    %ebp
  1026df:	c3                   	ret    

001026e0 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1026e0:	55                   	push   %ebp
  1026e1:	89 e5                	mov    %esp,%ebp
  1026e3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1026e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1026ed:	eb 04                	jmp    1026f3 <strlen+0x13>
        cnt ++;
  1026ef:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1026f6:	8d 50 01             	lea    0x1(%eax),%edx
  1026f9:	89 55 08             	mov    %edx,0x8(%ebp)
  1026fc:	0f b6 00             	movzbl (%eax),%eax
  1026ff:	84 c0                	test   %al,%al
  102701:	75 ec                	jne    1026ef <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102703:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102706:	c9                   	leave  
  102707:	c3                   	ret    

00102708 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102708:	55                   	push   %ebp
  102709:	89 e5                	mov    %esp,%ebp
  10270b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10270e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102715:	eb 04                	jmp    10271b <strnlen+0x13>
        cnt ++;
  102717:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  10271b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10271e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102721:	73 10                	jae    102733 <strnlen+0x2b>
  102723:	8b 45 08             	mov    0x8(%ebp),%eax
  102726:	8d 50 01             	lea    0x1(%eax),%edx
  102729:	89 55 08             	mov    %edx,0x8(%ebp)
  10272c:	0f b6 00             	movzbl (%eax),%eax
  10272f:	84 c0                	test   %al,%al
  102731:	75 e4                	jne    102717 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102733:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102736:	c9                   	leave  
  102737:	c3                   	ret    

00102738 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102738:	55                   	push   %ebp
  102739:	89 e5                	mov    %esp,%ebp
  10273b:	57                   	push   %edi
  10273c:	56                   	push   %esi
  10273d:	83 ec 20             	sub    $0x20,%esp
  102740:	8b 45 08             	mov    0x8(%ebp),%eax
  102743:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102746:	8b 45 0c             	mov    0xc(%ebp),%eax
  102749:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10274c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102752:	89 d1                	mov    %edx,%ecx
  102754:	89 c2                	mov    %eax,%edx
  102756:	89 ce                	mov    %ecx,%esi
  102758:	89 d7                	mov    %edx,%edi
  10275a:	ac                   	lods   %ds:(%esi),%al
  10275b:	aa                   	stos   %al,%es:(%edi)
  10275c:	84 c0                	test   %al,%al
  10275e:	75 fa                	jne    10275a <strcpy+0x22>
  102760:	89 fa                	mov    %edi,%edx
  102762:	89 f1                	mov    %esi,%ecx
  102764:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102767:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10276a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102770:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102771:	83 c4 20             	add    $0x20,%esp
  102774:	5e                   	pop    %esi
  102775:	5f                   	pop    %edi
  102776:	5d                   	pop    %ebp
  102777:	c3                   	ret    

00102778 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102778:	55                   	push   %ebp
  102779:	89 e5                	mov    %esp,%ebp
  10277b:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10277e:	8b 45 08             	mov    0x8(%ebp),%eax
  102781:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102784:	eb 21                	jmp    1027a7 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102786:	8b 45 0c             	mov    0xc(%ebp),%eax
  102789:	0f b6 10             	movzbl (%eax),%edx
  10278c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10278f:	88 10                	mov    %dl,(%eax)
  102791:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102794:	0f b6 00             	movzbl (%eax),%eax
  102797:	84 c0                	test   %al,%al
  102799:	74 04                	je     10279f <strncpy+0x27>
            src ++;
  10279b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  10279f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1027a3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1027a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1027ab:	75 d9                	jne    102786 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1027ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1027b0:	c9                   	leave  
  1027b1:	c3                   	ret    

001027b2 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1027b2:	55                   	push   %ebp
  1027b3:	89 e5                	mov    %esp,%ebp
  1027b5:	57                   	push   %edi
  1027b6:	56                   	push   %esi
  1027b7:	83 ec 20             	sub    $0x20,%esp
  1027ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1027bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1027c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1027c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1027c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1027c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1027cc:	89 d1                	mov    %edx,%ecx
  1027ce:	89 c2                	mov    %eax,%edx
  1027d0:	89 ce                	mov    %ecx,%esi
  1027d2:	89 d7                	mov    %edx,%edi
  1027d4:	ac                   	lods   %ds:(%esi),%al
  1027d5:	ae                   	scas   %es:(%edi),%al
  1027d6:	75 08                	jne    1027e0 <strcmp+0x2e>
  1027d8:	84 c0                	test   %al,%al
  1027da:	75 f8                	jne    1027d4 <strcmp+0x22>
  1027dc:	31 c0                	xor    %eax,%eax
  1027de:	eb 04                	jmp    1027e4 <strcmp+0x32>
  1027e0:	19 c0                	sbb    %eax,%eax
  1027e2:	0c 01                	or     $0x1,%al
  1027e4:	89 fa                	mov    %edi,%edx
  1027e6:	89 f1                	mov    %esi,%ecx
  1027e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1027eb:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1027ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1027f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  1027f4:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1027f5:	83 c4 20             	add    $0x20,%esp
  1027f8:	5e                   	pop    %esi
  1027f9:	5f                   	pop    %edi
  1027fa:	5d                   	pop    %ebp
  1027fb:	c3                   	ret    

001027fc <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1027fc:	55                   	push   %ebp
  1027fd:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1027ff:	eb 0c                	jmp    10280d <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102801:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102805:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102809:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10280d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102811:	74 1a                	je     10282d <strncmp+0x31>
  102813:	8b 45 08             	mov    0x8(%ebp),%eax
  102816:	0f b6 00             	movzbl (%eax),%eax
  102819:	84 c0                	test   %al,%al
  10281b:	74 10                	je     10282d <strncmp+0x31>
  10281d:	8b 45 08             	mov    0x8(%ebp),%eax
  102820:	0f b6 10             	movzbl (%eax),%edx
  102823:	8b 45 0c             	mov    0xc(%ebp),%eax
  102826:	0f b6 00             	movzbl (%eax),%eax
  102829:	38 c2                	cmp    %al,%dl
  10282b:	74 d4                	je     102801 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10282d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102831:	74 18                	je     10284b <strncmp+0x4f>
  102833:	8b 45 08             	mov    0x8(%ebp),%eax
  102836:	0f b6 00             	movzbl (%eax),%eax
  102839:	0f b6 d0             	movzbl %al,%edx
  10283c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10283f:	0f b6 00             	movzbl (%eax),%eax
  102842:	0f b6 c0             	movzbl %al,%eax
  102845:	29 c2                	sub    %eax,%edx
  102847:	89 d0                	mov    %edx,%eax
  102849:	eb 05                	jmp    102850 <strncmp+0x54>
  10284b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102850:	5d                   	pop    %ebp
  102851:	c3                   	ret    

00102852 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102852:	55                   	push   %ebp
  102853:	89 e5                	mov    %esp,%ebp
  102855:	83 ec 04             	sub    $0x4,%esp
  102858:	8b 45 0c             	mov    0xc(%ebp),%eax
  10285b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10285e:	eb 14                	jmp    102874 <strchr+0x22>
        if (*s == c) {
  102860:	8b 45 08             	mov    0x8(%ebp),%eax
  102863:	0f b6 00             	movzbl (%eax),%eax
  102866:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102869:	75 05                	jne    102870 <strchr+0x1e>
            return (char *)s;
  10286b:	8b 45 08             	mov    0x8(%ebp),%eax
  10286e:	eb 13                	jmp    102883 <strchr+0x31>
        }
        s ++;
  102870:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102874:	8b 45 08             	mov    0x8(%ebp),%eax
  102877:	0f b6 00             	movzbl (%eax),%eax
  10287a:	84 c0                	test   %al,%al
  10287c:	75 e2                	jne    102860 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  10287e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102883:	c9                   	leave  
  102884:	c3                   	ret    

00102885 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102885:	55                   	push   %ebp
  102886:	89 e5                	mov    %esp,%ebp
  102888:	83 ec 04             	sub    $0x4,%esp
  10288b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10288e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102891:	eb 0f                	jmp    1028a2 <strfind+0x1d>
        if (*s == c) {
  102893:	8b 45 08             	mov    0x8(%ebp),%eax
  102896:	0f b6 00             	movzbl (%eax),%eax
  102899:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10289c:	74 10                	je     1028ae <strfind+0x29>
            break;
        }
        s ++;
  10289e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1028a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1028a5:	0f b6 00             	movzbl (%eax),%eax
  1028a8:	84 c0                	test   %al,%al
  1028aa:	75 e7                	jne    102893 <strfind+0xe>
  1028ac:	eb 01                	jmp    1028af <strfind+0x2a>
        if (*s == c) {
            break;
  1028ae:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  1028af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1028b2:	c9                   	leave  
  1028b3:	c3                   	ret    

001028b4 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1028b4:	55                   	push   %ebp
  1028b5:	89 e5                	mov    %esp,%ebp
  1028b7:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1028ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1028c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1028c8:	eb 04                	jmp    1028ce <strtol+0x1a>
        s ++;
  1028ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1028d1:	0f b6 00             	movzbl (%eax),%eax
  1028d4:	3c 20                	cmp    $0x20,%al
  1028d6:	74 f2                	je     1028ca <strtol+0x16>
  1028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1028db:	0f b6 00             	movzbl (%eax),%eax
  1028de:	3c 09                	cmp    $0x9,%al
  1028e0:	74 e8                	je     1028ca <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1028e5:	0f b6 00             	movzbl (%eax),%eax
  1028e8:	3c 2b                	cmp    $0x2b,%al
  1028ea:	75 06                	jne    1028f2 <strtol+0x3e>
        s ++;
  1028ec:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1028f0:	eb 15                	jmp    102907 <strtol+0x53>
    }
    else if (*s == '-') {
  1028f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1028f5:	0f b6 00             	movzbl (%eax),%eax
  1028f8:	3c 2d                	cmp    $0x2d,%al
  1028fa:	75 0b                	jne    102907 <strtol+0x53>
        s ++, neg = 1;
  1028fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102900:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102907:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10290b:	74 06                	je     102913 <strtol+0x5f>
  10290d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102911:	75 24                	jne    102937 <strtol+0x83>
  102913:	8b 45 08             	mov    0x8(%ebp),%eax
  102916:	0f b6 00             	movzbl (%eax),%eax
  102919:	3c 30                	cmp    $0x30,%al
  10291b:	75 1a                	jne    102937 <strtol+0x83>
  10291d:	8b 45 08             	mov    0x8(%ebp),%eax
  102920:	83 c0 01             	add    $0x1,%eax
  102923:	0f b6 00             	movzbl (%eax),%eax
  102926:	3c 78                	cmp    $0x78,%al
  102928:	75 0d                	jne    102937 <strtol+0x83>
        s += 2, base = 16;
  10292a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10292e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102935:	eb 2a                	jmp    102961 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102937:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10293b:	75 17                	jne    102954 <strtol+0xa0>
  10293d:	8b 45 08             	mov    0x8(%ebp),%eax
  102940:	0f b6 00             	movzbl (%eax),%eax
  102943:	3c 30                	cmp    $0x30,%al
  102945:	75 0d                	jne    102954 <strtol+0xa0>
        s ++, base = 8;
  102947:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10294b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102952:	eb 0d                	jmp    102961 <strtol+0xad>
    }
    else if (base == 0) {
  102954:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102958:	75 07                	jne    102961 <strtol+0xad>
        base = 10;
  10295a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102961:	8b 45 08             	mov    0x8(%ebp),%eax
  102964:	0f b6 00             	movzbl (%eax),%eax
  102967:	3c 2f                	cmp    $0x2f,%al
  102969:	7e 1b                	jle    102986 <strtol+0xd2>
  10296b:	8b 45 08             	mov    0x8(%ebp),%eax
  10296e:	0f b6 00             	movzbl (%eax),%eax
  102971:	3c 39                	cmp    $0x39,%al
  102973:	7f 11                	jg     102986 <strtol+0xd2>
            dig = *s - '0';
  102975:	8b 45 08             	mov    0x8(%ebp),%eax
  102978:	0f b6 00             	movzbl (%eax),%eax
  10297b:	0f be c0             	movsbl %al,%eax
  10297e:	83 e8 30             	sub    $0x30,%eax
  102981:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102984:	eb 48                	jmp    1029ce <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102986:	8b 45 08             	mov    0x8(%ebp),%eax
  102989:	0f b6 00             	movzbl (%eax),%eax
  10298c:	3c 60                	cmp    $0x60,%al
  10298e:	7e 1b                	jle    1029ab <strtol+0xf7>
  102990:	8b 45 08             	mov    0x8(%ebp),%eax
  102993:	0f b6 00             	movzbl (%eax),%eax
  102996:	3c 7a                	cmp    $0x7a,%al
  102998:	7f 11                	jg     1029ab <strtol+0xf7>
            dig = *s - 'a' + 10;
  10299a:	8b 45 08             	mov    0x8(%ebp),%eax
  10299d:	0f b6 00             	movzbl (%eax),%eax
  1029a0:	0f be c0             	movsbl %al,%eax
  1029a3:	83 e8 57             	sub    $0x57,%eax
  1029a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029a9:	eb 23                	jmp    1029ce <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ae:	0f b6 00             	movzbl (%eax),%eax
  1029b1:	3c 40                	cmp    $0x40,%al
  1029b3:	7e 3c                	jle    1029f1 <strtol+0x13d>
  1029b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b8:	0f b6 00             	movzbl (%eax),%eax
  1029bb:	3c 5a                	cmp    $0x5a,%al
  1029bd:	7f 32                	jg     1029f1 <strtol+0x13d>
            dig = *s - 'A' + 10;
  1029bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1029c2:	0f b6 00             	movzbl (%eax),%eax
  1029c5:	0f be c0             	movsbl %al,%eax
  1029c8:	83 e8 37             	sub    $0x37,%eax
  1029cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029d1:	3b 45 10             	cmp    0x10(%ebp),%eax
  1029d4:	7d 1a                	jge    1029f0 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  1029d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1029da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1029dd:	0f af 45 10          	imul   0x10(%ebp),%eax
  1029e1:	89 c2                	mov    %eax,%edx
  1029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029e6:	01 d0                	add    %edx,%eax
  1029e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1029eb:	e9 71 ff ff ff       	jmp    102961 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  1029f0:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  1029f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1029f5:	74 08                	je     1029ff <strtol+0x14b>
        *endptr = (char *) s;
  1029f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029fa:	8b 55 08             	mov    0x8(%ebp),%edx
  1029fd:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1029ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102a03:	74 07                	je     102a0c <strtol+0x158>
  102a05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102a08:	f7 d8                	neg    %eax
  102a0a:	eb 03                	jmp    102a0f <strtol+0x15b>
  102a0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102a0f:	c9                   	leave  
  102a10:	c3                   	ret    

00102a11 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102a11:	55                   	push   %ebp
  102a12:	89 e5                	mov    %esp,%ebp
  102a14:	57                   	push   %edi
  102a15:	83 ec 24             	sub    $0x24,%esp
  102a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a1b:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102a1e:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102a22:	8b 55 08             	mov    0x8(%ebp),%edx
  102a25:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102a28:	88 45 f7             	mov    %al,-0x9(%ebp)
  102a2b:	8b 45 10             	mov    0x10(%ebp),%eax
  102a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102a31:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102a34:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102a38:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102a3b:	89 d7                	mov    %edx,%edi
  102a3d:	f3 aa                	rep stos %al,%es:(%edi)
  102a3f:	89 fa                	mov    %edi,%edx
  102a41:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102a44:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102a47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102a4a:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102a4b:	83 c4 24             	add    $0x24,%esp
  102a4e:	5f                   	pop    %edi
  102a4f:	5d                   	pop    %ebp
  102a50:	c3                   	ret    

00102a51 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102a51:	55                   	push   %ebp
  102a52:	89 e5                	mov    %esp,%ebp
  102a54:	57                   	push   %edi
  102a55:	56                   	push   %esi
  102a56:	53                   	push   %ebx
  102a57:	83 ec 30             	sub    $0x30,%esp
  102a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102a66:	8b 45 10             	mov    0x10(%ebp),%eax
  102a69:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a6f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102a72:	73 42                	jae    102ab6 <memmove+0x65>
  102a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102a7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102a7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102a80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a83:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102a86:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a89:	c1 e8 02             	shr    $0x2,%eax
  102a8c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102a8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a94:	89 d7                	mov    %edx,%edi
  102a96:	89 c6                	mov    %eax,%esi
  102a98:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102a9a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102a9d:	83 e1 03             	and    $0x3,%ecx
  102aa0:	74 02                	je     102aa4 <memmove+0x53>
  102aa2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102aa4:	89 f0                	mov    %esi,%eax
  102aa6:	89 fa                	mov    %edi,%edx
  102aa8:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102aab:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102aae:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102ab1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102ab4:	eb 36                	jmp    102aec <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102ab6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ab9:	8d 50 ff             	lea    -0x1(%eax),%edx
  102abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102abf:	01 c2                	add    %eax,%edx
  102ac1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ac4:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aca:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  102acd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ad0:	89 c1                	mov    %eax,%ecx
  102ad2:	89 d8                	mov    %ebx,%eax
  102ad4:	89 d6                	mov    %edx,%esi
  102ad6:	89 c7                	mov    %eax,%edi
  102ad8:	fd                   	std    
  102ad9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102adb:	fc                   	cld    
  102adc:	89 f8                	mov    %edi,%eax
  102ade:	89 f2                	mov    %esi,%edx
  102ae0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102ae3:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102ae6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  102ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102aec:	83 c4 30             	add    $0x30,%esp
  102aef:	5b                   	pop    %ebx
  102af0:	5e                   	pop    %esi
  102af1:	5f                   	pop    %edi
  102af2:	5d                   	pop    %ebp
  102af3:	c3                   	ret    

00102af4 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102af4:	55                   	push   %ebp
  102af5:	89 e5                	mov    %esp,%ebp
  102af7:	57                   	push   %edi
  102af8:	56                   	push   %esi
  102af9:	83 ec 20             	sub    $0x20,%esp
  102afc:	8b 45 08             	mov    0x8(%ebp),%eax
  102aff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b08:	8b 45 10             	mov    0x10(%ebp),%eax
  102b0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b11:	c1 e8 02             	shr    $0x2,%eax
  102b14:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b1c:	89 d7                	mov    %edx,%edi
  102b1e:	89 c6                	mov    %eax,%esi
  102b20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102b22:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102b25:	83 e1 03             	and    $0x3,%ecx
  102b28:	74 02                	je     102b2c <memcpy+0x38>
  102b2a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102b2c:	89 f0                	mov    %esi,%eax
  102b2e:	89 fa                	mov    %edi,%edx
  102b30:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102b33:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102b36:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102b3c:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102b3d:	83 c4 20             	add    $0x20,%esp
  102b40:	5e                   	pop    %esi
  102b41:	5f                   	pop    %edi
  102b42:	5d                   	pop    %ebp
  102b43:	c3                   	ret    

00102b44 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102b44:	55                   	push   %ebp
  102b45:	89 e5                	mov    %esp,%ebp
  102b47:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b53:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102b56:	eb 30                	jmp    102b88 <memcmp+0x44>
        if (*s1 != *s2) {
  102b58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b5b:	0f b6 10             	movzbl (%eax),%edx
  102b5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102b61:	0f b6 00             	movzbl (%eax),%eax
  102b64:	38 c2                	cmp    %al,%dl
  102b66:	74 18                	je     102b80 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102b68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b6b:	0f b6 00             	movzbl (%eax),%eax
  102b6e:	0f b6 d0             	movzbl %al,%edx
  102b71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102b74:	0f b6 00             	movzbl (%eax),%eax
  102b77:	0f b6 c0             	movzbl %al,%eax
  102b7a:	29 c2                	sub    %eax,%edx
  102b7c:	89 d0                	mov    %edx,%eax
  102b7e:	eb 1a                	jmp    102b9a <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102b80:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102b84:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  102b88:	8b 45 10             	mov    0x10(%ebp),%eax
  102b8b:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b8e:	89 55 10             	mov    %edx,0x10(%ebp)
  102b91:	85 c0                	test   %eax,%eax
  102b93:	75 c3                	jne    102b58 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  102b95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b9a:	c9                   	leave  
  102b9b:	c3                   	ret    

00102b9c <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102b9c:	55                   	push   %ebp
  102b9d:	89 e5                	mov    %esp,%ebp
  102b9f:	83 ec 38             	sub    $0x38,%esp
  102ba2:	8b 45 10             	mov    0x10(%ebp),%eax
  102ba5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ba8:	8b 45 14             	mov    0x14(%ebp),%eax
  102bab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102bae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102bb1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102bb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102bb7:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102bba:	8b 45 18             	mov    0x18(%ebp),%eax
  102bbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102bc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bc3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102bc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102bc9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102bd6:	74 1c                	je     102bf4 <printnum+0x58>
  102bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  102be0:	f7 75 e4             	divl   -0x1c(%ebp)
  102be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102be9:	ba 00 00 00 00       	mov    $0x0,%edx
  102bee:	f7 75 e4             	divl   -0x1c(%ebp)
  102bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102bfa:	f7 75 e4             	divl   -0x1c(%ebp)
  102bfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c00:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102c03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c06:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102c09:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c0c:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102c0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c12:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102c15:	8b 45 18             	mov    0x18(%ebp),%eax
  102c18:	ba 00 00 00 00       	mov    $0x0,%edx
  102c1d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102c20:	77 41                	ja     102c63 <printnum+0xc7>
  102c22:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102c25:	72 05                	jb     102c2c <printnum+0x90>
  102c27:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102c2a:	77 37                	ja     102c63 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102c2c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102c2f:	83 e8 01             	sub    $0x1,%eax
  102c32:	83 ec 04             	sub    $0x4,%esp
  102c35:	ff 75 20             	pushl  0x20(%ebp)
  102c38:	50                   	push   %eax
  102c39:	ff 75 18             	pushl  0x18(%ebp)
  102c3c:	ff 75 ec             	pushl  -0x14(%ebp)
  102c3f:	ff 75 e8             	pushl  -0x18(%ebp)
  102c42:	ff 75 0c             	pushl  0xc(%ebp)
  102c45:	ff 75 08             	pushl  0x8(%ebp)
  102c48:	e8 4f ff ff ff       	call   102b9c <printnum>
  102c4d:	83 c4 20             	add    $0x20,%esp
  102c50:	eb 1b                	jmp    102c6d <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102c52:	83 ec 08             	sub    $0x8,%esp
  102c55:	ff 75 0c             	pushl  0xc(%ebp)
  102c58:	ff 75 20             	pushl  0x20(%ebp)
  102c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5e:	ff d0                	call   *%eax
  102c60:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102c63:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102c67:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102c6b:	7f e5                	jg     102c52 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102c6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102c70:	05 10 39 10 00       	add    $0x103910,%eax
  102c75:	0f b6 00             	movzbl (%eax),%eax
  102c78:	0f be c0             	movsbl %al,%eax
  102c7b:	83 ec 08             	sub    $0x8,%esp
  102c7e:	ff 75 0c             	pushl  0xc(%ebp)
  102c81:	50                   	push   %eax
  102c82:	8b 45 08             	mov    0x8(%ebp),%eax
  102c85:	ff d0                	call   *%eax
  102c87:	83 c4 10             	add    $0x10,%esp
}
  102c8a:	90                   	nop
  102c8b:	c9                   	leave  
  102c8c:	c3                   	ret    

00102c8d <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102c8d:	55                   	push   %ebp
  102c8e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102c90:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c94:	7e 14                	jle    102caa <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102c96:	8b 45 08             	mov    0x8(%ebp),%eax
  102c99:	8b 00                	mov    (%eax),%eax
  102c9b:	8d 48 08             	lea    0x8(%eax),%ecx
  102c9e:	8b 55 08             	mov    0x8(%ebp),%edx
  102ca1:	89 0a                	mov    %ecx,(%edx)
  102ca3:	8b 50 04             	mov    0x4(%eax),%edx
  102ca6:	8b 00                	mov    (%eax),%eax
  102ca8:	eb 30                	jmp    102cda <getuint+0x4d>
    }
    else if (lflag) {
  102caa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102cae:	74 16                	je     102cc6 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb3:	8b 00                	mov    (%eax),%eax
  102cb5:	8d 48 04             	lea    0x4(%eax),%ecx
  102cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  102cbb:	89 0a                	mov    %ecx,(%edx)
  102cbd:	8b 00                	mov    (%eax),%eax
  102cbf:	ba 00 00 00 00       	mov    $0x0,%edx
  102cc4:	eb 14                	jmp    102cda <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc9:	8b 00                	mov    (%eax),%eax
  102ccb:	8d 48 04             	lea    0x4(%eax),%ecx
  102cce:	8b 55 08             	mov    0x8(%ebp),%edx
  102cd1:	89 0a                	mov    %ecx,(%edx)
  102cd3:	8b 00                	mov    (%eax),%eax
  102cd5:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102cda:	5d                   	pop    %ebp
  102cdb:	c3                   	ret    

00102cdc <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102cdc:	55                   	push   %ebp
  102cdd:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102cdf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102ce3:	7e 14                	jle    102cf9 <getint+0x1d>
        return va_arg(*ap, long long);
  102ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce8:	8b 00                	mov    (%eax),%eax
  102cea:	8d 48 08             	lea    0x8(%eax),%ecx
  102ced:	8b 55 08             	mov    0x8(%ebp),%edx
  102cf0:	89 0a                	mov    %ecx,(%edx)
  102cf2:	8b 50 04             	mov    0x4(%eax),%edx
  102cf5:	8b 00                	mov    (%eax),%eax
  102cf7:	eb 28                	jmp    102d21 <getint+0x45>
    }
    else if (lflag) {
  102cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102cfd:	74 12                	je     102d11 <getint+0x35>
        return va_arg(*ap, long);
  102cff:	8b 45 08             	mov    0x8(%ebp),%eax
  102d02:	8b 00                	mov    (%eax),%eax
  102d04:	8d 48 04             	lea    0x4(%eax),%ecx
  102d07:	8b 55 08             	mov    0x8(%ebp),%edx
  102d0a:	89 0a                	mov    %ecx,(%edx)
  102d0c:	8b 00                	mov    (%eax),%eax
  102d0e:	99                   	cltd   
  102d0f:	eb 10                	jmp    102d21 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102d11:	8b 45 08             	mov    0x8(%ebp),%eax
  102d14:	8b 00                	mov    (%eax),%eax
  102d16:	8d 48 04             	lea    0x4(%eax),%ecx
  102d19:	8b 55 08             	mov    0x8(%ebp),%edx
  102d1c:	89 0a                	mov    %ecx,(%edx)
  102d1e:	8b 00                	mov    (%eax),%eax
  102d20:	99                   	cltd   
    }
}
  102d21:	5d                   	pop    %ebp
  102d22:	c3                   	ret    

00102d23 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102d23:	55                   	push   %ebp
  102d24:	89 e5                	mov    %esp,%ebp
  102d26:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  102d29:	8d 45 14             	lea    0x14(%ebp),%eax
  102d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d32:	50                   	push   %eax
  102d33:	ff 75 10             	pushl  0x10(%ebp)
  102d36:	ff 75 0c             	pushl  0xc(%ebp)
  102d39:	ff 75 08             	pushl  0x8(%ebp)
  102d3c:	e8 06 00 00 00       	call   102d47 <vprintfmt>
  102d41:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  102d44:	90                   	nop
  102d45:	c9                   	leave  
  102d46:	c3                   	ret    

00102d47 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102d47:	55                   	push   %ebp
  102d48:	89 e5                	mov    %esp,%ebp
  102d4a:	56                   	push   %esi
  102d4b:	53                   	push   %ebx
  102d4c:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102d4f:	eb 17                	jmp    102d68 <vprintfmt+0x21>
            if (ch == '\0') {
  102d51:	85 db                	test   %ebx,%ebx
  102d53:	0f 84 8e 03 00 00    	je     1030e7 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  102d59:	83 ec 08             	sub    $0x8,%esp
  102d5c:	ff 75 0c             	pushl  0xc(%ebp)
  102d5f:	53                   	push   %ebx
  102d60:	8b 45 08             	mov    0x8(%ebp),%eax
  102d63:	ff d0                	call   *%eax
  102d65:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102d68:	8b 45 10             	mov    0x10(%ebp),%eax
  102d6b:	8d 50 01             	lea    0x1(%eax),%edx
  102d6e:	89 55 10             	mov    %edx,0x10(%ebp)
  102d71:	0f b6 00             	movzbl (%eax),%eax
  102d74:	0f b6 d8             	movzbl %al,%ebx
  102d77:	83 fb 25             	cmp    $0x25,%ebx
  102d7a:	75 d5                	jne    102d51 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102d7c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102d80:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102d8d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d94:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d97:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102d9a:	8b 45 10             	mov    0x10(%ebp),%eax
  102d9d:	8d 50 01             	lea    0x1(%eax),%edx
  102da0:	89 55 10             	mov    %edx,0x10(%ebp)
  102da3:	0f b6 00             	movzbl (%eax),%eax
  102da6:	0f b6 d8             	movzbl %al,%ebx
  102da9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102dac:	83 f8 55             	cmp    $0x55,%eax
  102daf:	0f 87 05 03 00 00    	ja     1030ba <vprintfmt+0x373>
  102db5:	8b 04 85 34 39 10 00 	mov    0x103934(,%eax,4),%eax
  102dbc:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102dbe:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102dc2:	eb d6                	jmp    102d9a <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102dc4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102dc8:	eb d0                	jmp    102d9a <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102dca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102dd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102dd4:	89 d0                	mov    %edx,%eax
  102dd6:	c1 e0 02             	shl    $0x2,%eax
  102dd9:	01 d0                	add    %edx,%eax
  102ddb:	01 c0                	add    %eax,%eax
  102ddd:	01 d8                	add    %ebx,%eax
  102ddf:	83 e8 30             	sub    $0x30,%eax
  102de2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102de5:	8b 45 10             	mov    0x10(%ebp),%eax
  102de8:	0f b6 00             	movzbl (%eax),%eax
  102deb:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102dee:	83 fb 2f             	cmp    $0x2f,%ebx
  102df1:	7e 39                	jle    102e2c <vprintfmt+0xe5>
  102df3:	83 fb 39             	cmp    $0x39,%ebx
  102df6:	7f 34                	jg     102e2c <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102df8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102dfc:	eb d3                	jmp    102dd1 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102dfe:	8b 45 14             	mov    0x14(%ebp),%eax
  102e01:	8d 50 04             	lea    0x4(%eax),%edx
  102e04:	89 55 14             	mov    %edx,0x14(%ebp)
  102e07:	8b 00                	mov    (%eax),%eax
  102e09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102e0c:	eb 1f                	jmp    102e2d <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  102e0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e12:	79 86                	jns    102d9a <vprintfmt+0x53>
                width = 0;
  102e14:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102e1b:	e9 7a ff ff ff       	jmp    102d9a <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102e20:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102e27:	e9 6e ff ff ff       	jmp    102d9a <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  102e2c:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  102e2d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e31:	0f 89 63 ff ff ff    	jns    102d9a <vprintfmt+0x53>
                width = precision, precision = -1;
  102e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e3d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102e44:	e9 51 ff ff ff       	jmp    102d9a <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102e49:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102e4d:	e9 48 ff ff ff       	jmp    102d9a <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102e52:	8b 45 14             	mov    0x14(%ebp),%eax
  102e55:	8d 50 04             	lea    0x4(%eax),%edx
  102e58:	89 55 14             	mov    %edx,0x14(%ebp)
  102e5b:	8b 00                	mov    (%eax),%eax
  102e5d:	83 ec 08             	sub    $0x8,%esp
  102e60:	ff 75 0c             	pushl  0xc(%ebp)
  102e63:	50                   	push   %eax
  102e64:	8b 45 08             	mov    0x8(%ebp),%eax
  102e67:	ff d0                	call   *%eax
  102e69:	83 c4 10             	add    $0x10,%esp
            break;
  102e6c:	e9 71 02 00 00       	jmp    1030e2 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102e71:	8b 45 14             	mov    0x14(%ebp),%eax
  102e74:	8d 50 04             	lea    0x4(%eax),%edx
  102e77:	89 55 14             	mov    %edx,0x14(%ebp)
  102e7a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102e7c:	85 db                	test   %ebx,%ebx
  102e7e:	79 02                	jns    102e82 <vprintfmt+0x13b>
                err = -err;
  102e80:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102e82:	83 fb 06             	cmp    $0x6,%ebx
  102e85:	7f 0b                	jg     102e92 <vprintfmt+0x14b>
  102e87:	8b 34 9d f4 38 10 00 	mov    0x1038f4(,%ebx,4),%esi
  102e8e:	85 f6                	test   %esi,%esi
  102e90:	75 19                	jne    102eab <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  102e92:	53                   	push   %ebx
  102e93:	68 21 39 10 00       	push   $0x103921
  102e98:	ff 75 0c             	pushl  0xc(%ebp)
  102e9b:	ff 75 08             	pushl  0x8(%ebp)
  102e9e:	e8 80 fe ff ff       	call   102d23 <printfmt>
  102ea3:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102ea6:	e9 37 02 00 00       	jmp    1030e2 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102eab:	56                   	push   %esi
  102eac:	68 2a 39 10 00       	push   $0x10392a
  102eb1:	ff 75 0c             	pushl  0xc(%ebp)
  102eb4:	ff 75 08             	pushl  0x8(%ebp)
  102eb7:	e8 67 fe ff ff       	call   102d23 <printfmt>
  102ebc:	83 c4 10             	add    $0x10,%esp
            }
            break;
  102ebf:	e9 1e 02 00 00       	jmp    1030e2 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102ec4:	8b 45 14             	mov    0x14(%ebp),%eax
  102ec7:	8d 50 04             	lea    0x4(%eax),%edx
  102eca:	89 55 14             	mov    %edx,0x14(%ebp)
  102ecd:	8b 30                	mov    (%eax),%esi
  102ecf:	85 f6                	test   %esi,%esi
  102ed1:	75 05                	jne    102ed8 <vprintfmt+0x191>
                p = "(null)";
  102ed3:	be 2d 39 10 00       	mov    $0x10392d,%esi
            }
            if (width > 0 && padc != '-') {
  102ed8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102edc:	7e 76                	jle    102f54 <vprintfmt+0x20d>
  102ede:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102ee2:	74 70                	je     102f54 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102ee4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ee7:	83 ec 08             	sub    $0x8,%esp
  102eea:	50                   	push   %eax
  102eeb:	56                   	push   %esi
  102eec:	e8 17 f8 ff ff       	call   102708 <strnlen>
  102ef1:	83 c4 10             	add    $0x10,%esp
  102ef4:	89 c2                	mov    %eax,%edx
  102ef6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ef9:	29 d0                	sub    %edx,%eax
  102efb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102efe:	eb 17                	jmp    102f17 <vprintfmt+0x1d0>
                    putch(padc, putdat);
  102f00:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102f04:	83 ec 08             	sub    $0x8,%esp
  102f07:	ff 75 0c             	pushl  0xc(%ebp)
  102f0a:	50                   	push   %eax
  102f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f0e:	ff d0                	call   *%eax
  102f10:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102f13:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102f17:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f1b:	7f e3                	jg     102f00 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102f1d:	eb 35                	jmp    102f54 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  102f1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102f23:	74 1c                	je     102f41 <vprintfmt+0x1fa>
  102f25:	83 fb 1f             	cmp    $0x1f,%ebx
  102f28:	7e 05                	jle    102f2f <vprintfmt+0x1e8>
  102f2a:	83 fb 7e             	cmp    $0x7e,%ebx
  102f2d:	7e 12                	jle    102f41 <vprintfmt+0x1fa>
                    putch('?', putdat);
  102f2f:	83 ec 08             	sub    $0x8,%esp
  102f32:	ff 75 0c             	pushl  0xc(%ebp)
  102f35:	6a 3f                	push   $0x3f
  102f37:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3a:	ff d0                	call   *%eax
  102f3c:	83 c4 10             	add    $0x10,%esp
  102f3f:	eb 0f                	jmp    102f50 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  102f41:	83 ec 08             	sub    $0x8,%esp
  102f44:	ff 75 0c             	pushl  0xc(%ebp)
  102f47:	53                   	push   %ebx
  102f48:	8b 45 08             	mov    0x8(%ebp),%eax
  102f4b:	ff d0                	call   *%eax
  102f4d:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102f50:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102f54:	89 f0                	mov    %esi,%eax
  102f56:	8d 70 01             	lea    0x1(%eax),%esi
  102f59:	0f b6 00             	movzbl (%eax),%eax
  102f5c:	0f be d8             	movsbl %al,%ebx
  102f5f:	85 db                	test   %ebx,%ebx
  102f61:	74 26                	je     102f89 <vprintfmt+0x242>
  102f63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f67:	78 b6                	js     102f1f <vprintfmt+0x1d8>
  102f69:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102f6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f71:	79 ac                	jns    102f1f <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102f73:	eb 14                	jmp    102f89 <vprintfmt+0x242>
                putch(' ', putdat);
  102f75:	83 ec 08             	sub    $0x8,%esp
  102f78:	ff 75 0c             	pushl  0xc(%ebp)
  102f7b:	6a 20                	push   $0x20
  102f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f80:	ff d0                	call   *%eax
  102f82:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102f85:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102f89:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f8d:	7f e6                	jg     102f75 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  102f8f:	e9 4e 01 00 00       	jmp    1030e2 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102f94:	83 ec 08             	sub    $0x8,%esp
  102f97:	ff 75 e0             	pushl  -0x20(%ebp)
  102f9a:	8d 45 14             	lea    0x14(%ebp),%eax
  102f9d:	50                   	push   %eax
  102f9e:	e8 39 fd ff ff       	call   102cdc <getint>
  102fa3:	83 c4 10             	add    $0x10,%esp
  102fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fa9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102faf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fb2:	85 d2                	test   %edx,%edx
  102fb4:	79 23                	jns    102fd9 <vprintfmt+0x292>
                putch('-', putdat);
  102fb6:	83 ec 08             	sub    $0x8,%esp
  102fb9:	ff 75 0c             	pushl  0xc(%ebp)
  102fbc:	6a 2d                	push   $0x2d
  102fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc1:	ff d0                	call   *%eax
  102fc3:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  102fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fcc:	f7 d8                	neg    %eax
  102fce:	83 d2 00             	adc    $0x0,%edx
  102fd1:	f7 da                	neg    %edx
  102fd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fd6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102fd9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102fe0:	e9 9f 00 00 00       	jmp    103084 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102fe5:	83 ec 08             	sub    $0x8,%esp
  102fe8:	ff 75 e0             	pushl  -0x20(%ebp)
  102feb:	8d 45 14             	lea    0x14(%ebp),%eax
  102fee:	50                   	push   %eax
  102fef:	e8 99 fc ff ff       	call   102c8d <getuint>
  102ff4:	83 c4 10             	add    $0x10,%esp
  102ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ffa:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102ffd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103004:	eb 7e                	jmp    103084 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103006:	83 ec 08             	sub    $0x8,%esp
  103009:	ff 75 e0             	pushl  -0x20(%ebp)
  10300c:	8d 45 14             	lea    0x14(%ebp),%eax
  10300f:	50                   	push   %eax
  103010:	e8 78 fc ff ff       	call   102c8d <getuint>
  103015:	83 c4 10             	add    $0x10,%esp
  103018:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10301b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10301e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103025:	eb 5d                	jmp    103084 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  103027:	83 ec 08             	sub    $0x8,%esp
  10302a:	ff 75 0c             	pushl  0xc(%ebp)
  10302d:	6a 30                	push   $0x30
  10302f:	8b 45 08             	mov    0x8(%ebp),%eax
  103032:	ff d0                	call   *%eax
  103034:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  103037:	83 ec 08             	sub    $0x8,%esp
  10303a:	ff 75 0c             	pushl  0xc(%ebp)
  10303d:	6a 78                	push   $0x78
  10303f:	8b 45 08             	mov    0x8(%ebp),%eax
  103042:	ff d0                	call   *%eax
  103044:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  103047:	8b 45 14             	mov    0x14(%ebp),%eax
  10304a:	8d 50 04             	lea    0x4(%eax),%edx
  10304d:	89 55 14             	mov    %edx,0x14(%ebp)
  103050:	8b 00                	mov    (%eax),%eax
  103052:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10305c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103063:	eb 1f                	jmp    103084 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103065:	83 ec 08             	sub    $0x8,%esp
  103068:	ff 75 e0             	pushl  -0x20(%ebp)
  10306b:	8d 45 14             	lea    0x14(%ebp),%eax
  10306e:	50                   	push   %eax
  10306f:	e8 19 fc ff ff       	call   102c8d <getuint>
  103074:	83 c4 10             	add    $0x10,%esp
  103077:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10307a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10307d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103084:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10308b:	83 ec 04             	sub    $0x4,%esp
  10308e:	52                   	push   %edx
  10308f:	ff 75 e8             	pushl  -0x18(%ebp)
  103092:	50                   	push   %eax
  103093:	ff 75 f4             	pushl  -0xc(%ebp)
  103096:	ff 75 f0             	pushl  -0x10(%ebp)
  103099:	ff 75 0c             	pushl  0xc(%ebp)
  10309c:	ff 75 08             	pushl  0x8(%ebp)
  10309f:	e8 f8 fa ff ff       	call   102b9c <printnum>
  1030a4:	83 c4 20             	add    $0x20,%esp
            break;
  1030a7:	eb 39                	jmp    1030e2 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1030a9:	83 ec 08             	sub    $0x8,%esp
  1030ac:	ff 75 0c             	pushl  0xc(%ebp)
  1030af:	53                   	push   %ebx
  1030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b3:	ff d0                	call   *%eax
  1030b5:	83 c4 10             	add    $0x10,%esp
            break;
  1030b8:	eb 28                	jmp    1030e2 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1030ba:	83 ec 08             	sub    $0x8,%esp
  1030bd:	ff 75 0c             	pushl  0xc(%ebp)
  1030c0:	6a 25                	push   $0x25
  1030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c5:	ff d0                	call   *%eax
  1030c7:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  1030ca:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1030ce:	eb 04                	jmp    1030d4 <vprintfmt+0x38d>
  1030d0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1030d4:	8b 45 10             	mov    0x10(%ebp),%eax
  1030d7:	83 e8 01             	sub    $0x1,%eax
  1030da:	0f b6 00             	movzbl (%eax),%eax
  1030dd:	3c 25                	cmp    $0x25,%al
  1030df:	75 ef                	jne    1030d0 <vprintfmt+0x389>
                /* do nothing */;
            break;
  1030e1:	90                   	nop
        }
    }
  1030e2:	e9 68 fc ff ff       	jmp    102d4f <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  1030e7:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1030e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1030eb:	5b                   	pop    %ebx
  1030ec:	5e                   	pop    %esi
  1030ed:	5d                   	pop    %ebp
  1030ee:	c3                   	ret    

001030ef <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1030ef:	55                   	push   %ebp
  1030f0:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1030f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030f5:	8b 40 08             	mov    0x8(%eax),%eax
  1030f8:	8d 50 01             	lea    0x1(%eax),%edx
  1030fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030fe:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103101:	8b 45 0c             	mov    0xc(%ebp),%eax
  103104:	8b 10                	mov    (%eax),%edx
  103106:	8b 45 0c             	mov    0xc(%ebp),%eax
  103109:	8b 40 04             	mov    0x4(%eax),%eax
  10310c:	39 c2                	cmp    %eax,%edx
  10310e:	73 12                	jae    103122 <sprintputch+0x33>
        *b->buf ++ = ch;
  103110:	8b 45 0c             	mov    0xc(%ebp),%eax
  103113:	8b 00                	mov    (%eax),%eax
  103115:	8d 48 01             	lea    0x1(%eax),%ecx
  103118:	8b 55 0c             	mov    0xc(%ebp),%edx
  10311b:	89 0a                	mov    %ecx,(%edx)
  10311d:	8b 55 08             	mov    0x8(%ebp),%edx
  103120:	88 10                	mov    %dl,(%eax)
    }
}
  103122:	90                   	nop
  103123:	5d                   	pop    %ebp
  103124:	c3                   	ret    

00103125 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103125:	55                   	push   %ebp
  103126:	89 e5                	mov    %esp,%ebp
  103128:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10312b:	8d 45 14             	lea    0x14(%ebp),%eax
  10312e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103134:	50                   	push   %eax
  103135:	ff 75 10             	pushl  0x10(%ebp)
  103138:	ff 75 0c             	pushl  0xc(%ebp)
  10313b:	ff 75 08             	pushl  0x8(%ebp)
  10313e:	e8 0b 00 00 00       	call   10314e <vsnprintf>
  103143:	83 c4 10             	add    $0x10,%esp
  103146:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103149:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10314c:	c9                   	leave  
  10314d:	c3                   	ret    

0010314e <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10314e:	55                   	push   %ebp
  10314f:	89 e5                	mov    %esp,%ebp
  103151:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103154:	8b 45 08             	mov    0x8(%ebp),%eax
  103157:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10315a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10315d:	8d 50 ff             	lea    -0x1(%eax),%edx
  103160:	8b 45 08             	mov    0x8(%ebp),%eax
  103163:	01 d0                	add    %edx,%eax
  103165:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103168:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10316f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103173:	74 0a                	je     10317f <vsnprintf+0x31>
  103175:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10317b:	39 c2                	cmp    %eax,%edx
  10317d:	76 07                	jbe    103186 <vsnprintf+0x38>
        return -E_INVAL;
  10317f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103184:	eb 20                	jmp    1031a6 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103186:	ff 75 14             	pushl  0x14(%ebp)
  103189:	ff 75 10             	pushl  0x10(%ebp)
  10318c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10318f:	50                   	push   %eax
  103190:	68 ef 30 10 00       	push   $0x1030ef
  103195:	e8 ad fb ff ff       	call   102d47 <vprintfmt>
  10319a:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  10319d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031a0:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1031a6:	c9                   	leave  
  1031a7:	c3                   	ret    
