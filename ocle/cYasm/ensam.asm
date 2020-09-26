DOSSEG 
	.model small
	.code 
		public _SAR_R
		
		_SAR_R proc
			push bp 
			mov bp,sp
			
			mov ax,[bp+4]		;   parte baja del dato 
            mov dx,[bp+6]       ;   parte alta del dato
			push ax	
            push dx 		   

            sar dx,1            ;corrimiento respetando el signo 
            rcr ax,1            ;corrimiento del dato sin respetar el signo 

            mov bx,dx           ;retornamos parte alta del dato y la parte baja en AX 



			pop bp 
			ret
 endp
end 
