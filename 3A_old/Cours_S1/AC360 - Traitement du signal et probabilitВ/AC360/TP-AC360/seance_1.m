%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%            SEANCE DE TP n�1 : Prise en main de Matlab/Octave
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars % vide la m�moire
close all % ferme les fen�tres graphiques
clc % vide le command window

% Il n'y a pas de compte rendu � rendre au terme de la s�ance de TP car vous �tes �valu� durant l'examen de TP individuel
% Vous n'aurez pas le droit � vos scripts de vos documents pendant l'examen.
% Par contre, je vous conseil de faire un script comment� afin de pouvoir r�viser facilement.
%
%

%% 1. Op�ration sur les vecteurs

% 1.1) cr�er un vecteur temps nomm� t1 compos� de 1001 �chantillons de 0 � 1 secondes en utilisant la fonction linspace.

t1=linspace(0,1,1000);
% le ; en fin de ligne permet de ne pas afficher le r�sultats dans la fen�tre de commande.
% Par exemple, si vous cr�e un vecteur de 100 000 points sans mettre de ; vous aurez les 100 000 valeurs d'affich�es. Cela peut prendre beaucoup de temps.

%1.2) Pour d�finir un vecteur avec un pas d�fini, il peut �tre utile d'utiliser la syntaxe suivante :
% t2 = (0 : delta_t : (N-1)*delta_t) ;
% Avec cette syntaxe, cr�er un vecteur t2 de 1001 �chantillons avec un pas temporel de 10 ms.

N = 1001 ; % nombre de points
delta_t = 10e-3; % pas temporel
t2 = 0:delta_t: (N-1)*delta_t; % il faut toujours utiliser des variables pour d�finir les vecteurs.
% Cette fa�on de creer un vecteur est � privilegier par rapport � linspace car nous voyons mieux le p�riode d'�chantillonnage (delta_t) et le nombre de points

% 1.3) V�rifier la taille du vecteur avec la fonction size. Est-ce un vecteur ligne ou un vecteur colonne ?
size(t2)
% La fonction renvoie deux valeurs : 1,1001
% Cela veut dire qu'il y a une ligne et 1001 colonnes. c'est donc un vecteur ligne.

% 1.4) Cr�er les vecteurs : t3 = [1+j , 2+j , 3+j]     t4 = t3'      t5=t3.'
t3 = [ 1+1j , 2+1j , 3+1j ]
t4 = t3'
t5 = t3.'

% 1.5) Quelles diff�rences voyez-vous entre ces vecteurs (vous pouvez vous aider de la fonction size) ?  Expliquer les fonctions � et .'
% Nous voyons que l'op�rateur ' correspond au transpos� du vecteur et son
% conjugu� :
% La fonction size(t3) renvoie 1 , 3 => c'est un vecteur ligne
% La fonction size(t4) renvoie cette fois 3,1 => c'est donc devenu un vecteur colonne

% Nous voyons que l'op�rateur .' correspond simplement au conjugu�. Ici la
% fonction size(t5) renvoie 3 , 1 => c'est un vecteur colonne.

% 1.6) R�aliser la multiplication : t3*t3. Expliquez la signification de l'erreur renvoy�e par Matlab (Il est tr�s important de bien lire et comprendre les erreurs donn�es par le logiciel. Cela vous aidera � corriger votre code rapidement)
% t3*t3
% Nous voyons le message suivant :


% Error using  *
% Inner matrix dimensions must agree.  => traduction : les dimensions des matrices doivent correspondres.
%                                         En effet, il n'est pas possible de multiplier deux vecteurs lignes
%
% Error in seance_0 (line 51)  => vous avez le num�ro de la ligne o� se % trouve l'erreur (ici 51 si vous enlevez le commentaire)
% t3*t3


% 1.7) R�aliser les multiplications suivantes : A1=t3*t4 ; A2=t3.*t3
A1=t3*t4
A2=t3.*t3

% 1.8) Expliquer les diff�rences ? A quoi sert le point avec le signe multipli� : .*
% A1 = 17, soit un scalaire. C'est la multiplication math�matique usuelle
% entre un vecteur ligne et un vecteur colonne

