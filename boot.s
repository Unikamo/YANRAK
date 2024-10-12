; boot is loaded at 0x7c00
; must fit in 512 bytes sector
; [somethings] is a (dereferenced) pointer* to something



bits 16
org 0x7c00 ; move to 0x7c00

mov si, 0

printchar:
	mov ah, 0x0e ; print a character
	mov al, [hello + si] ; prints "Hello, World!" + si register
	int 0x10 ; Video Services interrupt (BIOS Interrupt)
	add si, 1 ; Prints the next letter
	cmp byte [hello + si], 0 ; check if the memory contains 0
	jne printchar ; if not, print the next char

jmp $ ; $ = current memory adress

hello:
	db "Hello, World!", 0 ; 0 = null termination
; $$ means "start of current section"
times 510-($-$$) db 0 ; fill 510 minus start of the line minus start of the program of zeroes
			; db means "define byte", it adds bytes
dw 0xAA55 ; every x86 boot sector must end with it (takes 2 bytes)


