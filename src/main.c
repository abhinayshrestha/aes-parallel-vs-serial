#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "utils.h"
#include "aes_serial.h"

int main(int argc, char *argv[])
{
    unsigned char message[] = "abhinayshrestha1 sadfsadf"; // Allocate space for 16 characters + null terminator
    unsigned char key[17] = "1234567898765432";     // Allocate space for 16 characters + null terminator

    // Get and validate the message and key
    // if (read_input_and_validate(message, key)) {
    //     return 1; // If validation fails, exit the program
    // }

    AES_Encryption_Serial(message, key);
    return 0;
}