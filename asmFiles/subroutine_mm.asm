#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
# a2 = a
# a3 = b
# a0 = result

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

