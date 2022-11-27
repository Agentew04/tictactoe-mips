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

# for(int %i=0; %i < %to) %body();
.macro for(%i, %to, %body)
	li %i, 0		# i = 0
	startLoop:
		bge %i, %to, endLoop	# if i >= to, goto end
		jal %body 		# execute Body
		addi %i, %i, 1 	# i++
		j startLoop		# goto startLoop
	endLoop:
.end_macro 

.macro printChar(%x)
	addiu $v0, $zero, 11
	add $a0, %x, $zero
	syscall 
.end_macro 

.macro randomInt(%max, %dest)
	li $v0, 42	# set syscall service
	li $a0, 0		# A0 to 0 (random machine ID), can be any number
	li $a1, %max		# set upper bound
	syscall			# syscall rand()%max
	move %dest, $a0		# set result to destination register
.end_macro 

.macro readInt (%dest)
	li $v0, 5
	syscall 
	move %dest, $v0
.end_macro 

# R1 == R2 && R2 == R3 && R3 != ' '
.macro checkSpace(%r1, %r2, %r3, %rd)
	bne %r1, %r2, false		# if (R1 != R2) false;
	bne %r2, %r3, false		# if (R2 != R3) false;
	beq %r1, SPACECHAR, false	# if (R1 == ' ') false;
	
	li %rd, 1	# RD = 1
	j end
	false:
		li %rd, 0
	end:
.end_macro  

.macro printStrLabel(%label)
	li $v0, 4
	la $a0, %label
	syscall
.end_macro 

.macro mod(%rs, %n, %rd)
	li %rd, %n	# RD = 2
	div %rs, %rd	# RS / RD
	mfhi %rd	# RD = i%2
.end_macro 

.macro coordToLinear(%rc, %rl, %n, %rd)
	#col + linha * 3 // x,y to one idx
	li %rd, %n		# RD = 3
	mul %rd, %rl, %rd	# RD = LINHA*3
	add %rd, %rd, %rc	# RD = RD + COL
.end_macro 

.data
.eqv XCHAR 88
.eqv OCHAR 79
.eqv SPACECHAR 32

cmpTopLabel:	.asciiz "\\ 0   1   2\n"
cmpL1: 		.asciiz "0 "
cmpL2: 		.asciiz "1 "
cmpL3: 		.asciiz "2 "
cmpDivV: 	.asciiz " | "
cmpDivH: 	.asciiz "\n ---+---+---\n"
inputL:		.asciiz  "\nDigite a linha de sua jogada: "
inputC:		.asciiz "\nDigite a coluna de sua jogada: "
endChat:	.asciiz "O jogo acabou.\n"
winChat:	.asciiz "O vencedor eh: "
tieChat:	.asciiz "Deu empate. Nao tem vencedores!\n"
exclamation:	.asciiz "!"
charNL:		.asciiz "\n"

campo:		.space 9 # campo de chars 3x3 = 9
linha:		.word 0
coluna:		.word 0
winner:		.byte SPACECHAR

.text


printCampo:
	printStrLabel(cmpTopLabel)

	#linha 1 char
	printStrLabel(cmpL1)
	
	lb $t0, campo+0
	printChar($t0)
	
	printStrLabel(cmpDivV)
	
	lb $t0, campo+1
	printChar($t0)
	
	printStrLabel(cmpDivV)
	
	lb $t0, campo+2
	printChar($t0)
	
	#linha 2 div
	printStrLabel(cmpDivH)
	
	#linha 3 char
	printStrLabel(cmpL2)
	
	lb $t0, campo+3
	printChar($t0)
	
	printStrLabel(cmpDivV)
	
	lb $t0, campo+4
	printChar($t0)
	
	printStrLabel(cmpDivV)
	
	lb $t0, campo+5
	printChar($t0)
	
	#linha 4 div
	printStrLabel(cmpDivH)
	
	#linha 5 char
	printStrLabel(cmpL3)
	
	lb $t0, campo+6
	printChar($t0)
	
	printStrLabel(cmpDivV)
	
	lb $t0, campo+7
	printChar($t0)
	
	printStrLabel(cmpDivV)
	
	lb $t0, campo+8
	printChar($t0)
	
	printStrLabel(charNL)
	jr $ra


# v0 <= 0 | 1
valido:
# T0 = linha
# T1 = coluna
	lw $t0, linha
	lw $t1, coluna
	bltz $t0, valido.false 		# linha < 0 => false
	bltz $t1, valido.false		# col < 0   => false
	bgt $t0, 2, valido.false	# linha > 2 => false
	bgt $t1, 2, valido.false	# col > 2   => false
	
	coordToLinear($t1, $t0, 3, $t2)	# T2 = index
	move $t0, $t2			# T0 = T2
	
	lb $t0, campo($t0)		# T0 = campo[T0]
	
	bne $t0, SPACECHAR, valido.false# if( T1 != ' ') => false
		li $v0, 1	# return 1
		jr $ra
	valido.false:
		li $v0, 0	# return 0
		jr $ra



