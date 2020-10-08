/*
Diego Bergara
Fernando Rakovsky
Juan Francisco Kurucz
Javier Martin
*/
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define LARGO 100
#define TRUE 1
#define FALSE 0
#define VARIABLES 5

// Declarar funciones
void evaluate(char **code, int *pos, int *stack, int *top, int maxI, int *variables);
char **split(char *originStringPointer, char *delimiterStringPointer, char **resultArrayPointer, int size, int *resultSize);
int pusheye(int elem, int *stack, int *top);
int pushBool(int elem, int *stack, int *top);
int popeye(int *stack, int *top);
char *strsep(char **stringp, const char *delim);

/*
 * Main ej 2.5
 * 
 */
int main()
{
    // CASOS DE PRUEBA
    // 1 2 3 MULT ADD = 7 
    // 22 33 4 SUB MULT = 638
    // 1 10 5 DIV ADD = 3
    // 10 2 10 5 DIV ADD MULT = 40
    // 5 5 5 5 5 1 SUB MULT ADD DIV ADD = 5
    // MULT ADD SUB = 435
    // 25 10 4 8 9 3 ADD SUB ADD MULT ADD = 25
    // 15 ADD MULT = 17400
    // 2 DIV 4 ADD = 8704
    // 45 20 45450 37 25 108 25 35 12 SUB MULT ADD DIV ADD ADD SUB ADD = -45422

    // 7 DUP 1 SET:0 SET:1
    // GET:1 1 LT CJP+10 GET:1 GET:0 MULT SET:0 GET:1 1 SUB SET:1 UJP-12 GET:0
    
    // Declarar vars
    int stack[LARGO], top = -1, variables[VARIABLES];
    char s[2] = " ";
    
    for (int z = 0; z < VARIABLES; z++)
    {
        variables[z]=0;
    }
    while (1 == 1)
    {
        int maxI = 0;
        int pos = 0;
        char texto[LARGO];
        char *code[LARGO];

        printf("Introduce la secuencia de operaciones: ");
        fgets(texto, LARGO, stdin);

        int len = strlen(texto);
        if (texto[len - 1] == '\n')
        {
            texto[len - 1] = 0;
        }

        split(texto, s, code, LARGO, &maxI);
        while (pos < maxI)
        {
            evaluate(code, &pos, stack, &top, maxI, variables);
        }

        printf("STACK TOP: %d\n", top);
        printf("CODE POS: %d\n", pos);
        for (int z = 0; z < top + 1; z++)
        {
            printf("STACK %d: %d\n", z, stack[z]);
        }
        for (int z = 0; z < VARIABLES; z++)
        {
            printf("VARIABLES %d: %d\n", z, variables[z]);
        }
    }
}

/**
 * Realiza la operacion definida en la posicion POS del codigo CODE y avanza
 * el puntero POS.
 * 
 */
