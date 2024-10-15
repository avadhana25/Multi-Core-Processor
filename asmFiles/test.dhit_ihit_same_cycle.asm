//contains a lw whose instruction will be in icache and data in dcache at the same time
org 0x0000
    ori   $4, $0, 0xF0
    addi  $5, $0, 2
    loop: lw $6, 0($4)
           addi $5,$5,-1
           bne $5,$0,loop
    halt


org   0x00F0
  cfw   0x7337
  cfw   0x2701
