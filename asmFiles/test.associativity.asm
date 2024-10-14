org 0x0000

  ori   $4, $0, 0xF0
  ori   $5, $0, 0x1F0
  lw    $10, 0($4) //should be cache miss
  lw    $12, 0($5) //should be cache miss
  lw    $11, 4($4) //should be cache hit
  halt
  
org   0x00F0
  cfw   0x7337
  cfw   0x2701

org   0x01F0 //same index as 0x00F0 (110)
  cfw   0x1234
