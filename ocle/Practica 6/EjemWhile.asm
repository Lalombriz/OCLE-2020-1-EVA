MODEL small
   .STACK 100h

   ;----- Insert INCLUDE "filename" directives here
   ;----- Insert EQU and = equates here

   N  EQU  30
   CR  EQU 13
   LF  EQU  10
   
 INCLUDE procs.inc
 
       LOCALS
	   
   .DATA
      mens       db  'Hola Mundo',CR,LF,0
	  letra      db  0
	  
   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

				call clrscr	
				 
  	   @@while:	cmp byte ptr[letra],'S' 
                jz  @@end_while				
			    
	            mov  dx,offset mens
				call puts
					
				call getch
                mov [letra],al
				
				jmp @@while
				 
     @@end_while:				
				
				call getch

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
