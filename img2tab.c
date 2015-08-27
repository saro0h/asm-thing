/*
   Programme de conversion d'image format BMP TGA ou PCX
   en fichier source déclarant un tableau image compatible 
   avec le mode3 de la GBA (BGR 15 bits, 2 octets par pixel)

   Lancer le programme, sélectionner le fichier image, confirmer
   Un fichier source .c du même nom que le fichier image est généré
   Eviter les noms de fichier avec espaces ou accents: si nécessaire renommer
   L'image est affichée au centre de l'écran entourée d'un cadre blanc
   Cliquer sur la fenêtre ou appuyer une touche pour terminer
   
   Exemple : selectionner ufo.bmp génère ufo.c
   Attention si un fichier ufo.c existe déjà il est écrasé
   
   Voir TP3 pour la méthode d'utilisation du résultat
   
   Ecole centrale d'électronique (ECE)  2008

*/

#include <allegro.h>
#include <string.h>

void initAllegro();

int main(int argc, char *argv[])
{
   int confirme;
   int x,y,r,g,b,colorRGB24,colorBGR15;
   char path[500];
   BITMAP * img=NULL;
   FILE * f;
   
   initAllegro();
   
   // Choix du fichier image à convertir dans le tampon  path
   confirme=file_select_ex("Choisir un fichier image (.bmp .tga ou .pcx)",
                        path,"BMP;TGA;PCX",sizeof(path),0,0);
                        
   if (confirme){
     
      // Charger image
      img=load_bitmap(path,NULL);
      
      if (img){
        
         // Ouverture en écriture du fichier de sortie avec extension .c
         replace_extension(path,path,"c",sizeof(path));
         f=fopen(path,"w");
         
         if (f){
           
            // On "enlève" l'extension en tronquant la chaîne au dernier '.'
            *strrchr(path,'.')='\0';
            
            // Début des déclarations dans le fichier de sortie...
            fprintf(f,"#include \"projet.h\"\n\n");
            fprintf(f,"const t_image %s={%d,%d,{\n",
                    get_filename(path),img->w,img->h);
            
            // Pour chaque pixel image...
            for (y=0;y<img->h;y++){
               for (x=0;x<img->w;x++){
                 
                  // Décomposer la couleur en 3 composantes primaires R G B
                  colorRGB24=getpixel(img,x,y);
                  r=getr(colorRGB24);
                  g=getg(colorRGB24);
                  b=getb(colorRGB24);
                  
                  // Transformation du RGB 24 bits en BGR 15 bits
                  // voir TD1 pour les détails de cette formule
                  colorBGR15=((b>>3)<<10)|((g>>3)<<5)|(r>>3);
                  
                  // On écrit la donnée en hexadécimal dans le fichier de sortie
                  fprintf(f,"0x%04x",colorBGR15);
                  if (!(x==img->w-1 && y==img->h-1))
                     fprintf(f,",");
               }
               fprintf(f,"\n");  // Retour ligne à la fin de chaque ligne image
            }
            fprintf(f,"}};\n");  // Fermeture de la déclaration
            
            fclose(f);           // C'est terminé : fermer le fichier
            
            // Confirmation de l'image à l'écran avec cadre blanc autour
            blit(img,screen,0,0,(SCREEN_W-img->w)/2,(SCREEN_H-img->h)/2,
                 img->w,img->h);
            rect(screen,(SCREEN_W-img->w)/2-1,(SCREEN_H-img->h)/2-1,
                        (SCREEN_W-img->w)/2+img->w,(SCREEN_H-img->h)/2+img->h, 
                         makecol(255,255,255));
                         
            clear_keybuf();                       // Vider le tampon clavier
            while (!keypressed() && !mouse_b);    // Attendre clavier ou souris
         }
         else   // Echec de l'ouverture du fichier destination
            alert("Impossible d'ouvrir en écriture le fichier",
                   path,NULL,"OK",NULL,'\n',0);
      }
      else      // Echec de l'ouverture du fichier image source
         alert("Impossible d'ouvrir le fichier",path,NULL,"OK",NULL,'\n',0);
   }  
   
   return 0;
}
END_OF_MAIN();


// Lancement des services Allegro utilisés
void initAllegro()
{
   set_uformat(U_ASCII);
   allegro_init();
   install_mouse();
   install_keyboard();
   install_timer();

   set_color_depth(24);
   if (set_gfx_mode(GFX_AUTODETECT_WINDOWED,640,480,0,0)!=0){
      set_color_depth(32);
      if (set_gfx_mode(GFX_AUTODETECT_WINDOWED,640,480,0,0)!=0){
         allegro_message("probleme ouverture mode graphique");
         allegro_exit();
         exit(EXIT_FAILURE);
      }  
   }

   show_mouse(screen);
}

