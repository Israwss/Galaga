title "Proyecto: Galaga" ;codigo opcional. Descripcion breve del programa, el texto entrecomillado se imprime como cabecera en cada página de código
   .model small   ;directiva de modelo de memoria, small => 64KB para memoria de programa y 64KB para memoria de datos
   .386        ;directiva para indicar version del procesador
   .stack 128     ;Define el tamano del segmento de stack, se mide en bytes
   .data       ;Definicion del segmento de datos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Definición de constantes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Valor ASCII de caracteres para el marco del programa
marcoEsqInfIzq       equ   200d  ;'╚'
marcoEsqInfDer       equ   188d  ;'╝'
marcoEsqSupDer       equ   187d  ;'╗'
marcoEsqSupIzq       equ   201d  ;'╔'
marcoCruceVerSup  equ      203d  ;'╦'
marcoCruceHorDer  equ   185d  ;'╣'
marcoCruceVerInf  equ      202d  ;'╩'
marcoCruceHorIzq  equ   204d  ;'╠'
marcoCruce        equ      206d  ;'╬'
marcoHor          equ   205d  ;'═'
marcoVer          equ   186d  ;'║'
;Atributos de color de BIOS
;Valores de color para carácter
cNegro         equ      00h
cAzul          equ      01h
cVerde         equ   02h
cCyan          equ   03h
cRojo          equ   04h
cMagenta       equ      05h
cCafe          equ   06h
cGrisClaro     equ      07h
cGrisOscuro    equ      08h
cAzulClaro     equ      09h
cVerdeClaro    equ      0Ah
cCyanClaro     equ      0Bh
cRojoClaro     equ      0Ch
cMagentaClaro  equ      0Dh
cAmarillo      equ      0Eh
cBlanco     equ      0Fh
;Valores de color para fondo de carácter
bgNegro     equ      00h
bgAzul         equ      10h
bgVerde     equ   20h
bgCyan         equ   30h
bgRojo         equ   40h
bgMagenta      equ      50h
bgCafe         equ   60h
bgGrisClaro    equ      70h
bgGrisOscuro   equ      80h
bgAzulClaro    equ      90h
bgVerdeClaro   equ      0A0h
bgCyanClaro    equ      0B0h
bgRojoClaro    equ      0C0h
bgMagentaClaro equ      0D0h
bgAmarillo     equ      0E0h
bgBlanco       equ      0F0h
;Valores para delimitar el área de juego
lim_superior   equ      1
lim_inferior   equ      23
lim_izquierdo  equ      1
lim_derecho    equ      39
;Valores de referencia para la posición inicial del jugador
ini_columna    equ   lim_derecho/2
ini_renglon    equ   22

;Valores para la posición de los controles e indicadores dentro del juego
;Lives
lives_col      equ   lim_derecho+7
lives_ren      equ   4

;Scores
hiscore_ren    equ   11
hiscore_col    equ   lim_derecho+7
score_ren      equ   13
score_col      equ   lim_derecho+7

;Botón STOP
stop_col       equ   lim_derecho+10
stop_ren       equ   19
stop_izq       equ   stop_col-1
stop_der       equ   stop_col+1
stop_sup       equ   stop_ren-1
stop_inf       equ   stop_ren+1

;Botón PAUSE
pause_col      equ   stop_col+10
pause_ren      equ   19
pause_izq      equ   pause_col-1
pause_der      equ   pause_col+1
pause_sup      equ   pause_ren-1
pause_inf      equ   pause_ren+1

;Botón PLAY
play_col       equ   pause_col+10
play_ren       equ   19
play_izq       equ   play_col-1
play_der       equ   play_col+1
play_sup       equ   play_ren-1
play_inf       equ   play_ren+1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;////////////////////////////////////////////////////
;Definición de variables
;////////////////////////////////////////////////////
titulo         db       "GALAGA"
scoreStr       db       "SCORE"
hiscoreStr     db       "HI-SCORE"
livesStr    db       "LIVES"
blank       db       "     "
;////////////////////////////////////////////////////
;JUGADOR
player_lives   db       3
player_score   dw       0
player_hiscore    dw       0

player_col     db       ini_columna    ;posicion en columna del jugador
player_ren     db       ini_renglon    ;posicion en renglon del jugador

bandera_jugador db      1       ;se mueve 1, no se mueve 0

;Bala jugador
balaJ_col       db      0       ;columna de la bala
balaJ_ren       db      0       ;renglon de la bala
balaJ_run       db      1       ;velocidad de la bala

;BALAS JUGADOR---------------------------------------ANEXO
;----------------------------------------------------------LASER JUGADOR (1)
bolaJ_col_1		db              0d		;Iniciamos por defecto
bolaJ_ren_1             db		0d 		;Iniciamos por defecto
bolaJ_activa_1		db		1h		;0 ->Inactiva(no puede disparar esa bala) | 1 -> Activa(puede dispararse)

;----------------------------------------------------------LASER JUGADOR (2)
bolaJ_col_2		db              0d		;Iniciamos por defecto
bolaJ_ren_2             db		0d 		;Iniciamos por defecto
bolaJ_activa_2		db		1h		;0 ->Inactiva(no puede disparar esa bala) | 1 -> Activa(puede dispararse)

;----------------------------------------------------------LASER JUGADOR (2)
bolaJ_col_3		db              0d		;Iniciamos por defecto
bolaJ_ren_3             db		0d 		;Iniciamos por defecto
bolaJ_activa_3		db		1h		;0 ->Inactiva(no puede disparar esa bala) | 1 -> Activa(puede dispararse)


;////////////////////////////////////////////////////

;////////////////////////////////////////////////////
;ENEMIGO
enemy_col      db       ini_columna    ;posicion en columna del enemigo
enemy_ren      db       3           ;posicion en renglon del enemigo

;Bala enemiga
balaE_col       db      0       ;columna de la bala
balaE_ren       db      0       ;renglon de la bala
balaE_run       db      1       ;velocidad de la bala
coorBala_col    db      0       ;valiable auxiliar
coorBala_ren    db      0       ;variable auxiliar
bandera_bala    db      0       ;bala libre 0 bala activa 1
bandE           db      2       ;1 a la derecha. 0 a la izquierda

;BALA ENEMIGA--------------------------
;----------------------------------------------------------LASER
bola_col		db 		ini_columna 	;columna de la bala
bola_ren		db 		ini_renglon-3 	;renglón de la bala

bolaE_col               db              ini_columna 	 ;columna bala enemiga
bolaE_ren               db              ini_renglon-16   ;renglón bala enemiga


;NIVEL DE DIFICULTAD-------------------------------------------
dificultad    dw         2d

;////////////////////////////////////////////////////

;Variables para la implementación de ventanas
gameover        db      "GAME OVER"
mensaje1        db      "CLIC EN EL"
mensaje2        db      "BOT",0E0h,"N"
mensaje3        db      "PLAY ",16d
bandTexto       db       0 ;0 texto de inicio. 1 texo game over
mensaje4        db      "CLIC EN"
continuar       db      "Continuar"
cadenaSI        db      "SI"
cadenaNO        db      "NO"
pregunta        db      0A8h,"Quieres reiniciar el juego?"
bandPause       db       0 ;0 el jugo no esta en pausa. 1 el juego esta en pausa
bandStop        db       0 ;0 el juego tiene la ventana con los botones stop, pause y play. 1 ventana SI y NO
bandContinuar   db       0 ;0 el juego tiene la ventana con los botones stop, pause y play. 1 ventana Continuar
bandInicio      db       0 ;1 corriendo juego. 0 no se corre el juego
bandInicio2     db       0 ;0 si imprime las naves por primera vez, y se borra la ventana del area de juego. 1 pasa directo a los movimientos

;Variable auxiliares
col_aux     db       0        ;variable auxiliar para operaciones con posicion - columna
ren_aux     db       0     ;variable auxiliar para operaciones con posicion - renglon

conta          db       0     ;contador

;; Variables de ayuda para lectura de tiempo del sistema
tick_ms        dw       55       ;55 ms por cada tick del sistema, esta variable se usa para operación de MUL convertir ticks a segundos
mil            dw    1000  ;1000 auxiliar para operación DIV entre 1000
diez        dw       10       ;10 auxiliar para operaciones
sesenta        db       60       ;60 auxiliar para operaciones
status         db       0     ;0 stop, 1 play, 2 pause
ticks          dw    0     ;Variable para almacenar el número de ticks del sistema y usarlo como referencia

;Variables que sirven de parámetros de entrada para el procedimiento IMPRIME_BOTON
boton_caracter    db       0
boton_renglon  db       0
boton_columna  db       0
boton_color    db       0
boton_bg_color db       0


;Auxiliar para calculo de coordenadas del mouse en modo Texto
ocho        db       8
;Cuando el driver del mouse no está disponible
no_mouse    db    'No se encuentra driver de mouse. Presione [enter] para salir$'

;////////////////////////////////////////////////////
;Sonido
DISPARO_S dw 0AAAh
HitE_S dw 0FFh
Hit_S dw 0AFFFh
DisparoE_S dw 0AAAh
;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;Macros;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;
;clear - Limpia pantalla
clear macro
   mov ax,0003h   ;ah = 00h, selecciona modo video
               ;al = 03h. Modo texto, 16 colores
   int 10h     ;llama interrupcion 10h con opcion 00h. 
            ;Establece modo de video limpiando pantalla
endm

;posiciona_cursor - Cambia la posición del cursor a la especificada con 'renglon' y 'columna' 
posiciona_cursor macro renglon,columna
   mov dh,renglon ;dh = renglon
   mov dl,columna ;dl = columna
   mov bx,0
   mov ax,0200h   ;preparar ax para interrupcion, opcion 02h
   int 10h     ;interrupcion 10h y opcion 02h. Cambia posicion del cursor
endm 

;inicializa_ds_es - Inicializa el valor del registro DS y ES
inicializa_ds_es  macro
   mov ax,@data
   mov ds,ax
   mov es,ax      ;Este registro se va a usar, junto con BP, para imprimir cadenas utilizando interrupción 10h
endm

;muestra_cursor_mouse - Establece la visibilidad del cursor del mouser
muestra_cursor_mouse macro
   mov ax,1    ;opcion 0001h
   int 33h        ;int 33h para manejo del mouse. Opcion AX=0001h
               ;Habilita la visibilidad del cursor del mouse en el programa
endm

;posiciona_cursor_mouse - Establece la posición inicial del cursor del mouse
posiciona_cursor_mouse  macro columna,renglon
   mov dx,renglon
   mov cx,columna
   mov ax,4    ;opcion 0004h
   int 33h        ;int 33h para manejo del mouse. Opcion AX=0001h
               ;Habilita la visibilidad del cursor del mouse en el programa
endm

;oculta_cursor_teclado - Oculta la visibilidad del cursor del teclado
oculta_cursor_teclado   macro
   mov ah,01h     ;Opcion 01h
   mov cx,2607h   ;Parametro necesario para ocultar cursor
   int 10h     ;int 10, opcion 01h. Cambia la visibilidad del cursor del teclado
endm

;apaga_cursor_parpadeo - Deshabilita el parpadeo del cursor cuando se imprimen caracteres con fondo de color
;Habilita 16 colores de fondo
apaga_cursor_parpadeo   macro
   mov ax,1003h      ;Opcion 1003h
   xor bl,bl         ;BL = 0, parámetro para int 10h opción 1003h
   int 10h        ;int 10, opcion 01h. Cambia la visibilidad del cursor del teclado
endm

