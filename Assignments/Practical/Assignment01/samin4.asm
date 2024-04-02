.text   
    la      $a0,    input1_str                          #load the address of string
    addi    $v0,    $zero,          4                   #code for printing string
    syscall                                             #print the first string

    addi    $v0,    $zero,          5                   #code for reading integer
    syscall                                             #read n
    add     $s0,    $zero,          $v0                 #s0 is n

    add     $s1,    $zero,          $zero               #s1 is the counter

    sll     $a0,    $s0,            2                   #a0 contains the number of bytes to allocate (n*4)
    addi    $v0,    $zero,          9                   #code for allocating memory
    syscall                                             #allocate memory for n words
    add     $s2,    $zero,          $v0                 #s2 contains the memory address

    add     $s3,    $zero,          $zero               #s3 contains the sum of all inputs
    add     $s4,    $zero,          $zero               #s4 contains the sum of squares of inputs

loop:                                                   #loop for reading inputs
    la      $a0,    input2_str                          #load the address of string
    addi    $v0,    $zero,          4                   #code for printing string
    syscall                                             #print the first string

    addi    $a0,    $s1,            1                   #index of inputs to print; counter+1
    addi    $v0,    $zero,          1                   #code for printing integer
    syscall                                             #print the index

    la      $a0,    input3_str                          #load the address of string
    addi    $v0,    $zero,          4                   #code for printing string
    syscall                                             #print the first string

    addi    $v0,    $zero,          5                   #code for reading integer
    syscall                                             #v0 contains the input number
    sll     $t0,    $s1,            2                   #t0 = counter * 4
    add     $s2,    $s2,            $t0                 #address of memory we want to store the input to = s2 + 4 * counter
    sw      $v0,    0($s2)                              #store in memory

    add     $s3,    $s3,            $v0                 #sum += input

    mult    $v0,    $v0                                 #input^2
    mflo    $t0                                         #stor the low bytes of multiplication result to t0
    add     $s4,    $s4,            $t0                 #sum_of_squares += input^2

    addi    $s1,    $s1,            1                   #increasing counter

    beq     $s1,    $s0,            after_loop          #end loop when the counter is n
    ble     $s1,    $s0,            loop                #continue if the counter is less than n

after_loop:                                             #now we calculate and print the output
    mtc1    $s4,    $f4                                 #f4 = (float) sum_of_squares
    mtc1    $s0,    $f0                                 #f0 = (float) n

    mtc1    $s3,    $f3                                 #f3 = (float) sum
    div.s   $f3,    $f3,            $f0                 #calculate ave

    la      $a0,    output1_str                         #load address of ave string
    addi    $v0,    $zero,          4                   #code for printing string
    syscall                                             #print ave message

    mtc1    $zero,  $f10                                #f10 = 0
    add.s   $f12,   $f10,           $f3                 #a0 = average
    addi    $v0,    $zero,          2                   #code for printing integer
    syscall                                             #print the average

    mul.s   $f1,    $f3,            $f3                 #f1 = ave^2

    la      $a0,    output2_str                         #load address of string to print
    addi    $v0,    $zero,          4                   #code for printing string
    syscall                                             #print var message

    div.s   $f12,   $f4,            $f0                 #f12 = sum_of_square/n
    sub.s   $f12,   $f12,           $f1                 #f12 -= ave^2
    addi    $v0,    $zero,          2                   #code for printing float
    syscall                                             #print the variance

    addi    $v0,    $zero,          10                  #code for terminating the program
    syscall                                             #end of program

.data   
input1_str:     .asciiz "Enter the number of inputs: "
input2_str:     .asciiz "Enter input ["
input3_str:     .asciiz "]: "
output1_str:    .asciiz "The average of inputs is: "
output2_str:    .asciiz "\nThe variance of inputs is: "
