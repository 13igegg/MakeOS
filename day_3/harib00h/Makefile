
	
ipl.bin: ipl.nas
	nasm -f bin -o ipl.bin -l ipl.lst ipl.nas
	

haribote.sys: haribote.nas
	nasm -f bin haribote.nas -o haribote.sys -l haribote.lst
	
haribote.img: ipl.bin haribote.sys
	dd if=/dev/zero of=haribote.img bs=512 count=2880
	mformat -i haribote.img -f 1440 ::
	dd if=ipl.bin of=haribote.img conv=notrunc bs=512 count=1
	mcopy -i haribote.img haribote.sys ::

run: haribote.img
	qemu-system-i386 -fda haribote.img
	
clean:
	rm -f *.bin
	rm *.lst
	rm *.img
	rm haribote.sys



