; Vernamova sifra na architekture DLX
; ilia iudenkov xiuden00
; ('iuiuiu' is key {+9 -21 +9 -21 +9 -21}) DO NOT ENCRYPT NUMBERS
; gndins

        .data 0x04          ; zacatek data segmentu v pameti
login:  .asciiz "xiuden00"  ; <-- nahradte vasim loginem   xiuden00-r4-r8-r9-r13-r16-r0
cipher: .space 9            ; sem ukladejte sifrovane znaky (za posledni nezapomente dat 0)
                            ; 9 bytes rezerved for cipher (fndins***) (last 0 to ouptut)

        .align 2            ; dale zarovnavej na ctverice (2^2) bajtu
laddr:  .word login         ; 4B adresa vstupniho textu (pro vypis)
caddr:  .word cipher        ; 4B adresa sifrovaneho retezce (pro vypis)

        .text 0x40          ; adresa zacatku programu v pameti
        .global main        ; xiuden00-r4-r8-r9-r13-r16-r0

main:   ; sem doplnte reseni Vernamovy sifry dle specifikace v zadani

        addi r4, r0, 0      ; index
        addi r8, r0, 1      ; parity
        addi r16, r0, 0     ; T/F flag

        lb r9, login(r4)    ; r9 now has login symbol
loop:
        lb r9, login(r4)    ; r9 now has login symbol
        slti r16, r9, 96    ; if login symbol < 96
        bnez r16, end       ; then stop

        seqi r16, r8, 2     ; else (if parity == 2)
        bnez r16, par       ; then execute par
        nop
        addi r8, r8, 1      ; else (parity == 1) -> increment parity
        addi r9, r9, 9      ; encrypt login symbol
        slti r16, r9, 122   ; check if symbol is in ascii table (if < 122)
        bnez r16, true      ; if lower then just store it in cipher[i]
        nop
        subi r9, r9, 26     ; if greater sub 26 (offser)
        sb cipher(r4), r9   ; sctore encrypted symbol in ciper[i]


        addi r4, r4, 1      ; increment counter
        j loop              ; repeat cykle
        nop

true:
        sb cipher(r4), r9   ; store encrypted symbol
        addi r4, r4, 1      ; inc counter
        j loop              ; repeat cykle
        nop

par:
        subi r8, r8, 1      ; decrement parity
        subi r9, r9, 21     ; substract 21 from login symbol
        sgti r16, r9, 97    ; check if encrypted symbol is in ASCII
        bnez r16, true      ; if it is then store the encrypted value
        nop
        addi r9, r9, 26     ; if not -> offset
        sb cipher(r4), r9   ; save encrypted data
        addi r4, r4, 1      ; inc counter
        j loop              ; repeat cykle
        nop

end:    addi r14, r0, caddr ; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5  ; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  ; ukonceni simulace
