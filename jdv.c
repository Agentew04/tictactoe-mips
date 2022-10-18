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

    // col1 036
    if((campo[0] != ' ' && campo[3] != ' ' && campo[6] != ' ') &&
        (campo[0] == campo[3] && campo[3] == campo[6])){
        vencedor = campo[0];
        return 1;
    }
    // col2 147
    if((campo[1] != ' ' && campo[4] != ' ' && campo[7] != ' ') &&
        (campo[1] == campo[4] && campo[4] == campo[7])){
        vencedor = campo[1];
        return 1;
    }
    // col3 258
    if((campo[2] != ' ' && campo[5] != ' ' && campo[8] != ' ') &&
        (campo[2] == campo[5] && campo[5] == campo[8])){
        vencedor = campo[2];
        return 1;
    }
    // lin1 012
    if((campo[0] != ' ' && campo[1] != ' ' && campo[2] != ' ') &&
        (campo[0] == campo[1] && campo[1] == campo[2])){
        vencedor = campo[0];
        return 1;
    }
    // lin2 345
    if((campo[3] != ' ' && campo[4] != ' ' && campo[5] != ' ') &&
        (campo[3] == campo[4] && campo[4] == campo[5])){
        vencedor = campo[3];
        return 1;
    }
    // lin3 678
    if((campo[6] != ' ' && campo[7] != ' ' && campo[8] != ' ') &&
        (campo[6] == campo[7] && campo[7] == campo[8])){
        vencedor = campo[6];
        return 1;
    }
    // diag1 048
    if((campo[0] != ' ' && campo[4] != ' ' && campo[8] != ' ') &&
        (campo[0] == campo[4] && campo[4] == campo[8])){
        vencedor = campo[0];
        return 1;
    }
    // diag2 246
    if((campo[2] != ' ' && campo[4] != ' ' && campo[6] != ' ') &&
        (campo[2] == campo[4] && campo[4] == campo[6])){
        vencedor = campo[2];
        return 1;
    }
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
    int i;
    for(i = 0; i < 9; i++){
        if(campo[i] == ' '){
            return 0;
        }
    }
    return 1;
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