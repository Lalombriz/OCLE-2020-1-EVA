; uint32_t sum32bits(uint32_t x, uint32_t y);
dosseg 
.model small
	.code 
		public _sum32bits
		_sum32bits proc

			push bp 
			mov bp,sp

            mov ax,[bp+4]  ;B
            mov dx,[bp+6]  ;H
            mov bx,[bp+8]  ;B
            mov cx,[bp+10] ;H

            add ax,cx
            adc dx,bx

            pop bp 
            ret  
            endp _sum32bits
        end  





