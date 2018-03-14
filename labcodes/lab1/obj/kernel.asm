
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
  10001f:	e8 e0 2d 00 00       	call   102e04 <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 40 15 00 00       	call   10156c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 a0 35 10 00 	movl   $0x1035a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 bc 35 10 00       	push   $0x1035bc
  10003e:	e8 16 02 00 00       	call   100259 <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 98 08 00 00       	call   1008e3 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 79 00 00 00       	call   1000c9 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 73 2a 00 00       	call   102ac8 <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 55 16 00 00       	call   1016af <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 d7 17 00 00       	call   101836 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 ed 0c 00 00       	call   100d51 <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 83 17 00 00       	call   1017ec <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100069:	e8 5c 01 00 00       	call   1001ca <lab1_switch_test>

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
  10007f:	e8 bb 0c 00 00       	call   100d3f <mon_backtrace>
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
  100112:	68 c1 35 10 00       	push   $0x1035c1
  100117:	e8 3d 01 00 00       	call   100259 <cprintf>
  10011c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100123:	0f b7 d0             	movzwl %ax,%edx
  100126:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10012b:	83 ec 04             	sub    $0x4,%esp
  10012e:	52                   	push   %edx
  10012f:	50                   	push   %eax
  100130:	68 cf 35 10 00       	push   $0x1035cf
  100135:	e8 1f 01 00 00       	call   100259 <cprintf>
  10013a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  10013d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100141:	0f b7 d0             	movzwl %ax,%edx
  100144:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100149:	83 ec 04             	sub    $0x4,%esp
  10014c:	52                   	push   %edx
  10014d:	50                   	push   %eax
  10014e:	68 dd 35 10 00       	push   $0x1035dd
  100153:	e8 01 01 00 00       	call   100259 <cprintf>
  100158:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  10015b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015f:	0f b7 d0             	movzwl %ax,%edx
  100162:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100167:	83 ec 04             	sub    $0x4,%esp
  10016a:	52                   	push   %edx
  10016b:	50                   	push   %eax
  10016c:	68 eb 35 10 00       	push   $0x1035eb
  100171:	e8 e3 00 00 00       	call   100259 <cprintf>
  100176:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100179:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10017d:	0f b7 d0             	movzwl %ax,%edx
  100180:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100185:	83 ec 04             	sub    $0x4,%esp
  100188:	52                   	push   %edx
  100189:	50                   	push   %eax
  10018a:	68 f9 35 10 00       	push   $0x1035f9
  10018f:	e8 c5 00 00 00       	call   100259 <cprintf>
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
	    "int %0 \n"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001ac:	90                   	nop
  1001ad:	5d                   	pop    %ebp
  1001ae:	c3                   	ret    

001001af <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001af:	55                   	push   %ebp
  1001b0:	89 e5                	mov    %esp,%ebp
  1001b2:	83 ec 08             	sub    $0x8,%esp
    //LAB1 CHALLENGE 1 :  TODO
    cprintf("in lab1_switch_to_kernel\n");
  1001b5:	83 ec 0c             	sub    $0xc,%esp
  1001b8:	68 07 36 10 00       	push   $0x103607
  1001bd:	e8 97 00 00 00       	call   100259 <cprintf>
  1001c2:	83 c4 10             	add    $0x10,%esp
    asm volatile (
  1001c5:	cd 79                	int    $0x79
	    "int %0 \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001c7:	90                   	nop
  1001c8:	c9                   	leave  
  1001c9:	c3                   	ret    

001001ca <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001ca:	55                   	push   %ebp
  1001cb:	89 e5                	mov    %esp,%ebp
  1001cd:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001d0:	e8 15 ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001d5:	83 ec 0c             	sub    $0xc,%esp
  1001d8:	68 24 36 10 00       	push   $0x103624
  1001dd:	e8 77 00 00 00       	call   100259 <cprintf>
  1001e2:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001e5:	e8 bd ff ff ff       	call   1001a7 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ea:	e8 fb fe ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001ef:	83 ec 0c             	sub    $0xc,%esp
  1001f2:	68 44 36 10 00       	push   $0x103644
  1001f7:	e8 5d 00 00 00       	call   100259 <cprintf>
  1001fc:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001ff:	e8 ab ff ff ff       	call   1001af <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100204:	e8 e1 fe ff ff       	call   1000ea <lab1_print_cur_status>
}
  100209:	90                   	nop
  10020a:	c9                   	leave  
  10020b:	c3                   	ret    

0010020c <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10020c:	55                   	push   %ebp
  10020d:	89 e5                	mov    %esp,%ebp
  10020f:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100212:	83 ec 0c             	sub    $0xc,%esp
  100215:	ff 75 08             	pushl  0x8(%ebp)
  100218:	e8 80 13 00 00       	call   10159d <cons_putc>
  10021d:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100220:	8b 45 0c             	mov    0xc(%ebp),%eax
  100223:	8b 00                	mov    (%eax),%eax
  100225:	8d 50 01             	lea    0x1(%eax),%edx
  100228:	8b 45 0c             	mov    0xc(%ebp),%eax
  10022b:	89 10                	mov    %edx,(%eax)
}
  10022d:	90                   	nop
  10022e:	c9                   	leave  
  10022f:	c3                   	ret    

00100230 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100230:	55                   	push   %ebp
  100231:	89 e5                	mov    %esp,%ebp
  100233:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100236:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10023d:	ff 75 0c             	pushl  0xc(%ebp)
  100240:	ff 75 08             	pushl  0x8(%ebp)
  100243:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100246:	50                   	push   %eax
  100247:	68 0c 02 10 00       	push   $0x10020c
  10024c:	e8 e9 2e 00 00       	call   10313a <vprintfmt>
  100251:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100254:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100257:	c9                   	leave  
  100258:	c3                   	ret    

00100259 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100259:	55                   	push   %ebp
  10025a:	89 e5                	mov    %esp,%ebp
  10025c:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10025f:	8d 45 0c             	lea    0xc(%ebp),%eax
  100262:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100265:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100268:	83 ec 08             	sub    $0x8,%esp
  10026b:	50                   	push   %eax
  10026c:	ff 75 08             	pushl  0x8(%ebp)
  10026f:	e8 bc ff ff ff       	call   100230 <vcprintf>
  100274:	83 c4 10             	add    $0x10,%esp
  100277:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10027a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10027d:	c9                   	leave  
  10027e:	c3                   	ret    

0010027f <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10027f:	55                   	push   %ebp
  100280:	89 e5                	mov    %esp,%ebp
  100282:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100285:	83 ec 0c             	sub    $0xc,%esp
  100288:	ff 75 08             	pushl  0x8(%ebp)
  10028b:	e8 0d 13 00 00       	call   10159d <cons_putc>
  100290:	83 c4 10             	add    $0x10,%esp
}
  100293:	90                   	nop
  100294:	c9                   	leave  
  100295:	c3                   	ret    

00100296 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100296:	55                   	push   %ebp
  100297:	89 e5                	mov    %esp,%ebp
  100299:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10029c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002a3:	eb 14                	jmp    1002b9 <cputs+0x23>
        cputch(c, &cnt);
  1002a5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002a9:	83 ec 08             	sub    $0x8,%esp
  1002ac:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002af:	52                   	push   %edx
  1002b0:	50                   	push   %eax
  1002b1:	e8 56 ff ff ff       	call   10020c <cputch>
  1002b6:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1002bc:	8d 50 01             	lea    0x1(%eax),%edx
  1002bf:	89 55 08             	mov    %edx,0x8(%ebp)
  1002c2:	0f b6 00             	movzbl (%eax),%eax
  1002c5:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002c8:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002cc:	75 d7                	jne    1002a5 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002ce:	83 ec 08             	sub    $0x8,%esp
  1002d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002d4:	50                   	push   %eax
  1002d5:	6a 0a                	push   $0xa
  1002d7:	e8 30 ff ff ff       	call   10020c <cputch>
  1002dc:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002e2:	c9                   	leave  
  1002e3:	c3                   	ret    

001002e4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002e4:	55                   	push   %ebp
  1002e5:	89 e5                	mov    %esp,%ebp
  1002e7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002ea:	e8 de 12 00 00       	call   1015cd <cons_getc>
  1002ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002f6:	74 f2                	je     1002ea <getchar+0x6>
        /* do nothing */;
    return c;
  1002f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002fb:	c9                   	leave  
  1002fc:	c3                   	ret    

001002fd <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002fd:	55                   	push   %ebp
  1002fe:	89 e5                	mov    %esp,%ebp
  100300:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  100303:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100307:	74 13                	je     10031c <readline+0x1f>
        cprintf("%s", prompt);
  100309:	83 ec 08             	sub    $0x8,%esp
  10030c:	ff 75 08             	pushl  0x8(%ebp)
  10030f:	68 63 36 10 00       	push   $0x103663
  100314:	e8 40 ff ff ff       	call   100259 <cprintf>
  100319:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10031c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100323:	e8 bc ff ff ff       	call   1002e4 <getchar>
  100328:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10032b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10032f:	79 0a                	jns    10033b <readline+0x3e>
            return NULL;
  100331:	b8 00 00 00 00       	mov    $0x0,%eax
  100336:	e9 82 00 00 00       	jmp    1003bd <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10033b:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10033f:	7e 2b                	jle    10036c <readline+0x6f>
  100341:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100348:	7f 22                	jg     10036c <readline+0x6f>
            cputchar(c);
  10034a:	83 ec 0c             	sub    $0xc,%esp
  10034d:	ff 75 f0             	pushl  -0x10(%ebp)
  100350:	e8 2a ff ff ff       	call   10027f <cputchar>
  100355:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10035b:	8d 50 01             	lea    0x1(%eax),%edx
  10035e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100361:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100364:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  10036a:	eb 4c                	jmp    1003b8 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  10036c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100370:	75 1a                	jne    10038c <readline+0x8f>
  100372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100376:	7e 14                	jle    10038c <readline+0x8f>
            cputchar(c);
  100378:	83 ec 0c             	sub    $0xc,%esp
  10037b:	ff 75 f0             	pushl  -0x10(%ebp)
  10037e:	e8 fc fe ff ff       	call   10027f <cputchar>
  100383:	83 c4 10             	add    $0x10,%esp
            i --;
  100386:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10038a:	eb 2c                	jmp    1003b8 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  10038c:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100390:	74 06                	je     100398 <readline+0x9b>
  100392:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100396:	75 8b                	jne    100323 <readline+0x26>
            cputchar(c);
  100398:	83 ec 0c             	sub    $0xc,%esp
  10039b:	ff 75 f0             	pushl  -0x10(%ebp)
  10039e:	e8 dc fe ff ff       	call   10027f <cputchar>
  1003a3:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1003a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003b6:	eb 05                	jmp    1003bd <readline+0xc0>
        }
    }
  1003b8:	e9 66 ff ff ff       	jmp    100323 <readline+0x26>
}
  1003bd:	c9                   	leave  
  1003be:	c3                   	ret    

001003bf <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003bf:	55                   	push   %ebp
  1003c0:	89 e5                	mov    %esp,%ebp
  1003c2:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003c5:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003ca:	85 c0                	test   %eax,%eax
  1003cc:	75 4a                	jne    100418 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003ce:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003d5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003d8:	8d 45 14             	lea    0x14(%ebp),%eax
  1003db:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003de:	83 ec 04             	sub    $0x4,%esp
  1003e1:	ff 75 0c             	pushl  0xc(%ebp)
  1003e4:	ff 75 08             	pushl  0x8(%ebp)
  1003e7:	68 66 36 10 00       	push   $0x103666
  1003ec:	e8 68 fe ff ff       	call   100259 <cprintf>
  1003f1:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1003f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003f7:	83 ec 08             	sub    $0x8,%esp
  1003fa:	50                   	push   %eax
  1003fb:	ff 75 10             	pushl  0x10(%ebp)
  1003fe:	e8 2d fe ff ff       	call   100230 <vcprintf>
  100403:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100406:	83 ec 0c             	sub    $0xc,%esp
  100409:	68 82 36 10 00       	push   $0x103682
  10040e:	e8 46 fe ff ff       	call   100259 <cprintf>
  100413:	83 c4 10             	add    $0x10,%esp
  100416:	eb 01                	jmp    100419 <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  100418:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  100419:	e8 d5 13 00 00       	call   1017f3 <intr_disable>
    while (1) {
        kmonitor(NULL);
  10041e:	83 ec 0c             	sub    $0xc,%esp
  100421:	6a 00                	push   $0x0
  100423:	e8 3d 08 00 00       	call   100c65 <kmonitor>
  100428:	83 c4 10             	add    $0x10,%esp
    }
  10042b:	eb f1                	jmp    10041e <__panic+0x5f>

0010042d <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10042d:	55                   	push   %ebp
  10042e:	89 e5                	mov    %esp,%ebp
  100430:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100433:	8d 45 14             	lea    0x14(%ebp),%eax
  100436:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100439:	83 ec 04             	sub    $0x4,%esp
  10043c:	ff 75 0c             	pushl  0xc(%ebp)
  10043f:	ff 75 08             	pushl  0x8(%ebp)
  100442:	68 84 36 10 00       	push   $0x103684
  100447:	e8 0d fe ff ff       	call   100259 <cprintf>
  10044c:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10044f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100452:	83 ec 08             	sub    $0x8,%esp
  100455:	50                   	push   %eax
  100456:	ff 75 10             	pushl  0x10(%ebp)
  100459:	e8 d2 fd ff ff       	call   100230 <vcprintf>
  10045e:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100461:	83 ec 0c             	sub    $0xc,%esp
  100464:	68 82 36 10 00       	push   $0x103682
  100469:	e8 eb fd ff ff       	call   100259 <cprintf>
  10046e:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100471:	90                   	nop
  100472:	c9                   	leave  
  100473:	c3                   	ret    

00100474 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100474:	55                   	push   %ebp
  100475:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100477:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  10047c:	5d                   	pop    %ebp
  10047d:	c3                   	ret    

0010047e <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10047e:	55                   	push   %ebp
  10047f:	89 e5                	mov    %esp,%ebp
  100481:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100484:	8b 45 0c             	mov    0xc(%ebp),%eax
  100487:	8b 00                	mov    (%eax),%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	8b 45 10             	mov    0x10(%ebp),%eax
  10048f:	8b 00                	mov    (%eax),%eax
  100491:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100494:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10049b:	e9 d2 00 00 00       	jmp    100572 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004a6:	01 d0                	add    %edx,%eax
  1004a8:	89 c2                	mov    %eax,%edx
  1004aa:	c1 ea 1f             	shr    $0x1f,%edx
  1004ad:	01 d0                	add    %edx,%eax
  1004af:	d1 f8                	sar    %eax
  1004b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004b7:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ba:	eb 04                	jmp    1004c0 <stab_binsearch+0x42>
            m --;
  1004bc:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004c6:	7c 1f                	jl     1004e7 <stab_binsearch+0x69>
  1004c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004cb:	89 d0                	mov    %edx,%eax
  1004cd:	01 c0                	add    %eax,%eax
  1004cf:	01 d0                	add    %edx,%eax
  1004d1:	c1 e0 02             	shl    $0x2,%eax
  1004d4:	89 c2                	mov    %eax,%edx
  1004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1004d9:	01 d0                	add    %edx,%eax
  1004db:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004df:	0f b6 c0             	movzbl %al,%eax
  1004e2:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004e5:	75 d5                	jne    1004bc <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ed:	7d 0b                	jge    1004fa <stab_binsearch+0x7c>
            l = true_m + 1;
  1004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004f2:	83 c0 01             	add    $0x1,%eax
  1004f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004f8:	eb 78                	jmp    100572 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004fa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100501:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100504:	89 d0                	mov    %edx,%eax
  100506:	01 c0                	add    %eax,%eax
  100508:	01 d0                	add    %edx,%eax
  10050a:	c1 e0 02             	shl    $0x2,%eax
  10050d:	89 c2                	mov    %eax,%edx
  10050f:	8b 45 08             	mov    0x8(%ebp),%eax
  100512:	01 d0                	add    %edx,%eax
  100514:	8b 40 08             	mov    0x8(%eax),%eax
  100517:	3b 45 18             	cmp    0x18(%ebp),%eax
  10051a:	73 13                	jae    10052f <stab_binsearch+0xb1>
            *region_left = m;
  10051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100522:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100524:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100527:	83 c0 01             	add    $0x1,%eax
  10052a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10052d:	eb 43                	jmp    100572 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10052f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100532:	89 d0                	mov    %edx,%eax
  100534:	01 c0                	add    %eax,%eax
  100536:	01 d0                	add    %edx,%eax
  100538:	c1 e0 02             	shl    $0x2,%eax
  10053b:	89 c2                	mov    %eax,%edx
  10053d:	8b 45 08             	mov    0x8(%ebp),%eax
  100540:	01 d0                	add    %edx,%eax
  100542:	8b 40 08             	mov    0x8(%eax),%eax
  100545:	3b 45 18             	cmp    0x18(%ebp),%eax
  100548:	76 16                	jbe    100560 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10054a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054d:	8d 50 ff             	lea    -0x1(%eax),%edx
  100550:	8b 45 10             	mov    0x10(%ebp),%eax
  100553:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100558:	83 e8 01             	sub    $0x1,%eax
  10055b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10055e:	eb 12                	jmp    100572 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100566:	89 10                	mov    %edx,(%eax)
            l = m;
  100568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10056b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10056e:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100572:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100575:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100578:	0f 8e 22 ff ff ff    	jle    1004a0 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  10057e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100582:	75 0f                	jne    100593 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100584:	8b 45 0c             	mov    0xc(%ebp),%eax
  100587:	8b 00                	mov    (%eax),%eax
  100589:	8d 50 ff             	lea    -0x1(%eax),%edx
  10058c:	8b 45 10             	mov    0x10(%ebp),%eax
  10058f:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100591:	eb 3f                	jmp    1005d2 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100593:	8b 45 10             	mov    0x10(%ebp),%eax
  100596:	8b 00                	mov    (%eax),%eax
  100598:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10059b:	eb 04                	jmp    1005a1 <stab_binsearch+0x123>
  10059d:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a4:	8b 00                	mov    (%eax),%eax
  1005a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005a9:	7d 1f                	jge    1005ca <stab_binsearch+0x14c>
  1005ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005ae:	89 d0                	mov    %edx,%eax
  1005b0:	01 c0                	add    %eax,%eax
  1005b2:	01 d0                	add    %edx,%eax
  1005b4:	c1 e0 02             	shl    $0x2,%eax
  1005b7:	89 c2                	mov    %eax,%edx
  1005b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005bc:	01 d0                	add    %edx,%eax
  1005be:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005c2:	0f b6 c0             	movzbl %al,%eax
  1005c5:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005c8:	75 d3                	jne    10059d <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005d0:	89 10                	mov    %edx,(%eax)
    }
}
  1005d2:	90                   	nop
  1005d3:	c9                   	leave  
  1005d4:	c3                   	ret    

001005d5 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005d5:	55                   	push   %ebp
  1005d6:	89 e5                	mov    %esp,%ebp
  1005d8:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005de:	c7 00 a4 36 10 00    	movl   $0x1036a4,(%eax)
    info->eip_line = 0;
  1005e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f1:	c7 40 08 a4 36 10 00 	movl   $0x1036a4,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fb:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100602:	8b 45 0c             	mov    0xc(%ebp),%eax
  100605:	8b 55 08             	mov    0x8(%ebp),%edx
  100608:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10060b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100615:	c7 45 f4 2c 3f 10 00 	movl   $0x103f2c,-0xc(%ebp)
    stab_end = __STAB_END__;
  10061c:	c7 45 f0 5c ba 10 00 	movl   $0x10ba5c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100623:	c7 45 ec 5d ba 10 00 	movl   $0x10ba5d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10062a:	c7 45 e8 fa da 10 00 	movl   $0x10dafa,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100631:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100634:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100637:	76 0d                	jbe    100646 <debuginfo_eip+0x71>
  100639:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10063c:	83 e8 01             	sub    $0x1,%eax
  10063f:	0f b6 00             	movzbl (%eax),%eax
  100642:	84 c0                	test   %al,%al
  100644:	74 0a                	je     100650 <debuginfo_eip+0x7b>
        return -1;
  100646:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10064b:	e9 91 02 00 00       	jmp    1008e1 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100650:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100657:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10065a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10065d:	29 c2                	sub    %eax,%edx
  10065f:	89 d0                	mov    %edx,%eax
  100661:	c1 f8 02             	sar    $0x2,%eax
  100664:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10066a:	83 e8 01             	sub    $0x1,%eax
  10066d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100670:	ff 75 08             	pushl  0x8(%ebp)
  100673:	6a 64                	push   $0x64
  100675:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100678:	50                   	push   %eax
  100679:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10067c:	50                   	push   %eax
  10067d:	ff 75 f4             	pushl  -0xc(%ebp)
  100680:	e8 f9 fd ff ff       	call   10047e <stab_binsearch>
  100685:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  100688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10068b:	85 c0                	test   %eax,%eax
  10068d:	75 0a                	jne    100699 <debuginfo_eip+0xc4>
        return -1;
  10068f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100694:	e9 48 02 00 00       	jmp    1008e1 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10069c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10069f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006a5:	ff 75 08             	pushl  0x8(%ebp)
  1006a8:	6a 24                	push   $0x24
  1006aa:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006ad:	50                   	push   %eax
  1006ae:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006b1:	50                   	push   %eax
  1006b2:	ff 75 f4             	pushl  -0xc(%ebp)
  1006b5:	e8 c4 fd ff ff       	call   10047e <stab_binsearch>
  1006ba:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006c3:	39 c2                	cmp    %eax,%edx
  1006c5:	7f 7c                	jg     100743 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006ca:	89 c2                	mov    %eax,%edx
  1006cc:	89 d0                	mov    %edx,%eax
  1006ce:	01 c0                	add    %eax,%eax
  1006d0:	01 d0                	add    %edx,%eax
  1006d2:	c1 e0 02             	shl    $0x2,%eax
  1006d5:	89 c2                	mov    %eax,%edx
  1006d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006da:	01 d0                	add    %edx,%eax
  1006dc:	8b 00                	mov    (%eax),%eax
  1006de:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006e4:	29 d1                	sub    %edx,%ecx
  1006e6:	89 ca                	mov    %ecx,%edx
  1006e8:	39 d0                	cmp    %edx,%eax
  1006ea:	73 22                	jae    10070e <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006ef:	89 c2                	mov    %eax,%edx
  1006f1:	89 d0                	mov    %edx,%eax
  1006f3:	01 c0                	add    %eax,%eax
  1006f5:	01 d0                	add    %edx,%eax
  1006f7:	c1 e0 02             	shl    $0x2,%eax
  1006fa:	89 c2                	mov    %eax,%edx
  1006fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ff:	01 d0                	add    %edx,%eax
  100701:	8b 10                	mov    (%eax),%edx
  100703:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100706:	01 c2                	add    %eax,%edx
  100708:	8b 45 0c             	mov    0xc(%ebp),%eax
  10070b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10070e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100711:	89 c2                	mov    %eax,%edx
  100713:	89 d0                	mov    %edx,%eax
  100715:	01 c0                	add    %eax,%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	c1 e0 02             	shl    $0x2,%eax
  10071c:	89 c2                	mov    %eax,%edx
  10071e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100721:	01 d0                	add    %edx,%eax
  100723:	8b 50 08             	mov    0x8(%eax),%edx
  100726:	8b 45 0c             	mov    0xc(%ebp),%eax
  100729:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10072c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10072f:	8b 40 10             	mov    0x10(%eax),%eax
  100732:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100735:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10073b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10073e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100741:	eb 15                	jmp    100758 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100743:	8b 45 0c             	mov    0xc(%ebp),%eax
  100746:	8b 55 08             	mov    0x8(%ebp),%edx
  100749:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10074c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10074f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100752:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100755:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100758:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075b:	8b 40 08             	mov    0x8(%eax),%eax
  10075e:	83 ec 08             	sub    $0x8,%esp
  100761:	6a 3a                	push   $0x3a
  100763:	50                   	push   %eax
  100764:	e8 0f 25 00 00       	call   102c78 <strfind>
  100769:	83 c4 10             	add    $0x10,%esp
  10076c:	89 c2                	mov    %eax,%edx
  10076e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100771:	8b 40 08             	mov    0x8(%eax),%eax
  100774:	29 c2                	sub    %eax,%edx
  100776:	8b 45 0c             	mov    0xc(%ebp),%eax
  100779:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10077c:	83 ec 0c             	sub    $0xc,%esp
  10077f:	ff 75 08             	pushl  0x8(%ebp)
  100782:	6a 44                	push   $0x44
  100784:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100787:	50                   	push   %eax
  100788:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10078b:	50                   	push   %eax
  10078c:	ff 75 f4             	pushl  -0xc(%ebp)
  10078f:	e8 ea fc ff ff       	call   10047e <stab_binsearch>
  100794:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  100797:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10079d:	39 c2                	cmp    %eax,%edx
  10079f:	7f 24                	jg     1007c5 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  1007a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007a4:	89 c2                	mov    %eax,%edx
  1007a6:	89 d0                	mov    %edx,%eax
  1007a8:	01 c0                	add    %eax,%eax
  1007aa:	01 d0                	add    %edx,%eax
  1007ac:	c1 e0 02             	shl    $0x2,%eax
  1007af:	89 c2                	mov    %eax,%edx
  1007b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b4:	01 d0                	add    %edx,%eax
  1007b6:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007ba:	0f b7 d0             	movzwl %ax,%edx
  1007bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c0:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007c3:	eb 13                	jmp    1007d8 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ca:	e9 12 01 00 00       	jmp    1008e1 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	83 e8 01             	sub    $0x1,%eax
  1007d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007de:	39 c2                	cmp    %eax,%edx
  1007e0:	7c 56                	jl     100838 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e5:	89 c2                	mov    %eax,%edx
  1007e7:	89 d0                	mov    %edx,%eax
  1007e9:	01 c0                	add    %eax,%eax
  1007eb:	01 d0                	add    %edx,%eax
  1007ed:	c1 e0 02             	shl    $0x2,%eax
  1007f0:	89 c2                	mov    %eax,%edx
  1007f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f5:	01 d0                	add    %edx,%eax
  1007f7:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007fb:	3c 84                	cmp    $0x84,%al
  1007fd:	74 39                	je     100838 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	89 d0                	mov    %edx,%eax
  100806:	01 c0                	add    %eax,%eax
  100808:	01 d0                	add    %edx,%eax
  10080a:	c1 e0 02             	shl    $0x2,%eax
  10080d:	89 c2                	mov    %eax,%edx
  10080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100812:	01 d0                	add    %edx,%eax
  100814:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100818:	3c 64                	cmp    $0x64,%al
  10081a:	75 b3                	jne    1007cf <debuginfo_eip+0x1fa>
  10081c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10081f:	89 c2                	mov    %eax,%edx
  100821:	89 d0                	mov    %edx,%eax
  100823:	01 c0                	add    %eax,%eax
  100825:	01 d0                	add    %edx,%eax
  100827:	c1 e0 02             	shl    $0x2,%eax
  10082a:	89 c2                	mov    %eax,%edx
  10082c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10082f:	01 d0                	add    %edx,%eax
  100831:	8b 40 08             	mov    0x8(%eax),%eax
  100834:	85 c0                	test   %eax,%eax
  100836:	74 97                	je     1007cf <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100838:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10083b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10083e:	39 c2                	cmp    %eax,%edx
  100840:	7c 46                	jl     100888 <debuginfo_eip+0x2b3>
  100842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100845:	89 c2                	mov    %eax,%edx
  100847:	89 d0                	mov    %edx,%eax
  100849:	01 c0                	add    %eax,%eax
  10084b:	01 d0                	add    %edx,%eax
  10084d:	c1 e0 02             	shl    $0x2,%eax
  100850:	89 c2                	mov    %eax,%edx
  100852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	8b 00                	mov    (%eax),%eax
  100859:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10085c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10085f:	29 d1                	sub    %edx,%ecx
  100861:	89 ca                	mov    %ecx,%edx
  100863:	39 d0                	cmp    %edx,%eax
  100865:	73 21                	jae    100888 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100867:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10086a:	89 c2                	mov    %eax,%edx
  10086c:	89 d0                	mov    %edx,%eax
  10086e:	01 c0                	add    %eax,%eax
  100870:	01 d0                	add    %edx,%eax
  100872:	c1 e0 02             	shl    $0x2,%eax
  100875:	89 c2                	mov    %eax,%edx
  100877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10087a:	01 d0                	add    %edx,%eax
  10087c:	8b 10                	mov    (%eax),%edx
  10087e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100881:	01 c2                	add    %eax,%edx
  100883:	8b 45 0c             	mov    0xc(%ebp),%eax
  100886:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100888:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10088b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10088e:	39 c2                	cmp    %eax,%edx
  100890:	7d 4a                	jge    1008dc <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  100892:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100895:	83 c0 01             	add    $0x1,%eax
  100898:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10089b:	eb 18                	jmp    1008b5 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10089d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008a0:	8b 40 14             	mov    0x14(%eax),%eax
  1008a3:	8d 50 01             	lea    0x1(%eax),%edx
  1008a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008a9:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008af:	83 c0 01             	add    $0x1,%eax
  1008b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008bb:	39 c2                	cmp    %eax,%edx
  1008bd:	7d 1d                	jge    1008dc <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c2:	89 c2                	mov    %eax,%edx
  1008c4:	89 d0                	mov    %edx,%eax
  1008c6:	01 c0                	add    %eax,%eax
  1008c8:	01 d0                	add    %edx,%eax
  1008ca:	c1 e0 02             	shl    $0x2,%eax
  1008cd:	89 c2                	mov    %eax,%edx
  1008cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d2:	01 d0                	add    %edx,%eax
  1008d4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008d8:	3c a0                	cmp    $0xa0,%al
  1008da:	74 c1                	je     10089d <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008e1:	c9                   	leave  
  1008e2:	c3                   	ret    

