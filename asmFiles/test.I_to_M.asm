#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Test Block transition from Invalid to Modified
#--------------------------------------
org 0x0000
  addi $4, $0, 0x00F0     #memory
  addi $5 , $0, 0x6226
  sw $5, 0($4)           #block at address 0x00F0 should now be in modified
  halt

org 0x0200
    halt

org   0xF000
  cfw   0x7337
  cfw   0x2701
