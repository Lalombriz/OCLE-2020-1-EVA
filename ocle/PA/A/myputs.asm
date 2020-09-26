dosseg 
	.model small
	.code 
		public _myputchar 
		
		_myputchar proc
					push bp
					mov bp,sp
					
					mov dl,[bp+4]
					mov ah,2
					int 21h
					
					pop bp
					ret
		_myputchar	endp
	end 