#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Test Block transition from Shared to Modified
#--------------------------------------
  org 0x0000
  addi $4, $0, 0x00F0     #memory
  lw $5, 0($4)           #block at address 0x00F0 should now be in shared
  sw $6, 4($4)           #block in core 1 will go to M, block in core 2 will go to I
  halt

org 0x0200
  addi $6, $0, 0x6116
  lw $5, 0($4)           #block at address 0x00F0 should now be in shared
  halt

org   0xF000
  cfw   0x7337
  cfw   0x2701