001008e3 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008e3:	55                   	push   %ebp
  1008e4:	89 e5                	mov    %esp,%ebp
  1008e6:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008e9:	83 ec 0c             	sub    $0xc,%esp
  1008ec:	68 ae 36 10 00       	push   $0x1036ae
  1008f1:	e8 63 f9 ff ff       	call   100259 <cprintf>
  1008f6:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008f9:	83 ec 08             	sub    $0x8,%esp
  1008fc:	68 00 00 10 00       	push   $0x100000
  100901:	68 c7 36 10 00       	push   $0x1036c7
  100906:	e8 4e f9 ff ff       	call   100259 <cprintf>
  10090b:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  10090e:	83 ec 08             	sub    $0x8,%esp
  100911:	68 9b 35 10 00       	push   $0x10359b
  100916:	68 df 36 10 00       	push   $0x1036df
  10091b:	e8 39 f9 ff ff       	call   100259 <cprintf>
  100920:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100923:	83 ec 08             	sub    $0x8,%esp
  100926:	68 16 ea 10 00       	push   $0x10ea16
  10092b:	68 f7 36 10 00       	push   $0x1036f7
  100930:	e8 24 f9 ff ff       	call   100259 <cprintf>
  100935:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100938:	83 ec 08             	sub    $0x8,%esp
  10093b:	68 80 fd 10 00       	push   $0x10fd80
  100940:	68 0f 37 10 00       	push   $0x10370f
  100945:	e8 0f f9 ff ff       	call   100259 <cprintf>
  10094a:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10094d:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  100952:	05 ff 03 00 00       	add    $0x3ff,%eax
  100957:	ba 00 00 10 00       	mov    $0x100000,%edx
  10095c:	29 d0                	sub    %edx,%eax
  10095e:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100964:	85 c0                	test   %eax,%eax
  100966:	0f 48 c2             	cmovs  %edx,%eax
  100969:	c1 f8 0a             	sar    $0xa,%eax
  10096c:	83 ec 08             	sub    $0x8,%esp
  10096f:	50                   	push   %eax
  100970:	68 28 37 10 00       	push   $0x103728
  100975:	e8 df f8 ff ff       	call   100259 <cprintf>
  10097a:	83 c4 10             	add    $0x10,%esp
}
  10097d:	90                   	nop
  10097e:	c9                   	leave  
  10097f:	c3                   	ret    

00100980 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100980:	55                   	push   %ebp
  100981:	89 e5                	mov    %esp,%ebp
  100983:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100989:	83 ec 08             	sub    $0x8,%esp
  10098c:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10098f:	50                   	push   %eax
  100990:	ff 75 08             	pushl  0x8(%ebp)
  100993:	e8 3d fc ff ff       	call   1005d5 <debuginfo_eip>
  100998:	83 c4 10             	add    $0x10,%esp
  10099b:	85 c0                	test   %eax,%eax
  10099d:	74 15                	je     1009b4 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10099f:	83 ec 08             	sub    $0x8,%esp
  1009a2:	ff 75 08             	pushl  0x8(%ebp)
  1009a5:	68 52 37 10 00       	push   $0x103752
  1009aa:	e8 aa f8 ff ff       	call   100259 <cprintf>
  1009af:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009b2:	eb 65                	jmp    100a19 <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009bb:	eb 1c                	jmp    1009d9 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009c3:	01 d0                	add    %edx,%eax
  1009c5:	0f b6 00             	movzbl (%eax),%eax
  1009c8:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009d1:	01 ca                	add    %ecx,%edx
  1009d3:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009df:	7f dc                	jg     1009bd <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009e1:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ea:	01 d0                	add    %edx,%eax
  1009ec:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  1009f2:	8b 55 08             	mov    0x8(%ebp),%edx
  1009f5:	89 d1                	mov    %edx,%ecx
  1009f7:	29 c1                	sub    %eax,%ecx
  1009f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1009fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009ff:	83 ec 0c             	sub    $0xc,%esp
  100a02:	51                   	push   %ecx
  100a03:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a09:	51                   	push   %ecx
  100a0a:	52                   	push   %edx
  100a0b:	50                   	push   %eax
  100a0c:	68 6e 37 10 00       	push   $0x10376e
  100a11:	e8 43 f8 ff ff       	call   100259 <cprintf>
  100a16:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  100a19:	90                   	nop
  100a1a:	c9                   	leave  
  100a1b:	c3                   	ret    

00100a1c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a1c:	55                   	push   %ebp
  100a1d:	89 e5                	mov    %esp,%ebp
  100a1f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a22:	8b 45 04             	mov    0x4(%ebp),%eax
  100a25:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a2b:	c9                   	leave  
  100a2c:	c3                   	ret    

00100a2d <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a2d:	55                   	push   %ebp
  100a2e:	89 e5                	mov    %esp,%ebp
  100a30:	53                   	push   %ebx
  100a31:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a34:	89 e8                	mov    %ebp,%eax
  100a36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100a39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    // 1. read_ebp
    uint32_t stack_val_ebp = read_ebp();
  100a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)

    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
  100a3f:	e8 d8 ff ff ff       	call   100a1c <read_eip>
  100a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  100a47:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a4e:	e9 93 00 00 00       	jmp    100ae6 <print_stackframe+0xb9>
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);
  100a53:	83 ec 04             	sub    $0x4,%esp
  100a56:	ff 75 f0             	pushl  -0x10(%ebp)
  100a59:	ff 75 f4             	pushl  -0xc(%ebp)
  100a5c:	68 80 37 10 00       	push   $0x103780
  100a61:	e8 f3 f7 ff ff       	call   100259 <cprintf>
  100a66:	83 c4 10             	add    $0x10,%esp

        // get args
        for (int j = 0; j < 4; j++) {
  100a69:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a70:	eb 1f                	jmp    100a91 <print_stackframe+0x64>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
  100a72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a75:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a7f:	01 d0                	add    %edx,%eax
  100a81:	83 c0 08             	add    $0x8,%eax
  100a84:	8b 10                	mov    (%eax),%edx
  100a86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a89:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);

        // get args
        for (int j = 0; j < 4; j++) {
  100a8d:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a91:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a95:	7e db                	jle    100a72 <print_stackframe+0x45>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
        }

        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", stack_val_args[0], 
  100a97:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  100a9a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  100a9d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100aa0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100aa3:	83 ec 0c             	sub    $0xc,%esp
  100aa6:	53                   	push   %ebx
  100aa7:	51                   	push   %ecx
  100aa8:	52                   	push   %edx
  100aa9:	50                   	push   %eax
  100aaa:	68 98 37 10 00       	push   $0x103798
  100aaf:	e8 a5 f7 ff ff       	call   100259 <cprintf>
  100ab4:	83 c4 20             	add    $0x20,%esp
                stack_val_args[1], stack_val_args[2], stack_val_args[3]);

        // print function info
        print_debuginfo(stack_val_eip - 1);
  100ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aba:	83 e8 01             	sub    $0x1,%eax
  100abd:	83 ec 0c             	sub    $0xc,%esp
  100ac0:	50                   	push   %eax
  100ac1:	e8 ba fe ff ff       	call   100980 <print_debuginfo>
  100ac6:	83 c4 10             	add    $0x10,%esp

        // pop up stackframe, refresh ebp & eip
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
  100ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100acc:	83 c0 04             	add    $0x4,%eax
  100acf:	8b 00                	mov    (%eax),%eax
  100ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));
  100ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad7:	8b 00                	mov    (%eax),%eax
  100ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)

        // ebp should be valid
        if (stack_val_ebp <= 0) {
  100adc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ae0:	74 10                	je     100af2 <print_stackframe+0xc5>
    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
    
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  100ae2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ae6:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100aea:	0f 8e 63 ff ff ff    	jle    100a53 <print_stackframe+0x26>
        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
        }
    }
}
  100af0:	eb 01                	jmp    100af3 <print_stackframe+0xc6>
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));

        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
  100af2:	90                   	nop
        }
    }
}
  100af3:	90                   	nop
  100af4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100af7:	c9                   	leave  
  100af8:	c3                   	ret    

00100af9 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100af9:	55                   	push   %ebp
  100afa:	89 e5                	mov    %esp,%ebp
  100afc:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100aff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b06:	eb 0c                	jmp    100b14 <parse+0x1b>
            *buf ++ = '\0';
  100b08:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0b:	8d 50 01             	lea    0x1(%eax),%edx
  100b0e:	89 55 08             	mov    %edx,0x8(%ebp)
  100b11:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b14:	8b 45 08             	mov    0x8(%ebp),%eax
  100b17:	0f b6 00             	movzbl (%eax),%eax
  100b1a:	84 c0                	test   %al,%al
  100b1c:	74 1e                	je     100b3c <parse+0x43>
  100b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b21:	0f b6 00             	movzbl (%eax),%eax
  100b24:	0f be c0             	movsbl %al,%eax
  100b27:	83 ec 08             	sub    $0x8,%esp
  100b2a:	50                   	push   %eax
  100b2b:	68 3c 38 10 00       	push   $0x10383c
  100b30:	e8 10 21 00 00       	call   102c45 <strchr>
  100b35:	83 c4 10             	add    $0x10,%esp
  100b38:	85 c0                	test   %eax,%eax
  100b3a:	75 cc                	jne    100b08 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b3f:	0f b6 00             	movzbl (%eax),%eax
  100b42:	84 c0                	test   %al,%al
  100b44:	74 69                	je     100baf <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b46:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b4a:	75 12                	jne    100b5e <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b4c:	83 ec 08             	sub    $0x8,%esp
  100b4f:	6a 10                	push   $0x10
  100b51:	68 41 38 10 00       	push   $0x103841
  100b56:	e8 fe f6 ff ff       	call   100259 <cprintf>
  100b5b:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b61:	8d 50 01             	lea    0x1(%eax),%edx
  100b64:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b71:	01 c2                	add    %eax,%edx
  100b73:	8b 45 08             	mov    0x8(%ebp),%eax
  100b76:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b78:	eb 04                	jmp    100b7e <parse+0x85>
            buf ++;
  100b7a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b81:	0f b6 00             	movzbl (%eax),%eax
  100b84:	84 c0                	test   %al,%al
  100b86:	0f 84 7a ff ff ff    	je     100b06 <parse+0xd>
  100b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8f:	0f b6 00             	movzbl (%eax),%eax
  100b92:	0f be c0             	movsbl %al,%eax
  100b95:	83 ec 08             	sub    $0x8,%esp
  100b98:	50                   	push   %eax
  100b99:	68 3c 38 10 00       	push   $0x10383c
  100b9e:	e8 a2 20 00 00       	call   102c45 <strchr>
  100ba3:	83 c4 10             	add    $0x10,%esp
  100ba6:	85 c0                	test   %eax,%eax
  100ba8:	74 d0                	je     100b7a <parse+0x81>
            buf ++;
        }
    }
  100baa:	e9 57 ff ff ff       	jmp    100b06 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100baf:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bb3:	c9                   	leave  
  100bb4:	c3                   	ret    

00100bb5 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bb5:	55                   	push   %ebp
  100bb6:	89 e5                	mov    %esp,%ebp
  100bb8:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bbb:	83 ec 08             	sub    $0x8,%esp
  100bbe:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bc1:	50                   	push   %eax
  100bc2:	ff 75 08             	pushl  0x8(%ebp)
  100bc5:	e8 2f ff ff ff       	call   100af9 <parse>
  100bca:	83 c4 10             	add    $0x10,%esp
  100bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bd4:	75 0a                	jne    100be0 <runcmd+0x2b>
        return 0;
  100bd6:	b8 00 00 00 00       	mov    $0x0,%eax
  100bdb:	e9 83 00 00 00       	jmp    100c63 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100be0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100be7:	eb 59                	jmp    100c42 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100be9:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bef:	89 d0                	mov    %edx,%eax
  100bf1:	01 c0                	add    %eax,%eax
  100bf3:	01 d0                	add    %edx,%eax
  100bf5:	c1 e0 02             	shl    $0x2,%eax
  100bf8:	05 00 e0 10 00       	add    $0x10e000,%eax
  100bfd:	8b 00                	mov    (%eax),%eax
  100bff:	83 ec 08             	sub    $0x8,%esp
  100c02:	51                   	push   %ecx
  100c03:	50                   	push   %eax
  100c04:	e8 9c 1f 00 00       	call   102ba5 <strcmp>
  100c09:	83 c4 10             	add    $0x10,%esp
  100c0c:	85 c0                	test   %eax,%eax
  100c0e:	75 2e                	jne    100c3e <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c13:	89 d0                	mov    %edx,%eax
  100c15:	01 c0                	add    %eax,%eax
  100c17:	01 d0                	add    %edx,%eax
  100c19:	c1 e0 02             	shl    $0x2,%eax
  100c1c:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c21:	8b 10                	mov    (%eax),%edx
  100c23:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c26:	83 c0 04             	add    $0x4,%eax
  100c29:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c2c:	83 e9 01             	sub    $0x1,%ecx
  100c2f:	83 ec 04             	sub    $0x4,%esp
  100c32:	ff 75 0c             	pushl  0xc(%ebp)
  100c35:	50                   	push   %eax
  100c36:	51                   	push   %ecx
  100c37:	ff d2                	call   *%edx
  100c39:	83 c4 10             	add    $0x10,%esp
  100c3c:	eb 25                	jmp    100c63 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c3e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c45:	83 f8 02             	cmp    $0x2,%eax
  100c48:	76 9f                	jbe    100be9 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c4a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c4d:	83 ec 08             	sub    $0x8,%esp
  100c50:	50                   	push   %eax
  100c51:	68 5f 38 10 00       	push   $0x10385f
  100c56:	e8 fe f5 ff ff       	call   100259 <cprintf>
  100c5b:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c63:	c9                   	leave  
  100c64:	c3                   	ret    

00100c65 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c65:	55                   	push   %ebp
  100c66:	89 e5                	mov    %esp,%ebp
  100c68:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c6b:	83 ec 0c             	sub    $0xc,%esp
  100c6e:	68 78 38 10 00       	push   $0x103878
  100c73:	e8 e1 f5 ff ff       	call   100259 <cprintf>
  100c78:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c7b:	83 ec 0c             	sub    $0xc,%esp
  100c7e:	68 a0 38 10 00       	push   $0x1038a0
  100c83:	e8 d1 f5 ff ff       	call   100259 <cprintf>
  100c88:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c8f:	74 0e                	je     100c9f <kmonitor+0x3a>
        print_trapframe(tf);
  100c91:	83 ec 0c             	sub    $0xc,%esp
  100c94:	ff 75 08             	pushl  0x8(%ebp)
  100c97:	e8 52 0d 00 00       	call   1019ee <print_trapframe>
  100c9c:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c9f:	83 ec 0c             	sub    $0xc,%esp
  100ca2:	68 c5 38 10 00       	push   $0x1038c5
  100ca7:	e8 51 f6 ff ff       	call   1002fd <readline>
  100cac:	83 c4 10             	add    $0x10,%esp
  100caf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cb6:	74 e7                	je     100c9f <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100cb8:	83 ec 08             	sub    $0x8,%esp
  100cbb:	ff 75 08             	pushl  0x8(%ebp)
  100cbe:	ff 75 f4             	pushl  -0xc(%ebp)
  100cc1:	e8 ef fe ff ff       	call   100bb5 <runcmd>
  100cc6:	83 c4 10             	add    $0x10,%esp
  100cc9:	85 c0                	test   %eax,%eax
  100ccb:	78 02                	js     100ccf <kmonitor+0x6a>
                break;
            }
        }
    }
  100ccd:	eb d0                	jmp    100c9f <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100ccf:	90                   	nop
            }
        }
    }
}
  100cd0:	90                   	nop
  100cd1:	c9                   	leave  
  100cd2:	c3                   	ret    

00100cd3 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cd3:	55                   	push   %ebp
  100cd4:	89 e5                	mov    %esp,%ebp
  100cd6:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ce0:	eb 3c                	jmp    100d1e <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100ce2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce5:	89 d0                	mov    %edx,%eax
  100ce7:	01 c0                	add    %eax,%eax
  100ce9:	01 d0                	add    %edx,%eax
  100ceb:	c1 e0 02             	shl    $0x2,%eax
  100cee:	05 04 e0 10 00       	add    $0x10e004,%eax
  100cf3:	8b 08                	mov    (%eax),%ecx
  100cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cf8:	89 d0                	mov    %edx,%eax
  100cfa:	01 c0                	add    %eax,%eax
  100cfc:	01 d0                	add    %edx,%eax
  100cfe:	c1 e0 02             	shl    $0x2,%eax
  100d01:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d06:	8b 00                	mov    (%eax),%eax
  100d08:	83 ec 04             	sub    $0x4,%esp
  100d0b:	51                   	push   %ecx
  100d0c:	50                   	push   %eax
  100d0d:	68 c9 38 10 00       	push   $0x1038c9
  100d12:	e8 42 f5 ff ff       	call   100259 <cprintf>
  100d17:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d1a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d21:	83 f8 02             	cmp    $0x2,%eax
  100d24:	76 bc                	jbe    100ce2 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d2b:	c9                   	leave  
  100d2c:	c3                   	ret    

00100d2d <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d2d:	55                   	push   %ebp
  100d2e:	89 e5                	mov    %esp,%ebp
  100d30:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d33:	e8 ab fb ff ff       	call   1008e3 <print_kerninfo>
    return 0;
  100d38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d3d:	c9                   	leave  
  100d3e:	c3                   	ret    

00100d3f <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d3f:	55                   	push   %ebp
  100d40:	89 e5                	mov    %esp,%ebp
  100d42:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d45:	e8 e3 fc ff ff       	call   100a2d <print_stackframe>
    return 0;
  100d4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d4f:	c9                   	leave  
  100d50:	c3                   	ret    

00100d51 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d51:	55                   	push   %ebp
  100d52:	89 e5                	mov    %esp,%ebp
  100d54:	83 ec 18             	sub    $0x18,%esp
  100d57:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d5d:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d61:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d65:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d69:	ee                   	out    %al,(%dx)
  100d6a:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d70:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d74:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d78:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d7c:	ee                   	out    %al,(%dx)
  100d7d:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d83:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d87:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d8b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d8f:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d90:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d97:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d9a:	83 ec 0c             	sub    $0xc,%esp
  100d9d:	68 d2 38 10 00       	push   $0x1038d2
  100da2:	e8 b2 f4 ff ff       	call   100259 <cprintf>
  100da7:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100daa:	83 ec 0c             	sub    $0xc,%esp
  100dad:	6a 00                	push   $0x0
  100daf:	e8 ce 08 00 00       	call   101682 <pic_enable>
  100db4:	83 c4 10             	add    $0x10,%esp
}
  100db7:	90                   	nop
  100db8:	c9                   	leave  
  100db9:	c3                   	ret    

00100dba <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dba:	55                   	push   %ebp
  100dbb:	89 e5                	mov    %esp,%ebp
  100dbd:	83 ec 10             	sub    $0x10,%esp
  100dc0:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dc6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dca:	89 c2                	mov    %eax,%edx
  100dcc:	ec                   	in     (%dx),%al
  100dcd:	88 45 f4             	mov    %al,-0xc(%ebp)
  100dd0:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100dd6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100dda:	89 c2                	mov    %eax,%edx
  100ddc:	ec                   	in     (%dx),%al
  100ddd:	88 45 f5             	mov    %al,-0xb(%ebp)
  100de0:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100de6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dea:	89 c2                	mov    %eax,%edx
  100dec:	ec                   	in     (%dx),%al
  100ded:	88 45 f6             	mov    %al,-0xa(%ebp)
  100df0:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100df6:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100dfa:	89 c2                	mov    %eax,%edx
  100dfc:	ec                   	in     (%dx),%al
  100dfd:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e00:	90                   	nop
  100e01:	c9                   	leave  
  100e02:	c3                   	ret    

00100e03 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e03:	55                   	push   %ebp
  100e04:	89 e5                	mov    %esp,%ebp
  100e06:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e09:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e13:	0f b7 00             	movzwl (%eax),%eax
  100e16:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e1d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e25:	0f b7 00             	movzwl (%eax),%eax
  100e28:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e2c:	74 12                	je     100e40 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e2e:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e35:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e3c:	b4 03 
  100e3e:	eb 13                	jmp    100e53 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e43:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e47:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e4a:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e51:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e53:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e5a:	0f b7 c0             	movzwl %ax,%eax
  100e5d:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100e61:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e65:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100e69:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100e6d:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e6e:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e75:	83 c0 01             	add    $0x1,%eax
  100e78:	0f b7 c0             	movzwl %ax,%eax
  100e7b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e7f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e83:	89 c2                	mov    %eax,%edx
  100e85:	ec                   	in     (%dx),%al
  100e86:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100e89:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100e8d:	0f b6 c0             	movzbl %al,%eax
  100e90:	c1 e0 08             	shl    $0x8,%eax
  100e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e96:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e9d:	0f b7 c0             	movzwl %ax,%eax
  100ea0:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100ea4:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ea8:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100eac:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100eb0:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100eb1:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb8:	83 c0 01             	add    $0x1,%eax
  100ebb:	0f b7 c0             	movzwl %ax,%eax
  100ebe:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ec2:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ec6:	89 c2                	mov    %eax,%edx
  100ec8:	ec                   	in     (%dx),%al
  100ec9:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ecc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ed0:	0f b6 c0             	movzbl %al,%eax
  100ed3:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed9:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ee1:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ee7:	90                   	nop
  100ee8:	c9                   	leave  
  100ee9:	c3                   	ret    

00100eea <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100eea:	55                   	push   %ebp
  100eeb:	89 e5                	mov    %esp,%ebp
  100eed:	83 ec 28             	sub    $0x28,%esp
  100ef0:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ef6:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100efa:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100efe:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f02:	ee                   	out    %al,(%dx)
  100f03:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100f09:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100f0d:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100f11:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100f15:	ee                   	out    %al,(%dx)
  100f16:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f1c:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f20:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f24:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f28:	ee                   	out    %al,(%dx)
  100f29:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f2f:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f33:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f37:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f3b:	ee                   	out    %al,(%dx)
  100f3c:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f42:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f46:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f4a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f4e:	ee                   	out    %al,(%dx)
  100f4f:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f55:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f59:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100f5d:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100f61:	ee                   	out    %al,(%dx)
  100f62:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f68:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100f6c:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100f70:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f74:	ee                   	out    %al,(%dx)
  100f75:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f7b:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100f7f:	89 c2                	mov    %eax,%edx
  100f81:	ec                   	in     (%dx),%al
  100f82:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100f85:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f89:	3c ff                	cmp    $0xff,%al
  100f8b:	0f 95 c0             	setne  %al
  100f8e:	0f b6 c0             	movzbl %al,%eax
  100f91:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f96:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f9c:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100fa0:	89 c2                	mov    %eax,%edx
  100fa2:	ec                   	in     (%dx),%al
  100fa3:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100fa6:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100fac:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100fb0:	89 c2                	mov    %eax,%edx
  100fb2:	ec                   	in     (%dx),%al
  100fb3:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fb6:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fbb:	85 c0                	test   %eax,%eax
  100fbd:	74 0d                	je     100fcc <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100fbf:	83 ec 0c             	sub    $0xc,%esp
  100fc2:	6a 04                	push   $0x4
  100fc4:	e8 b9 06 00 00       	call   101682 <pic_enable>
  100fc9:	83 c4 10             	add    $0x10,%esp
    }
}
  100fcc:	90                   	nop
  100fcd:	c9                   	leave  
  100fce:	c3                   	ret    

