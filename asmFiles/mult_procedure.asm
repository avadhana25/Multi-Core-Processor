#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Aakash Vadhanam mult_procedure 8/26/24
#--------------------------------------
  org 0x0000

  main:
  addi $2, $0, 0xFFFC           #initialize stack at 0xFFFC
  add  $8, $8, $2               #set r8 to sp address
  addi $8, $8, -4               #set r8 to address sp will be after multiplying all operands
  addi $4, $4, 1                #set r4 to 4
  addi $5, $5, 2                #set r5 to 5
  addi $6, $6, 3                #set r6 to 6
  addi $7, $7, 4                #set r7 to 7
  push $4                       #push r4 onto stack
  push $5                       #push r5 onto stack
  push $6                       #push r6 onto stack
  push $7                       #push r7 onto stack
  
  compare:
  beq $2, $8, end              #if stack has one element, go to end
  j funct                       #jump to funct

  funct:
  j mult                       #jump to mult

  end:
  halt


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
  j compare                      #jump to compare