% A2 = 0.0000 + 2.0000i   3.0000 + 4.0000i   8.0000 + 6.0000i
% Cette multiplication renvoie un vecteur. Il s'agit de la multiplication terme � terme.
% Le premier terme de A2 est T3(1)*t3(1)
% Le deuxi�me terme de A2 est T3(2)*t3(2)
% Le troisi�me terme de A2 est T3(3)*t3(3)

% 1.9) Concat�nation de deux vecteurs : B = [ t1 t2 ]
B = [ t1 t2 ]

% 1.10) Selection d'une partie d'un vecteur : C=t1(1:20) ; % on selectionne les 20 premi�res valeurs.
C=t1(1:20)

% 1.11) Fonction find : gr�ce � l'aide de matlab, expliquer le fonctionnement de la fonction find � l'aide d'un exemple.
find(t1)  % renvoie l'indice des �l�ments non nul du vecteur
find(t1 == 1) %renvoie l'indice des �l�ments �gaux � 1 dans t1

%% 2. G�n�ration d'un signal num�rique
% 2.1) G�n�rer un signal num�rique, x1, repr�sentant N = 100 �chantillons d'une cosinuso�de de fr�quence f0 = 1 kHz,
%     la fr�quence d'�chantillonnage �tant fix�e � 8 kHz.

N=100;
f0=1e3;
fs=8e3;

tt=0:1/fs:(N-1)/fs;
x1 = cos(2*pi*f0*tt);


% 2.2) Tracer ce signal en faisant appara�tre en abscisse le temps. Pour cela aidez vous de la fonction � plot �.
% TOUJOURS suivre ce format pour l'affichage des courbes
figure(1)
plot(tt,x1,'-b','linewidth',3) %affichage de x1 en fonction de t. La courbe en bleue continue d'�paisseur 3
xlabel('t (s)','fontsize',14) %label sur l'axe x avec une police de 14
ylabel('x_1','fontsize',14)    % idem sur l'axe y
set(gca,'fontsize',14) % police des axes en 14
set(gcf,'color','white') %couleur de la fen�tre en blanc

% 2.3) D�terminer l'�nergie du signal : Comment varie l'�nergie lorsque N augmente ? Commenter ce r�sultat.
Ex = sum(abs(x1).^2)
% ou
Ex1 = x1*x1'

%Lorsque le nombre de point augmente nous avons plus de signal donc plus
%d'�nergie. On remarque que l'�nergie d�finie ici n'a pas de sens physique.
% En effet, elle ne d�pend pas de t. Elle permet de comparer deux signaux
% discret en m�moire.

% 2.4) D�terminer la puissance du signal : Comment varie la puissance lorsque N augmente ? Est-ce en accord avec la th�orie ?
Px1=Ex/N % On trouve 0.5 soit la puissance th�orique d'un cosinus d'amplitude A=1 (A^2/2)

% 3. Transformation de Fourier Discr�te
% 3.1) Calculer le spectre du signal x1 avec la fonction FFT pour N = 100.
X1f = fft(x1);

% 3.2) Tracer le module du spectre correspondant en fonction de la fr�quence. Commenter le spectre obtenu. Est-il en accord avec ce que vous vous attendiez � trouver ? Quelle est la fr�quence exacte du signal indiqu�e par le spectre ?
ff=0:fs/N:fs-fs/N; % d�finition du vecteur fr�quence suivant la th�orie

figure(2)
plot(ff,abs(X1f),'-b','linewidth',3) %affichage de x1 en fonction de t. La courbe en bleue continue d'�paisseur 3
xlabel('f (Hz)','fontsize',14) %label sur l'axe x avec une police de 14
ylabel('X_1(f)','fontsize',14)    % idem sur l'axe y
set(gca,'fontsize',14) % police des axes en 14
set(gcf,'color','white') %couleur de la fen�tre en blanc

% Notez que si vous oubliez la valeur absolue, matlab ou octave ne renvoie
% pas d'erreur mais un warning :
% Warning: Imaginary parts of complex X and/or Y arguments ignored
% Il est not� que la partie imaginaire a �t� ignor�e. Seule la partie
% r�elle a �t� affich�e.

