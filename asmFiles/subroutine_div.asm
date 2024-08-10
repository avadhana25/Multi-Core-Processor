#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
org   0x0000              # first processor p0
  ori   $2, $0, 0x3ffc  # stack
   ori   $24, $0, number     
   lw $12, 0($24)
   ori   $24, $0, divisor
   lw $13, 0($24)
   jal divide
  ori   $7, $0, quotient
   sw    $10, 0($7)
   ori   $7, $0, remainder
   sw    $11, 0($7)
   halt

divide:               # setup frame
  push  $1           # saved return address
   push  $12           # saved register
   push  $13           # saved register
   or    $10, $0, $0   # Quotient v0=0
   or    $11, $0, $12  # Remainder t2=N=a0
   beq   $0, $13, divrtn # test zero D
   slt   $5, $13, $0  # test neg D
   bne   $5, $0, divdneg
   slt   $5, $12, $0  # test neg N
   bne   $5, $0, divnneg
 divloop:
  slt   $5, $11, $13 # while R >= D
   bne   $5, $0, divrtn
   addi $10, $10, 1   # Q = Q + 1
   sub  $11, $11, $13 # R = R - D
   j     divloop
divnneg:
  sub  $12, $0, $12  # negate N
   jal   divide        # call divide
  sub  $10, $0, $10  # negate Q
   beq   $11, $0, divrtn
   addi $10, $10, -1  # return -Q-1
   j     divrtn
divdneg:
  sub  $12, $0, $13  # negate D
   jal   divide        # call divide
  sub  $10, $0, $10  # negate Q
 divrtn:
  pop $13
   pop $12
   pop $1
   jr  $1
 
number:
  cfw 8
divisor:
  cfw 2
quotient:
  cfw 0
remainder:
  cfw 0



# registers a0-1,v0-1,t0
# a0 = Numerator
# a1 = Denominator
# v0 = Quotient
# v1 = Remainder

#-divide(N=$a0,D=$a1) returns (Q=$v0,R=$v1)--------

#-divide--------------------------------------------