;imprime_caracter_color - Imprime un caracter de cierto color en pantalla, especificado por 'caracter', 'color' y 'bg_color'. 
;Los colores disponibles están en la lista a continuacion;
; Colores:
; 0h: Negro
; 1h: Azul
; 2h: Verde
; 3h: Cyan
; 4h: Rojo
; 5h: Magenta
; 6h: Cafe
; 7h: Gris Claro
; 8h: Gris Oscuro
; 9h: Azul Claro
; Ah: Verde Claro
; Bh: Cyan Claro
; Ch: Rojo Claro
; Dh: Magenta Claro
; Eh: Amarillo
; Fh: Blanco
; utiliza int 10h opcion 09h
; 'caracter' - caracter que se va a imprimir
; 'color' - color que tomará el caracter
; 'bg_color' - color de fondo para el carácter en la celda
; Cuando se define el color del carácter, éste se hace en el registro BL:
; La parte baja de BL (los 4 bits menos significativos) define el color del carácter
; La parte alta de BL (los 4 bits más significativos) define el color de fondo "background" del carácter
imprime_caracter_color macro caracter,color,bg_color
   mov ah,09h           ;preparar AH para interrupcion, opcion 09h
   mov al,caracter      ;AL = caracter a imprimir
   mov bh,0          ;BH = numero de pagina
   mov bl,color         
   or bl,bg_color          ;BL = color del caracter
                     ;'color' define los 4 bits menos significativos 
                     ;'bg_color' define los 4 bits más significativos 
   mov cx,1          ;CX = numero de veces que se imprime el caracter
                     ;CX es un argumento necesario para opcion 09h de int 10h
   int 10h           ;int 10h, AH=09h, imprime el caracter en AL con el color BL
endm

;imprime_caracter_color - Imprime un caracter de cierto color en pantalla, especificado por 'caracter', 'color' y 'bg_color'. 
; utiliza int 10h opcion 09h
; 'cadena' - nombre de la cadena en memoria que se va a imprimir
; 'long_cadena' - longitud (en caracteres) de la cadena a imprimir
; 'color' - color que tomarán los caracteres de la cadena
; 'bg_color' - color de fondo para los caracteres en la cadena
imprime_cadena_color macro cadena,long_cadena,color,bg_color
   mov ah,13h           ;preparar AH para interrupcion, opcion 13h
   lea bp,cadena        ;BP como apuntador a la cadena a imprimir
   mov bh,0          ;BH = numero de pagina
   mov bl,color         
   or bl,bg_color          ;BL = color del caracter
                     ;'color' define los 4 bits menos significativos 
                     ;'bg_color' define los 4 bits más significativos 
   mov cx,long_cadena      ;CX = longitud de la cadena, se tomarán este número de localidades a partir del apuntador a la cadena
   int 10h           ;int 10h, AH=09h, imprime el caracter en AL con el color BL
endm

;lee_mouse - Revisa el estado del mouse
;Devuelve:
;;BX - estado de los botones
;;;Si BX = 0000h, ningun boton presionado
;;;Si BX = 0001h, boton izquierdo presionado
;;;Si BX = 0002h, boton derecho presionado
;;;Si BX = 0003h, boton izquierdo y derecho presionados
; (400,120) => 80x25 =>Columna: 400 x 80 / 640 = 50; Renglon: (120 x 25 / 200) = 15 => 50,15
;;CX - columna en la que se encuentra el mouse en resolucion 640x200 (columnas x renglones)
;;DX - renglon en el que se encuentra el mouse en resolucion 640x200 (columnas x renglones)
lee_mouse   macro
   mov ax,0003h
   int 33h
endm

;comprueba_mouse - Revisa si el driver del mouse existe
comprueba_mouse   macro
   mov ax,0    ;opcion 0
   int 33h        ;llama interrupcion 33h para manejo del mouse, devuelve un valor en AX
               ;Si AX = 0000h, no existe el driver. Si AX = FFFFh, existe driver
endm

entrada_teclado   macro ;para entradas del teclado 
   mov ah,01h  ;opcion 01, modifica bandera Z, si Z = 1, no hay datos en buffer de teclado. Si Z = 0, hay datos en el buffer de teclado
   int 16h     ;interrupcion 16h (maneja la entrada del teclado)
endm

vacia_teclado  macro ;para vaciar el teclado
   mov ah,00h  
   int 16h
endm
;----------------------------------------------------------------------------------------------
;                           MACROINSTRUCCIONES DE SONIDO
;----------------------------------------------------------------------------------------------
tone macro nota
    PUSHA     
    MOV CX,0
    MOV DX,0FFFFh          
    MOV AL, 182 ; 2) Configura la escritura en el registro de palabras de control.
    OUT 43h, AL ; 2) Realiza la escritura.
    MOV AX, nota ;2) Nota que se va a reproducir.
    OUT 42h, AL ; 2) Envia el byte inferior de la frecuencia.
    MOV AL, AH ; 2) Carga el byte superior de la frecuencia.
    OUT 42h, AL ; 2) Envia el byte superior.
    IN AL, 61h ; 3) Lee el estado actual del controlador del teclado.
    OR AL, 03h ; 3) Activa 0 y 1 bit, habilitando la puerta del altavoz de la PC y la transferencia de datos.
    OUT 61h, AL; 3) Guarda el nuevo estado del controlador del teclado.
    MOV AH, 86h; 4) Carga la BIOS en ESPERA, función int15h AH=86h.
    INT 15h; 4) Interrumpe inmediatamente. El retraso ya está en CX:DX (Tiempo de ejecución).
    IN AL, 61h ; 5) Lee el estado actual del controlador del teclado.
    AND AL, 0FCh ; 5) Cero 0 y 1 bit, deshabilitando la puerta.
    OUT 61h, AL; 5) Escribe el nuevo estado del controlador del teclado.
    POPA ; Saca a todos los registros de la pila
    endm
;----------------------------------------------------------------------------------------------
;                           MACROINSTRUCCIONES DE COLICIONES
;----------------------------------------------------------------------------------------------

dir_caracter macro   ;macro para obtener el caracacter en la posición del cursor
   posiciona_cursor ren_aux,col_aux 
   MOV AH,08H
   MOV BH,00
   INT 10H          ;Al =  caracter y AH = atributo = color
   push ax
endm

guarda_posicionE macro  ;macro para pasar las coordenadas del enemigo a las variables col_aux y ren_aux 
    mov al,enemy_col
    mov ah,enemy_ren
    mov [col_aux],al
    mov [ren_aux],ah
endm

guarda_posicionj macro   ;macro para pasar las coordenadas del jugador a las variables col_aux y ren_aux 
    mov al,[player_col]
    mov ah,[player_ren]
    mov [col_aux],al
    mov [ren_aux],ah
endm

;-----------------------------------------------------------------------------------------ANEXADO
guarda_posicionLaserJ_3 macro  ;macro para pasar las coordenadas del laser enemigo a las variables col_aux y ren_aux 
    mov al,bolaJ_col_3
    mov ah,bolaJ_ren_3
    mov [col_aux],al
    mov [ren_aux],ah
endm
;-----------------------------------------------------------------------------------------ANEXADO
guarda_posicionLaserJ_2 macro  ;macro para pasar las coordenadas del laser enemigo a las variables col_aux y ren_aux 
    mov al,bolaJ_col_2
    mov ah,bolaJ_ren_2
    mov [col_aux],al
    mov [ren_aux],ah
endm
;-----------------------------------------------------------------------------------------ANEXADO
guarda_posicionLaserJ_1 macro  ;macro para pasar las coordenadas del laser enemigo a las variables col_aux y ren_aux 
    mov al,bolaJ_col_1
    mov ah,bolaJ_ren_1
    mov [col_aux],al
    mov [ren_aux],ah
endm
;-----------------------------------------------------------------------------------------ANEXADO
guarda_posicionLaserE macro  ;macro para pasar las coordenadas del laser enemigo a las variables col_aux y ren_aux 
    mov al,bolaE_col 
    mov ah,bolaE_ren
    mov [col_aux],al
    mov [ren_aux],ah
endm
;------------------------------------------------------------------------------------------ANEXADO
colision_BALA macro 
    add ren_aux,1d 
    dir_caracter
    cmp al,219d
    je pierde_vida  ;pierde vida

   ; add col_aux,1d 
   ; dir_caracter
    ;cmp al,219d
   ; je pierde_vidaB   ;pierde vida

  ;  sub ren_aux,1d 
  ;  dir_caracter
  ;  cmp al,219d
  ;  je pierde_vidaB  ;pierde vid

   ; sub col_aux,1d 
   ; dir_caracter
    ;cmp al,219d
    ;je pierde_vidaB   ;pierde vida

endm
;-----------------------------------------------------------------------------------------------
colision_BALA_J1 macro 
    guarda_posicionLaserJ_1
    sub ren_aux,1d 
    dir_caracter
    cmp al,178d
    je pierde_vidaE1
endm
;-----------------------------------------------------
colision_BALA_J2 macro 
    guarda_posicionLaserJ_2
    sub ren_aux,1d 
    dir_caracter
    cmp al,178d
    je pierde_vidaE2
endm
;-----------------------------------------------------
colision_BALA_J3 macro 
    guarda_posicionLaserJ_3
    sub ren_aux,1d 
    dir_caracter
    cmp al,178d
    je pierde_vidaE3
endm
;-------------------------------------
;Colisión de la nave del enemigo
colision_derechaE macro 
;    [ ][ ][ ][ ][ ]-->
;       [ ][ ][ ]
;          [ ]
    add col_aux,3d 
    dir_caracter
    cmp al,219d
    je pierde_vida   ;pierde vida 

;    [ ][ ][ ][ ][ ]
;       [ ][ ][ ]-->
;          [ ]
    dec col_aux
    inc ren_aux
    dir_caracter
    cmp al,219d
    je pierde_vida   ;pierde vida 

;    [ ][ ][ ][ ][ ]
;       [ ][ ][ ]
;          [ ]-->
    dec col_aux
    inc ren_aux
    dir_caracter
    cmp al,219d
    je pierde_vida   ;pierde vida 
endm

colision_izquierdaE macro 
;resiva posición
 ; <--[ ][ ][ ][ ][ ]
 ;       [ ][ ][ ]
 ;          [ ]
    sub col_aux,3d
    dir_caracter
    cmp al,219d
    je pierde_vida   ;pierde vida 

 ;resiva posición
 ;    [ ][ ][ ][ ][ ]
 ;    <--[ ][ ][ ]
 ;          [ ]
    inc col_aux
    inc ren_aux
    dir_caracter
    cmp al,219d
    je pierde_vida   ;pierde vida 

 ;resiva posición
 ;    [ ][ ][ ][ ][ ]
 ;       [ ][ ][ ]
 ;       <--[ ]
    inc col_aux
    inc ren_aux
    dir_caracter
    cmp al,219d
    je pierde_vida   ;pierde vida 
endm

colision_abajoD macro 
;    [ ][ ][ ][ ][ ]-->
;       [ ][ ][ ]
;          [ ]
    add col_aux,3d 
    dir_caracter
    cmp al,219d
    je pierde_vida   ;pierde vida 

;    [ ][ ][ ][ ][ ]
;       [ ][ ][ ]-->
;          [ ]
    dec col_aux
    inc ren_aux
    dir_caracter
    cmp al,219d
    je pierde_vida   ;pierde vida 

;    [ ][ ][ ][ ][ ]
;       [ ][ ][ ]
;          [ ]-->
    dec col_aux
    inc ren_aux
    dir_caracter
    cmp al,219d
    je pierde_vida   ;pierde vida 
;    [ ][ ][ ][ ][ ]
;       [ ][ ][ ]
;          [ ]
;           |
;           v
    dec col_aux
    inc ren_aux
    dir_caracter
    cmp al,219d
    je pierde_vida   ;pierde vida 
endm

colision_abajoI macro 
;resiva posición
 ; <--[ ][ ][ ][ ][ ]
 ;       [ ][ ][ ]
 ;          [ ]
    sub col_aux,3d
    dir_caracter
    cmp al,219d
    je pierde_vida   ;pierde vida 

 ;resiva posición
 ;    [ ][ ][ ][ ][ ]
 ;    <--[ ][ ][ ]
 ;          [ ]
    inc col_aux
    inc ren_aux
    dir_caracter
    cmp al,219d
    je pierde_vida   ;pierde vida 

 ;resiva posición
 ;    [ ][ ][ ][ ][ ]
 ;       [ ][ ][ ]
 ;       <--[ ]
    inc col_aux
    inc ren_aux
    dir_caracter
    cmp al,219d
    je pierde_vida   ;pierde vida 
