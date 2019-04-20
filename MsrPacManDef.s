#########################################################
# Universidade de Brasilia                              #
# Instituto de Ciencias Exatas                          #
# Departamento de Ciencia da Computacao                 #
# Introdução a Sistemas Computacionais – 1/2018		    #
# Aluno(a): Pedro Luis Chaves Rocha                     #
# Matricula: 180054635     								#
#			                                            #
# Versão do RARS: Custom 6 		                        #
# Descricao: Mrs.Pacman							        #
#########################################################

.data

NOTAS: .word 

1,0,78,110,223
223,0,76,110,231
454,0,71,110,2038
2723,0,76,110,461
3184,0,79,110,454
3638,0,81,110,908
4546,0,76,110,2499
7269,0,79,110,1822
9091,0,78,110,454
9545,0,79,110,454
9999,0,81,110,454
10453,0,74,110,454
10907,0,83,110,1815
12722,0,81,110,1592



mapa1:   .string "Mapas/Mapa1.bin"      # filename for output
mapa2:   .string "Mapas/Mapa2.bin"      # filename for output
mapa3:   .string "Mapas/Mapa3.bin"      # filename for output
mapa4:   .string "Mapas/Mapa4.bin"      # filename for output

pontostr:	.string "Pontos:"
vidasstr:	.string "Vidas:"
gameOverstr:	.string "GAME OVER"
readystr:	.string "GET READY"

pacPPU:   .string "Imagens/PAC++U.bin"
pacPMU:   .string "Imagens/PAC+-U.bin"      
pacMMU:   .string "Imagens/PAC--U.bin"
pacPPD:   .string "Imagens/PAC++D.bin"      
pacPMD:   .string "Imagens/PAC+-D.bin"      
pacMMD:   .string "Imagens/PAC--D.bin"
pacPPR:   .string "Imagens/PAC++R.bin"      
pacPMR:   .string "Imagens/PAC+-R.bin"      
pacMMR:   .string "Imagens/PAC--R.bin"
pacPPL:   .string "Imagens/PAC++L.bin"      
pacPML:   .string "Imagens/PAC+-L.bin"      
pacMML:   .string "Imagens/PAC--L.bin"  



blinkyU	:   	.string "Imagens/BlinkyU.bin"
sueU	:   	.string "Imagens/SueU.bin"
pinkyU  :	.string "Imagens/PinkyU.bin"
inkyU  :	.string "Imagens/InkyU.bin"

especial1: .string "Imagens/Especial1.bin"

VIDAS: .byte 3

MAPA: .byte 1

IMGCONT: .byte 0 # contador de 3 em 3 que diz qual das 3 imagens de pacman mostrar

.eqv ESPECIAL_TIME 100

.align 2

pacPPUimg:   .space 256
pacPMUimg:   .space 256
pacMMUimg:   .space 256
pacPPDimg:   .space 256
pacPMDimg:   .space 256
pacMMDimg:   .space 256
pacPPRimg:   .space 256
pacPMRimg:   .space 256
pacMMRimg:   .space 256
pacPPLimg:   .space 256 
pacPMLimg:   .space 256 
pacMMLimg:   .space 256 

blinkyUimg	:   	.space 256	
sueUimg		:	.space 256
pinkyUimg	:   	.space 256	
inkyUimg	:	.space 256	

especial1img:   .space 256

PONTOS_DE_COMIDA: .word 0x00000000
PONTOS_EXTRAS:	   .word 0x00000000

mapaBackup: .space 76800

BLINKY:	.word 0x00000000 # primeiro byte : x do fantasma, segundo byte y do fantasma
PINKY:	.word 0x00000000 # terceito byte: direção do fantasma para andar
INKY:	.word 0x00000000 # quarto byte : movimento em espera do fantasma
SUE:	.word 0x00000000

GOHSTS: .word 0x00000000 # primeiro byte, flag do especial; segundo byte ; contador de especial

			

PACMAN: .word 0x00000000 	#primeiro Byte: x do pacman segundo byte: y do pacman
				#terceiro byte direção do pacman quanto byte: direção em espera
				# x e y são as posiçoes do primeiro pixel do quadra	
				
PACIMG: .space 256    	# imagem a ser impressa do pacman

BLINKYIMG: .space 256
SUEIMG: .space 256
PINKYIMG: .space 256
INKYIMG: .space 256

TILESET: .space 868    # memoria do tileset





LOOPCONT: .word 0x00000001 # contador de interações por animação



PACTILE: .word 0x0000 	# x do pacman no tileset e y do pacman no tileset
BLINKYTILE: .word 0x0000 # x do fantasma blinky e y no tileset
SUETILE:  .word 0x0000
PINKYTILE: .word 0x0000 # x do fantasma blinky e y no tileset
INKYTILE:  .word 0x0000

.macro gameOverMusic

	la s0,NOTAS		# define o endereço das notas
	li t0,0			# zera o contador de notas
	li a2,71		# define o instrumento
	li s3,0			# tempo anterior
	li s5,0			# canal a ser tocado
	li s1,14		# numero de notas

	LOOP:	

	beq t0,s1, FIM	        # contador chegou no final? então  vá para FIM
	lw s2,0(s0)		# le tempo inicial
	lw s4,4(s0)		# le canal
	bne s4,s5,PULA
	lw a0,8(s0)		# le o valor da nota
	lw a3,12(s0)		# le o volume
	lw a1,16(s0)		# le a duracao da nota

	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	beq s2,s3,PULA
	mv a0,a1		# passa a duração da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de $a0 ms
	mv s3,s2		# copia o tempo
PULA:	addi s0,s0,20		# incrementa para o endereço da próxima nota
	addi t0,t0,1		# incrementa o contador de notas
	j LOOP			# volta ao loop
	
FIM:

	.end_macro
		
.macro soundPAC			
			
	li a7 31
	li a0 61
	li a1 300
	li a2 1
	li a3 100
	ecall
					
	.end_macro						
									
######################## xy2men ############################
.macro xy2men
# função que converte x y em memoria 
# recebe x no a0, y no a1, quantidade de colunas no a2 e endereço base no a3
# retorna o endereço no a0


mul a1 a1 a2 # y*colunas
add a0 a0 a1 # + x
add a0 a0 a3 # + endereço base

.end_macro

######################## print ############################
.macro print

#Printa o mapa1 na tela # receba a label para printar pelo a0 e o tamanho de bytes pelo s0 e o endereço base pelo s1
 	 # Open (for writing) a file that does not exist
 	 li   a7 1024     # system call for open file
 	 li   a1  0        # Open for writing (flags are 0: read, 1: write)
  	 ecall             # open a file (file descriptor returned in a0)
	 mv   s11  a0      # save the file descriptor
 	 	 
 	 li   a7  63       # system call for read to file
 	 mv   a0  s11      # file descriptor
 	 mv a1 s1 # address of buffer to write
 	 mv   a2  s0    # hardcoded buffer length
  	 ecall             # write VGA
	 closeFile	   # close file 

	.end_macro

######################## closeFile ############################
.macro closeFile

	li   a7  57       # system call for close file
	mv   a0  s11       # file descriptor to close
	ecall             # close file    # close file

	.end_macro


######################## pixelMap ############################
.macro pixelMap


li s0 0xff00001e # endereço inicial da matriz d jogo
	li s1 0xff012bbd #endereço final da matriz do jogo
	li s2 224 # tamanho de uma linha
	li s3 240 # quantidade de linhas
	li s4 0xff00001d       	# zera o endereço inicial na poziçao inicial da matriz -1 pois ele começará sendo incrementado
	li a1 0x00000000	# a1 é o contador para pular partes que não sao da matriz
	li a2 0x00000000       	# a2 é um contador geral para identificar as linhas va vertical das quinhas do quandrado de 8x8
	li a3 0x00000000      	# a3 é um contador geral para identificar as linhas horizontais das quinas do quandro de 8x8
	li s10 0x10040000      # endereço base para onde os bytes das quinas filtradas serao mandadas
	
	LOOP1:
	beq s4 s1 ENDLOOP1 # caso o endereço atua atinga o final saia do loop
	
	
	beq a1 s2 IF1 # caso o contador atinja o numero maximo de linhas some om offset de 96 
	
	j ENDIF1
	IF1:
	
	addi s4 s4 96 # somar ofset de 96
	mv a1 zero #zera o cont
	
	ENDIF1:
	
	
	addi s4 s4 1
	addi a1 a1 1
	
	# if 2
	li t0 7
	beq a2 zero IF2 # pega o endereçe de onde o a2 é zero e consegquntetemente onde seria 8, porem o 8 é erado antes
	beq a2 t0   IF2	# pega o endereço de  onde o a2 é 7
	j ENDIF2
	IF2:
	
		li t1 224
		li t2 0xff000000
		sub t3 s4 t2 
		div t3 t3 t1 # calculos que encontram a linha atual do endereçamento
		
		
		# if 4 para excluir os 4 acima do bitmap
		li t4 4
		bge t3 t4 IF4	
		j ENDIF4
		IF4:
			# if 5 pare escuir os 4 abaixo do bitmap
			li t4 336
			bge t4 t3 IF5
			j ENDIF5
			IF5:
			
				#if 7 para zerar o contador a3 quando for igual a 8
				li t6 8
				beq a3 t6 IF7 
				j ENDIF7
				IF7:
					mv a3 zero
				ENDIF7:
				
				#if 6 para checar caso o a3 seja igual a 7 ou 8 que sera sempre serado para filtrar a memoria 
				li t6 7
				beq a3 t6 IF6
				beq a3 zero IF6
				j ENDIF6
				IF6:
					
					
					lb s11 (s4) # carrega a cor que tem no endereço filtrado que está em s4
					sb s11 (s10) # salva a mesma cor sequencialmente na memoria no endereço do contador s10
					addi s10 s10 1
					
					
					#li t6 0x00000aa  	#mostra os pixels filtrados que serao salvos
					#sb t6 (s4)		# em 0x10040000
			
			
				ENDIF6:
				# if 8 faz com que o a3 somente incremente quando mudar de linha ou seja em 56 processos
				addi t5 t5 1
				li t6 56
				beq t6 t5 IF8
				j ENDIF8
				IF8:
					mv t5 zero
									
					addi a3 a3 1
				
				ENDIF8:
			
			ENDIF5:
			
		ENDIF4:
		
	ENDIF2:
	
	
	addi a2 a2 1
	
	# if 3
	li t0 8 
	beq a2 t0 IF3 # zera o contador a2 quando chega em 8
	j ENDIF3
	IF3:
	li a2 0
	ENDIF3:

	j LOOP1
	ENDLOOP1:

