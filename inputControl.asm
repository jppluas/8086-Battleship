.model small
.stack 100h
.data
msg db 'Ingrese una celda: $'
num dw 0

.code
main proc
mov ax, @data
mov ds, ax

; Mostrar el mensaje
lea dx, msg
mov ah, 09h
int 21h

; Leer el primer dígito del número ingresado por el usuario
mov ah, 01h
int 21h
    


end main







