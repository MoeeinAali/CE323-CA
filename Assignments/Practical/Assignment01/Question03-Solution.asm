.text   
    # در این بخش پیغام دریافت ورودی اول نمایش داده میشود
    la      $a0,        input1
    li      $v0,        4
    syscall 

    # در این بخش عدد اول ورودی داده میشود
    li      $v0,        5
    syscall 
    move    $a1,        $v0

    # در این بخش پیغام دریافت ورودی دوم نمایش داده میشود
    la      $a0,        input2
    li      $v0,        4
    syscall 


    # در این بخش عدد دوم ورودی داده میشود
    li      $v0,        5
    syscall 
    move    $a2,        $v0

    # در این بخش پیغام نمایش خروجی داده میشود
    la      $a0,        output1
    li      $v0,        4
    syscall 

    # n--> $a1 , r-->$a2
    # در این بخش تابع فراخوانی میشود
    move    $v0,        $zero                   # رجیستر خروجی را صفر میکنیم تا مشکلی به وجود نیاید
    jal     my_func

    # در این بخش جواب خروجی داده میشود
    move    $a0,        $v0
    li      $v0,        1
    syscall 

    # در این بخش برنامه تمام میشود
    li      $v0,        10
    syscall 

my_func:    
    move    $v0,        $zero
    move    $s1,        $zero

    beq     $a1,        $a2,        return_1    #if n==r return 1
    ble     $a1,        $a2,        return_0    #if n is smaller
    beq     $a2,        $zero,      return_1    #if r is zero

    addi    $a1,        $a1,        -1          # n = n-1

    addi    $sp,        $sp,        -16
    sw      $ra,        12($sp)
    sw      $a1,        8($sp)
    sw      $s1,        4($sp)
    sw      $a2,        0($sp)
    jal     my_func                             # $v0 = C(n-1, r)
    lw      $a2,        0($sp)
    lw      $s1,        4($sp)
    lw      $a1,        8($sp)
    lw      $ra,        12($sp)
    addi    $sp,        $sp,        16

    add     $s1,        $s1,        $v0

    addi    $a2,        $a2,        -1          # r = r-1


    addi    $sp,        $sp,        -16
    sw      $ra,        12($sp)
    sw      $a1,        8($sp)
    sw      $a2,        4($sp)
    sw      $s1,        0($sp)
    jal     my_func                             # $v0 = C(n-1, r-1)
    lw      $s1,        0($sp)
    lw      $a2,        4($sp)
    lw      $a1,        8($sp)
    lw      $ra,        12($sp)
    addi    $sp,        $sp,        16


    add     $v0,        $v0,        $s1
    jr      $ra

return_1:   
    li      $v0,        1
    jr      $ra
return_0:   
    move    $v0,        $zero
    jr      $ra

.data   
input1:     .asciiz "Please Enter n:\n"
input2:     .asciiz "Please Enter r:\n"
output1:    .asciiz "C(n,r)="

