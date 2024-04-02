.data   
input_prompt:   .asciiz "Enter an integer:\n"
output_prompt:  .asciiz "Your Number is:\n"

.text   
                .globl  main

main:           
    # در این بخش متن مربوط به ورودی گرفتن عدد چاپ می شود.
    li      $v0,    4
    la      $a0,    input_prompt
    syscall 
    # در این بخش عدد توسط کاربر ورودی داده می شود.
    li      $v0,    5
    syscall 
    move    $t0,    $v0                         # input_number --> t0

    # در این بخش متن مروبط به خروجی دادن عدد چاپ میشود.
    li      $v0,    4
    la      $a0,    output_prompt
    syscall 

    sll     $t0,    $t0,            15          # ابتدا عدد را 15 واحد شیفت به چپ میدهیم
    srl     $t0,    $t0,            28          # سپس عدد را 28 واحد شیفت به راست میدهیم

    # در این بخش عدد را خروجی میدهیم
    li      $v0,    1
    move    $a0,    $t0
    syscall 

    # در این بخش برنامه پایان میباید
    li      $v0,    10
    syscall 