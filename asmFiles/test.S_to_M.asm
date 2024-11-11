#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Test Block transition from Shared to Modified and Shared to Invalid - works
#--------------------------------------
  org 0x0000
  addi $4, $0, 0xF000     #memory
  lw $5, 0($4)           #block at address 0x00F0 should now be in shared
  addi $6, $0, 0x6116
  sw $6, 4($4)           #block in core 1 will go to M, block in core 2 will go to I
  halt

org 0x0200
  addi $4, $0, 0xF000
  nop
  lw $5, 0($4)           #block at address 0x00F0 should now be in shared
  nop
  nop
  halt

org   0xF000
  cfw   0x7337
  cfw   0x2701

