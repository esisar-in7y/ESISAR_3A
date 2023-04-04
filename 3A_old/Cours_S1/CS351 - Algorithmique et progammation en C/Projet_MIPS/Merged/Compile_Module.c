#include "Compile_Module.h"


// #define DEBUG_BITS
#define BIT5MASK 0b11111
#define BIT6MASK 0b111111
#define BIT16MASK 0xFFFF
#define BIT26MASK 0x3FFFFFF
#define UNDEFINED 0
#define TAILLE_LIGNE_MAX 25

struct ligne_tableau Tableau[TAILLE_TABLEAU]={
    { "ADD",0b100000, 'R',0b00111},
    { "ADDI",0b001000, 'I',0b10111},
    { "AND",0b100100, 'R',0b00111},
    { "BEQ",0b000100, 4,0b10111},
    { "BGTZ",0b000111, 5,0b10011},
    { "BLEZ",0b000110, 5,0b10011},
    { "BNE",0b000101, 4,0b10111},
    { "DIV",0b011010, 4,0b00011},
    { "J",0b000010, 'J',0b10001},
    { "JAL",0b000011, 'J',0b10001},
    { "JR",0b001000, 4,0b00001},
    { "LUI",0b001111, 'Z',0b10011},
    { "LW",0b100011, 'Y',0b10111},
    { "MFHI",0b010000, 'R',0b00001},
    { "MFLO",0b010010, 'R',0b00001},
    { "MULT",0b011000, 4,0b00011},
    { "NOP",0b00000, 0,0b00000},
    { "OR",0b100101, 'R',0b00111},
    { "ROTR",0b000010, 'S',0b10000111},
    { "SLL",0b000000, 'S',0b00111},
    { "SLT",0b101010, 'R',0b00111},
    { "SRL",0b000010, 'S',0b00111},
    { "SUB",0b100010, 'R',0b00111},
    { "SW",0b101011, 'Y',0b10111},
    { "XOR",0b100110, 'R',0b00111}
};

/**
Remplace tous les characteres [a] contenu dans [str] par [b] */
void sed(char *str, char a, char b){
	for(int i=0; (str[i]!='\0'); i++) if(str[i] == a) str[i] = b;
}

/**
Efface certain characteres génants */
void traitement_de_ligne(char * line){
	sed(line, '#', '\0');
	sed(line, ',', ' ');
	sed(line, '(', ' ');
	sed(line, ')', ' ');
}

/**
Décompose les mots de [line] (séparés par des espaces) en 4 chaines de characteres */
void line_decomposer(char * line,char * name,char * arg1,char * arg2,char * arg3){
	
	sscanf(line, "%s %s %s %s",name,arg1,arg2,arg3);
	// printf("1:%s\n2:%s\n3:%s\n",arg1,arg2,arg3);
	
}

/**
Affiche un nombre [nb] de bits d'un nombre pointé par [ptr] (et de taille [size]) */
void printBits(long unsigned int nb, size_t const size, void const * const ptr){
    unsigned char *b = (unsigned char*) ptr;
    unsigned char byte;
    int i, j;
    
    for (i = size-1; i >= 0; i--) {
        for (j = 7; j >= 0; j--) {
            byte = (b[i] >> j) & 1;
            if((size*i+j)<nb)printf("%u", byte);
        }
    }
}

