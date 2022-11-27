#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// GLOBAL VAR
char campo[9];

// REGISTERS
char vencedor = ' ';
int linha = 0;
int coluna = 0;
int contador = 0;

// mostra o campo na tela
void printCampo(){
    //linha 1 char
    printf(" %c | %c | %c", campo[0], campo[1], campo[2]);
	
	//linha 2 div
	printf("\n---+---+---\n");
	
	//linha 3 char
    printf(" %c | %c | %c", campo[3], campo[4], campo[5]);
	
	//linha 4 div
	printf("\n---+---+---\n");
	
	//linha 5 char
    printf(" %c | %c | %c", campo[6], campo[7], campo[8]);
    printf("\n");
}

// retorna se ganhou e seta o vencedor
int ganhou(){
    // i, a1,a2,a3, temps
    int i=0;
    while(i<3){
        char a1,a2,a3;
        a1 = campo[i*3];
        a2 = campo[i*3+1];
        a3 = campo[i*3+2];
        if(a1==a2 && a2==a3 && a1!=' '){
            vencedor = a1;
            break;
        }
        a1 = campo[i];
        a2 = campo[i+3];
        a3 = campo[i+6];
        if(a1==a2 && a2==a3 && a1!=' '){
            vencedor = a1;
            break;
        }
        if(i==2)
            break;
        a1 = campo[i*2];
        a2 = campo[4];
        a3 = campo[8-i*2];
        if(a1==a2 && a2==a3 && a1!=' '){
            vencedor = a1;
            break;
        }
        i++;
    }
    vencedor = win;
    if(vencedor!=' ')
        return 1;
    return 0;
}

// coloca um valor no campo
void setChar(){
    int index = linha * 3 + coluna;
    if(contador % 2 == 0){
        campo[index] = 'X';
    }else{
        campo[index] = 'O';
    }

}

// diz se o lance é valido
int valido(){
    if(coluna < 0 || coluna > 2 || linha < 0 || linha > 2){
        return 0;
    }
    if(campo[coluna + linha * 3] != ' '){
        return 0;
    }
    return 1;
}

int empate(){
    int achou = 0;
    for(int i = 0; i < 9; i++){
        if(campo[i] == ' '){
            achou = 1;
        }
    }
    return !achou;  // ESSE NOT NAO FOI IMPLEMENTADO NO MIPS!!!!
                    // ELE RETORNA 0 SE TEM EMPATE E 1 SE NAO TEM
}

int main(void){
    srand(time(NULL));
    for (int i = 0; i < 9; i++) // for($t0, 9, fillBody)
        campo[i] = ' ';

    vencedor = ' ';
    contador = 0;
    printCampo();

start:

    int t0 = contador % 2;
    if(t0 != 0){
        // ai
        linha = rand() % 3;
        coluna = rand() % 3;
    }else{
        // player
        printf("\nDigite a linha de sua jogada: ");
        scanf("%d", &linha);
        printf("\nDigite a coluna de sua jogada: ");
        scanf("%d", &coluna);
    }
    int v0 = valido();
    if(v0 == 0)
        goto start;

    setChar();

    printCampo();

    v0 = ganhou(); // se ganhou, vencedor tá definido
    contador++;

    if(v0 == 0)
        goto start;

    printf("O jogo acabou.\nO vencedor eh: ");
    printf("%c", vencedor);
    printf("\n");
    return 0;
}