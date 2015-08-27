
	.INCLUDE "incarmgba.s"

alea: .WORD 0
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ Nom          : asmProc
@
@ Action       :    -----
@
@ Prototype C  : void asmProc()
@
@
@ Entr�es      :    -----
@ Sortie       :    -----
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@	.ARM
@	.SECTION .iwram,"ax",%progbits
@	.ALIGN
@	.GLOBAL  asmProc
@	.TYPE    asmProc, function
@
@   asmProc:
@	push	{r4-r11,lr}
@


    @ DEVELOPPER ICI le code assembleur de la proc�dure asmProc

@@@@@@@@@@@@@@@@@@@@@@@ SEGMENT DIAGONAL @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@	ldr r2,=0x06000000+2*120+480*80
@   ldr r3,=0x7FFF
@    ldr r0,=10 @ Compteur de boucle "r�p�ter 10 fois"
@    BoucleSeg: @ Etiquette de d�but de boucle
@    strh r3,[r2] @ Colorier le pixel courant
@    add r2,r2,#480 @ Adresse du pixel suivant (d�placement d'un pixel � droite)
@    add r2,r2,#2 @ pour la diagonale, une �tape en plus (add #482 impossible)
@    subs r0,r0,#1 @ D�cr�menter le compteur de boucle et mettre NZCV � jour
@    bne BoucleSeg
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ldr r2,=0x06000000+2*120+480*80 @ Adresse de d�part...
@
@mov r2, #240
@mul r2, r1, r2
@add r2, r2, r0
@add r2, r2, r2
@add r2, r2, #0x06000000
@
@add r2,r2,#4 @ d�placement de 2 pixels � droite
@ldr r3,=0x5294 @ couleur grise
@strh r3,[r2] @ colorier un pixel
@add r2,r2,#480 @ d�placement d'1 pixel vers le bas
@ldr r0,=6 @ on va colorier un segment horizontal de 6 pixels
@
@BoucleSeg1: @ d�but de 1�re boucle
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BoucleSeg1 @ r�p�ter tant que compteur non nul
@
@ldr r3,=0x7FE0 @ couleur cyan (bleu + vert)
@strh r3,[r2] @ colorier un pixel (cockpit)
@add r2,r2,#480-16 @ d�placement d'1 pixel vers le bas et de 8 � gauche
@ldr r3,=0x001F @ couleur rouge
@strh r3,[r2] @ colorier un pixel (flamme r�acteur)
@add r2,r2,#2 @ d�placement d'1 pixel � droite
@ldr r3,=0x03FF @ couleur jaune
@strh r3,[r2] @ colorier un pixel (flamme r�acteur)
@add r2,r2,#2 @ d�placement d'1 pixel � droite
@ldr r3,=0x5294 @ couleur grise
@ldr r0,=8 @ on va colorier un segment horizontal de 8 pixels
@
@BoucleSeg2: @ d�but de 2�me boucle (nom d'�tiquette diff�rent)
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BoucleSeg2 @ r�p�ter tant que compteur non nul
@
@
@	pop		{r4-r11,lr}
@	bx      lr
@
@ ---------------------------------------------------------------------------


@.ARM
@	.SECTION .iwram,"ax",%progbits
@	.ALIGN
@	.GLOBAL  asmProcEff
@	.TYPE    asmProcEff, function
@
@
@asmProcEff:
@	push	{r4-r11,lr}
@
@
@mov r2, #240
@mul r2, r1, r2
@add r2, r2, r0
@add r2, r2, r2
@add r2, r2, #0x06000000
@
@add r2,r2,#4 @ d�placement de 2 pixels � droite
@ldr r3,=0x0000 @ couleur grise
@strh r3,[r2] @ colorier un pixel
@add r2,r2,#480 @ d�placement d'1 pixel vers le bas
@ldr r0,=6 @ on va colorier un segment horizontal de 6 pixels
@
@BouclSeg1: @ d�but de 1�re boucle
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BouclSeg1 @ r�p�ter tant que compteur non nul
@
@ldr r3,=0x7FE0 @ couleur cyan (bleu + vert)
@strh r3,[r2] @ colorier un pixel (cockpit)
@add r2,r2,#480-16 @ d�placement d'1 pixel vers le bas et de 8 � gauche
@ldr r3,=0x001F @ couleur rouge
@strh r3,[r2] @ colorier un pixel (flamme r�acteur)
@add r2,r2,#2 @ d�placement d'1 pixel � droite
@ldr r3,=0x03FF @ couleur jaune
@strh r3,[r2] @ colorier un pixel (flamme r�acteur)
@add r2,r2,#2 @ d�placement d'1 pixel � droite
@ldr r3,=0x5294 @ couleur grise
@ldr r0,=8 @ on va colorier un segment horizontal de 8 pixels
@
@BouclSeg2: @ d�but de 2�me boucle (nom d'�tiquette diff�rent)
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BouclSeg2 @ r�p�ter tant que compteur non nul
@
@
@	pop		{r4-r11,lr}
@	bx      lr
@
@ ---------------------------------------------------------------------------

@
	.ARM
	.SECTION .iwram,"ax",%progbits
	.ALIGN
	.GLOBAL  asmDrawShip
	.TYPE    asmDrawShip, function

    asmDrawShip:
	push	{r4-r11,lr}



    @ DEVELOPPER ICI le code assembleur de la proc�dure asmProc
@
@@@@@@@@@@@@@@@@@@@@@@@ SEGMENT DIAGONAL @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@	ldr r2,=0x06000000+2*120+480*80
@   ldr r3,=0x7FFF
@    ldr r0,=10 @ Compteur de boucle "r�p�ter 10 fois"
@    BoucleSeg: @ Etiquette de d�but de boucle
@    strh r3,[r2] @ Colorier le pixel courant
@    add r2,r2,#480 @ Adresse du pixel suivant (d�placement d'un pixel � droite)
@    add r2,r2,#2 @ pour la diagonale, une �tape en plus (add #482 impossible)
@    subs r0,r0,#1 @ D�cr�menter le compteur de boucle et mettre NZCV � jour
@    bne BoucleSeg
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ldr r2,=0x06000000+2*120+480*80 @ Adresse de d�part...

@Calcul de l'adresse
mov r5, #0

mov r2, #240
mul r2, r1, r2
add r2, r2, r0
add r2, r2, r2
add r2, r2, #0x06000000

add r2,r2,#14 @ d�placement de 7 pixels � droite
ldr r3,=0x001F @ verte
ldr r0,=4 @ on va colorier un segment horizontal de 4 pixels

@ 1�re ligne verte
BoucleSeg1o: @ d�but de 1�re boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg1o @ r�p�ter tant que compteur non nul

add r2,r2,#480
sub r2,r2,#10
ldr r0,=6 @ on va colorier un segment horizontal de 6 pixels

@ 2eme ligne verte
BoucleSeg2o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg2o @ r�p�ter tant que compteur non nul



add r2,r2,#480
sub r2,r2,#16
ldr r3,=0x7C00 @ bleu
ldr r0,=10 @ on va colorier un segment horizontal de 10 pixels

@ 3eme ligne bleu
BoucleSeg3o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg3o @ r�p�ter tant que compteur non nul

add r2,r2,#480-20
ldr r0,=10 @ on va colorier un segment horizontal de 10 pixels

@ 4eme ligne bleu
BoucleSeg4o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg4o @ r�p�ter tant que compteur non nul


add r2,r2,#480-24
ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels

@ 5eme ligne bleu/vert

BoucleSeg5o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg5o @ r�p�ter tant que compteur non nul

ldr r3,=0x03E0  @ vert
ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels

BoucleSeg6o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg6o @ r�p�ter tant que compteur non nul

ldr r3,=0x7C00 @ bleu
ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels

BoucleSeg7o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg7o @ r�p�ter tant que compteur non nul

ldr r3,=0x03E0  @ vert
ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels

BoucleSeg8o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg8o @ r�p�ter tant que compteur non nul

ldr r3,=0x7C00 @ bleu
ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels

BoucleSeg9o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg9o @ r�p�ter tant que compteur non nul

ldr r3,=0x03E0  @ vert
ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels

BoucleSeg10o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg10o @ r�p�ter tant que compteur non nul

ldr r3,=0x7C00 @ bleu
ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels

BoucleSeg11o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg11o @ r�p�ter tant que compteur non nul


@ 6eme ligne bleu/vert

add r2,r2,#480
sub r2,r2,#28
ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels

BoucleSeg12o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg12o @ r�p�ter tant que compteur non nul

ldr r3,=0x03E0  @ vert
ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels

BoucleSeg13o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg13o @ r�p�ter tant que compteur non nul

ldr r3,=0x7C00 @ bleu
ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels

BoucleSeg14o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg14o @ r�p�ter tant que compteur non nul

ldr r3,=0x03E0  @ vert
ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels

BoucleSeg15o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg15o @ r�p�ter tant que compteur non nul

ldr r3,=0x7C00 @ bleu
ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels

BoucleSeg16o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg16o @ r�p�ter tant que compteur non nul

ldr r3,=0x03E0  @ vert
ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels

BoucleSeg17o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg17o @ r�p�ter tant que compteur non nul

ldr r3,=0x7C00 @ bleu
ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels

BoucleSeg18o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg18o @ r�p�ter tant que compteur non nul


add r2,r2,#480
sub r2,r2,#32
ldr r3,=0x7C00 @ bleu
ldr r0,=18 @ on va colorier un segment horizontal de 18 pixels

@ 7eme ligne bleu
BoucleSeg19o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg19o @ r�p�ter tant que compteur non nul

add r2,r2,#480
sub r2,r2,#36
ldr r0,=18 @ on va colorier un segment horizontal de 18 pixels

@ 7eme ligne bleu
BoucleSeg20o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg20o @ r�p�ter tant que compteur non nul


add r2,r2,#480
sub r2,r2,#34
ldr r3,=0x001F @ jaune
ldr r0,=16 @ on va colorier un segment horizontal de 18 pixels

@ 8eme ligne jaune
BoucleSeg21o: @ d�but de 2eme boucle
ldrh r4,[r2]
orr r5,r5,r4
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg21o @ r�p�ter tant que compteur non nul

mov r0,r5
@

	pop		{r4-r11,lr}
	bx      lr

@ ---------------------------------------------------------------------------




@
	.ARM
	.SECTION .iwram,"ax",%progbits
	.ALIGN
	.GLOBAL  asmDrawShipoff
	.TYPE    asmDrawShipoff, function

    asmDrawShipoff:
	push	{r4-r11,lr}



    @ DEVELOPPER ICI le code assembleur de la proc�dure asmProc
@
@@@@@@@@@@@@@@@@@@@@@@@ SEGMENT DIAGONAL @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@	ldr r2,=0x06000000+2*120+480*80
@   ldr r3,=0x7FFF
@    ldr r0,=10 @ Compteur de boucle "r�p�ter 10 fois"
@    BoucleSeg: @ Etiquette de d�but de boucle
@    strh r3,[r2] @ Colorier le pixel courant
@    add r2,r2,#480 @ Adresse du pixel suivant (d�placement d'un pixel � droite)
@    add r2,r2,#2 @ pour la diagonale, une �tape en plus (add #482 impossible)
@    subs r0,r0,#1 @ D�cr�menter le compteur de boucle et mettre NZCV � jour
@    bne BoucleSeg
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ldr r2,=0x06000000+2*120+480*80 @ Adresse de d�part...

@Calcul de l'adresse

mov r2, #240
mul r2, r1, r2
add r2, r2, r0
add r2, r2, r2
add r2, r2, #0x06000000

add r2,r2,#14 @ d�placement de 7 pixels � droite
ldr r3,=0x0000 @ noir
ldr r0,=4 @ on va colorier un segment horizontal de 4 pixels

@ 1�re ligne verte
BoucleSeg1eff: @ d�but de 1�re boucle
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg1eff @ r�p�ter tant que compteur non nul

add r2,r2,#480
sub r2,r2,#10
ldr r0,=6 @ on va colorier un segment horizontal de 6 pixels

@ 2eme ligne verte
BoucleSeg2eff: @ d�but de 2eme boucle
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg2eff @ r�p�ter tant que compteur non nul



add r2,r2,#480
sub r2,r2,#16
ldr r3,=0x0000 @ noir
ldr r0,=10 @ on va colorier un segment horizontal de 10 pixels

@ 3eme ligne bleu
BoucleSeg3eff: @ d�but de 2eme boucle
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg3eff @ r�p�ter tant que compteur non nul

add r2,r2,#480-20
ldr r0,=10 @ on va colorier un segment horizontal de 10 pixels

@ 4eme ligne bleu
BoucleSeg4eff: @ d�but de 2eme boucle
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg4eff @ r�p�ter tant que compteur non nul


add r2,r2,#480-24
ldr r0,=14 @ on va colorier un segment horizontal de 2 pixels

@ 5eme ligne bleu/vert

BoucleSeg5eff: @ d�but de 2eme boucle
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg5eff @ r�p�ter tant que compteur non nul
@
@ldr r3,=0x03E0  @ vert
@ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels
@
@BoucleSeg6o: @ d�but de 2eme boucle
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BoucleSeg6o @ r�p�ter tant que compteur non nul
@
@ldr r3,=0x7C00 @ bleu
@ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels
@
@BoucleSeg7o: @ d�but de 2eme boucle
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BoucleSeg7o @ r�p�ter tant que compteur non nul
@
@ldr r3,=0x03E0  @ vert
@ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels
@
@BoucleSeg8o: @ d�but de 2eme boucle
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BoucleSeg8o @ r�p�ter tant que compteur non nul
@
@ldr r3,=0x7C00 @ bleu
@ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels
@
@BoucleSeg9o: @ d�but de 2eme boucle
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BoucleSeg9o @ r�p�ter tant que compteur non nul
@
@ldr r3,=0x03E0  @ vert
@ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels
@
@BoucleSeg10o: @ d�but de 2eme boucle
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BoucleSeg10o @ r�p�ter tant que compteur non nul
@
@ldr r3,=0x7C00 @ bleu
@ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels
@
@BoucleSeg11o: @ d�but de 2eme boucle
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BoucleSeg11o @ r�p�ter tant que compteur non nul
@

@ 6eme ligne bleu/vert

add r2,r2,#480
sub r2,r2,#28
ldr r0,=14 @ on va colorier un segment horizontal de 2 pixels

BoucleSeg12eff: @ d�but de 2eme boucle
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg12eff @ r�p�ter tant que compteur non nul

@ldr r3,=0x03E0  @ vert
@ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels
@
@BoucleSeg13eff: @ d�but de 2eme boucle
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BoucleSeg13eff @ r�p�ter tant que compteur non nul
@
@ldr r3,=0x7C00 @ bleu
@ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels
@
@BoucleSeg14eff: @ d�but de 2eme boucle
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BoucleSeg14eff @ r�p�ter tant que compteur non nul
@
@ldr r3,=0x03E0  @ vert
@ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels
@
@BoucleSeg15eff: @ d�but de 2eme boucle
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BoucleSeg15eff @ r�p�ter tant que compteur non nul
@
@ldr r3,=0x7C00 @ bleu
@ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels
@
@BoucleSeg16eff: @ d�but de 2eme boucle
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BoucleSeg16eff @ r�p�ter tant que compteur non nul
@
@ldr r3,=0x03E0  @ vert
@ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels
@
@BoucleSeg17eff: @ d�but de 2eme boucle
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BoucleSeg17eff @ r�p�ter tant que compteur non nul
@
@ldr r3,=0x7C00 @ bleu
@ldr r0,=2 @ on va colorier un segment horizontal de 2 pixels
@
@BoucleSeg18eff: @ d�but de 2eme boucle
@strh r3,[r2] @ colorier un pixel du segment
@add r2,r2,#2 @ adresse pixel suivant
@subs r0,r0,#1 @ d�cr�menter compteur de boucle...
@bne BoucleSeg18eff @ r�p�ter tant que compteur non nul
@

add r2,r2,#480
sub r2,r2,#32
ldr r3,=0x0000 @ bleu
ldr r0,=18 @ on va colorier un segment horizontal de 18 pixels

@ 7eme ligne bleu
BoucleSeg19eff: @ d�but de 2eme boucle
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg19eff @ r�p�ter tant que compteur non nul

add r2,r2,#480
sub r2,r2,#36
ldr r0,=18 @ on va colorier un segment horizontal de 18 pixels

@ 7eme ligne bleu
BoucleSeg20eff: @ d�but de 2eme boucle
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg20eff @ r�p�ter tant que compteur non nul

add r2,r2,#480
sub r2,r2,#34
ldr r3,=0x0000 @ noir
ldr r0,=16 @ on va colorier un segment horizontal de 18 pixels

@ 8eme ligne jaune
BoucleSeg21eff: @ d�but de 2eme boucle
strh r3,[r2] @ colorier un pixel du segment
add r2,r2,#2 @ adresse pixel suivant
subs r0,r0,#1 @ d�cr�menter compteur de boucle...
bne BoucleSeg21eff @ r�p�ter tant que compteur non nul

@

	pop		{r4-r11,lr}
	bx      lr

@ ---------------------------------------------------------------------------


.ARM
.SECTION .iwram,"ax",%progbits
.ALIGN
.GLOBAL  asmRectcpy
.TYPE    asmRectcpy, function

asmRectcpy:
    push   {r4,r5}
    rcBoucleV:          @ Boucle verticale : r3 servira de compteur
        mov     r4,r2             @ Init boucle horizontale : r4 sert de compteur
        rcBoucleH:
       ldrh    r5,[r1]            @ transfert depuis adresse source r1
       strh    r5,[r0]            @ transfert vers adresse destination r0
       add     r1,r1,#2           @ src : pixel horizontal suivant (+2 octets)
       add     r0,r0,#2           @ dest : pixel horizontal suivant (+2 octets)
       subs    r4,r4,#1           @ d�cr�menter compteur boucle horizontale
       bne     rcBoucleH          @ boucler pixel horizontal suivant
        sub     r1,r1,r2,lsl #1   @ source : Retour en d�but de segment horizontal
        add     r1,r1,#SCREENLINE @          Puis ligne en dessous (SCREENLINE=480 voir incarmgba.s)
        sub     r0,r0,r2,lsl #1   @ dest. : Retour en d�but de segment horizontal
        add     r0,r0,#SCREENLINE @          Puis ligne en dessous
        subs    r3,r3,#1          @ d�cr�menter compteur boucle verticale
        bne     rcBoucleV         @ boucler ligne suivante
    pop    {r4,r5}
    bx     lr





@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ POUR CHAQUE NOUVELLE PROCEDURE ASSEMBLEUR :
@
@ COPIER LE MODELE DE PROCEDURE ci dessus ( asmProc )
@
@ DONNER UN NOM et d�terminer le prototype C correspondant
@ AJOUTER LE PROTOTYPE C dans le fichier en-t�te projet.h
@
@ Modifier le nom et le prototype dans le bloc commentaire qui pr�c�de le code assembleur
@ Modifier le nom dans le code assembleur au niveau de
@   - La directive    .GLOBAL asmProc              ->      .GLOBAL asmMaProcedure
@   - La directive    .TYPE asmProc, function      ->      .TYPE asmMaProcedure, function
@   - L'�tiquette   asmProc:                       ->      asmMaProcedure:
@
@ CODER entre le   "push ..."  de d�but de proc�dure et le   "pop ... / bx lr" de fin
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


@@@@@ASMSRAND@@@@@

.ARM
.SECTION .iwram,"ax",%progbits
.ALIGN
.GLOBAL  asmSRand
.TYPE    asmSRand, function


asmSRand:
    LDR r1,=alea
    STR r0, [r1]
    bx     lr


@@@@@ASMRAND@@@@@

.ARM
.SECTION .iwram,"ax",%progbits
.ALIGN
.GLOBAL  asmRand
.TYPE    asmRand, function


asmRand:
    LDR r1,=alea
    LDR r0, [r1]
    LDR R3,= 1664525
    LDR R2,= 1013904223
    MUL r0, r3, r0
    ADD r0, r0, r2
    STR r0, [r1]
    MOV r0, r0, LSR#16
    bx     lr

@@@@@ASMDrawRect@@@@@

.ARM
.SECTION .iwram,"ax",%progbits
.ALIGN
.GLOBAL  asmDrawRect
.TYPE    asmDrawRect, function


asmDrawRect:
    push   {r4}
    dcBoucleV:          @ Boucle verticale : r3 servira de compteur
        mov     r4,r2             @ Init boucle horizontale : r4 sert de compteur
        dcBoucleH:
       strh    r1,[r0]            @ transfert depuis adresse source r1
       add     r0,r0,#2           @ src : pixel horizontal suivant (+2 octets)
       subs    r4,r4,#1           @ d�cr�menter compteur boucle horizontale
       bne     dcBoucleH          @ boucler pixel horizontal suivant
        sub     r0,r0,r2,lsl #1   @ source : Retour en d�but de segment horizontal
        add     r0,r0,#SCREENLINE @          Puis ligne en dessous (SCREENLINE=480 voir incarmgba.s)
        subs    r3,r3,#1          @ d�cr�menter compteur boucle verticale
        bne     dcBoucleV         @ boucler ligne suivante
    pop    {r4}
    bx     lr

@@@@@ASMDrawRect@@@@@

.ARM
.SECTION .iwram,"ax",%progbits
.ALIGN
.GLOBAL  asmAlea
.TYPE    asmAlea, function


asmAlea:

        mov    r1,r0            @ transfert depuis adresse source r1
        ldrh   r1, =alea
        
       
    bx lr
    
@@@@@ASMDrawRect@@@@@

.ARM
.SECTION .iwram,"ax",%progbits
.ALIGN
.GLOBAL  asmDrawImage
.TYPE    asmDrawImage, function


asmDrawImage :
push {r4 - r5}
bcol :           mov r4,r2
          bligne : ldrh r5,[r1]
               cmp r5,#0
                  bne copie
copie :           strh r5, [r0]
               add r1,r1,#2
               add r0,r0,#2
               subs r4,r4,#1
               bne bligne
          sub r0,r0,r2,lsl#1
          add r0,r0,#480
          subs r3,r3,#1
          bne bcol
pop {r4 - r5}
bx lr