/**
Transforme un registre en la valeur numérique correspondante.
Arg: str, chaine de characteres contenant le nom d'un registre
Return: un nombre compris entre 0 et 31.
Renvoie 0 par défault si le registre n'est pas reconnu */
uint8_t str2reg(char* str){
	uint8_t regnum = 0;
	if (str[0] == '\0') ;
	else if (!strcmp(str,"$zero")) regnum = 0;
	else if (!strcmp(str,"$at")) regnum = 1;
	else if (!strcmp(str,"$v0")) regnum = 2;
	else if (!strcmp(str,"$v1")) regnum = 3;
	else if (!strcmp(str,"$a0")) regnum = 4;
	else if (!strcmp(str,"$a1")) regnum = 5;
	else if (!strcmp(str,"$a2")) regnum = 6;
	else if (!strcmp(str,"$a3")) regnum = 7;
	else if (!strcmp(str,"$t0")) regnum = 8;
	else if (!strcmp(str,"$t1")) regnum = 9;
	else if (!strcmp(str,"$t2")) regnum = 10;
	else if (!strcmp(str,"$t3")) regnum = 11;
	else if (!strcmp(str,"$t4")) regnum = 12;
	else if (!strcmp(str,"$t5")) regnum = 13;
	else if (!strcmp(str,"$t6")) regnum = 14;
	else if (!strcmp(str,"$t7")) regnum = 15;
	else if (!strcmp(str,"$s0")) regnum = 16;
	else if (!strcmp(str,"$s1")) regnum = 17;
	else if (!strcmp(str,"$s2")) regnum = 18;
	else if (!strcmp(str,"$s3")) regnum = 19;
	else if (!strcmp(str,"$s4")) regnum = 20;
	else if (!strcmp(str,"$s5")) regnum = 21;
	else if (!strcmp(str,"$s6")) regnum = 22;
	else if (!strcmp(str,"$s7")) regnum = 23;
	else if (!strcmp(str,"$t8")) regnum = 24;
	else if (!strcmp(str,"$t9")) regnum = 25;
	else if (!strcmp(str,"$k0")) regnum = 26;
	else if (!strcmp(str,"$k1")) regnum = 27;
	else if (!strcmp(str,"$gp")) regnum = 28;
	else if (!strcmp(str,"$sp")) regnum = 29;
	else if (!strcmp(str,"$fp")) regnum = 30;
	else if (!strcmp(str,"$ra")) regnum = 31;
	else sscanf(str,"$%hhd",&regnum);
	if (regnum>31) regnum = 0 ;
	return regnum;
}

