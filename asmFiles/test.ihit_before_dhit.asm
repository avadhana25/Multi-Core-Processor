//tests a dhit and ihit both happening at the same time
org 0x0000
    ori   $4, $0, 0xF0
    addi  $5, $0, 2
    loop:  or $4,$4,$7
           lw $6, 0($4)
           addi $7,$0,8 //lw in decode
           addi $8,$0,1 //lw in execute
           addi $9,$0,1 //lw in mem, should be ihit and dhit in second iteration
           addi $5,$5,-1
           bne $5,$0,loop
    halt


org   0x00F0
  cfw   0x7337
  cfw   0x2701

org  0x00F8
  cfw  0x1234
