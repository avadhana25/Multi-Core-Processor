#Parallel algorithm for producer of randomly generated numbers 
#and consumer providing statistics
#Written by Brett Heckman and Aakash Vadhanam


#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#----------------------------------------------------------
# Core 1 Init
#----------------------------------------------------------
#this core generates the random numbers
	org 0x0000    
	li   sp, 0xFFFC    # core 1 stack
	
	lui  t0, 0xab275
	ori  t0, t0, 0x7fe #seed generation
	
	add  t3, $0, $0 #total random numbers generated
	addi t4, $0, 256 #max number to generate
				
	loop:     bne  t3, zero, store_a0 #check if first number generated					
						sw   t0, 0(a2) #store seed to crc32 argument location
						j    crc_call
				
  store_a0: sw a0, 0(a2) #put previous random number into a2

	crc_call: jal  crc32
						#lock
						ori  a3, zero, lock_var
						jal  lock
						#critical section----------
						ori  t2, zero, stack_pointer
						lw   t0, 0(t2)
						addi t1, t0, -4 #allocate space on stack
						sw   t1, 0(t2)
						sw   a0, 0(t2) #store random number
						#end critical section------
						ori  a0, zero, lock_var    # move lock to argument register
						jal  unlock                # release the lock
						addi t3, t3, 1
						blt  t3, t4, loop #check if 256 numbers have been generated

	halt

#----------------------------------------------------------
# Core 2 Init
#----------------------------------------------------------
#this core processes the random numbers
	org 0x0200               
	li   sp, 0x7FFC            # core 2 stack




	halt


#----------------------------------------------------------
# Shared Lock Functions
#----------------------------------------------------------
# pass in an address to lock function in argument register 0
# returns when lock is available
lock:
acquire:
	lr.w    t0, (a3)              # load lock location
	bne     t0, zero, acquire     # wait on lock to be open
	li      t1, 1
	sc.w    t2, t1, (a3)
	bne     t2, zero, lock        # if sc.w failed, retry (In case of SC failure, rd gets written 1 (!= 0))
	ret

# pass in an address to unlock function in argument register 0
# returns after freeing lock
unlock:
	sw      zero, 0(a3)           # exclusive writer safe to clear the lock
	ret
#----------------------------------------------------------
# Begin CRC subroutine
#----------------------------------------------------------
# $a0 = crc32($a2)
crc32:
	lui $t1, 0x04C11
	 ori $t1, $t1, 0x7B7
	 addi $t1, $t1, 0x600
	 or $t2, $0, $0
	 ori $t3, $0, 32
 
l1:
	slt $t4, $t2, $t3
	 beq $t4, $0, l2
 
	ori $t5, $0, 31
	 srl $t4, $a2, $t5
	 ori $t5, $0, 1
	 sll $a2,$a2,$t5
	 beq $t4, $0, l3
	 xor $a2, $a2, $t1
 l3:
	addi $t2, $t2, 1
	 j l1
l2:
	or $a0, $a2, $0
	 jr $1
#----------------------------------------------------------
# End CRC subroutine
#----------------------------------------------------------

#-divide(N=$a2,D=$a3) returns (Q=$a0,R=$a1)--------
divide:               # setup frame
	push  $1           # saved return address
	 or    $a0, $0, $0   # Quotient v0=0
	 or    $a1, $0, $a2  # Remainder t2=N=a0
	 beq   $0, $a3, divrtn # test zero D
	 slt   $t0, $a3, $0  # test neg D
	 bne   $t0, $0, divdneg
	 slt   $t0, $a2, $0  # test neg N
	 bne   $t0, $0, divnneg
 divloop:
	slt   $t0, $a1, $a3 # while R >= D
	 bne   $t0, $0, divrtn
	 addi $a0, $a0, 1   # Q = Q + 1
	 sub  $a1, $a1, $a3 # R = R - D
	 j     divloop
divnneg:
	sub  $a2, $0, $a2  # negate N
	 jal   divide        # call divide
	sub  $a0, $0, $a0  # negate Q
	 beq   $a1, $0, divrtn
	 addi $a0, $a0, -1  # return -Q-1
	 j     divrtn
divdneg:
	sub  $a2, $0, $a3  # negate D
	 jal   divide        # call divide
	sub  $a0, $0, $a0  # negate Q
 divrtn:
	 pop $1
	 jr  $1
#-divide--------------------------------------------

#-max (a2=a,a3=b) returns a0=max(a,b)--------------
max:
	push  $1
	 or    $a0, $0, $a2
	 slt   $t0, $a2, $a3
	 beq   $t0, $0, maxrtn
	 or    $a0, $0, $a3
 maxrtn:
	 pop   $1
	 jr    $1
 #--------------------------------------------------

#-min (a0=a,a1=b) returns v0=min(a,b)--------------
min:
	push  $1
	 or    $a0, $0, $a2
	 slt   $t0, $a3, $a2
	 beq   $t0, $0, minrtn
	 or    $a0, $0, $a3
 minrtn:
	 pop   $1
	 jr    $1
 #--------------------------------------------------

 #----------------------------------------------------------
# Shared Data Segment
#----------------------------------------------------------
org 0x0300
lock_var:
	cfw 0x0   
stack_pointer:
  cfw 0x1FFF