/***
Fonction Principale:
	Cette fonction parmet de traduire une instruction pris en charge par ce programme (i.e, dont l'opcode est dans le tableau des instructions)
	et de la traduire un une valeur numérique.
Args:
	[index], ligne du Tableau à laquelle ce trouvent les détails de l'instructions.
	[arg1/2/3], chaine de charactères contenant les arguments de l'instruction.
Return:
	Renvoie une valeur numérique, codée sur 32bits, équivalente à l'instruction traduite en language machine.
***/
int inst2hex(int index, char * arg1, char * arg2, char * arg3){
	unsigned int hex=0;
	
	uint8_t SPECIAL, rs, rt, rd, sa, OP;
	uint16_t imm;
	uint32_t target;
	/* Ordre
		SPECIAL : 6 bits
		rs      : 5 bits
		rt      : 5 bits
		rd      : 5 bits | ou imm 
		sa      : 5 bits | ou offset
		OP      : 6 bits | 16 bits
	*/
	SPECIAL = rs = rt = rd = sa = OP = 0;
	imm = 0;
	target = 0;
	
	char category = 0;
	category = Tableau[index].Category;
	
	/* On met soit OP soit SPECIAL a la bonne valeur */
	if (Tableau[index].flags & 0b10000) 
		  SPECIAL = Tableau[index].Code;
	else  OP =Tableau[index].Code;
	
	/* On efface les arguments en trop (juste pour être sûr)*/
	switch (Tableau[index].flags & 0b111){
		case 0: /* 0b000 */
			arg1[0]='\0';
			__attribute__ ((fallthrough));
		/* La ligne precedente sert a supprimer les warnings */
			
		case 1: /* 0b001 */
			arg2[0]='\0';
			__attribute__ ((fallthrough));
			
		case 3: /* 0b011 */
			arg3[0]='\0';
			
		case 7: /* 0b111 */
		default:
			break;
	}
	
	/* Cas special pour ROTR */
	if (Tableau[index].flags & 0b10000000)
		rs = 1;
	
	switch(category){
		case 'R': // INST rd,rs,rt
			rs = str2reg(arg2);
			rt = str2reg(arg3);
			rd = str2reg(arg1);
			break;
		case 'I': // INST rt,rs,imm
			rs = str2reg(arg2);
			rt = str2reg(arg1);
			sscanf(arg3,"%hd",&imm);
			break;
		case 'J': // INST target
			sscanf(arg1,"%ud",&target);
			break;
		case 4: // INST rs, rt, offset
			rs = str2reg(arg1);
			rt = str2reg(arg2);
			sscanf(arg3,"%hud",&imm);
			break;
		case 5: // INST rs, offset
			rs = str2reg(arg1);
			sscanf(arg2,"%hd",&imm); //unsigned ?
			break;
		case 'S': // INST rd,rt,sa
			rt = str2reg(arg2);
			rd = str2reg(arg1);
			sscanf(arg3,"%hhud",&sa);
			break;
		case 'Y': // INST, rt, offset(base)
			// rt = str2reg(arg1);
			// sscanf(arg2,"%hud",&imm);
			rs = str2reg(arg3);
			__attribute__ ((fallthrough));
		case 'Z': // INST rt, imm
			rt = str2reg(arg1);
			sscanf(arg2,"%hud",&imm);
			break;
		case 0:
		default: 
			break;
	}
	
	
	target |= imm;
	
	/* assert size */
	SPECIAL &= 0b111111;
	rs &= 0b11111;
	rt &= 0b11111;
	rd &= 0b11111;
	sa &= 0b11111;
	OP &= 0b111111;
	target &=0x3FFFFFF;
	
	/* fill hex value */
	 				hex |= SPECIAL;
	hex <<= 5;		hex |= rs;
	hex <<= 5;		hex |= rt;
	hex <<= 5;		hex |= rd;
	hex <<= 5;		hex |= sa;
	hex <<= 6;		hex |= OP;
	//hex |= imm; /* Ne fait rien si imm n'est pas set*/
	hex |= target; 
	
	#ifdef DEBUG_BITS
	
	printf("OP: %s %s %s %s\n",Tableau[index].OP_NAME,arg1,arg2,arg3);
	printf("%x    %x     %x     %x            %x\n",SPECIAL,rs,rt,rd,OP);
	printBits(6, sizeof(SPECIAL), &SPECIAL);
	printf(" ");
	printBits(5, sizeof(rs), &rs);
	printf(" ");
	printBits(5, sizeof(rt), &rt);
	if(imm){
		printf(" ");
		printBits(16, sizeof(imm), &imm);
	}else{
		printf(" ");
		printBits(5, sizeof(rd), &rd);
		printf(" ");
		printBits(5, sizeof(sa), &sa);
		printf(" ");
		printBits(5, sizeof(OP), &OP);
	}
	puts("");
	// puts("");
	#endif
	
	return hex;
}


