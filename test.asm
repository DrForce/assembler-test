.model small
.stack 128
.data

frac struc
num db 0
den db 0
frac ends

enterNum db 'Enter numerator $'
enterDen db 'Enter denominator $'
uWrong db 'Wrong symbol$'
enterOp db 'Enter operation symbol(+, -, *, /): $'
chis db ' drobi(-128 - 127): $'
znam db ' drobi(-128 - 127): $'
temp db 5, ?, 5 dup(?)
fr1 frac <0, 0>
fr2 frac <0, 0>
newL db 0ah,0dh,24h
operation db 0

.code 
start:
	mov ax, @data
	mov ds, ax
	
	;Ввод числителя первой дроби
    lea dx, enterNum
	call print
	mov ah, 2
	mov dl, 31h
	xor dh,dh
	int 21h
	lea dx, chis
	call print
	mov ah, 0ah 
    lea dx, temp
    int 21h 
	xor bx,bx
	xor cx,cx
	mov di,0
	mov cl, temp[1]
	mov al, temp[2]
	cmp al,2dh
	jne inp1next
	mov di,1
	mov si,3
	sub cl,1
	jmp chis1
	inp1next:
	mov si,2
	chis1:
		mov al,0ah
		mul bl
		mov bl, al
		mov al, temp[si]
		sub al,30h
		add bl,al
		add si,1
		loop chis1
	cmp di,1
	jne ok1
		neg bl
	ok1:
	mov fr1.num, bl
	
	lea dx, newL
	call print
	
	;Ввод знаменателя первой дроби
	lea dx, enterDen
	call print
	mov ah, 2
	mov dl, 31h
	xor dh,dh
	int 21h
	lea dx, chis
	call print
	mov ah, 0ah 
    lea dx, temp
    int 21h 
	xor bx,bx
	xor cx,cx
	mov di,0
	mov cl, temp[1]
	mov al, temp[2]
	cmp al,2dh
	jne inp2next
	mov di,1
	mov si,3
	sub cl,1
	jmp znam1
	inp2next:
	mov si,2
	znam1:
		mov al,0ah
		mul bl
		mov bl, al
		mov al, temp[si]
		sub al,30h
		add bl,al
		add si,1
		loop znam1
	cmp di,1
	jne ok2
		neg bl
	ok2:
	mov fr1.den, bl
	
	lea dx, newL
	call print
	
	;Ввод символа операции
	lea dx, enterOp
	call print
	
	mov ah,01h
	int 21h
	mov operation, al
	
	lea dx, newL
	call print
	
	;Ввод числителя второй дроби
    lea dx, enterNum
	call print
	mov ah, 2
	mov dl, 32h
	xor dh,dh
	int 21h
	lea dx, chis
	call print
	mov ah, 0ah 
    lea dx, temp
    int 21h 
	xor bx,bx
	xor cx,cx
	mov di,0
	mov cl, temp[1]
	mov al, temp[2]
	cmp al,2dh
	jne inp3next
	mov di,1
	mov si,3
	sub cl,1
	jmp chis2
	inp3next:
	mov si,2
	chis2:
		mov al,0ah
		mul bl
		mov bl, al
		mov al, temp[si]
		sub al,30h
		add bl,al
		add si,1
		loop chis2
	cmp di,1
	jne ok3
		neg bl
	ok3:
	mov fr2.num, bl
	
	lea dx, newL
	call print
	
	;Ввод знаменателя второй дроби
	lea dx, enterDen
	call print
	mov ah, 2
	mov dl, 32h
	xor dh,dh
	int 21h
	lea dx, chis
	call print
	mov ah, 0ah 
    lea dx, temp
    int 21h 
	xor bx,bx
	xor cx,cx
	mov di,0
	mov cl, temp[1]
	mov al, temp[2]
	cmp al,2dh
	jne inp4next
	mov di,1
	mov si,3
	sub cl,1
	jmp znam2
	inp4next:
	mov si,2
	znam2:
		mov al,0ah
		mul bl
		mov bl, al
		mov al, temp[si]
		sub al,30h
		add bl,al
		add si,1
		loop znam2
	cmp di,1
	jne ok4
		neg bl
	ok4:
	mov fr2.den, bl
	
	lea dx, newL
	call print
	
	mov al, operation
	cmp al,2bh
	jne nextop1
	call summ
	jmp endprog
	nextop1:
		cmp al,2dh
		jne nextop2
		call razn
		jmp endprog
	nextop2:
		cmp al,2ah
		jne nextop3
		call proizved
		jmp endprog
	nextop3:
		cmp al,2fh
		jne wrongOp
		call chastnoe
		jmp endprog
	wrongOp:
		lea dx, uWrong
		call print
	
	endprog:
	mov ax, 4c00h
	int 21h
	
	print proc 
        mov ah, 9 
        int 21h 
        ret     
    print endp 
	
	;Вывести дробь в формате <числитель>/<знаменатель>. числитель - ax, знаменатель - dx	
	printDrob proc
		xor bx,bx
		xor si,si
		push dx
		xor dx,dx
		cmp ax, 32767d
		jbe chisbgo
			neg ax
			push ax
			push dx
			mov ah,02h
			mov dl,2dh
			int 21h
			pop dx
			pop ax
		chisbgo:
			add si,1
			mov bx,0ah
			div bx
			add dx, 30h
			push dx
			xor dx,dx
			cmp ax, 0
			jne chisbgo
		mov cx, si
		mov ah,02h
		chisbToScr:
			pop dx
			int 21h
			loop chisbToScr
			
		mov dl,2fh
		int 21h
		pop dx
		mov ax,dx
		
		xor bx,bx
		xor si,si
		xor dx,dx
		cmp ax, 32767d
		jbe chisb1go
			neg ax
			push ax
			push dx
			mov ah,02h
			mov dl,2dh
			int 21h
			pop dx
			pop ax
		chisb1go:
			add si,1
			mov bx,0ah
			div bx
			add dx, 30h
			push dx
			xor dx,dx
			cmp ax, 0
			jne chisb1go
		mov cx, si
		mov ah,02h
		chisb1ToScr:
			pop dx
			int 21h
			loop chisb1ToScr
		ret
	printDrob endp
	
	sokrat proc
		mov si,0
		mov di,0
		cmp ax,32767d
		jbe axok
			neg ax
			mov si,1
		axok:
		cmp bx,32767d
		jbe bxok
			neg bx
			mov di,1
		bxok:
		push ax
		push bx		
		gcd:
			cmp ax,bx
			jz  stop
			jl  less 
			sub ax,bx 
			jmp gcd
		less:
			sub bx,ax
			jmp gcd
		stop:
			mov cx,ax
		pop bx
		pop ax
		xor dx,dx
		div cx
		push ax
		xor dx,dx
		mov ax,bx
		div cx
		mov bx,ax
		pop ax
		cmp si,1
		jne axok1
			neg ax
		axok1:
		cmp di,1
		jne bxok1
			neg bx
		bxok1:
		ret
	sokrat endp
	
	summ proc
		mov al, fr1.num
		mov bl, fr2.den
		imul bl
		push ax
		mov al, fr2.num
		mov bl, fr1.den
		imul bl
		mov dx, ax
		pop ax
		add ax, dx
		push ax
		mov al, fr1.den
		mov bl, fr2.den
		imul bl
		mov bx,ax
		pop ax
		call sokrat
		mov dx,bx
		call printDrob
		ret
	summ endp
	
	razn proc
		mov al, fr1.num
		mov bl, fr2.den
		imul bl
		push ax
		mov al, fr2.num
		mov bl, fr1.den
		imul bl
		mov dx, ax
		pop ax
		cmp ax,dx
		jg torazn
			push ax
			push dx
			mov dl,2dh
			mov ah,02h
			int 21h
			pop ax
			pop dx
		torazn:
		sub ax, dx
		push ax
		mov al, fr1.den
		mov bl, fr2.den
		imul bl
		mov bx,ax
		pop ax
		call sokrat
		mov dx,bx
		call printDrob
		ret
	razn endp
	
	proizved proc
		xor ax,ax
		xor bx,bx
		mov al, fr1.num
		mov bl, fr2.num
		imul bl
		push ax
		xor ax,ax
		xor bx,bx
		mov al, fr1.den
		mov bl, fr2.den
		imul bl
		mov bx,ax
		pop ax
		call sokrat
		mov dx,bx
		call printDrob
		ret
	proizved endp
	
	chastnoe proc
		xor ax,ax
		xor bx,bx
		mov al, fr1.num
		mov bl, fr2.den
		imul bl
		push ax
		xor ax,ax
		xor bx,bx
		mov al, fr2.num
		mov bl, fr1.den
		imul bl
		mov bx,ax
		pop ax
		call sokrat
		mov dx,bx
		call printDrob
		ret
	chastnoe endp
	
end start

	