;    [ ][ ][ ][ ][ ]
;       [ ][ ][ ]
;          [ ]
;           |
;           v
    inc col_aux
    inc ren_aux
    dir_caracter
    cmp al,219d
    je pierde_vida   ;pierde vida 
endm


;Colisión de la nave del Jugador

colision_derecha macro  
 ;resiva posición
 ;          [ ]
 ;       [ ][ ][ ]
 ;    [ ][ ][ ][ ][ ]-->
    add col_aux,3d 
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 

 ;resiva posición
 ;          [ ]
 ;       [ ][ ][ ]-->
 ;    [ ][ ][ ][ ][ ]
    dec col_aux
    dec ren_aux
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 

 ;resiva posición
 ;          [ ]-->
 ;       [ ][ ][ ]
 ;    [ ][ ][ ][ ][ ]
    dec col_aux 
    dec ren_aux
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 
endm

colision_izquierda macro 
 ;resiva posición
 ;          [ ]
 ;       [ ][ ][ ]
 ; <--[ ][ ][ ][ ][ ]
    sub col_aux,3d
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 

 ;resiva posición
 ;          [ ]
 ;    <--[ ][ ][ ]
 ;    [ ][ ][ ][ ][ ]
    inc col_aux
    dec ren_aux
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 

 ;resiva posición
 ;       <--[ ]
 ;       [ ][ ][ ]
 ;    [ ][ ][ ][ ][ ]
    inc col_aux
    dec ren_aux
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 
endm


colision_arriba macro  
 ;resiva posición
 ;       ^
 ;       |
 ;      [ ]
 ;   [ ][ ][ ]
 ;[ ][ ][ ][ ][ ]
    sub ren_aux,3d ;pasa saber que hay arriba de la nave del jugador   
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 

 ;resiva posición
 ;    ^
 ;    | [ ]
 ;   [ ][ ][ ]
 ;[ ][ ][ ][ ][ ]
    dec col_aux 
    inc ren_aux
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 

 ;resiva posición
 ;    
 ; ^    [ ]
 ; | [ ][ ][ ]
 ;[ ][ ][ ][ ][ ]
    dec col_aux 
    inc ren_aux
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 

 ;resiva posición
 ;    
 ;      [ ]    ^
 ;   [ ][ ][ ] |
 ;[ ][ ][ ][ ][ ]
    add col_aux,4d 
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 

 ;resiva posición
 ;          ^
 ;      [ ] |  
 ;   [ ][ ][ ] 
 ;[ ][ ][ ][ ][ ]
    dec col_aux
    dec ren_aux 
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 
endm

colision_abajo macro 
    inc ren_aux ;pasa saber que hay abajo de la nave del jugador
  
  ;primero se revisa que hay abajo en esta posición 
  ;[ ][ ][ ][ ][ ]
  ;       |
  ;       v
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 

  ;posición a revisar
  ;[ ][ ][ ][ ][ ]
  ;          |
  ;          v
    inc col_aux 
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 

  ;posición a revisar
  ;[ ][ ][ ][ ][ ]
  ;             |
  ;             v
    inc col_aux
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 

  ;posición a revisar
  ;[ ][ ][ ][ ][ ]
  ;    |
  ;    v
    sub col_aux,3d
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 

  ;posición a revisar
  ;[ ][ ][ ][ ][ ]
  ; |
  ; v
    dec col_aux
    dir_caracter
    cmp al,178d
    je pierde_vida   ;pierde vida 
endm

;----------------------------------------------------------------------------------------------
;                           FIN DE MACROINSTRUCCIONES DE COLICIONES
;----------------------------------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;Fin Macros;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

   .code
inicio:              ;etiqueta inicio
   inicializa_ds_es
   comprueba_mouse      ;macro para revisar driver de mouse
   xor ax,0FFFFh     ;compara el valor de AX con FFFFh, si el resultado es zero, entonces existe el driver de mouse
   jz imprime_ui     ;Si existe el driver del mouse, entonces salta a 'imprime_ui'
   ;Si no existe el driver del mouse entonces se muestra un mensaje
   lea dx,[no_mouse]
   mov ax,0900h   ;opcion 9 para interrupcion 21h
   int 21h        ;interrupcion 21h. Imprime cadena.
   jmp teclado    ;salta a 'teclado'
imprime_ui:
   clear                ;limpia pantalla
   oculta_cursor_teclado   ;oculta cursor del mouse
   apaga_cursor_parpadeo   ;Deshabilita parpadeo del cursor
   call DIBUJA_UI          ;procedimiento que dibuja marco de la interfaz
   muestra_cursor_mouse    ;hace visible el cursor del mouse

;En "mouse_no_clic" se revisa que el boton izquierdo del mouse no esté presionado
;Si el botón está suelto, continúa a la sección "mouse"
;si no, se mantiene indefinidamente en "mouse_no_clic" hasta que se suelte
mouse_no_clic:
   vacia_bufer_teclado:     
   entrada_teclado          ;macro para leer el contenido del buffer de teclado
   jz continua_mouse        ;Si Z = 1, no hay datos en buffer de teclado 
   vacia_teclado
   entrada_teclado
   jnz vacia_bufer_teclado  ;Si Z = 0, hay datos en el buffer de teclado
    
   continua_mouse:
   xor bx,bx 
   lee_mouse
   test bx,0001h
   jnz mouse_no_clic
;Lee el mouse y avanza hasta que se haga clic en el boton izquierdo

mouse:
    jmp validacion
    mouse_1:
    lee_mouse
conversion_mouse:
   ;Leer la posicion del mouse y hacer la conversion a resolucion
   ;80x25 (columnas x renglones) en modo texto
   mov ax,dx         ;Copia DX en AX. DX es un valor entre 0 y 199 (renglon)
   div [ocho]        ;Division de 8 bits
                     ;divide el valor del renglon en resolucion 640x200 en donde se encuentra el mouse
                     ;para obtener el valor correspondiente en resolucion 80x25
   xor ah,ah         ;Descartar el residuo de la division anterior
   mov dx,ax         ;Copia AX en DX. AX es un valor entre 0 y 24 (renglon)

   mov ax,cx         ;Copia CX en AX. CX es un valor entre 0 y 639 (columna)
   div [ocho]        ;Division de 8 bits
                     ;divide el valor de la columna en resolucion 640x200 en donde se encuentra el mouse
                     ;para obtener el valor correspondiente en resolucion 80x25
   xor ah,ah         ;Descartar el residuo de la division anterior
   mov cx,ax         ;Copia AX en CX. AX es un valor entre 0 y 79 (columna)


   ;Aquí se revisa si se hizo clic en el botón izquierdo
   test bx,0001h     ;Para revisar si el boton izquierdo del mouse fue presionado
   jz mouse        ;Si el boton izquierdo no fue presionado, salta a valicacion para conocer el estado del juego: congelado o no congelado         

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Aqui va la lógica de la posicion del mouse;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Si el mouse fue presionado en el renglon 0
   ;se va a revisar si fue dentro del boton [X]
   cmp dx,0
   je boton_x

   cmp dx,19
   jge mas_botones

   jmp mouse_no_clic

;/////////////////////////////////////////////////////////////////////////////////
;Lógica para revisar si el mouse fue presionado en [X]

;Consideraciones:
;    - [X] se encuentra en renglon 0 y entre columnas 76 y 78
;    - En flujo del programa el boton [X] es el primero que se verifica si fue presionado
;    - De la etiqueta 'boton_x' salta hasta 'boton_x1'
;    - Si se cumplieron todas las condiciones, significa que el boton fue presionado y salta a la etiqueta 'salir'
boton_x:
   jmp boton_x1

;Lógica para revisar si el mouse fue presionado en [X]
;[X] se encuentra en renglon 0 y entre columnas 76 y 78
boton_x1:
   cmp cx,76
   jge boton_x2
   jmp mouse_no_clic
boton_x2:
   cmp cx,78
   jbe boton_x3
   jmp mouse_no_clic
boton_x3:
   ;Se cumplieron todas las condiciones
   jmp salir
;/////////////////////////////////////////////////////////////////////////////////


;/////////////////////////////////////////////////////////////////////////////////
;Lógica para revisar que botones tenemos activo
;Consideraciones:
;    - si bandStop=0 y bandContinuar=0 significa que esta activa la ventana con los botones [■] [‼] [►]
;    - si bandStop=1 significa que esta activa la ventana con los botones [NO] [SI]
;    - si bandInicio=1 siginica que apenas se va iniciar el juego por primera vez
;    - si bandContinuar=1 significa que esta activa la ventana con el boton [Continuar]

mas_botones: ;revisa si el clic es en el renglon es igual o menor a 21 
   cmp bandStop,1
   je ventanaSINO  ;ventana con los botones [NO] [SI]

   cmp dx,21
   jbe mainBotones   ;renglon igual o menor a 21 

   jmp mouse_no_clic ;mayor a 21, salta a 'mouse_no_clic' y de acuerdo al flujo del programa llega a 'validacion'

mainBotones:      ;si se cumplieron todas las condiciones para llegar a esta etiqueta Renglon:[19,21]
   cmp bandContinuar,1
   je ventanaContinuar ;ventana con el boton [continuar] que se muestra al perder todas la vidad (revisar etiqueta: pierde_vida)

   cmp bandInicio,0
   je opcion1        ;hasta que se de clic en play para iniciar el juego por primera vez 

   ;si bandStop=0 y bandContinuar=0 significa que estamos en la ventana con los botones [■] [‼] [►]
   ;|
   ;|  se sigue el flujo del programa sin ningun salto realizado
   ;v

;/////////////////////////////////////////////////////////////////////////////////
;Lógica para revisar si el stop fue presionado en [■]

;Consideraciones:
;    - [■] se encuentra entre los renglones 19 y 21, y entre columnas 49 y 51
;    - Si bandPause=1 condicionamos a que se detenga los movimientos del juego 
;    - Si bandStop=1 condicionamos a que salte a la etiqueta 'ventanaSINO' 
;    - En la etiqueta 'boton_stop' se verifica si se toco el boton Stop o Pause o Play
;    - El proposito del boton [■] es que despues de ser presionado se muestre una nueva ventana con los botones [NO] y [SI] 
;      para que el jugador decida si reiniciar todo el juego o no
   cmp cx,49
   jge boton_stop   ;mayor o igual a 49
   jmp mouse_no_clic ;menor a 49, salta a 'mouse_no_clic' y de acuerdo al flujo del programa llega a 'validacion'

   boton_stop:
   cmp cx,51
   jbe boton_stop1   ;menor o igual a 51. Columnas [48,51]
   jmp opcion2       ;mayor a 51. Sale del rango de columnas [48,51], por lo tanto debemos revisar los botones  [‼] [►]

   boton_stop1:         ;Si se llego aqui significa que se dio clic en el boton stop. Toca validar otros dos botones: [SI] y [NO]
   posiciona_cursor_mouse 320,100
   call BORRA_BOTONES   ;borra botones de stop, pause y play
   call PRINT_VENTANA2  ;Imprime una nueva ventana. Botones: SI y NO
   mov bandPause,1      ;congelar el juego
   mov bandStop,1       ;condicionamos a que simpre se revise la etiqueta 'ventanaSINO'
   jmp mouse_no_clic    ;salta a 'mouse_no_clic' y de acuerdo al flujo del programa llega a 'validacion'
;/////////////////////////////////////////////////////////////////////////////////


;/////////////////////////////////////////////////////////////////////////////////
;Lógica para revisar si el pause fue presionado en [‼]

