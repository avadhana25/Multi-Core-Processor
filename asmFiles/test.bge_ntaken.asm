#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Test bge not taken
#--------------------------------------
  org 0x0000
  addi $10, $0, 0x28      #memory
  addi $3, $0, -4
  addi $4, $0, 5
  addi $5, $0, 15         #failure symbol
  addi $6, $0, 12          #success symbol
  bge $3, $4, taken
  nop
  nop
  sw $6, 0($10)           #if branch not taken store success
  halt

  taken:
  sw $5, 0($10)           #if taken store failure
  halt