void evaluate(char **code, int *pos, int *stack, int *top, int maxI, int *variables)
{
    // Declarar variables
    char *instruction;
    int a, b;
    int salto=0;
    if(*pos<maxI){
        // Agarra la intrucción en la pos
        instruction = code[*pos];

        if(instruction != NULL){
            if ((strlen(instruction) == 6) && !(isdigit(*instruction))){
                char *out[LARGO];
                char *dupped;
                int size;
                
                dupped = strdup(instruction);
                split(dupped, "+-", out, LARGO, &size);
                sscanf(out[1], "%d", &salto);
                if(strcmp("UJP", out[0]) == 0){
                    printf("Entramos en UJP\n");
                    if(instruction[3] == '-'){
                        *pos = *pos - salto;
                    } else {
                        *pos = *pos + salto;
                    }
                } else if(strcmp("CJP", out[0]) == 0){
                    printf("Entramos en CJP\n");
                    a = popeye(stack, top);
                    if (a != 0){
                        if(instruction[3] == '-'){
                            *pos = *pos - salto;
                        } else {
                            *pos = *pos + salto;
                        }
                    } else {
                        *pos = *pos + 1;
                    }
                }  
            }
            else if ((strlen(instruction) == 5) && !(isdigit(*instruction))){
                char *out[LARGO];
                char *dupped;
                int size;
                int variableIndex=0;
                
                dupped = strdup(instruction);
                split(dupped, ":", out, LARGO, &size);
                sscanf(out[1], "%d", &variableIndex);
                if(strcmp("GET", out[0]) == 0){
                    pusheye(variables[variableIndex], stack, top);
                } else if (strcmp("SET", out[0]) == 0){
                    a = popeye(stack, top);
                    variables[variableIndex]=a;
                }
                *pos = *pos + 1;
            } else { 
                if (*top > 0 && strcmp("ADD", instruction) == 0)
                {
                    printf("Entramos en ADD\n");
                    a = popeye(stack, top);
                    b = popeye(stack, top);
                    // chequear que a y b tengan valores
                    pusheye(a + b, stack, top);
                }
                else if (*top > 0 && strcmp("DIV", instruction) == 0)
                {
                    printf("Entramos en DIV\n");
                    a = popeye(stack, top);
                    b = popeye(stack, top);
                    pusheye(b / a, stack, top);
                }
                else if (*top > 0 && strcmp("SUB", instruction) == 0)
                {
                    printf("Entramos en SUB\n");
                    a = popeye(stack, top);
                    b = popeye(stack, top);
                    pusheye(b - a, stack, top);
                }
                else if (*top > 0 && strcmp("MULT", instruction) == 0)
                {
                    printf("Entramos en MULT\n");
                    a = popeye(stack, top);
                    b = popeye(stack, top);
                    pusheye(a * b, stack, top);
                }
                else if (*top > 0 && strcmp("EQ", instruction) == 0)
                {
                    printf("Entramos en EQ\n");
                    a = popeye(stack, top);
                    b = popeye(stack, top);
                    pushBool(a == b, stack, top);
                }
                else if (*top > 0 && strcmp("DIFF", instruction) == 0)
                {
                    printf("Entramos en DIFF\n");
                    a = popeye(stack, top);
                    b = popeye(stack, top);
                    pushBool(a != b, stack, top);
                }
                else if (*top > 0 && strcmp("LT", instruction) == 0)
                {
                    printf("Entramos en LT\n");
                    a = popeye(stack, top);
                    b = popeye(stack, top);
                    pushBool(b < a, stack, top);
                }
                else if (*top > 0 && strcmp("LTE", instruction) == 0)
                {
                    printf("Entramos en LTE\n");
                    a = popeye(stack, top);
                    b = popeye(stack, top);
                    pushBool(b <= a, stack, top);
                }
                else if (*top > 0 && strcmp("GT", instruction) == 0)
                {
                    printf("Entramos en GT\n");
                    a = popeye(stack, top);
                    b = popeye(stack, top);
                    pushBool(b > a, stack, top);
                }
                else if (*top > 0 && strcmp("GTE", instruction) == 0)
                {
                    printf("Entramos en GTE\n");
                    a = popeye(stack, top);
                    b = popeye(stack, top);
                    pushBool(b >= a, stack, top);
                }
                else if (*top >= 0 && strcmp("NOT", instruction) == 0)
                {
                    printf("Entramos en NOT\n");
                    a = popeye(stack, top);
                    if(a != 0){
                        pushBool(FALSE, stack, top);
                    }else {
                        pushBool(TRUE, stack, top);
                    }
                }
                else if (*top > 0 && strcmp("AND", instruction) == 0)
                {
                    printf("Entramos en AND\n");
                    a = popeye(stack, top);
                    b = popeye(stack, top);
                    pushBool(a && b, stack, top);
                }
                else if (*top > 0 && strcmp("OR", instruction) == 0)
                {
                    printf("Entramos en OR\n");
                    a = popeye(stack, top);
                    b = popeye(stack, top);
                    pusheye(a || b, stack, top);
                }
                else if (*top >= 0 && strcmp("POP", instruction) == 0)
                {
                    printf("Entramos en POP\n");
                    a = popeye(stack, top);
                }
                else if (*top >= 0 && strcmp("DUP", instruction) == 0)
                {
                    printf("Entramos en DUP\n");
                    a = popeye(stack, top);
                    pusheye(a, stack, top);
                    pusheye(a, stack, top);
                } 
                else if (
                    (strlen(instruction)>0 && instruction[0] == '-' && ++instruction && isdigit(*instruction) && --instruction) 
                    || isdigit(*instruction)
                )
                {
                    int z = 0;
                    printf("Entramos en ELSE para insertar valor en el stack: %s\n", instruction);
                    sscanf(instruction, "%d", &z); //castear el char a int usando sscanf
                    pusheye(z, stack, top);
                }
                *pos = *pos + 1; // avanzamos la pos a la siguiente instruccion en el codigo
            }
        }
    }
}

/*
 * Funcion que toma un string (puntero) y un delimitador y separa
 * el string.
 * Retorna un array con los tokens.
 */
char **split(char *originStringPointer, char *delimiterStringPointer, char **resultArrayPointer, int size, int *resultSize)
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
        *resultSize = *resultSize + 1;
        printf("SPLIT: %s\n", tokenPointer);

        i++;
    }

    //printf("SPLIT RESULT: %s\n", resultArrayPointer);
    return resultArrayPointer;
}

/**
 * Separa de un string un sub-string segun el delim dado
 * Retorna un puntero al sub-string
 * 
 */
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

/**
 * Inserta en el tope del stack un valor
 * 
 */
int pusheye(int elem, int *stack, int *top)
{
    *top = *top + 1;
    stack[*top] = elem;
    return 0;
}

/**
 * Quita un valor del tope del stack y lo devuelve
 *  
 */
int popeye(int *stack, int *top)
{
    int res = stack[*top];
    *top = *top - 1;
    return res;
}

int pushBool(int elem, int *stack, int *top){
    *top = *top + 1;
    if(elem == 0){
        stack[*top] = FALSE;
    } else {
        stack[*top] = TRUE;
    }
    return 0;
}