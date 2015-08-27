#ifndef PROJET_H
#define PROJET_H

#include "armgba.h"

//     Structures et Typedefs
typedef struct{
int w,h;
u16 img[];
}t_image;

typedef struct {
int x,y,dx,dy; // Position du coin supérieur gauche de la soucoupe (x,y) et vecteur déplacement (dx,dy)
int mort;
} t_saucer;


//     Constantes
extern const t_image panorama;
extern const t_image ufo;
extern const t_image start;
extern const t_image over;
extern const t_image victoire;
#define NSAUCER 10
//     Variables globales

//     Prototypes des procédures en C

//     Prototypes des procédures en assembleur (pour appel depuis code C)

void asmProc(int x,int y);
void asmProcEff(int x, int y);
void asmProcOVNI(int x, int y);
void asmProcOVNIEff(int x, int y);
void asmRectcpy(u16 * dest, u16 * src, int w, int h);
void drawImage(const t_image * bmp, int x, int y);
u16 * pixelAddress(int x,int y);
void asmSRand();
int asmRand();
int asmAlea();
void initSaucer(t_saucer *s);
void moveSaucer(t_saucer *s);
void eraseSaucer(t_saucer *s);
void drawSaucer(t_saucer *s);
void asmDrawImage(u16 * dest, u16 * img, int w, int h);

void startTimers();
unsigned int readTimers();




#endif /* PROJET_H */


