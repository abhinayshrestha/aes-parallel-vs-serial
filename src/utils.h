#ifndef AES_UTILS_H
#define AES_UTILS_H

#include <stdio.h>

// Function to validate message and key length
extern unsigned char mul2[];
extern unsigned char mul3[];
extern unsigned int s[256];
extern unsigned char rcon[255];
int read_input_and_validate(unsigned char *message, unsigned char *key);

#endif // AES_UTILS_H