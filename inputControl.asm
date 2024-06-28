.model small
.stack 100h
.data
msg db 'Ingrese una celda: $'
num dw 0

.code
main proc
mov ax, @data
mov ds, ax

lea dx, msg
mov ah, 09h
int 21h    


end main







