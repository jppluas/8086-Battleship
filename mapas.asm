.model small
.stack 100h
.data  
n_casillas db 36
mapa_alea_1 db 10,20,30,40,50,60,70,80,90,1,11
mapa_alea_2 db 10,20,30,40,50,60,70,80,90,1,11
mapa_alea_3 db 10,20,30,40,50,60,70,80,90,1,11 
mapa_alea_4 db 10,20,30,40,50,60,70,80,90,1,11
mapa_4  db 1,1,1,0,0,0
        db 0,0,0,0,0,0
        db 1,1,1,1,1,0
        db 1,0,0,0,0,0
        db 1,0,0,0,0,0
        db 1,0,0,0,0,0
         
mapa_alea_5 db 10,20,30,40,50,60,70,80,90,1,11   
mapa_alea_6 db 10,20,30,40,50,60,70,80,90,1,11 
mapa_alea_7 db 10,20,30,40,50,60,70,80,90,1,11

mapa_elegido db 11 dup(?)
mapa_en_juego db 6 dup(?) db 6 dup(?) db 6 dup(?) db 6 dup(?) db 6 dup(?) db 6 dup(?)   

salto_linea db 0AH, 0DH, '$'
alea db 4

.code
     
mov cl, 11
mov ch, 1
mov bl, alea
cmp bl, 4
jz es_4         
    
es_4:       
    ;copiar el array mapa_alea_4 en mapa_elegido
     
    mov di, offset mapa_elegido
    mov si, offset mapa_alea_4
    jmp lup     
    
lup:
    mov al, [si]
    mov [di], al
    mov ah, [di]
    inc si
    inc di
    dec cl
    cmp cl, 0
    jz paso_2
    jnz lup

paso_2:
    inc ch
    cmp ch, 2
    jz  es_4_2
    jnz sgt

es_4_2:       
    ;copiar el array mapa_4 en mapa_en_juego
    mov cl, 36 
    mov di, offset mapa_en_juego
    mov si, offset mapa_4
    jmp lup
    

sgt:     
    mov si, offset mapa_en_juego
    mov ch, 36
    mov cl, 6
    jmp imprimir
     
imprimir:
    ;imprimir mapa en juego      
    mov dl, [si]
    inc si
    add dl, 030h    
    mov ah, 02h
    int 21h
    dec ch
    mov ax, 0000h
    mov al, ch
    div cl
    cmp ah, 0
    jz salto_de_linea
    jnz imprimir
    
    
salto_de_linea:
    mov ah, 09h
    lea dx, salto_linea
    int 21h    
    cmp ch, 0
    jz exit
    jnz imprimir
                
exit:
