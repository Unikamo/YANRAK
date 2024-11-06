; boot is loaded at 0x7c00
; must fit in 512 bytes sector
; [somethings] is a (dereferenced) pointer* to something



bits 16
org 0x7c00 ; move to 0x7c00

mov si, 0

setvideomode: ; 320x300px - mode 13h
	mov ah, 00h
	mov al, 13h
	int 0x10
	jmp writepixel
	
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

writepixel:
	mov cx, 160
	mov dx, 100
	mov al, 15

pixelloop:
	mov ah, 0x0C
	int 0x10
	add cx, 1            ; Increment X position
	cmp cx, 320          ; Check if X exceeds screen width (320px)
	jl continue_drawing  ; If not, continue drawing on the same line
	mov cx, 0            ; Reset X to 0
	add dx, 1            ; Move down to the next line (Y position)
	cmp dx, 200          ; Check if Y exceeds screen height (200px)
	jge waitforkeypress   ; If Y >= 200, stop drawing and wait for keypress

continue_drawing:
	add al, 1
	cmp al, 255
	jle pixelloop

waitforkeypress: 
	mov ah, 0x00
	int 0x16

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


