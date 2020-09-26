MODEL small
   .STACK 100h

   ;----- Insert INCLUDE "filename" directives here
   ;----- Insert EQU and = equates here

 INCLUDE procs.inc
 
       LOCALS

	  N     EQU 20
	  CR	EQU 13
	  LF 	EQU	10
	   
   .DATA
      mens       db  'Hola Mundo',CR,LF,0
		i		 db (?)
	   
	  
   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

				call clrscr
				
				; i=0
				mov byte ptr[i],0
				
				; i<n
     @@cmp_for: cmp byte ptr[i],N
                jae @@fin_for
				
				mov al,[i]
				add al,30h    ; convierte a ASCII
				
				call putchar
                
				mov al,'-'
                call putchar				
				
				mov  dx,offset mens 
				call puts
                   
				; i++
                inc byte ptr[i]
                jmp @@cmp_for
				
     @@fin_for:	call getch

				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ; 

                ENDP

; incluir procedimientos	
; ejemplo:
; funcionX PROC ; < -- Indica a TASM el inicio del un procedimiento
;               ; 
;               ; < --- contenido del procedimiento
;           ret
;           ENDP; < -- Indica a TASM el fin del procedimiento



         END