;Consideraciones:
;    - [‼] se encuentra entre los renglones 19 y 21, y entre columnas 59 y 61
;    - En la etiqueta 'boton_pause' se verifica si se toco el boton Pause o Play
;    - El proposito del boton es congelar el juego por eso la bandera bandPause=1 y en la etiqueta 'validacion' siempre saltara a 'mouse_no_clic'
;    - hasta que se de clic en el boton play para activar los movimiento del juego (bandPause=0)
;    - no hace falta borrar o reimprimir la ventana con los botones [■] [‼] [►], porque se asume que no hay un cambio de ventana
   opcion2:
   cmp cx,59
   jge boton_pause   ;mayor o igual a 49
   jmp mouse_no_clic  ;menor a 49, salta a 'mouse_no_clic' y de acuerdo al flujo del programa llega a 'validacion'

   boton_pause:
   cmp cx,61
   jbe boton_pause2   ;menor o igual a 51. Columnas [48,51]
   jmp opcion1        ;mayor a 51 , sale del rango de columnas por lo tanto debemos revisar los botones [►]

   boton_pause2:     ;Si se llego aqui significa que se dio clic en el boton pause
   mov bandPause,1   ;congela el juego hasta que se de clic en el boton play
   jmp mouse_no_clic ;salta a 'mouse_no_clic' y de acuerdo al flujo del programa llega a 'validacion'

;/////////////////////////////////////////////////////////////////////////////////
;Lógica para revisar si el play fue presionado en [►]

;Consideraciones:
;    - [►] se encuentra entre los renglones 19 y 21, y entre columnas 69 y 71
;    - De la etiqueta 'boton_pause' salta hasta 'opcion1' porque existe la posibilidad de que sea boton [►]
;    - En la etiqueta 'boton_play2' la bandera bandPause=0 para descongelar el movimiento de las naves cuando pasemos a la etiqueta 'validacion'
;    - El proposito del boton activar los movimientos del juego 
;    - no hace falta borrar o reimprimir la ventana con los botones [■] [‼] [►], porque se asume que no hay un cambio de ventana 
   opcion1:
   cmp cx,69
   jge boton_play1   ;mayor o igual a 49
   jmp mouse_no_clic ;menor a 49 salta a 'mouse_no_clic' y de acuerdo al flujo del programa llega a 'validacion'

   boton_play1:
   cmp cx,71
   jbe boton_play2   ;menor o igual a 51 [48,51]
   jmp mouse_no_clic ;mayor a 51 , salta a 'mouse_no_clic' y de acuerdo al flujo del programa llega a 'validacion'

   boton_play2: ; Si se llego aqui significa que se dio clic en el boton play.
   mov bandPause,0   ;congela el juego hasta que se de clic en el boton play
   mov bandInicio,1  ;activa el juego
   jmp mouse_no_clic ;salta a 'mouse_no_clic' y de acuerdo al flujo del programa llega a 'validacion'

;/////////////////////////////////////////////////////////////////////////////////
;Lógica para revisar los botones [NO] [SI]

;primero se valida si los renglones corresponde al rango de [20,22]  
ventanaSINO:
   cmp dx,20
   jge boton_SINO    ;mayor o igual a 20
   jmp mouse_no_clic ;menor a 20

   boton_SINO:
   cmp dx,22
   jbe boton_no ;menor o igual a 22. [20,22]
   jmp mouse_no_clic  ;mayor a 22

;/////////////////////////////////////////////////////////////////////////////////
;Lógica para revisar si el boton 'NO' fue presionado en [NO]

;Consideraciones:
;    - [NO] se encuentra entre los renglones 20 y 22, y entre columnas 50 y 53
;    - de la etiqueta 'boton_stop2_2' salta a 'boton_stop2_3'. Significa que las columnas son las correctas de los dos botones
;    - El proposito del boton es descongelar el juego y continuar desde donde se quedo antes de oprimir el boton stop [■]
;    - bandPause = 0  descongela el juego
;    - bandStop  = 0  sale de la ventana SI y NO
;    - Se borra la ventana con los botonos [SI] y [NO]
;    - Imprime la ventana con los botones [■] [‼] [►]
   boton_no:
   cmp cx,50
   jge boton_no1 ;mayor o igual a 50
   jmp mouse_no_clic ;menor a 50 

   boton_no1:
   cmp cx,53
   jbe boton_no2 ;menor o igual a 53. Columna: [50,53]
   jmp boton_si  ;mayor a 53. Posibilidad de que sea boton SI

   boton_no2: ;si se llego aqui significa que se cumplieron las validaciones de las columnas donde puede ser presionado el boton [NO]
   posiciona_cursor_mouse 320,100
   mov bandPause,0      ;descongela el juego
   mov bandStop,0       ;sale de la ventana SI y NO
   call BORRAR_VENTANA2 ;Borra la ventana SI y NO
   call IMPRIME_BOTONES ;dibuja la ventana ; Stop, Pause y Play
   jmp mouse_no_clic
;/////////////////////////////////////////////////////////////////////////////////


;/////////////////////////////////////////////////////////////////////////////////
;Lógica para revisar si el boton 'SI' fue presionado en [SI]

;Consideraciones:
;    - [SI] se encuentra entre los renglones 20 y 22, y entre columnas 66 y 69
;    - El boton 'SI' tiene como proposito reiniciar todo el juego, por lo tanto de la etiqueta 'boton_si2' salta a 'inicio' 
;    - De la etiqueta 'boton_no1' salta a 'boton_si' porque existe la posibilidad de que sea boton [SI]
;    - Cuando salta a 'inicio' se limpia la pantalla y se imprime la ventana con los botones [■] [‼] [►] y el mensaje de "CLIC EN..."
   boton_si:
   cmp cx,66
   jge boton_si1     ;mayor o igual a 66
   jmp mouse_no_clic ;menor a 50

   boton_si1:
   cmp cx,69
   jbe boton_si2     ;menor o igual a 69. Columna: [66,69]
   jmp mouse_no_clic ;mayor a 53. Posibilidad de que sea boton SI

   boton_si2:      ;si se llego aqui significa que se cumplieron las validaciones de las columnas donde puede ser presionado el boton [SI]
   jmp inicio      ;se reinicia todo el juego
;/////////////////////////////////////////////////////////////////////////////////


;/////////////////////////////////////////////////////////////////////////////////
;Lógica para revisar si el boton 'continuar' fue presionado en [continuar]

;Consideraciones:
;    - [continuar] se encuentra entre los renglones 19 y 21, y entre columnas 54 y 65
;    - Para llegar al boton continuar se tuvieron que perder todas las vidas del jugador
;    - Desde la etiqueta 'mainBotones' se valida si 'bandContinuar=1' para saltar a la etiqueta 'ventanaContinuar'
;    - El proposito del boton continuar es reinicar el juego, por eso de la etiqueta 'boton_continuar2' salta a 'inicio'
;    - Cuando salta a 'inicio' se limpia la pantalla y se imprime la ventana con los botones [■] [‼] [►] y el mensaje "CLIC EN..."

ventanaContinuar:       ;Ventana continuar esta activa
   cmp cx,54
   jge boton_continuar1 ;mayor o igual a 54.
   jmp mouse_no_clic    ;menor que 54

boton_continuar1:
   cmp cx,65
   jbe boton_continuar2 ;mayor o igual a 65. Columna: [54,65]
   jmp mouse_no_clic    ;mayor que 65

boton_continuar2: 
   jmp inicio           ;se reinicia todo el juego
;/////////////////////////////////////////////////////////////////////////////////

;|---------------------------------------------------------------------------------------------------|
;|---------------------------------------------------------------------------------------------------|
;|                                    Movimiento del Jugador                                         |
;|---------------------------------------------------------------------------------------------------|
;|---------------------------------------------------------------------------------------------------| 

validacion: ;En esta etiqueta se revisa el estado del jugo: congelado o no congelado 

  cmp bandInicio,0  ;;¿bandInicio=0?
  je mouse_1  ;si bandInicio=0 aun no se corre el programa 

  cmp bandInicio2,0 ;imprime naves
  je inicio2

  cmp bandPause,1   ;¿bandPause=1?
  je mouse_1  ;vuelva a resisar el estado el mause hasta que se presione el boton play

  jmp mainJugador
;si la bandera bandPause es 0 significa que ya se pueden mover las naves


;                                    arriba
;                                     'w'
;                      izquierda  'a' 's' 'd'  derecha                      'k' dispara bala
;                                    abajo
;Cuando es el primer jugo o se reinicio desde cero se debe imprimir las naves y borrar el mesaje de "CLIC EN..."
;Para acceder a la etiqueta inicio2 la bandera bandInicio=0;
inicio2:
    call IMPRIME_ENEMIGO
    call IMPRIME_JUGADOR
    call BORRA_VENTANA
    mov bandInicio2,1;

mainJugador:
   cmp [bandera_jugador],0d ;Salto a la etiqueta mainjugador (movimiento del enemigo)
   je mainEnemigo

   ;------------------------------------------------ANEXADO------------
     cmp [enemy_ren],14h  ;compara si se encuentra en el limite derecho
     jge salto  
        guarda_posicionLaserE        
     	colision_BALA 
      	call BORRA_BOLA_E    
      	inc bolaE_ren   
      	call IMPRIME_BOLA_E 
     salto:
    
     cmp [bolaE_ren],10h
      jb salto1
 	 mov bandera_jugador,1d
	salto1:
	
     cmp bolaJ_activa_1,1h
     je off_1
	 colision_BALA_J1
    	 guarda_posicionLaserJ_1
   	 call BORRA_BOLAJ_1
    	 dec bolaJ_ren_1
     	call IMPRIME_BOLAJ_1C
     off_1:
	
     cmp bolaJ_activa_2,1h
     je off_2
	colision_BALA_J2
     	guarda_posicionLaserJ_2
    	call BORRA_BOLAJ_2
    	dec bolaJ_ren_2
     	call IMPRIME_BOLAJ_2C
     off_2:
	
     cmp bolaJ_activa_3,1h
     je off_3
	colision_BALA_J3
    	guarda_posicionLaserJ_3
     	call BORRA_BOLAJ_3
     	dec bolaJ_ren_3
     	call IMPRIME_BOLAJ_3C
     off_3:
	
;--------------------------------------------------------------------

  
   cmp [bandera_jugador],1d ;Salto a la etiqueta lectura_del_jugador. (lectura del teclado)
   je lectura_del_jugador

lectura_del_jugador:
   mov ah,01h               ;Se utiliza la interrupción 1Ah con opcion AH=01h para modificar a 0 el System-Timer Time Counter.
   mov cx,0000h             ;Se reinicia el System-Timer Time Counter.
   mov dx,0000h
   int 1Ah
   mov [bandera_jugador],0d ;se cambia el valor de la etiqueta para que despues de leer el teclado se mueva el enemigo
   
   LDJ:                     ;En esta etiqueta se compara la entrada
   entrada_teclado          ;macro para leer el contenido del buffer de teclado
   jz mouse_1               ;Si Z = 0, hay datos en el buffer de teclado. Si Z = 1, no hay datos en buffer de teclado
   vacia_teclado              ;macro para vaciar el contenido del buffer de teclado

   cmp al,64h ;caracter 'd' se avanza a la derecha
   je derechaJ

   cmp al,61h ;caracter 'a' se avanza a la izquierda
   je izquierdaJ

   cmp al,77h ;caracter 'w' se avanza hacia arriba
   je arribaJ

   cmp al,73h ;caracter 's' se avanza hacia abajo
   je abajoJ

   cmp al,6Bh ;caracter 'k' se dispara la bala del jugador
   je disparoJ

   cmp al,6Ah ;caracter 'j' se dispara la bala del jugador
   je disparoJ2
     
   cmp al,6Ch ;caracter 'l' se dispara la bala del jugador
   je disparoJ3

   jmp mouse_1 ;si el caracter del teclado no corresponde a un boton de movimiento



;DERECHA: no pasar el limite derecho 39d o 27h. Caracter 'd'
;----->
derechaJ:
    cmp player_col,25h  ;compara si se encuentra en el limite derecho
    je mouse_1

    guarda_posicionj     ;macro para pasar las coordenadas del jugador a las variables col_aux y ren_aux 
    colision_derecha     ;comprueba que no exista colisión 

   call BORRA_JUGADOR

   inc player_col      ;se incrementa la columna del jugador ----->

   call IMPRIME_JUGADOR

   
   xor ax,ax           ;se limpia el registro. ax=0000h
   jmp mouse_1



