.model small
.stack 100h
.data
    mapa_1 db 0, 1, 0, 0, 0, 0
           db 0, 1, 0, 1, 1, 1
           db 0, 1, 0, 0, 0, 0
           db 0, 1, 0, 1, 0, 0
           db 0, 1, 0, 1, 0, 0
           db 0, 0, 0, 1, 0, 0       
    
    mapa_2 db 0, 0, 1, 0, 0, 0
           db 0, 0, 1, 0, 0, 0
           db 0, 0, 1, 1, 1, 1
           db 1, 0, 1, 0, 0, 0
           db 1, 0, 1, 0, 0, 0
           db 1, 0, 0, 0, 0, 0 
           
    mapa_3 db 1, 1, 1, 1, 1, 0
           db 0, 0, 0, 0, 0, 0
           db 0, 0, 0, 0, 0, 0
           db 1, 0, 1, 1, 1, 0
           db 1, 0, 0, 0, 0, 0
           db 1, 0, 0, 0, 0, 0 
    
    mapa_4 db 0, 1, 1, 1, 0, 0
           db 1, 0, 0, 0, 0, 0
           db 1, 0, 0, 0, 0, 0
           db 1, 0, 0, 0, 0, 0
           db 0, 1, 1, 1, 1, 1
           db 0, 0, 0, 0, 0, 0 
    
    mapa_5 db 0, 0, 0, 0, 0, 0
           db 0, 0, 0, 0, 0, 0
           db 0, 0, 0, 0, 0, 0
           db 0, 0, 0, 0, 0, 0
           db 0, 0, 0, 0, 0, 0
           db 0, 0, 0, 0, 0, 0 
    
    mapa_6 db 0, 0, 0, 0, 0, 1
           db 0, 1, 1, 1, 0, 1
           db 0, 0, 0, 0, 0, 1
           db 0, 0, 0, 0, 0, 1
           db 1, 1, 1, 0, 0, 1
           db 0, 0, 0, 0, 0, 0 
    
    mapa_7 db 0, 0, 0, 0, 0, 0
           db 0, 0, 0, 0, 0, 0
           db 1, 1, 1, 1, 1, 0
           db 0, 1, 0, 0, 0, 0
           db 0, 1, 0, 0, 0, 0
           db 0, 1, 0, 1, 1, 1 
    newline db 13, 10, '$'
    
.code
start:
    mov ax, @data
    mov ds, ax
    mov es, ax
    
    lea si, mapa_1
    
    mov cx, 8
    
fila_loop:
    push cx
    
    mov cx, 8

columna_loop:
    mov al, [si]
    add al, 030h
    call print_char
    
    mov al, ' '
    call print_char
    
    inc si
    loop columna_loop
    
    lea dx, newline
    mov ah, 09h
    int 21h
    
    pop cx
    loop fila_loop
    
    mov ax, 4C00h
    int 21h
    
print_char:
    mov ah, 02h
    int 21h
    ret
end start    



















