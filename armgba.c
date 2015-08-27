/*
    "mini librairie" armgba :
    ARMGBA.C

      armgba.h    : En-t�te C (� inclure dans le projet C)
      armgba.c    : Les sous programmes en C
      asmarmgba.s : Les sous programmes en assembleur
      incarmgba.s : En-t�te assembleur (� inclure dans les fichiers assembleur)
*/


#include "armgba.h"

//  Initialisation du mode graphique 3 (utilis� dans tous les exercices et pour le projet)
void setMode3(){
  REG_DISPCNT=0x0403;
}

//  Initialisation du mode graphique 4 (pour aventureux, mode palette avec contraintes...)
void setMode4(){
  REG_DISPCNT=0x0404;
}

//  Colorie un pixel (mode 3 seulement) Attention : Pas de contr�le de coordonn�es
void drawPixel(u32 x, u32 y, u16 color){
  ((unsigned short*)VRAM)[x+y*SCREENW] = color;
}

//  Attente de rafra�chissement �cran ( affichage effectif du contenu de la RAM vid�o )
void vSync()
{
    while(REG_VCOUNT >= SCREENH);   // Attendre VDraw  ( d�but du balayage �cran )
    while(REG_VCOUNT < SCREENH);    // Attendre VBlank ( fin du balayage �cran )
}

// Par d�faut la variable traceConsole est � 1 -> les fonctions trace sont actives
// Pour d�sactiver les fonctions trace il suffit de mettre traceConsole � 0
volatile int traceConsole=1;

//  La cha�ne dont l'adresse est pass�e en argument est affich�e
//  Assembleur "inline" pour acc�der � une instruction SWI : Software Interrupt
//  L'interruption 0xff ne fait pas partie du BIOS de la GBA (plantage GBA r�elle)
//  C'est une adresse sp�ciale reconnue par le simulateur VBA pour capturer
//  des messages de d�bogage ( menu Tools -> Logging... )
void traceStr(char *s)
{
  if (traceConsole){
    asm volatile("mov r0, %0;"
                 "swi 0xff;"
                  : // no ouput
                  : "r" (s)
                  : "r0");
	}
}

//  La valeur 32 bits pass�e en argument est affich�e en hexad�cimal. Retour ligne auto.
void traceHex32(u32 u){
  char str[10];
  int dh,i;

  for (i=0;i<8;i++){
    dh=(u>>(28-4*i))&0xf;
	if (dh<10)
	  str[i]=dh+'0';
	else
	  str[i]=dh-10+'A';
  }
  str[8]='\n';
  str[9]='\0';

  traceStr(str);
}

//  La cha�ne s puis la valeur h�xa de u sont affich�es. Retour ligne auto.
void traceStrHex32(char *s,u32 u){
  traceStr(s);
  traceHex32(u);
}

//  Affichage des Codes Conditions NZCV avec le CPSR pass� en argument. Retour ligne auto.
//  Utiliser TRACECC dans le code assembleur (appel automatique � traceCC)
void traceCC(u32 u){
  char str[21]="CC: N=  Z=  C=  V= \n";
  if (u&(1<<31)) str[6]='1';  else str[6]='0';
  if (u&(1<<30)) str[10]='1'; else str[10]='0';
  if (u&(1<<29)) str[14]='1'; else str[14]='0';
  if (u&(1<<28)) str[18]='1'; else str[18]='0';
  traceStr(str);
}


