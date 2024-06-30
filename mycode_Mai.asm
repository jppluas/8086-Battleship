.model small
.stack 100h
.data  
    ; NO TOCAR
    mapa_1 dw 4131h, 4231h, 4331h, 4431h, 4531h, 4631h
           dw 4132h, 4232h, 4332h, 4432h, 4532h, 4632h
           dw 4133h, 4233h, 4333h, 4433h, 4533h, 4633h
           dw 4134h, 4234h, 4334h, 4434h, 4534h, 4634h
           dw 4135h, 4235h, 4335h, 4435h, 4535h, 4635h
           dw 4136h, 4236h, 4336h, 4436h, 4536h, 4636h   
               
    newline db 0Dh, 0Ah, '$'    
    
    ; NO TOCAR
    navio_1 dw 4434h, 4435h, 4436h, 4432h, 4532h, 4632h, 4231h, 4232h, 4233h, 4234h, 4235h
    
    navio_2 dw 4132h, 4133h, 4134h, 4333h, 4433h, 4533h, 4236h, 4336h, 4436h, 4536h, 4636h
    
    navio_3 dw 4531h, 4532h, 4533h, 4634h, 4635h, 4636h, 4134h, 4234h, 4334h, 4434h, 4534h
    
    navio_4 dw 4132h, 4232h, 4332h, 4234h, 4235h, 4236h, 4431h, 4432h, 4433h, 4434h, 4434h
    
    navio_5 dw 4236h, 4336h, 4436h, 4533h, 4534h, 4535h, 4131h, 4231h, 4331h, 4431h, 4531h
    
    navio_6 dw 4231h, 4232h, 4233h, 4433h, 4434h, 4435h, 4631h, 4632h, 4633h, 4634h, 4635h
    
    navio_7 dw 4435h, 4535h, 4635h, 4234h, 4235h, 4236h, 4133h, 4233h, 4333h, 4433h, 4533h
    
    navio dw 11 dup(?)
       
    mapa_print db 6 dup(?)
               db 6 dup(?)
               db 6 dup(?)
               db 6 dup(?)
               db 6 dup(?)
               db 6 dup(?)
    
.code
start:
    mov ax, @data
    mov ds, ax
    mov es, ax
    
    ;inicializar el puntero al mapa a imprimir
    lea si, mapa_print
    
    ;recorrer el mapa_1
    lea di, mapa_1
    mov cx, 6; #filas
    mov bx, 6; #columnas
    
fila_loop:
    push cx 
    mov cx, bx   ; número de columnas

columna_loop: 
    push cx
    mov dx, [di]; cargar el valor de mapa_1
    push di     ; guarda la direccion de mapa_1
    lea di, navio_7
    mov cx, 11; numeros de elementos en navios
    
navio_loop:
    cmp dx, [di]
    je encontrado
    add di, 2
    loop navio_loop
    
    ;no encontrado en navios
    mov [si], 0
    jmp siguiente

encontrado:
    mov [si], 1
    
siguiente:
    pop di
    add di, 2
    inc si
    pop cx
    loop columna_loop
    
    lea dx, newline
    mov ah, 09h
    int 21h
    
    pop cx
    loop fila_loop
    
    ;imprimir mapa_print
    lea si, mapa_print
    mov cx, 6

imprimir_fila_loop:
    push cx
    mov cx, 6
    
imprimir_columna_loop:
    mov al, [si]
    add al, 30h   ; convertir el número a su equivalente ASCII
    mov dl, al
    mov ah, 02h
    int 21h

    mov dl, ' '
    mov ah, 02h
    int 21h

    inc si
    loop imprimir_columna_loop

    lea dx, newline
    mov ah, 09h
    int 21h

    pop cx
    loop imprimir_fila_loop

    mov ax, 4C00h
    int 21h

end start