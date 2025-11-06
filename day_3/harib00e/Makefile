
	
ipl.bin: ipl.nas
	nasm -f bin -o ipl.bin -l ipl.lst ipl.nas
	

haribote.sys: haribote.nas
	nasm -f bin haribote.nas -o haribote.sys -l haribote.lst
	
haribote.img: ipl.bin haribote.sys
	dd if=/dev/zero of=haribote.img bs=512 count=2880
	dd if=ipl.bin of=haribote.img conv=notrunc bs=512 count=1
	dd if=haribote.sys of=haribote.img bs=512 seek=1 conv=notrunc

run: haribote.img
	qemu-system-i386 -fda haribote.img
	
clean:
	rm ipl.bin
	rm helloos.img
	rm ipl.lst
	rm haribote.img
	rm haribote.sys
	rm haribote.lst


