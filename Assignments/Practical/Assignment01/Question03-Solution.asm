.data   
input1:     .asciiz "Please Enter N:\n"
input2:     .asciiz "Enter Numbers:\n"
output1:    .asciiz "Average is:"
output2:    .asciiz "\nVariance is: "

.text   

    # در این بخش پیام مربوط به ورودی اول چاپ میشود
    la      $a0,    input1
    li      $v0,    4
    syscall 

    # در این بخش تعداد اعداد ورودی داده میشود
    # n--> s0
    addi    $v0,    $zero,      5
    syscall 
    move    $s0,    $v0

    # Counter --> s1
    move    $s1,    $zero
    sll     $a0,    $s0,        2           # n * 4 --> a0

    # Allocate Memory
    # Memory Address --> s2
    li      $v0,    9
    syscall 
    move    $s2,    $v0

    move    $s3,    $zero                   # sigma(x) --> s3
    move    $s4,    $zero                   # sigma(x^2) --> s4


    # در این بخش متن مربوط به ورودی گرفتن نمایش داده میشود
    la      $a0,    input2
    li      $v0,    4
    syscall 


input:      

    # یک عدد ورودی گرفته میشود
    li      $v0,    5
    syscall 
    # Location = S2 + 4 * Counter
    sll     $t0,    $s1,        2
    add     $s2,    $s2,        $t0
    sw      $v0,    0($s2)                  # عدد ورودی گرفته شده را در این خانه از آرایه ذخیره میکنیم

    add     $s3,    $s3,        $v0         # عدد ورودی داده شده را به جمع اضافه میکنیم

    mult    $v0,    $v0                     # عدد ورودی داده شده را به توان دو رسانده و در جمع مربعات ذخیره میکنیم
    mflo    $t0
    add     $s4,    $s4,        $t0


    addi    $s1,    $s1,        1           # شمارنده را یکی اضافه میکنیم

    beq     $s0,    $s1,        end_input   # اگر ورودی گرفتن تمام شده برو به بخش بعدی
    j       input                           # برو به ابتدای حلقه فعلی

end_input:  
    # در این بخش متغیرهارا به فلوت تبدیل میکنیم
    mtc1    $s3,    $f3                     #f3 = (float) sigma(x)
    mtc1    $s4,    $f4                     #f4 = (float) sigma(x^2)
    mtc1    $s0,    $f0                     #f0 = (float) n

    # در این بخش میانگین را حساب میکنیم
    # Average --> f10
    div.s   $f10,   $f3,        $f0

    # در این بخش پیام مربوط به خروجی ها نمایش داده میشود
    la      $a0,    output1
    li      $v0,    4
    syscall 

    # در این بخش میانگین خروجی داده میشود
    mtc1    $zero,  $f11                    #f11 = 0
    add.s   $f12,   $f10,       $f11

    # از رجیستر f12 برای خروجی دادن اعداد فلوت استفاده میشود
    addi    $v0,    $zero,      2
    syscall 


    # در این بخش پیام مربوط به خروجی دوم نمایش داده میشود
    la      $a0,    output2
    addi    $v0,    $zero,      4
    syscall 

    # در این بخش واریانس محاسبه میشود
    mul.s   $f10,   $f10,       $f10        # Average^2 --> f10
    div.s   $f12,   $f4,        $f0         # Average 0f X^2's
    sub.s   $f12,   $f12,       $f10

    # در این بخش واریانس خروجی داده میشود.
    addi    $v0,    $zero,      2
    syscall 

    # پایان برنامه
    addi    $v0,    $zero,      10
    syscall 
