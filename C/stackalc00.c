#include <stdio.h>
#include <string.h>

#define LARGO 100

// Declarar funciones
int evaluate(char *code, int *pos, int *stack, int *top);
char** split(char * originStringPointer, char * delimiterStringPointer, char **resultArrayPointer, int size);
int add(int a, int b);
int sub(int a, int b);
int mult(int a, int b);
int div(int a, int b);
int pusheye(char *stack, int *top);
int popeye(char *stack, int *top);

/*
 * Main ej 2.2
 * 
 */
int main( ) {
    // Declarar var
    char *code[LARGO] = {"ADD","PUSH-3","ADD"};
    int pos, *stack, top;   

    // inicalizamos
    stack[LARGO];
    pos = 0;
    top = 0;

    evaluate(code, &pos, stack, &top);
}

/**
 * 
 * 
 */
int evaluate(char *code, int *pos, int *stack, int *top){
    // Declarar variables
    char *instruction;
    char *instruction_parsed[2];
    int a, b;
    // Agarra la intrucción en la pos
    instruction = code[*pos];
 
    if (strcmp('ADD',instruction)){
        printf("Entramos en ADD");
        a = popeye(stack, top);
        b = popeye(stack, top);
        // chequear que a y b tengan valores
        return add(a, b);
    }
    else if (strcmp('DIV',instruction))
    {
      printf("Entramos en DIV");
      a = popeye(stack, top);
      b = popeye(stack, top);
      return div(a, b);
    }
    else if (strcmp('SUB',instruction))
    {
        printf("Entramos en SUB");
        a = popeye(stack, top);
        b = popeye(stack, top);
        return sub(a, b);
    }
    else if (strcmp('MULT',instruction))
    {
        printf("Entramos en SUB");
        a = popeye(stack, top);
        b = popeye(stack, top);
        return mult(a, b);
    }
    else
    {
        split(instruction,"-", instruction_parsed,2);   
        pusheye(stack, top, instruction_parsed[1]);
    }
    pos++;
}

/*
 * Funcion que toma un string (puntero) y un delimitador y separa
 * el string.
 * Retorna un array con los tokens.
 */
char** split(char * originStringPointer, char * delimiterStringPointer, char **resultArrayPointer, int size){
    
    // Declaraciones
    char *tokenPointer;
    char *token[LARGO];
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

int pusheye(int elem, char *stack, int *top){
    *top++;
    stack[*top] = elem;
    return 0;
}

int popeye(char *stack, int *top){
    return stack[*top--];    
}