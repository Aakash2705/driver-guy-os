[bits 16]
[org 0x7c00]

; where to load the kernel to
KERNEL_OFFSET equ 0x1000

; BIOS loads the boot drive in 'dl': store for later use
mov [BOOT_DRIVE], dl

; setup stack
mov bp, 0x9000
mov sp, bp

call load_kernel
call switch_to_32bit

jmp $

%include "bootloader/disk.asm"
%include "bootloader/gdt.asm"
%include "bootloader/switch-to-32bit.asm"

[bits 16]
load_kernel:
	mov bx, KERNEL_OFFSET 	; bx -> dest
	mov dh, 2		; dh -> num sectors
	mov dl, [BOOT_DRIVE]	; dl -> disk
	call disk_load
	ret

[bits 32]
BEGIN_32BIT:
	call KERNEL_OFFSET
	jmp $

; boot drive var
BOOT_DRIVE:	db 0

; padding
times 510 - ($ - $$) db 0
dw 0xaa55
