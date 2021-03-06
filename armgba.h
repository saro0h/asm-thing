/*
    "mini librairie" armgba :
    ARMGBA.H

      armgba.h    : En-t�te C (� inclure dans le projet C)
      armgba.c    : Les sous programmes en C
      asmarmgba.s : Les sous programmes en assembleur
      incarmgba.s : En-t�te assembleur (� inclure dans les fichiers assembleur)
*/


#ifndef ARMGBA_H
#define ARMGBA_H


//    ******** TYPEDEFS USUELS ********

typedef unsigned char      u8;
typedef unsigned short int u16;
typedef unsigned int       u32;
typedef signed char        s8;
typedef signed short int   s16;
typedef signed int         s32;


//    ******** CONSTANTES ET ADRESSES UTILES GBA ********

//      G�om�trie �cran
#define SCREENW        240          // Largeur �cran : nombre de pixels
#define SCREENH        160          // Hauteur �cran : nombre de pixels
#define SCREENLINE     480          // Nombre d'octets dans une ligne �cran (mode 3)

//      RAM vid�o
#define VRAM        0x06000000      // Origine de la RAM vid�o
#define VRAMLIMIT   0x06018000      // Premi�re adresse apr�s la RAM vid�o

//      "Registres" d'entr�es sorties pour piloter le mat�riel
#define REG_DISPCNT  *(volatile u16 *)0x04000000    // Mode graphique
#define REG_VCOUNT   *(volatile u16 *)0x04000006    // Compteur de Balayage vertical
#define REG_KEYINPUT *(volatile u16 *)0x04000130	// Lecture d'�tat des touches

 	                                // Masques 16 bit pour lecture des touches
	                                //  Touche GBA      Touche VBA (clavier PC azerty)
#define KEY_A    		0x0001		//  A               W
#define KEY_B    		0x0002		//  B               X
#define KEY_SELECT	    0x0004		//  Select          Backspace (au dessus de "Entr�e")
#define KEY_START		0x0008		//  Start           "Entr�e"
#define KEY_RIGHT		0x0010		//  Right           fl�che droite
#define KEY_LEFT		0x0020		//  Left            fl�che gauche
#define KEY_UP		    0x0040		//  Up              fl�che haut
#define KEY_DOWN		0x0080		//  Down            fl�che bas
#define KEY_SRIGHT	    0x0100		//  Shoulder Right  S
#define KEY_SLEFT		0x0200		//  Shoulder Left   Q


//    ******** VARIABLES GLOBALES ********

// Par d�faut la variable traceConsole est � 1 -> les fonctions trace sont actives
// Pour d�sactiver les fonctions trace il suffit de mettre traceConsole � 0
extern volatile int traceConsole;


//    ******** PROTOTYPES DES PROCEDURES EN C ********

//  Initialisation du mode graphique 3 (utilis� dans tous les exercices et pour le projet)
void setMode3();

//  Initialisation du mode graphique 4 (pour aventureux, mode palette avec contraintes...)
void setMode4();

//  Colorie un pixel (mode 3 seulement) Attention : Pas de contr�le de coordonn�es
void drawPixel(u32 x, u32 y, u16 color);

//  Attente de rafra�chissement �cran ( affichage effectif du contenu de la RAM vid�o )
void vSync();

//  Pour acc�der aux informations affich�es avec les fonctions trace :
//  dans le simulateur VBA ouvrir le menu Tools -> Logging...

//  La cha�ne dont l'adresse est pass�e en argument est affich�e (\n pour retour ligne)
void traceStr(char *s);

//  La valeur 32 bits pass�e en argument est affich�e en hexad�cimal. Retour ligne auto.
void traceHex32(u32 u);

//  La cha�ne s puis la valeur h�xa de u sont affich�es. Retour ligne auto.
void traceStrHex32(char *s,u32 u);

//  Affichage des Codes Conditions NZCV avec le CPSR pass� en argument. Retour ligne auto.
//  Utiliser TRACECC dans le code assembleur (appel automatique � traceCC)
void traceCC(u32 u);


//    ******** PROTOTYPES DES PROCEDURES EN ASSEMBLEUR ********

//  Calcul d'une couleur BGR 15 bits ( mode graphique 3 )
//  les arguments sont attendus sur l'intervalle  [0:255]
u16  asmMakeColor (u8 r, u8 g, u8 b);

//  Colorier un pixel avec une couleur ( mode graphique 3 )
//  Attention : Pas de contr�le de coordonn�es
void asmDrawPixel (u32 x, u32 y, u16 color);

//  Colorier un pixel avec une couleur ( mode graphique 3 )
//  Impl�mentation courte avec moins d'instructions
//  Attention : Pas de contr�le de coordonn�es
void asmDrawPixel_fast (u32 x, u32 y, u16 color);

//  Dessine un carr� rempli ( mode graphique 3 )
//  x,y coordonn�es du pixel sup�rieur gauche, size cot� du carr� (en nombre de pixels)
//  Attention : Pas de contr�le de coordonn�es ou de la taille
void asmDrawBlock (u32 x, u32 y, u32 size, u16 color);

int asmDrawShip(int x, int y);

void asmDrawRect(u16 * dest, u16 color, int w, int h);

#endif /* FIN ARMGBA_H */


