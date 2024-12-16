/*
 * File:   %<%NAME%>%.%<%EXTENSION%>%
 * Author: %<%USER%>%
 *
 * Created on %<%DATE%>%, %<%TIME%>%
 */

    .include "p33fj32mc202.inc"

    ; ____________________Configuration Bits____________________________
    ;User program memory is not write-protected
    #pragma config __FGS, GWRP_OFF & GSS_OFF & GCP_OFF
    
    ;Internal Fast RC (FRC)
    ;Start-up device with user-selected oscillator source
    #pragma config __FOSCSEL, FNOSC_FRC & IESO_ON
    
    ;Both Clock Switching and Fail-Safe Clock Monitor are disabled
    ;XT mode is a medium-gain, medium-frequency mode that is used to work with crystal
    ;frequencies of 3.5-10 MHz
  ; #pragma config __FOSC, FCKSM_CSDCMD & POSCMD_XT
    
    ;Watchdog timer enabled/disabled by user software
    #pragma config __FWDT, FWDTEN_OFF
    
    ;POR Timer Value
    #pragma config __FPOR, FPWRT_PWR128
   
    ; Communicate on PGC1/EMUC1 and PGD1/EMUD1
    ; JTAG is Disabled
    #pragma config __FICD, ICS_PGD1 & JTAGEN_OFF

;..............................................................................
;Program Specific Constants (literals used in code)
;..............................................................................

    .equ SAMPLES, 64         ;Number of samples



;..............................................................................
;Global Declarations:
;..............................................................................

    .global _wreg_init       ;Provide global scope to _wreg_init routine
                                 ;In order to call this routine from a C file,
                                 ;place "wreg_init" in an "extern" declaration
                                 ;in the C file.

    .global __reset          ;The label for the first line of code.

;..............................................................................
;Constants stored in Program space
;..............................................................................

    .section .myconstbuffer, code
    .palign 2                ;Align next word stored in Program space to an
                                 ;address that is a multiple of 2
ps_coeff:
    .hword   0x0002, 0x0003, 0x0005, 0x000A
    
; --- Animación 1 ---
PatronesAnim1:;K-R
.WORD	0X380, 0X1C0, 0X0E0, 0X070, 0X038, 0X01C, 0X00E, 0X007, 0X00E, 0X01C, 0X038, 0X070, 0X0E0, 0X1C0, 0X380, 0X000

; --- Animación 2 ---
PatronesAnim2:;Cortina cierra
.WORD	0X201, 0X303, 0X387, 0X3CF, 0X3FF, 0X000

; --- Animación 3 ---
PatronesAnim3:	;Cortina Abre
.WORD	0X3FF, 0X3CF, 0X387, 0X303, 0X201, 0X000, 0X000

; --- Animación 4 ---
PatronesAnim4:	;Blink
.WORD	0X400, 0X3FF, 0X000

; --- Animación 5 ---
PatronesAnim5:	;vaciado doble
.WORD	0X3FF, 0X3FC, 0X3F0, 0X3C0, 0X300, 0X000
    
; --- Animación 6 ---
PatronesAnim6:	;llenado doble
.WORD	0X300, 0X3C0, 0X3F0, 0X3FC, 0X3FF, 0X000
    
; --- Animación 7 ---
PatronesAnim7:	;llenado incremental
.WORD	0X200, 0X380, 0X3F0, 0X3FF, 0X000
    
; --- Animación 8 ---
PatronesAnim8:	;vaciado incremental
.WORD	0X3FF, 0X3F0, 0X380, 0X200, 0X000




;..............................................................................
;Uninitialized variables in X-space in data memory
;..............................................................................

    .section .xbss, bss, xmemory
x_input: .space 2*SAMPLES        ;Allocating space (in bytes) to variable.



;..............................................................................
;Uninitialized variables in Y-space in data memory
;..............................................................................

    .section .ybss, bss, ymemory
y_input:  .space 2*SAMPLES




;..............................................................................
;Uninitialized variables in Near data memory (Lower 8Kb of RAM)
;..............................................................................

    .section .nbss, bss, near
var1:     .space 2               ;Example of allocating 1 word of space for
                                 ;variable "var1".




;..............................................................................
;Code Section in Program Memory
;..............................................................................

