.model small
.stack 100h
.data 
    msg_intentar db 0Dh, 0Ah, 0Dh, 0Ah, 'Desea jugar de nuevo? Si(1)/No(0) $'
    msg_misil db 0Dh, 0Ah,'Misil $'
    msg_misil_2 db ', ingrese la celda a atacar: $'      
    msg_incorrecto db 0Dh, 0Ah, 'Ingrese una celda valida Ej. C4$'
    msg_incorrecto_2 db 0Dh, 0Ah, 'Ingrese una opcion valida$' 
    msg_incorrecto_enter db 0Dh, 0Ah, 'No es necesario presionar ENTER$' 
    msg_victoria db 0Dh, 0Ah, 0Dh, 0Ah,'Ganaste! ;)$'
    msg_derrota db 0Dh, 0Ah, 0Dh, 0Ah, 'Mejor suerte para la proxima! ;)',0Dh, 0Ah,  '$' 
    msg_gracias db 0Dh, 0Ah,'Gracias por jugar, vuelve pronto ;)$'
    msg_ataque_confirmado db 'Impacto confirmado$'
    msg_ataque_fallido db 'Sin impacto$'
    msg_submarino db ' ; Submarino hundido!$'  
    msg_destructor db ' ; Destructor hundido!$'
    msg_portaviones db ' ; Portaviones hundido!$'
    msg_ataque_repetido db 'Ya impactado, intente de nuevo$'
    msg_cargando_faltantes db 0Dh, 0Ah, 'Mostrando barcos faltantes...', 0Dh, 0Ah, '$'
    msg_separador db ' .......... $' 
    fila db ?
    columna db ? 
    celda_ingresada dw ?
    celdas_atacadas db 0,0,0,0,0,0,0,0,0,0,0 
    mapa_size db 11
    is_submarino_vivo db 1 
    is_destructor_vivo db 1 
    is_portaviones_vivo db 1
    barco_size db ? 
    num dw 0 
    intentar db ? 
    guardar_a dw ?
    guardar_b dw ?
    guardar_c dw ? 
    guardar_d dw ?
    
    
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
    
    celdas_no_atacadas dw 11 dup(?)
    n_celdas_no_atacadas db ?
    
     dw 18 dup(?)
    
    mapa_en_juego dw 11 dup(?)
       
    mapa_print db 6 dup(?)
               db 6 dup(?)
               db 6 dup(?)
               db 6 dup(?)
               db 6 dup(?)
               db 6 dup(?)
    
    
    encabezado_col db 0Dh, 0Ah, '   A B C D E F', 0Dh, 0Ah, '$'           
    encabezado_col_1 db 0Dh, 0Ah,'  A B C D E F', 0Dh, 0Ah, '$'
    f1 db '1 * * * * * *', 0Dh, 0Ah, '$'
    f2 db '2 * * * * * *', 0Dh, 0Ah, '$'
    f3 db '3 * * * * * *', 0Dh, 0Ah, '$'
    f4 db '4 * * * * * *', 0Dh, 0Ah, '$'
    f5 db '5 * * * * * *', 0Dh, 0Ah, '$'
    f6 db '6 * * * * * *', 0Dh, 0Ah, '$'
          
    juego db 0Dh, 0Ah,'BATALLA NAVAL', '$'
    condicion db 0Dh, 0Ah,'Tienes 18 misiles para destruir la flota enemiga', 0Dh, 0Ah, 'Presiona ENTER para visualizar el tablero y ubicar los barcos aleatoriamente ...$'            
    barcos db  0Dh, 0Ah,'Flota: Submarino (3 celdas)', 0Dh, 0Ah,' Destructor (3 celdas)', 0Dh, 0Ah,' Portaviones (5 celdas), ', 0Dh, 0Ah,'$'
.code
main proc
    mov ax, @data
    mov ds, ax
    mov es, ax
    
;--------------------------------------------------------------------------------------------------
; ----------------------------- UBICACION ALEATORIA DE BARCOS --------------------------------------
; --------------------------------------------------------------------------------------------------    
    
    start:
    
    
    mov ah, 06h       ; Función de desplazamiento de ventana hacia arriba
    mov al, 0         ; Número de líneas a desplazar, 0 para borrar la pantalla
    mov bh, 07h       ; Atributo de color (07h es texto blanco sobre fondo negro)
    mov cx, 0         ; Esquina superior izquierda de la ventana (fila y columna)
    mov dx, 184Fh     ; Esquina inferior derecha de la ventana (fila 24, columna 79 para 80x25)
    int 10h           ; Llamada a la interrupción de la BIOS para video
    
    
    mov ah, 02h ; posicion cursor
    mov bh, 00h
    mov dh, 00h ; fila
    mov dl, 00h ; columna
    int 10h  
    
    mov n_fila, 31h    
    lea dx, juego
    mov ah, 09h
    int 21h
    
    
    lea dx, condicion
    mov ah, 09h
    int 21h
    
    mov ah, 01h
    int 21h 
    
    lea dx, mensaje_cargando 
    mov ah, 09h
    int 21h
    
    lea dx, barcos
    mov ah, 09h
    int 21h

    ; Llamar a la subrutina para seleccionar aleatoriamente un mapa_en_juego
    call seleccionar_navio_aleatorio 
    jmp logica
        
    tabla:
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
        lea di, celdas_no_atacadas
        mov cl, n_celdas_no_atacadas   ; número de elementos en navios
        
    navio_loop:
        cmp dx, [di]
        je encontrado
        add di, 2
        loop navio_loop
        
        ; no encontrado en navios
        mov [si], -224
        jmp siguiente
    
    encontrado: ; la posición del navio encontrado en el tablero
        mov [si], '1'
        
    siguiente:  ; si no encuentra, sigue a otro
        pop di
        add di, 2
        inc si
        pop cx
        loop columna_loop
        
        pop cx
        loop fila_loop       
        
        
        mov guardar_a, ax
        mov guardar_b, bx
        mov guardar_c, cx
        mov guardar_d, dx
        
        
        mov ah, 06h       ; Función de desplazamiento de ventana hacia arriba
        mov al, 0         ; Número de líneas a desplazar, 0 para borrar la pantalla
        mov bh, 07h       ; Atributo de color (07h es texto blanco sobre fondo negro)
        mov cx, 0         ; Esquina superior izquierda de la ventana (fila y columna)
        mov dx, 184Fh     ; Esquina inferior derecha de la ventana (fila 24, columna 79 para 80x25)
        int 10h           ; Llamada a la interrupción de la BIOS para video
        
        
        mov ax, guardar_a
        mov bx, guardar_b
        mov cx, guardar_c
        mov dx, guardar_d
        
        
        mov ah, 02h ; posicion cursor
        mov bh, 00h
        mov dh, 00h ; fila
        mov dl, 00h ; columna
        int 10h
        
        
        lea dx, encabezado_col
        mov ah, 09h
        int 21h
        
        lea si, mapa_print
        mov cx, 6 
    
    imprimir_fila_loop:; imprime la enumeracion de la fila        
        mov dh, n_fila
        mov dl, dh        
        mov ah, 02h
        int 21h
        
        inc n_fila
    
        push cx
        mov cx, 6 
        
        mov dl, 02h ; columna
        
    imprimir_columna_loop: ; imprime los valores de la tabla en cada fila
    
        mov guardar_b, bx
        mov guardar_c, cx
        
        mov ah, 02h ; posicion cursor
        mov bh, 00h
        mov dh, n_fila ; fila
        sub dh, 30h
        int 10h
        
        mov al, [si]
        cmp al, '1'
        jnz imp
        
        pintar:
        mov bl, 4Fh ; color
        
        imp:   
        mov ah, 09h ; caracter y atributo
        mov bh, 00h 
        
        mov cx, 1   ; veces de escribir
        int 10h
        
        mov bx, guardar_b 
        mov cx, guardar_c 
        
        
        add dl, 2
        inc si
        loop imprimir_columna_loop
    
        lea dx, newline
        mov ah, 09h
        int 21h
    
        pop cx
        loop imprimir_fila_loop
    
        jmp exit
        
    
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
      
    ; VALIDACIONES SI SE ESCOGIO DE MANERA ALEATORIA ALGUN MAPA
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
        lea di, mapa_en_juego; direcciona el mapa en juego
        mov cx, 11  
        
    ; Copiar el arreglo seleccionado a mapa_en_juego   
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
    
    ; imprime el modelo del mapa del juego
    lea dx, encabezado_col_1
    mov ah, 09h
    int 21h  
    
    lea dx, f1
    mov ah, 09h
    int 21h
    
    lea dx, f2
    mov ah, 09h
    int 21h 
    
    lea dx, f3
    mov ah, 09h
    int 21h
    
    lea dx, f4
    mov ah, 09h
    int 21h 
    
    lea dx, f5
    mov ah, 09h
    int 21h
    
    lea dx, f6
    mov ah, 09h
    int 21h
    
    mov n_fila, 31h
   
    mov bx, 00000h
    mov cx, 00000h
    mov dx, 00000h
    mov ch, 1   ; inicializamos el numero de intento 

    ; Mostrar el mensaje     
    ingreso:
        mov cl, 00h
        lea dx, msg_misil   ;Imprime la palabra Misil
        mov ah, 09h
        int 21h
        mov ah, 00h         ;Mueve el numero de misil actual al registro para imprimirlo
        mov al, ch
        
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
       
        pedir_columna:
        ; Lee la columna ingresada por el usuario
        mov ah, 01h
        int 21h 
        
        cmp al, 08h
        jnz  verficaciones_columna
        
        devolver_carro_columna:
        mov dl, 20h
        mov ah, 02h
        int 21h
        jmp pedir_columna
        
        verficaciones_columna:
        ; verificar ctrl+e
        cmp al, 05h
        jz fin  
        
        ; verificar enter
        cmp al, 0Dh
        jz incorrecto_enter
        
        mov columna, al
        
        pedir_fila:
        ; Lee la fila ingresada
        mov ah, 01h
        int 21h
        
        ; verificar backspace
        cmp al, 08h
        jnz  verficaciones_fila
        
        devolver_carro_fila:
        mov dl, 20h
        mov ah, 02h
        int 21h
        mov dl, 08h
        int 21h
        jmp pedir_columna
        
        verficaciones_fila:
        ; verificar ctrl+e
        cmp al, 05h
        jz fin  
        
        ; verificar enter
        cmp al, 0Dh
        jz incorrecto_enter 
        
        mov fila, al
        
        
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
        
    incorrecto_enter:
        lea dx, msg_incorrecto_enter
        mov ah, 09h
        int 21h
        jmp ingreso   
        
        
    correcto:
        lea dx, msg_separador 
        mov ah, 09h
        int 21h
        
        mov dx, 00000h
        mov dh, columna
        add dl, fila
        mov celda_ingresada, dx        ; obtener el valor total de la celda

    verificar_ataque:
        mov si, offset mapa_en_juego     ; inicializar indice para recorrer el array de navios
        mov di, offset celdas_atacadas  ; inicializar indice para recorrer el array de ataques
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
       
    verif_hundido_submarino:
        mov di, offset celdas_atacadas
        mov barco_size, 3
        mov bl, barco_size
        cmp is_submarino_vivo, 01h
        jnz verif_hundido_destructor
    
    verif_celdas_submarino:
        cmp [di], 01h 
        jnz verif_hundido_destructor
        inc di
        dec bl
        cmp bl, 00h            
        jnz verif_celdas_submarino
        
        mov is_submarino_vivo, bl
        lea dx, msg_submarino
        mov ah, 09h
        int 21h 
        
        jmp verif_victoria_1
        
        
     verif_hundido_destructor:
        mov di, offset celdas_atacadas 
        mov barco_size, 3
        mov bl, barco_size
        add di, 3
        cmp is_destructor_vivo, 01h
        jnz verif_hundido_portaviones
     
     verif_celdas_destructor:
        cmp [di], 01h 
        jnz verif_hundido_portaviones
        inc di
        dec bl
        cmp bl, 00h
        jnz verif_celdas_destructor
        
        mov is_destructor_vivo, 00h
        lea dx, msg_destructor
        mov ah, 09h
        int 21h
        
        jmp verif_victoria_1
         
        
    verif_hundido_portaviones:
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
        cmp is_submarino_vivo, 00h
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
        jmp exit     
    
    derrota:
        lea dx, msg_derrota
        mov ah, 09h
        int 21h
        
        mov dx,0
        mov si, offset mapa_en_juego     ; inicializar indice para recorrer el array de navios
        mov di, offset celdas_atacadas  ; inicializar indice para recorrer el array de ataques
        mov bh, mapa_size 
    
    comparar_2: 
    
        cmp bh, 00h
        jz llenar_lista  
        dec bh
        
        mov ax, [si]
        cmp [di], 0
        
        jnz control_indices_2
        push [si] 
        add dx, 1       
    
    control_indices_2:
        mov [di], 0
        add si,2
        inc di
        jmp comparar_2  
    
    llenar_lista: 
        mov si, offset celdas_no_atacadas     ; inicializar indice para recorrer el array    
        mov dh, 0
        
    lup:
        cmp dl, 00h
        jz siguiente_2  
        dec dl
        inc dh
        mov n_celdas_no_atacadas, dh
        
        pop bx
        mov [si], bx
        add si,2
        jmp lup    
    
    ;comienza a imprimir el mapa con los barcos que faltaron atacar 
    siguiente_2: 
        lea dx, msg_cargando_faltantes 
        mov ah, 09h
        int 21h
    
        
        ; imprimir mapa_print
        lea si, mapa_print
        mov cx, 6 
        
         
        call tabla   
        call fila_loop
        call columna_loop
        call navio_loop
        call imprimir_fila_loop 
        call imprimir_columna_loop 
            
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
        jnz  verif_hundido_submarino
        
        
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
        
    incorrecto_enter_2:
        lea dx, msg_incorrecto_enter
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
        
        ; verificar ctrl+e
        cmp al, 05h
        jz fin  
        
        ; verificar enter
        cmp al, 0Dh
        jz incorrecto_enter_2
        
        cmp al, 30h
        jb incorrecto_2
        cmp al, 31h
        ja incorrecto_2
        
        mov intentar, al
        
        mov ax, @data
        mov ds, ax
        mov es, ax   
        
        cmp intentar, 30h 
        jnz start
        
    fin:
        lea dx, msg_gracias
        mov ah, 09h
        int 21h  
        
        mov ax, 4C00h
        int 21h
        
main endp