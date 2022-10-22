.text
j main

.macro notBool(%rs,%rd)
	beq %rs, $zero, toOne
	j toZero
toOne:
	addiu %rd, $zero, 1
	j end
toZero:
	add %rd, $zero, $zero
end:
.end_macro 

.macro for(%i, %to, %body)
	li %i, 0		# i = 0
startLoop:
	beq %i, %to, endLoop	# if i==to, goto end
	jal %body 		# execute Body
	addiu %i, %i, 1 	# i++
	j startLoop		# goto startLoop
endLoop:
.end_macro 

.macro printChar(%x)
	addiu $v0, $zero, 11
	add $a0, %x, $zero
	syscall 
.end_macro 

.macro printChar (%label, %offset)
	addiu $v0, $zero, 11	# set syscall service
	li $t0, %offset		# load offset to T0
	la $t1, %label		# load label addr to T1
	add $a0, $t1, $t0	# set argument to wanted addr
	lb $a0, ($a0)		# load real int
	syscall 		# syscall, print($a0)
.end_macro

.macro readChar(%dest)
	addiu $v0, $zero, 12
	syscall 
	add %dest, $zero, $v0
.end_macro 

.macro printInt (%x)
	addiu $v0, $zero, 1
	add $a0, %x, $zero
	syscall 
.end_macro 

.macro randomInt(%max, %dest)
	addiu $v0, $zero, 42	# set syscall service
	addiu $a0, $zero, 0	# A0 to 0 (random machine ID), can be any number
	addiu $a1, $zero, %max	# set upper bound
	syscall 		# syscall rand()%max
	add %dest, $zero, $a0	# set result to destination register
.end_macro 

.macro printInt (%label, %offset)
	addiu $v0, $zero, 1	# set syscall service
	li $t0, %offset		# load offset to T0
	la $t1, %label		# load label addr to T1
	add $a0, $t1, $t0	# set argument to wanted addr
	lb $a0, ($a0)		# load real int
	syscall 		# syscall, print($a0)
.end_macro

.macro readInt (%dest)
	addiu $v0, $zero, 5
	syscall 
	add %dest, $v0, $zero
.end_macro 

.macro checkSpace(%r1, %r2, %r3, %rd)
	add %rd, $zero, %r1	# RD = R1
	addi %rd, %rd, -32	# RD -= 32
	beq %rd, $zero, false 	# if RD == 0, goto false
	
	add %rd, $zero, %r2	# RD = R2
	addi %rd, %rd, -32	# RD -= 32
	beq %rd, $zero, false 	# if RD == 0, goto false
	
	add %rd, $zero, %r3	# RD = R3
	addi %rd, %rd, -32	# RD -= 32
	beq %rd, $zero, false 	# if RD == 0, goto false
	
	addiu %rd, $zero, 1	# RD = 1
	j end
false:
	addiu %rd, $zero, 0	# RD = 0
end:
.end_macro 

.macro printStr(%str)
	.data
minhaStr: .asciiz %str
	.text 
	addiu $v0, $zero, 4
	la $a0, minhaStr
	syscall
.end_macro 

.macro printStrLabel(%label)
	addiu $v0, $zero, 4
	la $a0, %label
	syscall
.end_macro 

.macro getArrImediate(%label, %offset, %dest)
	la $t0, %label
	addiu $t0, $t0, %offset
	lb %dest, ($t0)
.end_macro

.macro mod(%reg, %n, %dest)
	addiu $t9, $zero, %n	# T2 = 2
	div %reg, $t9		# 
	mfhi %dest		# T2 = i%2
.end_macro 

.macro getArrReg(%label, %offset, %dest)
	la $t0, %label
	addiu $t0, $t0, %offset
	lb %dest, ($t0)
.end_macro 

.macro equals(%reg1, %reg2, %reg3, %dest)
	bne %reg1, %reg2, false
	bne %reg2, %reg3, false
	addiu %dest, $zero, 1
	j end
