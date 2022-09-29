#include "p18f4550.inc"

CONFIG FOSC = XT_XT 
CONFIG WDT = OFF
CONFIG LVP = OFF 

VARIABLES UDATA_ACS 0
    CONT1 RES 1 ; counter to delay routine
    CONT2 RES 1 ; counter to delay routine
    CONT RES 1 ; main counter 
    SW1 EQU  .5   ; pin 5
    SW2 EQU  .6	  ; pin 6

RES_VECT CODE 0X0000
   GOTO START 
   MAIN_PROG CODE 

START
    CLRF TRISD ; set PORTD as output
    BSF TRISC, SW1 ; set PORTC pin 5 as input
    BSF TRISC, SW2 ; set PORTC pin 6 as input
    
LOOP  ; main loop
    CALL DELAY1S ; delay 1 second

    BTFSS PORTC, SW1 ; if button 1 is pressed
    INCF COUNT ; increment count
    BTFSS PORTC, SW2 ; if button 2 is pressed
    DECF CONT ; decrement count
    MOVFF  CONT,  PORTD
    
    MOVFF  CONT,  PORTD ; display count on PORTD

GOTO LOOP 

; auxiliary routine to delay 1 second
DELAY1S
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS
    RETURN
 
; auxiliary routine to delay 200 ms
DELAY200MS
    MOVLW .200 
    MOVWF CONT2 
    DELAYM 
	CALL	DELAY200US
	CALL	DELAY200US
	CALL	DELAY200US
	CALL	DELAY200US
	CALL	DELAY200US
	DECFSZ CONT2 
    BRA DELAYM
RETURN

; auxiliary routine to delay 200 us
DELAY200US
    MOVLW .48 
    MOVWF CONT1 
    DELAY
	NOP 
	DECFSZ CONT1 
    BRA DELAY
    BTFSC PORTC, SW1 ;SE O SW1 FOR 0, PULA PARA PRÓXIMA INSTRUÇÃO.
	RETURN
    BTFSC PORTC, SW2 ;;SE O SW2 FOR 0, PULA PARA PRÓXIMA INSTRUÇÃO.
	RETURN
    POP
    POP
RETURN 

END