00100fcf <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fcf:	55                   	push   %ebp
  100fd0:	89 e5                	mov    %esp,%ebp
  100fd2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fdc:	eb 09                	jmp    100fe7 <lpt_putc_sub+0x18>
        delay();
  100fde:	e8 d7 fd ff ff       	call   100dba <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fe3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fe7:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100fed:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100ff1:	89 c2                	mov    %eax,%edx
  100ff3:	ec                   	in     (%dx),%al
  100ff4:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100ff7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100ffb:	84 c0                	test   %al,%al
  100ffd:	78 09                	js     101008 <lpt_putc_sub+0x39>
  100fff:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101006:	7e d6                	jle    100fde <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101008:	8b 45 08             	mov    0x8(%ebp),%eax
  10100b:	0f b6 c0             	movzbl %al,%eax
  10100e:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  101014:	88 45 f0             	mov    %al,-0x10(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101017:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  10101b:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10101f:	ee                   	out    %al,(%dx)
  101020:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101026:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10102a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10102e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101032:	ee                   	out    %al,(%dx)
  101033:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  101039:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  10103d:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  101041:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101045:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101046:	90                   	nop
  101047:	c9                   	leave  
  101048:	c3                   	ret    

00101049 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101049:	55                   	push   %ebp
  10104a:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10104c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101050:	74 0d                	je     10105f <lpt_putc+0x16>
        lpt_putc_sub(c);
  101052:	ff 75 08             	pushl  0x8(%ebp)
  101055:	e8 75 ff ff ff       	call   100fcf <lpt_putc_sub>
  10105a:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10105d:	eb 1e                	jmp    10107d <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  10105f:	6a 08                	push   $0x8
  101061:	e8 69 ff ff ff       	call   100fcf <lpt_putc_sub>
  101066:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  101069:	6a 20                	push   $0x20
  10106b:	e8 5f ff ff ff       	call   100fcf <lpt_putc_sub>
  101070:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101073:	6a 08                	push   $0x8
  101075:	e8 55 ff ff ff       	call   100fcf <lpt_putc_sub>
  10107a:	83 c4 04             	add    $0x4,%esp
    }
}
  10107d:	90                   	nop
  10107e:	c9                   	leave  
  10107f:	c3                   	ret    

00101080 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101080:	55                   	push   %ebp
  101081:	89 e5                	mov    %esp,%ebp
  101083:	53                   	push   %ebx
  101084:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101087:	8b 45 08             	mov    0x8(%ebp),%eax
  10108a:	b0 00                	mov    $0x0,%al
  10108c:	85 c0                	test   %eax,%eax
  10108e:	75 07                	jne    101097 <cga_putc+0x17>
        c |= 0x0700;
  101090:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101097:	8b 45 08             	mov    0x8(%ebp),%eax
  10109a:	0f b6 c0             	movzbl %al,%eax
  10109d:	83 f8 0a             	cmp    $0xa,%eax
  1010a0:	74 4e                	je     1010f0 <cga_putc+0x70>
  1010a2:	83 f8 0d             	cmp    $0xd,%eax
  1010a5:	74 59                	je     101100 <cga_putc+0x80>
  1010a7:	83 f8 08             	cmp    $0x8,%eax
  1010aa:	0f 85 8a 00 00 00    	jne    10113a <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  1010b0:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010b7:	66 85 c0             	test   %ax,%ax
  1010ba:	0f 84 a0 00 00 00    	je     101160 <cga_putc+0xe0>
            crt_pos --;
  1010c0:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010c7:	83 e8 01             	sub    $0x1,%eax
  1010ca:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010d0:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010d5:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010dc:	0f b7 d2             	movzwl %dx,%edx
  1010df:	01 d2                	add    %edx,%edx
  1010e1:	01 d0                	add    %edx,%eax
  1010e3:	8b 55 08             	mov    0x8(%ebp),%edx
  1010e6:	b2 00                	mov    $0x0,%dl
  1010e8:	83 ca 20             	or     $0x20,%edx
  1010eb:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010ee:	eb 70                	jmp    101160 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  1010f0:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010f7:	83 c0 50             	add    $0x50,%eax
  1010fa:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101100:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101107:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10110e:	0f b7 c1             	movzwl %cx,%eax
  101111:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101117:	c1 e8 10             	shr    $0x10,%eax
  10111a:	89 c2                	mov    %eax,%edx
  10111c:	66 c1 ea 06          	shr    $0x6,%dx
  101120:	89 d0                	mov    %edx,%eax
  101122:	c1 e0 02             	shl    $0x2,%eax
  101125:	01 d0                	add    %edx,%eax
  101127:	c1 e0 04             	shl    $0x4,%eax
  10112a:	29 c1                	sub    %eax,%ecx
  10112c:	89 ca                	mov    %ecx,%edx
  10112e:	89 d8                	mov    %ebx,%eax
  101130:	29 d0                	sub    %edx,%eax
  101132:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101138:	eb 27                	jmp    101161 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10113a:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101140:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101147:	8d 50 01             	lea    0x1(%eax),%edx
  10114a:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101151:	0f b7 c0             	movzwl %ax,%eax
  101154:	01 c0                	add    %eax,%eax
  101156:	01 c8                	add    %ecx,%eax
  101158:	8b 55 08             	mov    0x8(%ebp),%edx
  10115b:	66 89 10             	mov    %dx,(%eax)
        break;
  10115e:	eb 01                	jmp    101161 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  101160:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101161:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101168:	66 3d cf 07          	cmp    $0x7cf,%ax
  10116c:	76 59                	jbe    1011c7 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10116e:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101173:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101179:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10117e:	83 ec 04             	sub    $0x4,%esp
  101181:	68 00 0f 00 00       	push   $0xf00
  101186:	52                   	push   %edx
  101187:	50                   	push   %eax
  101188:	e8 b7 1c 00 00       	call   102e44 <memmove>
  10118d:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101190:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101197:	eb 15                	jmp    1011ae <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  101199:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10119e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011a1:	01 d2                	add    %edx,%edx
  1011a3:	01 d0                	add    %edx,%eax
  1011a5:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011ae:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011b5:	7e e2                	jle    101199 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011b7:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011be:	83 e8 50             	sub    $0x50,%eax
  1011c1:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011c7:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011ce:	0f b7 c0             	movzwl %ax,%eax
  1011d1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011d5:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  1011d9:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1011dd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011e1:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011e2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011e9:	66 c1 e8 08          	shr    $0x8,%ax
  1011ed:	0f b6 c0             	movzbl %al,%eax
  1011f0:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011f7:	83 c2 01             	add    $0x1,%edx
  1011fa:	0f b7 d2             	movzwl %dx,%edx
  1011fd:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  101201:	88 45 e9             	mov    %al,-0x17(%ebp)
  101204:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101208:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10120c:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10120d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101214:	0f b7 c0             	movzwl %ax,%eax
  101217:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10121b:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  10121f:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101223:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101227:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101228:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10122f:	0f b6 c0             	movzbl %al,%eax
  101232:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101239:	83 c2 01             	add    $0x1,%edx
  10123c:	0f b7 d2             	movzwl %dx,%edx
  10123f:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101243:	88 45 eb             	mov    %al,-0x15(%ebp)
  101246:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10124a:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10124e:	ee                   	out    %al,(%dx)
}
  10124f:	90                   	nop
  101250:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101253:	c9                   	leave  
  101254:	c3                   	ret    

00101255 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101255:	55                   	push   %ebp
  101256:	89 e5                	mov    %esp,%ebp
  101258:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10125b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101262:	eb 09                	jmp    10126d <serial_putc_sub+0x18>
        delay();
  101264:	e8 51 fb ff ff       	call   100dba <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101269:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10126d:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101273:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101277:	89 c2                	mov    %eax,%edx
  101279:	ec                   	in     (%dx),%al
  10127a:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10127d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  101281:	0f b6 c0             	movzbl %al,%eax
  101284:	83 e0 20             	and    $0x20,%eax
  101287:	85 c0                	test   %eax,%eax
  101289:	75 09                	jne    101294 <serial_putc_sub+0x3f>
  10128b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101292:	7e d0                	jle    101264 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101294:	8b 45 08             	mov    0x8(%ebp),%eax
  101297:	0f b6 c0             	movzbl %al,%eax
  10129a:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1012a0:	88 45 f6             	mov    %al,-0xa(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a3:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  1012a7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1012ab:	ee                   	out    %al,(%dx)
}
  1012ac:	90                   	nop
  1012ad:	c9                   	leave  
  1012ae:	c3                   	ret    

001012af <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012af:	55                   	push   %ebp
  1012b0:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012b2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012b6:	74 0d                	je     1012c5 <serial_putc+0x16>
        serial_putc_sub(c);
  1012b8:	ff 75 08             	pushl  0x8(%ebp)
  1012bb:	e8 95 ff ff ff       	call   101255 <serial_putc_sub>
  1012c0:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012c3:	eb 1e                	jmp    1012e3 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  1012c5:	6a 08                	push   $0x8
  1012c7:	e8 89 ff ff ff       	call   101255 <serial_putc_sub>
  1012cc:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012cf:	6a 20                	push   $0x20
  1012d1:	e8 7f ff ff ff       	call   101255 <serial_putc_sub>
  1012d6:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012d9:	6a 08                	push   $0x8
  1012db:	e8 75 ff ff ff       	call   101255 <serial_putc_sub>
  1012e0:	83 c4 04             	add    $0x4,%esp
    }
}
  1012e3:	90                   	nop
  1012e4:	c9                   	leave  
  1012e5:	c3                   	ret    

001012e6 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012e6:	55                   	push   %ebp
  1012e7:	89 e5                	mov    %esp,%ebp
  1012e9:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012ec:	eb 33                	jmp    101321 <cons_intr+0x3b>
        if (c != 0) {
  1012ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012f2:	74 2d                	je     101321 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012f4:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012f9:	8d 50 01             	lea    0x1(%eax),%edx
  1012fc:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101302:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101305:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10130b:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101310:	3d 00 02 00 00       	cmp    $0x200,%eax
  101315:	75 0a                	jne    101321 <cons_intr+0x3b>
                cons.wpos = 0;
  101317:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10131e:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101321:	8b 45 08             	mov    0x8(%ebp),%eax
  101324:	ff d0                	call   *%eax
  101326:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101329:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10132d:	75 bf                	jne    1012ee <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10132f:	90                   	nop
  101330:	c9                   	leave  
  101331:	c3                   	ret    

00101332 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101332:	55                   	push   %ebp
  101333:	89 e5                	mov    %esp,%ebp
  101335:	83 ec 10             	sub    $0x10,%esp
  101338:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10133e:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101342:	89 c2                	mov    %eax,%edx
  101344:	ec                   	in     (%dx),%al
  101345:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  101348:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10134c:	0f b6 c0             	movzbl %al,%eax
  10134f:	83 e0 01             	and    $0x1,%eax
  101352:	85 c0                	test   %eax,%eax
  101354:	75 07                	jne    10135d <serial_proc_data+0x2b>
        return -1;
  101356:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10135b:	eb 2a                	jmp    101387 <serial_proc_data+0x55>
  10135d:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101363:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101367:	89 c2                	mov    %eax,%edx
  101369:	ec                   	in     (%dx),%al
  10136a:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  10136d:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101371:	0f b6 c0             	movzbl %al,%eax
  101374:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101377:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10137b:	75 07                	jne    101384 <serial_proc_data+0x52>
        c = '\b';
  10137d:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101384:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101387:	c9                   	leave  
  101388:	c3                   	ret    

00101389 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101389:	55                   	push   %ebp
  10138a:	89 e5                	mov    %esp,%ebp
  10138c:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  10138f:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101394:	85 c0                	test   %eax,%eax
  101396:	74 10                	je     1013a8 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101398:	83 ec 0c             	sub    $0xc,%esp
  10139b:	68 32 13 10 00       	push   $0x101332
  1013a0:	e8 41 ff ff ff       	call   1012e6 <cons_intr>
  1013a5:	83 c4 10             	add    $0x10,%esp
    }
}
  1013a8:	90                   	nop
  1013a9:	c9                   	leave  
  1013aa:	c3                   	ret    

001013ab <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013ab:	55                   	push   %ebp
  1013ac:	89 e5                	mov    %esp,%ebp
  1013ae:	83 ec 18             	sub    $0x18,%esp
  1013b1:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013b7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013bb:	89 c2                	mov    %eax,%edx
  1013bd:	ec                   	in     (%dx),%al
  1013be:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013c1:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013c5:	0f b6 c0             	movzbl %al,%eax
  1013c8:	83 e0 01             	and    $0x1,%eax
  1013cb:	85 c0                	test   %eax,%eax
  1013cd:	75 0a                	jne    1013d9 <kbd_proc_data+0x2e>
        return -1;
  1013cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d4:	e9 5d 01 00 00       	jmp    101536 <kbd_proc_data+0x18b>
  1013d9:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013e3:	89 c2                	mov    %eax,%edx
  1013e5:	ec                   	in     (%dx),%al
  1013e6:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  1013e9:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013ed:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013f0:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013f4:	75 17                	jne    10140d <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013f6:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013fb:	83 c8 40             	or     $0x40,%eax
  1013fe:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101403:	b8 00 00 00 00       	mov    $0x0,%eax
  101408:	e9 29 01 00 00       	jmp    101536 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  10140d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101411:	84 c0                	test   %al,%al
  101413:	79 47                	jns    10145c <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101415:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10141a:	83 e0 40             	and    $0x40,%eax
  10141d:	85 c0                	test   %eax,%eax
  10141f:	75 09                	jne    10142a <kbd_proc_data+0x7f>
  101421:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101425:	83 e0 7f             	and    $0x7f,%eax
  101428:	eb 04                	jmp    10142e <kbd_proc_data+0x83>
  10142a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10142e:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101431:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101435:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10143c:	83 c8 40             	or     $0x40,%eax
  10143f:	0f b6 c0             	movzbl %al,%eax
  101442:	f7 d0                	not    %eax
  101444:	89 c2                	mov    %eax,%edx
  101446:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10144b:	21 d0                	and    %edx,%eax
  10144d:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101452:	b8 00 00 00 00       	mov    $0x0,%eax
  101457:	e9 da 00 00 00       	jmp    101536 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  10145c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101461:	83 e0 40             	and    $0x40,%eax
  101464:	85 c0                	test   %eax,%eax
  101466:	74 11                	je     101479 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101468:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10146c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101471:	83 e0 bf             	and    $0xffffffbf,%eax
  101474:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101479:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147d:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101484:	0f b6 d0             	movzbl %al,%edx
  101487:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148c:	09 d0                	or     %edx,%eax
  10148e:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101493:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101497:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  10149e:	0f b6 d0             	movzbl %al,%edx
  1014a1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a6:	31 d0                	xor    %edx,%eax
  1014a8:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014ad:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b2:	83 e0 03             	and    $0x3,%eax
  1014b5:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014bc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c0:	01 d0                	add    %edx,%eax
  1014c2:	0f b6 00             	movzbl (%eax),%eax
  1014c5:	0f b6 c0             	movzbl %al,%eax
  1014c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014cb:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d0:	83 e0 08             	and    $0x8,%eax
  1014d3:	85 c0                	test   %eax,%eax
  1014d5:	74 22                	je     1014f9 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014d7:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014db:	7e 0c                	jle    1014e9 <kbd_proc_data+0x13e>
  1014dd:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014e1:	7f 06                	jg     1014e9 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014e3:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014e7:	eb 10                	jmp    1014f9 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014e9:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014ed:	7e 0a                	jle    1014f9 <kbd_proc_data+0x14e>
  1014ef:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014f3:	7f 04                	jg     1014f9 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014f5:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014f9:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014fe:	f7 d0                	not    %eax
  101500:	83 e0 06             	and    $0x6,%eax
  101503:	85 c0                	test   %eax,%eax
  101505:	75 2c                	jne    101533 <kbd_proc_data+0x188>
  101507:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10150e:	75 23                	jne    101533 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  101510:	83 ec 0c             	sub    $0xc,%esp
  101513:	68 ed 38 10 00       	push   $0x1038ed
  101518:	e8 3c ed ff ff       	call   100259 <cprintf>
  10151d:	83 c4 10             	add    $0x10,%esp
  101520:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  101526:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10152a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10152e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101532:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101533:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101536:	c9                   	leave  
  101537:	c3                   	ret    

00101538 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101538:	55                   	push   %ebp
  101539:	89 e5                	mov    %esp,%ebp
  10153b:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10153e:	83 ec 0c             	sub    $0xc,%esp
  101541:	68 ab 13 10 00       	push   $0x1013ab
  101546:	e8 9b fd ff ff       	call   1012e6 <cons_intr>
  10154b:	83 c4 10             	add    $0x10,%esp
}
  10154e:	90                   	nop
  10154f:	c9                   	leave  
  101550:	c3                   	ret    

00101551 <kbd_init>:

static void
kbd_init(void) {
  101551:	55                   	push   %ebp
  101552:	89 e5                	mov    %esp,%ebp
  101554:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101557:	e8 dc ff ff ff       	call   101538 <kbd_intr>
    pic_enable(IRQ_KBD);
  10155c:	83 ec 0c             	sub    $0xc,%esp
  10155f:	6a 01                	push   $0x1
  101561:	e8 1c 01 00 00       	call   101682 <pic_enable>
  101566:	83 c4 10             	add    $0x10,%esp
}
  101569:	90                   	nop
  10156a:	c9                   	leave  
  10156b:	c3                   	ret    

0010156c <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10156c:	55                   	push   %ebp
  10156d:	89 e5                	mov    %esp,%ebp
  10156f:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101572:	e8 8c f8 ff ff       	call   100e03 <cga_init>
    serial_init();
  101577:	e8 6e f9 ff ff       	call   100eea <serial_init>
    kbd_init();
  10157c:	e8 d0 ff ff ff       	call   101551 <kbd_init>
    if (!serial_exists) {
  101581:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101586:	85 c0                	test   %eax,%eax
  101588:	75 10                	jne    10159a <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10158a:	83 ec 0c             	sub    $0xc,%esp
  10158d:	68 f9 38 10 00       	push   $0x1038f9
  101592:	e8 c2 ec ff ff       	call   100259 <cprintf>
  101597:	83 c4 10             	add    $0x10,%esp
    }
}
  10159a:	90                   	nop
  10159b:	c9                   	leave  
  10159c:	c3                   	ret    

0010159d <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10159d:	55                   	push   %ebp
  10159e:	89 e5                	mov    %esp,%ebp
  1015a0:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  1015a3:	ff 75 08             	pushl  0x8(%ebp)
  1015a6:	e8 9e fa ff ff       	call   101049 <lpt_putc>
  1015ab:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1015ae:	83 ec 0c             	sub    $0xc,%esp
  1015b1:	ff 75 08             	pushl  0x8(%ebp)
  1015b4:	e8 c7 fa ff ff       	call   101080 <cga_putc>
  1015b9:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1015bc:	83 ec 0c             	sub    $0xc,%esp
  1015bf:	ff 75 08             	pushl  0x8(%ebp)
  1015c2:	e8 e8 fc ff ff       	call   1012af <serial_putc>
  1015c7:	83 c4 10             	add    $0x10,%esp
}
  1015ca:	90                   	nop
  1015cb:	c9                   	leave  
  1015cc:	c3                   	ret    

001015cd <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015cd:	55                   	push   %ebp
  1015ce:	89 e5                	mov    %esp,%ebp
  1015d0:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015d3:	e8 b1 fd ff ff       	call   101389 <serial_intr>
    kbd_intr();
  1015d8:	e8 5b ff ff ff       	call   101538 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015dd:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015e3:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015e8:	39 c2                	cmp    %eax,%edx
  1015ea:	74 36                	je     101622 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015ec:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f1:	8d 50 01             	lea    0x1(%eax),%edx
  1015f4:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015fa:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  101601:	0f b6 c0             	movzbl %al,%eax
  101604:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101607:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10160c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101611:	75 0a                	jne    10161d <cons_getc+0x50>
            cons.rpos = 0;
  101613:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10161a:	00 00 00 
        }
        return c;
  10161d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101620:	eb 05                	jmp    101627 <cons_getc+0x5a>
    }
    return 0;
  101622:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101627:	c9                   	leave  
  101628:	c3                   	ret    

00101629 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101629:	55                   	push   %ebp
  10162a:	89 e5                	mov    %esp,%ebp
  10162c:	83 ec 14             	sub    $0x14,%esp
  10162f:	8b 45 08             	mov    0x8(%ebp),%eax
  101632:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101636:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163a:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101640:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101645:	85 c0                	test   %eax,%eax
  101647:	74 36                	je     10167f <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101649:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10164d:	0f b6 c0             	movzbl %al,%eax
  101650:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101656:	88 45 fa             	mov    %al,-0x6(%ebp)
  101659:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  10165d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101661:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101662:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101666:	66 c1 e8 08          	shr    $0x8,%ax
  10166a:	0f b6 c0             	movzbl %al,%eax
  10166d:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101673:	88 45 fb             	mov    %al,-0x5(%ebp)
  101676:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  10167a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  10167e:	ee                   	out    %al,(%dx)
    }
}
  10167f:	90                   	nop
  101680:	c9                   	leave  
  101681:	c3                   	ret    

00101682 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101682:	55                   	push   %ebp
  101683:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101685:	8b 45 08             	mov    0x8(%ebp),%eax
  101688:	ba 01 00 00 00       	mov    $0x1,%edx
  10168d:	89 c1                	mov    %eax,%ecx
  10168f:	d3 e2                	shl    %cl,%edx
  101691:	89 d0                	mov    %edx,%eax
  101693:	f7 d0                	not    %eax
  101695:	89 c2                	mov    %eax,%edx
  101697:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10169e:	21 d0                	and    %edx,%eax
  1016a0:	0f b7 c0             	movzwl %ax,%eax
  1016a3:	50                   	push   %eax
  1016a4:	e8 80 ff ff ff       	call   101629 <pic_setmask>
  1016a9:	83 c4 04             	add    $0x4,%esp
}
  1016ac:	90                   	nop
  1016ad:	c9                   	leave  
  1016ae:	c3                   	ret    

001016af <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016af:	55                   	push   %ebp
  1016b0:	89 e5                	mov    %esp,%ebp
  1016b2:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  1016b5:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016bc:	00 00 00 
  1016bf:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016c5:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1016c9:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1016cd:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016d1:	ee                   	out    %al,(%dx)
  1016d2:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016d8:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1016dc:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1016e0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016e4:	ee                   	out    %al,(%dx)
  1016e5:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1016eb:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  1016ef:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  1016f3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016f7:	ee                   	out    %al,(%dx)
  1016f8:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  1016fe:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  101702:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101706:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10170a:	ee                   	out    %al,(%dx)
  10170b:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  101711:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101715:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  101719:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10171d:	ee                   	out    %al,(%dx)
  10171e:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101724:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  101728:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  10172c:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  101730:	ee                   	out    %al,(%dx)
  101731:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  101737:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  10173b:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  10173f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101743:	ee                   	out    %al,(%dx)
  101744:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  10174a:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  10174e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101752:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101756:	ee                   	out    %al,(%dx)
  101757:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10175d:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  101761:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  101765:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101769:	ee                   	out    %al,(%dx)
  10176a:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  101770:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  101774:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  101778:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10177c:	ee                   	out    %al,(%dx)
  10177d:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  101783:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  101787:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  10178b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10178f:	ee                   	out    %al,(%dx)
  101790:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  101796:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  10179a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10179e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1017a2:	ee                   	out    %al,(%dx)
  1017a3:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017a9:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  1017ad:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  1017b1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017b5:	ee                   	out    %al,(%dx)
  1017b6:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  1017bc:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  1017c0:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1017c4:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1017c8:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017c9:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d0:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017d4:	74 13                	je     1017e9 <pic_init+0x13a>
        pic_setmask(irq_mask);
  1017d6:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017dd:	0f b7 c0             	movzwl %ax,%eax
  1017e0:	50                   	push   %eax
  1017e1:	e8 43 fe ff ff       	call   101629 <pic_setmask>
  1017e6:	83 c4 04             	add    $0x4,%esp
    }
}
  1017e9:	90                   	nop
  1017ea:	c9                   	leave  
  1017eb:	c3                   	ret    

001017ec <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017ec:	55                   	push   %ebp
  1017ed:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017ef:	fb                   	sti    
    sti();
}
  1017f0:	90                   	nop
  1017f1:	5d                   	pop    %ebp
  1017f2:	c3                   	ret    

001017f3 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017f3:	55                   	push   %ebp
  1017f4:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017f6:	fa                   	cli    
    cli();
}
  1017f7:	90                   	nop
  1017f8:	5d                   	pop    %ebp
  1017f9:	c3                   	ret    

001017fa <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017fa:	55                   	push   %ebp
  1017fb:	89 e5                	mov    %esp,%ebp
  1017fd:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101800:	83 ec 08             	sub    $0x8,%esp
  101803:	6a 64                	push   $0x64
  101805:	68 20 39 10 00       	push   $0x103920
  10180a:	e8 4a ea ff ff       	call   100259 <cprintf>
  10180f:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101812:	83 ec 0c             	sub    $0xc,%esp
  101815:	68 2a 39 10 00       	push   $0x10392a
  10181a:	e8 3a ea ff ff       	call   100259 <cprintf>
  10181f:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  101822:	83 ec 04             	sub    $0x4,%esp
  101825:	68 38 39 10 00       	push   $0x103938
  10182a:	6a 12                	push   $0x12
  10182c:	68 4e 39 10 00       	push   $0x10394e
  101831:	e8 89 eb ff ff       	call   1003bf <__panic>