false:
	addiu %dest, $zero, 0
end:
.end_macro 


.data
campo:		.space 9 # campo de chars 3x3 = 9
cmpTopLabel:	.asciiz "\\ 0   1   2\n"
cmpL1: 		.asciiz "0 "
cmpL2: 		.asciiz "1 "
cmpL3: 		.asciiz "2 "
cmpDivV: 	.asciiz " | "
cmpDivH: 	.asciiz "\n ---+---+---\n"
inputL:		.asciiz "\nDigite a linha de sua jogada: "
inputC:		.asciiz "\nDigite a coluna de sua jogada: "
endChat:	.asciiz "O jogo acabou.\n"
winChat:	.asciiz "O vencedor eh: "
tieChat:	.asciiz "Deu empate. Nao tem vencedores!\n"
exclamation:	.asciiz "!"
charNL:		.asciiz "\n"

.eqv XCHAR 88
.eqv OCHAR 79
.eqv SPACECHAR 32
.text


printCampo:
	printStrLabel(cmpTopLabel)

	#linha 1 char
	printStrLabel(cmpL1)
	
	getArrImediate(campo, 0, $t0)
	printChar($t0)
	
	printStrLabel(cmpDivV)
	
	getArrImediate(campo, 1, $t0)
	printChar($t0)
	
	printStrLabel(cmpDivV)
	
	getArrImediate(campo, 2, $t0)
	printChar($t0)
	
	#linha 2 div
	printStrLabel(cmpDivH)
	
	#linha 3 char
	printStrLabel(cmpL2)
	
	getArrImediate(campo, 3, $t0)
	printChar($t0)
	
	printStrLabel(cmpDivV)
	
	getArrImediate(campo, 4, $t0)
	printChar($t0)
	
	printStrLabel(cmpDivV)
	
	getArrImediate(campo, 5, $t0)
	printChar($t0)
	
	#linha 4 div
	printStrLabel(cmpDivH)
	
	#linha 5 char
	printStrLabel(cmpL3)
	
	getArrImediate(campo, 6, $t0)
	printChar($t0)
	
	printStrLabel(cmpDivV)
	
	getArrImediate(campo, 7, $t0)
	printChar($t0)
	
	printStrLabel(cmpDivV)
	
	getArrImediate(campo, 8, $t0)
	printChar($t0)
	
	printStrLabel(charNL)
	jr $ra


valido:
	bltz $s0, valido.false 		# linha < 0 => false
	bltz $s1, valido.false		# col < 0   => false
	bgt $s0, 2, valido.false	# linha > 2 => false
	bgt $s1, 2, valido.false	# col > 2   => false
	
	#col + linha * 3 // x,y to one idx
	addiu $t0, $zero, 3		# T0 = 3
	mul $t0, $s0, $t0		# T0 = LINHA*3
	add $t0, $t0, $s1 		# T0 = T0 + COL ( INDEX LINEAR )
	
	lb $t1, campo($t0)		# T1 = campo[T0]
	
	addi $t1, $t1, -32		# T1 -= 32
	bnez $t1, valido.false		# if T1 != 0 => false
	j valido.true			# T1 == ' ' goto inputOk
valido.true:
	addiu $v0, $zero, 1	# return 1
	jr $ra
valido.false:
	addiu $v0, $zero, 0	# return 0
	jr $ra

# v=1 if not empate
# v=0 if empate
empate:
	add $t3, $zero, $ra	# T3 = RA
	addiu $t2, $zero, 0	# T2 = 0 (se achou ' ')
	for($t0, 9, empateBody)	# for(T0=0; T0<9; T0++T2) empateBody()
	notBool($t2, $v0)	# V0 = !T2
	jr $t3
empateBody:
	lb $t1, campo($t0)		# T1 = campo[T0]
	addi $t1, $t1, -32 		# T1 -= 32
	beq $t1, $zero, empateBody.true	# if campo[T0]==' ' then T2=1
	jr $ra
