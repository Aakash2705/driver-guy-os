disk_load:
	pusha
	push dx

	mov ah, 0x02		; read mode
	mov al, dh 		; read dh number of sectors
	mov cl, 0x02 		; start from sector 2 (sec 1 is our boour sector)
	mov ch, 0x00		; cylinder 0
	mov dh, 0x00		; head 0

	int 0x13		; now actually read the disk
	jc disk_error		; jump if error occurs

	pop dx
	cmp al, dh

	jne sectors_error
	popa
	ret

disk_error:
	jmp disk_loop

sectors_error:
	jmp disk_loop

disk_loop:
	jmp $
