.model small
.stack 100h
.data 
    msg_intentar db 0Dh, 0Ah, 0Dh, 0Ah, 'Desea jugar de nuevo? Si(1)/No(0) $'
    msg_misil db 0Dh, 0Ah,'Misil $'
    msg_misil_2 db ', ingrese la celda a atacar: $'      
    msg_incorrecto db 0Dh, 0Ah, 'Ingrese una celda valida (Columna A-F y Fila 1-6)$'
    msg_incorrecto_2 db 0Dh, 0Ah, 'Ingrese una opción valida$'
    msg_victoria db 0Dh, 0Ah,'Ganaste! ;)$'
    msg_derrota db 0Dh, 0Ah, 0Dh, 0Ah, 'Mejor suerte para la proxima! ;)$'
    msg_gracias db 0Dh, 0Ah,'Gracias por jugar, vuelve pronto ;)$'
    msg_ataque_confirmado db '..........Impacto confirmado$'
    msg_ataque_fallido db '..........Sin impacto$'
    msg_submarino db ' ; Submarino hundido!$'  
    msg_destructor db ' ; Destructor hundido!$'
    msg_portaviones db ' ; Portaviones hundido!$'
    msg_ataque_repetido db '..........Ya impactado, intente de nuevo$'
    fila db ?
    columna db ? 
    celda_ingresada dw ?
    ataques_prueba db 0,0,0,0,0,0,0,0,0,0,0 
    mapa_size db 11
    barco_1 db 1 
    barco_2 db 1 
    barco_3 db 1
    barco_size db ? 
    num dw 0 
    intentar db ?
    
    n_fila db 31h

    ; NO TOCAR
    mapa_1 dw 4131h, 4231h, 4331h, 4431h, 4531h, 4631h
           dw 4132h, 4232h, 4332h, 4432h, 4532h, 4632h
           dw 4133h, 4233h, 4333h, 4433h, 4533h, 4633h
           dw 4134h, 4234h, 4334h, 4434h, 4534h, 4634h
           dw 4135h, 4235h, 4335h, 4435h, 4535h, 4635h
           dw 4136h, 4236h, 4336h, 4436h, 4536h, 4636h   
               
    newline db 0Dh, 0Ah, '$'
    
    mensaje_cargando db 0Dh, 0Ah, 'Cargando...', 0Dh, 0Ah, '$'    
    
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
               
    encabezado_col db 0Dh, 0Ah,'  A B C D E F', 0Dh, 0Ah, '$' 
    juego db 0Dh, 0Ah,'BATALLA NAVAL', '$'
    condicion db db 0Dh, 0Ah,'Tienes 18 misiles para destruit la flota enemiga', '$'           

.code
main proc
    mov ax, @data
    mov ds, ax
    mov es, ax 
    
