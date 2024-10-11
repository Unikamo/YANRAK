; boot is loaded at 0x7c00
; must fit in 512 bytes sector

bits 16
org 0x7c00 ; move to 0x7c00

mov si, 0

printchar:
	mov ah, 0x0e ; print a character
	mov al, [hello + si] ; prints "Hello, World!" + si register
	int 0x10 ; Video Services interrupt
	add si, 1
	cmp byte [hello + si], 0 ; check if the memory contains 0
	jne printchar ; if not, print the next char

jmp $

hello:
	db "Hello, World!", 0

times 510 - ($ - $$) db 0 ; fill 510 minus start of the line minus start of the program of zeroes
dw 0xAA55 ; every x86 boot sector must end with it (takes 2 bytes)


