ORG 0xc200 ;这个程序被加载到内存的0xc200
    MOV AL, 0x13 ;设置vga显卡模式
    MOV AH, 0x00
    INT 0x10
fin:
	HLT
	JMP fin