00101836 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101836:	55                   	push   %ebp
  101837:	89 e5                	mov    %esp,%ebp
  101839:	83 ec 10             	sub    $0x10,%esp
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
  10183c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101843:	e9 c3 00 00 00       	jmp    10190b <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101848:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184b:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101852:	89 c2                	mov    %eax,%edx
  101854:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101857:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10185e:	00 
  10185f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101862:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101869:	00 08 00 
  10186c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10186f:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101876:	00 
  101877:	83 e2 e0             	and    $0xffffffe0,%edx
  10187a:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101881:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101884:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10188b:	00 
  10188c:	83 e2 1f             	and    $0x1f,%edx
  10188f:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101896:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101899:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018a0:	00 
  1018a1:	83 e2 f0             	and    $0xfffffff0,%edx
  1018a4:	83 ca 0e             	or     $0xe,%edx
  1018a7:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b1:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018b8:	00 
  1018b9:	83 e2 ef             	and    $0xffffffef,%edx
  1018bc:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c6:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018cd:	00 
  1018ce:	83 e2 9f             	and    $0xffffff9f,%edx
  1018d1:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018db:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018e2:	00 
  1018e3:	83 ca 80             	or     $0xffffff80,%edx
  1018e6:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f0:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018f7:	c1 e8 10             	shr    $0x10,%eax
  1018fa:	89 c2                	mov    %eax,%edx
  1018fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ff:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101906:	00 
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
  101907:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10190b:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101912:	0f 8e 30 ff ff ff    	jle    101848 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }

	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101918:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10191d:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101923:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  10192a:	08 00 
  10192c:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101933:	83 e0 e0             	and    $0xffffffe0,%eax
  101936:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10193b:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101942:	83 e0 1f             	and    $0x1f,%eax
  101945:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10194a:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101951:	83 e0 f0             	and    $0xfffffff0,%eax
  101954:	83 c8 0e             	or     $0xe,%eax
  101957:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10195c:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101963:	83 e0 ef             	and    $0xffffffef,%eax
  101966:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10196b:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101972:	83 c8 60             	or     $0x60,%eax
  101975:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10197a:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101981:	83 c8 80             	or     $0xffffff80,%eax
  101984:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101989:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10198e:	c1 e8 10             	shr    $0x10,%eax
  101991:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101997:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  10199e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019a1:	0f 01 18             	lidtl  (%eax)

    // 3. LIDT
    lidt(&idt_pd);
}
  1019a4:	90                   	nop
  1019a5:	c9                   	leave  
  1019a6:	c3                   	ret    

001019a7 <trapname>:

static const char *
trapname(int trapno) {
  1019a7:	55                   	push   %ebp
  1019a8:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ad:	83 f8 13             	cmp    $0x13,%eax
  1019b0:	77 0c                	ja     1019be <trapname+0x17>
        return excnames[trapno];
  1019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b5:	8b 04 85 e0 3c 10 00 	mov    0x103ce0(,%eax,4),%eax
  1019bc:	eb 18                	jmp    1019d6 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019be:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019c2:	7e 0d                	jle    1019d1 <trapname+0x2a>
  1019c4:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019c8:	7f 07                	jg     1019d1 <trapname+0x2a>
        return "Hardware Interrupt";
  1019ca:	b8 5f 39 10 00       	mov    $0x10395f,%eax
  1019cf:	eb 05                	jmp    1019d6 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019d1:	b8 72 39 10 00       	mov    $0x103972,%eax
}
  1019d6:	5d                   	pop    %ebp
  1019d7:	c3                   	ret    

001019d8 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019d8:	55                   	push   %ebp
  1019d9:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019db:	8b 45 08             	mov    0x8(%ebp),%eax
  1019de:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019e2:	66 83 f8 08          	cmp    $0x8,%ax
  1019e6:	0f 94 c0             	sete   %al
  1019e9:	0f b6 c0             	movzbl %al,%eax
}
  1019ec:	5d                   	pop    %ebp
  1019ed:	c3                   	ret    

001019ee <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019ee:	55                   	push   %ebp
  1019ef:	89 e5                	mov    %esp,%ebp
  1019f1:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  1019f4:	83 ec 08             	sub    $0x8,%esp
  1019f7:	ff 75 08             	pushl  0x8(%ebp)
  1019fa:	68 b3 39 10 00       	push   $0x1039b3
  1019ff:	e8 55 e8 ff ff       	call   100259 <cprintf>
  101a04:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101a07:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0a:	83 ec 0c             	sub    $0xc,%esp
  101a0d:	50                   	push   %eax
  101a0e:	e8 b8 01 00 00       	call   101bcb <print_regs>
  101a13:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a16:	8b 45 08             	mov    0x8(%ebp),%eax
  101a19:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a1d:	0f b7 c0             	movzwl %ax,%eax
  101a20:	83 ec 08             	sub    $0x8,%esp
  101a23:	50                   	push   %eax
  101a24:	68 c4 39 10 00       	push   $0x1039c4
  101a29:	e8 2b e8 ff ff       	call   100259 <cprintf>
  101a2e:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a31:	8b 45 08             	mov    0x8(%ebp),%eax
  101a34:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a38:	0f b7 c0             	movzwl %ax,%eax
  101a3b:	83 ec 08             	sub    $0x8,%esp
  101a3e:	50                   	push   %eax
  101a3f:	68 d7 39 10 00       	push   $0x1039d7
  101a44:	e8 10 e8 ff ff       	call   100259 <cprintf>
  101a49:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a53:	0f b7 c0             	movzwl %ax,%eax
  101a56:	83 ec 08             	sub    $0x8,%esp
  101a59:	50                   	push   %eax
  101a5a:	68 ea 39 10 00       	push   $0x1039ea
  101a5f:	e8 f5 e7 ff ff       	call   100259 <cprintf>
  101a64:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a67:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a6e:	0f b7 c0             	movzwl %ax,%eax
  101a71:	83 ec 08             	sub    $0x8,%esp
  101a74:	50                   	push   %eax
  101a75:	68 fd 39 10 00       	push   $0x1039fd
  101a7a:	e8 da e7 ff ff       	call   100259 <cprintf>
  101a7f:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a82:	8b 45 08             	mov    0x8(%ebp),%eax
  101a85:	8b 40 30             	mov    0x30(%eax),%eax
  101a88:	83 ec 0c             	sub    $0xc,%esp
  101a8b:	50                   	push   %eax
  101a8c:	e8 16 ff ff ff       	call   1019a7 <trapname>
  101a91:	83 c4 10             	add    $0x10,%esp
  101a94:	89 c2                	mov    %eax,%edx
  101a96:	8b 45 08             	mov    0x8(%ebp),%eax
  101a99:	8b 40 30             	mov    0x30(%eax),%eax
  101a9c:	83 ec 04             	sub    $0x4,%esp
  101a9f:	52                   	push   %edx
  101aa0:	50                   	push   %eax
  101aa1:	68 10 3a 10 00       	push   $0x103a10
  101aa6:	e8 ae e7 ff ff       	call   100259 <cprintf>
  101aab:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101aae:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab1:	8b 40 34             	mov    0x34(%eax),%eax
  101ab4:	83 ec 08             	sub    $0x8,%esp
  101ab7:	50                   	push   %eax
  101ab8:	68 22 3a 10 00       	push   $0x103a22
  101abd:	e8 97 e7 ff ff       	call   100259 <cprintf>
  101ac2:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac8:	8b 40 38             	mov    0x38(%eax),%eax
  101acb:	83 ec 08             	sub    $0x8,%esp
  101ace:	50                   	push   %eax
  101acf:	68 31 3a 10 00       	push   $0x103a31
  101ad4:	e8 80 e7 ff ff       	call   100259 <cprintf>
  101ad9:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101adc:	8b 45 08             	mov    0x8(%ebp),%eax
  101adf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ae3:	0f b7 c0             	movzwl %ax,%eax
  101ae6:	83 ec 08             	sub    $0x8,%esp
  101ae9:	50                   	push   %eax
  101aea:	68 40 3a 10 00       	push   $0x103a40
  101aef:	e8 65 e7 ff ff       	call   100259 <cprintf>
  101af4:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101af7:	8b 45 08             	mov    0x8(%ebp),%eax
  101afa:	8b 40 40             	mov    0x40(%eax),%eax
  101afd:	83 ec 08             	sub    $0x8,%esp
  101b00:	50                   	push   %eax
  101b01:	68 53 3a 10 00       	push   $0x103a53
  101b06:	e8 4e e7 ff ff       	call   100259 <cprintf>
  101b0b:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b15:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b1c:	eb 3f                	jmp    101b5d <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b21:	8b 50 40             	mov    0x40(%eax),%edx
  101b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b27:	21 d0                	and    %edx,%eax
  101b29:	85 c0                	test   %eax,%eax
  101b2b:	74 29                	je     101b56 <print_trapframe+0x168>
  101b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b30:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b37:	85 c0                	test   %eax,%eax
  101b39:	74 1b                	je     101b56 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b3e:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b45:	83 ec 08             	sub    $0x8,%esp
  101b48:	50                   	push   %eax
  101b49:	68 62 3a 10 00       	push   $0x103a62
  101b4e:	e8 06 e7 ff ff       	call   100259 <cprintf>
  101b53:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b56:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b5a:	d1 65 f0             	shll   -0x10(%ebp)
  101b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b60:	83 f8 17             	cmp    $0x17,%eax
  101b63:	76 b9                	jbe    101b1e <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b65:	8b 45 08             	mov    0x8(%ebp),%eax
  101b68:	8b 40 40             	mov    0x40(%eax),%eax
  101b6b:	25 00 30 00 00       	and    $0x3000,%eax
  101b70:	c1 e8 0c             	shr    $0xc,%eax
  101b73:	83 ec 08             	sub    $0x8,%esp
  101b76:	50                   	push   %eax
  101b77:	68 66 3a 10 00       	push   $0x103a66
  101b7c:	e8 d8 e6 ff ff       	call   100259 <cprintf>
  101b81:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101b84:	83 ec 0c             	sub    $0xc,%esp
  101b87:	ff 75 08             	pushl  0x8(%ebp)
  101b8a:	e8 49 fe ff ff       	call   1019d8 <trap_in_kernel>
  101b8f:	83 c4 10             	add    $0x10,%esp
  101b92:	85 c0                	test   %eax,%eax
  101b94:	75 32                	jne    101bc8 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b96:	8b 45 08             	mov    0x8(%ebp),%eax
  101b99:	8b 40 44             	mov    0x44(%eax),%eax
  101b9c:	83 ec 08             	sub    $0x8,%esp
  101b9f:	50                   	push   %eax
  101ba0:	68 6f 3a 10 00       	push   $0x103a6f
  101ba5:	e8 af e6 ff ff       	call   100259 <cprintf>
  101baa:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bad:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb0:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bb4:	0f b7 c0             	movzwl %ax,%eax
  101bb7:	83 ec 08             	sub    $0x8,%esp
  101bba:	50                   	push   %eax
  101bbb:	68 7e 3a 10 00       	push   $0x103a7e
  101bc0:	e8 94 e6 ff ff       	call   100259 <cprintf>
  101bc5:	83 c4 10             	add    $0x10,%esp
    }
}
  101bc8:	90                   	nop
  101bc9:	c9                   	leave  
  101bca:	c3                   	ret    

00101bcb <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bcb:	55                   	push   %ebp
  101bcc:	89 e5                	mov    %esp,%ebp
  101bce:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd4:	8b 00                	mov    (%eax),%eax
  101bd6:	83 ec 08             	sub    $0x8,%esp
  101bd9:	50                   	push   %eax
  101bda:	68 91 3a 10 00       	push   $0x103a91
  101bdf:	e8 75 e6 ff ff       	call   100259 <cprintf>
  101be4:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101be7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bea:	8b 40 04             	mov    0x4(%eax),%eax
  101bed:	83 ec 08             	sub    $0x8,%esp
  101bf0:	50                   	push   %eax
  101bf1:	68 a0 3a 10 00       	push   $0x103aa0
  101bf6:	e8 5e e6 ff ff       	call   100259 <cprintf>
  101bfb:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  101c01:	8b 40 08             	mov    0x8(%eax),%eax
  101c04:	83 ec 08             	sub    $0x8,%esp
  101c07:	50                   	push   %eax
  101c08:	68 af 3a 10 00       	push   $0x103aaf
  101c0d:	e8 47 e6 ff ff       	call   100259 <cprintf>
  101c12:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c15:	8b 45 08             	mov    0x8(%ebp),%eax
  101c18:	8b 40 0c             	mov    0xc(%eax),%eax
  101c1b:	83 ec 08             	sub    $0x8,%esp
  101c1e:	50                   	push   %eax
  101c1f:	68 be 3a 10 00       	push   $0x103abe
  101c24:	e8 30 e6 ff ff       	call   100259 <cprintf>
  101c29:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2f:	8b 40 10             	mov    0x10(%eax),%eax
  101c32:	83 ec 08             	sub    $0x8,%esp
  101c35:	50                   	push   %eax
  101c36:	68 cd 3a 10 00       	push   $0x103acd
  101c3b:	e8 19 e6 ff ff       	call   100259 <cprintf>
  101c40:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c43:	8b 45 08             	mov    0x8(%ebp),%eax
  101c46:	8b 40 14             	mov    0x14(%eax),%eax
  101c49:	83 ec 08             	sub    $0x8,%esp
  101c4c:	50                   	push   %eax
  101c4d:	68 dc 3a 10 00       	push   $0x103adc
  101c52:	e8 02 e6 ff ff       	call   100259 <cprintf>
  101c57:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5d:	8b 40 18             	mov    0x18(%eax),%eax
  101c60:	83 ec 08             	sub    $0x8,%esp
  101c63:	50                   	push   %eax
  101c64:	68 eb 3a 10 00       	push   $0x103aeb
  101c69:	e8 eb e5 ff ff       	call   100259 <cprintf>
  101c6e:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c71:	8b 45 08             	mov    0x8(%ebp),%eax
  101c74:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c77:	83 ec 08             	sub    $0x8,%esp
  101c7a:	50                   	push   %eax
  101c7b:	68 fa 3a 10 00       	push   $0x103afa
  101c80:	e8 d4 e5 ff ff       	call   100259 <cprintf>
  101c85:	83 c4 10             	add    $0x10,%esp
}
  101c88:	90                   	nop
  101c89:	c9                   	leave  
  101c8a:	c3                   	ret    

00101c8b <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c8b:	55                   	push   %ebp
  101c8c:	89 e5                	mov    %esp,%ebp
  101c8e:	57                   	push   %edi
  101c8f:	56                   	push   %esi
  101c90:	53                   	push   %ebx
  101c91:	83 ec 1c             	sub    $0x1c,%esp
    //     print_trapframe(tf);
    //     cprintf("\n");
    // }
    char c;

    switch (tf->tf_trapno) {
  101c94:	8b 45 08             	mov    0x8(%ebp),%eax
  101c97:	8b 40 30             	mov    0x30(%eax),%eax
  101c9a:	83 f8 2f             	cmp    $0x2f,%eax
  101c9d:	77 21                	ja     101cc0 <trap_dispatch+0x35>
  101c9f:	83 f8 2e             	cmp    $0x2e,%eax
  101ca2:	0f 83 a0 01 00 00    	jae    101e48 <trap_dispatch+0x1bd>
  101ca8:	83 f8 21             	cmp    $0x21,%eax
  101cab:	0f 84 87 00 00 00    	je     101d38 <trap_dispatch+0xad>
  101cb1:	83 f8 24             	cmp    $0x24,%eax
  101cb4:	74 5b                	je     101d11 <trap_dispatch+0x86>
  101cb6:	83 f8 20             	cmp    $0x20,%eax
  101cb9:	74 1c                	je     101cd7 <trap_dispatch+0x4c>
  101cbb:	e9 52 01 00 00       	jmp    101e12 <trap_dispatch+0x187>
  101cc0:	83 f8 78             	cmp    $0x78,%eax
  101cc3:	0f 84 96 00 00 00    	je     101d5f <trap_dispatch+0xd4>
  101cc9:	83 f8 79             	cmp    $0x79,%eax
  101ccc:	0f 84 0d 01 00 00    	je     101ddf <trap_dispatch+0x154>
  101cd2:	e9 3b 01 00 00       	jmp    101e12 <trap_dispatch+0x187>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        // 1. record
        ticks++;
  101cd7:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101cdc:	83 c0 01             	add    $0x1,%eax
  101cdf:	a3 08 f9 10 00       	mov    %eax,0x10f908

        // 2. print
        if (ticks % 100 == 0) {
  101ce4:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101cea:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cef:	89 c8                	mov    %ecx,%eax
  101cf1:	f7 e2                	mul    %edx
  101cf3:	89 d0                	mov    %edx,%eax
  101cf5:	c1 e8 05             	shr    $0x5,%eax
  101cf8:	6b c0 64             	imul   $0x64,%eax,%eax
  101cfb:	29 c1                	sub    %eax,%ecx
  101cfd:	89 c8                	mov    %ecx,%eax
  101cff:	85 c0                	test   %eax,%eax
  101d01:	0f 85 44 01 00 00    	jne    101e4b <trap_dispatch+0x1c0>
            print_ticks();
  101d07:	e8 ee fa ff ff       	call   1017fa <print_ticks>
        }

        // 3. too simple ?!
        break;
  101d0c:	e9 3a 01 00 00       	jmp    101e4b <trap_dispatch+0x1c0>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d11:	e8 b7 f8 ff ff       	call   1015cd <cons_getc>
  101d16:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d19:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d1d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d21:	83 ec 04             	sub    $0x4,%esp
  101d24:	52                   	push   %edx
  101d25:	50                   	push   %eax
  101d26:	68 09 3b 10 00       	push   $0x103b09
  101d2b:	e8 29 e5 ff ff       	call   100259 <cprintf>
  101d30:	83 c4 10             	add    $0x10,%esp
        break;
  101d33:	e9 14 01 00 00       	jmp    101e4c <trap_dispatch+0x1c1>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d38:	e8 90 f8 ff ff       	call   1015cd <cons_getc>
  101d3d:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d40:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d44:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d48:	83 ec 04             	sub    $0x4,%esp
  101d4b:	52                   	push   %edx
  101d4c:	50                   	push   %eax
  101d4d:	68 1b 3b 10 00       	push   $0x103b1b
  101d52:	e8 02 e5 ff ff       	call   100259 <cprintf>
  101d57:	83 c4 10             	add    $0x10,%esp
        break;
  101d5a:	e9 ed 00 00 00       	jmp    101e4c <trap_dispatch+0x1c1>
    //LAB1 CHALLENGE 1 : 2015010062 you should modify below codes.
    case T_SWITCH_TOU:
        switchk2u = *tf;
  101d5f:	8b 55 08             	mov    0x8(%ebp),%edx
  101d62:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101d67:	89 d3                	mov    %edx,%ebx
  101d69:	ba 4c 00 00 00       	mov    $0x4c,%edx
  101d6e:	8b 0b                	mov    (%ebx),%ecx
  101d70:	89 08                	mov    %ecx,(%eax)
  101d72:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  101d76:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  101d7a:	8d 78 04             	lea    0x4(%eax),%edi
  101d7d:	83 e7 fc             	and    $0xfffffffc,%edi
  101d80:	29 f8                	sub    %edi,%eax
  101d82:	29 c3                	sub    %eax,%ebx
  101d84:	01 c2                	add    %eax,%edx
  101d86:	83 e2 fc             	and    $0xfffffffc,%edx
  101d89:	89 d0                	mov    %edx,%eax
  101d8b:	c1 e8 02             	shr    $0x2,%eax
  101d8e:	89 de                	mov    %ebx,%esi
  101d90:	89 c1                	mov    %eax,%ecx
  101d92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        switchk2u.tf_cs = USER_CS;
  101d94:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101d9b:	1b 00 
        switchk2u.tf_ds = USER_DS;
  101d9d:	66 c7 05 4c f9 10 00 	movw   $0x23,0x10f94c
  101da4:	23 00 
        switchk2u.tf_es = USER_DS;
  101da6:	66 c7 05 48 f9 10 00 	movw   $0x23,0x10f948
  101dad:	23 00 
        switchk2u.tf_ss = USER_DS;
  101daf:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101db6:	23 00 

        switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101db8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dbb:	83 c0 44             	add    $0x44,%eax
  101dbe:	a3 64 f9 10 00       	mov    %eax,0x10f964
		
        // set eflags, make sure ucore can use io under user mode.
        // if CPL > IOPL, then cpu will generate a general protection.
        switchk2u.tf_eflags |= FL_IOPL_MASK;
  101dc3:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101dc8:	80 cc 30             	or     $0x30,%ah
  101dcb:	a3 60 f9 10 00       	mov    %eax,0x10f960
    
        // set temporary stack
        // then iret will jump to the right stack
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd3:	83 e8 04             	sub    $0x4,%eax
  101dd6:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101ddb:	89 10                	mov    %edx,(%eax)
        break;
  101ddd:	eb 6d                	jmp    101e4c <trap_dispatch+0x1c1>
    case T_SWITCH_TOK:
        // panic("T_SWITCH_** ??\n");
        tf->tf_cs = KERNEL_CS;
  101ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  101de2:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = tf->tf_es = KERNEL_DS;
  101de8:	8b 45 08             	mov    0x8(%ebp),%eax
  101deb:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101df1:	8b 45 08             	mov    0x8(%ebp),%eax
  101df4:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101df8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfb:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
  101dff:	8b 45 08             	mov    0x8(%ebp),%eax
  101e02:	8b 40 40             	mov    0x40(%eax),%eax
  101e05:	80 e4 cf             	and    $0xcf,%ah
  101e08:	89 c2                	mov    %eax,%edx
  101e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0d:	89 50 40             	mov    %edx,0x40(%eax)
        break;
  101e10:	eb 3a                	jmp    101e4c <trap_dispatch+0x1c1>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e12:	8b 45 08             	mov    0x8(%ebp),%eax
  101e15:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e19:	0f b7 c0             	movzwl %ax,%eax
  101e1c:	83 e0 03             	and    $0x3,%eax
  101e1f:	85 c0                	test   %eax,%eax
  101e21:	75 29                	jne    101e4c <trap_dispatch+0x1c1>
            print_trapframe(tf);
  101e23:	83 ec 0c             	sub    $0xc,%esp
  101e26:	ff 75 08             	pushl  0x8(%ebp)
  101e29:	e8 c0 fb ff ff       	call   1019ee <print_trapframe>
  101e2e:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101e31:	83 ec 04             	sub    $0x4,%esp
  101e34:	68 2a 3b 10 00       	push   $0x103b2a
  101e39:	68 dc 00 00 00       	push   $0xdc
  101e3e:	68 4e 39 10 00       	push   $0x10394e
  101e43:	e8 77 e5 ff ff       	call   1003bf <__panic>
        tf->tf_eflags &= ~FL_IOPL_MASK;
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e48:	90                   	nop
  101e49:	eb 01                	jmp    101e4c <trap_dispatch+0x1c1>
        if (ticks % 100 == 0) {
            print_ticks();
        }

        // 3. too simple ?!
        break;
  101e4b:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e4c:	90                   	nop
  101e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  101e50:	5b                   	pop    %ebx
  101e51:	5e                   	pop    %esi
  101e52:	5f                   	pop    %edi
  101e53:	5d                   	pop    %ebp
  101e54:	c3                   	ret    

00101e55 <cur_debug>:

void
cur_debug(void) {
  101e55:	55                   	push   %ebp
  101e56:	89 e5                	mov    %esp,%ebp
  101e58:	83 ec 18             	sub    $0x18,%esp
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  101e5b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  101e5e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  101e61:	8c 45 f2             	mov    %es,-0xe(%ebp)
  101e64:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", reg1 & 3);
  101e67:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101e6b:	0f b7 c0             	movzwl %ax,%eax
  101e6e:	83 e0 03             	and    $0x3,%eax
  101e71:	83 ec 08             	sub    $0x8,%esp
  101e74:	50                   	push   %eax
  101e75:	68 46 3b 10 00       	push   $0x103b46
  101e7a:	e8 da e3 ff ff       	call   100259 <cprintf>
  101e7f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", reg1);
  101e82:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101e86:	0f b7 c0             	movzwl %ax,%eax
  101e89:	83 ec 08             	sub    $0x8,%esp
  101e8c:	50                   	push   %eax
  101e8d:	68 54 3b 10 00       	push   $0x103b54
  101e92:	e8 c2 e3 ff ff       	call   100259 <cprintf>
  101e97:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", reg2);
  101e9a:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  101e9e:	0f b7 c0             	movzwl %ax,%eax
  101ea1:	83 ec 08             	sub    $0x8,%esp
  101ea4:	50                   	push   %eax
  101ea5:	68 62 3b 10 00       	push   $0x103b62
  101eaa:	e8 aa e3 ff ff       	call   100259 <cprintf>
  101eaf:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", reg3);
  101eb2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101eb6:	0f b7 c0             	movzwl %ax,%eax
  101eb9:	83 ec 08             	sub    $0x8,%esp
  101ebc:	50                   	push   %eax
  101ebd:	68 70 3b 10 00       	push   $0x103b70
  101ec2:	e8 92 e3 ff ff       	call   100259 <cprintf>
  101ec7:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", reg4);
  101eca:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101ece:	0f b7 c0             	movzwl %ax,%eax
  101ed1:	83 ec 08             	sub    $0x8,%esp
  101ed4:	50                   	push   %eax
  101ed5:	68 7e 3b 10 00       	push   $0x103b7e
  101eda:	e8 7a e3 ff ff       	call   100259 <cprintf>
  101edf:	83 c4 10             	add    $0x10,%esp
}
  101ee2:	90                   	nop
  101ee3:	c9                   	leave  
  101ee4:	c3                   	ret    

00101ee5 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ee5:	55                   	push   %ebp
  101ee6:	89 e5                	mov    %esp,%ebp
  101ee8:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101eeb:	83 ec 0c             	sub    $0xc,%esp
  101eee:	ff 75 08             	pushl  0x8(%ebp)
  101ef1:	e8 95 fd ff ff       	call   101c8b <trap_dispatch>
  101ef6:	83 c4 10             	add    $0x10,%esp
}
  101ef9:	90                   	nop
  101efa:	c9                   	leave  
  101efb:	c3                   	ret    

00101efc <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $0
  101efe:	6a 00                	push   $0x0
  jmp __alltraps
  101f00:	e9 69 0a 00 00       	jmp    10296e <__alltraps>

00101f05 <vector1>:
.globl vector1
vector1:
  pushl $0
  101f05:	6a 00                	push   $0x0
  pushl $1
  101f07:	6a 01                	push   $0x1
  jmp __alltraps
  101f09:	e9 60 0a 00 00       	jmp    10296e <__alltraps>

00101f0e <vector2>:
.globl vector2
vector2:
  pushl $0
  101f0e:	6a 00                	push   $0x0
  pushl $2
  101f10:	6a 02                	push   $0x2
  jmp __alltraps
  101f12:	e9 57 0a 00 00       	jmp    10296e <__alltraps>

00101f17 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f17:	6a 00                	push   $0x0
  pushl $3
  101f19:	6a 03                	push   $0x3
  jmp __alltraps
  101f1b:	e9 4e 0a 00 00       	jmp    10296e <__alltraps>