void hex2inst(uint32_t hex){
	uint8_t SPECIAL, rs, rt, rd, sa;
	int16_t imm;
	uint32_t target;
	
	SPECIAL = (hex>>26)& BIT6MASK;
	rs = 	  (hex>>21)& BIT5MASK;
	rt = 	  (hex>>16)& BIT5MASK;
	rd = 	  (hex>>11)& BIT5MASK;
	sa = 	  (hex>>6) & BIT5MASK;
	imm = 	  (hex)	& BIT16MASK;
	target =  (hex)	& BIT26MASK;
	
	if (!SPECIAL) SPECIAL = (hex&BIT6MASK); else SPECIAL +=0x80;
	
	printf("%08x {",hex);
	
	int i=TAILLE_TABLEAU-1;
	while( i>=0 && (Tableau[i].Code + 0x80*(Tableau[i].flags>>4&1)) != SPECIAL ){
		i--;
	}
	/* On parcoure le tableau du bas vers le haut pour ne pas causer de souci avec NOP et ROTR 
		Comme NOP est un cas special de SLL et ROTR de SRL, il faut qu'on trouve uniquement cette ligne en parcourant le tableau.
		Ce fix ne devrait être que temporaire car il risquerait de ne plus fonctionner si on voulait implémenter de nouvelle instructions.
	*/
	
	if (i>=0){
		/* Dirty Fix 2 :) */
		if (hex==0) printf("NOP");
		else if((i==21) & (rs==1)) printf("ROTR"); //ligne 21 il y a SRL
		else printf("%s",Tableau[i].OP_NAME);
	
		switch(Tableau[i].Category){
		case 'R': // INST rd,rs,rt
		// puts("R--");
			if(Tableau[i].flags   &1) printf(" $%d",rd);
			if(Tableau[i].flags>>1&1) printf(", $%d",rs);
			if(Tableau[i].flags>>2&1) printf(", $%d",rt);
			break;
		case 'I': // INST rt,rs,imm
		// puts("I--");
			if(Tableau[i].flags   &1) printf(" $%d",rt);
			if(Tableau[i].flags>>1&1) printf(", $%d",rs);
			if(Tableau[i].flags>>2&1) printf(", %x",imm);
			break;
		case 'J': // INST target
		// puts("J--");
			if(Tableau[i].flags   &1) printf(" %X",target);
			break;
		case 4: // INST rs, rt, offset
		// puts("4--");
			if(Tableau[i].flags   &1) printf(" $%d",rs);
			if(Tableau[i].flags>>1&1) printf(", $%d",rt);
			if(Tableau[i].flags>>2&1) printf(", %x",imm);
			break;
		case 5: // INST rs, offset
		// puts("5--");
			if(Tableau[i].flags   &1) printf(" $%d",rs);
			if(Tableau[i].flags>>1&1) printf(", %x",imm);
			break;
		case 'S': // INST rd,rt,sa
		// puts("S--");
			if(Tableau[i].flags   &1) printf(" $%d",rd);
			if(Tableau[i].flags>>1&1) printf(", $%d",rt);
			if(Tableau[i].flags>>2&1) printf(", $%d",sa);
			break;
		case 'Y': // INST, rt, offset(base) (LW,SW, LUI(no base) )
		// puts("Y--");
			if(Tableau[i].flags   &1) printf(" $%d",rt);
			if(Tableau[i].flags>>1&1) printf(", $%d",rs);
			if(Tableau[i].flags>>2&1) printf(", %x",imm);
			break;
		default: 
			break;
		}
		puts("}");
	}
	else puts("non implémenté}");
}


/** bonus !?
void hex2inst(uint32_t hex){
	uint8_t SPECIAL, rs, rt, rd, sa;
	int16_t imm;
	uint32_t target;
	
	long temp;
	
	SPECIAL = (hex>>26)& BIT6MASK;
	rs = 	  (hex>>21)& BIT5MASK;
	rt = 	  (hex>>16)& BIT5MASK;
	rd = 	  (hex>>11)& BIT5MASK;
	sa = 	  (hex>>6) & BIT5MASK;
	imm = 	  (hex)	& BIT16MASK;
	target =  (hex)	& BIT26MASK;
	
	if (!SPECIAL) SPECIAL = (hex&BIT6MASK)+0x80;
	
	printf("%08x {",hex);
	
	switch(SPECIAL){
		// Opcode defined in CPU_Struct.h 
		case ADD: printf("ADD");
			break;
			
		case ADDI: printf("ADDI");
			break;
			
		case AND: printf("AND");
			break;
		
		case BEQ: printf("BEQ");
			break;
			
		case BGTZ: printf("BGTZ");
			break;
			
		case BLEZ: printf("BLEZ");
			break;
			
		case BNE: printf("BNE");
			break;
			
		case DIV: printf("DIV");
			break;
			
		case JAL: printf("JAL");
			
			
		case J: printf("J");
			break;
			
		case JR: printf("JR");
			break;
			
		case LUI: printf("LUI");
			break;
		
		case LW: printf("LW");
			break;
		
		case MFHI: printf("MFHI");
			break;
			
		case MFLO: printf("MFLO");
			break;
		
		case MULT: printf("MULT");
			break;
			
		case OR: printf("OR");
			break;
			
		case SLL: 
			if(hex) printf("SLL");
			else printf("NOP");
			break;
		
		case SLT: printf("SLT");
			break;
			
		case SRL: 
			if (rs == 1){
				printf("ROTR");
			} else {
				printf("SRL");
			}
			break;
			
		case SUB: printf("SUB");
			break;
			
		case SW: printf("SW");
		
		case XOR: printf("XOR");
		
		default:
			printf("non implémenté");
	}
}
*/



