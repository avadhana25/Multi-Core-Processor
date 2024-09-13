#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Test halt
#--------------------------------------
  org 0x0000
  addi $10, $0, 0x28      #memory
  addi $5, $0, 15         #failure symbol
  addi $6, $0, 12          #success symbol
  nop
  nop
  sw $6, 0($10)            #store success pre halt
  halt
  sw $5, 0($10)            #replace success with failure if gets past halt