.end_macro

######################## fillTileSet ############################

	
.macro fillTileSet # receve a label do tileset em s0

	la s0 TILESET
	addi s1 s0 0x00000364 # endereço final do tilemap
	li s2 0x10040000 #endereço base do mapa de cores
	li s3 0x00040d20 #endereço final do mapa de cores
	
	
	mv a0 s0  #copia o endereço inicial
	LOOP1:
	
	beq a0 s1 ENDLOOP1 # llop para preencher todo tile map com 2(COMIDA) para depois tocar as paredes por 1
	
	li t0 0x000000ff # seta o numero 2 que significa a comida 
	sb t0 (a0) # salva o na matriz enteira
	
	addi a0 a0 1 #incrementa o endereço
	
	
	j LOOP1
	ENDLOOP1:
	
		li t0 0x10040000 #contadores relativos ao endereço das 4 quinas por quadrados do tileset
		li t1 0x10040001 #
		li t2 0x10040038
		li t3 0x10040039
		
		li t5 0 #contador para nao repetir as linhasd do mapa de cores duante sua interpretação
		
		addi s10 s0 28 # copia o endereço do tilemap para esse contador sem contar a linha 1 
		addi s9 s1 -28
	
	
		LOOP2:
		
		beq s10 s9 ENDLOOP2
		
		
		lbu a0 (t0) # carrega as 4 cores de quinas 
		lbu a1 (t1) # nos registradores a0-a3
		lbu a2 (t2) 
		lbu a3 (t3)
		
		
		bne a0 zero IF2
		bne a1 zero IF2
		bne a2 zero IF2
		bne a3 zero IF2
		
		li t6 0x00000000 # carrega 0 no tileset caso os 4 pixels sejem iguais a 0
		sb t6 (s10)
		
		j ENDIF2
		IF2:
		li t6 0x000000ff # carrega ff no tileset caso qualquer 1 dos 4 pixels sejam diferentes de 0
		sb t6 (s10)
		
		ENDIF2:
		
		addi s10 s10 1 # adiciona 1 no endereço do tileset
	
	 	addi t5 t5 1 # contador para identificar quando chegar em 28 pois os pixels da quinas estao sequenciados na ordem dos 
	 	# superiores primeiro e os inferiores depois, assim tem ue pular 56 bytes a cada 28 para n repetir os pixels de baixo
	 	
	 	addi t0 t0 2 #incrementa os pixels de 2 em 2 por se tratarem de pares 
	 	addi t1 t1 2
	 	addi t2 t2 2
	 	addi t3 t3 2
	 	
	 	li t6 28
	 	beq t5 t6 IF1 # checa se o t5 é 28
		j ENDIF1
		IF1:
		
		mv t5 zero #se t5 for igual a 28 zera o contador e incrementa os contadores das 4 quinas em 56
		
		addi t0 t0 56 
		addi t1 t1 56
		addi t2 t2 56
		addi t3 t3 56
		
		ENDIF1:
	 	
		   
		j LOOP2
		ENDLOOP2:   
.end_macro


######################## miniMapa ############################
.macro miniMapa
 	
 	la t0 TILESET
 	addi t1 t0 0x00000364
 	li t2 0xff000391
 	
 	li t3 0
 	
 	
 	LOOP:
 	beq t0 t1 ENDLOOP
 	
 	lb s0 (t0)
 	sb s0 (t2)
 	
 	addi t0 t0 1
 	addi t2 t2 1
 	addi t3 t3 1
 	
 	
 	li t4 28
 	beq t3 t4 IF
 	
 	
 	j ENDIF
 	IF:
 	
 	mv t3 zero
 	
 	addi t2 t2 292
 	
 	ENDIF:
 	
 	
 	
 	j LOOP
	 ENDLOOP:
	
	 
	.end_macro



######################## loadPACIMG ############################
.macro loadPACIMG
#carrega as imagems do pacman na ram
	
	li s8 0 # contador para o loop
	la t5 pacPPU # labar do caminho da imagen 
	la s1 pacPPUimg # label da ram onde a imagen será armazenada
	
	LOOP:
	
	li t6 12
	beq s8 t6 ENDLOOP
	
	
	
	mv a0 t5 # move para o a0
	li s0 256 # tamanho da imagem
	
	print
	
	
	addi t5 t5 19
	addi s1 s1 256
	addi s8 s8 1 
	
	j LOOP
	ENDLOOP:
	

	.end_macro


######################## PRINTPAC ############################	
			# recebe a label do personagen no s0 (PACMaN ou Fantasmas)
.macro printPAC  # recebe a LABEL QUE SERA PRINTADA no s10 (PACIMG ou PACVOID)
	

	# carregando variavis da func xy2men
	lbu a0 3(s0) #salva o x no a0
	lbu a1 2(s0) #salva o y no a1
	li a2 320 #colunas
	li a3 0xff000000 # endereço base da vga
	xy2men # endereço base em que o pacman está fica no a0

	li s5 0 #contador de pixels
	
	LOOP1:

	li t6 256
	beq s5 t6 ENDLOOP1

	lbu t0 (s10) # carrega para t0 um byte de PACIMG
	sb t0 (a0) #salva no endereço base vga do retorno de xy2mem o byte de PACIMG

	addi s10 s10 1 #incrementa o PACIMG
	addi a0 a0 1 #incrementa o endereço na vga

	addi s5 s5 1 # incrementa o contador de pixels

	li t6 16 #checa se o contador é multiplo de 16
	rem t5 s5 t6 # se o resto for 0 é pq é multiplo de 16

	beq t5 zero IF1 # checa o resto 0

	j ENDIF1
	IF1: # se for ele incrementa um offset na memoria vga de 304 para pular as linhas

	addi a0 a0 304

	ENDIF1:

	j LOOP1
	ENDLOOP1:

	.end_macro

############################# tileSetPAC #############################################
.macro tileSetBlinky # recebe em s0 a label do fantasma e em s3 a label do fantasma tileset

	
	
	
	lbu t0 3(s0) # carrega o x do pac
	lbu t1 2(s0) # carrega o y do pac

	
	addi t0 t0 -34 # subtrai 34 para pegar o xy no mapa 224 X 240
	li t6 8
	
	
	
	rem t2 t0 t6 # multiplo de 8 em x
	rem t3 t1 t6 # multiplo de 8 em y

	
	beq t2 zero IF1
	
		div t4 t0 t6 # salva a posição do pacman relativa ao tileset no PACTILE
		div t5 t1 t6
		addi a0 t4 1 # soma para coreção de pisoçoes e já salvar no a0 para a xy2mem
		addi a1 t5 1
		li a2 28
		la a3 TILESET
		xy2men
		li t6 0x00000000
		
		sb t6 (a0)
		sb t6 1(a0)
		
		sb t6 1(s3)
		sb t6 (s3)
		
	j ENDIF1
	IF1:	
	li t6 1
	beq t1 t6 IF2
	beq t3 zero IF2 
	
		li t6 8
		div t4 t0 t6 # salva a posição do pacman relativa ao tileset no PACTILE
		div t5 t1 t6
		addi a0 t4 1 # soma para coreção de pisoçoes e já salvar no a0 para a xy2mem
		addi a1 t5 1
		li a2 28
		la a3 TILESET
		xy2men
		
		li t6 0x00000000
		
		sb t6 (a0)
	
		sb t6 28(a0)
		
		sb t6 1(s3)
		sb t6 (s3)
		
		
		j ENDIF2
		IF2:
		
		li t6 8
		div t2 t0 t6 # salva a posição do pacman relativa ao tileset no PACTILE
		div t3 t1 t6
		addi a0 t2 1 # soma para coreção de pisoçoes e já salvar no a0 para a xy2mem
		addi a1 t3 1
		
		sb a0 1(s3)
		sb a1 (s3)
		li a2 28
		la a3 TILESET
		xy2men
		li t6 0x00000007
		sb t6 (a0)
		
		
		ENDIF2:
	
	ENDIF1:
	
		
	
	.end_macro
	
.macro tileSetPAC

	la s0 PACMAN
	la s3 PACTILE
	
	
	lbu t0 3(s0) # carrega o x do pac
	lbu t1 2(s0) # carrega o y do pac
	addi t0 t0 -34 # subtrai 34 para pegar o xy no mapa 224 X 240
	addi t1 t1 0
	li t6 8
	
	rem t2 t0 t6 # multiplo de 8 em x
	rem t3 t1 t6 # multiplo de 8 em y

	
	beq t2 zero IF1
	
		div t4 t0 t6 # salva a posição do pacman relativa ao tileset no PACTILE
		div t5 t1 t6
		addi a0 t4 1 # soma para coreção de pisoçoes e já salvar no a0 para a xy2mem
		addi a1 t5 1
		li a2 28
		la a3 TILESET
		xy2men
		li t6 0x00000000
		
		sb t6 (a0)
		sb t6 1(a0)
		
		sb t6 1(s3)
		sb t6 (s3)
		
	j ENDIF1
	IF1:	
	
	beq t3 zero IF2 
	
		li t6 8
		div t4 t0 t6 # salva a posição do pacman relativa ao tileset no PACTILE
		div t5 t1 t6
		addi a0 t4 1 # soma para coreção de pisoçoes e já salvar no a0 para a xy2mem
		addi a1 t5 1
		li a2 28
		la a3 TILESET
		xy2men
		
		li t6 0x00000000
		
		sb t6 (a0)
	
		sb t6 28(a0)
		
		sb t6 1(s3)
		sb t6 (s3)
		
		
		j ENDIF2
		IF2:
		
		li t6 8
		div t2 t0 t6 # salva a posição do pacman relativa ao tileset no PACTILE
		div t3 t1 t6
		addi a0 t2 1 # soma para coreção de pisoçoes e já salvar no a0 para a xy2mem
		addi a1 t3 1
		
		sb a0 1(s3)
		sb a1 (s3)
		li a2 28
		la a3 TILESET
		xy2men
		li t6 0x0000003f
		sb t6 (a0)
		
		
		ENDIF2:
	
	ENDIF1:
	
	
		
	
	.end_macro

######################## getKeyBoard ############################
.macro getKeyBoard # Checa se existe uma tecla precionada, se existir salva no registrados a0

	la s0 PACMAN # garante o valor inicial de a0 como sendo o armazenado em PACMAN
	lbu a0 1(s0)
	
	li t1,0xFF200000	# carrega o endereço de controle do KDMMIO
	lw t0,0(t1)		# le a palavra de controle
	andi t0,t0,0x0001	# mascara o bit menos signifcativo
	beq t0,zero,PULA   	# Se não há tecla pressionada então vá para PULA
	lw a0,4(t1)  		# le a tecla pressionada
	sw a0,12(t1)  		# escreve a tecla do no display de texto
	sb a0 (s0)		# sava a tecla na espera do PACMAN
	li a7 1
	ecall 
	
	
	
PULA:

.end_macro

######################## MUDA DE DIREÇÂO #####################################


.macro waitKey  # recebe em s0 a label do personagem e em s1 a label das cordenadas do tileset do personagem

	
	
	lbu t0 1(s0) # carrega a direção em que o pacman se move no momento ( alteralá mudará a direção do pacman realmente)
	lbu t1 (s0)  # carrega a tecla de espera
	lbu t2 1(s1) # carrega o x do pacman no tileset
	lbu t3 (s1)  # carrega o y do pacman no tileset
	
	# checa colisao na mesma direção 
	
	bne zero t2 IF40
	bne zero t3 IF40
	j ENDIF40
	
	IF40:
	
	
	# if a0 == 119 (UP)
	li t6 119 
	beq t0 t6 UPP
	# if a0 == 115 (DOWN)
	li t6 115
	beq t0 t6 DOWNP
	# if a0 == 97 (LEFT)
	li t6 97
	beq t0 t6 LEFTP
	# if a0 == 100 (RIGHT)
	li t6 100
	beq t0 t6 RIGHTP
	
	j PAREDE
	
	
	UPP:
	
	mv a0 t2
	addi a1 t3 -1
	li a2 28
	la a3 TILESET
	xy2men
	lbu t4 (a0) # carrega o tile em cima do pacman
	
	li t6 0x000000ff
	beq t4 t6 IF31
	
	j ENDIF31
	IF31:
	
	sb zero 1(s0)
	
	ENDIF31:
	
	
	j PAREDE
	DOWNP:
	
	mv a0 t2
	addi a1 t3 1
	li a2 28
	la a3 TILESET
	xy2men
	lbu t4 (a0) # carrega o tile em baixo do pacman
	
	li t6 0x000000ff
	beq t4 t6 IF31
	
	j ENDIF32
	IF32:
	
	sb zero 1(s0)
	
	ENDIF32:
	
	j PAREDE
	LEFTP:
	
	addi a0 t2 -1
	mv a1 t3 
	li a2 28
	la a3 TILESET
	xy2men
	lbu t4 (a0)
	
	li t6 0x000000ff
	beq t4 t6 IF31
	
	j ENDIF33
	IF33:
	
	sb zero 1(s0)
	
	ENDIF33:
	
	
	j PAREDE
	RIGHTP:
	
	
	addi a0 t2 1
	mv a1 t3 
	li a2 28
	la a3 TILESET
	xy2men
	lbu t4 (a0)
	
	li t6 0x000000ff
	beq t4 t6 IF31
	
	j ENDIF34
	IF34:
	
	sb zero 1(s0)
	
	ENDIF34:
	
	
	j PAREDE
	PAREDE:
	
	
	ENDIF40:
	
	
	
	## Move o pacman automaticamente
	
	# if a0 == 119 (UP)
	li t6 119 
	beq t1 t6 UP
	# if a0 == 115 (DOWN)
	li t6 115
	beq t1 t6 DOWN
	# if a0 == 97 (LEFT)
	li t6 97
	beq t1 t6 LEFT
	# if a0 == 100 (RIGHT)
	li t6 100
	beq t1 t6 RIGHT
	
	
	j ENDMOVE
	UP:
	
	li t6 115
	bne t6 t0 IF4 # checa se o jogar não esta invertendo a direçao (de down pra up)
	beq zero t0 IF4			
			# se for uma inversao sómente muda a direção		
			
	li t6 119
	sb t6 1(s0)						
					
		
	j ENDIF4	
	IF4: # se não for uma inversao checa o tileset
		
		bne t3 zero IF2
	
		j ENDIF2
		IF2:
		
		mv a0 t2
		addi a1 t3 -1
		li a2 28
		la a3 TILESET
		xy2men # pega a memoria do tile em cima do pac
		lbu t4 (a0)	
			
			beq t4 zero IF3
			
			j ENDIF3
			IF3:
			
			li t6 119
			sb t6 1(s0)
			
			ENDIF3:
		
		
		ENDIF2:
	
	ENDIF4:
	
	j ENDMOVE
	DOWN:
	
	

	
	li t6 119
	bne t6 t0 IF5 # checa se o jogar não esta invertendo a direçao (de up pra down)
	beq zero t0 IF5			
			# se for uma inversao sómente muda a direção		
			
	li t6 115
	sb t6 1(s0)						
					
		
	j ENDIF5	
	IF5: # se não for uma inversao checa o tileset
		
		bne t3 zero IF6
	
		j ENDIF6
		IF6:
		
		mv a0 t2
		addi a1 t3 +1
		li a2 28
		la a3 TILESET
		xy2men # pega a memoria do tile em baixo do pac
		lbu t4 (a0)	
			
			beq t4 zero IF7
			
			j ENDIF7
			IF7:
			
			li t6 115
			sb t6 1(s0)
			
			ENDIF7:
		
		
		ENDIF6:
	
	ENDIF5:
	
	
	j ENDMOVE
	LEFT:
	
	li t6 100
	bne t6 t0 IF8 # checa se o jogar não esta invertendo a direçao (de right pra left)
	beq zero t0 IF8			
			# se for uma inversao sómente muda a direção		
			
	li t6 97
	sb t6 1(s0)						
					
		
	j ENDIF8	
	IF8: # se não for uma inversao checa o tileset
		
		bne t2 zero IF9
	
		j ENDIF9
		IF9:
		
		addi a0 t2 -1
		mv a1 t3
		li a2 28
		la a3 TILESET
		xy2men # pega a memoria do tile em da esquerda do pac
		lbu t4 (a0)	
			
			beq t4 zero IF10
			
			j ENDIF10
			IF10:
			
			li t6 97
			sb t6 1(s0)
			
			ENDIF10:
		
		
		ENDIF9:
	
	ENDIF8:
	
	
	
	
	j ENDMOVE
	RIGHT:
	
	
	
	
	li t6 97
	bne t6 t0 IF11 # checa se o jogar não esta invertendo a direçao (de left pra right)
	beq zero t0 IF11		
			# se for uma inversao sómente muda a direção		
			
	li t6 100
	sb t6 1(s0)						
					
		
	j ENDIF11	
	IF11: # se não for uma inversao checa o tileset
		
		bne t2 zero IF12
	
		j ENDIF12
		IF12:
		
		addi a0 t2 +1
		mv a1 t3
		li a2 28
		la a3 TILESET
		xy2men # pega a memoria do tile da direita do pac
		lbu t4 (a0)	
			
			beq t4 zero IF13
			
			j ENDIF13
			IF13:
			
			li t6 100
			sb t6 1(s0)
			
			ENDIF13:
		
		
		ENDIF12:
	
	ENDIF11:
	


	j ENDMOVE
	ENDMOVE:
	
	
		
	
	
	ENDIF1:
	
	

	.end_macro
	
	