.text                             ;Start of Code section
__reset:
    MOV #__SP_init, W15       ;Initalize the Stack Pointer
    MOV #__SPLIM_init, W0     ;Initialize the Stack Pointer Limit Register
    MOV W0, SPLIM
    NOP                       ;Add NOP to follow SPLIM initialization

    CALL _wreg_init           ;Call _wreg_init subroutine
                                  ;Optionally use RCALL instead of CALL




        ;<<insert more user code here>>


SETM    AD1PCFGL		; PORTB AS DIGITAL
MOV	#0xC00, W0		; Habilitamos RB11 y RB 10 como entradas, el resto salidas
MOV	W0, TRISB				

MOV #0x07, W0			; Habilitamos el puerto A como entrada
MOV W0, TRISA
	
MOV PORTA, W12			; Leemos el dato en el puerto A para controlar las animaciones
AND #0x07, W12				  
MOV W12, W1			; Guardamos en W1
	
MOV PORTB, W12			; Leemos el dato en RB11-RB10 para controlar el retardo
LSR W12, W12			; Desplazamos los bits a la posicion deseada
LSR W12, W12
LSR W12, W12
LSR W12, W12
LSR W12, W12
LSR W12, W12
LSR W12, W12
LSR W12, W12
LSR W12, W12
LSR W12, W12
AND #0x3, W12
MOV W12, W0			; Guardamos en W0
	
; Selección de retardo
;MOV     #1, W0          ; Cargar el caso de retardo en W0 (1 = 500ms, 2 = 350ms, 3 = 100us)
;MOV	#2, W1				  

; Switch de control para seleccionar animaciones
switch_case2:
    CP      W1, #0             ; Comparar W0 con 0
    BRA     Z, Animacion1      ; Selecciona animacion 1
    
    CP      W1, #1             ; Comparar W0 con 1
    BRA     Z, Animacion2    
    
    CP      W1, #2             ; Comparar W0 con 2
    BRA     Z, Animacion3    
    
    CP      W1, #3             ; Comparar W0 con 3
    BRA     Z, Animacion4    
    
    CP      W1, #4             ; Comparar W0 con 4
    BRA     Z, Animacion5    
    
    CP      W1, #5             ; Comparar W0 con 5
    BRA     Z, Animacion6    
    
    CP      W1, #6             ; Comparar W0 con 6
    BRA     Z, Animacion7    
    
    CP      W1, #7             ; Comparar W0 con 7
    BRA     Z, Animacion8    
    
Animacion1:
    ; Setup the address pointer to program space
    MOV #tblpage(PatronesAnim1), W2	    ; get table page value <22:16>
    MOV W2, TBLPAG  ; load TBLPAG register
    BRA AN1	
    
Animacion2:
    ; Setup the address pointer to program space
    MOV #tblpage(PatronesAnim2), W2	    ; get table page value <22:16>
    MOV W2, TBLPAG  ; load TBLPAG register
    BRA AN2
    
Animacion3:
    ; Setup the address pointer to program space
    MOV #tblpage(PatronesAnim3), W2	    ; get table page value <22:16>
    MOV W2, TBLPAG  ; load TBLPAG register
    BRA AN3
    
Animacion4:
    ; Setup the address pointer to program space
    MOV #tblpage(PatronesAnim4), W2	    ; get table page value <22:16>
    MOV W2, TBLPAG  ; load TBLPAG register
    BRA AN4
    
Animacion5:
    ; Setup the address pointer to program space
    MOV #tblpage(PatronesAnim5), W2	    ; get table page value <22:16>
    MOV W2, TBLPAG  ; load TBLPAG register
    BRA AN5
    
Animacion6:
    ; Setup the address pointer to program space
    MOV #tblpage(PatronesAnim6), W2	    ; get table page value <22:16>
    MOV W2, TBLPAG  ; load TBLPAG register
    BRA AN6
    
Animacion7:
    ; Setup the address pointer to program space
    MOV #tblpage(PatronesAnim7), W2	    ; get table page value <22:16>
    MOV W2, TBLPAG  ; load TBLPAG register
    BRA AN7
    
