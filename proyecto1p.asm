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
    celdas_atacadas db 0,0,0,0,0,0,0,0,0,0,0 
    mapa_size db 11
    is_subamarino_vivo db 1 
    is_destructor_vivo db 1 
    is_portaviones_vivo db 1
    barco_size db ? 
    num dw 0 
    intentar db ?
    
    n_fila db 31h

    ; NO TOCAR
    tablero_base dw 4131h, 4231h, 4331h, 4431h, 4531h, 4631h
           dw 4132h, 4232h, 4332h, 4432h, 4532h, 4632h
           dw 4133h, 4233h, 4333h, 4433h, 4533h, 4633h
           dw 4134h, 4234h, 4334h, 4434h, 4534h, 4634h
           dw 4135h, 4235h, 4335h, 4435h, 4535h, 4635h
           dw 4136h, 4236h, 4336h, 4436h, 4536h, 4636h   
               
    newline db 0Dh, 0Ah, '$'
    
    mensaje_cargando db 0Dh, 0Ah, 'Cargando...', 0Dh, 0Ah, '$'    
    
    ; NO TOCAR
    mapa_1 dw 4434h, 4435h, 4436h, 4432h, 4532h, 4632h, 4231h, 4232h, 4233h, 4234h, 4235h
    mapa_2 dw 4132h, 4133h, 4134h, 4333h, 4433h, 4533h, 4236h, 4336h, 4436h, 4536h, 4636h
    mapa_3 dw 4531h, 4532h, 4533h, 4634h, 4635h, 4636h, 4134h, 4234h, 4334h, 4434h, 4534h
    mapa_4 dw 4132h, 4232h, 4332h, 4234h, 4235h, 4236h, 4431h, 4432h, 4433h, 4434h, 4434h
    mapa_5 dw 4236h, 4336h, 4436h, 4533h, 4534h, 4535h, 4131h, 4231h, 4331h, 4431h, 4531h
    mapa_6 dw 4231h, 4232h, 4233h, 4433h, 4434h, 4435h, 4631h, 4632h, 4633h, 4634h, 4635h
    mapa_7 dw 4435h, 4535h, 4635h, 4234h, 4235h, 4236h, 4133h, 4233h, 4333h, 4433h, 4533h
    
    mapa_en_juego dw 11 dup(?)
       
    mapa_print db 6 dup(?)
               db 6 dup(?)
               db 6 dup(?)
               db 6 dup(?)
               db 6 dup(?)
               db 6 dup(?) 
               
    encabezado_col db 0Dh, 0Ah,'  A B C D E F', 0Dh, 0Ah, '$' 
    juego db 0Dh, 0Ah,'BATALLA NAVAL', '$'
    condicion db db 0Dh, 0Ah,'Tienes 18 misiles para destruir la flota enemiga', '$'           

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

    ; Llamar a la subrutina para seleccionar aleatoriamente un mapa_en_juego
    call seleccionar_navio_aleatorio

    ; Inicializar el puntero al mapa a imprimir
    lea si, mapa_print

    ; Recorrer el tablero_base
    lea di, tablero_base
    mov cx, 6    ; número de filas
    mov bx, 6    ; número de columnas

    fila_loop:
        push cx 
        mov cx, bx   ; número de columnas
    
    columna_loop: 
        push cx
        mov dx, [di] ; cargar el valor de tablero_base
        push di      ; guarda la direccion de tablero_base
        lea di, mapa_en_juego
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
    
    ; Subrutina para seleccionar aleatoriamente un mapa_en_juego
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
        je copiar_mapa_1
        cmp al, 1
        je copiar_mapa_2
        cmp al, 2
        je copiar_mapa_3
        cmp al, 3
        je copiar_mapa_4
        cmp al, 4
        je copiar_mapa_5
        cmp al, 5
        je copiar_mapa_6
        cmp al, 6
        je copiar_mapa_7
    
    copiar_mapa_1:
        lea si, mapa_1
        jmp copiar
    
    copiar_mapa_2:
        lea si, mapa_2
        jmp copiar
    
    copiar_mapa_3:
        lea si, mapa_3
        jmp copiar
    
    copiar_mapa_4:
        lea si, mapa_4
        jmp copiar
    
    copiar_mapa_5:
        lea si, mapa_5
        jmp copiar
    
    copiar_mapa_6:
        lea si, mapa_6
    
    copiar_mapa_7:
        lea si, mapa_7
    
    copiar:
        ; Copiar el arreglo seleccionado a mapa_en_juego
        lea di, mapa_en_juego
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

     ; Imprime el mensaje de ingreso en 3 partes    
    ingreso:
        mov cl, 00h
        lea dx, msg_misil   ;Imprime la palabra Misil
        mov ah, 09h
        int 21h
        
        mov ah, 00h
        mov al, ch          ;Mueve el numero de misil actual al registro para imprimirlo
        
    ; Cuando el numero de misil tenga 2 digitos, realiza las operaciones necesarias para mostrarlo
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
        jz  mostrar  ;si dl es igual a 0 salta a la etiqueta mostrar
                               
    mostrar:
        sub cl, 1    ;decrementa cx en 1
        pop ax       ;retira el ultimo valor ingresado en la pila y lo guarda en ax
        mov ah, 02h  ;se coloca 02h en ah (funcion)
        mov dl, al   ;se guarda el contenido de al en dl
        add dl, 30h  ;se suma 30h a dl para obtener el caracter ascii correcto
        int 21h
          ;esta linea y las 2 siguientes son para dejar un espacio entre cada numero
        mov dl, 0h
        int 21h      ;se llama a interrupcion 21h para mostrar el caracter por pantalla
        cmp cl, 0    ;verifica si el contador llego a 0
        jnz mostrar  ;si lo anterior no se cumple, salta a la etiqueta mostrar
        mov ah,00h 
        
        
        
        lea dx, msg_misil_2    ;Imprime el resto del mensaje de ingreso de celda
        mov ah, 09h
        int 21h 
        
        ; Lee la columna ingresada por el usuario
        mov ah, 01h
        int 21h
        
        ; verificar interrupcion con ctrl+e
        cmp al, 05h       ; en caso de leer el ascii de ctrl+e, salta a la etiqueta fin
        jz fin 
        
        mov columna, al   ;guarda el valor ingresado en la variable columna
        
        ; Lee la fila ingresada
        mov ah, 01h
        int 21h
        ; verificar interrupcion con ctrl+e
        cmp al, 05h       ; en caso de leer el ascii de ctrl+e, salta a la etiqueta fin
        jz fin
        mov fila, al      ;guarda el valor ingresado en la variable fila
        
        ; verifica si lo ingresado en la columna se encuentra entre la A y la F 
        cmp columna, 41h    
        jb incorrecto         
        cmp columna, 46h   
        ja incorrecto  
        
        ; verifica si lo ingresado en la fila se encuentra entre el 1 y el 6 
        cmp fila, 31h  
        jb incorrecto
        cmp fila, 36h
        ja incorrecto 
        
        jmp correcto    ; si la celda es valida, pasa al siguiente paso
        
    incorrecto:
        lea dx, msg_incorrecto    ; muestra un mensaje indicando que lo ingresado no cumple el formato
        mov ah, 09h
        int 21h
        jmp ingreso               ; pide que ingrese otra celda
        
        
    correcto:
        mov dx, 00000h
        mov dh, columna           
        mov dl, fila
        mov celda_ingresada, dx   ; obtiene el valor total de la celda y lo guarda en variable    

    verificar_ataque:
        mov si, offset mapa_en_juego    ; inicializar indice para recorrer el array de posiciones de barcos
        mov di, offset celdas_atacadas  ; inicializar indice para recorrer el array de las celdas atacadas
        mov bh, mapa_size               ; indica el numero de celdas cque tienen barcos para controlar iteracion
    
    comparar:                           ; verifica si se ha recorrido todo el array de posiciones
        cmp bh, 00h                     ; es decir, que no se encontró ninguna coincidencia y rechaza el ataque
        jz rechazar_ataque              ; decrementa el numero de posiciones por recorrer del array
        dec bh                          
        
        cmp [si], dx                    ; verifica si la celda ingresada coincide con el elemento de la posicion actual del array
        
        jz verif                        ; si es el caso, verifico si no se ha atacado antes
        jnz control_indices             ; si no es el caso, voy al siguiente indice
                                
    
    control_indices:                    
        add si,2                        ; incremento en 2 el indice de las posiciones porque son de tipo word
        inc di                          ; incremento en 1 el indice de las celdas atacadas porque son tipo byte 
        jmp comparar                    ; itero sobre el array 
    
    verif:
        cmp [di], 01h                   ; verifico si esa celda ya ha sido atacada antes, es decir la lista paralela guarde 1 en esa posicion
        jz omitir_ataque                ; si es el caso, omito el ataque y pido una nueva celda
        jnz ataque                      ; si no es el caso, procedo a guardar el ataque
    
    ataque:
        mov [di], 01h                   ; asigno 1 en las celdas atacadas correspondiente a que la celda fue impactada
        jmp confirmar_ataque            ; imprimo el mensaje de confirmación de ataque
       
    verif_submarino_hundido:
        mov di, offset celdas_atacadas   ; inicializar indice para recorrer el array de posiciones de barcos 
        mov barco_size, 3
        mov bl, barco_size
        cmp is_subamarino_vivo, 01h
        jnz verif_destructor_hundido
    
    verif_celdas_submarino:
        cmp [di], 01h 
        jnz verif_destructor_hundido
        inc di
        dec bl
        cmp bl, 00h            
        jnz verif_celdas_submarino
        
        mov is_subamarino_vivo, bl
        lea dx, msg_submarino
        mov ah, 09h
        int 21h 
        
        jmp verif_victoria_1
        
        
     verif_destructor_hundido:
        mov di, offset celdas_atacadas 
        mov barco_size, 3
        mov bl, barco_size
        add di, 3
        cmp is_destructor_vivo, 01h
        jnz verif_portaviones_hundido
     
     verif_celdas_destructor:
        cmp [di], 01h 
        jnz verif_portaviones_hundido
        inc di
        dec bl
        cmp bl, 00h
        jnz verif_celdas_destructor
        
        mov is_destructor_vivo, 00h
        lea dx, msg_destructor
        mov ah, 09h
        int 21h
        
        jmp verif_victoria_1
         
        
    verif_portaviones_hundido:
        mov di, offset celdas_atacadas 
        mov barco_size, 5
        mov bl, barco_size
        add di, 6
        cmp is_portaviones_vivo, 01h
        jnz verif_victoria_1 
        
    verif_celdas_portaviones:
        cmp [di], 01h 
        jnz ingreso
        inc di
        dec bl
        cmp bl, 00h
        jnz verif_celdas_portaviones
        
        mov is_portaviones_vivo, 00h
        lea dx, msg_portaviones
        mov ah, 09h
        int 21h
        
    
    verif_victoria_1:
        cmp is_subamarino_vivo, 00h
        jz verif_victoria_2
        jnz ingreso
         
    verif_victoria_2:
        cmp is_destructor_vivo, 00h
        jz verif_victoria_3
        jnz ingreso
        
    verif_victoria_3:
        cmp is_portaviones_vivo, 00h
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
        jnz  verif_submarino_hundido
        
        
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
        ; verificar interrupcion con ctrl+e
        cmp al, 05h       ; en caso de leer el ascii de ctrl+e, salta a la etiqueta fin
        jz fin
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
