void io_hlt(void);

void HarMain(void){
	fin:
        io_hlt();
        goto fin;
}
