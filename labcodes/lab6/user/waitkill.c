#include <ulib.h>
#include <stdio.h>

void
do_yield(void) {
    yield();
    // cprintf("yield() * 1\n");    
    yield();
    // cprintf("yield() * 2\n");
    yield();
    // cprintf("yield() * 3\n");
    yield();
    // cprintf("yield() * 4\n");
    yield();
    // cprintf("yield() * 5\n");
    yield();
    // cprintf("end of do_yield()\n");
}

int parent, pid1, pid2;

void
loop(void) {
    cprintf("child 1.\n");
    while (1);
}

void
work(void) {
    cprintf("child 2.\n");
    do_yield();
    if (kill(parent) == 0) {
        cprintf("kill parent ok.\n");
        do_yield();
        if (kill(pid1) == 0) {
            cprintf("kill child1 ok.\n");
            exit(0);
        }
    }
    exit(-1);
}

int
main(void) {
    parent = getpid();
    if ((pid1 = fork()) == 0) {
        loop();
    }

    assert(pid1 > 0);

    if ((pid2 = fork()) == 0) {
        work();
    }
    if (pid2 > 0) {
        cprintf("wait child 1.\n");
        waitpid(pid1, NULL);
        panic("waitpid %d returns\n", pid1);
    }
    else {
        kill(pid1);
    }
    panic("FAIL: T.T\n");
}

