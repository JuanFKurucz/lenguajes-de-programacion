#include <stdio.h>
#include <string.h>
#include <string.h>
#define LARGO 100

// Declarar funciones
void evaluate(char **code, int *pos, int *stack, int *top);
char **split(char *originStringPointer, char *delimiterStringPointer, char **resultArrayPointer, int size);
int add(int a, int b);
int sub(int a, int b);
int mult(int a, int b);
int div(int a, int b);
int pusheye(int elem, int *stack, int *top);
int popeye(int *stack, int *top);
char *strsep(char **stringp, const char *delim);

char *strsep(char **stringp, const char *delim)
{
    char *rv = *stringp;
    if (rv)
    {
        *stringp += strcspn(*stringp, delim);
        if (**stringp)
            *(*stringp)++ = '\0';
        else
            *stringp = 0;
    }
    return rv;
}

/*
 * Main ej 2.2
 * 
 */
int main()
{
    // Declarar var
    int pos = 0, stack[LARGO], top = -1;
    //printf("Introduce la secuencia de operaciones: ");
    //fgets(texto, LARGO, stdin);

    //https://www.tutorialspoint.com/c_standard_library/c_function_strtok.htm
    //Splitea la oracion de acuerdo a un separador
    char *code[LARGO] = {"1", "2", "3", "MULT", "ADD"};
    int i = 0;

    while (i < 5)
    {
        evaluate(code, &pos, stack, &top);
        printf("STACK: %d\n", *stack);
        i++;
    }
}

/**
 * 
 * 
 */
void evaluate(char **code, int *pos, int *stack, int *top)
{
    // Declarar variables
    char *instruction;
    char *instruction_parsed[2];
    int a, b;
    // Agarra la intrucción en la pos
    instruction = code[*pos];
    if (strcmp("ADD", instruction) == 0)
    {
        printf("Entramos en ADD\n");
        a = popeye(stack, top);
        b = popeye(stack, top);
        // chequear que a y b tengan valores
        pusheye(a + b, stack, top);
    }
    else if (strcmp("DIV", instruction) == 0)
    {
        printf("Entramos en DIV\n");
        a = popeye(stack, top);
        b = popeye(stack, top);
        pusheye(a / b, stack, top);
    }
    else if (strcmp("SUB", instruction) == 0)
    {
        printf("Entramos en SUB\n");
        a = popeye(stack, top);
        b = popeye(stack, top);
        pusheye(a - b, stack, top);
    }
    else if (strcmp("MULT", instruction) == 0)
    {
        printf("Entramos en MULT\n");
        a = popeye(stack, top);
        b = popeye(stack, top);
        pusheye(a * b, stack, top);
    }
    else
    {
        int z = 0;
        printf("Entramos en ELSE %s\n", instruction);
        /*split(instruction, "-", instruction_parsed, 2);*/
        sscanf(instruction, "%d", &z);
        pusheye(z, stack, top);
    }
    *pos = *pos + 1;
}

/*
 * Funcion que toma un string (puntero) y un delimitador y separa
 * el string.
 * Retorna un array con los tokens.
 */
char **split(char *originStringPointer, char *delimiterStringPointer, char **resultArrayPointer, int size)
{

    // Declaraciones
    char *tokenPointer;
    char *token[LARGO];
    int i;

    i = 0;
    // Extraer tokens y ponerlos en un array de strings uno a uno. Mientras hay espacio en el array de salida y
    // el puntero al token es distinto de nulo
    while ((i < size) && ((tokenPointer = strsep(&originStringPointer, delimiterStringPointer)) != NULL))
    {
        resultArrayPointer[i] = strdup(tokenPointer);
        printf("SPLIT: %s\n", tokenPointer);

        i++;
    }

    //printf("SPLIT RESULT: %s\n", resultArrayPointer);
    return resultArrayPointer;
}

int pusheye(int elem, int *stack, int *top)
{
    *top = *top + 1;
    stack[*top] = elem;
    return 0;
}

int popeye(int *stack, int *top)
{
    int res = stack[*top];
    *top = *top - 1;
    return res;
}