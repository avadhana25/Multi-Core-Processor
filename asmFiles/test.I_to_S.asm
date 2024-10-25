#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Test Block transition from Invalid to Shared and Modified to Shared
#--------------------------------------
org 0x0000
  addi $4, $0, 0xF000     #memory
  addi $5, $0, 0x23
  sw $5, 0($4)           #block at address 0x00F0 should now be in modified
  nop
  halt

org 0x0200
  addi $4, $0, 0xF000
  nop
  nop
  lw $5, 0($4)            #block in cpu 2 goes from Invalid to Shared, block in cpu 1 goes from Modified to Shared            
    halt

org   0xF000
  cfw   0x7337
  cfw   0x2701
