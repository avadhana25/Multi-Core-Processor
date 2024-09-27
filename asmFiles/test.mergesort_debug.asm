org 0x0000

ori   $8, $0, 0xFFC
   ori   $2, $0, 0xFFC
   lui $3, 0xffff7  
  sub $2, $2, $3
  sub $8, $8, $3
  lui $3, 0x00007
  add $2, $2, $3
  add $8, $8, $3
   ori   $12, $0, data
   lw    $24, size($0)
   ori   $6, $0, 1
   srl  $13,$24,$6
   or    $9, $0, $12
   or    $18, $0, $13
   jal   insertion_sort

  
insertion_sort:
  ori   $5, $0, 4
   ori   $7, $0, 2
   sll  $6,$13,$7
 is_outer:
  sltu  $4, $5, $6
   beq   $4, $0, is_inner_end
   add  $31, $12, $5
   lw    $30, 0($31)
is_inner:
  beq   $31, $12, is_inner_end
  nop
   lw    $16, -4($31)
   slt   $4, $30, $16
   beq   $4, $0, is_inner_end
   sw    $16, 0($31)
   addi $31, $31, -4
   j     is_inner
is_inner_end:
  sw    $30, 0($31)
   addi $5, $5, 4
   halt

org 0x300
size:
cfw 64
data:
cfw 90
cfw 81
cfw 51
cfw 25
cfw 80
cfw 41
cfw 22
cfw 21
cfw 12
cfw 62
cfw 75
cfw 71
cfw 83
cfw 81
cfw 77
cfw 22
cfw 11
cfw 29
cfw 7
cfw 33
cfw 99
cfw 27
cfw 100
cfw 66
cfw 61
cfw 32
cfw 1
cfw 54
cfw 4
cfw 61
cfw 56
cfw 3
cfw 48
cfw 8
cfw 66
cfw 100
cfw 15
cfw 92
cfw 65
cfw 32
cfw 9
cfw 47
cfw 89
cfw 17
cfw 7
cfw 35
cfw 68
cfw 32
cfw 10
cfw 7
cfw 23
cfw 92
cfw 91
cfw 40
cfw 26
cfw 8
cfw 36
cfw 38
cfw 8
cfw 38
cfw 16
cfw 50
cfw 7
cfw 67

org 0x500
sorted:
