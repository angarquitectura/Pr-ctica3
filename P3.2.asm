.data
.eqv tensionControl 0xffff0040
.eqv tensionEstado 0xffff0044
.eqv tensionDiastol 0xffff0048
.eqv tensionSistol 0xffff0060
tensiones: .word 120 80
sms: .asciiz "midiendo\n"
sms2: .asciiz "error en la medicion...\n"
sms3: .asciiz "presion sistolica: "
sms4: .asciiz "presion diastolica: "
newline: .asciiz "\n"
.text
main:
li $t0,0
sw $t0,tensionEstado
jal controlador_tension
move $t1,$v0
move $t2,$v1
li $v0,4
la $a0,sms3
syscall 
move $a0,$t1
li $v0,1
syscall

li $v0,4
la $a0,newline
syscall 

li $v0,4
la $a0,sms4
syscall 
move $a0,$t2
li $v0,1
syscall

li $v0,10
syscall
controlador_tension:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	iniciar_medicion:
	li $t0,1
	sw $t0,tensionControl
	li $t2,-1
	esperando:
	lw $t1,tensionEstado
	beqz $t1,mensaje
	beq $t1,1,results
	beq $t1,$t2,failed
	mensaje:
	la $a0,sms
	li $v0,4
	syscall 
	j esperando 
	failed:
	la $a0,sms2
	li $v0,4
	syscall
	move $v0,$zero
	move $v1,$zero
	j ret
	results:
	la $t3,tensiones
	lw $v0,0($t3)
	lw $v1,4($t3)
	sw $v0,tensionSistol
	sw $v1,tensionDiastol
	ret:
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
	
	
	
	
	
	
	
	








