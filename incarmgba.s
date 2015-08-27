@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    "mini librairie" armgba :
@    INCARMGBA.S
@
@      armgba.h    : En-t�te C (� inclure dans le projet C)
@      armgba.c    : Les sous programmes en C
@      asmarmgba.s : Les sous programmes en assembleur
@      incarmgba.s : En-t�te assembleur (� inclure dans les fichiers assembleur)
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ CONSTANTES UTILES
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    .EQU SCREENW,       240         @ Largeur �cran : nombre de pixels
    .EQU SCREENH,       160         @ Hauteur �cran : nombre de pixels
    .EQU SCREENLINE,    480         @ Nombre d'octets dans une ligne �cran (mode 3)

	.EQU VRAM,			0x06000000	@ Adresse Video RAM
	.EQU VRAMLIMIT,		0x06018000	@ 1ere Adresse apr�s Video RAM
	
	.EQU REG_KEYINPUT,	0x04000130	@ Adresse de lecture d'�tat des touches
	
 	                                @ Masques 16 bit pour lecture des touches
	                                @  Touche GBA      Touche VBA (clavier PC)
	.EQU KEY_A,    		0x0001		@ A               W
	.EQU KEY_B,    		0x0002		@ B               X
	.EQU KEY_SELECT,	0x0004		@ Select          Backspace (au dessus de "Entr�e")
	.EQU KEY_START,		0x0008		@ Start           "Entr�e"
	.EQU KEY_RIGHT,		0x0010		@ Right           fl�che droite
	.EQU KEY_LEFT,		0x0020		@ Left            fl�che gauche
	.EQU KEY_UP,		0x0040		@ Up              fl�che haut
	.EQU KEY_DOWN,		0x0080		@ Down            fl�che bas
	.EQU KEY_SRIGHT,	0x0100		@ Shoulder Right  S
	.EQU KEY_SLEFT,		0x0200		@ Shoulder Left   Q
	
	
	


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ MACROS DE "DEBOGAGE"
@
@   WATCH         : attend le rafra�chissement de l'�cran avant de poursuivre
@
@   KEYWATCH  key : WATCH si la touche "key" est appuy�e
@                   avec key = nom bouton GBA ( A ou B ou SELECT ou START ... )
@                   Ne pas utiliser plusieurs KEYWATCH avec le m�me key
@
@   KEYWATCH      : Par d�faut c'est la touche START ( entr�e sur le clavier PC )
@
@   KEYPAUSE  key : Suspend l'�x�cution du programme au niveau du KEYPAUSE
@                   tant que la touche "key" est appuy�e
@                   avec key = nom bouton GBA ( A ou B ou SELECT ou START ... )
@                   Ne pas utiliser plusieurs KEYPAUSE avec le m�me key
@
@   KEYPAUSE      : Par d�faut c'est la touche START ( entr�e sur le clavier PC )
@
@   KEYBREAK  key : Suspend l'�x�cution du programme au niveau du KEYBREAK
@                   Ne reprend que si la touche "key" est appuy�e puis relach�e
@                   avec key = nom bouton GBA ( A ou B ou SELECT ou START ... )
@                   Ne pas utiliser plusieurs KEYBREAK avec le m�me key
@
@   KEYBREAK      : Par d�faut c'est la touche START ( entr�e sur le clavier PC )
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.macro WATCH
			PRECALLC
			CALLC vSync
.endm

.macro KEYWATCH label=START
			push	{r11,r12}
			mrs		r11,cpsr
			ldr 	r12,=REG_KEYINPUT
			ldrh	r12,[r12]
			ands	r12,#KEY_\label
			bne		keywatchend\label
			WATCH
			keywatchend\label:
			msr		cpsr_f,r11
			pop		{r11,r12}
.endm

.macro KEYPAUSE label=START
			push	{r11,r12}
			mrs		r11,cpsr
			keypauseloop\label:
			ldr 	r12,=REG_KEYINPUT
			ldrh	r12,[r12]
			ands	r12,#KEY_\label
			beq		keypauseloop\label
			msr		cpsr_f,r11
			pop		{r11,r12}
.endm