/**
Cherche si [name] est une instruction valide du Tableau des instructions.
Return: la ligne correspondant à l'instruction si elle existe, -1 sinon. 
*/
int chercher_index(char* name){
	
	/* Recherche Dichotomique */
	
	int POS;   /* position de la valeur */
	int INF, MIL, SUP; /* limites du champ de recherche */
	int CMP; /* resultat de la comparaison */
 
    /* Initialisation des limites du domaine de recherche */
    INF=0;
    SUP=TAILLE_TABLEAU-1;
     
    /* Recherche de la position de la valeur */
    POS=-1;
    while ((INF<=SUP) && (POS==-1)){
        MIL=(SUP+INF)/2;
        CMP = strcmp(name,Tableau[MIL].OP_NAME);
		if (CMP<0)
			SUP=MIL-1;
		else if (CMP>0)
			INF=MIL+1;
		else
			POS=MIL;
		}
     
    /* Edition du résultat */
    return POS;
	
}

/**
Traduit ligne par ligne un fichier texte du language assembleur en language machine.
Args: fichier_entree, fichier entrée
	  fichier_sortie, fichier sortie
Return: rien du tout
*/
void compile_segment(char *fichier_entree, char *fichier_sortie) {
	
	FILE * fic;
	FILE * fout;
	char line[TAILLE_LIGNE_MAX];
	unsigned int hex;
	
	/* Ouverture du fichier */
	fic = fopen(fichier_entree, "r");
	if(fic == NULL) {
		perror("Probleme ouverture fichier");
		exit(1);
	}
	fout = fopen(fichier_sortie, "w");
	
	char c;
	int index;
	char name[10]="";
	char arg1[20]="";
	char arg2[20]="";
	char arg3[20]="";
	
	/** Boucle principale */
	
	while(!feof(fic)) {
		// fscanf(fic, "[^\n]", line);
		
		/* scan full line */
		fgets(line, sizeof(line), fic);
		
		/* traiter ligne */
		traitement_de_ligne(line);
		
		/* reset param */
		*name='\0'; *arg1='\0'; *arg2='\0'; *arg3='\0';
		
		/* read op and args */
		line_decomposer(line, name, arg1, arg2, arg3);
		
		
		/* chercher index */
		index = chercher_index(name);
		
		if (index != -1) {
			/* do the stuff */
			hex = inst2hex(index, arg1, arg2, arg3);
			#ifdef DEBUG_BITS
				printf("%s: %08x\n\n",name,hex);
			#endif
			fprintf(fout,"%08X\n",hex);
		}
		
		/* remove duplicate bug (if file end with \n)*/
		c = getc(fic);
		while( c =='\n') c = getc(fic);
		ungetc(c,fic) ;
	}
	
	/* Fermeture du fichier */
	fclose(fic);
	fclose(fout);
	
	
	printf("Exit:%d\n", 0);
}