% 3.3) Tracer � nouveau le spectre mais pour N = 1000. Commenter le spectre obtenu. Quelle est la fr�quence du signal indiqu�e par le spectre ? Conclure sur l'influence du nombre de points dans la d�duction de la fr�quence du signal.
N = 1000;
tt=0:1/fs:(N-1)/fs;
x1 = cos(2*pi*f0*tt);
X1f = fft(x1);
ff=0:fs/N:fs-fs/N;

figure(3)
plot(ff,abs(X1f),'-b','linewidth',3) %affichage de x1 en fonction de t. La courbe en bleue continue d'�paisseur 3
xlabel('f (Hz)','fontsize',14) %label sur l'axe x avec une police de 14
ylabel('X_1(f)','fontsize',14)    % idem sur l'axe y
set(gca,'fontsize',14) % police des axes en 14
set(gcf,'color','white') %couleur de la fen�tre en blanc

% Nous avons regard� le signal sur un dur�e plus longue. La fen�tre
% observation est plus large donc les sinus cardinaux sont plus fins (ils tendent vers des
% diracs si N tend vers l'infini).


% 3.4) Tracer � nouveau le spectre mais pour N = 104 et N = 405. Quelle est la fr�quence du signal indiqu�e par les spectres ? Est-ce en accord avec la conclusion de la question 23) ? Expliquer pr�cis�ment pourquoi nous observons cela  et conclure sur ce cas particulier.
%Cas particulier o� l'on tombe sur les z�ros du sinus cardinal sauf en f0
%donc on a l'impression d'avoir un spectre mieux d�fini avec N = 104 alors
%que normalement plus N augmente plus le spectre est pr�cis. C'est un cas
% particulier.

% 3.5) Pourquoi l'amplitude des raies varient pour N = 1000 et N = 2000.
% Le th�or�me de parseval dit que l'�nergie est conserv�e en fr�quence.
% Donc on a plus d'�nergie en temps donc plus d'�nergie en fr�quence
N2 = 2000;
tt=0:1/fs:(N2-1)/fs;
x2 = cos(2*pi*f0*tt);
X2f = fft(x2);
ff2=0:fs/N2:fs-fs/N2;

figure(4)
plot(ff,abs(X1f),'-b','linewidth',3) %affichage de x1 en fonction de t. La courbe en bleue continue d'�paisseur 3
hold on % affichage de plusieurs courbes
plot(ff2,abs(X2f),'--r','linewidth',3)
legend('N = 1000','N = 2000') %legende du graphique
xlabel('f (Hz)','fontsize',14) %label sur l'axe x avec une police de 14
ylabel('X_1(f)','fontsize',14)    % idem sur l'axe y
set(gca,'fontsize',14) % police des axes en 14
set(gcf,'color','white') %couleur de la fen�tre en blan

%autre affichqage possible
figure(5)
subplot(2,1,1)
plot(ff,abs(X1f),'-b','linewidth',3) %affichage de x1 en fonction de t. La courbe en bleue continue d'�paisseur 3
xlabel('f (Hz)','fontsize',14) %label sur l'axe x avec une police de 14
ylabel('X_1(f)','fontsize',14)    % idem sur l'axe y
subplot(2,1,2)
plot(ff2,abs(X2f),'--r','linewidth',3)
xlabel('f (Hz)','fontsize',14) %label sur l'axe x avec une police de 14
ylabel('X_2(f)','fontsize',14)    % idem sur l'axe y
set(gca,'fontsize',14) % police des axes en 14
set(gcf,'color','white') %couleur de la fen�tre en blanc


% 3.6) D�terminer l'�nergie du spectre pour N = 100. Comparer avec l'�nergie obtenue � la question
% (en discret, l'�nergie du spectre est : 1/N*sum(abs(spectre).^2)).
%
% Si vous faites le calcul vous aurez 0.5 comme la puissance calcul� en
% temps.

% 3. Transform�e de Fourier inverse - Reconstruction
% A partir du spectre du signal x1, reconstruire le signal gr�ce � la transform�e de Fourier inverse (fonction ifft). Comparer le signal reconstruit � l'aide de la FFT inverse, au signal original de la question 11).
% Quelle condition doit-on respecter pour effectuer cette op�ration ?
% La condition de shannon doit �tre respect�e. (fr�quence d'�chantillonnage
% sup�rieure � 2 fois la fr�quence du signal.
% Utilisez la fonction ifft





