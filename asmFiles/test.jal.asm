#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Test jal
#--------------------------------------
  org 0x0000
  addi $10, $0, 0x28      #memory
  addi $5, $0, 15         #failure symbol
  addi $6, $0, 12          #success symbol
  jal taken
  sw $5, 0($10)           #if jal not taken store failure
  halt


  taken:
  sw $6, 0($10)           #if taken store success
  halt
