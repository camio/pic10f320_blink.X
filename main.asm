; Blink an LED on output 2

PROCESSOR 10F320
    
; CONFIG
  CONFIG  FOSC = INTOSC         ; Oscillator Selection bits (INTOSC oscillator: CLKIN function disabled)
  CONFIG  BOREN = OFF           ; Brown-out Reset Enable (Brown-out Reset disabled)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable (WDT disabled)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = OFF           ; MCLR Pin Function Select bit (MCLR pin function is digital input, MCLR internally tied to VDD)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  LVP = OFF             ; Low-Voltage Programming Enable (High-voltage on MCLR/VPP must be used for programming)
  CONFIG  LPBOR = OFF           ; Brown-out Reset Selection bits (BOR disabled)
  CONFIG  BORV = LO             ; Brown-out Reset Voltage Selection (Brown-out Reset Voltage (Vbor), low trip point selected.)
  CONFIG  WRT = OFF             ; Flash Memory Self-Write Protection (Write protection off)

#include <xc.inc>

PSECT resetVec,class=CODE
resetVec:
    goto    main
    
PSECT code
main:
    BCF IRCF0 ; Set frequency to 31 kHz
    BCF IRCF1
    BCF IRCF2
    
    ; Note that the timer operates based on Fosc/4. That is 4 oscillations is one tick in the timer.
    
    BCF T0CS   ; Enable timer 0
    BCF TMR0IE ; Disable timer 0 interrupt
    BSF PS0    ; Set prescaler to 1:16
    BSF PS1
    BCF PS2
    BCF PSA    ; Enable prescaler
    CLRF TMR0  ; clear the timer
    
    BCF TRISA2 ; Set RA2 to output mode
    BCF LATA2  ; Set RA2 low
    
loop:
    BTFSS TMR0IF
    GOTO loop
    BCF TMR0IF
    
    MOVLW LATA_LATA2_MASK ; toggle RA2
    XORWF LATA, F
    
    GOTO loop
    
END resetVec