.macro KEYBREAK label=START
			push	{r11,r12}
			mrs		r11,cpsr
			keybreakloop0\label:
			ldr 	r12,=REG_KEYINPUT
			ldrh	r12,[r12]
			ands	r12,#KEY_\label
			bne		keybreakloop0\label
			keybreakloop1\label:
			ldr 	r12,=REG_KEYINPUT
			ldrh	r12,[r12]
			ands	r12,#KEY_\label
			beq		keybreakloop1\label
			msr		cpsr_f,r11
			pop		{r11,r12}
.endm

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ MACRO POUR APPEL DE PROCEDURE C DEPUIS LE CODE ARM
@
@ Sauve et restaure le contexte modifiable par l'appel : r0-r3, r12, flags NZCV
@ Restaure �galement r0, ne convient donc pas pour les fonctions
@
@ Utilisation :
@
@	PRECALLC	   @ Pr�parer appel C
@	mov r0,rm	   @ Si n�cessaire (si la proc�dure C prend de arguments)
@   mov r1,rn      @ Charger les registres r0 � r3 pour passer les 1ers arguments (<=4)
@   mov r2,rp      @ pour plus de 4 arguments -> APCS = ARM Procedure Call Standard
@   mov r3,rq
@	CALLC procname @ appel en branchement absolu (bx r12)
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.macro PRECALLC
	push	{r0-r3,r12}		@ Empiler les "scratch registers" (store multiple)
	mrs		r12,cpsr		@ Move from Status Register : pour r�cup�ration des flags NZCV
	push	{r12,lr}		@ Empiler �tat du Status Register et Link Register
	ldr		r12,[sp,#24]    @ R�cup�rer valeur initiale de r12 (depuis la pile)
.endm


.macro CALLC funcname
	ldr		r12,=\funcname	@ R�cup�ration adresse fonction
	mov		lr,pc			@ Copier adresse de retour dans Link Register
	bx		r12				@ APPEL
	pop		{r12,lr}   	 	@ Adresse de retour, on d�pile en sens inverse
	msr		cpsr_f,r12		@ Move to Status Register : restaurer les flags NZCV
	pop		{r0-r3,r12} 	@ On d�pile en sens inverse ... (load multiple)
.endm


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ DONNEES ET MACROS POUR TRACER LES REGISTRES
@
@ Utilisation :
@
@	TRACEREG	rn	@ Pour afficher en console le contenu de rn (r0-r15)
@	TRACECC			@ Pour afficher l'�tat des codes condition NZCV
@	TRACENL			@ Pour sauter une ligne (New Line)
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ NE PAS EDITER LES CHAINES (ALIGNEMENT)
        .SECTION .iwram,"ax",%progbits
		.ALIGN
LABr0:	.string "r0="
LABr1:	.string "r1="
LABr2:	.string "r2="
LABr3:	.string "r3="
LABr4:	.string "r4="
LABr5:	.string "r5="
LABr6:	.string "r6="
LABr7:	.string "r7="
LABr8:	.string "r8="
LABr9:	.string "r9="
LABr10:	.string "r10=","  "
LABr11:	.string "r11=","  "
LABr12:	.string "r12=","  "
LABr13:	.string "r13(sp)=","  "
LABr14:	.string "r14(lr)=","  "
LABr15:	.string "r15(pc)=","  "
LABsp:	.string "r13(sp)=","  "
LABlr:	.string "r14(lr)=","  "
LABpc:	.string "r15(pc)=","  "
LABNL:	.string "\n"," "
		.ALIGN

.macro TRACEREG reg
	PRECALLC
	mov r1,\reg
	ldr	r0,=LAB\reg
	CALLC traceStrHex32
.endm
	
.macro TRACECC
	PRECALLC
	mrs r0,cpsr
	CALLC traceCC
.endm

.macro TRACENL
	PRECALLC
	ldr	r0,=LABNL
	CALLC traceStr
.endm


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ MACROS POUR PLACER LES CONSTANTES NUMERIQUES (utilis�es par ldr r0,=Cst)
@
@ Utilisation : n�cessaire seulement en cas d'erreur
@       "Error: invalid literal constant: pool needs to be closer"
@
@	P0OL       @  Apr�s la fin de proc�dure,
@              @  ou si l'erreur persiste
@              @      dans le code proche du ldr en cause (apr�s)
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.macro POOL
	b    1f
	.ltorg
	1:
.endm


