ASM=nasm
LD=ld

disk.img: boot.bin
	qemu-img create disk.img 1440k
	dd status=noxfer conv=notrunc if=boot.bin of=disk.img

boot.bin: boot.asm
	$(ASM) -f bin -o boot.bin boot.asm

clean:
	rm -f *.img *.bin *.o *.out
