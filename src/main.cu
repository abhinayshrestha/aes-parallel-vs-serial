#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "utils.h"
#include "aes_serial.h"
#include "aes_parallel.h"
#include <cuda_runtime.h>
#include "timer.h"

int main()
{
    unsigned char message[] = "The AES128 algorithm is a highly efficient and secure cryptographic method designed to encrypt data in both parallel and serial modes, ensuring robust protection against unauthorized access. Utilizing a 128-bit key, this algorithm transforms plaintext into a 128-bit ciphertext through a sequence of intricate operations. To begin, the input message is divided into blocks, each 128 bits in size, which are then processed independently. The key expansion mechanism generates a unique round key for every stage, producing 11 distinct keys for the 10 main encryption rounds and the initial pre-round transformation. These keys are crucial to the algorithm's strength, ensuring that each block is encrypted differently.Each encryption round consists of several transformative steps: SubBytes replaces bytes based on a substitution box, offering non-linearity; ShiftRows rearranges rows to disperse the data further; MixColumns introduces data diffusion across columns, making it difficult to trace original data patterns; and AddRoundKey combines the state with the round key using an XOR operation. In the final round, the MixColumns step is omitted to maintain ciphertext compactness. Parallel processing allows AES128 to encrypt large volumes of data rapidly, while serial execution ensures precise and consistent operations for smaller datasets. This flexibility makes the algorithm suitable for a wide range of applications, including securing online banking, safeguarding personal communications, and protecting classified government information. Its resistance to modern cryptanalytic attacks like differential and linear cryptanalysis underscores its reliability.AES128's adoption across industries highlights its trustworthiness. By breaking messages into blocks and applying layered transformations, it guarantees confidentiality. Whether encrypting a short text or vast datasets, it ensures that sensitive information remains secure, reinforcing its role as a cornerstone of modern data encryption technologies.";
    unsigned char key[] = "thesouthernmisss";
    printf("\n *******************Starting**********************\n");
    printf("Message: %s\n", message);
    printf("Key: %s\n", key);
    printf("\n\n");
    AES_Encryption_Serial(message, key);
    printf("\n\n");
    AES_Encryption_Parallel(message, key);
    return 0;
}