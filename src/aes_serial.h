#ifndef AES_SERIAL_H
#define AES_SERIAL_H

void KeyExpansionCore(unsigned char* in , unsigned char i);
void KeyExpansion(unsigned char* inputKey, unsigned char* expandedKeys);
void SubBytes(unsigned char* state);
void ShiftRows(unsigned char* state);
void MixColumns(unsigned char* state);
void AddRoundKey(unsigned char* state, unsigned char* roundKey);
void AES_Encrypt(unsigned char* message, unsigned char* expandedKey, unsigned char* key);
void AES_Encryption_Serial(unsigned char *message, unsigned char *key);

#endif // AES_SERIAL_H