00101f20 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f20:	6a 00                	push   $0x0
  pushl $4
  101f22:	6a 04                	push   $0x4
  jmp __alltraps
  101f24:	e9 45 0a 00 00       	jmp    10296e <__alltraps>

00101f29 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f29:	6a 00                	push   $0x0
  pushl $5
  101f2b:	6a 05                	push   $0x5
  jmp __alltraps
  101f2d:	e9 3c 0a 00 00       	jmp    10296e <__alltraps>

00101f32 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f32:	6a 00                	push   $0x0
  pushl $6
  101f34:	6a 06                	push   $0x6
  jmp __alltraps
  101f36:	e9 33 0a 00 00       	jmp    10296e <__alltraps>

00101f3b <vector7>:
.globl vector7
vector7:
  pushl $0
  101f3b:	6a 00                	push   $0x0
  pushl $7
  101f3d:	6a 07                	push   $0x7
  jmp __alltraps
  101f3f:	e9 2a 0a 00 00       	jmp    10296e <__alltraps>

00101f44 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f44:	6a 08                	push   $0x8
  jmp __alltraps
  101f46:	e9 23 0a 00 00       	jmp    10296e <__alltraps>

00101f4b <vector9>:
.globl vector9
vector9:
  pushl $0
  101f4b:	6a 00                	push   $0x0
  pushl $9
  101f4d:	6a 09                	push   $0x9
  jmp __alltraps
  101f4f:	e9 1a 0a 00 00       	jmp    10296e <__alltraps>

00101f54 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f54:	6a 0a                	push   $0xa
  jmp __alltraps
  101f56:	e9 13 0a 00 00       	jmp    10296e <__alltraps>

00101f5b <vector11>:
.globl vector11
vector11:
  pushl $11
  101f5b:	6a 0b                	push   $0xb
  jmp __alltraps
  101f5d:	e9 0c 0a 00 00       	jmp    10296e <__alltraps>

00101f62 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f62:	6a 0c                	push   $0xc
  jmp __alltraps
  101f64:	e9 05 0a 00 00       	jmp    10296e <__alltraps>

00101f69 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f69:	6a 0d                	push   $0xd
  jmp __alltraps
  101f6b:	e9 fe 09 00 00       	jmp    10296e <__alltraps>

00101f70 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f70:	6a 0e                	push   $0xe
  jmp __alltraps
  101f72:	e9 f7 09 00 00       	jmp    10296e <__alltraps>

00101f77 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $15
  101f79:	6a 0f                	push   $0xf
  jmp __alltraps
  101f7b:	e9 ee 09 00 00       	jmp    10296e <__alltraps>

00101f80 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f80:	6a 00                	push   $0x0
  pushl $16
  101f82:	6a 10                	push   $0x10
  jmp __alltraps
  101f84:	e9 e5 09 00 00       	jmp    10296e <__alltraps>

00101f89 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f89:	6a 11                	push   $0x11
  jmp __alltraps
  101f8b:	e9 de 09 00 00       	jmp    10296e <__alltraps>

00101f90 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f90:	6a 00                	push   $0x0
  pushl $18
  101f92:	6a 12                	push   $0x12
  jmp __alltraps
  101f94:	e9 d5 09 00 00       	jmp    10296e <__alltraps>

00101f99 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f99:	6a 00                	push   $0x0
  pushl $19
  101f9b:	6a 13                	push   $0x13
  jmp __alltraps
  101f9d:	e9 cc 09 00 00       	jmp    10296e <__alltraps>

00101fa2 <vector20>:
.globl vector20
vector20:
  pushl $0
  101fa2:	6a 00                	push   $0x0
  pushl $20
  101fa4:	6a 14                	push   $0x14
  jmp __alltraps
  101fa6:	e9 c3 09 00 00       	jmp    10296e <__alltraps>

00101fab <vector21>:
.globl vector21
vector21:
  pushl $0
  101fab:	6a 00                	push   $0x0
  pushl $21
  101fad:	6a 15                	push   $0x15
  jmp __alltraps
  101faf:	e9 ba 09 00 00       	jmp    10296e <__alltraps>

00101fb4 <vector22>:
.globl vector22
vector22:
  pushl $0
  101fb4:	6a 00                	push   $0x0
  pushl $22
  101fb6:	6a 16                	push   $0x16
  jmp __alltraps
  101fb8:	e9 b1 09 00 00       	jmp    10296e <__alltraps>

00101fbd <vector23>:
.globl vector23
vector23:
  pushl $0
  101fbd:	6a 00                	push   $0x0
  pushl $23
  101fbf:	6a 17                	push   $0x17
  jmp __alltraps
  101fc1:	e9 a8 09 00 00       	jmp    10296e <__alltraps>

00101fc6 <vector24>:
.globl vector24
vector24:
  pushl $0
  101fc6:	6a 00                	push   $0x0
  pushl $24
  101fc8:	6a 18                	push   $0x18
  jmp __alltraps
  101fca:	e9 9f 09 00 00       	jmp    10296e <__alltraps>

00101fcf <vector25>:
.globl vector25
vector25:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $25
  101fd1:	6a 19                	push   $0x19
  jmp __alltraps
  101fd3:	e9 96 09 00 00       	jmp    10296e <__alltraps>

00101fd8 <vector26>:
.globl vector26
vector26:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $26
  101fda:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fdc:	e9 8d 09 00 00       	jmp    10296e <__alltraps>

00101fe1 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $27
  101fe3:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fe5:	e9 84 09 00 00       	jmp    10296e <__alltraps>

00101fea <vector28>:
.globl vector28
vector28:
  pushl $0
  101fea:	6a 00                	push   $0x0
  pushl $28
  101fec:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fee:	e9 7b 09 00 00       	jmp    10296e <__alltraps>

00101ff3 <vector29>:
.globl vector29
vector29:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $29
  101ff5:	6a 1d                	push   $0x1d
  jmp __alltraps
  101ff7:	e9 72 09 00 00       	jmp    10296e <__alltraps>

00101ffc <vector30>:
.globl vector30
vector30:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $30
  101ffe:	6a 1e                	push   $0x1e
  jmp __alltraps
  102000:	e9 69 09 00 00       	jmp    10296e <__alltraps>

00102005 <vector31>:
.globl vector31
vector31:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $31
  102007:	6a 1f                	push   $0x1f
  jmp __alltraps
  102009:	e9 60 09 00 00       	jmp    10296e <__alltraps>

0010200e <vector32>:
.globl vector32
vector32:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $32
  102010:	6a 20                	push   $0x20
  jmp __alltraps
  102012:	e9 57 09 00 00       	jmp    10296e <__alltraps>

00102017 <vector33>:
.globl vector33
vector33:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $33
  102019:	6a 21                	push   $0x21
  jmp __alltraps
  10201b:	e9 4e 09 00 00       	jmp    10296e <__alltraps>

00102020 <vector34>:
.globl vector34
vector34:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $34
  102022:	6a 22                	push   $0x22
  jmp __alltraps
  102024:	e9 45 09 00 00       	jmp    10296e <__alltraps>

00102029 <vector35>:
.globl vector35
vector35:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $35
  10202b:	6a 23                	push   $0x23
  jmp __alltraps
  10202d:	e9 3c 09 00 00       	jmp    10296e <__alltraps>

00102032 <vector36>:
.globl vector36
vector36:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $36
  102034:	6a 24                	push   $0x24
  jmp __alltraps
  102036:	e9 33 09 00 00       	jmp    10296e <__alltraps>

0010203b <vector37>:
.globl vector37
vector37:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $37
  10203d:	6a 25                	push   $0x25
  jmp __alltraps
  10203f:	e9 2a 09 00 00       	jmp    10296e <__alltraps>

00102044 <vector38>:
.globl vector38
vector38:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $38
  102046:	6a 26                	push   $0x26
  jmp __alltraps
  102048:	e9 21 09 00 00       	jmp    10296e <__alltraps>

0010204d <vector39>:
.globl vector39
vector39:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $39
  10204f:	6a 27                	push   $0x27
  jmp __alltraps
  102051:	e9 18 09 00 00       	jmp    10296e <__alltraps>

00102056 <vector40>:
.globl vector40
vector40:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $40
  102058:	6a 28                	push   $0x28
  jmp __alltraps
  10205a:	e9 0f 09 00 00       	jmp    10296e <__alltraps>

0010205f <vector41>:
.globl vector41
vector41:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $41
  102061:	6a 29                	push   $0x29
  jmp __alltraps
  102063:	e9 06 09 00 00       	jmp    10296e <__alltraps>

00102068 <vector42>:
.globl vector42
vector42:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $42
  10206a:	6a 2a                	push   $0x2a
  jmp __alltraps
  10206c:	e9 fd 08 00 00       	jmp    10296e <__alltraps>

00102071 <vector43>:
.globl vector43
vector43:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $43
  102073:	6a 2b                	push   $0x2b
  jmp __alltraps
  102075:	e9 f4 08 00 00       	jmp    10296e <__alltraps>

0010207a <vector44>:
.globl vector44
vector44:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $44
  10207c:	6a 2c                	push   $0x2c
  jmp __alltraps
  10207e:	e9 eb 08 00 00       	jmp    10296e <__alltraps>

00102083 <vector45>:
.globl vector45
vector45:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $45
  102085:	6a 2d                	push   $0x2d
  jmp __alltraps
  102087:	e9 e2 08 00 00       	jmp    10296e <__alltraps>

0010208c <vector46>:
.globl vector46
vector46:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $46
  10208e:	6a 2e                	push   $0x2e
  jmp __alltraps
  102090:	e9 d9 08 00 00       	jmp    10296e <__alltraps>

00102095 <vector47>:
.globl vector47
vector47:
  pushl $0
  102095:	6a 00                	push   $0x0
  pushl $47
  102097:	6a 2f                	push   $0x2f
  jmp __alltraps
  102099:	e9 d0 08 00 00       	jmp    10296e <__alltraps>

0010209e <vector48>:
.globl vector48
vector48:
  pushl $0
  10209e:	6a 00                	push   $0x0
  pushl $48
  1020a0:	6a 30                	push   $0x30
  jmp __alltraps
  1020a2:	e9 c7 08 00 00       	jmp    10296e <__alltraps>

001020a7 <vector49>:
.globl vector49
vector49:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $49
  1020a9:	6a 31                	push   $0x31
  jmp __alltraps
  1020ab:	e9 be 08 00 00       	jmp    10296e <__alltraps>

001020b0 <vector50>:
.globl vector50
vector50:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $50
  1020b2:	6a 32                	push   $0x32
  jmp __alltraps
  1020b4:	e9 b5 08 00 00       	jmp    10296e <__alltraps>

001020b9 <vector51>:
.globl vector51
vector51:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $51
  1020bb:	6a 33                	push   $0x33
  jmp __alltraps
  1020bd:	e9 ac 08 00 00       	jmp    10296e <__alltraps>

001020c2 <vector52>:
.globl vector52
vector52:
  pushl $0
  1020c2:	6a 00                	push   $0x0
  pushl $52
  1020c4:	6a 34                	push   $0x34
  jmp __alltraps
  1020c6:	e9 a3 08 00 00       	jmp    10296e <__alltraps>

001020cb <vector53>:
.globl vector53
vector53:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $53
  1020cd:	6a 35                	push   $0x35
  jmp __alltraps
  1020cf:	e9 9a 08 00 00       	jmp    10296e <__alltraps>

001020d4 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $54
  1020d6:	6a 36                	push   $0x36
  jmp __alltraps
  1020d8:	e9 91 08 00 00       	jmp    10296e <__alltraps>

001020dd <vector55>:
.globl vector55
vector55:
  pushl $0
  1020dd:	6a 00                	push   $0x0
  pushl $55
  1020df:	6a 37                	push   $0x37
  jmp __alltraps
  1020e1:	e9 88 08 00 00       	jmp    10296e <__alltraps>

001020e6 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $56
  1020e8:	6a 38                	push   $0x38
  jmp __alltraps
  1020ea:	e9 7f 08 00 00       	jmp    10296e <__alltraps>

001020ef <vector57>:
.globl vector57
vector57:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $57
  1020f1:	6a 39                	push   $0x39
  jmp __alltraps
  1020f3:	e9 76 08 00 00       	jmp    10296e <__alltraps>

001020f8 <vector58>:
.globl vector58
vector58:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $58
  1020fa:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020fc:	e9 6d 08 00 00       	jmp    10296e <__alltraps>

00102101 <vector59>:
.globl vector59
vector59:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $59
  102103:	6a 3b                	push   $0x3b
  jmp __alltraps
  102105:	e9 64 08 00 00       	jmp    10296e <__alltraps>

0010210a <vector60>:
.globl vector60
vector60:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $60
  10210c:	6a 3c                	push   $0x3c
  jmp __alltraps
  10210e:	e9 5b 08 00 00       	jmp    10296e <__alltraps>

00102113 <vector61>:
.globl vector61
vector61:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $61
  102115:	6a 3d                	push   $0x3d
  jmp __alltraps
  102117:	e9 52 08 00 00       	jmp    10296e <__alltraps>

0010211c <vector62>:
.globl vector62
vector62:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $62
  10211e:	6a 3e                	push   $0x3e
  jmp __alltraps
  102120:	e9 49 08 00 00       	jmp    10296e <__alltraps>

00102125 <vector63>:
.globl vector63
vector63:
  pushl $0
  102125:	6a 00                	push   $0x0
  pushl $63
  102127:	6a 3f                	push   $0x3f
  jmp __alltraps
  102129:	e9 40 08 00 00       	jmp    10296e <__alltraps>

0010212e <vector64>:
.globl vector64
vector64:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $64
  102130:	6a 40                	push   $0x40
  jmp __alltraps
  102132:	e9 37 08 00 00       	jmp    10296e <__alltraps>

00102137 <vector65>:
.globl vector65
vector65:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $65
  102139:	6a 41                	push   $0x41
  jmp __alltraps
  10213b:	e9 2e 08 00 00       	jmp    10296e <__alltraps>

00102140 <vector66>:
.globl vector66
vector66:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $66
  102142:	6a 42                	push   $0x42
  jmp __alltraps
  102144:	e9 25 08 00 00       	jmp    10296e <__alltraps>

00102149 <vector67>:
.globl vector67
vector67:
  pushl $0
  102149:	6a 00                	push   $0x0
  pushl $67
  10214b:	6a 43                	push   $0x43
  jmp __alltraps
  10214d:	e9 1c 08 00 00       	jmp    10296e <__alltraps>

00102152 <vector68>:
.globl vector68
vector68:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $68
  102154:	6a 44                	push   $0x44
  jmp __alltraps
  102156:	e9 13 08 00 00       	jmp    10296e <__alltraps>

0010215b <vector69>:
.globl vector69
vector69:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $69
  10215d:	6a 45                	push   $0x45
  jmp __alltraps
  10215f:	e9 0a 08 00 00       	jmp    10296e <__alltraps>

00102164 <vector70>:
.globl vector70
vector70:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $70
  102166:	6a 46                	push   $0x46
  jmp __alltraps
  102168:	e9 01 08 00 00       	jmp    10296e <__alltraps>

0010216d <vector71>:
.globl vector71
vector71:
  pushl $0
  10216d:	6a 00                	push   $0x0
  pushl $71
  10216f:	6a 47                	push   $0x47
  jmp __alltraps
  102171:	e9 f8 07 00 00       	jmp    10296e <__alltraps>

00102176 <vector72>:
.globl vector72
vector72:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $72
  102178:	6a 48                	push   $0x48
  jmp __alltraps
  10217a:	e9 ef 07 00 00       	jmp    10296e <__alltraps>

0010217f <vector73>:
.globl vector73
vector73:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $73
  102181:	6a 49                	push   $0x49
  jmp __alltraps
  102183:	e9 e6 07 00 00       	jmp    10296e <__alltraps>

00102188 <vector74>:
.globl vector74
vector74:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $74
  10218a:	6a 4a                	push   $0x4a
  jmp __alltraps
  10218c:	e9 dd 07 00 00       	jmp    10296e <__alltraps>

00102191 <vector75>:
.globl vector75
vector75:
  pushl $0
  102191:	6a 00                	push   $0x0
  pushl $75
  102193:	6a 4b                	push   $0x4b
  jmp __alltraps
  102195:	e9 d4 07 00 00       	jmp    10296e <__alltraps>

0010219a <vector76>:
.globl vector76
vector76:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $76
  10219c:	6a 4c                	push   $0x4c
  jmp __alltraps
  10219e:	e9 cb 07 00 00       	jmp    10296e <__alltraps>

001021a3 <vector77>:
.globl vector77
vector77:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $77
  1021a5:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021a7:	e9 c2 07 00 00       	jmp    10296e <__alltraps>

001021ac <vector78>:
.globl vector78
vector78:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $78
  1021ae:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021b0:	e9 b9 07 00 00       	jmp    10296e <__alltraps>

001021b5 <vector79>:
.globl vector79
vector79:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $79
  1021b7:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021b9:	e9 b0 07 00 00       	jmp    10296e <__alltraps>

001021be <vector80>:
.globl vector80
vector80:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $80
  1021c0:	6a 50                	push   $0x50
  jmp __alltraps
  1021c2:	e9 a7 07 00 00       	jmp    10296e <__alltraps>

001021c7 <vector81>:
.globl vector81
vector81:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $81
  1021c9:	6a 51                	push   $0x51
  jmp __alltraps
  1021cb:	e9 9e 07 00 00       	jmp    10296e <__alltraps>

001021d0 <vector82>:
.globl vector82
vector82:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $82
  1021d2:	6a 52                	push   $0x52
  jmp __alltraps
  1021d4:	e9 95 07 00 00       	jmp    10296e <__alltraps>

001021d9 <vector83>:
.globl vector83
vector83:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $83
  1021db:	6a 53                	push   $0x53
  jmp __alltraps
  1021dd:	e9 8c 07 00 00       	jmp    10296e <__alltraps>

001021e2 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $84
  1021e4:	6a 54                	push   $0x54
  jmp __alltraps
  1021e6:	e9 83 07 00 00       	jmp    10296e <__alltraps>

001021eb <vector85>:
.globl vector85
vector85:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $85
  1021ed:	6a 55                	push   $0x55
  jmp __alltraps
  1021ef:	e9 7a 07 00 00       	jmp    10296e <__alltraps>

001021f4 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $86
  1021f6:	6a 56                	push   $0x56
  jmp __alltraps
  1021f8:	e9 71 07 00 00       	jmp    10296e <__alltraps>

001021fd <vector87>:
.globl vector87
vector87:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $87
  1021ff:	6a 57                	push   $0x57
  jmp __alltraps
  102201:	e9 68 07 00 00       	jmp    10296e <__alltraps>

00102206 <vector88>:
.globl vector88
vector88:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $88
  102208:	6a 58                	push   $0x58
  jmp __alltraps
  10220a:	e9 5f 07 00 00       	jmp    10296e <__alltraps>

0010220f <vector89>:
.globl vector89
vector89:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $89
  102211:	6a 59                	push   $0x59
  jmp __alltraps
  102213:	e9 56 07 00 00       	jmp    10296e <__alltraps>

00102218 <vector90>:
.globl vector90
vector90:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $90
  10221a:	6a 5a                	push   $0x5a
  jmp __alltraps
  10221c:	e9 4d 07 00 00       	jmp    10296e <__alltraps>

00102221 <vector91>:
.globl vector91
vector91:
  pushl $0
  102221:	6a 00                	push   $0x0
  pushl $91
  102223:	6a 5b                	push   $0x5b
  jmp __alltraps
  102225:	e9 44 07 00 00       	jmp    10296e <__alltraps>

0010222a <vector92>:
.globl vector92
vector92:
  pushl $0
  10222a:	6a 00                	push   $0x0
  pushl $92
  10222c:	6a 5c                	push   $0x5c
  jmp __alltraps
  10222e:	e9 3b 07 00 00       	jmp    10296e <__alltraps>

00102233 <vector93>:
.globl vector93
vector93:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $93
  102235:	6a 5d                	push   $0x5d
  jmp __alltraps
  102237:	e9 32 07 00 00       	jmp    10296e <__alltraps>

0010223c <vector94>:
.globl vector94
vector94:
  pushl $0
  10223c:	6a 00                	push   $0x0
  pushl $94
  10223e:	6a 5e                	push   $0x5e
  jmp __alltraps
  102240:	e9 29 07 00 00       	jmp    10296e <__alltraps>

00102245 <vector95>:
.globl vector95
vector95:
  pushl $0
  102245:	6a 00                	push   $0x0
  pushl $95
  102247:	6a 5f                	push   $0x5f
  jmp __alltraps
  102249:	e9 20 07 00 00       	jmp    10296e <__alltraps>

0010224e <vector96>:
.globl vector96
vector96:
  pushl $0
  10224e:	6a 00                	push   $0x0
  pushl $96
  102250:	6a 60                	push   $0x60
  jmp __alltraps
  102252:	e9 17 07 00 00       	jmp    10296e <__alltraps>

00102257 <vector97>:
.globl vector97
vector97:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $97
  102259:	6a 61                	push   $0x61
  jmp __alltraps
  10225b:	e9 0e 07 00 00       	jmp    10296e <__alltraps>

00102260 <vector98>:
.globl vector98
vector98:
  pushl $0
  102260:	6a 00                	push   $0x0
  pushl $98
  102262:	6a 62                	push   $0x62
  jmp __alltraps
  102264:	e9 05 07 00 00       	jmp    10296e <__alltraps>

00102269 <vector99>:
.globl vector99
vector99:
  pushl $0
  102269:	6a 00                	push   $0x0
  pushl $99
  10226b:	6a 63                	push   $0x63
  jmp __alltraps
  10226d:	e9 fc 06 00 00       	jmp    10296e <__alltraps>

00102272 <vector100>:
.globl vector100
vector100:
  pushl $0
  102272:	6a 00                	push   $0x0
  pushl $100
  102274:	6a 64                	push   $0x64
  jmp __alltraps
  102276:	e9 f3 06 00 00       	jmp    10296e <__alltraps>

0010227b <vector101>:
.globl vector101
vector101:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $101
  10227d:	6a 65                	push   $0x65
  jmp __alltraps
  10227f:	e9 ea 06 00 00       	jmp    10296e <__alltraps>

00102284 <vector102>:
.globl vector102
vector102:
  pushl $0
  102284:	6a 00                	push   $0x0
  pushl $102
  102286:	6a 66                	push   $0x66
  jmp __alltraps
  102288:	e9 e1 06 00 00       	jmp    10296e <__alltraps>

0010228d <vector103>:
.globl vector103
vector103:
  pushl $0
  10228d:	6a 00                	push   $0x0
  pushl $103
  10228f:	6a 67                	push   $0x67
  jmp __alltraps
  102291:	e9 d8 06 00 00       	jmp    10296e <__alltraps>

00102296 <vector104>:
.globl vector104
vector104:
  pushl $0
  102296:	6a 00                	push   $0x0
  pushl $104
  102298:	6a 68                	push   $0x68
  jmp __alltraps
  10229a:	e9 cf 06 00 00       	jmp    10296e <__alltraps>

0010229f <vector105>:
.globl vector105
vector105:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $105
  1022a1:	6a 69                	push   $0x69
  jmp __alltraps
  1022a3:	e9 c6 06 00 00       	jmp    10296e <__alltraps>

001022a8 <vector106>:
.globl vector106
vector106:
  pushl $0
  1022a8:	6a 00                	push   $0x0
  pushl $106
  1022aa:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022ac:	e9 bd 06 00 00       	jmp    10296e <__alltraps>

001022b1 <vector107>:
.globl vector107
vector107:
  pushl $0
  1022b1:	6a 00                	push   $0x0
  pushl $107
  1022b3:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022b5:	e9 b4 06 00 00       	jmp    10296e <__alltraps>

001022ba <vector108>:
.globl vector108
vector108:
  pushl $0
  1022ba:	6a 00                	push   $0x0
  pushl $108
  1022bc:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022be:	e9 ab 06 00 00       	jmp    10296e <__alltraps>

001022c3 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $109
  1022c5:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022c7:	e9 a2 06 00 00       	jmp    10296e <__alltraps>

001022cc <vector110>:
.globl vector110
vector110:
  pushl $0
  1022cc:	6a 00                	push   $0x0
  pushl $110
  1022ce:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022d0:	e9 99 06 00 00       	jmp    10296e <__alltraps>

001022d5 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022d5:	6a 00                	push   $0x0
  pushl $111
  1022d7:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022d9:	e9 90 06 00 00       	jmp    10296e <__alltraps>

001022de <vector112>:
.globl vector112
vector112:
  pushl $0
  1022de:	6a 00                	push   $0x0
  pushl $112
  1022e0:	6a 70                	push   $0x70
  jmp __alltraps
  1022e2:	e9 87 06 00 00       	jmp    10296e <__alltraps>

001022e7 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $113
  1022e9:	6a 71                	push   $0x71
  jmp __alltraps
  1022eb:	e9 7e 06 00 00       	jmp    10296e <__alltraps>

001022f0 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $114
  1022f2:	6a 72                	push   $0x72
  jmp __alltraps
  1022f4:	e9 75 06 00 00       	jmp    10296e <__alltraps>

001022f9 <vector115>:
.globl vector115
vector115:
  pushl $0
  1022f9:	6a 00                	push   $0x0
  pushl $115
  1022fb:	6a 73                	push   $0x73
  jmp __alltraps
  1022fd:	e9 6c 06 00 00       	jmp    10296e <__alltraps>

00102302 <vector116>:
.globl vector116
vector116:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $116
  102304:	6a 74                	push   $0x74
  jmp __alltraps
  102306:	e9 63 06 00 00       	jmp    10296e <__alltraps>

0010230b <vector117>:
.globl vector117
vector117:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $117
  10230d:	6a 75                	push   $0x75
  jmp __alltraps
  10230f:	e9 5a 06 00 00       	jmp    10296e <__alltraps>

00102314 <vector118>:
.globl vector118
vector118:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $118
  102316:	6a 76                	push   $0x76
  jmp __alltraps
  102318:	e9 51 06 00 00       	jmp    10296e <__alltraps>

0010231d <vector119>:
.globl vector119
vector119:
  pushl $0
  10231d:	6a 00                	push   $0x0
  pushl $119
  10231f:	6a 77                	push   $0x77
  jmp __alltraps
  102321:	e9 48 06 00 00       	jmp    10296e <__alltraps>

00102326 <vector120>:
.globl vector120
vector120:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $120
  102328:	6a 78                	push   $0x78
  jmp __alltraps
  10232a:	e9 3f 06 00 00       	jmp    10296e <__alltraps>

