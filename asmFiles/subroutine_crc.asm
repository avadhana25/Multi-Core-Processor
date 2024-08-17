#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#REGISTERS
#at $1 at
#v $2-3 function returns
#a $4-7 function args
#t $8-15 temps
#s $16-23 saved temps (callee preserved)
#t $24-25 temps
#k $26-27 kernel
#gp $28 gp (callee preserved)
#sp $29 sp (callee preserved)
#fp $30 fp (callee preserved)
#ra $31 return address

# USAGE random0 = crc(seed), random1 = crc(random0)
#       randomN = crc(randomN-1)
#------------------------------------------------------
# $v0 = crc32($a0)
crc32:
  lui $6, 0x04C11
   ori $6, $6, 0x7B7
   addi $6, $6, 0x600
   or $7, $0, $0
   ori $28, $0, 32
 
l1:
  slt $29, $7, $28
   beq $29, $0, l2
 
  ori $30, $0, 31
   srl $29,$12,$30
   ori $30, $0, 1
   sll $12,$12,$30
   beq $29, $0, l3
   xor $12, $12, $6
 l3:
  addi $7, $7, 1
   j l1
l2:
  or $10, $12, $0
   jr $1