empateBody.true:
	addiu $t2, $zero, 1
	jr $ra

fillBody:
	addiu $t1, $zero, 32
	sb $t1, campo($t0)
	jr $ra
	
setChar:
	addiu $t0, $zero, 3	# T0 = 3
	mul $t0, $s0, $t0	# T0 = LINHA * 3
	add $t0, $t0, $s1	# T0 = COL + T0
	la $t1, campo		# T1 = &campo
	add $t0, $t1, $t0	# T0 = &campo + T0 => T0 = char*
	
	mod($s4, 2, $t2)
	beqz $t2, setChar.X	# if COUNTER % 2 == 0, T2='X' else T2='O'
	addiu $t2, $zero, OCHAR # T2 = 'O'
	j setChar.End
setChar.X:
	addiu $t2, $zero, XCHAR	# T2 = 'X'
setChar.End:
	sb $t2, ($t0)		# *T0 = T3
	jr $ra

ganhou:
ganhou.col1:				# 0 3 6
	lb $t0, campo+0			# T0 = campo[A]
	lb $t1, campo+3			# T1 = campo[B]
	lb $t2, campo+6			# T2 = campo[C]
	checkSpace($t0,$t1,$t2,$t3)	# T3 = !(T0==' ' || T1==' ' || T2==' ')
	beq $t3, $zero, ganhou.col2	# if T3==0, goto next
	equals($t0,$t1,$t2,$t3)		# T3 = (T0==T1==T2)
	bgtz $t3, ganhou.win
ganhou.col2:				# 1 4 7
	lb $t0, campo+1			# T0 = campo[A]
	lb $t1, campo+4			# T1 = campo[B]
	lb $t2, campo+7			# T2 = campo[C]
	checkSpace($t0,$t1,$t2,$t3)	# T3 = !(T0==' ' || T1==' ' || T2==' ')
	beq $t3, $zero, ganhou.col3	# if T3==0, goto next
	equals($t0,$t1,$t2,$t3)		# T3 = (T0==T1==T2)
	bgtz $t3, ganhou.win
ganhou.col3:				# 2 5 8
	lb $t0, campo+2			# T0 = campo[A]
	lb $t1, campo+5			# T1 = campo[B]
	lb $t2, campo+8			# T2 = campo[C]
	checkSpace($t0,$t1,$t2,$t3)	# T3 = !(T0==' ' || T1==' ' || T2==' ')
	beq $t3, $zero, ganhou.lin1	# if T3==0, goto next
	equals($t0,$t1,$t2,$t3)		# T3 = (T0==T1==T2)
	bgtz $t3, ganhou.win
ganhou.lin1:				# 0 1 2
	lb $t0, campo+0			# T0 = campo[A]
	lb $t1, campo+1			# T1 = campo[B]
	lb $t2, campo+2			# T2 = campo[C]
	checkSpace($t0,$t1,$t2,$t3)	# T3 = !(T0==' ' || T1==' ' || T2==' ')
	beq $t3, $zero, ganhou.lin2	# if T3==0, goto next
	equals($t0,$t1,$t2,$t3)		# T3 = (T0==T1==T2)
	bgtz $t3, ganhou.win
ganhou.lin2:				# 3 4 5
	lb $t0, campo+3			# T0 = campo[A]
	lb $t1, campo+4			# T1 = campo[B]
	lb $t2, campo+5			# T2 = campo[C]
	checkSpace($t0,$t1,$t2,$t3)	# T3 = !(T0==' ' || T1==' ' || T2==' ')
	beq $t3, $zero, ganhou.lin3	# if T3==0, goto next
	equals($t0,$t1,$t2,$t3)		# T3 = (T0==T1==T2)
	bgtz $t3, ganhou.win