0010232f <vector121>:
.globl vector121
vector121:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $121
  102331:	6a 79                	push   $0x79
  jmp __alltraps
  102333:	e9 36 06 00 00       	jmp    10296e <__alltraps>

00102338 <vector122>:
.globl vector122
vector122:
  pushl $0
  102338:	6a 00                	push   $0x0
  pushl $122
  10233a:	6a 7a                	push   $0x7a
  jmp __alltraps
  10233c:	e9 2d 06 00 00       	jmp    10296e <__alltraps>

00102341 <vector123>:
.globl vector123
vector123:
  pushl $0
  102341:	6a 00                	push   $0x0
  pushl $123
  102343:	6a 7b                	push   $0x7b
  jmp __alltraps
  102345:	e9 24 06 00 00       	jmp    10296e <__alltraps>

0010234a <vector124>:
.globl vector124
vector124:
  pushl $0
  10234a:	6a 00                	push   $0x0
  pushl $124
  10234c:	6a 7c                	push   $0x7c
  jmp __alltraps
  10234e:	e9 1b 06 00 00       	jmp    10296e <__alltraps>

00102353 <vector125>:
.globl vector125
vector125:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $125
  102355:	6a 7d                	push   $0x7d
  jmp __alltraps
  102357:	e9 12 06 00 00       	jmp    10296e <__alltraps>

0010235c <vector126>:
.globl vector126
vector126:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $126
  10235e:	6a 7e                	push   $0x7e
  jmp __alltraps
  102360:	e9 09 06 00 00       	jmp    10296e <__alltraps>

00102365 <vector127>:
.globl vector127
vector127:
  pushl $0
  102365:	6a 00                	push   $0x0
  pushl $127
  102367:	6a 7f                	push   $0x7f
  jmp __alltraps
  102369:	e9 00 06 00 00       	jmp    10296e <__alltraps>

0010236e <vector128>:
.globl vector128
vector128:
  pushl $0
  10236e:	6a 00                	push   $0x0
  pushl $128
  102370:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102375:	e9 f4 05 00 00       	jmp    10296e <__alltraps>

0010237a <vector129>:
.globl vector129
vector129:
  pushl $0
  10237a:	6a 00                	push   $0x0
  pushl $129
  10237c:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102381:	e9 e8 05 00 00       	jmp    10296e <__alltraps>

00102386 <vector130>:
.globl vector130
vector130:
  pushl $0
  102386:	6a 00                	push   $0x0
  pushl $130
  102388:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10238d:	e9 dc 05 00 00       	jmp    10296e <__alltraps>

00102392 <vector131>:
.globl vector131
vector131:
  pushl $0
  102392:	6a 00                	push   $0x0
  pushl $131
  102394:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102399:	e9 d0 05 00 00       	jmp    10296e <__alltraps>

0010239e <vector132>:
.globl vector132
vector132:
  pushl $0
  10239e:	6a 00                	push   $0x0
  pushl $132
  1023a0:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023a5:	e9 c4 05 00 00       	jmp    10296e <__alltraps>

001023aa <vector133>:
.globl vector133
vector133:
  pushl $0
  1023aa:	6a 00                	push   $0x0
  pushl $133
  1023ac:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023b1:	e9 b8 05 00 00       	jmp    10296e <__alltraps>

001023b6 <vector134>:
.globl vector134
vector134:
  pushl $0
  1023b6:	6a 00                	push   $0x0
  pushl $134
  1023b8:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023bd:	e9 ac 05 00 00       	jmp    10296e <__alltraps>

001023c2 <vector135>:
.globl vector135
vector135:
  pushl $0
  1023c2:	6a 00                	push   $0x0
  pushl $135
  1023c4:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023c9:	e9 a0 05 00 00       	jmp    10296e <__alltraps>

001023ce <vector136>:
.globl vector136
vector136:
  pushl $0
  1023ce:	6a 00                	push   $0x0
  pushl $136
  1023d0:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023d5:	e9 94 05 00 00       	jmp    10296e <__alltraps>

001023da <vector137>:
.globl vector137
vector137:
  pushl $0
  1023da:	6a 00                	push   $0x0
  pushl $137
  1023dc:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023e1:	e9 88 05 00 00       	jmp    10296e <__alltraps>

001023e6 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023e6:	6a 00                	push   $0x0
  pushl $138
  1023e8:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023ed:	e9 7c 05 00 00       	jmp    10296e <__alltraps>

001023f2 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023f2:	6a 00                	push   $0x0
  pushl $139
  1023f4:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023f9:	e9 70 05 00 00       	jmp    10296e <__alltraps>

001023fe <vector140>:
.globl vector140
vector140:
  pushl $0
  1023fe:	6a 00                	push   $0x0
  pushl $140
  102400:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102405:	e9 64 05 00 00       	jmp    10296e <__alltraps>

0010240a <vector141>:
.globl vector141
vector141:
  pushl $0
  10240a:	6a 00                	push   $0x0
  pushl $141
  10240c:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102411:	e9 58 05 00 00       	jmp    10296e <__alltraps>

00102416 <vector142>:
.globl vector142
vector142:
  pushl $0
  102416:	6a 00                	push   $0x0
  pushl $142
  102418:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10241d:	e9 4c 05 00 00       	jmp    10296e <__alltraps>

00102422 <vector143>:
.globl vector143
vector143:
  pushl $0
  102422:	6a 00                	push   $0x0
  pushl $143
  102424:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102429:	e9 40 05 00 00       	jmp    10296e <__alltraps>

0010242e <vector144>:
.globl vector144
vector144:
  pushl $0
  10242e:	6a 00                	push   $0x0
  pushl $144
  102430:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102435:	e9 34 05 00 00       	jmp    10296e <__alltraps>

0010243a <vector145>:
.globl vector145
vector145:
  pushl $0
  10243a:	6a 00                	push   $0x0
  pushl $145
  10243c:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102441:	e9 28 05 00 00       	jmp    10296e <__alltraps>

00102446 <vector146>:
.globl vector146
vector146:
  pushl $0
  102446:	6a 00                	push   $0x0
  pushl $146
  102448:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10244d:	e9 1c 05 00 00       	jmp    10296e <__alltraps>

00102452 <vector147>:
.globl vector147
vector147:
  pushl $0
  102452:	6a 00                	push   $0x0
  pushl $147
  102454:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102459:	e9 10 05 00 00       	jmp    10296e <__alltraps>

0010245e <vector148>:
.globl vector148
vector148:
  pushl $0
  10245e:	6a 00                	push   $0x0
  pushl $148
  102460:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102465:	e9 04 05 00 00       	jmp    10296e <__alltraps>

0010246a <vector149>:
.globl vector149
vector149:
  pushl $0
  10246a:	6a 00                	push   $0x0
  pushl $149
  10246c:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102471:	e9 f8 04 00 00       	jmp    10296e <__alltraps>

00102476 <vector150>:
.globl vector150
vector150:
  pushl $0
  102476:	6a 00                	push   $0x0
  pushl $150
  102478:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10247d:	e9 ec 04 00 00       	jmp    10296e <__alltraps>

00102482 <vector151>:
.globl vector151
vector151:
  pushl $0
  102482:	6a 00                	push   $0x0
  pushl $151
  102484:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102489:	e9 e0 04 00 00       	jmp    10296e <__alltraps>

0010248e <vector152>:
.globl vector152
vector152:
  pushl $0
  10248e:	6a 00                	push   $0x0
  pushl $152
  102490:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102495:	e9 d4 04 00 00       	jmp    10296e <__alltraps>

0010249a <vector153>:
.globl vector153
vector153:
  pushl $0
  10249a:	6a 00                	push   $0x0
  pushl $153
  10249c:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024a1:	e9 c8 04 00 00       	jmp    10296e <__alltraps>

001024a6 <vector154>:
.globl vector154
vector154:
  pushl $0
  1024a6:	6a 00                	push   $0x0
  pushl $154
  1024a8:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024ad:	e9 bc 04 00 00       	jmp    10296e <__alltraps>

001024b2 <vector155>:
.globl vector155
vector155:
  pushl $0
  1024b2:	6a 00                	push   $0x0
  pushl $155
  1024b4:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024b9:	e9 b0 04 00 00       	jmp    10296e <__alltraps>

001024be <vector156>:
.globl vector156
vector156:
  pushl $0
  1024be:	6a 00                	push   $0x0
  pushl $156
  1024c0:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024c5:	e9 a4 04 00 00       	jmp    10296e <__alltraps>

001024ca <vector157>:
.globl vector157
vector157:
  pushl $0
  1024ca:	6a 00                	push   $0x0
  pushl $157
  1024cc:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024d1:	e9 98 04 00 00       	jmp    10296e <__alltraps>

001024d6 <vector158>:
.globl vector158
vector158:
  pushl $0
  1024d6:	6a 00                	push   $0x0
  pushl $158
  1024d8:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024dd:	e9 8c 04 00 00       	jmp    10296e <__alltraps>

001024e2 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024e2:	6a 00                	push   $0x0
  pushl $159
  1024e4:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024e9:	e9 80 04 00 00       	jmp    10296e <__alltraps>

001024ee <vector160>:
.globl vector160
vector160:
  pushl $0
  1024ee:	6a 00                	push   $0x0
  pushl $160
  1024f0:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024f5:	e9 74 04 00 00       	jmp    10296e <__alltraps>

001024fa <vector161>:
.globl vector161
vector161:
  pushl $0
  1024fa:	6a 00                	push   $0x0
  pushl $161
  1024fc:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102501:	e9 68 04 00 00       	jmp    10296e <__alltraps>

00102506 <vector162>:
.globl vector162
vector162:
  pushl $0
  102506:	6a 00                	push   $0x0
  pushl $162
  102508:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10250d:	e9 5c 04 00 00       	jmp    10296e <__alltraps>

00102512 <vector163>:
.globl vector163
vector163:
  pushl $0
  102512:	6a 00                	push   $0x0
  pushl $163
  102514:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102519:	e9 50 04 00 00       	jmp    10296e <__alltraps>

0010251e <vector164>:
.globl vector164
vector164:
  pushl $0
  10251e:	6a 00                	push   $0x0
  pushl $164
  102520:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102525:	e9 44 04 00 00       	jmp    10296e <__alltraps>

0010252a <vector165>:
.globl vector165
vector165:
  pushl $0
  10252a:	6a 00                	push   $0x0
  pushl $165
  10252c:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102531:	e9 38 04 00 00       	jmp    10296e <__alltraps>

00102536 <vector166>:
.globl vector166
vector166:
  pushl $0
  102536:	6a 00                	push   $0x0
  pushl $166
  102538:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10253d:	e9 2c 04 00 00       	jmp    10296e <__alltraps>

00102542 <vector167>:
.globl vector167
vector167:
  pushl $0
  102542:	6a 00                	push   $0x0
  pushl $167
  102544:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102549:	e9 20 04 00 00       	jmp    10296e <__alltraps>

0010254e <vector168>:
.globl vector168
vector168:
  pushl $0
  10254e:	6a 00                	push   $0x0
  pushl $168
  102550:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102555:	e9 14 04 00 00       	jmp    10296e <__alltraps>

0010255a <vector169>:
.globl vector169
vector169:
  pushl $0
  10255a:	6a 00                	push   $0x0
  pushl $169
  10255c:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102561:	e9 08 04 00 00       	jmp    10296e <__alltraps>

00102566 <vector170>:
.globl vector170
vector170:
  pushl $0
  102566:	6a 00                	push   $0x0
  pushl $170
  102568:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10256d:	e9 fc 03 00 00       	jmp    10296e <__alltraps>

00102572 <vector171>:
.globl vector171
vector171:
  pushl $0
  102572:	6a 00                	push   $0x0
  pushl $171
  102574:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102579:	e9 f0 03 00 00       	jmp    10296e <__alltraps>

0010257e <vector172>:
.globl vector172
vector172:
  pushl $0
  10257e:	6a 00                	push   $0x0
  pushl $172
  102580:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102585:	e9 e4 03 00 00       	jmp    10296e <__alltraps>

0010258a <vector173>:
.globl vector173
vector173:
  pushl $0
  10258a:	6a 00                	push   $0x0
  pushl $173
  10258c:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102591:	e9 d8 03 00 00       	jmp    10296e <__alltraps>

00102596 <vector174>:
.globl vector174
vector174:
  pushl $0
  102596:	6a 00                	push   $0x0
  pushl $174
  102598:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10259d:	e9 cc 03 00 00       	jmp    10296e <__alltraps>

001025a2 <vector175>:
.globl vector175
vector175:
  pushl $0
  1025a2:	6a 00                	push   $0x0
  pushl $175
  1025a4:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025a9:	e9 c0 03 00 00       	jmp    10296e <__alltraps>

001025ae <vector176>:
.globl vector176
vector176:
  pushl $0
  1025ae:	6a 00                	push   $0x0
  pushl $176
  1025b0:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025b5:	e9 b4 03 00 00       	jmp    10296e <__alltraps>

001025ba <vector177>:
.globl vector177
vector177:
  pushl $0
  1025ba:	6a 00                	push   $0x0
  pushl $177
  1025bc:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025c1:	e9 a8 03 00 00       	jmp    10296e <__alltraps>

001025c6 <vector178>:
.globl vector178
vector178:
  pushl $0
  1025c6:	6a 00                	push   $0x0
  pushl $178
  1025c8:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025cd:	e9 9c 03 00 00       	jmp    10296e <__alltraps>

001025d2 <vector179>:
.globl vector179
vector179:
  pushl $0
  1025d2:	6a 00                	push   $0x0
  pushl $179
  1025d4:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025d9:	e9 90 03 00 00       	jmp    10296e <__alltraps>

001025de <vector180>:
.globl vector180
vector180:
  pushl $0
  1025de:	6a 00                	push   $0x0
  pushl $180
  1025e0:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025e5:	e9 84 03 00 00       	jmp    10296e <__alltraps>

001025ea <vector181>:
.globl vector181
vector181:
  pushl $0
  1025ea:	6a 00                	push   $0x0
  pushl $181
  1025ec:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025f1:	e9 78 03 00 00       	jmp    10296e <__alltraps>

001025f6 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025f6:	6a 00                	push   $0x0
  pushl $182
  1025f8:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025fd:	e9 6c 03 00 00       	jmp    10296e <__alltraps>

00102602 <vector183>:
.globl vector183
vector183:
  pushl $0
  102602:	6a 00                	push   $0x0
  pushl $183
  102604:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102609:	e9 60 03 00 00       	jmp    10296e <__alltraps>

0010260e <vector184>:
.globl vector184
vector184:
  pushl $0
  10260e:	6a 00                	push   $0x0
  pushl $184
  102610:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102615:	e9 54 03 00 00       	jmp    10296e <__alltraps>

0010261a <vector185>:
.globl vector185
vector185:
  pushl $0
  10261a:	6a 00                	push   $0x0
  pushl $185
  10261c:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102621:	e9 48 03 00 00       	jmp    10296e <__alltraps>

00102626 <vector186>:
.globl vector186
vector186:
  pushl $0
  102626:	6a 00                	push   $0x0
  pushl $186
  102628:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10262d:	e9 3c 03 00 00       	jmp    10296e <__alltraps>

00102632 <vector187>:
.globl vector187
vector187:
  pushl $0
  102632:	6a 00                	push   $0x0
  pushl $187
  102634:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102639:	e9 30 03 00 00       	jmp    10296e <__alltraps>

0010263e <vector188>:
.globl vector188
vector188:
  pushl $0
  10263e:	6a 00                	push   $0x0
  pushl $188
  102640:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102645:	e9 24 03 00 00       	jmp    10296e <__alltraps>

0010264a <vector189>:
.globl vector189
vector189:
  pushl $0
  10264a:	6a 00                	push   $0x0
  pushl $189
  10264c:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102651:	e9 18 03 00 00       	jmp    10296e <__alltraps>

00102656 <vector190>:
.globl vector190
vector190:
  pushl $0
  102656:	6a 00                	push   $0x0
  pushl $190
  102658:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10265d:	e9 0c 03 00 00       	jmp    10296e <__alltraps>

00102662 <vector191>:
.globl vector191
vector191:
  pushl $0
  102662:	6a 00                	push   $0x0
  pushl $191
  102664:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102669:	e9 00 03 00 00       	jmp    10296e <__alltraps>

0010266e <vector192>:
.globl vector192
vector192:
  pushl $0
  10266e:	6a 00                	push   $0x0
  pushl $192
  102670:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102675:	e9 f4 02 00 00       	jmp    10296e <__alltraps>

0010267a <vector193>:
.globl vector193
vector193:
  pushl $0
  10267a:	6a 00                	push   $0x0
  pushl $193
  10267c:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102681:	e9 e8 02 00 00       	jmp    10296e <__alltraps>

00102686 <vector194>:
.globl vector194
vector194:
  pushl $0
  102686:	6a 00                	push   $0x0
  pushl $194
  102688:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10268d:	e9 dc 02 00 00       	jmp    10296e <__alltraps>

00102692 <vector195>:
.globl vector195
vector195:
  pushl $0
  102692:	6a 00                	push   $0x0
  pushl $195
  102694:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102699:	e9 d0 02 00 00       	jmp    10296e <__alltraps>

0010269e <vector196>:
.globl vector196
vector196:
  pushl $0
  10269e:	6a 00                	push   $0x0
  pushl $196
  1026a0:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026a5:	e9 c4 02 00 00       	jmp    10296e <__alltraps>

001026aa <vector197>:
.globl vector197
vector197:
  pushl $0
  1026aa:	6a 00                	push   $0x0
  pushl $197
  1026ac:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026b1:	e9 b8 02 00 00       	jmp    10296e <__alltraps>

001026b6 <vector198>:
.globl vector198
vector198:
  pushl $0
  1026b6:	6a 00                	push   $0x0
  pushl $198
  1026b8:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026bd:	e9 ac 02 00 00       	jmp    10296e <__alltraps>

001026c2 <vector199>:
.globl vector199
vector199:
  pushl $0
  1026c2:	6a 00                	push   $0x0
  pushl $199
  1026c4:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026c9:	e9 a0 02 00 00       	jmp    10296e <__alltraps>

001026ce <vector200>:
.globl vector200
vector200:
  pushl $0
  1026ce:	6a 00                	push   $0x0
  pushl $200
  1026d0:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026d5:	e9 94 02 00 00       	jmp    10296e <__alltraps>

001026da <vector201>:
.globl vector201
vector201:
  pushl $0
  1026da:	6a 00                	push   $0x0
  pushl $201
  1026dc:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026e1:	e9 88 02 00 00       	jmp    10296e <__alltraps>

001026e6 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026e6:	6a 00                	push   $0x0
  pushl $202
  1026e8:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026ed:	e9 7c 02 00 00       	jmp    10296e <__alltraps>

001026f2 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026f2:	6a 00                	push   $0x0
  pushl $203
  1026f4:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026f9:	e9 70 02 00 00       	jmp    10296e <__alltraps>

001026fe <vector204>:
.globl vector204
vector204:
  pushl $0
  1026fe:	6a 00                	push   $0x0
  pushl $204
  102700:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102705:	e9 64 02 00 00       	jmp    10296e <__alltraps>

0010270a <vector205>:
.globl vector205
vector205:
  pushl $0
  10270a:	6a 00                	push   $0x0
  pushl $205
  10270c:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102711:	e9 58 02 00 00       	jmp    10296e <__alltraps>

00102716 <vector206>:
.globl vector206
vector206:
  pushl $0
  102716:	6a 00                	push   $0x0
  pushl $206
  102718:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10271d:	e9 4c 02 00 00       	jmp    10296e <__alltraps>

00102722 <vector207>:
.globl vector207
vector207:
  pushl $0
  102722:	6a 00                	push   $0x0
  pushl $207
  102724:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102729:	e9 40 02 00 00       	jmp    10296e <__alltraps>

0010272e <vector208>:
.globl vector208
vector208:
  pushl $0
  10272e:	6a 00                	push   $0x0
  pushl $208
  102730:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102735:	e9 34 02 00 00       	jmp    10296e <__alltraps>

0010273a <vector209>:
.globl vector209
vector209:
  pushl $0
  10273a:	6a 00                	push   $0x0
  pushl $209
  10273c:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102741:	e9 28 02 00 00       	jmp    10296e <__alltraps>

00102746 <vector210>:
.globl vector210
vector210:
  pushl $0
  102746:	6a 00                	push   $0x0
  pushl $210
  102748:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10274d:	e9 1c 02 00 00       	jmp    10296e <__alltraps>

00102752 <vector211>:
.globl vector211
vector211:
  pushl $0
  102752:	6a 00                	push   $0x0
  pushl $211
  102754:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102759:	e9 10 02 00 00       	jmp    10296e <__alltraps>

0010275e <vector212>:
.globl vector212
vector212:
  pushl $0
  10275e:	6a 00                	push   $0x0
  pushl $212
  102760:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102765:	e9 04 02 00 00       	jmp    10296e <__alltraps>

0010276a <vector213>:
.globl vector213
vector213:
  pushl $0
  10276a:	6a 00                	push   $0x0
  pushl $213
  10276c:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102771:	e9 f8 01 00 00       	jmp    10296e <__alltraps>

00102776 <vector214>:
.globl vector214
vector214:
  pushl $0
  102776:	6a 00                	push   $0x0
  pushl $214
  102778:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10277d:	e9 ec 01 00 00       	jmp    10296e <__alltraps>

00102782 <vector215>:
.globl vector215
vector215:
  pushl $0
  102782:	6a 00                	push   $0x0
  pushl $215
  102784:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102789:	e9 e0 01 00 00       	jmp    10296e <__alltraps>

0010278e <vector216>:
.globl vector216
vector216:
  pushl $0
  10278e:	6a 00                	push   $0x0
  pushl $216
  102790:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102795:	e9 d4 01 00 00       	jmp    10296e <__alltraps>

0010279a <vector217>:
.globl vector217
vector217:
  pushl $0
  10279a:	6a 00                	push   $0x0
  pushl $217
  10279c:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027a1:	e9 c8 01 00 00       	jmp    10296e <__alltraps>

001027a6 <vector218>:
.globl vector218
vector218:
  pushl $0
  1027a6:	6a 00                	push   $0x0
  pushl $218
  1027a8:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027ad:	e9 bc 01 00 00       	jmp    10296e <__alltraps>

001027b2 <vector219>:
.globl vector219
vector219:
  pushl $0
  1027b2:	6a 00                	push   $0x0
  pushl $219
  1027b4:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027b9:	e9 b0 01 00 00       	jmp    10296e <__alltraps>

001027be <vector220>:
.globl vector220
vector220:
  pushl $0
  1027be:	6a 00                	push   $0x0
  pushl $220
  1027c0:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027c5:	e9 a4 01 00 00       	jmp    10296e <__alltraps>

001027ca <vector221>:
.globl vector221
vector221:
  pushl $0
  1027ca:	6a 00                	push   $0x0
  pushl $221
  1027cc:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027d1:	e9 98 01 00 00       	jmp    10296e <__alltraps>

001027d6 <vector222>:
.globl vector222
vector222:
  pushl $0
  1027d6:	6a 00                	push   $0x0
  pushl $222
  1027d8:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027dd:	e9 8c 01 00 00       	jmp    10296e <__alltraps>

001027e2 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027e2:	6a 00                	push   $0x0
  pushl $223
  1027e4:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027e9:	e9 80 01 00 00       	jmp    10296e <__alltraps>

001027ee <vector224>:
.globl vector224
vector224:
  pushl $0
  1027ee:	6a 00                	push   $0x0
  pushl $224
  1027f0:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027f5:	e9 74 01 00 00       	jmp    10296e <__alltraps>

001027fa <vector225>:
.globl vector225
vector225:
  pushl $0
  1027fa:	6a 00                	push   $0x0
  pushl $225
  1027fc:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102801:	e9 68 01 00 00       	jmp    10296e <__alltraps>

00102806 <vector226>:
.globl vector226
vector226:
  pushl $0
  102806:	6a 00                	push   $0x0
  pushl $226
  102808:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10280d:	e9 5c 01 00 00       	jmp    10296e <__alltraps>

00102812 <vector227>:
.globl vector227
vector227:
  pushl $0
  102812:	6a 00                	push   $0x0
  pushl $227
  102814:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102819:	e9 50 01 00 00       	jmp    10296e <__alltraps>

0010281e <vector228>:
.globl vector228
vector228:
  pushl $0
  10281e:	6a 00                	push   $0x0
  pushl $228
  102820:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102825:	e9 44 01 00 00       	jmp    10296e <__alltraps>

0010282a <vector229>:
.globl vector229
vector229:
  pushl $0
  10282a:	6a 00                	push   $0x0
  pushl $229
  10282c:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102831:	e9 38 01 00 00       	jmp    10296e <__alltraps>

00102836 <vector230>:
.globl vector230
vector230:
  pushl $0
  102836:	6a 00                	push   $0x0
  pushl $230
  102838:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10283d:	e9 2c 01 00 00       	jmp    10296e <__alltraps>

00102842 <vector231>:
.globl vector231
vector231:
  pushl $0
  102842:	6a 00                	push   $0x0
  pushl $231
  102844:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102849:	e9 20 01 00 00       	jmp    10296e <__alltraps>

0010284e <vector232>:
.globl vector232
vector232:
  pushl $0
  10284e:	6a 00                	push   $0x0
  pushl $232
  102850:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102855:	e9 14 01 00 00       	jmp    10296e <__alltraps>

0010285a <vector233>:
.globl vector233
vector233:
  pushl $0
  10285a:	6a 00                	push   $0x0
  pushl $233
  10285c:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102861:	e9 08 01 00 00       	jmp    10296e <__alltraps>

00102866 <vector234>:
.globl vector234
vector234:
  pushl $0
  102866:	6a 00                	push   $0x0
  pushl $234
  102868:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10286d:	e9 fc 00 00 00       	jmp    10296e <__alltraps>

00102872 <vector235>:
.globl vector235
vector235:
  pushl $0
  102872:	6a 00                	push   $0x0
  pushl $235
  102874:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102879:	e9 f0 00 00 00       	jmp    10296e <__alltraps>

0010287e <vector236>:
.globl vector236
vector236:
  pushl $0
  10287e:	6a 00                	push   $0x0
  pushl $236
  102880:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102885:	e9 e4 00 00 00       	jmp    10296e <__alltraps>

0010288a <vector237>:
.globl vector237
vector237:
  pushl $0
  10288a:	6a 00                	push   $0x0
  pushl $237
  10288c:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102891:	e9 d8 00 00 00       	jmp    10296e <__alltraps>

00102896 <vector238>:
.globl vector238
vector238:
  pushl $0
  102896:	6a 00                	push   $0x0
  pushl $238
  102898:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10289d:	e9 cc 00 00 00       	jmp    10296e <__alltraps>

001028a2 <vector239>:
.globl vector239
vector239:
  pushl $0
  1028a2:	6a 00                	push   $0x0
  pushl $239
  1028a4:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028a9:	e9 c0 00 00 00       	jmp    10296e <__alltraps>

001028ae <vector240>:
.globl vector240
vector240:
  pushl $0
  1028ae:	6a 00                	push   $0x0
  pushl $240
  1028b0:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028b5:	e9 b4 00 00 00       	jmp    10296e <__alltraps>

001028ba <vector241>:
.globl vector241
vector241:
  pushl $0
  1028ba:	6a 00                	push   $0x0
  pushl $241
  1028bc:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028c1:	e9 a8 00 00 00       	jmp    10296e <__alltraps>

001028c6 <vector242>:
.globl vector242
vector242:
  pushl $0
  1028c6:	6a 00                	push   $0x0
  pushl $242
  1028c8:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028cd:	e9 9c 00 00 00       	jmp    10296e <__alltraps>

001028d2 <vector243>:
.globl vector243
vector243:
  pushl $0
  1028d2:	6a 00                	push   $0x0
  pushl $243
  1028d4:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028d9:	e9 90 00 00 00       	jmp    10296e <__alltraps>

001028de <vector244>:
.globl vector244
vector244:
  pushl $0
  1028de:	6a 00                	push   $0x0
  pushl $244
  1028e0:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028e5:	e9 84 00 00 00       	jmp    10296e <__alltraps>

001028ea <vector245>:
.globl vector245
vector245:
  pushl $0
  1028ea:	6a 00                	push   $0x0
  pushl $245
  1028ec:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028f1:	e9 78 00 00 00       	jmp    10296e <__alltraps>

001028f6 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028f6:	6a 00                	push   $0x0
  pushl $246
  1028f8:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028fd:	e9 6c 00 00 00       	jmp    10296e <__alltraps>

00102902 <vector247>:
.globl vector247
vector247:
  pushl $0
  102902:	6a 00                	push   $0x0
  pushl $247
  102904:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102909:	e9 60 00 00 00       	jmp    10296e <__alltraps>

0010290e <vector248>:
.globl vector248
vector248:
  pushl $0
  10290e:	6a 00                	push   $0x0
  pushl $248
  102910:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102915:	e9 54 00 00 00       	jmp    10296e <__alltraps>

0010291a <vector249>:
.globl vector249
vector249:
  pushl $0
  10291a:	6a 00                	push   $0x0
  pushl $249
  10291c:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102921:	e9 48 00 00 00       	jmp    10296e <__alltraps>

00102926 <vector250>:
.globl vector250
vector250:
  pushl $0
  102926:	6a 00                	push   $0x0
  pushl $250
  102928:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10292d:	e9 3c 00 00 00       	jmp    10296e <__alltraps>

00102932 <vector251>:
.globl vector251
vector251:
  pushl $0
  102932:	6a 00                	push   $0x0
  pushl $251
  102934:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102939:	e9 30 00 00 00       	jmp    10296e <__alltraps>

0010293e <vector252>:
.globl vector252
vector252:
  pushl $0
  10293e:	6a 00                	push   $0x0
  pushl $252
  102940:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102945:	e9 24 00 00 00       	jmp    10296e <__alltraps>

0010294a <vector253>:
.globl vector253
vector253:
  pushl $0
  10294a:	6a 00                	push   $0x0
  pushl $253
  10294c:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102951:	e9 18 00 00 00       	jmp    10296e <__alltraps>

00102956 <vector254>:
.globl vector254
vector254:
  pushl $0
  102956:	6a 00                	push   $0x0
  pushl $254
  102958:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10295d:	e9 0c 00 00 00       	jmp    10296e <__alltraps>

00102962 <vector255>:
.globl vector255
vector255:
  pushl $0
  102962:	6a 00                	push   $0x0
  pushl $255
  102964:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102969:	e9 00 00 00 00       	jmp    10296e <__alltraps>

0010296e <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10296e:	1e                   	push   %ds
    pushl %es
  10296f:	06                   	push   %es
    pushl %fs
  102970:	0f a0                	push   %fs
    pushl %gs
  102972:	0f a8                	push   %gs
    pushal
  102974:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102975:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10297a:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10297c:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10297e:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10297f:	e8 61 f5 ff ff       	call   101ee5 <trap>

    # pop the pushed stack pointer
    popl %esp
  102984:	5c                   	pop    %esp

00102985 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102985:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102986:	0f a9                	pop    %gs
    popl %fs
  102988:	0f a1                	pop    %fs
    popl %es
  10298a:	07                   	pop    %es
    popl %ds
  10298b:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10298c:	83 c4 08             	add    $0x8,%esp
    iret
  10298f:	cf                   	iret   

00102990 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102990:	55                   	push   %ebp
  102991:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102993:	8b 45 08             	mov    0x8(%ebp),%eax
  102996:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102999:	b8 23 00 00 00       	mov    $0x23,%eax
  10299e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1029a0:	b8 23 00 00 00       	mov    $0x23,%eax
  1029a5:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1029a7:	b8 10 00 00 00       	mov    $0x10,%eax
  1029ac:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1029ae:	b8 10 00 00 00       	mov    $0x10,%eax
  1029b3:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1029b5:	b8 10 00 00 00       	mov    $0x10,%eax
  1029ba:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1029bc:	ea c3 29 10 00 08 00 	ljmp   $0x8,$0x1029c3
}
  1029c3:	90                   	nop
  1029c4:	5d                   	pop    %ebp
  1029c5:	c3                   	ret    

001029c6 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1029c6:	55                   	push   %ebp
  1029c7:	89 e5                	mov    %esp,%ebp
  1029c9:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1029cc:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  1029d1:	05 00 04 00 00       	add    $0x400,%eax
  1029d6:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1029db:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1029e2:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1029e4:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1029eb:	68 00 
  1029ed:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029f2:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1029f8:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029fd:	c1 e8 10             	shr    $0x10,%eax
  102a00:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102a05:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a0c:	83 e0 f0             	and    $0xfffffff0,%eax
  102a0f:	83 c8 09             	or     $0x9,%eax
  102a12:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a17:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a1e:	83 c8 10             	or     $0x10,%eax
  102a21:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a26:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a2d:	83 e0 9f             	and    $0xffffff9f,%eax
  102a30:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a35:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a3c:	83 c8 80             	or     $0xffffff80,%eax
  102a3f:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a44:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a4b:	83 e0 f0             	and    $0xfffffff0,%eax
  102a4e:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a53:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a5a:	83 e0 ef             	and    $0xffffffef,%eax
  102a5d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a62:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a69:	83 e0 df             	and    $0xffffffdf,%eax
  102a6c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a71:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a78:	83 c8 40             	or     $0x40,%eax
  102a7b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a80:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a87:	83 e0 7f             	and    $0x7f,%eax
  102a8a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a8f:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a94:	c1 e8 18             	shr    $0x18,%eax
  102a97:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a9c:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102aa3:	83 e0 ef             	and    $0xffffffef,%eax
  102aa6:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102aab:	68 10 ea 10 00       	push   $0x10ea10
  102ab0:	e8 db fe ff ff       	call   102990 <lgdt>
  102ab5:	83 c4 04             	add    $0x4,%esp
  102ab8:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102abe:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102ac2:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102ac5:	90                   	nop
  102ac6:	c9                   	leave  
  102ac7:	c3                   	ret    

00102ac8 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102ac8:	55                   	push   %ebp
  102ac9:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102acb:	e8 f6 fe ff ff       	call   1029c6 <gdt_init>
}
  102ad0:	90                   	nop
  102ad1:	5d                   	pop    %ebp
  102ad2:	c3                   	ret    

00102ad3 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102ad3:	55                   	push   %ebp
  102ad4:	89 e5                	mov    %esp,%ebp
  102ad6:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ad9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102ae0:	eb 04                	jmp    102ae6 <strlen+0x13>
        cnt ++;
  102ae2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae9:	8d 50 01             	lea    0x1(%eax),%edx
  102aec:	89 55 08             	mov    %edx,0x8(%ebp)
  102aef:	0f b6 00             	movzbl (%eax),%eax
  102af2:	84 c0                	test   %al,%al
  102af4:	75 ec                	jne    102ae2 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102af6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102af9:	c9                   	leave  
  102afa:	c3                   	ret    

00102afb <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102afb:	55                   	push   %ebp
  102afc:	89 e5                	mov    %esp,%ebp
  102afe:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102b01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102b08:	eb 04                	jmp    102b0e <strnlen+0x13>
        cnt ++;
  102b0a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102b0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b11:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102b14:	73 10                	jae    102b26 <strnlen+0x2b>
  102b16:	8b 45 08             	mov    0x8(%ebp),%eax
  102b19:	8d 50 01             	lea    0x1(%eax),%edx
  102b1c:	89 55 08             	mov    %edx,0x8(%ebp)
  102b1f:	0f b6 00             	movzbl (%eax),%eax
  102b22:	84 c0                	test   %al,%al
  102b24:	75 e4                	jne    102b0a <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102b26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102b29:	c9                   	leave  
  102b2a:	c3                   	ret    

00102b2b <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102b2b:	55                   	push   %ebp
  102b2c:	89 e5                	mov    %esp,%ebp
  102b2e:	57                   	push   %edi
  102b2f:	56                   	push   %esi
  102b30:	83 ec 20             	sub    $0x20,%esp
  102b33:	8b 45 08             	mov    0x8(%ebp),%eax
  102b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102b3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b45:	89 d1                	mov    %edx,%ecx
  102b47:	89 c2                	mov    %eax,%edx
  102b49:	89 ce                	mov    %ecx,%esi
  102b4b:	89 d7                	mov    %edx,%edi
  102b4d:	ac                   	lods   %ds:(%esi),%al
  102b4e:	aa                   	stos   %al,%es:(%edi)
  102b4f:	84 c0                	test   %al,%al
  102b51:	75 fa                	jne    102b4d <strcpy+0x22>
  102b53:	89 fa                	mov    %edi,%edx
  102b55:	89 f1                	mov    %esi,%ecx
  102b57:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102b5a:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102b5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102b63:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102b64:	83 c4 20             	add    $0x20,%esp
  102b67:	5e                   	pop    %esi
  102b68:	5f                   	pop    %edi
  102b69:	5d                   	pop    %ebp
  102b6a:	c3                   	ret    

00102b6b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102b6b:	55                   	push   %ebp
  102b6c:	89 e5                	mov    %esp,%ebp
  102b6e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102b71:	8b 45 08             	mov    0x8(%ebp),%eax
  102b74:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102b77:	eb 21                	jmp    102b9a <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b7c:	0f b6 10             	movzbl (%eax),%edx
  102b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b82:	88 10                	mov    %dl,(%eax)
  102b84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b87:	0f b6 00             	movzbl (%eax),%eax
  102b8a:	84 c0                	test   %al,%al
  102b8c:	74 04                	je     102b92 <strncpy+0x27>
            src ++;
  102b8e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102b92:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102b96:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  102b9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b9e:	75 d9                	jne    102b79 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  102ba0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102ba3:	c9                   	leave  
  102ba4:	c3                   	ret    

00102ba5 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102ba5:	55                   	push   %ebp
  102ba6:	89 e5                	mov    %esp,%ebp
  102ba8:	57                   	push   %edi
  102ba9:	56                   	push   %esi
  102baa:	83 ec 20             	sub    $0x20,%esp
  102bad:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bbf:	89 d1                	mov    %edx,%ecx
  102bc1:	89 c2                	mov    %eax,%edx
  102bc3:	89 ce                	mov    %ecx,%esi
  102bc5:	89 d7                	mov    %edx,%edi
  102bc7:	ac                   	lods   %ds:(%esi),%al
  102bc8:	ae                   	scas   %es:(%edi),%al
  102bc9:	75 08                	jne    102bd3 <strcmp+0x2e>
  102bcb:	84 c0                	test   %al,%al
  102bcd:	75 f8                	jne    102bc7 <strcmp+0x22>
  102bcf:	31 c0                	xor    %eax,%eax
  102bd1:	eb 04                	jmp    102bd7 <strcmp+0x32>
  102bd3:	19 c0                	sbb    %eax,%eax
  102bd5:	0c 01                	or     $0x1,%al
  102bd7:	89 fa                	mov    %edi,%edx
  102bd9:	89 f1                	mov    %esi,%ecx
  102bdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102bde:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102be1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  102be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102be7:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102be8:	83 c4 20             	add    $0x20,%esp
  102beb:	5e                   	pop    %esi
  102bec:	5f                   	pop    %edi
  102bed:	5d                   	pop    %ebp
  102bee:	c3                   	ret    

00102bef <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102bef:	55                   	push   %ebp
  102bf0:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102bf2:	eb 0c                	jmp    102c00 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102bf4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102bf8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102bfc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102c00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c04:	74 1a                	je     102c20 <strncmp+0x31>
  102c06:	8b 45 08             	mov    0x8(%ebp),%eax
  102c09:	0f b6 00             	movzbl (%eax),%eax
  102c0c:	84 c0                	test   %al,%al
  102c0e:	74 10                	je     102c20 <strncmp+0x31>
  102c10:	8b 45 08             	mov    0x8(%ebp),%eax
  102c13:	0f b6 10             	movzbl (%eax),%edx
  102c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c19:	0f b6 00             	movzbl (%eax),%eax
  102c1c:	38 c2                	cmp    %al,%dl
  102c1e:	74 d4                	je     102bf4 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102c20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c24:	74 18                	je     102c3e <strncmp+0x4f>
  102c26:	8b 45 08             	mov    0x8(%ebp),%eax
  102c29:	0f b6 00             	movzbl (%eax),%eax
  102c2c:	0f b6 d0             	movzbl %al,%edx
  102c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c32:	0f b6 00             	movzbl (%eax),%eax
  102c35:	0f b6 c0             	movzbl %al,%eax
  102c38:	29 c2                	sub    %eax,%edx
  102c3a:	89 d0                	mov    %edx,%eax
  102c3c:	eb 05                	jmp    102c43 <strncmp+0x54>
  102c3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c43:	5d                   	pop    %ebp
  102c44:	c3                   	ret    

00102c45 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102c45:	55                   	push   %ebp
  102c46:	89 e5                	mov    %esp,%ebp
  102c48:	83 ec 04             	sub    $0x4,%esp
  102c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c4e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102c51:	eb 14                	jmp    102c67 <strchr+0x22>
        if (*s == c) {
  102c53:	8b 45 08             	mov    0x8(%ebp),%eax
  102c56:	0f b6 00             	movzbl (%eax),%eax
  102c59:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102c5c:	75 05                	jne    102c63 <strchr+0x1e>
            return (char *)s;
  102c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c61:	eb 13                	jmp    102c76 <strchr+0x31>
        }
        s ++;
  102c63:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102c67:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6a:	0f b6 00             	movzbl (%eax),%eax
  102c6d:	84 c0                	test   %al,%al
  102c6f:	75 e2                	jne    102c53 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102c71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c76:	c9                   	leave  
  102c77:	c3                   	ret    

00102c78 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102c78:	55                   	push   %ebp
  102c79:	89 e5                	mov    %esp,%ebp
  102c7b:	83 ec 04             	sub    $0x4,%esp
  102c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c81:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102c84:	eb 0f                	jmp    102c95 <strfind+0x1d>
        if (*s == c) {
  102c86:	8b 45 08             	mov    0x8(%ebp),%eax
  102c89:	0f b6 00             	movzbl (%eax),%eax
  102c8c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102c8f:	74 10                	je     102ca1 <strfind+0x29>
            break;
        }
        s ++;
  102c91:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102c95:	8b 45 08             	mov    0x8(%ebp),%eax
  102c98:	0f b6 00             	movzbl (%eax),%eax
  102c9b:	84 c0                	test   %al,%al
  102c9d:	75 e7                	jne    102c86 <strfind+0xe>
  102c9f:	eb 01                	jmp    102ca2 <strfind+0x2a>
        if (*s == c) {
            break;
  102ca1:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  102ca2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102ca5:	c9                   	leave  
  102ca6:	c3                   	ret    

00102ca7 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102ca7:	55                   	push   %ebp
  102ca8:	89 e5                	mov    %esp,%ebp
  102caa:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102cad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102cb4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102cbb:	eb 04                	jmp    102cc1 <strtol+0x1a>
        s ++;
  102cbd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc4:	0f b6 00             	movzbl (%eax),%eax
  102cc7:	3c 20                	cmp    $0x20,%al
  102cc9:	74 f2                	je     102cbd <strtol+0x16>
  102ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  102cce:	0f b6 00             	movzbl (%eax),%eax
  102cd1:	3c 09                	cmp    $0x9,%al
  102cd3:	74 e8                	je     102cbd <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  102cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd8:	0f b6 00             	movzbl (%eax),%eax
  102cdb:	3c 2b                	cmp    $0x2b,%al
  102cdd:	75 06                	jne    102ce5 <strtol+0x3e>
        s ++;
  102cdf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ce3:	eb 15                	jmp    102cfa <strtol+0x53>
    }
    else if (*s == '-') {
  102ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce8:	0f b6 00             	movzbl (%eax),%eax
  102ceb:	3c 2d                	cmp    $0x2d,%al
  102ced:	75 0b                	jne    102cfa <strtol+0x53>
        s ++, neg = 1;
  102cef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102cf3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102cfa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cfe:	74 06                	je     102d06 <strtol+0x5f>
  102d00:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102d04:	75 24                	jne    102d2a <strtol+0x83>
  102d06:	8b 45 08             	mov    0x8(%ebp),%eax
  102d09:	0f b6 00             	movzbl (%eax),%eax
  102d0c:	3c 30                	cmp    $0x30,%al
  102d0e:	75 1a                	jne    102d2a <strtol+0x83>
  102d10:	8b 45 08             	mov    0x8(%ebp),%eax
  102d13:	83 c0 01             	add    $0x1,%eax
  102d16:	0f b6 00             	movzbl (%eax),%eax
  102d19:	3c 78                	cmp    $0x78,%al
  102d1b:	75 0d                	jne    102d2a <strtol+0x83>
        s += 2, base = 16;
  102d1d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102d21:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102d28:	eb 2a                	jmp    102d54 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102d2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d2e:	75 17                	jne    102d47 <strtol+0xa0>
  102d30:	8b 45 08             	mov    0x8(%ebp),%eax
  102d33:	0f b6 00             	movzbl (%eax),%eax
  102d36:	3c 30                	cmp    $0x30,%al
  102d38:	75 0d                	jne    102d47 <strtol+0xa0>
        s ++, base = 8;
  102d3a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d3e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102d45:	eb 0d                	jmp    102d54 <strtol+0xad>
    }
    else if (base == 0) {
  102d47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d4b:	75 07                	jne    102d54 <strtol+0xad>
        base = 10;
  102d4d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102d54:	8b 45 08             	mov    0x8(%ebp),%eax
  102d57:	0f b6 00             	movzbl (%eax),%eax
  102d5a:	3c 2f                	cmp    $0x2f,%al
  102d5c:	7e 1b                	jle    102d79 <strtol+0xd2>
  102d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d61:	0f b6 00             	movzbl (%eax),%eax
  102d64:	3c 39                	cmp    $0x39,%al
  102d66:	7f 11                	jg     102d79 <strtol+0xd2>
            dig = *s - '0';
  102d68:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6b:	0f b6 00             	movzbl (%eax),%eax
  102d6e:	0f be c0             	movsbl %al,%eax
  102d71:	83 e8 30             	sub    $0x30,%eax
  102d74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d77:	eb 48                	jmp    102dc1 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102d79:	8b 45 08             	mov    0x8(%ebp),%eax
  102d7c:	0f b6 00             	movzbl (%eax),%eax
  102d7f:	3c 60                	cmp    $0x60,%al
  102d81:	7e 1b                	jle    102d9e <strtol+0xf7>
  102d83:	8b 45 08             	mov    0x8(%ebp),%eax
  102d86:	0f b6 00             	movzbl (%eax),%eax
  102d89:	3c 7a                	cmp    $0x7a,%al
  102d8b:	7f 11                	jg     102d9e <strtol+0xf7>
            dig = *s - 'a' + 10;
  102d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d90:	0f b6 00             	movzbl (%eax),%eax
  102d93:	0f be c0             	movsbl %al,%eax
  102d96:	83 e8 57             	sub    $0x57,%eax
  102d99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d9c:	eb 23                	jmp    102dc1 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102da1:	0f b6 00             	movzbl (%eax),%eax
  102da4:	3c 40                	cmp    $0x40,%al
  102da6:	7e 3c                	jle    102de4 <strtol+0x13d>
  102da8:	8b 45 08             	mov    0x8(%ebp),%eax
  102dab:	0f b6 00             	movzbl (%eax),%eax
  102dae:	3c 5a                	cmp    $0x5a,%al
  102db0:	7f 32                	jg     102de4 <strtol+0x13d>
            dig = *s - 'A' + 10;
  102db2:	8b 45 08             	mov    0x8(%ebp),%eax
  102db5:	0f b6 00             	movzbl (%eax),%eax
  102db8:	0f be c0             	movsbl %al,%eax
  102dbb:	83 e8 37             	sub    $0x37,%eax
  102dbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dc4:	3b 45 10             	cmp    0x10(%ebp),%eax
  102dc7:	7d 1a                	jge    102de3 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102dc9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102dcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102dd0:	0f af 45 10          	imul   0x10(%ebp),%eax
  102dd4:	89 c2                	mov    %eax,%edx
  102dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dd9:	01 d0                	add    %edx,%eax
  102ddb:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102dde:	e9 71 ff ff ff       	jmp    102d54 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  102de3:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  102de4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102de8:	74 08                	je     102df2 <strtol+0x14b>
        *endptr = (char *) s;
  102dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ded:	8b 55 08             	mov    0x8(%ebp),%edx
  102df0:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102df2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102df6:	74 07                	je     102dff <strtol+0x158>
  102df8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102dfb:	f7 d8                	neg    %eax
  102dfd:	eb 03                	jmp    102e02 <strtol+0x15b>
  102dff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102e02:	c9                   	leave  
  102e03:	c3                   	ret    

00102e04 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102e04:	55                   	push   %ebp
  102e05:	89 e5                	mov    %esp,%ebp
  102e07:	57                   	push   %edi
  102e08:	83 ec 24             	sub    $0x24,%esp
  102e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e0e:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102e11:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102e15:	8b 55 08             	mov    0x8(%ebp),%edx
  102e18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102e1b:	88 45 f7             	mov    %al,-0x9(%ebp)
  102e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  102e21:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102e24:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102e27:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102e2b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102e2e:	89 d7                	mov    %edx,%edi
  102e30:	f3 aa                	rep stos %al,%es:(%edi)
  102e32:	89 fa                	mov    %edi,%edx
  102e34:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102e37:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102e3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e3d:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102e3e:	83 c4 24             	add    $0x24,%esp
  102e41:	5f                   	pop    %edi
  102e42:	5d                   	pop    %ebp
  102e43:	c3                   	ret    

00102e44 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102e44:	55                   	push   %ebp
  102e45:	89 e5                	mov    %esp,%ebp
  102e47:	57                   	push   %edi
  102e48:	56                   	push   %esi
  102e49:	53                   	push   %ebx
  102e4a:	83 ec 30             	sub    $0x30,%esp
  102e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e59:	8b 45 10             	mov    0x10(%ebp),%eax
  102e5c:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e62:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102e65:	73 42                	jae    102ea9 <memmove+0x65>
  102e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e70:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e76:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102e79:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e7c:	c1 e8 02             	shr    $0x2,%eax
  102e7f:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102e81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e87:	89 d7                	mov    %edx,%edi
  102e89:	89 c6                	mov    %eax,%esi
  102e8b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102e8d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102e90:	83 e1 03             	and    $0x3,%ecx
  102e93:	74 02                	je     102e97 <memmove+0x53>
  102e95:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e97:	89 f0                	mov    %esi,%eax
  102e99:	89 fa                	mov    %edi,%edx
  102e9b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102e9e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102ea1:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102ea4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102ea7:	eb 36                	jmp    102edf <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102ea9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102eac:	8d 50 ff             	lea    -0x1(%eax),%edx
  102eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102eb2:	01 c2                	add    %eax,%edx
  102eb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102eb7:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ebd:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  102ec0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ec3:	89 c1                	mov    %eax,%ecx
  102ec5:	89 d8                	mov    %ebx,%eax
  102ec7:	89 d6                	mov    %edx,%esi
  102ec9:	89 c7                	mov    %eax,%edi
  102ecb:	fd                   	std    
  102ecc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ece:	fc                   	cld    
  102ecf:	89 f8                	mov    %edi,%eax
  102ed1:	89 f2                	mov    %esi,%edx
  102ed3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102ed6:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102ed9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  102edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102edf:	83 c4 30             	add    $0x30,%esp
  102ee2:	5b                   	pop    %ebx
  102ee3:	5e                   	pop    %esi
  102ee4:	5f                   	pop    %edi
  102ee5:	5d                   	pop    %ebp
  102ee6:	c3                   	ret    

00102ee7 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102ee7:	55                   	push   %ebp
  102ee8:	89 e5                	mov    %esp,%ebp
  102eea:	57                   	push   %edi
  102eeb:	56                   	push   %esi
  102eec:	83 ec 20             	sub    $0x20,%esp
  102eef:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102efb:	8b 45 10             	mov    0x10(%ebp),%eax
  102efe:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102f01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f04:	c1 e8 02             	shr    $0x2,%eax
  102f07:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f0f:	89 d7                	mov    %edx,%edi
  102f11:	89 c6                	mov    %eax,%esi
  102f13:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102f15:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102f18:	83 e1 03             	and    $0x3,%ecx
  102f1b:	74 02                	je     102f1f <memcpy+0x38>
  102f1d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102f1f:	89 f0                	mov    %esi,%eax
  102f21:	89 fa                	mov    %edi,%edx
  102f23:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102f26:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102f29:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102f2f:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102f30:	83 c4 20             	add    $0x20,%esp
  102f33:	5e                   	pop    %esi
  102f34:	5f                   	pop    %edi
  102f35:	5d                   	pop    %ebp
  102f36:	c3                   	ret    

00102f37 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102f37:	55                   	push   %ebp
  102f38:	89 e5                	mov    %esp,%ebp
  102f3a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f40:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f46:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102f49:	eb 30                	jmp    102f7b <memcmp+0x44>
        if (*s1 != *s2) {
  102f4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f4e:	0f b6 10             	movzbl (%eax),%edx
  102f51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f54:	0f b6 00             	movzbl (%eax),%eax
  102f57:	38 c2                	cmp    %al,%dl
  102f59:	74 18                	je     102f73 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f5e:	0f b6 00             	movzbl (%eax),%eax
  102f61:	0f b6 d0             	movzbl %al,%edx
  102f64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f67:	0f b6 00             	movzbl (%eax),%eax
  102f6a:	0f b6 c0             	movzbl %al,%eax
  102f6d:	29 c2                	sub    %eax,%edx
  102f6f:	89 d0                	mov    %edx,%eax
  102f71:	eb 1a                	jmp    102f8d <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102f73:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102f77:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  102f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  102f7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f81:	89 55 10             	mov    %edx,0x10(%ebp)
  102f84:	85 c0                	test   %eax,%eax
  102f86:	75 c3                	jne    102f4b <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  102f88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f8d:	c9                   	leave  
  102f8e:	c3                   	ret    

00102f8f <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102f8f:	55                   	push   %ebp
  102f90:	89 e5                	mov    %esp,%ebp
  102f92:	83 ec 38             	sub    $0x38,%esp
  102f95:	8b 45 10             	mov    0x10(%ebp),%eax
  102f98:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f9b:	8b 45 14             	mov    0x14(%ebp),%eax
  102f9e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102fa1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102fa4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102fa7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102faa:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102fad:	8b 45 18             	mov    0x18(%ebp),%eax
  102fb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102fb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fb6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102fb9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102fbc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102fc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102fc9:	74 1c                	je     102fe7 <printnum+0x58>
  102fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fce:	ba 00 00 00 00       	mov    $0x0,%edx
  102fd3:	f7 75 e4             	divl   -0x1c(%ebp)
  102fd6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fdc:	ba 00 00 00 00       	mov    $0x0,%edx
  102fe1:	f7 75 e4             	divl   -0x1c(%ebp)
  102fe4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fe7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fed:	f7 75 e4             	divl   -0x1c(%ebp)
  102ff0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ff3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102ff6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ff9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ffc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102fff:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103002:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103005:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  103008:	8b 45 18             	mov    0x18(%ebp),%eax
  10300b:	ba 00 00 00 00       	mov    $0x0,%edx
  103010:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103013:	77 41                	ja     103056 <printnum+0xc7>
  103015:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103018:	72 05                	jb     10301f <printnum+0x90>
  10301a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10301d:	77 37                	ja     103056 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  10301f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103022:	83 e8 01             	sub    $0x1,%eax
  103025:	83 ec 04             	sub    $0x4,%esp
  103028:	ff 75 20             	pushl  0x20(%ebp)
  10302b:	50                   	push   %eax
  10302c:	ff 75 18             	pushl  0x18(%ebp)
  10302f:	ff 75 ec             	pushl  -0x14(%ebp)
  103032:	ff 75 e8             	pushl  -0x18(%ebp)
  103035:	ff 75 0c             	pushl  0xc(%ebp)
  103038:	ff 75 08             	pushl  0x8(%ebp)
  10303b:	e8 4f ff ff ff       	call   102f8f <printnum>
  103040:	83 c4 20             	add    $0x20,%esp
  103043:	eb 1b                	jmp    103060 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  103045:	83 ec 08             	sub    $0x8,%esp
  103048:	ff 75 0c             	pushl  0xc(%ebp)
  10304b:	ff 75 20             	pushl  0x20(%ebp)
  10304e:	8b 45 08             	mov    0x8(%ebp),%eax
  103051:	ff d0                	call   *%eax
  103053:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  103056:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10305a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10305e:	7f e5                	jg     103045 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103060:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103063:	05 b0 3d 10 00       	add    $0x103db0,%eax
  103068:	0f b6 00             	movzbl (%eax),%eax
  10306b:	0f be c0             	movsbl %al,%eax
  10306e:	83 ec 08             	sub    $0x8,%esp
  103071:	ff 75 0c             	pushl  0xc(%ebp)
  103074:	50                   	push   %eax
  103075:	8b 45 08             	mov    0x8(%ebp),%eax
  103078:	ff d0                	call   *%eax
  10307a:	83 c4 10             	add    $0x10,%esp
}
  10307d:	90                   	nop
  10307e:	c9                   	leave  
  10307f:	c3                   	ret    

00103080 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103080:	55                   	push   %ebp
  103081:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103083:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103087:	7e 14                	jle    10309d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  103089:	8b 45 08             	mov    0x8(%ebp),%eax
  10308c:	8b 00                	mov    (%eax),%eax
  10308e:	8d 48 08             	lea    0x8(%eax),%ecx
  103091:	8b 55 08             	mov    0x8(%ebp),%edx
  103094:	89 0a                	mov    %ecx,(%edx)
  103096:	8b 50 04             	mov    0x4(%eax),%edx
  103099:	8b 00                	mov    (%eax),%eax
  10309b:	eb 30                	jmp    1030cd <getuint+0x4d>
    }
    else if (lflag) {
  10309d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1030a1:	74 16                	je     1030b9 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a6:	8b 00                	mov    (%eax),%eax
  1030a8:	8d 48 04             	lea    0x4(%eax),%ecx
  1030ab:	8b 55 08             	mov    0x8(%ebp),%edx
  1030ae:	89 0a                	mov    %ecx,(%edx)
  1030b0:	8b 00                	mov    (%eax),%eax
  1030b2:	ba 00 00 00 00       	mov    $0x0,%edx
  1030b7:	eb 14                	jmp    1030cd <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1030bc:	8b 00                	mov    (%eax),%eax
  1030be:	8d 48 04             	lea    0x4(%eax),%ecx
  1030c1:	8b 55 08             	mov    0x8(%ebp),%edx
  1030c4:	89 0a                	mov    %ecx,(%edx)
  1030c6:	8b 00                	mov    (%eax),%eax
  1030c8:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1030cd:	5d                   	pop    %ebp
  1030ce:	c3                   	ret    

001030cf <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1030cf:	55                   	push   %ebp
  1030d0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1030d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1030d6:	7e 14                	jle    1030ec <getint+0x1d>
        return va_arg(*ap, long long);
  1030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1030db:	8b 00                	mov    (%eax),%eax
  1030dd:	8d 48 08             	lea    0x8(%eax),%ecx
  1030e0:	8b 55 08             	mov    0x8(%ebp),%edx
  1030e3:	89 0a                	mov    %ecx,(%edx)
  1030e5:	8b 50 04             	mov    0x4(%eax),%edx
  1030e8:	8b 00                	mov    (%eax),%eax
  1030ea:	eb 28                	jmp    103114 <getint+0x45>
    }
    else if (lflag) {
  1030ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1030f0:	74 12                	je     103104 <getint+0x35>
        return va_arg(*ap, long);
  1030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f5:	8b 00                	mov    (%eax),%eax
  1030f7:	8d 48 04             	lea    0x4(%eax),%ecx
  1030fa:	8b 55 08             	mov    0x8(%ebp),%edx
  1030fd:	89 0a                	mov    %ecx,(%edx)
  1030ff:	8b 00                	mov    (%eax),%eax
  103101:	99                   	cltd   
  103102:	eb 10                	jmp    103114 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  103104:	8b 45 08             	mov    0x8(%ebp),%eax
  103107:	8b 00                	mov    (%eax),%eax
  103109:	8d 48 04             	lea    0x4(%eax),%ecx
  10310c:	8b 55 08             	mov    0x8(%ebp),%edx
  10310f:	89 0a                	mov    %ecx,(%edx)
  103111:	8b 00                	mov    (%eax),%eax
  103113:	99                   	cltd   
    }
}
  103114:	5d                   	pop    %ebp
  103115:	c3                   	ret    