;--------------------------------------------------------------------------------------------------
; ----------------------------- UBICACION ALEATORIA DE BARCOS --------------------------------------
; --------------------------------------------------------------------------------------------------    
    
    start:    
    lea dx, juego
    mov ah, 09h
    int 21h 
    
    lea dx, condicion
    mov ah, 09h
    int 21h 
    
    lea dx, mensaje_cargando 
    mov ah, 09h
    int 21h

    ; Llamar a la subrutina para seleccionar aleatoriamente un navio
    call seleccionar_navio_aleatorio

    ; Inicializar el puntero al mapa a imprimir
    lea si, mapa_print

    ; Recorrer el mapa_1
    lea di, mapa_1
    mov cx, 6    ; número de filas
    mov bx, 6    ; número de columnas

    fila_loop:
        push cx 
        mov cx, bx   ; número de columnas
    
    columna_loop: 
        push cx
        mov dx, [di] ; cargar el valor de mapa_1
        push di      ; guarda la direccion de mapa_1
        lea di, navio
        mov cx, 11   ; número de elementos en navios
        
    navio_loop:
        cmp dx, [di]
        je encontrado
        add di, 2
        loop navio_loop
        
        ; no encontrado en navios
        mov [si], -48
        jmp siguiente
    
    encontrado:
        mov [si], 1
        
    siguiente:
        pop di
        add di, 2
        inc si
        pop cx
        loop columna_loop
        
        pop cx
        loop fila_loop       
        
        lea dx, encabezado_col
        mov ah, 09h
        int 21h
        
        ; imprimir mapa_print con '*'
        lea si, mapa_print
        mov cx, 6
    
    imprimir_fila_loop:        
        mov dh, n_fila
        mov dl, dh        
        mov ah, 02h
        int 21h
        
        inc n_fila
        
              
        mov dl, ' '
        mov ah, 02h
        int 21h
    
        push cx
        mov cx, 6
        
    imprimir_columna_loop:
        mov al, '*'
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
    
        jmp logica
    
    ; Subrutina para seleccionar aleatoriamente un navio
    seleccionar_navio_aleatorio:
        ; Generar un número aleatorio entre 0 y 6
        mov ah, 2Ch          ; Interrupción del reloj del sistema
        int 21h
        mov al, dh           ; Usar el valor de los segundos como número pseudoaleatorio
        and al, 07h          ; Limitar el valor a 0-7
        cmp al, 06h
        jle skip_dec         ; Si el valor es 0-6, continuar
        dec al               ; Si el valor es 7, cambiarlo a 6
    skip_dec:
    
        ; Seleccionar el arreglo de navíos correspondiente
        cmp al, 0
        je copiar_navio_1
        cmp al, 1
        je copiar_navio_2
        cmp al, 2
        je copiar_navio_3
        cmp al, 3
        je copiar_navio_4
        cmp al, 4
        je copiar_navio_5
        cmp al, 5
        je copiar_navio_6
        cmp al, 6
        je copiar_navio_7
    
    copiar_navio_1:
        lea si, navio_1
        jmp copiar
    
    copiar_navio_2:
        lea si, navio_2
        jmp copiar
    
    copiar_navio_3:
        lea si, navio_3
        jmp copiar
    
    copiar_navio_4:
        lea si, navio_4
        jmp copiar
    
    copiar_navio_5:
        lea si, navio_5
        jmp copiar
    
    copiar_navio_6:
        lea si, navio_6
    
    copiar_navio_7:
        lea si, navio_7
    
    copiar:
        ; Copiar el arreglo seleccionado a navio
        lea di, navio
        mov cx, 11
    copiar_navio:
        mov ax, [si]
        mov [di], ax
        add si, 2
        add di, 2
        loop copiar_navio
        ret   