Animacion8:
    ; Setup the address pointer to program space
    MOV #tblpage(PatronesAnim8), W2	    ; get table page value <22:16>
    MOV W2, TBLPAG  ; load TBLPAG register
    BRA AN8

A1:
    CP      W1, #0           ; Comparar W0 con 0
    BRA     Z, AN1
    
    CP      W1, #1           ; Comparar W0 con 1
    BRA     Z, AN2  
    
    CP      W1, #2           ; Comparar W0 con 2
    BRA     Z, AN3
    
    CP      W1, #3           ; Comparar W0 con 3
    BRA     Z, AN4
    
    CP      W1, #4           ; Comparar W0 con 4
    BRA     Z, AN5
    
    CP      W1, #5           ; Comparar W0 con 5
    BRA     Z, AN6
    
    CP      W1, #6           ; Comparar W0 con 5
    BRA     Z, AN7
    
    CP      W1, #7           ; Comparar W0 con 7
    BRA     Z, AN8

AN1:
    MOV	    #tbloffset(PatronesAnim1), W3	    ; load address LS word
    BRA     Z, A2

AN2:
    MOV	    #tbloffset(PatronesAnim2), W3	    ; load address LS word
    BRA     Z, A2
    
AN3:
    MOV	    #tbloffset(PatronesAnim3), W3	    ; load address LS word
    BRA     Z, A2
    
AN4:
    MOV	    #tbloffset(PatronesAnim4), W3	    ; load address LS word
    BRA     Z, A2
    
AN5:
    MOV	    #tbloffset(PatronesAnim5), W3	    ; load address LS word
    BRA     Z, A2
    
AN6:
    MOV	    #tbloffset(PatronesAnim6), W3	    ; load address LS word
    BRA     Z, A2

AN7:
    MOV	    #tbloffset(PatronesAnim7), W3	    ; load address LS word
    BRA     Z, A2  
    
AN8:
    MOV	    #tbloffset(PatronesAnim8), W3	    ; load address LS word
    BRA     Z, A2
    
A2:
    ; Read the program memory location
    TBLRDL  [W3++], W4	    ; Read low word to W4 16 bits
    ;TBLRDL.B  [W1++],		    W4	    ; Read low word to W4 just 8 bits
    CP0	    W4
    BRA	    Z, A1
switch_case:
    CP      W0, #0             ; Comparar W0 con 0
    BRA     Z, delay_500msx6     ; Si W0 == 1, ir a 500ms

    CP      W0, #1           ; Comparar W0 con 1
    BRA     Z, delay_350msx6     ; Si W0 == 2, ir a 350ms

    CP      W0, #2           ; Comparar W0 con 2
    BRA     Z, delay_500ms     ; Si W0 == 3, ir a 100us

; Retorno a 500ms por defecto si no coincide ninguna opción
delay_500msx6:
    MOV     #60000, W7         ; #10000 para 500ms
    BRA     delay_start

delay_350msx6:
    MOV     #42000, W7          ; #7000 para 350ms
    BRA     delay_start

delay_500ms:
    MOV     #10000, W7             ; #2 para 100us
    BRA     delay_start
    
delay_start:
LOOP1:
    CP0	    W7			        ; (1 ciclo)
    BRA	    Z,	    END_DELAY	; (1 ciclo si no hay salto)
    DEC	    W7,	    W7		    ; (1 ciclo)
    
    MOV	    #10,	W8		    ; (1 ciclo)
LOOP2:
    DEC	    W8,	    W8		    ; (1 ciclo)
    CP0	    W8			        ; (1 ciclo)
    BRA	    Z,	    LOOP1	    ; (1 ciclo si no hay salto)
    BRA	    LOOP2		        ; (2 ciclos si hay salto)

END_DELAY:
    NOP

    MOV	    W4,	PORTB
    NOP
    BRA	    A2

done:	        ; Bucle infinito    
    NOP
    BRA     switch_case2         ; Repetir para permitir selección continua

;..............................................................................
;Subroutine: Initialization of W registers to 0x0000
;..............................................................................

_wreg_init:
    CLR W0
    MOV W0, W14
    REPEAT #12
    MOV W0, [++W14]
    CLR W14
    RETURN




;--------End of All Code Sections ---------------------------------------------

.end                               ;End of program code in this file