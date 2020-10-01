#include <stdio.h>
#include <string.h>

#define LARGO 100

// Declarar funciones
int evaluate(char **code, int *pos, int *stack, int *top);
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
    char *code[LARGO] = {"ADD"};
    int pos, stack[LARGO], top;

    // inicalizamos
    pos = 0;
    top = 1;
    stack[0] = 1;
    stack[1] = 2;
    evaluate(code, &pos, stack, &top);

    printf("STACK: %d\n", *stack);
}

/**
 * 
 * 
 */
int evaluate(char **code, int *pos, int *stack, int *top)
{
    // Declarar variables
    char *instruction;
    char *instruction_parsed[2];
    int a, b, z;
    // Agarra la intrucción en la pos
    instruction = code[*pos];
    if (strcmp("ADD", instruction) == 0)
    {
        printf("Entramos en ADD\n");
        a = popeye(stack, top);
        b = popeye(stack, top);
        // chequear que a y b tengan valores
        return pusheye(a + b, stack, top);
    }
    else if (strcmp("DIV", instruction) == 0)
    {
        printf("Entramos en DIV\n");
        a = popeye(stack, top);
        b = popeye(stack, top);
        return pusheye(a / b, stack, top);
    }
    else if (strcmp("SUB", instruction) == 0)
    {
        printf("Entramos en SUB\n");
        a = popeye(stack, top);
        b = popeye(stack, top);
        return pusheye(a - b, stack, top);
    }
    else if (strcmp("MULT", instruction) == 0)
    {
        printf("Entramos en MULT\n");
        a = popeye(stack, top);
        b = popeye(stack, top);
        return pusheye(a * b, stack, top);
    }
    else
    {
        split(instruction, "-", instruction_parsed, 2);
        sscanf(instruction_parsed[1], "%d", &z);
        pusheye(z, stack, top);
    }
    pos++;
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
    *top++;
    stack[*top] = elem;
    return 0;
}

int popeye(int *stack, int *top)
{
    return stack[*top--];
}