ganhou.lin3:				# 6 7 8
	lb $t0, campo+6			# T0 = campo[A]
	lb $t1, campo+7			# T1 = campo[B]
	lb $t2, campo+8			# T2 = campo[C]
	checkSpace($t0,$t1,$t2,$t3)	# T3 = !(T0==' ' || T1==' ' || T2==' ')
	beq $t3, $zero, ganhou.dia1	# if T3==0, goto next
	equals($t0,$t1,$t2,$t3)		# T3 = (T0==T1==T2)
	bgtz $t3, ganhou.win
ganhou.dia1:				# 2 4 6
	lb $t0, campo+2			# T0 = campo[A]
	lb $t1, campo+4			# T1 = campo[B]
	lb $t2, campo+6			# T2 = campo[C]
	checkSpace($t0,$t1,$t2,$t3)	# T3 = !(T0==' ' || T1==' ' || T2==' ')
	beq $t3, $zero, ganhou.dia2	# if T3==0, goto next
	equals($t0,$t1,$t2,$t3)		# T3 = (T0==T1==T2)
	bgtz $t3, ganhou.win
ganhou.dia2:				# 0 4 8
	lb $t0, campo+0			# T0 = campo[A]
	lb $t1, campo+4			# T1 = campo[B]
	lb $t2, campo+8			# T2 = campo[C]
	checkSpace($t0,$t1,$t2,$t3)	# T3 = !(T0==' ' || T1==' ' || T2==' ')
	beq $t3, $zero, ganhou.lose	# if T3==0, goto next
	equals($t0,$t1,$t2,$t3)		# T3 = (T0==T1==T2)
	bgtz $t3, ganhou.win
	
ganhou.lose:
	addiu $v0, $zero, 0		# ganhou = false
	jr $ra
ganhou.win:
	addiu $v0, $zero 1		# ganhou = true
	add $s3, $zero, $t0		# T0 tem o valor do jogador
	jr $ra
	
main:
	for($t0, 9, fillBody)	# fill campo with 32(space)
	
	# S0 => linha
	# S1 => col
	# S3 => Winner
	addiu $s3, $zero, SPACECHAR
	# S4 => Counter
	add $s4, $zero, $zero
	
	jal printCampo			# print empty campo once
main.loopStart:				# do
	mod($s4, 2, $t0)		# T0 = S4 % 2
	beq $t0, $zero, main.playerInput	# if(T0 == 0) goto Player
	randomInt(3, $s0)		# LINHA = RANDOM()
	randomInt(3, $s1)		# COL = RANDOM()
	j main.inputEnd			# goto endInput
main.playerInput:			# player input
	printStrLabel(inputL)
	readInt($s0)			# LINHA = scanf()
	printStrLabel(inputC)
	readInt($s1)			# COL = scanf()
main.inputEnd:
	jal valido			# V0 = valido() => (1->valido; 0->invalido)
	beq $v0, $zero, main.loopStart	# while (V0==0);
	
	jal setChar			# SetChar()
	
	jal printCampo			# printCampo()
	
	add $s4, $s4, 1			# i++
	
	jal ganhou			# V0 = ganhou() => (0 -> ninguem; 1 -> PLAYER; -1 -> AI)
	add $s2, $zero, $v0		# RES(S2) = V0
	sll $s2, $s2, 1			# RES = RES << 1
	
	jal empate			# V0 = empate() => (0-empate // 1-nao empate)
	add $s2, $s2, $v0		# RES += V0
	
	beq $s2, $zero, main.loopStart  # if RES==0 play
	
	addi $s2, $s2, -2		# RES -= 2
	bgez $s2, main.win		# if RES==0 ganhou()
	j main.tie			# else empatou()

main.win:
	printStrLabel(endChat)
	printStrLabel(winChat)
	printChar($s3)
	printStrLabel(exclamation)
	printStrLabel(charNL)
	j end
	
main.tie:
	printStrLabel(endChat)
	printStrLabel(tieChat)
	j end
	
end:
	
	
	
	
	
	
	
	
	
	
	
	
