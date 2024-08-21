#include <stdint.h>
#include <stdarg.h>

void main() {
    char* my_msg = "Welcome to the kernel bitch!";
    char *VGA_MEM = (char*) 0xb8000;

    for(uint8_t i = 0; my_msg[i] != '\0'; i++) {
        VGA_MEM[i*2] = my_msg[i];
        VGA_MEM[i*2 + 1] = 0x02;
    }

    while(1);
}