;IZQUIERDA: no pasar el limite izquierdo 1d o 01h. Caracter 'a'
;<-----
izquierdaJ:
    cmp player_col,03h ;compara si se encuentra en el limite izquierdo
    je mouse_1

    guarda_posicionj   ;macro para pasar las coordenadas del jugador a las variables col_aux y ren_aux 
    colision_izquierda ;comprueba que no exista colisión 

   call BORRA_JUGADOR ;se decrementa la columna del jugador <-----

   dec player_col

   call IMPRIME_JUGADOR

   
   xor ax,ax           ;se limpia el registro. ax=0000h
   jmp mouse_1

;ARRIBA: no pasar el limite superior 1d o 01h. Caracter 'w'
;^
;|
;|
arribaJ:
    cmp player_ren,03h ;compara si se encuentra en el limite superior
    je mouse_1

    guarda_posicionj   ;macro para pasar las coordenadas del jugador a las variables col_aux y ren_aux  
    colision_arriba    ;comprueba que no exista colisión

   call BORRA_JUGADOR

    dec player_ren

    call IMPRIME_JUGADOR

   xor ax,ax          ;se limpia el registro. ax=0000h
   jmp mouse_1

;ABAJO: no pasar el limite inferior 22d o 16h. Caracter 's'
;|
;|
;v
abajoJ:
    cmp player_ren,16h ;compara si se encuentra en el limite inferior
    je mouse_1  ;mouse_no_clic

    guarda_posicionj    ;macro para pasar las coordenadas del jugador a las variables col_aux y ren_aux 
    colision_abajo      ;comprueba que no exista colisión 

   call BORRA_JUGADOR

    inc player_ren

    call IMPRIME_JUGADOR

   xor ax,ax
   jmp mouse_1


;|---------------------------------------------------------------------------------------------------|
;|                                    Movimiento del Disparo Jugador                                 |
;|---------------------------------------------------------------------------------------------------|
;de ABAJO hacia ARRIBA
;^
;|
;|
;Consideraciones: si la bala llega al limite superior desaparece
;                 si la bala le da al enemigo, el enemigo desapacere y se cuenta en el SCORE
disparoJ:
	cmp player_ren,03h ;compara si se encuentra en el limite superior
    	je mouse_1

	;----------------Comprueba si la bala(1) está activa(no puede estar dos veces en el plano)
	cmp bolaJ_activa_1,0h
	je dis1_off
   tone DISPARO_S
		call IMPRIME_BOLAJ_1
		mov bolaJ_activa_1,0h
	dis1_off:
	
	xor ax,ax
	jmp mouse_1

disparoJ2:
	cmp player_ren,03h ;compara si se encuentra en el limite superior
    	je mouse_1

	;----------------Comprueba si la bala(2) está activa(no puede estar dos veces en el plano)
	cmp bolaJ_activa_2,0h
	je dis2_off
   tone DISPARO_S
		call IMPRIME_BOLAJ_2
		mov bolaJ_activa_2,0h
	dis2_off:
	
	xor ax,ax
	jmp mouse_1

disparoJ3:
	cmp player_ren,03h ;compara si se encuentra en el limite superior
    	je mouse_1

	;----------------Comprueba si la bala(2) está activa(no puede estar dos veces en el plano)
	cmp bolaJ_activa_3,0h
	je dis3_off
   tone DISPARO_S
		call IMPRIME_BOLAJ_3
		mov bolaJ_activa_3,0h
	dis3_off:
	
	xor ax,ax
	jmp mouse_1

;|---------------------------------------------------------------------------------------------------|
;|                                    Fin de Movimiento del Jugador                                  |
;|---------------------------------------------------------------------------------------------------|
 


;|---------------------------------------------------------------------------------------------------|
;|---------------------------------------------------------------------------------------------------|
;|                                    Movimiento del Enemigo                                         |
;|---------------------------------------------------------------------------------------------------|
;|---------------------------------------------------------------------------------------------------|

mainEnemigo:        ;En esta etiqueta se revisa si ya paso el tiempo para mover la nave enemigav
   mov ax,0000h   ;Obtiene el valor del sistema (ticks) y se almacena en dx.
   int 1Ah

   cmp dx,dificultad      ;verifica que dx sea mayor que contador, si no lo es se repiten el código de intrucciones desde la etiqueta mouse_no_clic
   jge movimientoE      ;2d ES LA "VELOCIDAD" DEL JUEGO (podría verse com difucultad)
   jmp LDJ

movimientoE:

   cmp bandE,1d ;avanza a la derecha
   je derechaE

   cmp bandE,0d  ;avanza a la izquierda
   je izquierdaE


;DERECHA: no pasar el limite derecho 39d o 27h
;----->
derechaE:
;-------------------------PARTE ANEXADA
    guarda_posicionLaserE        
  ;  colision_BALA 
;-----------------------------------
    guarda_posicionE
    colision_derechaE
    mov bandE,01d     ;se cambia el valor de la bandera para que se mueva siempre a la derecha
   
    cmp enemy_col,25h ;compara si se encuentra en el limite derecho
    je izquierdaE     ;avanza hacia la derecha
;--------------------------PARTE ANEXADA
     cmp bolaE_ren,16h; compara si la bala enemiga se encuentra en el límite inferior del plano de juego
     je restaurarBalaD
     regresoBalaD:

     cmp bolaJ_ren_1,1h; compara si la bala del jugador se encuentra en el límite inferior del plano de juego
     je restaurarBalaJ_1D
     regresoBalaJ_1D:

     cmp bolaJ_ren_2,1h; compara si la bala del jugador se encuentra en el límite inferior del plano de juego
     je restaurarBalaJ_2D
     regresoBalaJ_2D:

     cmp bolaJ_ren_3,1h; compara si la bala del jugador se encuentra en el límite inferior del plano de juego
     je restaurarBalaJ_3D
     regresoBalaJ_3D:
;-------------------------------------------
    cmp enemy_col,1Dh ;compara si se encuentra en 29d para bajar
    je abajoED        ;baja en diagonal a la derecha

    cmp enemy_col,09h ;compara si se encuentra en 09d para bajar
    je abajoED        ;baja en diagonal a la derecha

    cmp enemy_col,13h ; compara si se encuentra en 19d para bajar
    je abajoED        ;baja en diagonal a la derecha

    call BORRA_ENEMIGO

    inc enemy_col     ;incrementamos la columna del enemigo  -------->

    call IMPRIME_ENEMIGO

    mov bandera_jugador,1d ;para pasar a la etiqueta lectura_del_jugador cuando se encuentre en mainJugador
    jmp LDJ


;IZQUIERDA: no pasar el limite izquierdo 1d o 01h
;<-----
izquierdaE:
;--------------------------------PARTE ANEXADA
    guarda_posicionLaserE        
    ;colision_BALA 
;--------------------------------
    guarda_posicionE
    colision_izquierdaE
    mov bandE,0d      ;se cambia el valor de la bandera para que se mueva siempre a la izquierda
    cmp enemy_col,03h ;compara si se encuentra en el limite izquierdo
    je derechaE       ;baja en diagonal a la izquierda
;--------------------------------PARTE ANEXADA
 ;RESTAURIZACIÓN DE BALA
     cmp bolaE_ren,16h; compara si la bala enemiga se encuentra en el límite inferior del plano de juego
     je restaurarBalaI
     regresoBalaI:

     ;RESTAURIZACIÓN DE BALA(1)J
     cmp bolaJ_ren_1,1h; compara si la bala del jugador se encuentra en el límite inferior del plano de juego
     je restaurarBalaJ_1I
     regresoBalaJ_1I:

    ;RESTAURIZACIÓN DE BALA(2)J
     cmp bolaJ_ren_2,1h; compara si la bala del jugador se encuentra en el límite inferior del plano de juego
     je restaurarBalaJ_2I
     regresoBalaJ_2I:

     ;RESTAURIZACIÓN DE BALA(3)J
     cmp bolaJ_ren_3,1h; compara si la bala del jugador se encuentra en el límite inferior del plano de juego
     je restaurarBalaJ_3I
     regresoBalaJ_3I:
;-----------------------------------------

    cmp enemy_col,1Dh ;compara si se encuentra en 29d para bajar
    je abajoEI        ;baja en diagonal a la izquierda

    cmp enemy_col,09h ;compara si se encuentra en 09d para bajar
    je abajoEI        ;baja en diagonal a la izquierda

    cmp enemy_col,13h ;compara si se encuentra en 19d para bajar
    je abajoEI        ;baja en diagonal a la izquierda

    call BORRA_ENEMIGO

    dec enemy_col     ;decrementamos la columna del enemigo  <--------

    call IMPRIME_ENEMIGO

    mov bandera_jugador,1d ;para pasar a la etiqueta lectura_del_jugador cuando se encuentre en mainJugador
    jmp LDJ

;--------------------------PARTE ANEXADA
restaurarBalaJ_1D:
      call BORRA_BOLAJ_1
      mov bolaJ_activa_1,1h
jmp regresoBalaJ_1D
;---------------------------
restaurarBalaJ_1I:
      call BORRA_BOLAJ_1
      mov bolaJ_activa_1,1h   
jmp regresoBalaJ_1I
;---------------------------
restaurarBalaJ_2D:
      call BORRA_BOLAJ_2
      mov bolaJ_activa_2,1h
jmp regresoBalaJ_2D
;---------------------------
restaurarBalaJ_2I:
       call BORRA_BOLAJ_2
       mov bolaJ_activa_2,1h
jmp regresoBalaJ_2I

restaurarBalaJ_3D:
      call BORRA_BOLAJ_3
      mov bolaJ_activa_3,1h
jmp regresoBalaJ_3D
;---------------------------
restaurarBalaJ_3I:
       call BORRA_BOLAJ_3
       mov bolaJ_activa_3,1h
jmp regresoBalaJ_3I
;----------------------------
restaurarBalaD:	
    call BORRA_BOLA_E    
    guarda_posicionE 
    
    mov [bolaE_col],al
    inc ah
    inc ah
    mov [bolaE_ren] , ah
    call IMPRIME_BOLA_E

jmp regresoBalaD
;----------------------------
restaurarBalaI:	
    call BORRA_BOLA_E    
    guarda_posicionE 
    
    mov [bolaE_col],al
    inc ah
    inc ah
    mov [bolaE_ren] , ah
    call IMPRIME_BOLA_E
jmp regresoBalaI
;-----------------------------------------------------------------
;ABAJO: no pasar el limite inferior 22d o 16h. 
;|
;|
;v
;Consideraciones: si el enemigo llega al limite inferior, el jugador pierde una vida,
;                 si chocan las naves el jugador pierde una vida
abajoED: ;movimiento en diagonal hacia abajo y a la derecha
    guarda_posicionE
    colision_abajoD
    cmp enemy_ren,13h ;compara si se encuentra en el limite inferior
    je pierde_vida    ;si se encuentra en el limite inferior se pierde una vida

    call BORRA_ENEMIGO

    inc enemy_ren ;el enemigo avanza en diagonal hacia la derecha 
    inc enemy_col

    call IMPRIME_ENEMIGO

    mov bandera_jugador,1d ;para pasar a la etiqueta lectura_del_jugador cuando se encuentre en mainJugador
    jmp LDJ

abajoEI: ;movimiento en diagonal hacia abajo y a la izquierda  
    guarda_posicionE
    colision_abajoI
    cmp enemy_ren,13h   ;compara si se encuentra en el limite inferior
    je pierde_vida      ;si se encuentra en el limite inferior se pierde una vida 

    call BORRA_ENEMIGO

    inc enemy_ren      ;el enemigo avanza en diagonal hacia la izquierda
    dec enemy_col

    call IMPRIME_ENEMIGO 

    mov bandera_jugador,1d ;para pasar a la etiqueta lectura_del_jugador cuando se encuentre en mainJugador
    jmp LDJ


;|---------------------------------------------------------------------------------------------------|
;|                                   Movimiento del Disparo Enemigo                                  |
;|---------------------------------------------------------------------------------------------------|

