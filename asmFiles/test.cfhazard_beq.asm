#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Test control flow hazard beq
#--------------------------------------
  org 0x0000
  addi $10, $0, 0x28      #memory
  addi $5,$0,10
  addi $6,$0,20
  beq $0,$0,jump
  sw $6,0($10)
  halt

  jump: sw $5,0($10)
  halt
