#include "aes_serial.h"
#include "utils.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "timer.h"

void KeyExpansionCore(unsigned char *in, unsigned char i)
{
    // rotate left
    unsigned char t = in[0];
    in[0] = in[1];
    in[1] = in[2];
    in[2] = in[3];
    in[3] = t;

    // s-box lookup
    in[0] = s[in[0]];
    in[1] = s[in[1]];
    in[2] = s[in[2]];
    in[3] = s[in[3]];

    // Rcon
    in[0] ^= rcon[i];
}

void KeyExpansion(unsigned char *inputKey, unsigned char *expandedKeys)
{
    // first 16 byte of orignal key
    int i;
    unsigned char a;
    for (i = 0; i < 16; i++)
        expandedKeys[i] = inputKey[i];

    // Variables:
    int bytesGenerated = 16;
    int rconIternarion = 1;
    unsigned char temp[4];

    while (bytesGenerated < 176)
    {
        for (i = 0; i < 4; i++)
            temp[i] = expandedKeys[i + bytesGenerated - 4];

        // Perform the core once for each 16 byte key
        if (bytesGenerated % 16 == 0)
            KeyExpansionCore(temp, rconIternarion++);

        // XOR temp
        for (a = 0; a < 4; a++)
        {
            expandedKeys[bytesGenerated] = expandedKeys[bytesGenerated - 16] ^ temp[a];
            bytesGenerated++;
        }
    }
}

void SubBytes(unsigned char *state)
{
    int i;
    for (i = 0; i < 16; i++)
    {
        state[i] = s[state[i]];
    }
}

void ShiftRows(unsigned char *state)
{
    unsigned char tmp[16];
    int i;
    tmp[0] = state[0];
    tmp[1] = state[5];
    tmp[2] = state[10];
    tmp[3] = state[15];

    tmp[4] = state[4];
    tmp[5] = state[9];
    tmp[6] = state[14];
    tmp[7] = state[3];

    tmp[8] = state[8];
    tmp[9] = state[13];
    tmp[10] = state[2];
    tmp[11] = state[7];

    tmp[12] = state[12];
    tmp[13] = state[1];
    tmp[14] = state[6];
    tmp[15] = state[11];

    for (i = 0; i < 16; i++)
        state[i] = tmp[i];
}

void MixColumns(unsigned char *state)
{
    unsigned char tmp[16];
    int i;
    tmp[0] = (unsigned char)(mul2[state[0]] ^ mul3[state[1]] ^ state[2] ^ state[3]);
    tmp[1] = (unsigned char)(state[0] ^ mul2[state[1]] ^ mul3[state[2]] ^ state[3]);
    tmp[2] = (unsigned char)(state[0] ^ state[1] ^ mul2[state[2]] ^ mul3[state[3]]);
    tmp[3] = (unsigned char)(mul3[state[0]] ^ state[1] ^ state[2] ^ mul2[state[3]]);

    tmp[4] = (unsigned char)(mul2[state[4]] ^ mul3[state[5]] ^ state[6] ^ state[7]);
    tmp[5] = (unsigned char)(state[4] ^ mul2[state[5]] ^ mul3[state[6]] ^ state[7]);
    tmp[6] = (unsigned char)(state[4] ^ state[5] ^ mul2[state[6]] ^ mul3[state[7]]);
    tmp[7] = (unsigned char)(mul3[state[4]] ^ state[5] ^ state[6] ^ mul2[state[7]]);

    tmp[8] = (unsigned char)(mul2[state[8]] ^ mul3[state[9]] ^ state[10] ^ state[11]);
    tmp[9] = (unsigned char)(state[8] ^ mul2[state[9]] ^ mul3[state[10]] ^ state[11]);
    tmp[10] = (unsigned char)(state[8] ^ state[9] ^ mul2[state[10]] ^ mul3[state[11]]);
    tmp[11] = (unsigned char)(mul3[state[8]] ^ state[9] ^ state[10] ^ mul2[state[11]]);

    tmp[12] = (unsigned char)(mul2[state[12]] ^ mul3[state[13]] ^ state[14] ^ state[15]);
    tmp[13] = (unsigned char)(state[12] ^ mul2[state[13]] ^ mul3[state[14]] ^ state[15]);
    tmp[14] = (unsigned char)(state[12] ^ state[13] ^ mul2[state[14]] ^ mul3[state[15]]);
    tmp[15] = (unsigned char)(mul3[state[12]] ^ state[13] ^ state[14] ^ mul2[state[15]]);

    for (i = 0; i < 16; i++)
        state[i] = tmp[i];
}

void AddRoundKey(unsigned char *state, unsigned char *roundKey)
{
    int i;
    for (i = 0; i < 16; i++)
        state[i] ^= roundKey[i];
}

void AES_Encrypt(unsigned char *message, unsigned char *expandedKey, unsigned char *key)
{
    unsigned char state[16];
    int i;
    int numberOfRounds = 9;
    for (i = 0; i < 16; i++)
        state[i] = message[i];

    AddRoundKey(state, key); /// Initial Round

    // Repeating rounds
    for (i = 0; i < numberOfRounds; i++)
    {
        SubBytes(state);
        ShiftRows(state);
        MixColumns(state);
        AddRoundKey(state, expandedKey + (16 * (i + 1)));
    }

    // Final Round
    SubBytes(state);
    ShiftRows(state);
    AddRoundKey(state, expandedKey + 160);

    // copy to message
    for (i = 0; i < 16; i++)
    {
        message[i] = state[i];
    }
}

void AES_Encrypt_Kernal(int originalLen, unsigned char *message, unsigned char *expandedKey, unsigned char *key, unsigned char *final_encrypted_message)
{
    int total_message_block = (originalLen + 15) / 16;
    int i = 0;
    int j = 0;
    for (j = 0; j < total_message_block; j++)
    {
        unsigned char block_message[16];
        for (i = 0; i < 16; i++)
        {
            if (j * 16 + i > originalLen - 1)
            {
                block_message[i] = '\0';
            }
            else
            {
                block_message[i] = message[j * 16 + i];
            }
        }
        unsigned char *paddedMessage = (unsigned char *)malloc(16);
        memcpy(paddedMessage, block_message, 16);
        AES_Encrypt(paddedMessage, expandedKey, key);
        for (i = 0; i < 16; i++)
        {
            final_encrypted_message[j * 16 + i] = paddedMessage[i];
        }
        // }
    }
}

void AES_Encryption_Serial(unsigned char *message, unsigned char *key)
{
    printf("======================Serial Encryption============================\n");
    double start, finish;
    int i;
    // Expanded Keys
    unsigned char expandedKey[176];

    KeyExpansion(key, expandedKey);

    // Calculate padded message length
    int originalLen = strlen((const char *)message);
    int final_encrypted_message_length = (originalLen + 15) / 16 * 16;

    unsigned char final_encrypted_message[final_encrypted_message_length];
    GET_TIME(start);
    AES_Encrypt_Kernal(originalLen, message, expandedKey, key, final_encrypted_message);
    GET_TIME(finish);
    printf("Time Elapsed by Serial Program to Encrypt the whole message is:%f\n", finish - start);
    printf("Serial Encrypted Message\n");
    for (i = 0; i < final_encrypted_message_length; i++)
    {
        printf("%02X", final_encrypted_message[i]); // %02X prints in uppercase without spaces
    }
    printf("\n");
}