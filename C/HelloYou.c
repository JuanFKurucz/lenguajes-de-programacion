#include <stdio.h>

#define LARGO 100

int main( ) {

   char nombre[LARGO];

   printf( "Ingresa tu nombre : ");
   fgets(nombre, LARGO, stdin);

   printf( "\nHola, %s\n", nombre);

   return 0;
}