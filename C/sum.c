#include <stdio.h>
#include <string.h>

#define LARGO 100

// Declarar funciones
int countElements(char * originStringPointer, char * delimiterStringPointer, int size);
int *splitToIntArray(char * originStringPointer, char * delimiterStringPointer, int *resultArrayPointer, int size);
int sum(int *intArray, int size);

/*
 * Main ej 1.4
 * 
 */
int main( ) {
    // declaraciones
    char cadenaNaturales[LARGO];
    char *originString;
    int count, i, sumResult;

    // Pedir input
    printf( "Ingresa numeros naturales separados por espacio : ");
    fgets(cadenaNaturales, LARGO, stdin);

    // Duplico el string para preservar el original por que countElements rompe el string
    originString = strdup(cadenaNaturales);

    // Cuento cantidad de elementos (rompe el string originString)
    count = countElements(originString, " ", LARGO);

    // Declaro array con el tamaño de la cantidad de elementos
    int elementos[count];

    // Obtengo array de ints
    originString = strdup(cadenaNaturales);
    splitToIntArray(originString, " ",  elementos, count);

    // Sumo
    sumResult = sum(elementos, count);
    printf("El resultado de la suma es: %d\n", sumResult);

    return 0;
}

/*
 * Funcion que toma un string (puntero) y un delimitador y 
 * retorna la cantidad de elementos que contiene el string al separar
 * por el delimitador
 */
int countElements(char * originStringPointer, char * delimiterStringPointer, int size){
    
    // Declaraciones
    char *tokenPointer;
    char *token[LARGO];
    int  count;

    count = 0;
    // Extraer tokens para contar la cantidad de elementos
    while(( count < size ) && ((tokenPointer = strsep(&originStringPointer, delimiterStringPointer)) != NULL) ){
       count++;
    }

    return count;
}

/*
 * Funcion que toma un string (puntero) y un delimitador y separa
 * el string.
 * Retorna un array con los tokens casteados a int usando sscanf.
 */
int *splitToIntArray(char * originStringPointer, char * delimiterStringPointer, int *resultArrayPointer, int size){
    
    // Declaraciones
    char *tokenPointer;
    int  i;

    i = 0;
    // Extraer tokens y ponerlos en un array casteandolos uno a uno a int.
    while(( i < size ) && ((tokenPointer = strsep(&originStringPointer, delimiterStringPointer)) != NULL) ){
        sscanf(tokenPointer, "%d", &resultArrayPointer[i]);
        printf("SPLIT: %d\n", resultArrayPointer[i]);
        
        i++;
    }

    printf("El while termino el la iteracion: %d\n", i );
    return resultArrayPointer;
}


/*
 * Funcion que realiza la suma de los elementos de un array de int
 * 
 */
int sum(int *intArray, int size){

    // Declaraciones
    int sumResult, i;

    // Suma
    sumResult = 0;
    for (i = 0; i < size; i++){
        sumResult += intArray[i];
    }
    return sumResult;
}