#include "p18f4550.inc"
; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
CONFIG  FOSC = XT_XT ; Oscillator com Cristal de 4 MHz
CONFIG  WDT = OFF    ; Watchdog Timer Enable bit (WDT enabled)
CONFIG  LVP = OFF    ; Single-Supply ICSP Enable bit
  
VARIABLES UDATA_ACS 0
    CONT2m   RES 1 ; Variavel auxiliar para contagem de 2 ms
    CONT500m RES 1 ; Variavel auxiliar para contagem de 500 ms
    CONT RES 1 ; main counter 
    SW1 EQU  .5   ; pin 5
    SW2 EQU  .6	  ; pin 6

    
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

MAIN_PROG CODE                      ; let linker place main program

START
    CLRF TRISD ; set PORTD as output
    BSF TRISC, SW1 ; set PORTC pin 5 as input
    BSF TRISC, SW2 ; set PORTC pin 6 as input
    
LOOP  ; main loop
    CALL DELAY1s ; delay 1 second

    BTFSS PORTC, SW1 ; if button 1 is pressed
    INCF CONT ; increment count
    BTFSS PORTC, SW2 ; if button 2 is pressed
    DECF CONT ; decrement count
    MOVFF  CONT,  PORTD
    
    MOVFF  CONT,  PORTD ; display count on PORTD

GOTO LOOP 

; auxiliary routine to delay 1 second
DELAY1s
    CALL	DELAY500Ms
    CALL	DELAY500Ms
    RETURN
 
DELAY500Ms ; Subrotina que gera atraso de 500 ms
    MOVLW .250
    MOVWF CONT500m ; Carrega contador para 250 interações
LOOP500m   ; Inicio d92o loop
    CALL DELAY2m ; Espera 2 ms
    DECFSZ CONT500m
    GOTO LOOP500m ; Repete interações até que CONTA500 = 0
    RETURN

DELAY2m ; Subrotina que gera atraso de 2 ms
    MOVLW .152
    MOVWF CONT2m ; Carrega contador para 200 interações
LOOP2m      ; Inicio do loop    
    NOP      ; 10 NOPs -> 10 us
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    DECFSZ CONT2m
    GOTO LOOP2m  ; Repete interações até que CONTA2 = 0
    RETURN    
    
END