#################### printBlack ######################################

.macro printBlack1 # recebe no a0 o x no a1 o y no a3 n de colunas do mapa e no a3 o endereço base

	addi a3 a3 321
	xy2men
	li t4 0 # contador de colunas
	
	LOOP:
	li t6 196
	beq t4 t6 ENDLOOP
	
	sb zero 0(a0)
	addi a0 a0 1
	addi t4 t4 1

	li t6 14
	rem t5 t4 t6
	beq t5 zero IF
	j ENDIF
	IF:	
		addi a0 a0 306
	
	ENDIF:
	j LOOP
	ENDLOOP:
	.end_macro

.macro rePrintBackup  

	la s0 mapaBackup
	li s1 0xff000000		
	
	li t4 0
	LOOP:
	li t6 78600
	beq t4 t6 ENDLOOP
	
	lw t5 0(s0)
	sw t5 0(s1)
	
	addi s0 s0 4
	addi s1 s1 4
	addi t4 t4 4

	
	j LOOP
	ENDLOOP:
	
	
	.end_macro						
		
				
.macro printBlack

xy2men
	li t4 0 # contador de colunas
	
	LOOP:
	li t6 240
	beq t4 t6 ENDLOOP
	
	
	lbu t2 (a0)
	
	li t6 0x00000037
	beq t2 t6 IF2
	li t6 0x0000003F
	beq t2 t6 IF2
	li t6 0x00000006
	beq t2 t6 IF2
	li t6 0x00000027
	beq t2 t6 IF2
	li t6 0x000000EF
	beq t2 t6 IF2
	li t6 0x000000F8
	beq t2 t6 IF2
	li t6 0x00000007
	beq t2 t6 IF2
	li t6 0x000000c1
	beq t2 t6 IF2
	li t6 0x000000c0
	beq t2 t6 IF2
	li t6 0x000000F6
	beq t2 t6 IF2
	
	j ENDIF2
	IF2:
	
	sb zero (a0)
	
	ENDIF2:
	
	
	addi a0 a0 1
	addi t4 t4 1

	li t6 16
	rem t5 t4 t6
	beq t5 zero IF
	j ENDIF
	IF:	
		addi a0 a0 304
	
	ENDIF:
	j LOOP
	ENDLOOP:
	.end_macro
	
	

.macro movePAC # recebe em s0 a label do personagem com o x o y e a direção
	

	# chaca os buracos
	
	lbu t0 3(s0)
	li t6 240
	beq t0 t6 BURACOE
	li t6 32
	beq t0 t6 BURACOD
	
	j ENDPULA
	BURACOE:
	
	lbu a0 3(s0)
	lbu a1 2(s0)
	li a2 320
	li a3 0xff000000
	printBlack	
	
	li t6 33
	sb t6 3(s0)

	
	j ENDPULA
	
	BURACOD:
	
	lbu a0 3(s0)
	lbu a1 2(s0)
	li a2 320
	li a3 0xff000000
	printBlack
		
	li t6 239
	sb t6 3(s0)
	
	j ENDPULA
	ENDPULA:
	lbu t0 1(s0) # carrega a direção do pacman para o t0
	
	# if a0 == 119 (UP) cheque o tile set de sima
	li t6 119 
	beq t0 t6 UP
	# if a0 == 115 (DOWN)
	li t6 115
	beq t0 t6 DOWN
	# if a0 == 97 (LEFT)
	li t6 97
	beq t0 t6 LEFT
	# if a0 == 100 (RIGHT)
	li t6 100
	beq t0 t6 RIGHT
	
	j ENDMOVE
	UP:
	
	lbu t0 3(s0)
	lbu t1 2(s0)
	
	addi t1 t1 -1
	
	sb t0 3(s0)
	sb t1 2(s0)
	
	j ENDMOVE
	DOWN:
	
	
	lbu t0 3(s0)
	lbu t1 2(s0)
	
	addi t1 t1 1
	
	sb t0 3(s0)
	sb t1 2(s0)
	
	j ENDMOVE
	LEFT:
	
	lbu t0 3(s0)
	lbu t1 2(s0)
	
	addi t0 t0 -1
	
	sb t0 3(s0)
	sb t1 2(s0)

	
	j ENDMOVE
	RIGHT:
	
	lbu t0 3(s0)
	lbu t1 2(s0)
	
	addi t0 t0 1
	
	sb t0 3(s0)
	sb t1 2(s0)
	
	
	ENDMOVE:
		
	.end_macro



.macro changePACIMG # muda o PACIMG de acordo com a direção do pacman e de acordo com os loops de 3 em 3 para abrir e fecha a boca


	la s0 PACMAN
	la s1 PACIMG
	la s2 IMGCONT
	
	lb t1 1(s0)
	
	lb t0 (s2) # contador de 3 em 3 para abrir e fechar a boca 
	
	
	# if a0 == 119 (UP)
	li t6 119 
	beq t1 t6 UP
	# if a0 == 115 (DOWN)
	li t6 115
	beq t1 t6 DOWN
	# if a0 == 97 (LEFT)
	li t6 97
	beq t1 t6 LEFT
	# if a0 == 100 (RIGHT)
	li t6 100
	beq t1 t6 RIGHT
	j ENDMOVE
	
	UP: # caso seja direção para cima
	
		li t6 0
		beq t0 t6 IF1 # se o contador for 1
		li t6 1
		beq t0 t6 IF2
		li t6 2
		beq t0 t6 IF3
	
		j ENDCONT
		IF1: # se o cont for 0 carrega as imagens --
		
			li s6 256 # será decrementado até zero 
			la s3 pacMMUimg
			LOOP1:
			
			beq s6 zero ENDLOOP1
			
			
			lw t4 (s3) # troca a imagen de pac...img para o label PACIMG que se´ra printado
			sw t4 (s1)	
			addi s1 s1 4
			addi s3 s3 4
			addi s6 s6 -4	
			
			j LOOP1
			ENDLOOP1:
		
		j ENDCONT
		IF2: # se o cont for 1 carrega as imagens +-
	
			li s6 256 # será decrementado até zero 
			la s3 pacPMUimg
			LOOP2:
			
			beq s6 zero ENDLOOP2
			
			
			lw t4 (s3) # troca a imagen de pac...img para o label PACIMG que se´ra printado
			sw t4 (s1)	
			addi s1 s1 4
			addi s3 s3 4
			addi s6 s6 -4	
			
			j LOOP2
			ENDLOOP2:
	
		j ENDCONT
		IF3: # se o cont for 2 carrega as imagens ++
		
		
			li s6 256 # será decrementado até zero 
			la s3 pacPPUimg
			
		LOOP3:
			
			beq s6 zero ENDLOOP3
			
			
			lw t4 (s3) # troca a imagen de pac...img para o label PACIMG que se´ra printado
			sw t4 (s1)	
			addi s1 s1 4
			addi s3 s3 4
			addi s6 s6 -4	
			
			j LOOP3
			ENDLOOP3:
	
		j ENDCONT
		ENDCONT:
	
	
	
	
	j ENDMOVE
	DOWN:
	
	
	
	li t6 0
		beq t0 t6 IF11 # se o contador for 1
		li t6 1
		beq t0 t6 IF12
		li t6 2
		beq t0 t6 IF13
	
		j ENDCONT1
		IF11: # se o cont for 0 carrega as imagens --
		
			li s6 256 # será decrementado até zero 
			la s3 pacMMDimg
			LOOP11:
			
			beq s6 zero ENDLOOP11
			
			
			lw t4 (s3) # troca a imagen de pac...img para o label PACIMG que se´ra printado
			sw t4 (s1)	
			addi s1 s1 4
			addi s3 s3 4
			addi s6 s6 -4	
			
			j LOOP11
			ENDLOOP11:
		
		j ENDCONT1
		IF12: # se o cont for 1 carrega as imagens +-
	
			li s6 256 # será decrementado até zero 
			la s3 pacPMDimg
			LOOP12:
			
			beq s6 zero ENDLOOP12
			
			
			lw t4 (s3) # troca a imagen de pac...img para o label PACIMG que se´ra printado
			sw t4 (s1)	
			addi s1 s1 4
			addi s3 s3 4
			addi s6 s6 -4	
			
			j LOOP12
			ENDLOOP12:
	
		j ENDCONT1
		IF13: # se o cont for 2 carrega as imagens ++
		
		
			li s6 256 # será decrementado até zero 
			la s3 pacPPDimg
			
		LOOP13:
			
			beq s6 zero ENDLOOP13
			
			
			lw t4 (s3) # troca a imagen de pac...img para o label PACIMG que se´ra printado
			sw t4 (s1)	
			addi s1 s1 4
			addi s3 s3 4
			addi s6 s6 -4	
			
			j LOOP13
			ENDLOOP13:
	
		j ENDCONT1
		ENDCONT1:
	
	
	
	
	
	j ENDMOVE
	RIGHT:
	
		li t6 0
		beq t0 t6 IF21 # se o contador for 1
		li t6 1
		beq t0 t6 IF22
		li t6 2
		beq t0 t6 IF23
	
		j ENDCONT2
		IF21: # se o cont for 0 carrega as imagens --
		
		
			li s6 256 # será decrementado até zero 
			
			la s3 pacMMRimg
			
			LOOP21:
			
			beq s6 zero ENDLOOP21
			
			lw t4 (s3) # troca a imagen de pac...img para o label PACIMG que sera printado
			sw t4 (s1)	
			addi s1 s1 4
			addi s3 s3 4
			addi s6 s6 -4	
			
			j LOOP21
			ENDLOOP21:
		
		j ENDCONT2
		IF22: # se o cont for 1 carrega as imagens +-
	
			li s6 256 # será decrementado até zero 
			la s3 pacPMRimg
			
			LOOP22:
			
			beq s6 zero ENDLOOP22
			
			
			lw t4 (s3) # troca a imagen de pac...img para o label PACIMG que se´ra printado
			sw t4 (s1)	
			addi s1 s1 4
			addi s3 s3 4
			addi s6 s6 -4	
			
			j LOOP22
			ENDLOOP22:
	
		j ENDCONT2
		IF23: # se o cont for 2 carrega as imagens ++
		
			li s6 256 # será decrementado até zero 
			la s3 pacPPRimg
			
		LOOP23:
			
			beq s6 zero ENDLOOP23
			
			
			lw t4 (s3) # troca a imagen de pac...img para o label PACIMG que se´ra printado
			sw t4 (s1)	
			addi s1 s1 4
			addi s3 s3 4
			addi s6 s6 -4	
			
			j LOOP23
			ENDLOOP23:
	
		j ENDCONT
		ENDCONT2:
	
	
	j ENDMOVE
	LEFT:
	
		li t6 0
		beq t0 t6 IF31 # se o contador for 1
		li t6 1
		beq t0 t6 IF32
		li t6 2
		beq t0 t6 IF33
	
		j ENDCONT3
		IF31: # se o cont for 0 carrega as imagens --
		
		
			li s6 256 # será decrementado até zero 
			
			la s3 pacMMLimg
			
			LOOP31:
			
			beq s6 zero ENDLOOP31
			
			lw t4 (s3) # troca a imagen de pac...img para o label PACIMG que sera printado
			sw t4 (s1)	
			addi s1 s1 4
			addi s3 s3 4
			addi s6 s6 -4	
			
			j LOOP31
			ENDLOOP31:
		
		j ENDCONT3
		IF32: # se o cont for 1 carrega as imagens +-
	
			li s6 256 # será decrementado até zero 
			la s3 pacPMLimg
			
			LOOP32:
			
			beq s6 zero ENDLOOP32
			
			
			lw t4 (s3) # troca a imagen de pac...img para o label PACIMG que se´ra printado
			sw t4 (s1)	
			addi s1 s1 4
			addi s3 s3 4
			addi s6 s6 -4	
			
			j LOOP32
			ENDLOOP32:
	
		j ENDCONT3
		IF33: # se o cont for 2 carrega as imagens ++
		
			li s6 256 # será decrementado até zero 
			la s3 pacPPLimg
			
		LOOP33:
			
			beq s6 zero ENDLOOP33
			
			
			lw t4 (s3) # troca a imagen de pac...img para o label PACIMG que se´ra printado
			sw t4 (s1)	
			addi s1 s1 4
			addi s3 s3 4
			addi s6 s6 -4	
			
			j LOOP33
			ENDLOOP33:
	
		j ENDCONT3
		ENDCONT3:
	
	
	
	
	j ENDMOVE
	ENDMOVE:
	
	la s3 LOOPCONT
	lw t4 (s3)
	li t6 3 # quantidade de interações -->> 1 sempre dá resto zero, 2 dá resto 0 de 2 em 2 e assim por diante
	rem t6 t4 t6 # quantidade de interações em que a animação mudará
	beq zero t6 IFLOOP_COMPLETE # checa o resto do contador 
	
	j ENDIFLOOP_COMPLETE
	IFLOOP_COMPLETE: # um if que conta de qunats em quantas interações o contador da animação vi ser incrementado
	
	la s2 IMGCONT
	lbu t0 (s2)
	addi t0 t0 1
	sb t0 (s2)
	
	
	li t6 3
	beq t0 t6 IF_ANIME
	
	
	j ENDIF_ANIME
	IF_ANIME: # checar se o contador for 3
	# se for zera ele
	
	sb zero (s2)
	
	
	ENDIF_ANIME:

	
	ENDIFLOOP_COMPLETE:
	
	
	la s3 LOOPCONT
	lw t4 (s3)
	addi t4 t4 1
	sw t4 (s3)
	
	
	li t6 0xefffffff # checa se o contador de interações está muito grande
	
	beq t6 t4 IFLOOP_OVERFLOW
	j ENDIFLOOP_OVERFLOW 
	IFLOOP_OVERFLOW:# se estiver pode zerar ele
	
	sw zero (s3)
	
	ENDIFLOOP_OVERFLOW:

	.end_macro


