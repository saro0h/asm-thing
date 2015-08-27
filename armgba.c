/*
    "mini librairie" armgba :
    ARMGBA.C

      armgba.h    : En-tête C (à inclure dans le projet C)
      armgba.c    : Les sous programmes en C
      asmarmgba.s : Les sous programmes en assembleur
      incarmgba.s : En-tête assembleur (à inclure dans les fichiers assembleur)
*/


#include "armgba.h"

//  Initialisation du mode graphique 3 (utilisé dans tous les exercices et pour le projet)
void setMode3(){
  REG_DISPCNT=0x0403;
}

//  Initialisation du mode graphique 4 (pour aventureux, mode palette avec contraintes...)
void setMode4(){
  REG_DISPCNT=0x0404;
}

//  Colorie un pixel (mode 3 seulement) Attention : Pas de contrôle de coordonnées
void drawPixel(u32 x, u32 y, u16 color){
  ((unsigned short*)VRAM)[x+y*SCREENW] = color;
}

//  Attente de rafraîchissement écran ( affichage effectif du contenu de la RAM vidéo )
void vSync()
{
    while(REG_VCOUNT >= SCREENH);   // Attendre VDraw  ( début du balayage écran )
    while(REG_VCOUNT < SCREENH);    // Attendre VBlank ( fin du balayage écran )
}

// Par défaut la variable traceConsole est à 1 -> les fonctions trace sont actives
// Pour désactiver les fonctions trace il suffit de mettre traceConsole à 0
volatile int traceConsole=1;

//  La chaîne dont l'adresse est passée en argument est affichée
//  Assembleur "inline" pour accéder à une instruction SWI : Software Interrupt
//  L'interruption 0xff ne fait pas partie du BIOS de la GBA (plantage GBA réelle)
//  C'est une adresse spéciale reconnue par le simulateur VBA pour capturer
//  des messages de débogage ( menu Tools -> Logging... )
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

//  La valeur 32 bits passée en argument est affichée en hexadécimal. Retour ligne auto.
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

//  La chaîne s puis la valeur héxa de u sont affichées. Retour ligne auto.
void traceStrHex32(char *s,u32 u){
  traceStr(s);
  traceHex32(u);
}

//  Affichage des Codes Conditions NZCV avec le CPSR passé en argument. Retour ligne auto.
//  Utiliser TRACECC dans le code assembleur (appel automatique à traceCC)
void traceCC(u32 u){
  char str[21]="CC: N=  Z=  C=  V= \n";
  if (u&(1<<31)) str[6]='1';  else str[6]='0';
  if (u&(1<<30)) str[10]='1'; else str[10]='0';
  if (u&(1<<29)) str[14]='1'; else str[14]='0';
  if (u&(1<<28)) str[18]='1'; else str[18]='0';
  traceStr(str);
}


