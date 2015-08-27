@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    "mini librairie" armgba :
@    ASMARMGBA.S
@
@      armgba.h    : En-t�te C (� inclure dans le projet C)
@      armgba.c    : Les sous programmes en C
@      asmarmgba.s : Les sous programmes en assembleur
@      incarmgba.s : En-t�te assembleur (� inclure dans les fichiers assembleur)
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


    .INCLUDE "incarmgba.s"


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ asmMakeColor : Calcul d'une couleur BGR 15 bits ( mode graphique 3 )
@                les arguments sont attendus sur l'intervalle  [0:255]
@
@ u16 asmMakeColor (u8 r, u8 g, u8 b);
@
@ Entr�es :     r = red, composante rouge     ( r0 )
@               g = green, composante verte   ( r1 )
@               b = blue, composante bleue    ( r2 )
@
@ Sortie :      couleur BGR 15 bits           ( r0 )
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	.ARM							@ Code ARM 32 bits (et non THUMB)
	.SECTION .iwram,"ax",%progbits  @ La proc�dure est mise en IWRAM
	.ALIGN							@ Aligner le code suivant sur les mots (adr. mult. 4)
	.GLOBAL  asmMakeColor			@ Exporter l'�tiquette pour l'�dition de liens
	.TYPE    asmMakeColor,function	@ Pr�cise le type d'objet (ici proc�dure ou fonction)

asmMakeColor:				@ Point entr�e de la proc�dure

                            @ Pas de push n�cessaire
                            @ (car aucun registre modifi� parmis r4-r11, lr)

	mov    r0,r0,lsr #3     @ D�calage : passage de 8 bits � 5 bits pour chaque composante
    mov    r1,r1,lsr #3
	mov    r2,r2,lsr #3
                            @ ici r0 contient d�j� le rouge sur 5 bits de poids faible ...
	orr    r0,r0,r1,lsl #5  @ on superpose dans le registre les 5 bits d�cal�s du vert
	orr    r0,r0,r2,lsl #10 @ on superpose encore les 5 bits d�cal�s du bleu
	
	                        @ Pas de push en d�but de proc�dure donc pas de pop � la fin
	bx      lr				@ Retour � la proc�dure appelante : lr = Link Register

@ ---------------------------------------------------------------------------


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ asmDrawPixel : Colorier un pixel avec une couleur ( mode graphique 3 )
@
@ void asmDrawPixel (u32 x, u32 y, u16 color);
@
@ Entr�es :     x = abscisse du pixel         ( r0 )
@               y = ordonn�e du pixel         ( r1 )
@			color = couleur BGR 15 bits       ( r2 )
@
@ Sortie  :  aucun registre, la m�moire vid�o est modifi�e
@
@ Remarque : PAS DE CONTROLE DE DEPASSEMENT DES BORDS DE l'ECRAN
@            LES COORDONNEES DOIVENT ETRE VALIDES
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	.ARM							@ Code ARM 32 bits (et non THUMB)
	.SECTION .iwram,"ax",%progbits  @ La proc�dure est mise en IWRAM
	.ALIGN							@ Aligner le code suivant sur les mots (adr. mult. 4)
	.GLOBAL asmDrawPixel			@ Exporter l'�tiquette pour l'�dition de liens
	.TYPE   asmDrawPixel,function	@ Pr�cise le type d'objet (ici proc�dure ou fonction)

asmDrawPixel:				@ Point entr�e de la proc�dure

	push	{r4-r5,lr}		@ Empiler les registres modifi�s par la proc�dure
	                        @ ( r0-r3 et r12 peuvent �tre modifi�s sans �tre restaur�s )

	ldr		r4,=SCREENLINE	@ r4 <- nombre d'octets dans une ligne �cran
	mul		r5,r4,r1		@ r5 <- r4 * y       Chaque pas vertical ajoute 480 octets
	add		r5,r5,r0,lsl #1	@ r5 <- r5 + 2 * x   Chaque pas horizontal ajoute 2 octets
	ldr		r3,=VRAM		@ r3 <- adresse de base de l'�cran
	add     r4,r5,r3		@ r4 (adresse pixel) <- r5(d�placement) + r3(adresse de base)
	strh    r2,[r4]			@ Ecrit 2 octets (Store Halfword) � l'adresse indiqu�e par r4

	pop		{r4-r5,lr}		@ Restauration des registres modifi�s
	bx      lr				@ Retour � l'appelant en utilisant le registre de lien
                            @ ( link register lr = r14 )

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ asmDrawPixel_fast : Colorier un pixel avec une couleur ( mode graphique 3 )
@                     Impl�mentation courte avec moins d'instructions
@
@ void asmDrawPixel_fast (u32 x, u32 y, u16 color);
@
@ Entr�es :     x = abscisse du pixel         ( r0 )
@               y = ordonn�e du pixel         ( r1 )
@			color = couleur BGR 15 bits       ( r2 )
@
@ Sortie  :  aucun registre, la m�moire vid�o est modifi�e
@
@ Remarque : PAS DE CONTROLE DE DEPASSEMENT DES BORDS DE l'ECRAN
@            LES COORDONNEES DOIVENT ETRE VALIDES
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	.ARM
	.SECTION .iwram,"ax",%progbits
	.ALIGN
	.GLOBAL asmDrawPixel_fast
	.TYPE   asmDrawPixel_fast,function