.macro colisionContFood # FAZ AS COLISOES COM AS COMIDAS e print a pontuação na tela

	la s0 PACMAN # comida é o ff no vga e comida especial é o 3f
	la s1 PONTOS_DE_COMIDA # carrega o placar de pontos
	la s2 GOHSTS # carrega os estatus dos fantasmas
	
	
	lbu t0 3(s0) # carrega o x do pacman na vga (1 pixel da imagen )
	lbu t1 2(s0) # carrega o y do pacman na vga
	lbu t2 1(s0) # carrega a direção do pacman
	
	# registradores t2(up) t3(down) t4(righ) t5(left) vao conter os vaores de 4 pixels 1 em cada direção para identificar as comidas
	
	
	
	# if a0 == 119 (UP)
	li t6 119 
	beq t2 t6 UP
	# if a0 == 115 (DOWN)
	li t6 115
	beq t2 t6 DOWN
	# if a0 == 97 (LEFT)
	li t6 97
	beq t2 t6 LEFT
	# if a0 == 100 (RIGHT)
	li t6 100
	beq t2 t6 RIGHT
	
	j ENDFOOD
	
	
	UP:
	
	
	beq t1 zero ENDFOOD # checa primeira linha para evitar overflow
	addi a0 t0 7
	addi a1 t1 -1
	li a2 320
	la a3 mapaBackup
	xy2men
	lbu t5 (a0) # carrega o conteudo do pixel central de cima para cehcar comida
	
	li t6 0x000000ff
	beq t5 t6 IF_COMIDA1
	j ENDIF_COMIDA1
	IF_COMIDA1:
	
	
	lw t5 (s1) # incrementa 1 ponto
	addi t5 t5 1
	sw t5 (s1)
	
	# apaga os outros 4 pixels
	
	addi a0 t0 7
	addi a1 t1 -1
	li a2 320
	li a3 0xff000000
	xy2men
	
	
	sb zero (a0)
	sb zero 1(a0)
	sb zero -320(a0)
	sb zero -319(a0)
	sb zero 320(a0)
	sb zero 321(a0)

	
	# apaga no mapa backup
	
	addi a0 t0 7
	addi a1 t1 -1
	li a2 320
	la a3 mapaBackup
	xy2men
	
	sb zero (a0)
	sb zero 1(a0)
	sb zero -320(a0)
	sb zero -319(a0)
	sb zero 320(a0)
	sb zero 321(a0)
	
	lbu a0 3(s0)
	lbu a1 2(s0)
	li a2 320
	la a3 mapaBackup
	printBlack1
	
	soundPAC
	
	
	ENDIF_COMIDA1:
	

	
	li t6 0x00000037
	beq t5 t6 IF_ESPECIAL1 # checa a comidinha amarela do especial
	j ENDIF_ESPECIAL1
	IF_ESPECIAL1:
	
	        li t6 1
		sb t6 0(s2)
		li t6 ESPECIAL_TIME
		sb t6 1(s2)
		
		addi a0 t0 0
		addi a1 t1 -6
		li a2 320
		li a3 0xff000000
		printBlack
		
		#apaga no backup
		
		addi a0 t0 0
		addi a1 t1 -6
		li a2 320
		la a3 mapaBackup
		printBlack

	
	ENDIF_ESPECIAL1:
	# outras colisoes de cores
	
	
	
	j ENDFOOD
	DOWN:
	
	li t6 224
	beq t1 t6 ENDFOOD# checa ultima linha para evitar overflow
	
	addi a0 t0 7
	addi a1 t1 15
	li a2 320
	la a3 mapaBackup
	xy2men
	lbu t5 (a0) # carrega o conteudo do pixel central de baixo para cehcar comida

	li t6 0x000000ff
	beq t5 t6 IF_COMIDA2
	j ENDIF_COMIDA2
	IF_COMIDA2:
	
	
	lw t5 (s1) # incrementa 1 ponto
	addi t5 t5 1
	sw t5 (s1)  
	
	# apaga os outros 4 pixels
	
	
	
	addi a0 t0 7
	addi a1 t1 15
	li a2 320
	li a3 0xff000000
	xy2men
	
	
	
	sb zero (a0)
	sb zero 1(a0)
	sb zero 320(a0)
	sb zero 321(a0)
	

	#apaga a comida do backup
	addi a0 t0 7
	addi a1 t1 15
	li a2 320
	la a3 mapaBackup
	xy2men
	
	
	sb zero (a0)
	sb zero 1(a0)
	sb zero 320(a0)
	sb zero 321(a0)
	
	lbu a0 3(s0)
	lbu a1 2(s0)
	li a2 320
	la a3 mapaBackup
	printBlack1
	
	soundPAC
	
	ENDIF_COMIDA2:
	

	
	li t6 0x00000037
	beq t5 t6 IF_ESPECIAL2 # checa a comidinha amarela do especial
	j ENDIF_ESPECIAL2
	IF_ESPECIAL2:
	
	        li t6 1
		sb t6 0(s2)
		li t6 ESPECIAL_TIME
		sb t6 1(s2)
		
		mv a0 t0
		addi a1 t1 8
		li a2 320
		li a3 0xff000000
		printBlack
		
		#apaga no backup
		
		mv a0 t0
		addi a1 t1 8
		li a2 320
		la a3 mapaBackup
		printBlack


	
	
	ENDIF_ESPECIAL2:
	
	
	# outras colisoes de cores
	
	
	
	j ENDFOOD
	RIGHT:
	
	addi a0 t0 15
	addi a1 t1 7
	li a2 320
	la a3 mapaBackup
	xy2men
	lbu t5 (a0) # carrega o conteudo do pixel central da direita para cehcar comida
	
	li t6 0x000000ff
	beq t5 t6 IF_COMIDA3
	j ENDIF_COMIDA3
	IF_COMIDA3:
	
	
	lw t5 (s1) # incrementa 1 ponto
	addi t5 t5 1
	sw t5 (s1)  
	
	# apaga os outros 4 pixels
	
	
	addi a0 t0 15
	addi a1 t1 7
	li a2 320
	li a3 0xff000000
	xy2men
	
	sb zero (a0)
	sb zero 1(a0)
	sb zero 320(a0)
	sb zero 321(a0)
	

	
	#apaga comida do backup
	addi a0 t0 15
	addi a1 t1 7
	li a2 320
	la a3 mapaBackup
	xy2men
	
	
	sb zero (a0)
	sb zero 1(a0)
	sb zero 320(a0)
	sb zero 321(a0)
	
	lbu a0 3(s0)
	lbu a1 2(s0)
	li a2 320
	la a3 mapaBackup
	printBlack1
	
	soundPAC
	
	ENDIF_COMIDA3:
	
	
	li t6 0x00000037
	beq t5 t6 IF_ESPECIAL3 # checa a comidinha amarela do especial
	j ENDIF_ESPECIAL3
	IF_ESPECIAL3:
	
	        li t6 1
		sb t6 0(s2)
		li t6 ESPECIAL_TIME
		sb t6 1(s2)
		
		addi a0 t0 8
		addi a1 t1 0 
		li a2 320
		li a3 0xff000000
		printBlack
		
		#apaga no backup
		
		addi a0 t0 8
		addi a1 t1 0
		li a2 320
		la a3 mapaBackup
		printBlack


	
	ENDIF_ESPECIAL3:
	
	# outras colisoes de cores
	
	

	
	
	j ENDFOOD
	LEFT:
	
	
	addi a0 t0 0
	addi a1 t1 7
	li a2 320
	la a3 mapaBackup
	xy2men
	lbu t5 (a0) # carrega o conteudo do pixel central da esquerda para cehcar comida
	
	
	li t6 0x000000ff
	beq t5 t6 IF_COMIDA4
	j ENDIF_COMIDA4
	IF_COMIDA4:
	
	
	lw t5 (s1) # incrementa 1 ponto
	addi t5 t5 1
	sw t5 (s1)  
	
	# apaga os outros 4 pixels
	
	addi a0 t0 0
	addi a1 t1 7
	li a2 320
	li a3 0xff000000
	xy2men
	
	# apaga a comida do backup
	sb zero (a0)
	sb zero -1(a0)
	sb zero 320(a0)
	sb zero 319(a0)
	
	
	addi a0 t0 0
	addi a1 t1 7
	li a2 320
	la a3 mapaBackup
	xy2men
	
	
	sb zero (a0)
	sb zero -1(a0)
	sb zero 320(a0)
	sb zero 319(a0)
	
	
	
	lbu a0 3(s0)
	lbu a1 2(s0)
	li a2 320
	la a3 mapaBackup
	printBlack1
	
	soundPAC
	
	ENDIF_COMIDA4:
	
	
	
	# outras colisoes de cores
	
	
	li t6 0x00000037
	beq t5 t6 IF_ESPECIAL4 # checa a comidinha amarela do especial
	j ENDIF_ESPECIAL4
	IF_ESPECIAL4:
	
	        li t6 1
		sb t6 0(s2)
		li t6 ESPECIAL_TIME
		sb t6 1(s2)
		
		addi a0 t0 -8
		addi a1 t1 0
		li a2 320
		li a3 0xff000000
		printBlack
		
		#apaga no backup
		
		addi a0 t0 -8
		addi a1 t1 0
		li a2 320
		la a3 mapaBackup
		printBlack


	
	ENDIF_ESPECIAL4:
	
	
	j ENDFOOD
	ENDFOOD:
	
	
	
	.end_macro
	
	
	
