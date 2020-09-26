dosseg
.model small
.code

public _pract
; void pract(char a[], int i, int n)c
        _pract proc
            push bp
            mov bp,sp
            push si
            push di
			
            mov bx,[bp+4] ; *a
            mov si,[bp+6] ; i
            mov cx,[bp+8] ; n

    @@if:   cmp  si,cx
            jne @@eif
            mov dx,bx
            call puts


             mov di,si
    @@fi:   cmp di,cx
            jg @@efi

            mov al,[bx+si]
            xchg al,[bx+di]
            mov [bx+si],al

            ;llamar recursion
            push cx
            push si
            push bx
            call _pract
            add sp,6

            mov al,[bx+si]
            xchg al,[bx+di]
            mov [bx+si],al

            inc di
            jmp @@fi
@@efi:
@@eif:
            pop di
            pop si
            ret
        _pract endp


			puts proc
			push dx		
			push ax
			push bx
			
			mov bx,dx	
	@@nxt:	cmp byte ptr[bx],0	
			je @@fin			
			mov dl,[bx]			
			mov ah,02h			
			int 21h				
			inc bx				
			jmp @@nxt	
			
	@@fin:
			pop bx
			pop ax
			pop dx
			ret
			endp

end