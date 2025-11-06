
[BITS 32] ;制作32位模式用的机械语言
;制作目标文件的信息
;[FILE "naskfunc.nas"] 	;源文件名信息
	GLOBAL io_hlt	;程序中包含的函数名

;实际函数
[SECTION .text]
io_hlt:
	HLT
	RET