.macro printPlacar

	# printa os pontos na tela 
	la s1 PONTOS_DE_COMIDA
	la s2 PONTOS_EXTRAS
	
	li a7 104
	la a0 pontostr
	li a1 255
	li a2 60
	li a3 0x00FF
	ecall
	li a7 101
	lbu t0 (s1)
	lbu t1 (s2)
	add a0 t0 t1
	li a1 255
	li a2 75
	li a3 0x00FF
	ecall


	.end_macro
	
.macro printVidas
	# printa os vida na tela
	la s1 VIDAS
	
	li a7 104
	la a0 vidasstr
	li a1 255
	li a2 100
	li a3 0x00FF
	ecall
	li a7 101
	lbu a0 (s1)
	li a1 305
	li a2 100
	li a3 0x00FF
	ecall


	.end_macro
	
.macro loadGhosts

	la a0 blinkyU
	li s0 256	
	la s1 blinkyUimg
	print
	
	
	la a0 sueU
	li s0 256	
	la s1 sueUimg
	print
	
	
	la a0 pinkyU
	li s0 256	
	la s1 pinkyUimg
	print
	
	
	la a0 inkyU
	li s0 256	
	la s1 inkyUimg
	print
	
	
	la a0 especial1
	li s0 256	
	la s1 especial1img
	print

	.end_macro
	
	
	
.macro blinkyIA # recebe em s0 a label do fantasma 
	
	
	li a7 41
	ecall
	li t6 40
	rem a0 a0 t6
	
	beq a0 zero IF0
	li t6 1
	beq a0 t6 IF1
	li t6 2
	beq a0 t6 IF2
	li t6 3
	beq a0 t6 IF3
	
	j ENDMOVE
	
	IF0:
		li t6 119
		sb t6 (s0)
		
	j ENDMOVE
	IF1:
		li t6 115
		sb t6 (s0)
	j ENDMOVE
	IF2:
		li t6 97
		sb t6 (s0)
	j ENDMOVE
	IF3:
		li t6 100
		sb t6 (s0)
	j ENDMOVE
	ENDMOVE:
	.end_macro


	
	
.macro ghostEspecialCONT

	la s0 GOHSTS
	lbu t0 (s0)
	lbu t1 1(s0)
	
	
	
	beq zero t1 IF
	
	addi t1 t1 -1
	sb t1 1(s0)
	
	j ENDIF
	IF:
	
	sb zero (s0) # cancela a flag do especial
	
	ENDIF:
	
	


	.end_macro
.macro changeGhosts
	
	la s0 GOHSTS
	lbu t0 (s0)
	la s1 BLINKYIMG
	la s2 SUEIMG
	la s7 PINKYIMG
	la s8 INKYIMG
	
	beq zero t0 IF
	
		li s6 256 # será decrementado até zero 
		la s3 especial1img
		LOOP2:
		
		beq s6 zero ENDLOOP2
		
		
		lw t4 (s3) # troca a imagen de pac...img para o label PACIMG que se´ra printado
		sw t4 (s1)
		sw t4 (s2)
		sw t4 (s7)
		sw t4 (s8)	
		addi s1 s1 4
		addi s2 s2 4
		addi s7 s7 4
		addi s8 s8 4
		addi s3 s3 4
		addi s6 s6 -4	
		
		j LOOP2
		ENDLOOP2:
	
	
	
	
	j ENDIF
	IF:

		li s6 256 # será decrementado até zero 
		la s3 blinkyUimg
		la s4 sueUimg
		la s9 pinkyUimg
		la s10 inkyUimg
		LOOP1:
		
		beq s6 zero ENDLOOP1
		
		
		lw t4 (s3) # printa o blinky normal
		sw t4 (s1)
		
		
		lw t4 (s4) # printa a Sue normal
		sw t4 (s2)
		
		lw t4 (s9) # printa a Sue normal
		sw t4 (s7)	
		
		lw t4 (s10) # printa a Sue normal
		sw t4 (s8)
		
		
		
		addi s1 s1 4
		addi s2 s2 4
		addi s3 s3 4 # incrementa o blinky
		addi s7 s7 4
		addi s8 s8 4
		addi s9 s9 4
		addi s10 s10 4
		addi s4 s4 4
		addi s6 s6 -4	
		
		j LOOP1
		ENDLOOP1:

	ENDIF:
	
	
	.end_macro
	
	
.macro ghostColision	
	la s0 VIDAS
	la s1 PACMAN
	#la s2 BLINKY
	la s3 PONTOS_EXTRAS
	
	lbu t0 3(s1)
	lbu t1 2(s1)
	
	addi a0 t0 7
	addi a1 t1 -1
	li a2 320
	li a3 0xff000000
	xy2men
	lbu t5 (a0) # carrega o pixel para checar as cores dos fantasmas
	li t6 0x00000006
	beq t5 t6 ghostFind # cor do blinky
	li t6 0x00000027
	beq t5 t6 ghostFind # cor do sue
	li t6 0x000000EF
	beq t5 t6 ghostFind # cor do sue
	li t6 0x000000F8
	beq t5 t6 ghostFind # cor do sue
	li t6 0x000000c1
	beq t5 t6 ghostKill # cor do volneravel
	
	
	addi a0 t0 7
	addi a1 t1 16
	li a2 320
	li a3 0xff000000
	xy2men
	lbu t5 (a0) # carrega o pixel para checar as cores dos fantasmas
	li t6 0x00000006
	beq t5 t6 ghostFind # cor do blinky
	li t6 0x00000027
	beq t5 t6 ghostFind # cor do sue
	li t6 0x000000EF
	beq t5 t6 ghostFind # cor do sue
	li t6 0x000000F8
	beq t5 t6 ghostFind # cor do sue
	li t6 0x000000c1
	beq t5 t6 ghostKill # cor do volneravel
	
	addi a0 t0 16
	addi a1 t1 7
	li a2 320
	li a3 0xff000000
	xy2men
	lbu t5 (a0) # carrega o pixel para checar as cores dos fantasmas
	li t6 0x00000006
	beq t5 t6 ghostFind # cor do blinky
	li t6 0x00000027
	beq t5 t6 ghostFind # cor do sue
	li t6 0x000000EF
	beq t5 t6 ghostFind # cor do sue
	li t6 0x000000F8
	beq t5 t6 ghostFind # cor do sue
	li t6 0x000000c1
	beq t5 t6 ghostKill # cor do volneravel
	
	
	addi a0 t0 -1
	addi a1 t1 7
	li a2 320
	li a3 0xff000000
	xy2men
	lbu t5 (a0) # carrega o pixel para checar as cores dos fantasmas
	li t6 0x00000006
	beq t5 t6 ghostFind # cor do blinky
	li t6 0x00000027
	beq t5 t6 ghostFind # cor do sue
	li t6 0x000000EF
	beq t5 t6 ghostFind # cor do sue
	li t6 0x000000F8
	beq t5 t6 ghostFind # cor do sue
	li t6 0x000000c1
	beq t5 t6 ghostKill # cor do volneravel
	
	
	
	
	j END_ghostFind
	
	ghostFind: 
	
	
	
	# delay antes de restrat
	li a7 32
	li a0 300
	ecall
	
	
	# caso tenha mais de 0 vidas
	lbu t5 (s0)
	addi t5 t5 -1
	sb t5 (s0)
	
	mv a0 t0 # apaga as antigas posições
	mv a1 t1 
	li a2 320
	li a3 0xff000000
	rePrintBackup
	
	# musica de perder vida
	
	fillTileSet
	
	la s0 VIDAS
	lbu t5 (s0)
	beq t5 zero GAME_OVER
	
	# setiver mais vidas simplesmente reseta o mapa
	# starta a posição do pacman em relação ao 320x240
	la s0 PACMAN
	li t1 0x86b06400 # starta o pacman na posiçao 134x176(86xb0) para adireita 100(64) e pode se mover 01
	sw t1 (s0)


	la s0 BLINKY
	li t1 0x86506400 # carrega a posição inicial do blinky com direçõ para a direita
	sw t1 (s0)
	la s0 SUE
	li t1 0x86506100 # carrega a posição inicial do blinky com direçõ para a direita
	sw t1 (s0)
	la s0 INKY
	li t1 0x86506100 # carrega a posição inicial do blinky com direçõ para a direita
	sw t1 (s0)
	la s0 PINKY
	li t1 0x86506400 # carrega a posição inicial do blinky com direçõ para a direita
	sw t1 (s0)
	
	readyStr
		
	
	END_ghostFind:
	
	
	j END_GAME_OVER
	GAME_OVER:
	# caso as vidas chegem em o
	

	li a7 104
	la a0 gameOverstr
	li a1 106
	li a2 84
	li a3 0x0007
	ecall
	printVidas
	gameOverMusic

	li a7 10
	ecall # acaba com a execução
	
	END_GAME_OVER:
	
	
	
	
	
	
	
	j END_ghostKill
	ghostKill:
	
	lw t5 (s3) # adiciona pontos por morte do fantasma 
	addi t5 t5 20
	sw t5 (s3)
	
	ghostDist
	mv s2 s0
	
	lbu a0 3(s2)
	lbu a1 2(s2) 
	li a2 320
	li a3 0xff000000
	printBlack
	
	
	#la s0 BLINKY
	ghostDist
	rePrintFood
	la s0 PACMAN
	rePrintFood
	fillTileSet
	
	
	
	


	ghostDist
	li t1 0x86506400 # carrega a posição inicial do blinky com direçõ para a direita
	sw t1 (s0)
	
	END_ghostKill:
	
	.end_macro
	
.macro ghostDist # retorn em s0 0 fantasma com a menor distancia ente o pacman e ele



	la s0 PACMAN
	la s1 BLINKY
	la s2 SUE
	la s3 INKY
	la s4 PINKY


	# blinky
	lbu t0 3(s0)
	lbu t1 2(s0)
	lbu t2 3(s1)
	lbu t3 2(s1)
	
	sub t0 t0 t2
	sub t1 t1 t3
	mul t0 t0 t0
	mul t1 t1 t1
	add t0 t0 t1
	fcvt.s.w ft0 t0
	fsqrt.s ft1 ft0
	
	
	#SUE
	lbu t0 3(s0)
	lbu t1 2(s0)
	lbu t2 3(s2)
	lbu t3 2(s2)
	
	sub t0 t0 t2
	sub t1 t1 t3
	mul t0 t0 t0
	mul t1 t1 t1
	add t0 t0 t1
	fcvt.s.w ft0 t0
	fsqrt.s ft2 ft0
	
	
	#INKY
	lbu t0 3(s0)
	lbu t1 2(s0)
	lbu t2 3(s3)
	lbu t3 2(s3)
	
	sub t0 t0 t2
	sub t1 t1 t3
	mul t0 t0 t0
	mul t1 t1 t1
	add t0 t0 t1
	fcvt.s.w ft0 t0
	fsqrt.s ft3 ft0
	
	
	#PINKY
	lbu t0 3(s0)
	lbu t1 2(s0)
	lbu t2 3(s4)
	lbu t3 2(s4)
	
	sub t0 t0 t2
	sub t1 t1 t3
	mul t0 t0 t0
	mul t1 t1 t1
	add t0 t0 t1
	fcvt.s.w ft0 t0
	fsqrt.s ft4 ft0
	
	fle.s t5 ft1 ft2 # checa se o pinky ta mais perto
	beq t5 zero ENDCHECK1
	fle.s t5 ft1 ft3
	beq t5 zero ENDCHECK1
	fle.s t5 ft1 ft4
	ENDCHECK1:
	
	bne t5 zero IF_BLINKY
	
	fle.s t5 ft2 ft1 # checa se o pinky ta mais perto
	beq t5 zero ENDCHECK2
	fle.s t5 ft2 ft3
	beq t5 zero ENDCHECK2
	fle.s t5 ft2 ft4
	ENDCHECK2:
	
	bne t5 zero IF_SUE
	
	
	fle.s t5 ft3 ft1 # checa se o pinky ta mais perto
	beq t5 zero ENDCHECK3
	fle.s t5 ft3 ft2
	beq t5 zero ENDCHECK3
	fle.s t5 ft3 ft4
	ENDCHECK3:
	
	bne t5 zero IF_INKY
	
	
	fle.s t5 ft4 ft1 # checa se o pinky ta mais perto
	beq t5 zero ENDCHECK4
	fle.s t5 ft4 ft2
	beq t5 zero ENDCHECK4
	fle.s t5 ft4 ft3
	ENDCHECK4:
	
	bne t5 zero IF_PINKY
	
	
	j ENDIF
	IF_BLINKY:
	
	la s0 BLINKY
	
	j ENDIF
	IF_SUE:

	la s0 SUE
	
	j ENDIF
	IF_INKY:
	
	la s0 INKY
	
	j ENDIF
	IF_PINKY:
	
	la s0 PINKY
	
	j ENDIF
	ENDIF:
	

	.end_macro

.macro mapStart # salva um backup do mapa para fins de n apagar as comida
		# printa mensagens iniciais
		#recebe o mapa do backup no a0
	
	li s0 76800
	la s1 mapaBackup	
	print  #bacup do mapa para fins de n apagar as comidas

	readyStr
	.end_macro
	
.macro readyStr
	
	li a7 104             # printa o ready no iniccio e depios dá  um delay
	la a0 readystr
	li a1 106
	li a2 84
	li a3 0x0007
	ecall

	li a7 32
	li a0 3000
	ecall
	

	li s11 106
	
	LOOP:
	li t6 186
	beq s11 t6 END_LOOP
	mv a0 s11 
	li a1 80
	li a2 320
	li a3 0xff000000
	printBlack

	addi s11 s11 16
	j LOOP
	END_LOOP:	
	
	
	.end_macro
	
	
	
	
