#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Test jalr
#--------------------------------------
  org 0x0000
  addi $10, $0, 0x28      #memory
  addi $5, $0, 15         #failure symbol
  addi $6, $0, 12          #success symbol
  jal taken
  sw $6, 0($10)           #if jalr returns store success
  halt


  taken:
  jalr $1
  sw $5, 0($10)           #if jalr not taken store failure
  halt
