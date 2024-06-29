.model small
.stack 100h
.data
msg db 0Dh, 0Ah, 'Ingrese una celda: $'   
msg_correcto db 0Dh, 0Ah, 'Correcto$'   
msg_incorrecto db 0Dh, 0Ah, 'Incorrecto, intente de nuevo$' 
fila db ?
columna db ?

num dw 0

.code
main proc
    mov ax, @data
    mov ds, ax

; Mostrar el mensaje     
ingreso:
    lea dx, msg
    mov ah, 09h
    int 21h 
    
    ; Leer el primer dígito del número ingresado por el usuario
    mov ah, 01h
    int 21h
    mov fila, al
    
    ; Leer el segundo digito
    mov ah, 01h
    int 21h
    mov columna, al
    
    ;verificar si se ingresaron dos caracteres
    cmp fila, 0h
    je incorrecto
    cmp columna, 0
    je incorrecto     
    
    cmp fila, 41h
    jb incorrecto
    cmp fila, 47h
    ja incorrecto 
    
    cmp columna, 31h
    jb incorrecto
    cmp columna, 36h
    ja incorrecto
    
    ; Mostrar mensaje de correcto 
    lea dx, msg_correcto
    mov ah, 09h
    int 21h
    jmp fin

incorrecto:
    lea dx, msg_incorrecto
    mov ah, 09h
    int 21h
    jmp ingreso

fin: 
    mov ah, 4Ch
    int 21h
    


end main