.macro rePrintFood # recebe em s0 a lebel contendo a posição do reprint

	la s1 mapaBackup
	
	lbu t0 3(s0)
	lbu t1 2(s0)	
	
	li s5 0 # contador do offset
	li s6 0 #
	
	LOOP:
	li t6 16
	beq s6 t6 ENDLOOP
	
	mv a0 t0
	mv a1 t1
	li a2 320
	li a3 0xff000000
	xy2men
	lbu s10 (a0) # salva o prixel do fantasma no s10
	
			
	mv a0 t0
	mv a1 t1
	li a2 320
	la a3 mapaBackup
	xy2men
	lbu s11 (a0) # salva o pixel do backup do mapa no s11	
	
					
	#if s10 == 0 && s10 != s11 reprinta o pixel na vga
	beq s10 zero IF1								
																	
	j ENDIF1																																
	IF1:
	
		bne s10 s11 IF2
		j ENDIF2
		IF2:
		
			mv a0 t0
			mv a1 t1
			li a2 320
			li a3 0xff000000
			xy2men
			sb s11 (a0)
			
		ENDIF2:
		
	ENDIF1:
	
	addi t0 t0 1
	addi s5 s5 1
	
	li t6 16
	beq s5 t6 IF3
	j ENDIF3
	IF3:	
	
		
	lbu t0 3(s0)			
	addi t1 t1 1
	li s5 0
	addi s6 s6 1
				
	ENDIF3:						
													
	j LOOP	
	ENDLOOP:	
																																																																
	.end_macro
	
		
.macro mapaChange
	la s0 MAPA
	la s1 PONTOS_DE_COMIDA
	la s2 PONTOS_EXTRAS
	
	lbu t0 (s0)
	
	li t6 1
	beq t0 t6 CMAPA1
	
	li t6 2
	beq t0 t6 CMAPA2
	
	li t6 3
	beq t0 t6 CMAPA3
	
	li t6 4
	beq t0 t6 CMAPA4
	
	j END_CMAPA	
	CMAPA1:
	
		li t6 220
		lw t5 (s1)
		beq t6 t5 IF1
		
		j ENDIF1
		IF1:
		
			lw t4 (s2)
			add t4 t4 t5
			sw t5 (s2) # salva a soma do contador de comida com os extras
			
			li t6 2
			sb t6 (s0) # muda o mapa
			
			sw zero (s1) # zera o contador de comida
			
			la s6 STARTALL_GAME
			jalr s6 0
		ENDIF1:
					
	j END_CMAPA						
	CMAPA2:
	
		li t6 240
		lw t5 (s1)
		beq t6 t5 IF2
		
		j ENDIF2
		IF2:
		
			lw t4 (s2)
			add t4 t4 t5
			sw t5 (s2) # salva a soma do contador de comida com os extras
			
			li t6 3
			sb t6 (s0) # muda o mapa
			
			sw zero (s1) # zera o contador de comida
			
			la s6 STARTALL_GAME
			jalr s6 0
		
		ENDIF2:
			
	j END_CMAPA
	CMAPA3:
	
		li t6 238
		lw t5 (s1)
		beq t6 t5 IF3
		
		j ENDIF3
		IF3:
		
			lw t4 (s2)
			add t4 t4 t5
			sw t5 (s2) # salva a soma do contador de comida com os extras
			
			li t6 4
			sb t6 (s0) # muda o mapa
			
			sw zero (s1) # zera o contador de comida
			
			la s6 STARTALL_GAME
			jalr s6 0
		
		ENDIF3:
				
	j END_CMAPA						
	CMAPA4:
	
		li t6 266
		lw t5 (s1)
		beq t6 t5 IF4
		
		j ENDIF4
		IF4:
		
			lw t4 (s2)
			add t4 t4 t5
			sw t5 (s2) # salva a soma do contador de comida com os extras
			
			li t6 2
			sb t6 (s0) # muda o mapa
			
			sw zero (s1) # zera o contador de comida
			
			la s6 STARTALL_GAME
			jalr s6 0
		
		ENDIF4:
			
	j END_CMAPA																																																																									
	END_CMAPA:							
		
	.end_macro	
	
.text	
######################## START MAIN ############################

# seta o exception handler
 la t0,exceptionHandling		# carrega em t0 o endere?o base das rotinas do sistema ECALL
 csrrw zero,5,t0 		# seta utvec (reg 5) para o endere?o t0
 csrrsi zero,0,1 		# seta o bit de habilitaçãoo de interrupçãoo em ustatus (reg 0)

STARTALL_GAME:

la s0 MAPA

lbu t5 (s0)

li t6 1
beq t5 t6 IF_MAPA1
li t6 2
beq t5 t6 IF_MAPA2
li t6 3
beq t5 t6 IF_MAPA3
li t6 4
beq t5 t6 IF_MAPA4

j ENDIF_MAPA
IF_MAPA1:

la a0 mapa1
li s0 76800
li s1 0xff000000	
print  # imprime o mapa na memoria vga

la a0 mapa1
mapStart

j ENDIF_MAPA
IF_MAPA2:

la a0 mapa2
li s0 76800
li s1 0xff000000	
print  # imprime o mapa na memoria vga

la a0 mapa2
mapStart

j ENDIF_MAPA
IF_MAPA3:

la a0 mapa3
li s0 76800
li s1 0xff000000	
print  # imprime o mapa na memoria vga

la a0 mapa3
mapStart

j ENDIF_MAPA
IF_MAPA4:

la a0 mapa4
li s0 76800
li s1 0xff000000	
print  # imprime o mapa na memoria vga

la a0 mapa4
mapStart

j ENDIF_MAPA


ENDIF_MAPA:

pixelMap # salva no endereço 0x10040000 os pixels das quinas de quandrados de 8x8
la s0 TILESET
fillTileSet

loadPACIMG # salva a imagens do pacman na ram

loadGhosts # salva as imagens de fantasmas na ram

STARTPAC_GAME: # labe de restar do pacman e do blinky

# starta a posição do pacman em relação ao 320x240
la s0 PACMAN
li t1 0x86b06400 # starta o pacman na posiçao 134x176(86xb0) para adireita 100(64) e pode se mover 01
sw t1 (s0)

STARTBLINKY_GAME: # labe de restart do game somente do blinky

la s0 BLINKY
li t1 0x86506400 # carrega a posição inicial do blinky com direçõ para a direita
sw t1 (s0)

 # labe de restart do game somente do blinky

la s0 PINKY
li t1 0x86506400 # carrega a posição inicial do blinky com direçõ para a direita
sw t1 (s0)

la s0 SUE
li t1 0x86506400 # carrega a posição inicial do blinky com direçõ para a direita
sw t1 (s0)

la s0 INKY
li t1 0x86506100 # carrega a posição inicial do blinky com direçõ para a direita
sw t1 (s0)

miniMapa

# animações de começo de mapa ou jogo




################# MAIN GAME LOOP #########################################
mainGameLoop:

	
# mover pacman
	
	#miniMapa # mostra o tileset (comentar para ficar mais rapido)
	tileSetPAC # Ajusta o pacman no tileset para verificar as curvas
	
	getKeyBoard # salva tecla precionada em a0
	la s0 PACMAN
	la s1 PACTILE
	waitKey # Muda a direção somente quando for apto e salva a tecla precionada para quando ele puder vira
	# checar colisoes com as comidas etc
	
	colisionContFood
	
	#move o pacman
	la s0 PACMAN
	movePAC # muda a posição do pacman relativa a sua dreção na labe 1(PACMAN) 

	
	
	
#estenssão do jump

	
# chaca colisao com fantasmas 
	ghostEspecialCONT
	ghostColision
	
	
	
# mover fantasmas
	
	la s0 BLINKY
	la s3 BLINKYTILE
	tileSetBlinky
	
	la s0 SUE
	la s3 SUETILE
	tileSetBlinky
	
	la s0 PINKY
	la s3 PINKYTILE
	tileSetBlinky
	
	la s0 INKY
	la s3 INKYTILE
	tileSetBlinky
	
	la s0 BLINKY 	
	blinkyIA
	la s0 BLINKY
	la s1 BLINKYTILE
	waitKey
	
	la s0 SUE 	
	blinkyIA
	la s0 SUE
	la s1 SUETILE
	waitKey
	
	la s0 PINKY 	
	blinkyIA
	la s0 PINKY
	la s1 PINKYTILE
	waitKey
	
	la s0 INKY 	
	blinkyIA
	la s0 INKY
	la s1 INKYTILE
	waitKey
	
	la s0 BLINKY
	movePAC
	
	la s0 SUE 
	movePAC
	
	la s0 INKY
	movePAC
	
	la s0 PINKY
	movePAC
	
# imprimair pacman e fantasmas

changeGhosts
la s0 BLINKY
la s10 BLINKYIMG
printPAC

la s0 SUE
la s10 SUEIMG
printPAC

la s0 PINKY
la s10 PINKYIMG
printPAC

la s0 INKY
la s10 INKYIMG
printPAC



# checar se ele apagou alguma comida

la s0 BLINKY
rePrintFood

la s0 SUE
rePrintFood

la s0 PINKY
rePrintFood

la s0 INKY
rePrintFood


changePACIMG # muda as imagens presentes no PACIMG de acordo com a rireção e de 3 em 3 interações
la s0 PACMAN
la s10 PACIMG # carrega a labem de pacimg no s10 exatamente na posição x y do PACMAN
printPAC # imprime o conteudo de s10

# Printa o Blinky

printPlacar
printVidas
mapaChange

#sleep
#li a7 32
#li a0 1
#ecall




la t0 mainGameLoop
jalr t0 , 0

END_mainGameLoop:



.include "SYSTEMv11.s"