# v=1 if not empate
# v=0 if empate
empate:
# T0 = i
# T1 = achou
# T2 = aux
	addi $sp, $sp, -4		# stack alloc 4 bytes
	sw $ra, ($sp)
	
	li $t1, 0			# T1 = 0
	for($t0, 9, empate.body)	# for(T0=0; T0<9; T0++) body()
	empate.loopbreak:
	notBool($t1, $v0)		# return !T1;
	
	lw $ra, ($sp)			# reload $RA
	addi $sp, $sp, 4		# dealloc 4 bytes
	jr $ra
	
	# to find a ' ' character on array
	empate.body:
		lb $t2, campo($t0)			# T2 = campo[T0]
		beq $t2, SPACECHAR, empate.body.true	# if campo[T0]==' ' then T2=1
		jr $ra
	empate.body.true:
		li $t1, 1
		j empate.loopbreak



fillBody:
	li $t1, 32
	sb $t1, campo($t0)
	jr $ra
	


setChar:
# T4 = linha
# T5 = coluna
	lw $t4, linha
	lw $t5, coluna
	addiu $t0, $zero, 3	# T0 = 3
	mul $t0, $t4, $t0	# T0 = LINHA * 3
	add $t0, $t0, $t5	# T0 = COL + T0
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
		
		
		
# V0 <= 1/0
# winner <=  'X'/'O'/' '
ganhou:
# T0 = i
# T1,T2,T3 = auxiliares campo
# T4,T5,T6 = auxiliar geral
	li $t0, 0
	ganhou.while: bge, $t0, 3, ganhou.while.end
	
		#linha
		li $t5, 3
		mul $t5, $t0, $t5 	# triple = 3*i
		lb $t1, campo($t5)	# T1 = campo[3*i]
		lb $t2, campo+1($t5)	# T2 = campo[3*i+1]
		lb $t3, campo+2($t5)	# T3 = campo[3*i+2]
		checkSpace($t1,$t2,$t3,$t4)
		bgtz $t4, ganhou.while.chkWn	# if(check(t1,t2,t3) chkWn(); break;
		
		# coluna
		lb $t1, campo($t0)	# T1 = campo[i]
		lb $t2, campo+3($t0)	# T2 = campo[i+3]
		lb $t3, campo+6($t0)	# T3 = campo[i+6]
		checkSpace($t1,$t2,$t3,$t4)
		bgtz $t4, ganhou.while.chkWn	# if(check(t1,t2,t3) chkWn(); break;
		
		#end if 3a vez
		beq $t0, 2, ganhou.while.end	# if(i==2) break;
		
		# diagonal
		sll $t4, $t0, 1		# T4 = i*2 (T5 == i << 1)
		lb $t1, campo($t4)	# T1 = campo[i*2]
		lb $t2, campo+4		# T2 = campo[4]
		li $t5, 8
		sub $t5,$t5,$t4		# T5 = 8(T5) - i*2(T4)
		lb $t3, campo($t5)	# T3 = campo[8-i*2]
		checkSpace($t1,$t2,$t3,$t4)
		bgtz $t4, ganhou.while.chkWn	# if(check(t2,t3,t4) chkWn(); break;
		
		addi $t0, $t0, 1 # i++
		j ganhou.while
	ganhou.while.chkWn:
		j ganhou.win		# goto ganhou
	ganhou.while.end:
	# aqui ele não ganhou
	li $v0, 0		# not ganhou
	jr $ra			
	ganhou.win:			# ganhou
		# aqui o winner está em T1
		sb $t1, winner
		li $v0, 1
		jr $ra


main:
	for($t0, 9, fillBody)	# fill campo with 32(space)
	
	# S0 => linha
	# S1 => col
	# S3 => Winner
	li $s3, SPACECHAR
	sb $s3, winner
	# S4 => Counter
	li $s4, 0
	
	jal printCampo			# print empty campo once
	main.loopStart:				# do
		mod($s4, 2, $t0)		# T0 = S4 % 2
		beq $t0, $zero, main.playerInput	# if(T0 == 0) goto Player
			randomInt(3, $t0)		# LINHA = RANDOM()
			sw $t0, linha
			randomInt(3, $t0)		# COL = RANDOM()
			sw $t0, coluna
			j main.inputEnd			# goto endInput
		main.playerInput:			# player input
			printStrLabel(inputL)
			readInt($t0)			# LINHA = scanf()
			sw $t0, linha
			printStrLabel(inputC)
			readInt($t0)			# COL = scanf()
			sw $t0, coluna
	main.inputEnd:
		jal valido			# V0 = valido() => (1->valido; 0->invalido)
		beq $v0, $zero, main.loopStart	# while (V0==0);
		
		jal setChar			# SetChar()
		
		jal printCampo			# printCampo()
	
		add $s4, $s4, 1			# i++
	
		jal ganhou			# V0 = ganhou() => (0 -> ninguem; 1 -> PLAYER; -1 -> AI)
		move $t0, $v0			# RES(T0) = V0
		sll $s0, $t0, 1			# RES(KEEP) = RES << 1
	
		jal empate			# V0 = empate() => (0-empate // 1-nao empate)
		#notBool($v0,$v0)
		add $t0, $s0, $v0		# RES(T0) = RES(KEEP) + V0
	
		beq $t0, $zero, main.loopStart  # if RES==0 play
	
		addi $t0, $t0, -2		# RES -= 2
		bgez $t0, main.win		# if RES==0 ganhou()
		j main.tie			# else empatou()

	main.win:
		printStrLabel(endChat)
		printStrLabel(winChat)
		lb $t0, winner
		printChar($t0)
		printStrLabel(exclamation)
		printStrLabel(charNL)
		j end
	
	main.tie:
		printStrLabel(endChat)
		printStrLabel(tieChat)
		j end
	
end:
	
	
	
	
	
	
	
	
	
	
	
	
