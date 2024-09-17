#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Test bne not taken
#--------------------------------------
  org 0x0000
  addi $10, $0, 0x28      #memory at address A (10 * 4 = 0x28) in sim.hex
  addi $3, $0, 4
  addi $4, $0, 4
  addi $5, $0, 15         #failure symbol F
  addi $6, $0, 12          #success symbol C
  nop
  bne $3, $4, taken
  sw $6, 0($10)           #if branch not taken store success
  halt

  taken:
  sw $5, 0($10)           #if taken store failure
  halt
