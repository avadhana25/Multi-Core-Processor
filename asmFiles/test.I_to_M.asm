#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Test Block transition from Invalid to Modified and Modified to Invalid
#--------------------------------------
org 0x0000
  addi $4, $0, 0xF000     #memory
  addi $5 , $0, 0x6226
  sw $5, 0($4)           #block at address 0xF000 should now be in modified
  nop
  halt

org 0x0200
  addi $4, $0, 0xF000
  addi $5, $0, 0x8448
  nop
  nop
  sw $5, 8($4)           #block at address 0xF000 goes to Invalid, block at 0xF008 goes to Modified from Invalid
  halt

org   0xF000
  cfw   0x7337
  cfw   0x2701
  cfw   0x6116
  cfw   0x1611
