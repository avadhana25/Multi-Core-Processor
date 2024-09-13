#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Test bne taken
#--------------------------------------
  org 0x0000
  addi $10, $0, 0x28      #memory
  addi $3, $0, 4
  addi $4, $0, 5
  addi $5, $0, 15         #failure symbol
  addi $6, $0, 12          #success symbol
  bne $3, $4, taken
  nop
  nop
  nop
  sw $5, 0($10)           #if branch not taken store failure
  halt

  taken:
  sw $6, 0($10)           #if taken store success
  halt
