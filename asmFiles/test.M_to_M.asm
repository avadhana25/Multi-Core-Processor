#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Test Block transition from Modified to Modified
#--------------------------------------
org 0x0000
  addi $4, $0, 0xF000     #memory
  sw $5, 0($4)           #block at address 0x00F0 should now be in modified
  addi $6, $0, 0x0011
  sw $6, 4($4)           #block should stay in Modified
  lw $7, 0($4)           #block should stay in Modified
  halt

org 0x0200
    halt

org   0xF000
  cfw   0x7337
  cfw   0x2701
