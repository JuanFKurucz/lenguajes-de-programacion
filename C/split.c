#include <stdio.h>
#include <string.h>

#define LARGO 100
char** split(char * originStringPointer, char * delimiterStringPointer, char **resultArrayPointer, int size);

/*
 * Main ej 1.4
 * 
 */
int main( ) {
    // declaraciones
    char *originString;
    char *resultArray[LARGO];
    char cadenaNaturales[LARGO];
    int i;


    printf( "Ingresa numeros naturales separados por espacio : ");
    fgets(cadenaNaturales, LARGO, stdin);
    // Duplico el string
    originString = strdup(cadenaNaturales);

    // Separo el string en tokens
    split(originString, " ", resultArray, LARGO);

    // Imprimo el array de strings para ver el resultado
    for (i = 0; i < LARGO-1; i++){
        printf("String = %s", resultArray[i] );
        printf("\tAddress of string literal = %p\n", resultArray[i]);
    }

    return 0;
}

/*
 * Funcion que toma un string (puntero) y un delimitador y separa
 * el string.
 * Retorna un array con los tokens.
 */
char** split(char * originStringPointer, char * delimiterStringPointer, char **resultArrayPointer, int size){
    
    // Declaraciones
    char *tokenPointer;
    int  i;

    i = 0;
    // Extraer tokens y ponerlos en un array de strings uno a uno. Mientras hay espacio en el array de salida y
    // el puntero al token es distinto de nulo
    while(( i < size ) && ((tokenPointer = strsep(&originStringPointer, delimiterStringPointer)) != NULL) ){
        resultArrayPointer[i] = strdup(tokenPointer);
        printf("SPLIT: %s\n", tokenPointer);
        
        i++;
    }

    //printf("SPLIT RESULT: %s\n", resultArrayPointer);
    return resultArrayPointer;
}
