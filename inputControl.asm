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
    mov ch, 1

    ; Mostrar el mensaje     
    ingreso:
        lea dx, msg_misil
        mov ah, 09h
        int 21h 
        
        mov dl, ch
        add dl, 030h
        mov ah, 02h
        int 21h 
        
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
        
        
    correcto:
        mov dx, 00000h
        mov dh, columna
        add dl, fila
        mov celda_ingresada, dx        ; obtener el valor total de la celda
;        lea dx, msg_correcto
;        mov ah, 09h
;        int 21h              ; mostrar mensaje de correcto
        jmp verificar_ataque
    
    incorrecto:
        lea dx, msg_incorrecto
        mov ah, 09h
        int 21h
        jmp ingreso     
    
    verificar_ataque:
        mov si, offset mapa_prueba
        mov di, offset ataques_prueba
        mov bh, mapa_size 
    
    comparar: 
        cmp bh, 00h
        jz rechazar_ataque  
        
        mov ax, [si]
        
        cmp [si], dx
        dec bh
        jz verif
        jnz control_indices
        
        jmp rechazar_ataque    
    
    control_indices:
        inc si
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
        cmp barco_1, 1
        jnz pre_verif_barcos_2
    
    lup_1:
        cmp [di], 01h 
        jnz pre_verif_barcos_2
        inc di
        dec bl
        cmp bl, 00h
        jnz lup_1
        
        lea dx, msg_submarino
        mov ah, 09h
        int 21h
        cmp ch, 18
        jnz ingreso
        jz derrota
        
     pre_verif_barcos_2:
        mov di, offset ataques_prueba 
        mov barco_size, 3
        mov bl, barco_size
        add di, 3
        cmp barco_2, 1
        jnz pre_verif_barcos_3
     
     lup_2:
        cmp [di], 01h 
        jnz pre_verif_barcos_3
        inc di
        dec bl
        cmp bl, 00h
        jnz lup_2
        
        lea dx, msg_destructor
        mov ah, 09h
        int 21h
        cmp ch, 18
        jnz ingreso
        jz derrota 
        
    pre_verif_barcos_3:
        mov di, offset ataques_prueba 
        mov barco_size, 5
        add di, 6
        cmp barco_3, 01h
        jnz victoria 
        
    lup_3:
        cmp [di], 01h 
        jnz ingreso
        inc di
        dec bl
        cmp bl, 00h
        jnz lup_3
        
        lea dx, msg_portaviones
        mov ah, 09h
        int 21h
        cmp ch, 18
        jnz ingreso
        jz derrota     
        
    victoria:
        lea dx, msg_victoria
        mov ah, 09h
        int 21h     
    
    derrota:
        lea dx, msg_derrota
        mov ah, 09h
        int 21h 
    
    fin:
                   
        
    rechazar_ataque:
        inc ch
        lea dx, msg_ataque_fallido
        mov ah, 09h
        int 21h
        jmp ingreso        
              
    confirmar_ataque:
        inc ch
        lea dx, msg_ataque_confirmado
        mov ah, 09h
        int 21h
        jmp ingreso
        
        
    omitir_ataque:
        lea dx, msg_ataque_repetido
        mov ah, 09h
        int 21h
        jmp ingreso
    
    exit: