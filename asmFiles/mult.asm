#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Aakash Vadhanam mult 8/26/24
#--------------------------------------
  org 0x0000

  main:
  addi $2, $0, 0xFFFC           #initialize stack at 0xFFFC
  addi $5, $0, 4          #set r5 to 4
  addi $6, $0, 5          #set r6 to 5
  push $5                 #push r5 onto stack
  push $6                 #push r6 onto stack
  j mult                  #jump to mult



  mult:
  pop $3                         #pop first number in r3, use as counter
  pop $4                         #pop second operand
  add $10, $0, $0               #sum register

  check:
  beq $3, $0, finish             #if count = 0
  j loop                          #jump to loop

  loop:
  add $10, $10, $4               #add second operand to sum
  addi $3, $3, -1                    #decrease counter
  j check                        #jump back to counter check

  finish:
  push $10                       #push sum onto stack
  halt                           #stop


