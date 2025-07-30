.data
.eqv sensor_control 0xffff0040
.eqv sensor_estado 0xffff0044
.eqv sensor_datos 0xffff0048
temp: .word 20 12 30 40 15
size: .word 5
sms: .asciiz "error del sensor... reiniciando\n"
sms2: .asciiz "iniciando...\n"
sms3: .asciiz "esperando...\n"
sms4: .asciiz "valor leido: "
sms5: .asciiz "error en la lectura\n"
.text
main:
li $t0,1
sw $t0,sensor_estado
jal iniciar
jal leer_temp
li $t0,-1
beq $v1,$t0,failed
beqz $v1,mostrar
failed:
la $a0,sms5
jal print
j finn
mostrar:
move $t1,$v0
la $a0,sms4
jal print
move $a0,$t1
li $v0,1
syscall
#li $t0,0
#sw $t0,sensor_estado
finn:
li $v0,10
syscall
iniciar:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	reset:
	la $a0,sms2
	jal print
	li $t0,0x2
	sw $t0,sensor_control
	loop:
	li $t2,-1
	lw $t1,sensor_estado
	beq $t1,1,salida
	beqz $t1,espera
	beq $t1,$t2,fail
	espera:
	la $a0,sms3
	jal print
	j loop
	fail:
	la $a0,sms
	jal print
	j reset
	salida:
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
leer_temp:
	addi $sp,$sp,4
	sw $ra,0($sp)
	li $t2,0
	li $t1,-1
	lw $t0,sensor_estado
	beq $t0,1,listo
	beqz $t0,error1
	beq $t0,$t1,error1
	listo:
	la $t2,temp
	li $t3,2
	sll $t4,$t3,2
	add $t4,$t2,$t4
	lw $t4,0($t4)
	sw $t4,sensor_datos
	move $v0,$t4
	li $v1,0
	j return
	error1:
	li $v0,-999
	li $v1,-1
	return:
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
	print:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	li $v0,4
	syscall 
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
	
	
	
	
	
	
	
	
