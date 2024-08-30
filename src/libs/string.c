#include "libs/string.h"

size_t strlen(const char* str) {
    uint16_t len = 0;
    for(;*str != '\0';len++);

    return len;
}