;--------------------------------------------------------------------------------------------------
; ----------------------------- LOGICA DEL ATAQUES  ------------------------------------------------
; --------------------------------------------------------------------------------------------------    
    
    logica: 
    mov n_fila, 31h
    mov bx, 00000h
    mov cx, 00000h
    mov dx, 00000h
    mov ch, 1   ; inicializamos el numero de intento 

    ; Mostrar el mensaje     
    ingreso:
        mov cl, 00h
        lea dx, msg_misil
        mov ah, 09h
        int 21h
        mov ah, 00h
        mov al, ch
        
    convertir:
        mov bl, 10   ;mueve 10 a bl
        div bl       ;divide el contenido de ax para 10, el cociente se guarda en al y el residuo en ah
        mov dh, ah   ;mueve el contenido de ah a dh  
        mov dl, al   ;guarda el contenido de al en dl
        mov ah, 00h  ;guarda 0 en ah
        mov al, dh   ;mueve el contenido de dh a al
        push ax      ;guarda el contenido de ax en la pila
        mov ax, 0000h;guarda 0 en ax   
        mov al, dl   ;guarda el cociente de la division en al
        add cl, 1
        cmp dl, 0    ;verifica si el cociente es 0
        jnz convertir;si no se cumple lo anterior regresa a la etiqueta convertir
        mov ah, 02h  ;esta linea y las 2 siguientes son para dejar un espacio entre cada numero
        mov dl, 0h
        int 21h
        jz  mostrar  ;si dl es igual a 0 salta a la etiqueta mostrar
                               
    mostrar:
        sub cl, 1    ;decrementa cx en 1
        pop ax       ;retira el ultimo valor ingresado en la pila y lo guarda en ax
        mov ah, 02h  ;se coloca 02h en ah (funcion)
        mov dl, al   ;se guarda el contenido de al en dl
        add dl, 30h  ;se suma 30h a dl para obtener el caracter ascii correcto
        int 21h      ;se llama a interrupcion 21h para mostrar el caracter por pantalla
        cmp cl, 0    ;verifica si el contador llego a 0
        jnz mostrar  ;si lo anterior no se cumple, salta a la etiqueta mostrar
        mov ah,00h 
        
        
        
        lea dx, msg_misil_2
        mov ah, 09h
        int 21h 
        
        ; Lee la columna ingresada por el usuario
        mov ah, 01h
        int 21h
        mov columna, al
        
        ; Lee la fila ingresada
        mov ah, 01h
        int 21h
        mov fila, al
        
        ; verificar ctrl+e
        cmp columna, 05h
        jz fin
        
        ;verificar si los valores se encuentran en los rangos correctos
        cmp columna, 0h
        je incorrecto 
        cmp fila, 0h
        je incorrecto
        
         
        cmp columna, 41h
        jb incorrecto
        cmp columna, 46h
        ja incorrecto  
        
        cmp fila, 31h  
        jb incorrecto
        cmp fila, 36h
        ja incorrecto 
        
        jmp correcto  
        
    incorrecto:
        lea dx, msg_incorrecto
        mov ah, 09h
        int 21h
        jmp ingreso   
        
        
    correcto:
        mov dx, 00000h
        mov dh, columna
        add dl, fila
        mov celda_ingresada, dx        ; obtener el valor total de la celda

    verificar_ataque:
        mov si, offset navio     ; inicializar indice para recorrer el array de navios
        mov di, offset ataques_prueba  ; inicializar indice para recorrer el array de ataques
        mov bh, mapa_size 
    
    comparar: 
        cmp bh, 00h
        jz rechazar_ataque  
        dec bh
        mov ax, [si]
        
        cmp [si], dx
        
        jz verif
        jnz control_indices
        
        jmp rechazar_ataque    
    
    control_indices:
        add si,2
        inc di
        jmp comparar          
    
    verif:
        cmp [di], 01h
        jz omitir_ataque
        jnz ataque
    
    ataque:
        mov [di], 01h
        jmp confirmar_ataque
       
    pre_verif_barcos_1:
        mov di, offset ataques_prueba
        mov barco_size, 3
        mov bl, barco_size
        cmp barco_1, 01h
        jnz pre_verif_barcos_2
    
    lup_1:
        cmp [di], 01h 
        jnz pre_verif_barcos_2
        inc di
        dec bl
        cmp bl, 00h            
        jnz lup_1
        
        mov barco_1, bl
        lea dx, msg_submarino
        mov ah, 09h
        int 21h 
        
        jmp verif_victoria_1
        
        
     pre_verif_barcos_2:
        mov di, offset ataques_prueba 
        mov barco_size, 3
        mov bl, barco_size
        add di, 3
        cmp barco_2, 01h
        jnz pre_verif_barcos_3
     
     lup_2:
        cmp [di], 01h 
        jnz pre_verif_barcos_3
        inc di
        dec bl
        cmp bl, 00h
        jnz lup_2
        
        mov barco_2, 00h
        lea dx, msg_destructor
        mov ah, 09h
        int 21h
        
        jmp verif_victoria_1
         
        
    pre_verif_barcos_3:
        mov di, offset ataques_prueba 
        mov barco_size, 5
        mov bl, barco_size
        add di, 6
        cmp barco_3, 01h
        jnz verif_victoria_1 
        
    lup_3:
        cmp [di], 01h 
        jnz ingreso
        inc di
        dec bl
        cmp bl, 00h
        jnz lup_3
        
        mov barco_3, 00h
        lea dx, msg_portaviones
        mov ah, 09h
        int 21h
        
    
    verif_victoria_1:
        cmp barco_1, 00h
        jz verif_victoria_2
        jnz ingreso
         
    verif_victoria_2:
        cmp barco_2, 00h
        jz verif_victoria_3
        jnz ingreso
        
    verif_victoria_3:
        cmp barco_3, 00h
        jnz ingreso 
    
    victoria:
        lea dx, msg_victoria
        mov ah, 09h
        int 21h

        ; Mostrar la tabla completa al final
        lea dx, encabezado_col
        mov ah, 09h
        int 21h
        
        ; imprimir mapa_print
        lea si, mapa_print
        mov cx, 6
          
    imprimir_fila_loop_final:        
        mov dh, n_fila
        mov dl, dh        
        mov ah, 02h
        int 21h
        
        inc n_fila
        
              
        mov dl, ' '
        mov ah, 02h
        int 21h
    
        push cx
        mov cx, 6
        
    imprimir_columna_loop_final:
        mov al, [si]
        add al, 30h   ; convertir el número a su equivalente ASCII
        mov dl, al
        mov ah, 02h
        int 21h
    
        mov dl, ' '
        mov ah, 02h
        int 21h
    
        inc si
        loop imprimir_columna_loop_final
    
        lea dx, newline
        mov ah, 09h
        int 21h
    
        pop cx
        loop imprimir_fila_loop_final

        jmp exit     
    
    derrota:
        lea dx, msg_derrota
        mov ah, 09h
        int 21h

        ; Mostrar la tabla completa al final
        lea dx, encabezado_col
        mov ah, 09h
        int 21h
        
        ; imprimir mapa_print
        lea si, mapa_print
        mov cx, 6
          
    imprimir_fila_loop_derrota:        
        mov dh, n_fila
        mov dl, dh        
        mov ah, 02h
        int 21h
        
        inc n_fila
        
              
        mov dl, ' '
        mov ah, 02h
        int 21h
    
        push cx
        mov cx, 6
        
    imprimir_columna_loop_derrota:
        mov al, [si]
        add al, 30h   ; convertir el número a su equivalente ASCII
        mov dl, al
        mov ah, 02h
        int 21h
    
        mov dl, ' '
        mov ah, 02h
        int 21h
    
        inc si
        loop imprimir_columna_loop_derrota
    
        lea dx, newline
        mov ah, 09h
        int 21h
    
        pop cx
        loop imprimir_fila_loop_derrota

        jmp exit        
        
    rechazar_ataque:
        inc ch
        lea dx, msg_ataque_fallido
        mov ah, 09h
        int 21h
        
        cmp ch, 19
        jz derrota
        jnz ingreso                       
              
    confirmar_ataque:
        inc ch
        lea dx, msg_ataque_confirmado
        mov ah, 09h
        int 21h
        
        
        cmp ch, 19
        jz derrota           
        jnz  pre_verif_barcos_1
        
        
    omitir_ataque:
        lea dx, msg_ataque_repetido
        mov ah, 09h
        int 21h
        jmp ingreso
          
    incorrecto_2:
        lea dx, msg_incorrecto_2
        mov ah, 09h
        int 21h
        jmp exit  
    
    exit: 
    
        lea dx, msg_intentar
        mov ah, 09h
        int 21h
        
        ; Lee la columna ingresada por el usuario
        mov ah, 01h
        int 21h
        mov intentar, al
        
        mov ax, @data
        mov ds, ax
        mov es, ax 
        
        ;verificar la opcion seleccionada
        cmp intentar, 30h
        jb incorrecto_2
        cmp intentar, 31h
        ja incorrecto_2
        
        cmp intentar, 30h  
        jnz start
        
    fin:
        lea dx, msg_gracias
        mov ah, 09h
        int 21h  
        
        mov ax, 4C00h
        int 21h
        
main endp
end main
