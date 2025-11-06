	
#install: ipl.nas
#	nasm -f bin -o ipl.bin -l ipl.lst ipl.nas
#	dd if=/dev/zero of=helloos.img bs=512 count=2880
#	dd if=ipl.bin of=helloos.img conv=notrunc bs=512 count=1
	
helloos.img: ipl.nas
	nasm -f bin -o ipl.bin -l ipl.lst ipl.nas
	dd if=/dev/zero of=helloos.img bs=512 count=2880
	dd if=ipl.bin of=helloos.img conv=notrunc bs=512 count=1

run: helloos.img
	qemu-system-i386 -fda helloos.img
	
clean:
	rm ipl.bin
	rm helloos.img
	rm ipl.lst