00103116 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  103116:	55                   	push   %ebp
  103117:	89 e5                	mov    %esp,%ebp
  103119:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  10311c:	8d 45 14             	lea    0x14(%ebp),%eax
  10311f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  103122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103125:	50                   	push   %eax
  103126:	ff 75 10             	pushl  0x10(%ebp)
  103129:	ff 75 0c             	pushl  0xc(%ebp)
  10312c:	ff 75 08             	pushl  0x8(%ebp)
  10312f:	e8 06 00 00 00       	call   10313a <vprintfmt>
  103134:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  103137:	90                   	nop
  103138:	c9                   	leave  
  103139:	c3                   	ret    

0010313a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10313a:	55                   	push   %ebp
  10313b:	89 e5                	mov    %esp,%ebp
  10313d:	56                   	push   %esi
  10313e:	53                   	push   %ebx
  10313f:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103142:	eb 17                	jmp    10315b <vprintfmt+0x21>
            if (ch == '\0') {
  103144:	85 db                	test   %ebx,%ebx
  103146:	0f 84 8e 03 00 00    	je     1034da <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  10314c:	83 ec 08             	sub    $0x8,%esp
  10314f:	ff 75 0c             	pushl  0xc(%ebp)
  103152:	53                   	push   %ebx
  103153:	8b 45 08             	mov    0x8(%ebp),%eax
  103156:	ff d0                	call   *%eax
  103158:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10315b:	8b 45 10             	mov    0x10(%ebp),%eax
  10315e:	8d 50 01             	lea    0x1(%eax),%edx
  103161:	89 55 10             	mov    %edx,0x10(%ebp)
  103164:	0f b6 00             	movzbl (%eax),%eax
  103167:	0f b6 d8             	movzbl %al,%ebx
  10316a:	83 fb 25             	cmp    $0x25,%ebx
  10316d:	75 d5                	jne    103144 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  10316f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103173:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10317a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10317d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103180:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103187:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10318a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10318d:	8b 45 10             	mov    0x10(%ebp),%eax
  103190:	8d 50 01             	lea    0x1(%eax),%edx
  103193:	89 55 10             	mov    %edx,0x10(%ebp)
  103196:	0f b6 00             	movzbl (%eax),%eax
  103199:	0f b6 d8             	movzbl %al,%ebx
  10319c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10319f:	83 f8 55             	cmp    $0x55,%eax
  1031a2:	0f 87 05 03 00 00    	ja     1034ad <vprintfmt+0x373>
  1031a8:	8b 04 85 d4 3d 10 00 	mov    0x103dd4(,%eax,4),%eax
  1031af:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1031b1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1031b5:	eb d6                	jmp    10318d <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1031b7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1031bb:	eb d0                	jmp    10318d <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1031bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1031c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1031c7:	89 d0                	mov    %edx,%eax
  1031c9:	c1 e0 02             	shl    $0x2,%eax
  1031cc:	01 d0                	add    %edx,%eax
  1031ce:	01 c0                	add    %eax,%eax
  1031d0:	01 d8                	add    %ebx,%eax
  1031d2:	83 e8 30             	sub    $0x30,%eax
  1031d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1031d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1031db:	0f b6 00             	movzbl (%eax),%eax
  1031de:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1031e1:	83 fb 2f             	cmp    $0x2f,%ebx
  1031e4:	7e 39                	jle    10321f <vprintfmt+0xe5>
  1031e6:	83 fb 39             	cmp    $0x39,%ebx
  1031e9:	7f 34                	jg     10321f <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1031eb:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1031ef:	eb d3                	jmp    1031c4 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1031f1:	8b 45 14             	mov    0x14(%ebp),%eax
  1031f4:	8d 50 04             	lea    0x4(%eax),%edx
  1031f7:	89 55 14             	mov    %edx,0x14(%ebp)
  1031fa:	8b 00                	mov    (%eax),%eax
  1031fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1031ff:	eb 1f                	jmp    103220 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  103201:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103205:	79 86                	jns    10318d <vprintfmt+0x53>
                width = 0;
  103207:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10320e:	e9 7a ff ff ff       	jmp    10318d <vprintfmt+0x53>

        case '#':
            altflag = 1;
  103213:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10321a:	e9 6e ff ff ff       	jmp    10318d <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  10321f:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  103220:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103224:	0f 89 63 ff ff ff    	jns    10318d <vprintfmt+0x53>
                width = precision, precision = -1;
  10322a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10322d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103230:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103237:	e9 51 ff ff ff       	jmp    10318d <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10323c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  103240:	e9 48 ff ff ff       	jmp    10318d <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103245:	8b 45 14             	mov    0x14(%ebp),%eax
  103248:	8d 50 04             	lea    0x4(%eax),%edx
  10324b:	89 55 14             	mov    %edx,0x14(%ebp)
  10324e:	8b 00                	mov    (%eax),%eax
  103250:	83 ec 08             	sub    $0x8,%esp
  103253:	ff 75 0c             	pushl  0xc(%ebp)
  103256:	50                   	push   %eax
  103257:	8b 45 08             	mov    0x8(%ebp),%eax
  10325a:	ff d0                	call   *%eax
  10325c:	83 c4 10             	add    $0x10,%esp
            break;
  10325f:	e9 71 02 00 00       	jmp    1034d5 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103264:	8b 45 14             	mov    0x14(%ebp),%eax
  103267:	8d 50 04             	lea    0x4(%eax),%edx
  10326a:	89 55 14             	mov    %edx,0x14(%ebp)
  10326d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10326f:	85 db                	test   %ebx,%ebx
  103271:	79 02                	jns    103275 <vprintfmt+0x13b>
                err = -err;
  103273:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103275:	83 fb 06             	cmp    $0x6,%ebx
  103278:	7f 0b                	jg     103285 <vprintfmt+0x14b>
  10327a:	8b 34 9d 94 3d 10 00 	mov    0x103d94(,%ebx,4),%esi
  103281:	85 f6                	test   %esi,%esi
  103283:	75 19                	jne    10329e <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  103285:	53                   	push   %ebx
  103286:	68 c1 3d 10 00       	push   $0x103dc1
  10328b:	ff 75 0c             	pushl  0xc(%ebp)
  10328e:	ff 75 08             	pushl  0x8(%ebp)
  103291:	e8 80 fe ff ff       	call   103116 <printfmt>
  103296:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103299:	e9 37 02 00 00       	jmp    1034d5 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  10329e:	56                   	push   %esi
  10329f:	68 ca 3d 10 00       	push   $0x103dca
  1032a4:	ff 75 0c             	pushl  0xc(%ebp)
  1032a7:	ff 75 08             	pushl  0x8(%ebp)
  1032aa:	e8 67 fe ff ff       	call   103116 <printfmt>
  1032af:	83 c4 10             	add    $0x10,%esp
            }
            break;
  1032b2:	e9 1e 02 00 00       	jmp    1034d5 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1032b7:	8b 45 14             	mov    0x14(%ebp),%eax
  1032ba:	8d 50 04             	lea    0x4(%eax),%edx
  1032bd:	89 55 14             	mov    %edx,0x14(%ebp)
  1032c0:	8b 30                	mov    (%eax),%esi
  1032c2:	85 f6                	test   %esi,%esi
  1032c4:	75 05                	jne    1032cb <vprintfmt+0x191>
                p = "(null)";
  1032c6:	be cd 3d 10 00       	mov    $0x103dcd,%esi
            }
            if (width > 0 && padc != '-') {
  1032cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032cf:	7e 76                	jle    103347 <vprintfmt+0x20d>
  1032d1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1032d5:	74 70                	je     103347 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1032d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032da:	83 ec 08             	sub    $0x8,%esp
  1032dd:	50                   	push   %eax
  1032de:	56                   	push   %esi
  1032df:	e8 17 f8 ff ff       	call   102afb <strnlen>
  1032e4:	83 c4 10             	add    $0x10,%esp
  1032e7:	89 c2                	mov    %eax,%edx
  1032e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032ec:	29 d0                	sub    %edx,%eax
  1032ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1032f1:	eb 17                	jmp    10330a <vprintfmt+0x1d0>
                    putch(padc, putdat);
  1032f3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1032f7:	83 ec 08             	sub    $0x8,%esp
  1032fa:	ff 75 0c             	pushl  0xc(%ebp)
  1032fd:	50                   	push   %eax
  1032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103301:	ff d0                	call   *%eax
  103303:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  103306:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10330a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10330e:	7f e3                	jg     1032f3 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103310:	eb 35                	jmp    103347 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  103312:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103316:	74 1c                	je     103334 <vprintfmt+0x1fa>
  103318:	83 fb 1f             	cmp    $0x1f,%ebx
  10331b:	7e 05                	jle    103322 <vprintfmt+0x1e8>
  10331d:	83 fb 7e             	cmp    $0x7e,%ebx
  103320:	7e 12                	jle    103334 <vprintfmt+0x1fa>
                    putch('?', putdat);
  103322:	83 ec 08             	sub    $0x8,%esp
  103325:	ff 75 0c             	pushl  0xc(%ebp)
  103328:	6a 3f                	push   $0x3f
  10332a:	8b 45 08             	mov    0x8(%ebp),%eax
  10332d:	ff d0                	call   *%eax
  10332f:	83 c4 10             	add    $0x10,%esp
  103332:	eb 0f                	jmp    103343 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  103334:	83 ec 08             	sub    $0x8,%esp
  103337:	ff 75 0c             	pushl  0xc(%ebp)
  10333a:	53                   	push   %ebx
  10333b:	8b 45 08             	mov    0x8(%ebp),%eax
  10333e:	ff d0                	call   *%eax
  103340:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103343:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103347:	89 f0                	mov    %esi,%eax
  103349:	8d 70 01             	lea    0x1(%eax),%esi
  10334c:	0f b6 00             	movzbl (%eax),%eax
  10334f:	0f be d8             	movsbl %al,%ebx
  103352:	85 db                	test   %ebx,%ebx
  103354:	74 26                	je     10337c <vprintfmt+0x242>
  103356:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10335a:	78 b6                	js     103312 <vprintfmt+0x1d8>
  10335c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  103360:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103364:	79 ac                	jns    103312 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  103366:	eb 14                	jmp    10337c <vprintfmt+0x242>
                putch(' ', putdat);
  103368:	83 ec 08             	sub    $0x8,%esp
  10336b:	ff 75 0c             	pushl  0xc(%ebp)
  10336e:	6a 20                	push   $0x20
  103370:	8b 45 08             	mov    0x8(%ebp),%eax
  103373:	ff d0                	call   *%eax
  103375:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  103378:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10337c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103380:	7f e6                	jg     103368 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  103382:	e9 4e 01 00 00       	jmp    1034d5 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103387:	83 ec 08             	sub    $0x8,%esp
  10338a:	ff 75 e0             	pushl  -0x20(%ebp)
  10338d:	8d 45 14             	lea    0x14(%ebp),%eax
  103390:	50                   	push   %eax
  103391:	e8 39 fd ff ff       	call   1030cf <getint>
  103396:	83 c4 10             	add    $0x10,%esp
  103399:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10339c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10339f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033a5:	85 d2                	test   %edx,%edx
  1033a7:	79 23                	jns    1033cc <vprintfmt+0x292>
                putch('-', putdat);
  1033a9:	83 ec 08             	sub    $0x8,%esp
  1033ac:	ff 75 0c             	pushl  0xc(%ebp)
  1033af:	6a 2d                	push   $0x2d
  1033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b4:	ff d0                	call   *%eax
  1033b6:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  1033b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033bf:	f7 d8                	neg    %eax
  1033c1:	83 d2 00             	adc    $0x0,%edx
  1033c4:	f7 da                	neg    %edx
  1033c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1033cc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1033d3:	e9 9f 00 00 00       	jmp    103477 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1033d8:	83 ec 08             	sub    $0x8,%esp
  1033db:	ff 75 e0             	pushl  -0x20(%ebp)
  1033de:	8d 45 14             	lea    0x14(%ebp),%eax
  1033e1:	50                   	push   %eax
  1033e2:	e8 99 fc ff ff       	call   103080 <getuint>
  1033e7:	83 c4 10             	add    $0x10,%esp
  1033ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1033f0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1033f7:	eb 7e                	jmp    103477 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1033f9:	83 ec 08             	sub    $0x8,%esp
  1033fc:	ff 75 e0             	pushl  -0x20(%ebp)
  1033ff:	8d 45 14             	lea    0x14(%ebp),%eax
  103402:	50                   	push   %eax
  103403:	e8 78 fc ff ff       	call   103080 <getuint>
  103408:	83 c4 10             	add    $0x10,%esp
  10340b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10340e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103411:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103418:	eb 5d                	jmp    103477 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  10341a:	83 ec 08             	sub    $0x8,%esp
  10341d:	ff 75 0c             	pushl  0xc(%ebp)
  103420:	6a 30                	push   $0x30
  103422:	8b 45 08             	mov    0x8(%ebp),%eax
  103425:	ff d0                	call   *%eax
  103427:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  10342a:	83 ec 08             	sub    $0x8,%esp
  10342d:	ff 75 0c             	pushl  0xc(%ebp)
  103430:	6a 78                	push   $0x78
  103432:	8b 45 08             	mov    0x8(%ebp),%eax
  103435:	ff d0                	call   *%eax
  103437:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10343a:	8b 45 14             	mov    0x14(%ebp),%eax
  10343d:	8d 50 04             	lea    0x4(%eax),%edx
  103440:	89 55 14             	mov    %edx,0x14(%ebp)
  103443:	8b 00                	mov    (%eax),%eax
  103445:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103448:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10344f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103456:	eb 1f                	jmp    103477 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103458:	83 ec 08             	sub    $0x8,%esp
  10345b:	ff 75 e0             	pushl  -0x20(%ebp)
  10345e:	8d 45 14             	lea    0x14(%ebp),%eax
  103461:	50                   	push   %eax
  103462:	e8 19 fc ff ff       	call   103080 <getuint>
  103467:	83 c4 10             	add    $0x10,%esp
  10346a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10346d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103470:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103477:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10347b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10347e:	83 ec 04             	sub    $0x4,%esp
  103481:	52                   	push   %edx
  103482:	ff 75 e8             	pushl  -0x18(%ebp)
  103485:	50                   	push   %eax
  103486:	ff 75 f4             	pushl  -0xc(%ebp)
  103489:	ff 75 f0             	pushl  -0x10(%ebp)
  10348c:	ff 75 0c             	pushl  0xc(%ebp)
  10348f:	ff 75 08             	pushl  0x8(%ebp)
  103492:	e8 f8 fa ff ff       	call   102f8f <printnum>
  103497:	83 c4 20             	add    $0x20,%esp
            break;
  10349a:	eb 39                	jmp    1034d5 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10349c:	83 ec 08             	sub    $0x8,%esp
  10349f:	ff 75 0c             	pushl  0xc(%ebp)
  1034a2:	53                   	push   %ebx
  1034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1034a6:	ff d0                	call   *%eax
  1034a8:	83 c4 10             	add    $0x10,%esp
            break;
  1034ab:	eb 28                	jmp    1034d5 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1034ad:	83 ec 08             	sub    $0x8,%esp
  1034b0:	ff 75 0c             	pushl  0xc(%ebp)
  1034b3:	6a 25                	push   $0x25
  1034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b8:	ff d0                	call   *%eax
  1034ba:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  1034bd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1034c1:	eb 04                	jmp    1034c7 <vprintfmt+0x38d>
  1034c3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1034c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1034ca:	83 e8 01             	sub    $0x1,%eax
  1034cd:	0f b6 00             	movzbl (%eax),%eax
  1034d0:	3c 25                	cmp    $0x25,%al
  1034d2:	75 ef                	jne    1034c3 <vprintfmt+0x389>
                /* do nothing */;
            break;
  1034d4:	90                   	nop
        }
    }
  1034d5:	e9 68 fc ff ff       	jmp    103142 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  1034da:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1034db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1034de:	5b                   	pop    %ebx
  1034df:	5e                   	pop    %esi
  1034e0:	5d                   	pop    %ebp
  1034e1:	c3                   	ret    

001034e2 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1034e2:	55                   	push   %ebp
  1034e3:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1034e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034e8:	8b 40 08             	mov    0x8(%eax),%eax
  1034eb:	8d 50 01             	lea    0x1(%eax),%edx
  1034ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f1:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1034f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f7:	8b 10                	mov    (%eax),%edx
  1034f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034fc:	8b 40 04             	mov    0x4(%eax),%eax
  1034ff:	39 c2                	cmp    %eax,%edx
  103501:	73 12                	jae    103515 <sprintputch+0x33>
        *b->buf ++ = ch;
  103503:	8b 45 0c             	mov    0xc(%ebp),%eax
  103506:	8b 00                	mov    (%eax),%eax
  103508:	8d 48 01             	lea    0x1(%eax),%ecx
  10350b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10350e:	89 0a                	mov    %ecx,(%edx)
  103510:	8b 55 08             	mov    0x8(%ebp),%edx
  103513:	88 10                	mov    %dl,(%eax)
    }
}
  103515:	90                   	nop
  103516:	5d                   	pop    %ebp
  103517:	c3                   	ret    

00103518 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103518:	55                   	push   %ebp
  103519:	89 e5                	mov    %esp,%ebp
  10351b:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10351e:	8d 45 14             	lea    0x14(%ebp),%eax
  103521:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103527:	50                   	push   %eax
  103528:	ff 75 10             	pushl  0x10(%ebp)
  10352b:	ff 75 0c             	pushl  0xc(%ebp)
  10352e:	ff 75 08             	pushl  0x8(%ebp)
  103531:	e8 0b 00 00 00       	call   103541 <vsnprintf>
  103536:	83 c4 10             	add    $0x10,%esp
  103539:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10353c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10353f:	c9                   	leave  
  103540:	c3                   	ret    

00103541 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103541:	55                   	push   %ebp
  103542:	89 e5                	mov    %esp,%ebp
  103544:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103547:	8b 45 08             	mov    0x8(%ebp),%eax
  10354a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10354d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103550:	8d 50 ff             	lea    -0x1(%eax),%edx
  103553:	8b 45 08             	mov    0x8(%ebp),%eax
  103556:	01 d0                	add    %edx,%eax
  103558:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10355b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103562:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103566:	74 0a                	je     103572 <vsnprintf+0x31>
  103568:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10356b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10356e:	39 c2                	cmp    %eax,%edx
  103570:	76 07                	jbe    103579 <vsnprintf+0x38>
        return -E_INVAL;
  103572:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103577:	eb 20                	jmp    103599 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103579:	ff 75 14             	pushl  0x14(%ebp)
  10357c:	ff 75 10             	pushl  0x10(%ebp)
  10357f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103582:	50                   	push   %eax
  103583:	68 e2 34 10 00       	push   $0x1034e2
  103588:	e8 ad fb ff ff       	call   10313a <vprintfmt>
  10358d:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  103590:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103593:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103596:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103599:	c9                   	leave  
  10359a:	c3                   	ret    
