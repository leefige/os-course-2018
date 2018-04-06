#ifndef __KERN_MM_SWAP_ENCLOCK_H__
#define __KERN_MM_SWAP_ENCLOCK_H__

#include <swap.h>

struct enclock_struct {
    list_entry_t* head;
    list_entry_t** clock;
};

extern struct swap_manager swap_manager_enclock;

#endif