;de ARRIBA hacia ABAJO.
;|
;|
;v
;Consideraciones: si la bala llega  al limite inferior desaparece
;                 si le da al jugador pierde una vida

disparoE:
    mov bandera_bala,1d ;se encuentra activa la bala 
    cmp balaE_ren,13h ; se borra la bala porque llego al limite inferior
    je eliminaBala
    

    eliminaBala:
       call BORRA_BALAE
       mov bandera_bala,0d ;se encuentra disponible  la bala 

;|---------------------------------------------------------------------------------------------------|
;|                                    Fin de Movimiento del Enemigo                                  |
;|---------------------------------------------------------------------------------------------------|



;|---------------------------------------------------------------------------------------------------|
;|---------------------------------------------------------------------------------------------------|
;|                                            Pierde vida                                            |
;|---------------------------------------------------------------------------------------------------|
;|---------------------------------------------------------------------------------------------------|
pierde_vida: ;el enemigo paso y llego al limite inferior o colision de naves
;   se borra la nave del jugador y se pone en la posición inicial.
   tone Hit_S
   call BORRA_ENEMIGO ; se borra enemigo
    mov [enemy_col], ini_columna
    mov [enemy_ren], 3d

   call BORRA_JUGADOR
    mov [player_col], ini_columna
    mov [player_ren], ini_renglon

   call BORRA_BOLA_E
     mov [bolaE_col], ini_columna 
     mov [bolaE_ren], ini_renglon-16 

   call IMPRIME_BOLA_E
   call IMPRIME_ENEMIGO
   call IMPRIME_JUGADOR

   call BORRA_LIVES    ;borramos los caracteres que representan las vidas
   dec player_lives    ;quitamos una vida del jugador

   cmp player_lives,0d ;¿el jugador ya perdio todas las vidas?
   je G_O              ;la etiqueta G_O tiene como proposito reiniciar el juego

   call IMPRIME_LIVES  ;se vuelva escribir el contador de vidas con los caracteres correspondientes
   mov bandera_jugador,0d

   jmp mouse_no_clic

pierde_vidaE1: ;el enemigo paso y llego al limite inferior o colision de naves
;   se borra la nave del jugador y se pone en la posición inicial.
   tone Hit_S
   guarda_posicionLaserJ_1
   call BORRA_BOLAJ_1
   mov bolaJ_activa_1,1h
   mov bolaJ_col_1,0h
   mov bolaJ_ren_1,0h

   call BORRA_BOLA_E
     mov [bolaE_col], ini_columna 
     mov [bolaE_ren], ini_renglon-16 

   call BORRA_ENEMIGO ; se borra enemigo
    mov [enemy_col], ini_columna
    mov [enemy_ren], 3d 

   call IMPRIME_BOLA_E
   call IMPRIME_ENEMIGO
   call BORRA_SCORE
   
   mov  ax,player_score
   adc  ax,4d
   mov player_score,ax

   call IMPRIME_SCORES

   cmp ax,player_hiscore
;   jbe NOactualizacionHS1
   
 ;       call BORRA_HISCORE 
 ;	mov ax,player_score
 ;	mov player_hiscore,ax 
 ;	call IMPRIME_HISCORE
  ; NOactualizacionHS1:
	
   jmp mouse_no_clic
;------------------------------------------------------------------------------
pierde_vidaE2: ;el enemigo paso y llego al limite inferior o colision de naves
;   se borra la nave del jugador y se pone en la posición inicial.
   tone Hit_S
   guarda_posicionLaserJ_2
   call BORRA_BOLAJ_2
   mov bolaJ_activa_2,1h
   mov bolaJ_col_2,0h
   mov bolaJ_ren_2,0h

   call BORRA_BOLA_E
     mov [bolaE_col], ini_columna 
     mov [bolaE_ren], ini_renglon-16 

   call BORRA_ENEMIGO ; se borra enemigo
    mov [enemy_col], 1Dh
    mov [enemy_ren], 8d 

   call IMPRIME_BOLA_E
   call IMPRIME_ENEMIGO
   call BORRA_SCORE
   
   mov  ax,player_score
   adc  ax,20d
   mov player_score,ax

   call IMPRIME_SCORES

; jbe NOactualizacionHS2
   
 ;       call BORRA_HISCORE 
 ;	mov ax,player_score
 ;	mov player_hiscore,ax 
 ;	call IMPRIME_HISCORE
  ; NOactualizacionHS2:

   jmp mouse_no_clic
;------------------------------------------------------------------------------
pierde_vidaE3: ;el enemigo paso y llego al limite inferior o colision de naves
;   se borra la nave del jugador y se pone en la posición inicial.
   tone Hit_S
   guarda_posicionLaserJ_3
   call BORRA_BOLAJ_3
   mov bolaJ_activa_3,1h
   mov bolaJ_col_3,0h
   mov bolaJ_ren_3,0h

   call BORRA_BOLA_E
     mov [bolaE_col], ini_columna 
     mov [bolaE_ren], ini_renglon-16 

   call BORRA_ENEMIGO ; se borra enemigo
    mov [enemy_col],  1Dh
    mov [enemy_ren], 12d 

   call IMPRIME_BOLA_E
   call IMPRIME_ENEMIGO
   call BORRA_SCORE
   
   mov  ax,player_score
   adc  ax,27d
   mov player_score,ax

   call IMPRIME_SCORES

 ;jbe NOactualizacionHS3
   
  ;      call BORRA_HISCORE 
 ;	mov ax,player_score
 ;	mov player_hiscore,ax 
 ;	call IMPRIME_HISCORE
  ; NOactualizacionHS3:

   jmp mouse_no_clic

G_O:
   posiciona_cursor_mouse 320,100 ;posiciona cursor
   call BORRA_BOTONES
   mov bandTexto,1     ;mostrar texto de game over
   call PRINT_VENTANA
   mov bandContinuar,1 ;Se encuentra activa la ventana de game over
   mov bandPause,1     ;Congela el juego
   call BORRA_ENEMIGO
   call BORRA_JUGADOR
   call BORRA_BOLA_E
   call BORRA_BOLAJ_1
   call BORRA_BOLAJ_2
   call BORRA_BOLAJ_2
   call BORRA_BOLAJ_3
   jmp mouse_no_clic
;|---------------------------------------------------------------------------------------------------|
;|                                        Fin de Pierde vida                                         |
;|---------------------------------------------------------------------------------------------------|

;Si no se encontró el driver del mouse, muestra un mensaje y el usuario debe salir tecleando [enter]
teclado:
   mov ah,08h
   int 21h
   cmp al,0Dh     ;compara la entrada de teclado si fue [enter]
   jnz teclado    ;Sale del ciclo hasta que presiona la tecla [enter]

salir:            ;inicia etiqueta salir
   clear          ;limpia pantalla
   mov ax,4C00h   ;AH = 4Ch, opción para terminar programa, AL = 0 Exit Code, código devuelto al finalizar el programa
   int 21h        ;señal 21h de interrupción, pasa el control al sistema operativo

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;PROCEDIMIENTOS;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   DIBUJA_UI proc
      ;imprimir esquina superior izquierda del marco
      posiciona_cursor 0,0
      imprime_caracter_color marcoEsqSupIzq,cAmarillo,bgNegro
      
      ;imprimir esquina superior derecha del marco
      posiciona_cursor 0,79
      imprime_caracter_color marcoEsqSupDer,cAmarillo,bgNegro
      
      ;imprimir esquina inferior izquierda del marco
      posiciona_cursor 24,0
      imprime_caracter_color marcoEsqInfIzq,cAmarillo,bgNegro
      
      ;imprimir esquina inferior derecha del marco
      posiciona_cursor 24,79
      imprime_caracter_color marcoEsqInfDer,cAmarillo,bgNegro
      
      ;imprimir marcos horizontales, superior e inferior
      mov cx,78      ;CX = 004Eh => CH = 00h, CL = 4Eh 
   marcos_horizontales:
      mov [col_aux],cl
      ;Superior
      posiciona_cursor 0,[col_aux]
      imprime_caracter_color marcoHor,cAmarillo,bgNegro
      ;Inferior
      posiciona_cursor 24,[col_aux]
      imprime_caracter_color marcoHor,cAmarillo,bgNegro
      
      mov cl,[col_aux]
      loop marcos_horizontales

      ;imprimir marcos verticales, derecho e izquierdo
      mov cx,23      ;CX = 0017h => CH = 00h, CL = 17h 
   marcos_verticales:
      mov [ren_aux],cl
      ;Izquierdo
      posiciona_cursor [ren_aux],0
      imprime_caracter_color marcoVer,cAmarillo,bgNegro
      ;Inferior
      posiciona_cursor [ren_aux],79
      imprime_caracter_color marcoVer,cAmarillo,bgNegro
      ;Limite mouse
      posiciona_cursor [ren_aux],lim_derecho+1
      imprime_caracter_color marcoVer,cAmarillo,bgNegro

      mov cl,[ren_aux]
      loop marcos_verticales

      ;imprimir marcos horizontales internos
      mov cx,79-lim_derecho-1       
   marcos_horizontales_internos:
      push cx
      mov [col_aux],cl
      add [col_aux],lim_derecho
      ;Interno superior 
      posiciona_cursor 8,[col_aux]
      imprime_caracter_color marcoHor,cAmarillo,bgNegro

      ;Interno inferior
      posiciona_cursor 16,[col_aux]
      imprime_caracter_color marcoHor,cAmarillo,bgNegro

      mov cl,[col_aux]
      pop cx
      loop marcos_horizontales_internos

      ;imprime intersecciones internas 
      posiciona_cursor 0,lim_derecho+1
      imprime_caracter_color marcoCruceVerSup,cAmarillo,bgNegro
      posiciona_cursor 24,lim_derecho+1
      imprime_caracter_color marcoCruceVerInf,cAmarillo,bgNegro

      posiciona_cursor 8,lim_derecho+1
      imprime_caracter_color marcoCruceHorIzq,cAmarillo,bgNegro
      posiciona_cursor 8,79
      imprime_caracter_color marcoCruceHorDer,cAmarillo,bgNegro

      posiciona_cursor 16,lim_derecho+1
      imprime_caracter_color marcoCruceHorIzq,cAmarillo,bgNegro
      posiciona_cursor 16,79
      imprime_caracter_color marcoCruceHorDer,cAmarillo,bgNegro

      ;imprimir [X] para cerrar programa
      posiciona_cursor 0,76
      imprime_caracter_color '[',cAmarillo,bgNegro
      posiciona_cursor 0,77
      imprime_caracter_color 'X',cRojoClaro,bgNegro
      posiciona_cursor 0,78
      imprime_caracter_color ']',cAmarillo,bgNegro

      ;imprimir título
      posiciona_cursor 0,37
      imprime_cadena_color [titulo],6,cAmarillo,bgNegro

      call IMPRIME_TEXTOS

      call IMPRIME_BOTONES

      call IMPRIME_DATOS_INICIALES

      call IMPRIME_SCORES

      call IMPRIME_LIVES

      call PRINT_VENTANA
             	
      ret
   endp

   IMPRIME_TEXTOS proc
      ;Imprime cadena "LIVES"
      posiciona_cursor lives_ren,lives_col
      imprime_cadena_color livesStr,5,cGrisClaro,bgNegro

      ;Imprime cadena "SCORE"
      posiciona_cursor score_ren,score_col
      imprime_cadena_color scoreStr,5,cGrisClaro,bgNegro

      ;Imprime cadena "HI-SCORE"
      posiciona_cursor hiscore_ren,hiscore_col
      imprime_cadena_color hiscoreStr,8,cGrisClaro,bgNegro
      ret
   endp

   IMPRIME_BOTONES proc
      ;Botón STOP
      mov [boton_caracter],254d     ;Carácter '■'
      mov [boton_color],bgAmarillo  ;Background amarillo
      mov [boton_renglon],stop_ren  ;Renglón en "stop_ren"
      mov [boton_columna],stop_col  ;Columna en "stop_col"
      call IMPRIME_BOTON            ;Procedimiento para imprimir el botón
      ;Botón PAUSE
      mov [boton_caracter],19d      ;Carácter '‼'
      mov [boton_color],bgAmarillo  ;Background amarillo
      mov [boton_renglon],pause_ren    ;Renglón en "pause_ren"
      mov [boton_columna],pause_col    ;Columna en "pause_col"
      call IMPRIME_BOTON            ;Procedimiento para imprimir el botón
      ;Botón PLAY
      mov [boton_caracter],16d      ;Carácter '►'
      mov [boton_color],bgAmarillo  ;Background amarillo
      mov [boton_renglon],play_ren  ;Renglón en "play_ren"
      mov [boton_columna],play_col  ;Columna en "play_col"
      call IMPRIME_BOTON            ;Procedimiento para imprimir el botón
      ret
   endp

   IMPRIME_SCORES proc
      ;Imprime el valor de la variable player_score en una posición definida
      call IMPRIME_SCORE
      ;Imprime el valor de la variable player_hiscore en una posición definida
      call IMPRIME_HISCORE
      ret
   endp

   IMPRIME_SCORE proc
      ;Imprime "player_score" en la posición relativa a 'score_ren' y 'score_col'
      mov [ren_aux],score_ren
      mov [col_aux],score_col+20
      mov bx,[player_score]
      call IMPRIME_BX
      ret
   endp

   IMPRIME_HISCORE proc
   ;Imprime "player_score" en la posición relativa a 'hiscore_ren' y 'hiscore_col'
      mov [ren_aux],hiscore_ren
      mov [col_aux],hiscore_col+20
      mov bx,[player_hiscore]
      call IMPRIME_BX
      ret
   endp

   ;BORRA_SCORES borra los marcadores numéricos de pantalla sustituyendo la cadena de números por espacios
   BORRA_SCORES proc
      call BORRA_SCORE
      call BORRA_HISCORE
      ret
   endp

   BORRA_SCORE proc
      posiciona_cursor score_ren,score_col+20      ;posiciona el cursor relativo a score_ren y score_col
      imprime_cadena_color blank,5,cBlanco,bgNegro    ;imprime cadena blank (espacios) para "borrar" lo que está en pantalla
      ret
   endp

   BORRA_HISCORE proc
      posiciona_cursor hiscore_ren,hiscore_col+20  ;posiciona el cursor relativo a hiscore_ren y hiscore_col
      imprime_cadena_color blank,5,cBlanco,bgNegro    ;imprime cadena blank (espacios) para "borrar" lo que está en pantalla
      ret
   endp

   ;Imprime el valor del registro BX como entero sin signo (positivo)
   ;Se imprime con 5 dígitos (incluyendo ceros a la izquierda)
   ;Se usan divisiones entre 10 para obtener dígito por dígito en un LOOP 5 veces (una por cada dígito)
   IMPRIME_BX proc
      mov ax,bx
      mov cx,5
   div10:
      xor dx,dx
      div [diez]
      push dx
      loop div10
      mov cx,5
   imprime_digito:
      mov [conta],cl
      posiciona_cursor [ren_aux],[col_aux]
      pop dx
      or dl,30h
      imprime_caracter_color dl,cBlanco,bgNegro
      xor ch,ch
      mov cl,[conta]
      inc [col_aux]
      loop imprime_digito
      ret
   endp

   IMPRIME_DATOS_INICIALES proc
      call DATOS_INICIALES       ;inicializa variables de juego

      ;borra la posición actual, luego se reinicia la posición y entonces se vuelve a imprimir
      call BORRA_JUGADOR
      mov [player_col], ini_columna
      mov [player_ren], ini_renglon

      ;Borrar posicion actual y se reinicia la posición del enemigo 
      call BORRA_ENEMIGO
      mov [enemy_col], ini_columna
      mov [enemy_ren], 3

      call BORRA_BOLA_E
      mov [bola_col], ini_columna
      mov [bola_ren], ini_renglon-16
   endp

   ;Inicializa variables del juego
   DATOS_INICIALES proc
      mov [player_score],0
      mov [player_lives], 3
      mov bandTexto,0
      mov bandPause,0
      mov bandStop,0
      mov bandera_jugador,1
      mov bandInicio,0
      mov bandInicio2,0
      mov bandContinuar,0
      mov bandE,1
      mov bolaE_ren,6
      mov bolaE_col,19
      mov bolaJ_ren_1,0
      mov bolaJ_ren_2,0
      mov bolaJ_ren_3,0
      mov bolaJ_col_1,0
      mov bolaJ_col_2,0
      mov bolaJ_col_3,0
      ret
   endp

   ;Imprime los caracteres ☻ que representan vidas. Inicialmente se imprime el número de 'player_lives'
   IMPRIME_LIVES proc
      xor cx,cx
      mov di,lives_col+20
      mov cl,[player_lives]
       imprime_live:
      push cx
      mov ax,di
      posiciona_cursor lives_ren,al
      imprime_caracter_color 3d,cRojo,bgNegro
      add di,2
      pop cx
      loop imprime_live
      ret
   endp

   BORRA_LIVES proc 
       xor cx,cx
       mov di,lives_col+20
      mov cl,[player_lives]
           borra_live:
          push cx
          mov ax,di
          posiciona_cursor lives_ren,al
          imprime_caracter_color 22d,cNegro,bgNegro
          add di,2
          pop cx
          loop borra_live
          ret
   endp
;---------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------
;                           Procedimiento utilizados para el JUGADOR

    BORRA_JUGADOR proc
      guarda_posicionJ   ;macro para pasar las coordenadas del jugador a las variables col_aux y ren_aux 
      call DELETE_PLAYER
      ret
   endp

   IMPRIME_JUGADOR proc
      guarda_posicionJ   ;macro para pasar las coordenadas del jugador a las variables col_aux y ren_aux 
      call PRINT_PLAYER
      ret
   endp

   IMPRIME_BALAJ proc
      mov ah,[balaE_col]
      mov al,[balaE_ren]
      mov [col_aux],ah
      mov [ren_aux],al
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22d,cblanco,bgNegro 
      ret
    endp

    BORRA_BALAJ proc
      mov ah,[balaE_col]
      mov al,[balaE_ren]
      mov [col_aux],ah
      mov [ren_aux],al
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22d,cNegro,bgNegro 
      ret
   endp

   ;Imprime la nave del jugador, que recibe como parámetros las variables ren_aux y col_aux, que indican la posición central inferior
   PRINT_PLAYER proc

      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cBlanco,bgNegro
      dec [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cBlanco,bgNegro
      dec [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cBlanco,bgNegro
      add [ren_aux],2
      
      dec [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cBlanco,bgNegro
      dec [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cBlanco,bgNegro
      inc [ren_aux]
      
      dec [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cBlanco,bgNegro
      
      add [col_aux],3
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cBlanco,bgNegro
      dec [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cBlanco,bgNegro
      inc [ren_aux]
      
      inc [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cBlanco,bgNegro
      ret
   endp



   ;Imprime la nave del jugador, que recibe como parámetros las variables ren_aux y col_aux, que indican la posición central inferior
   PRINT_PLAYER_MUERTO proc

      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cVerde ,bgNegro
      dec [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cVerde ,bgNegro
      dec [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cVerde ,bgNegro
      add [ren_aux],2
      
      dec [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cVerde ,bgNegro
      dec [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cVerde ,bgNegro
      inc [ren_aux]
      
      dec [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cVerde ,bgNegro
      
      add [col_aux],3
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cVerde ,bgNegro
      dec [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cVerde ,bgNegro
      inc [ren_aux]
      
      inc [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 219,cVerde ,bgNegro
      ret
   endp

   ;Borra la nave del jugador, que recibe como parámetros las variables ren_aux y col_aux, que indican la posición central de la barra
   DELETE_PLAYER proc
      ;Implementar
        posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      dec [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      dec [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      add [ren_aux],2
      
      dec [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      dec [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      inc [ren_aux]
      
      dec [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      
      add [col_aux],3
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      dec [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      inc [ren_aux]
      
      inc [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      ret
   endp
;---------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------
;                           Procedimiento utilizados para el ENEMIGO

    BORRA_ENEMIGO proc
      guarda_posicionE   ;macro para pasar las coordenadas del enemigo a las variables col_aux y ren_aux
      call DELETE_ENEMY
      ret
   endp

    IMPRIME_ENEMIGO proc
      guarda_posicionE   ;macro para pasar las coordenadas del enemigo a las variables col_aux y ren_aux
      call PRINT_ENEMY
      ret
   endp

   IMPRIME_BALAE proc
       mov ah,[balaE_col]
      mov al,[balaE_ren]
      mov [col_aux],ah
      mov [ren_aux],al
       posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22d,cRojo,bgNegro 
       ret
    endp

    BORRA_BALAE proc
      mov ah,[balaE_col]
      mov al,[balaE_ren]
      mov [col_aux],ah
      mov [ren_aux],al
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22d,cNegro,bgNegro 
      ret
   endp


   ;Imprime la nave del enemigo
   PRINT_ENEMY proc

      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 178,cRojo,bgNegro
      inc [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 178,cRojo,bgNegro
      inc [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 178,cRojo,bgNegro
      sub [ren_aux],2
      
      dec [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 178,cRojo,bgNegro
      inc [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 178,cRojo,bgNegro
      dec [ren_aux]
      
      dec [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 178,cRojo,bgNegro
      
      add [col_aux],3
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 178,cRojo,bgNegro
      inc [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 178,cRojo,bgNegro
      dec [ren_aux]
      
      inc [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 178,cRojo,bgNegro
      ret
   endp

   DELETE_ENEMY proc
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      inc [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      inc [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      sub [ren_aux],2
      
      dec [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      inc [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      dec [ren_aux]
      
      dec [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      
      add [col_aux],3
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      inc [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      dec [ren_aux]
      
      inc [col_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      ret
   endp

;---------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------
;                               Procedimientos para los botones

   PRINT_VENTANA proc 
        ;imprimir esquina superior izquierda del marco
      posiciona_cursor 7,12
      imprime_caracter_color marcoEsqSupIzq,cAmarillo,bgNegro
      
      ;imprimir esquina superior derecha del marco
      posiciona_cursor 7,26
      imprime_caracter_color marcoEsqSupDer,cAmarillo,bgNegro
      
      ;imprimir esquina inferior izquierda del marco
      posiciona_cursor 15,12
      imprime_caracter_color marcoEsqInfIzq,cAmarillo,bgNegro
      
      ;imprimir esquina inferior derecha del marco
      posiciona_cursor 15,26
      imprime_caracter_color marcoEsqInfDer,cAmarillo,bgNegro

      mov [col_aux],13
      marcos_h:
      ;Superior
      posiciona_cursor 7,[col_aux]
      imprime_caracter_color marcoHor,cAmarillo,bgNegro
      ;Inferior
      posiciona_cursor 15,[col_aux]
      imprime_caracter_color marcoHor,cAmarillo,bgNegro
      inc col_aux
      cmp col_aux,25d
      jbe marcos_h

       mov ren_aux,8
      marcos_v:
      ;Superior
      posiciona_cursor [ren_aux],12
      imprime_caracter_color marcoVer,cAmarillo,bgNegro
      ;Inferior
      posiciona_cursor [ren_aux],26
      imprime_caracter_color marcoVer,cAmarillo,bgNegro
      inc ren_aux
      cmp ren_aux,14d
      jbe marcos_v


      cmp bandTexto,1
      je gameO       ;si la bandTexto=1 entonces se imprime el texto game over en pantalla

        ;Imprime cadena "ClIC..."
        posiciona_cursor 9,14
      imprime_cadena_color mensaje1,10,cGrisClaro,bgNegro
        ;Imprime cadena "BOTÓN"
        posiciona_cursor 11,17
      imprime_cadena_color mensaje2,5,cGrisClaro,bgNegro
        ;Imprime cadena "PLAY"
        posiciona_cursor 13,17
      imprime_cadena_color mensaje3,6,cGrisClaro,bgNegro

      retgameO:
      ret 
   endp

   gameO:
       ;Imprime cadena "GAME OVER"
      posiciona_cursor 9,15
      imprime_cadena_color gameover,9,cGrisClaro,bgNegro

      call BORRA_BOTONES

      mov [col_aux],54
      Fondo_A:
      ;Superior
      posiciona_cursor 19,[col_aux]
      imprime_caracter_color 219,cAmarillo,bgNegro
      ;En medio
      posiciona_cursor 20,[col_aux]
      imprime_caracter_color 219,cAmarillo,bgNegro
      ;Inferior
      posiciona_cursor 21,[col_aux]
      imprime_caracter_color 219,cAmarillo,bgNegro
      inc col_aux
      cmp col_aux,64d
      jbe Fondo_A
        
        ;Imprime cadena "Clic En"
        posiciona_cursor 12,16
      imprime_cadena_color mensaje4,7,cGrisClaro,bgNegro
        ;Imprime cadena "Continuar" dentro del marco de la ventana 
      posiciona_cursor 13,15
      imprime_cadena_color continuar,9,cGrisClaro,bgNegro

       ;Imprime cadena "Continuar" en el area de botones 
      posiciona_cursor 20,55
      imprime_cadena_color continuar,9,cRojo,bgAmarillo
      jmp retgameO

    BORRA_BOTONES proc

	call BORRA_BOLA_E
        mov [col_aux],44
        Fondo_N:
      ;Superior
      posiciona_cursor 19,[col_aux]
      imprime_caracter_color 219,cNegro,bgNegro
      ;En medio
      posiciona_cursor 20,[col_aux]
      imprime_caracter_color 219,cNegro,bgNegro
      ;Inferior
      posiciona_cursor 21,[col_aux]
      imprime_caracter_color 219,cNegro,bgNegro
      inc col_aux
      cmp col_aux,71d
      jbe Fondo_N
        ret 
    endp

    BORRA_VENTANA proc
        mov [col_aux],12
        Fondo_N2:
      posiciona_cursor 7,[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      posiciona_cursor 8,[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      posiciona_cursor 9,[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      posiciona_cursor 10,[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      posiciona_cursor 11,[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      posiciona_cursor 12,[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      posiciona_cursor 13,[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      posiciona_cursor 14,[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      posiciona_cursor 15,[col_aux]
      imprime_caracter_color 22,cNegro,bgNegro
      inc col_aux
      cmp col_aux,26d
      jbe Fondo_N2
        ret 
    endp

    BORRAR_VENTANA2 proc
        mov [col_aux],46
        Fondo_N3:
           posiciona_cursor 18,[col_aux]
           imprime_caracter_color 22,cNegro,bgNegro
           inc col_aux
           cmp col_aux,73d
        jbe Fondo_N3

        mov [col_aux],50
        Fondo_N4:
        ;Superior
        posiciona_cursor 20,[col_aux]
        imprime_caracter_color 219,cNegro,bgNegro
        ;En medio
        posiciona_cursor 21,[col_aux]
        imprime_caracter_color 219,cNegro,bgNegro
        ;Inferior
        posiciona_cursor 22,[col_aux]
        imprime_caracter_color 219,cNegro,bgNegro
        inc col_aux
        cmp col_aux,69d
        jbe Fondo_N4

        ret
    endp


    PRINT_VENTANA2 proc 
        call BORRA_BOTONES

        ;Imprime cadena "¿Quieres..." en el area de botones 
        posiciona_cursor 18,46
        imprime_cadena_color pregunta,28,cGrisClaro,bgNegro
        
        mov [col_aux],50
      Fondo_A1:
      ;Superior
      posiciona_cursor 20,[col_aux]
      imprime_caracter_color 219,cAmarillo,bgNegro
      ;En medio
      posiciona_cursor 21,[col_aux]
      imprime_caracter_color 219,cAmarillo,bgNegro
      ;Inferior
      posiciona_cursor 22,[col_aux]
      imprime_caracter_color 219,cAmarillo,bgNegro
      inc col_aux
      cmp col_aux,53d
      jbe Fondo_A1

        ;Imprime cadena "NO" en el area de botones 
      posiciona_cursor 21,51
      imprime_cadena_color cadenaNO,2,cRojo,bgAmarillo

      mov [col_aux],66
      Fondo_A2:
      ;Superior
      posiciona_cursor 20,[col_aux]
      imprime_caracter_color 219,cAmarillo,bgNegro
      ;En medio
      posiciona_cursor 21,[col_aux]
      imprime_caracter_color 219,cAmarillo,bgNegro
      ;Inferior
      posiciona_cursor 22,[col_aux]
      imprime_caracter_color 219,cAmarillo,bgNegro
      inc col_aux
      cmp col_aux,69d
      jbe Fondo_A2

      ;Imprime cadena "SI" en el area de botones 
      posiciona_cursor 21,67
      imprime_cadena_color cadenaSI,2,cRojo,bgAmarillo

        ret 
    endp
   ;procedimiento IMPRIME_BOTON
   ;Dibuja un boton que abarca 3 renglones y 5 columnas
   ;con un caracter centrado dentro del boton
   ;en la posición que se especifique (esquina superior izquierda)
   ;y de un color especificado
   ;Utiliza paso de parametros por variables globales
   ;Las variables utilizadas son:
   ;boton_caracter: debe contener el caracter que va a mostrar el boton
   ;boton_renglon: contiene la posicion del renglon en donde inicia el boton
   ;boton_columna: contiene la posicion de la columna en donde inicia el boton
   ;boton_color: contiene el color del boton
   IMPRIME_BOTON proc
      ;background de botón
      mov ax,0600h      ;AH=06h (scroll up window) AL=00h (borrar)
      mov bh,cRojo      ;Caracteres en color amarillo
      xor bh,[boton_color]
      mov ch,[boton_renglon]
      mov cl,[boton_columna]
      mov dh,ch
      add dh,2
      mov dl,cl
      add dl,2
      int 10h
      mov [col_aux],dl
      mov [ren_aux],dh
      dec [col_aux]
      dec [ren_aux]
      posiciona_cursor [ren_aux],[col_aux]
      imprime_caracter_color [boton_caracter],cRojo,[boton_color]
      ret         ;Regreso de llamada a procedimiento
   endp           ;Indica fin de procedimiento UI para el ensamblador
   
;-------------------------------------------------------------------PARTE ANEXADA----------------
;---------------------------------------------------------IMPRIMIMOS EL LASER DEL JUGADOR----------------------

IMPRIME_BOLAJ_1C proc
		mov ah,[bolaJ_col_1]         
		mov al,[bolaJ_ren_1]        
		mov [col_aux],ah
		mov [ren_aux],al

;POSICIONAMOS PARA IMPRIMIR LASER EN RENGLÓN Y COLUMNA
		posiciona_cursor [ren_aux],[col_aux]

		imprime_caracter_color 176,cAzul,bgNegro
		ret
	endp
;----------------------------------------------------------------
IMPRIME_BOLAJ_2C proc
		mov ah,[bolaJ_col_2]         
		mov al,[bolaJ_ren_2]        
		mov [col_aux],ah
		mov [ren_aux],al

;POSICIONAMOS PARA IMPRIMIR LASER EN RENGLÓN Y COLUMNA
		posiciona_cursor [ren_aux],[col_aux]

		imprime_caracter_color 176,cVerde ,bgNegro
		ret
	endp
;----------------------------------------------------------------
IMPRIME_BOLAJ_3C proc
		mov ah,[bolaJ_col_3]         
		mov al,[bolaJ_ren_3]        
		mov [col_aux],ah
		mov [ren_aux],al

;POSICIONAMOS PARA IMPRIMIR LASER EN RENGLÓN Y COLUMNA
		posiciona_cursor [ren_aux],[col_aux]

		imprime_caracter_color 176,bgAmarillo ,bgNegro
		ret
	endp
;---------------------------------------------------------------
IMPRIME_BOLAJ_1 proc
                guarda_posicionj
		
;POSICIONAMOS PARA IMPRIMIR LASER EN RENGLÓN Y COLUMNA
		
 		dec ren_aux
                dec ren_aux
		dec ren_aux

	        mov ah,[col_aux]       
		mov al,[ren_aux]
		
		mov [bolaJ_col_1],ah
		mov [bolaJ_ren_1] ,al

		posiciona_cursor [ren_aux],[col_aux]

		imprime_caracter_color 176,cAzul,bgNegro
		ret
	endp
;-----------------------
IMPRIME_BOLAJ_2 proc
                guarda_posicionj
		
;POSICIONAMOS PARA IMPRIMIR LASER EN RENGLÓN Y COLUMNA
		
 		dec ren_aux
                dec ren_aux
		dec ren_aux

	        mov ah,[col_aux]       
		mov al,[ren_aux]
		
		mov [bolaJ_col_2],ah
		mov [bolaJ_ren_2] ,al

		posiciona_cursor [ren_aux],[col_aux]

		imprime_caracter_color 176,cVerde ,bgNegro
		ret
	endp
;-----------------------
IMPRIME_BOLAJ_3 proc
                guarda_posicionj
		
;POSICIONAMOS PARA IMPRIMIR LASER EN RENGLÓN Y COLUMNA
		
 		dec ren_aux
                dec ren_aux
		dec ren_aux

	        mov ah,[col_aux]       
		mov al,[ren_aux]
		
		mov [bolaJ_col_3],ah
		mov [bolaJ_ren_3] ,al

		posiciona_cursor [ren_aux],[col_aux]

		imprime_caracter_color 176,bgAmarillo ,bgNegro
		ret
	endp
;----------------------------------------------------------------BORRAMOS EL LASER DEL JUGADOR-----------------------------
;-----------------------BALA(1)
	;Borra la bola de juego, que recibe como parámetros las variables bola_col y bola_ren, que indican la posición de la bola
	BORRA_BOLAJ_1 proc
		mov ah,[bolaJ_col_1]
		mov al,[bolaJ_ren_1]
		mov [col_aux],ah
		mov [ren_aux],al
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 2d,cNegro,bgNegro 
		ret
	endp
;------------------------BALA(2)
;Borra la bola de juego, que recibe como parámetros las variables bola_col y bola_ren, que indican la posición de la bola
	BORRA_BOLAJ_2 proc
		mov ah,[bolaJ_col_2]
		mov al,[bolaJ_ren_2]
		mov [col_aux],ah
		mov [ren_aux],al
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 2d,cNegro,bgNegro 
		ret
	endp
;------------------------BALA(3)
;Borra la bola de juego, que recibe como parámetros las variables bola_col y bola_ren, que indican la posición de la bola
	BORRA_BOLAJ_3 proc
		mov ah,[bolaJ_col_3]
		mov al,[bolaJ_ren_3]
		mov [col_aux],ah
		mov [ren_aux],al
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 2d,cNegro,bgNegro 
		ret
	endp
;-------------------------------------------------------------IMPRESIÓN LASER ENEMIGO---------------

;Imprime la bola de juego, que recibe como parámetros las variables bola_col y bola_ren, que indican la posición de la bola
	IMPRIME_BOLA_E proc
		mov ah,[bolaE_col]        ;ini_columna -> limkeyb _derecho/2   
		mov al,[bolaE_ren]        ;ini_renglon-17 ;renglón de la bola = 22-17 =5
		mov [col_aux],ah
		mov [ren_aux],al

;POSICIONAMOS PARA IMPRIMIR LASER EN RENGLÓN Y COLUMNA
		posiciona_cursor [ren_aux],[col_aux]
;quite 2d
		imprime_caracter_color 177,cRojo,bgNegro
		ret
	endp
;----------------------------------------------------------------BORRAMOS EL LASER

	;Borra la bola de juego, que recibe como parámetros las variables bola_col y bola_ren, que indican la posición de la bola
	BORRA_BOLA_E proc
		mov ah,[bolaE_col]
		mov al,[bolaE_ren]
		mov [col_aux],ah
		mov [ren_aux],al
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 2d,cNegro,bgNegro 
		ret
	endp
;---------------------------------------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;FIN PROCEDIMIENTOS;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end inicio        ;fin de etiqueta inicio, fin de programa