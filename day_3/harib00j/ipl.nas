CYLS    EQU 10
ORG 0x7c00         ; 设置代码起始地址为0x7C00
JMP entry         ; 跳转到entry标签
NOP               ; 无操作（占位符）
DB "HELLOIPL"     ; OEM名称标识符（8字节）
DW 512            ; 每个扇区的字节数（512字节）
DB 1              ; 每簇的扇区数（1扇区/簇）
DW 1              ; 保留扇区数（1个保留扇区）
DB 2              ; FAT表数量（2个FAT表）
DW 224            ; 根目录的最大条目数（224条）
DW 2880           ; 总扇区数（小于32MB时，总扇区数为2880）
DB 0xf0           ; 媒体描述符（0xF0表示1.44MB的软盘）
DW 9              ; 每个FAT表的扇区数（9扇区）
DW 18             ; 每个磁道的扇区数（18扇区）
DW 2              ; 磁头数（2个磁头）
DD 0              ; 隐藏扇区数（0）
DD 2880           ; 总扇区数（大于32MB时，总扇区数为2880）
DB 0, 0, 0x29     ; 逻辑驱动器号、保留字节、扩展引导签名（0x29）
DD 0xffffffff     ; 卷序列号
DB "HELLO-OS   "  ; 卷标（11字节）
DB "FAT12   "     ; 文件系统类型（8字节）
RESB 18           ; 填充到62字节

entry:
	XOR AX, AX       ; AX寄存器清零
	MOV SS, AX       ; 将堆栈段寄存器设置为0
	MOV SP, 0x7c00   ; 将堆栈指针设置为0x7C00
	MOV DS, AX       ; 将数据段寄存器设置为0


	;读磁盘
	MOV AX, 0x0820
	MOV ES, AX
	MOV CH, 0	;柱面0
	MOV DH, 0 	;磁头0
	MOV CL, 2	;扇区2
    
 readloop:
    MOV SI, 0   ;记录失败次数的寄存器
    
    
retry:
    MOV AH, 0x02 ; 当ah=0x02就是读盘
    MOV AL, 1      ;1个扇区
    MOV BX, 0
    MOV DL, 0x00    ;A驱动器
    INT 0x13        ;调用BIOS
    JNC next         ;没出错跳到fin
    ADD SI, 1
    CMP SI, 5
    JAE error       ;SI >= 5,调整error
    MOV AH, 0x00
    MOV DL, 0x00    ;A驱动器
    INT 0x13        ;重置驱动器
    JMP retry

next:
    MOV AX, ES          ;内存地址后移0x200
    ADD AX, 0x0020
    MOV ES, AX          ;没有ADD ES, 0x20
    ADD CL, 1           ;扇区+1
    CMP CL, 18
    JBE readloop        ;当前扇区 <=18 跳转
    MOV CL, 1
    ADD DH, 1
    CMP DH, 2
    JB readloop
    MOV DH, 0
    ADD CH, 1
    CMP CH, CYLS
    JB readloop
    
;读完后运行haribote.sys
    MOV [0x0ff0], CH
    JMP 0xc200
    
fin:
    HLT
	JMP fin         ; 无限循环，保持CPU停止状态
    
    
error:
    MOV    SI,msg
    
putloop:
    MOV AL, [SI]            ; 从SI指向的地址加载字节到AL，并将SI增加1
    ADD SI, 1
    CMP AL, 0        ; 比较AL和0
    JE fin           ; 如果AL为0，跳转到fin标签，结束循环
    MOV AH, 0x0e     ; 设置BIOS视频中断功能号（显示字符）
    MOV BX, 15       ; 设置字符颜色（白色）
    INT 0x10         ; 调用BIOS中断显示字符
    JMP putloop      ; 跳转回putloop标签，继续循环

msg:
	DB 0x0a, 0x0a    ; 定义两个换行符（ASCII码0x0A）
	DB "load error" ; 定义字符串
	DB 0x0a          ; 定义一个换行符（ASCII码0x0A）
	DB 0             ; 定义字符串结束符（ASCII码0x00）

    RESB 0x1FE-($-$$)  ; 填充到510字节，使整个引导扇区达到510字节
    DB 0x55             ; 引导签名（低字节）
    DB 0xaa             ; 引导签名（高字节）
