.model small
.stack 100h
.data
msg_misil db 0Dh, 0Ah,'Misil $'
msg_misil_2 db ', ingrese la celda a atacar: $'      
msg_incorrecto db 0Dh, 0Ah, 'Ingrese una celda valida (Columna A-F y Fila 1-6)$'
msg_victoria db 0Dh, 0Ah,'Ganaste!$'
msg_derrota db 0Dh, 0Ah,'Mejor suerte para la proxima!$'
msg_ataque_confirmado db '..........Impacto confirmado$'
msg_ataque_fallido db '..........Sin impacto$'
msg_submarino db ';Submarino hundido$'  
msg_destructor db ';Destructor hundido$'
msg_portaviones db ';Portaviones hundido$'
msg_ataque_repetido db '..........Ya impactado, intente de nuevo$'
fila db ?
columna db ? 
celda_ingresada dw ?
mapa_prueba dw 04131h,04132h,04133h, 04134h,04135h,04136h, 04231h,04232h,04233h,04234h,04235h
ataques_prueba db 0,0,0,0,0,0,0,0,0,0,0 
mapa_size db 11
barco_1 db 1 
barco_2 db 1 
barco_3 db 1
barco_size db ? 
num dw 0

.code
main proc
    mov ax, @data
    mov ds, ax
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
        mov si, offset mapa_prueba     ; inicializar indice para recorrer el array de navios
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
        jmp exit     
    
    derrota:
        lea dx, msg_derrota
        mov ah, 09h
        int 21h
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
          
    
    
    exit: