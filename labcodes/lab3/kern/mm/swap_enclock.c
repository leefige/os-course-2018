#include <defs.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <swap_enclock.h>
#include <list.h>

/*
 * Details of ENHANCED CLOCK PRA
 * (1) Prepare: 
 */

list_entry_t pra_list_head;
list_entry_t *clock_ptr;

struct enclock_struct sm_priv_enclock =
{
     .head            = &pra_list_head,
     .clock           = &clock_ptr,
};

/*
 * (2) _enclock_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_enclock_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     clock_ptr = &pra_list_head;
     assert(clock_ptr != NULL);
     mm->sm_priv = &sm_priv_enclock;
     //cprintf(" mm->sm_priv %x in enclock_init_mm\n",mm->sm_priv);
     return 0;
}
/*
 * (3)_enclock_map_swappable: According enclock PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_enclock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    list_entry_t *head = ((struct enclock_struct*) mm->sm_priv)->head;
    list_entry_t *clock_ptr = *(((struct enclock_struct*) mm->sm_priv)->clock);
    if (head == clock_ptr) {
        cprintf("Got head == clock ptr in swappable\n");
    }
    list_entry_t *entry=&(page->pra_page_link);
    
    assert(entry != NULL && head != NULL);
    //record the page access situlation
    /*LAB3 CHALLENGE: 2015010062*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
        list_entry_t *le_prev = head, *le;
        while ((le = list_next(le_prev)) != head) {
            if (le == entry) {
                list_del(le);
                break;
            }
            le_prev = le;        
        }
    }
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);
    return 0;
}
/*
 *  (4)_enclock_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_enclock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
    list_entry_t *head = ((struct enclock_struct*) mm->sm_priv)->head;
    list_entry_t *clock_ptr = *(((struct enclock_struct*) mm->sm_priv)->clock);
    if (head == clock_ptr) {
        cprintf("Got head == clock ptr in victim\n");
    }
    assert(head != NULL);
    assert(in_tick==0);
    /* Select the victim */
    /*LAB3 CHALLENGE 2: 2015010062*/ 
    //(1)  iterate list searching for victim
    list_entry_t *le_prev = clock_ptr, *le;
    while ((le = list_next(le_prev)) != head) {
        pte_t* ptep = get_pte(mm->pgdir, addr, 0);
        if (*ptep & PTE_A != 0) {
            // set access to 0
            *ptep &= ~PTE_A;
        } else {
            if (*ptep & PTE_W != 0) {
                // set dirty to 0
                *ptep &= ~PTE_W;
            } else {
                break;
            }
        }
        le_prev = le;        
    }
    assert(le != head);
    list_del(le);
    //(2)  assign the value of *ptr_page to the addr of this page
    struct Page *page = le2page(le, pra_page_link);
    assert(page != NULL);
    *ptr_page = page;
    //(2)update clock
    *(((struct enclock_struct*) mm->sm_priv)->clock) = le_prev;
    return 0;
}

static int
_enclock_check_swap(void) {
    cprintf("read Virt Page c in enclock_check_swap\n");
    unsigned char tmp = *(unsigned char *)0x3000;
    assert(pgfault_num==4);
    cprintf("write Virt Page a in enclock_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==4);
    cprintf("read Virt Page d in enclock_check_swap\n");
    tmp = *(unsigned char *)0x4000;
    assert(pgfault_num==4);
    cprintf("write Virt Page b in enclock_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==4);

    cprintf("write Virt Page e in enclock_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==5);
    cprintf("read Virt Page b in enclock_check_swap\n");
    tmp = *(unsigned char *)0x2000;
    assert(pgfault_num==5);
    cprintf("write Virt Page a in enclock_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==5);
    cprintf("read Virt Page b in enclock_check_swap\n");
    tmp = *(unsigned char *)0x2000;
    assert(pgfault_num==5);

    cprintf("read Virt Page c in enclock_check_swap\n");
    tmp = *(unsigned char *)0x3000;
    assert(pgfault_num==6);
    cprintf("read Virt Page d in enclock_check_swap\n");
    tmp = *(unsigned char *)0x4000;
    assert(pgfault_num==7);
    return 0;
}


static int
_enclock_init(void)
{
    return 0;
}

static int
_enclock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_enclock_tick_event(struct mm_struct *mm)
{ return 0; }


struct swap_manager swap_manager_enclock =
{
     .name            = "enclock swap manager",
     .init            = &_enclock_init,
     .init_mm         = &_enclock_init_mm,
     .tick_event      = &_enclock_tick_event,
     .map_swappable   = &_enclock_map_swappable,
     .set_unswappable = &_enclock_set_unswappable,
     .swap_out_victim = &_enclock_swap_out_victim,
     .check_swap      = &_enclock_check_swap,
};
