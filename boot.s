; boot is loaded at 0x7c00
; must fit in 512 bytes sector
; [somethings] is a (dereferenced) pointer* to something



bits 16
org 0x7c00 ; move to 0x7c00

mov si, 0

;setvideomode: ; 320x300px - mode 13h
;	mov ah, 00h
;	mov al, 13h
;	int 0x10
;	jmp waitforkeypress
	
;clearscreen:
;	; set cursor position
;	mov ah, 0x02 ; bios setcursor
;	mov bh, 1 ; page 1
;	mov dh, 5 ; row 5
;	mov dl, 5 ; column 5
;
;	; change background && foreground color
;	mov ah, 0x06 ; int 10h to scroll window
;	mov al, 0 ; clear screen
;	mov bh, 0xF0 ; set foreground color to Black, background to white
;	mov ch, 0 ; starting point X : 0
;	mov cl, 0 ; starting point Y : 0
;	mov dh, 100 ; ending point X : 100
;	mov dl, 100 ; ending point Y : 100
;	int 0x10 ; bios interrupt
;	jmp printchar ; print text after writing all
;


waitforkeypress: 
	mov ah, 0x00
	int 0x16
	mov dh, al
	cmp al, 126
	jl printthing	
	
printthing:
	mov ah, 0x0e ; prepare to print
	mov al, dh ; print dh (ascii code)
	int 0x10 ; print
	jmp waitforkeypress
		

; set video again for text mode - 03h
	mov ah, 0x00
	mov al, 0x03
	int 0x10
	jmp printchar

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


