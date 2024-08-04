#include <asm/desc.h>

void my_store_idt(struct desc_ptr *idtr){
    asm volatile("sidt %0":"=m"(*idtr)::);
}

void my_load_idt(struct desc_ptr *idtr) {
    asm volatile("lidt %0"::"m"(*idtr):"memory");
}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
    unsigned long high = addr >> 32;
    unsigned long middle = addr >> 16;
    unsigned long low = addr;

    gate->offset_high = high;
    gate->offset_middle = middle;
    gate->offset_low = low;
}

//the opposite of the previous function
unsigned long my_get_gate_offset(gate_desc *gate) {
    unsigned long high = gate->offset_high;
    unsigned long middle = gate->offset_middle;
    unsigned long low = gate->offset_low;
    unsigned long addr = 0;

    addr = (high << 32) + (middle << 16) + low;

    return addr;
}