asmDrawPixel_fast:			@ Point entr�e de la proc�dure

                            @ On utilise que r0-r3 (pas besoin de push/pop)

    ldr		r3,=VRAM		@ r3 <- adresse de base de l'�cran
    add     r3,r3,r0,lsl #1 @ r3 <- r3 + 2 * x   Chaque pas horizontal ajoute 2 octets
	ldr		r0,=SCREENLINE	@ r0 <- nombre d'octets dans une ligne �cran
    mla     r3,r0,r1,r3     @ r3 <- (r0 * r1) + r3  mla = Multiply accumulate
	strh    r2,[r3]			@ Ecrit les 2 octets couleur � l'adresse indiqu�e par r3

	bx      lr				@ Retour � la proc�dure appelante : lr = Link Register



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ asmDrawBlock : Dessine un carr� rempli ( mode graphique 3 )
@
@ void asmDrawBlock (u32 x, u32 y, u32 size, u16 color);
@
@ Entr�es :     x = abscisse c�t� gauche      ( r0 )
@               y = ordonn�e c�t� sup�rieur   ( r1 )
@            size = c�t� du carr� (en pixels) ( r2 )
@			color = couleur BGR 15 bits       ( r3 )
@
@ Sortie  :  aucun registre, la m�moire vid�o est modifi�e
@
@ Remarque : PAS DE CONTROLE DE DEPASSEMENT DES BORDS DE l'ECRAN
@            LES COORDONNEES DOIVENT ETRE VALIDES
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	.ARM
	.SECTION .iwram,"ax",%progbits
	.ALIGN
	.GLOBAL  asmDrawBlock
	.TYPE    asmDrawBlock,function

asmDrawBlock:				 @ Point d'entr�e de la proc�dure

	push	{r4-r7}
                             @ r5 sera utilis� pour pointer vers le pixel courant
                             @ dans un balayage de la gauche vers la droite
                             @ par segments horizontaux successifs (de haut en bas)
                             @ r6 compteur horizontal
                             @ r7 compteur vertical

                             @ r5 : Calcul de l'adresse m�moire du pixel sup�rieur gauche
                             @ m�me principe que asmDrawPixel
	ldr		r4,=SCREENLINE
	mul		r5,r4,r1
	add		r5,r5,r0,lsl #1
	ldr		r1,=VRAM
	add     r5,r5,r1
 	                         @ r4 : nombre d'octet � ajouter pour passer d'une fin
	                         @ de segment horizontal au d�but du segment suivant
	sub		r4,r4,r2,lsl #1  @ r4 <- +480 (pixel en dessous) - 2*size (retour bord gauche)
	
	mov	r7,r2                @ Initialisation compteur boucle sur segments horizontaux
	loopYdb:                 @ D�but de boucle sur segments (balayage de haut en bas)
		mov	r6,r2            @ Initialisation compteur boucle sur pixels d'un segment
		loopXdb:             @ D�but de boucle sur pixels (balayage de gauche en droite)
			strh	r3,[r5]  @ Ecrit les deux octets de couleur � l'adresse courante
			add		r5,r5,#2 @ Augmente l'adresse courante de 2 octets (pixel � droite)
			subs	r6,r6,#1 @ D�cr�mente le compteur r6 et positionne le registre d'�tat
			bne		loopXdb  @ Boucler si le drapeaux Z du registre d'�tat n'est pas lev�
		add		r5,r5,r4	 @ On passe au pixel gauche du segment suivant
		subs	r7,r7,#1     @ D�cr�mente le compteur r7 et positionne le registre d'�tat
		bne		loopYdb      @ Boucler si le drapeaux Z du registre d'�tat n'est pas lev�
	
	pop		{r4-r7}			 @ Restauration des registres sauv�s sur la pile
	bx      lr				 @ Retour � la proc�dure appelante : lr = Link Register

@ ---------------------------------------------------------------------------




