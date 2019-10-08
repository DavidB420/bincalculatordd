;Binary Calculator for DavidDOS by David Badiei
org 4000h

start:

mov si,intro
call print_string

mov ah,00
int 16h

cmp al,'1'
je inttobin

cmp al,'2'
je bintoint

doneprog:
mov si,ques4
call print_string
mov ah,00
int 16h
cmp al,'1'
je start
ret

intro db 'Welcome to Binary Calculator! Copyright (C) 2019 David Badiei', 0x0D, 0x0A, 'Licensed under BSD License 2.0', 0x0D,0x0A,'Please choose an option:', 0x0D, 0x0A, '1.Convert integer to binary', 0x0D, 0x0A, '2. Convert binary to integer', 0x0D, 0x0A, 0
ques1 db 'Enter integer number: ',0
ques2 db 'Enter binary number: ',0
ques4 db 0x0D, 0x0A, 'Do you want to use this program again? 1.yes 2.no', 0x0D, 0x0A, 0
intNum times 5 db 0
num1 dw 0
multiplier dw 0
tmp dw 0
answerBin times 17 db 0
answerStr db 'Answer: ',0
answerInt times 5 db 0


print_string:
mov ah,0eh
loopstr:
lodsb
int 10h
test al,al
jz donestr
jmp loopstr
donestr:
ret

getinput:
	mov ah,0
	int 16h
	cmp al,08h
	je delchar
	cmp al,0dh
	je entpress
	cmp al,3fh
	je getinput
	mov ah,0eh
	int 10h
	stosb
	inc cx
	jmp getinput
	delchar:
		cmp cx,0
		je getinput
		mov ah,0eh
		mov al,08h
		int 10h
		mov al,20h
		int 10h
		mov al,08h
		int 10h
		sub cx,1
		dec di
	    mov byte [di], 0
		jmp getinput
	entpress:
	   mov al,0
	   stosb
	   mov ah,0eh
	   mov al,0dh
	   int 10h
	   mov al,0ah
	   int 10h
	   ret

stringtoint:
pusha
mov ax,si
call getStringlength
add si,ax
dec si
mov cx,ax
xor bx,bx
xor ax,ax
mov word [multiplier],1
loopconvert:
mov ax,0
mov byte al,[si]
sub al,30h
mul word [multiplier]
add bx,ax
push ax
mov word ax,[multiplier]
mov dx,10
mul dx
mov word [multiplier],ax
pop ax
dec cx
cmp cx,0
je finish
dec si
jmp loopconvert
finish:
mov word [tmp],bx
popa
mov word ax,[tmp]
ret

getStringlength:
	pusha
	mov bx,ax
	mov cx,0
more:
	cmp byte [bx],0
	je donelength
	inc bx
	inc cx
	jmp more
donelength:
	mov word [tmp],cx
	popa
	mov ax,[tmp]
	ret

inttobin:
mov si,ques1
call print_string
mov cx,0
mov di,intNum
call getinput
mov si,intNum
mov di,num1
call stringtoint
mov word [num1],ax
mov cx,0
mov dx,0
mov ax, word [num1]
loopdiv:
mov bx,2
xor dx,dx
div bx
cmp dx,0
jne odd
cmp dx,0
je even
continueloopdiv:
inc cx
cmp ax,0
je doneloop1
jmp loopdiv
doneloop1:
mov si,answerStr
call print_string
mov si,answerBin
call revStr
mov si,answerBin
call print_string
jmp doneprog
even:
mov si,answerBin
add si,cx
mov byte [si],'0'
mov dx,0
jmp continueloopdiv
odd:
mov si,answerBin
add si,cx
mov byte [si],'1'
mov dx,0
jmp continueloopdiv

revStr:
pusha
cmp byte [si],0
je doneRev
mov ax,si
call getStringlength
mov di,si
add di,ax
dec di
looprev:
mov byte al,[si]
mov byte bl,[di]
mov byte [si],bl
mov byte [di],al
inc si
dec di
cmp di,si
ja looprev
doneRev:
popa
ret

inttostr:
pusha
mov cx,0
mov bx,10
pushit:
xor dx,dx
div bx
inc cx
push dx
test ax,ax
jnz pushit
popit:
pop dx
add dl,30h
pusha
mov al,dl
mov ah,0eh
int 10h
popa
inc di
dec cx
jnz popit
popa
ret

bintoint:
mov si,ques2
call print_string
mov cx,0
mov di,answerBin
call getinput
mov si,answerBin
mov ax,si
call getStringlength
mov cx,ax
dec cx
mov si,answerBin
add si,cx
mov ax,0
mov bx,1
binloop:
cmp byte [si],'1'
je addup
continueloop:
add bx,bx
dec si
dec cx
cmp cx,0
jge binloop
mov word [num1],ax
pusha
mov si,answerStr
call print_string
popa
call inttostr
jmp doneprog
addup:
add ax,bx
jmp continueloop