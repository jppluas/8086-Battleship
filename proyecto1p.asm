                                    .model small
.stack 100h
.data
    seed dw ?          ; Espacio para la semilla
    buffer db 6 dup('$') ; Buffer para almacenar el número como cadena

.code
main proc
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; Obtener el contador de reloj del sistema
    mov ah, 00h        ; Función para leer el contador de reloj
    int 1Ah            ; Llamada a la interrupción BIOS
    mov seed, dx       ; Usar los 16 bits bajos del contador de reloj como semilla

    call random         ; Generar número aleatorio
    call int_to_str     ; Convertir número a cadena

    ; Mostrar el número aleatorio
    lea dx, buffer
    mov ah, 09h
    int 21h

    ; Fin del programa
    mov ax, 4C00h
    int 21h
main endp

; Función para generar un número pseudoaleatorio usando LCG
random proc
    mov ax, seed
    mov bx, 0x4E35      ; Multiplicador
    mul bx              ; DX:AX = AX * BX
    add ax, 0x1234      ; Agregar incremento
    mov seed, ax        ; Guardar nueva semilla

    ; Limitar el valor al rango 1-15
    mov bx, 15          ; Divisor
    xor dx, dx          ; Limpiar DX
    div bx              ; AX = AX / BX, DX = AX % BX
    mov ax, dx          ; AX = Resto
    add ax, 1           ; Asegurar que el valor esté entre 1 y 15

    ret
random endp

; Función para convertir un número entero a cadena
int_to_str proc
    mov bx, 10          ; Divisor para obtener los dígitos
    xor cx, cx          ; Limpiar cx (contador de dígitos)

convert_loop:
    xor dx, dx          ; Limpiar dx
    div bx              ; AX = AX / 10, DX = AX % 10
    add dl, '0'         ; Convertir dígito a carácter ASCII
    push dx             ; Almacenar carácter en la pila
    inc cx              ; Incrementar contador de dígitos
    test ax, ax         ; Verificar si ax es 0
    jnz convert_loop    ; Si no es 0, continuar con el siguiente dígito

    ; Extraer los caracteres de la pila al buffer
    lea di, buffer
extract_loop:
    pop dx              ; Obtener carácter de la pila
    mov [di], dl        ; Almacenar en el buffer
    inc di              ; Mover al siguiente carácter en el buffer
    loop extract_loop

    ; Agregar el terminador de cadena
    mov byte ptr [di], '$'
    ret
int_to_str endp

end main
