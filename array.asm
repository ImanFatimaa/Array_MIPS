.text
#getting which form of input is to be given  by user
    li $gp,0X10010000              #setting value of gp
    li $s0,1                       #1 for integer and 0 for alphabet
    li $v0,4
    la $a0,i
    syscall
    li $v0,5
    syscall
    move $s1,$v0
    
    beq $s1,$zero,character
    beq $s1,$s0,integer
integer:
#initializing array  
    li $v0,4
    la $a0,a
    syscall
    li $v0,5
    syscall
    move $t1,$v0                   #t1 contains lenght of array
    li $t0,0                       #t0= counter for array
intialize:
    beq $t1,$t0,operation
    li $v0,4
    la $a0,b_
    syscall
    li $v0,5
    syscall 
    move $t3,$v0
    sw $t3,128($gp)             #saving the array in memory
    addi $gp,$gp,4
    addi $t0,$t0,1
    b intialize
operation:    
#now asking user what function to be performed on string 
    li $t0,1
    li $t1,2
    li $t2,3

    li $v0,4
    la $a0,f
    syscall
    li $v0,5
    syscall
    move $s1,$v0
    
    beq $s1,$t0,print
    beq $s1,$t1,average
    beq $s1,$t2,maximum
    b exit        
   
print:
    li $t0,0                   #setting counter to 0
print_array:   
    beq $t0,$t1,exit 
    lw $t3,128($gp)            #getting array from memory  
    addi $gp,$gp,4
    addi $t0,$t0,1
    li $v0,1
    move $a0,$t3 
    syscall                   #printing array
    b print_array
average:
    li $t0,0                  #calculating average
    lw $a0,128($gp)
x:
    beq $t0,$t1,y    
    lw $a1,132($gp)
    addi $gp,$gp,4
    addi $t0,$t0,1
    jal procedure_call        #calling procedure to add array
    move $s0,$a0
    div $s0,$s0,$t1           #getting average
    b print_average
procedure_call:
    add $a0,$a0,$a1
    b x
y: 
    jr $ra       
print_average:
    li $v0,1
    move $a0,$s0
    syscall                       #printing average 
    b exit 

maximum:
    li $t0,0
    li $gp,0X10010000
    lw $s0,128($gp)
wapis: 
    beq $t0,$t1,chal   
    lw $s1,132($gp)
    addi $gp,$gp,4
    addi $t0,$t0,1
    slt $t4,$s0,$s1
    beq $t4,$zero,go
    move $s0,$s1
    b wapis
go:    
    b wapis
chal:
    li $v0,1
    move $a0,$s0
    syscall 
    b exit 
character:
    li $t0,1
    li $t1,2
    li $t2,3
    
#taking input from user   
    li $v0,4                      #lenght of string
    la $a0,a
    syscall
    li $v0,5
    syscall
    move $t9,$v0
     
    li $v0,4                 #taking string as input
    la $a0,b_
    syscall
    li $v0,8
    la $a0,space
    li $a1,50
    syscall
    
#asking user what funvtion t be performed
    li $v0,4
    la $a0,f
    syscall
    li $v0,5
    syscall
    move $s1,$v0
    
    beq $s1,$t0,palindrome
    beq $s1,$t1,compare
    beq $s1,$t2,display
    b exit
palindrome:    
    add $s0,$zero,$gp
    addi $s0,$s0,-1                      #last location of string
    li $t0,0
    li $s2,2
    div $t1,$s2
    mflo $t1
check:     
    beq $t0,$t1,next1
    lb $t3,28($gp)
    lb $t4,0($s0)
    addi $t0,$t0,1
    addi $gp,$gp,1
    addi $s0,$s0,-1
    
    beq $t3,$t4,check
    b message
message:
    li $v0,4
    la $a0,d
    syscall   
    b exit
next1:
    li $v0,4
    la $a0,c
    syscall    
    b exit
    
compare:
    li $v0,4
    la $a0,b_
    syscall
    li $v0,8
    la $a0,space2
    li $a1,50
    syscall
    
     li $t0,0
check1:    
    beq $t0,$t9,msg
    lb $t1,53($gp)
    lb $t2,133($gp)
    addi $gp,$gp,1
    addi $gp,$gp,1
    addi $t0,$t0,1
    
    beq $t1,$t2,check1
    b not_equal
msg:
    li $s0,1
    b aagy
not_equal:
    li $s0,0
    b aagy
aagy:    
    li $v0,1
    move $a0,$s0
    syscall    
    b exit
display:  
    b exit  
exit:    
    
    
.data
i: .asciiz "Input Type: "
f: .asciiz "Function: "
a: .asciiz "Enter length: "
b_: .asciiz "Enter Input: "
space: .space 50
c: .asciiz "Palindrome: "
d: .asciiz "not palindrome: "
space2: .space 50
