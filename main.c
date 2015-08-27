#include "projet.h"

int main()
{

  int x=60, y=40;
  int i=0;
  int a=25;
  int b=0;
  int c=0;
  int count=0;
  int fin, finstart = 0;
  int findujeu = 1;
  int fina = 0;
  int tirencours =0;
  int tirencoursco = 0;
  int time=0;
  t_saucer saucer[NSAUCER];

  setMode3();
  drawImage(&start,0,0);
  while(finstart==0)
  {
  startTimers();
  if((~REG_KEYINPUT)&KEY_START)
  {
      finstart=1;
      asmDrawBlock(0, 0, 300, 0x0000);
  }
  
  }
  time = readTimers();
  asmAlea(time);
  setMode3();
  drawImage(&panorama,0,120);
  //drawImage(&ufo,0,10);
  
  //for (i=0;i<10;i++)
//drawPixel(asmRand()%240,asmRand()%160,0x7FFF);
//drawImage(&ufo,asmRand()%200,asmRand()%120);
for(i=0;i<NSAUCER;i++)
initSaucer(&saucer[i]);
  
asmDrawShip(x,y);
/*initSaucer(&saucer[0]); // Initialiser une soucoupe
startTimers(); // D�marrage du chronom�trage
drawSaucer(&saucer[0]); // Appel de la proc�dure � chronom�trer
traceHex32(readTimers()); // Affichage en console du temps �coul�
while (1);*/
while(1)
{
  while(fina==0)
  {
  vSync();
  for(i=0;i<NSAUCER;i++)
  eraseSaucer(&saucer[i]);
  asmDrawBlock(20+b-5,c,3, 0x0000);
  
 

asmDrawShipoff(x,y);

for (i=0;i<NSAUCER;i++)
moveSaucer(&saucer[i]);

if ((~REG_KEYINPUT)&KEY_RIGHT){

      if (x+18<SCREENW) x++;


    }
    if ((~REG_KEYINPUT)&KEY_LEFT){

      if (x>0) x--;

    }
    if ((~REG_KEYINPUT)&KEY_DOWN){
      if (y+8<SCREENH) y++;
    }
    if ((~REG_KEYINPUT)&KEY_UP){
      if (y>5) y--;
    }
    if ((~REG_KEYINPUT)&KEY_A){
      tirencours = 1;
    }
    
    if(tirencours==1)
    {

        if(tirencoursco==0)
        {
         b = x;
         c = y;
         tirencoursco=1;
        }
        

        for(i=0; i<10; i++)
        {
            //saucer[i].x = iii;
            if((saucer[i].x>b+5)&&(saucer[i].x<b+35))
            {
               if((saucer[i].y>c-5)&&(saucer[i].y<c+5))
                {
             //eraseSaucer(&saucer[i]);
             saucer[i].mort=1;

             //asmDrawBlock(20+b, c, 10, 0xFFFF);
         }
            }
            
        }
        
        if(b>223)
        {
            tirencours=0;
            b=0;
            c=0;
            tirencoursco=0;
            //asmDrawBlock(20+b-5, c, 3, 0x0000);
        }

        asmDrawBlock(20+b, c, 3, 0xFF00);
        
        

        
        b = b+5;
        
    }

for (i=0;i<NSAUCER;i++)
{
drawSaucer(&saucer[i]);
}
if(asmDrawShip(x,y)!=0){
if (a+18<SCREENW){
asmDrawBlock(a, 1, 3, 0xFFFF);
a = a+1;
}

else
{
    fina=1;
}
}

count=0;
for(i=0; i<NSAUCER; i++)
        {
            if(saucer[i].mort==1)
            {
                count++;
            }
}
if(count==NSAUCER)
{
 fina=1;
}

if(y>112)
{
    fina = 1;
}

asmDrawShip(x,y);
//drawImage("panorama",0,120);
    asmRectcpy(pixelAddress(0,160), pixelAddress(0,120), 2, 40);
    asmRectcpy(pixelAddress(0,120), pixelAddress(2,120), 238, 40);
    asmRectcpy(pixelAddress(238,120), pixelAddress(0,160), 2, 40);
    //asmRectcpy(pixelAddress(0,120), pixelAddress(2,120), 238, 40);
    
  }
if(count<NSAUCER)
{
drawImage(&over, 0, 0);
}
else drawImage(&victoire, 0, 0);

while(fina==1)
{
    if((~REG_KEYINPUT)&KEY_START)
  {
      fina=0;
      y=40;
      x=60;
      a=25;
      asmDrawBlock(0, 0, 300, 0x0000);
      setMode3();
  drawImage(&panorama,0,120);
for(i=0;i<NSAUCER;i++)
initSaucer(&saucer[i]);

asmDrawShip(x,y);
  }
    if((~REG_KEYINPUT)&KEY_SELECT)
  {
      findujeu=0;
  }
}
}

  return 0;
}

u16 * pixelAddress(int x,int y){
return (u16 *)(VRAM+2*x+480*y);
}

void drawImage(const t_image * bmp, int x, int y){
int xi,yi;
for (yi=0;yi<bmp->h;yi++)
for (xi=0;xi<bmp->w;xi++)
*pixelAddress(x+xi,y+yi) = bmp->img[xi+bmp->w*yi];
}

void initSaucer(t_saucer *s){
s->x=(asmRand()%200)+20; s->y=(asmRand()%100)+20;
s->dx=(asmRand()%3)-1; s->dy=(asmRand()%3)-1;
s->mort=0;
}

void moveSaucer(t_saucer *s){
if ( (asmRand()&31)==0){ // Avec une probabilit� de 1/32 ...
s->dx=(asmRand()%3)-1; // nouvelle direction au hasard
s->dy=(asmRand()%3)-1;
}
s->x+=s->dx; s->y+=s->dy; // D�placement selon le vecteur dx,dy
// Gestion des bords : en cas de d�passement on se replace et nouvelle direction au hasard
if (s->x>225){ s->x=225; s->dx=(asmRand()%3)-1; }
if (s->x<0) { s->x=0; s->dx=(asmRand()%3)-1; }
if (s->y>115){ s->y=115; s->dy=(asmRand()%3)-1; }
if (s->y<8) { s->y=8; s->dy=(asmRand()%3)-1; }
}
void eraseSaucer(t_saucer *s){
asmDrawRect(pixelAddress(s->x,s->y),0,ufo.w,ufo.h);
}
void drawSaucer(t_saucer *s){
    if(s->mort==0)
    {
asmDrawImage(VRAM+2*(s->x)+480*(s->y),&ufo,15,5);
//drawImage(&ufo,s->x,s->y);
}
}

void startTimers(){
*(volatile u16 *)0x0400010E=0; // Stopper timers 2 et 3 (remet leur compteur � valeur de d�part, ici 0)
*(volatile u16 *)0x0400010A=0;
*(volatile u16 *)0x0400010E=128|4; // Configurer et lancer les timers 2 et 3
*(volatile u16 *)0x0400010A=128|1;
}
unsigned int readTimers(){
// Retourner le temps �coul� sur 32 bits � partir des 2 compteurs 16 bits des timers 2 et 3 en cascade
return ( (*(volatile u16 *)0x0400010C) << 16 ) | *(volatile u16 *)0x04000108;
}

