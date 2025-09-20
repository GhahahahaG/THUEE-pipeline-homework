


sparse_matmul:
    li $t0, 0
    lw $s0, 0($t0)  # $s0: m
    lw $s1, 4($t0)  # $s1: n
    lw $s2, 8($t0)  # $s2: p
    lw $s3, 12($t0) # $s3: s
    
    addi $s4, $t0, 16 # $s4: values
    
    sll $s5, $s3, 2 
    add $s5, $s5, $s4 # $s5: col_indices
    
    sll $s6, $s3, 3
    add $s6, $s6, $s4 # $s6: row_ptr
    
    addi $s7, $s0, 1
    sll $s7, $s7, 2
    add $s7, $s7, $s6 # $s7: B
    
    # TODO
    move $t0,$zero
    mul $t1,$s0,$s2 #  m*p
    addi $t2,$s7,400
    #la $t2,C
initializeC:
sw $zero,0($t2)
addi $t2,$t2,4
addi $t0,$t0,1
bne $t0,$t1,initializeC
# 完成对C的初始化

move $t0,$zero # i
move $t1,$zero # j
move $t2,$zero # l


for_i:
lw $t3,0($s6) # start
lw $t4,4($s6) # end
move $t1,$t3 # j=start

for_j:
move $t5,$s5 #  col_indices
move $t6,$s4 #values
mul $t7,$t1,4 #4j 4j 4j
add $t5,$t5,$t7
add $t6,$t6,$t7
lw $t5,0($t5)# t5 for  kkkk
lw $t6,0($t6) # t6 for val val val
move $t2,$zero # l 重置L为0
for_l:
addi $t7,$s7,400
#la $t7,C
mul $t8,$t0,$s2 # ip
add $t8,$t8,$t2 # ip+L
mul $t8,$t8,4 #4ip+4
add $t7,$t8,$t7 
lw $t9,0($t7)  #t9 for c_val c_val


mul $t8,$t5,$s2 #kp
add $t8,$t8,$t2 # kp+L
mul $t8,$t8,4 #4kp+4
add $t8,$t8,$s7  
lw $t8,0($t8) # t8 for B[kp+1]
mul $t8,$t8,$t6 # now t8 for val*B[kp+1]
add $t9,$t9,$t8 # new c_val
sw $t9,0($t7)
#完成循环内的操作 完成循环内的操作 完成循环内的操作 

addi $t2,$t2,1
blt $t2,$s2,for_l
addi $t1,$t1,1
blt $t1,$t4,for_j
addi $t0,$t0,1
addi $s6,$s6,4 # s6+4, row_ptr[i->i+1]
blt $t0,$s0,for_i



    # 显示结果矩阵C
    addi $t7, $s7, 400 # C矩阵地址
    addi $t8, $zero, 0 # 计数器
    mul $t9, $s0, $s2 # 元素个数 (m*p)
     lui $t2,0x4000
      addiu $t2,$t2,0x0010
     
      
      
      
    display_loop:
    beq $t8, $t9, end_program
    lw $t6, 0($t7)    # 读取当前元素
     addi $t5, $zero, 2000 # 设置循环计数器为250 (250*4ms=1000ms)
    jal displaylow16bit
    addi $t7,$t7,4
    addi $t8,$t8,1
    j display_loop
    
    
displaylow16bit:

 #andi $t4, $t6, 0xFFFF     # 取参数的低16位存入s0
    #addiu $t5, $zero, 250     # 设置循环计数器为250 (250*4ms=1000ms)
   # addi $t5, $zero, 2
    
    srl $t4, $t6, 12          # 右移12位获取最高4位
    andi $t4, $t4, 0xF        # 屏蔽高位，保留最低4位
    addi $t3, $zero, 16       # 设置数码管位置为0（最左边）
    
    
    addi $t0,$t4,36
    sll $t0,$t0,2  
    lw $t1,0($t0) # t1 for a-g
    sll $s1,$t3,7
    add $s2,$s1,$t1
    sw $s2,0($t2)
         # 返回调用者
    addiu $s3, $zero, 0x0940    # 设置计数器低16位 (0x0D40 = 12500)
delay_1ms_loop1:
    addiu $s3, $s3, -1        # 计数器减1
    bne $s3, $zero, delay_1ms_loop1 




   srl $t4, $t6, 8          # 右移12位获取最高4位
    andi $t4, $t4, 0xF        # 屏蔽高位，保留最低4位
    addi $t3, $zero, 8       # 设置数码管位置为0（最左边）
    
    
    addi $t0,$t4,36
    sll $t0,$t0,2  
    lw $t1,0($t0) # t1 for a-g
    sll $s1,$t3,7
    add $s2,$s1,$t1
    sw $s2,0($t2)
         # 返回调用者
    addiu $s3, $zero, 0x0940    # 设置计数器低16位 (0x0D40 = 12500)
delay_1ms_loop2:
    addiu $s3, $s3, -1        # 计数器减1
    bne $s3, $zero, delay_1ms_loop2



   srl $t4, $t6, 4          # 右移12位获取最高4位
    andi $t4, $t4, 0xF        # 屏蔽高位，保留最低4位
    addi $t3, $zero, 4       # 设置数码管位置为0（最左边）
    
    
    addi $t0,$t4,36
    sll $t0,$t0,2  
    lw $t1,0($t0) # t1 for a-g
    sll $s1,$t3,7
    add $s2,$s1,$t1
    sw $s2,0($t2)
         # 返回调用者
    addiu $s3, $zero, 0x0940    # 设置计数器低16位 (0x0D40 = 12500)
delay_1ms_loop3:
    addiu $s3, $s3, -1        # 计数器减1
    bne $s3, $zero, delay_1ms_loop3 


       
    andi $t4, $t6, 0xF        # 屏蔽高位，保留最低4位
    addi $t3, $zero, 2      # 设置数码管位置为0（最左边）
    
    
    addi $t0,$t4,36
    sll $t0,$t0,2  
    lw $t1,0($t0) # t1 for a-g
    sll $s1,$t3,7
    add $s2,$s1,$t1
    sw $s2,0($t2)
         # 返回调用者
    addiu $s3, $zero, 0x0940    # 设置计数器低16位 (0x0D40 = 12500)
delay_1ms_loop4:
    addiu $s3, $s3, -1        # 计数器减1
    bne $s3, $zero, delay_1ms_loop4
    
    
    addi $t5,$t5,-1
    beq $t5,$zero,jrra
    j displaylow16bit
    jrra:
    jr $ra
end_program:


