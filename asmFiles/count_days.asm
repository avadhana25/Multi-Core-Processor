#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Aakash Vadhanam count_days 8/26/24
#--------------------------------------
  org 0x0000

  main:
  addi $2, $0, 0xFFFC           #initialize stack at 0xFFFC
  addi $5, $0, 27               #r5 is current day 
  addi $6, $0, 8                #r6 is current month
  addi $7, $0, 2024             #r7 is current year
  addi $6, $6, -1               #month - 1
  addi $7, $7, -2000            #year - 2000
  addi $8, $0, 30               #set r8 to 30
  addi $9, $0, 365              #set r9 to 365
  push $8                       #push 30
  push $6                       #push month -1
  jal mult                      #call mult
  pop $11                       #pop result of 30 * (month - 1) into r11
  push $9                       #push 365
  push $7                       #push year - 2000
  jal mult                      #call mult
  pop $12                       #pop result of 365 * (year - 2000) into r12
  add $13, $5, $11              #r13 is result, add r5 and r11
  add $13, $13, $12             #add final value to get result in r13
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
  ret
  
