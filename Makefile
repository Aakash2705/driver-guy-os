# $@ = target file
# $< = first dependency
# $^ = all dependencies
BUILD_DIR=build
ASM=nasm
LINK=i686-elf-ld
CC=i686-elf-gcc

# First rule is the one executed when no parameters are fed to the Makefile
all: run

$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/kernel-entry.o $(BUILD_DIR)/kernel.o
	$(LINK) -o $(BUILD_DIR)/kernel.bin -Ttext 0x1000 $(BUILD_DIR)/kernel-entry.o $(BUILD_DIR)/kernel.o --oformat binary

$(BUILD_DIR)/kernel-entry.o: bootloader/kernel-entry.asm
	$(ASM) bootloader/kernel-entry.asm -f elf -o $(BUILD_DIR)/kernel-entry.o

$(BUILD_DIR)/kernel.o: kernel/kernel.c
	$(CC) -m32 -ffreestanding -c kernel/kernel.c -o $(BUILD_DIR)/kernel.o

$(BUILD_DIR)/mbr.bin: bootloader/mbr.asm
	$(ASM) bootloader/mbr.asm -f bin -o $(BUILD_DIR)/mbr.bin

$(BUILD_DIR)/os-image.bin: $(BUILD_DIR)/mbr.bin $(BUILD_DIR)/kernel.bin
	cat $(BUILD_DIR)/mbr.bin $(BUILD_DIR)/kernel.bin > $(BUILD_DIR)/os-image.bin

run: $(BUILD_DIR)/os-image.bin
	qemu-system-i386 -fda $(BUILD_DIR)/os-image.bin

clean:
	$(RM) $(BUILD_DIR)/*.bin $(BUILD_DIR)/*.o $(BUILD_DIR)/*.dis
