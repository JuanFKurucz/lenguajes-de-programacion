#include <stdio.h>
#include <string.h>

#define LARGO 100


char* split(char * stringPointer, char * delimiterStringPointer){
    // Declaraciones
    char *tokenPointer;
    char result[10];
    int tokenNumber;
    // Extraer tokens a una lista y contar cuantos tenemos
    tokenNumber = 0;
    while( (tokenPointer = strsep(&stringPointer, delimiterStringPointer)) != NULL ){
        result[tokenNumber] = *tokenPointer;
        printf("SPLIT: %s\n",tokenPointer);
        tokenNumber++;
    }
    printf("SPLIT RESULT: %s\n", result);
    return " ";
}

int main( ) {

    // declaraciones
    char *stringPointer;
    stringPointer = strdup("1 2 3 4 5 6 7 prueba");
    printf("MAIN: %s\n", split(stringPointer, " "));
}