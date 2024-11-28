#ifndef AES_PARALLEL_H
#define AES_PARALLEL_H

void KeyExpansionCore_parallel(unsigned char *in, unsigned char i);
void KeyExpansion_parallel(unsigned char *inputKey, unsigned char *expandedKeys);
void SubBytes_parallel(unsigned char *state);
void ShiftRows_parallel(unsigned char *state);
void MixColumns_parallel(unsigned char *state);
void AddRoundKey_parallel(unsigned char *state, unsigned char *roundKey);
void AES_Encrypt_parallel(unsigned char *message, unsigned char *expandedKey, unsigned char *key);
void AES_Encryption_Serial(unsigned char *message, unsigned char *key);
void AES_Encryption_Parallel(unsigned char *message, unsigned char *key);
__global__ void AES_Encrypt_Kernel_parallel();
#endif // AES_PARALLEL_H