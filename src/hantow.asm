; TOWERS OF HANOI

%include "asm_io.inc"

; ========== DATA SECTION =========== ;
SECTION .data

peg1: dd 0,0,0,0,0,0,0,0,9    ; array for peg 1
peg2: dd 0,0,0,0,0,0,0,0,9    ; array for peg 2
peg3: dd 0,0,0,0,0,0,0,0,9    ; array for peg 3

iNerror:  db "Error: Incorrect Argument", 0, 10                                                ; error message
NeAerror: db "Error: Not enough arguments", 0, 10                                              ; error message
TmAerror: db "Error: Too many arguments", 0, 10                                                ; error message
iAerror:  db "Error: Argument out of range", 0, 10                                             ; error message
base: db "   XXXXXXXXX|XXXXXXXXX      XXXXXXXXX|XXXXXXXXX      XXXXXXXXX|XXXXXXXXX", 0, 10     ; bases for pegs
done: db "                                    DONE                                 ", 0, 10    ; done message

; ========== BSS SECTION ========== ;
SECTION .bss
line: resb 80   ; space for each line to print
N: resd 3       ; space for each peg

; ========== TEXT SECTION ========== ;
SECTION .text
    global  asm_main

; line1
; The following was given by the professor
line1:
    enter 0,0    ; setup routine
    pusha        ; save all registers

    mov ebx, [ebp+8]         ; address of N1
    mov ecx, dword [ebx]     ; ecx=N1
    mov [N], ecx             ; remember N1
    add ebx, dword 36        ; address of N2
    mov ecx, dword [ebx]     ; ecx=N2
    mov [N+4], ecx           ; remember N2
    add ebx, dword 36        ; address of N3
    mov ecx, dword [ebx]     ; ecx=N3
    mov [N+8], ecx           ; remember N3
    mov ecx, line            ; pointer to line

    mov edi, N
    mov esi, 0

    LOOP:                           ; loops to print each line for each peg
        mov ebx, 12
        sub ebx, dword [edi]
        mov eax, 0

        L11:
            mov [ecx], byte ' '     ; prints the appropriate number of spaces
            inc eax
            inc ecx
            cmp eax, ebx
        jb L11

        mov eax, 1                  ; prints the appropriate numbers of +'s
        L12:
            cmp eax, dword [edi]
            ja L12END
            mov [ecx], byte '+'
            inc eax
            inc ecx
        jmp L12

        L12END:
            mov [ecx], byte '|'     ; prints a |
            inc ecx
            mov eax, 1              ; prints the appropriate numbers of +'s

        L13:
            cmp eax, [edi]
            ja L13END
            mov [ecx], byte '+'
            inc eax
            inc ecx
        jmp L13

        L13END:
            mov eax, 0              ; prints the appropriate number of spaces

        L14:
            mov [ecx], byte ' '
            inc ecx
            inc eax
            cmp eax, ebx
        jb L14

    LOOP_END:                       ; check if end loop
        add esi, dword 1
        add edi, 4
        cmp esi, dword 3
    jb LOOP                         ; loop again

    mov eax, line                   ; eax = line
    call print_string               ; print the string
    call print_nl                   ; print new line

    popa                            ; restore stack
    leave                           ; leave procedure
    ret                             ; return to calling procedure

; invalidArg
; Displays an error message after the user gives a wrong input (ex. 1, 9, hello, etc.).
invalidArg:
    mov eax, iAerror    ; eax = error message
    call print_string   ; display error message
    call print_nl       ; print new line
    call print_nl       ; print new line
    popa                ; restore the stack
    mov eax, 0          ; eax = 0
    leave               ; leave the program
    ret                 ; terminate the program

; incorrectArg
; Displays an error message after the user gives a wrong input (ex. 1 2, 2 3, etc.).
incorrectArg:
    mov eax, iNerror    ; eax = error message
    call print_string   ; display error message
    call print_nl       ; print new line
    call print_nl       ; print new line
    popa                ; restore the stack
    mov eax, 0          ; eax = 0
    leave               ; leave the program
    ret                 ; terminate the program

; tooManyArgs
; Displays an error message after the user gives a wrong input (ex. 1 2, 2 3, etc.).
tooManyArgs:
    mov eax, TmAerror   ; eax = error message
    call print_string   ; display error message
    call print_nl       ; print new line
    call print_nl       ; print new line
    popa                ; restore the stack
    mov eax, 0          ; eax = 0
    leave               ; leave the program
    ret                 ; terminate the program

; notEnoughArgs
; Displays an error message after the user does not give an input.
notEnoughArgs:
    mov eax, NeAerror   ; eax = error message
    call print_string   ; display error message
    call print_nl       ; print new line
    call print_nl       ; print new line
    popa                ; restore the stack
    mov eax, 0          ; eax = 0
    leave               ; leave the program
    ret                 ; terminate the program

; print
; Prints the pegs in a nice way for the user.
print:
    push ebp                ; push base pointer onto stack
    mov ebp, esp            ; move base pointer to top of stack

    mov ebx, dword 28       ; ebx = 28 [count]
    mov ecx, dword 0        ; ecx = 0  [index]
    doPrint:
        mov eax, peg1       ; eax = peg1
        add eax, ecx        ; eax += ecx (the index of the pegs to print)
        push eax            ; push eax onto stack
        call line1          ; call line1
        add ecx, 4          ; ecx += 4
        add esp, 4          ; pop stack
        cmp ecx, ebx        ; loop if ecx < ebx
    jbe doPrint             ; jump before doPrint

    mov eax, base           ; eax = base
    call print_string       ; print base
    call print_nl           ; print new line
    call print_nl           ; print new line

    mov esp, ebp            ; restore stack  pointer
    pop ebp                 ; restore base pointer
    ret                     ; return back to caller

; hanoi
; The algorithm that does the recursive solution to the problem.
hanoi:
    push ebp               ; push base pointer onto stack
    mov ebp, esp           ; move base pointer to top of stack
    mov eax, [ebp+8]       ; eax = n
    cmp eax, dword 0       ; end if n = 0
    jle hanoi_end          ; jump to hanoi_end

    dec eax                ; n -= 1
    push dword [ebp+16]    ; dest peg
    push dword [ebp+20]    ; help peg
    push dword [ebp+12]    ; orig peg
    push dword eax         ; n - 1
    call hanoi             ; hanoi(n-1, orig, help, dest)

    add esp, 16            ; fix stack
    push dword [ebp+16]    ; from peg
    push dword [ebp+12]    ; to peg
    call moveDisc          ; move disc from peg to peg

    add esp, 8             ; fix stack
    mov eax, [ebp+8]       ; eax = n
    dec eax                ; n -= 1
    push dword [ebp+12]    ; orig peg
    push dword [ebp+16]    ; dest peg
    push dword [ebp+20]    ; help peg
    push dword eax         ; n - 1
    call hanoi             ; hanoi(n-1, help, dest, orig)

    add esp,16             ; fix stack

hanoi_end:
    mov esp, ebp           ; restore stack pointer
    pop ebp                ; pop base pointer
    ret                    ; return to calling procedure

; moveDisc
; Moves a disc from the from peg (first argument) the the to peg (second argument).
moveDisc:
    push ebp                        ; push base pointer onto stack
    mov ebp, esp                    ; move base pointer to top of stack
    mov eax, [ebp+8]                ; eax = first peg arg
    mov ecx, dword 0                ; index for eax
    mov edx, dword 0                ; index for ebx

    findDisc1:
        cmp edx, [eax+ecx]          ; loop if edx < eax[i]
        jl foundDisc1               ; jump to foundDisc1
        add ecx, 4                  ; ecx += 4 (because index is memory address)
    jmp findDisc1                   ; loop again

    foundDisc1:
        mov ebx, [eax+ecx]          ; ebx = disc1
        mov [eax+ecx], dword 0      ; replace disc1 with nothing
        mov eax, [ebp+12]           ; eax = second arg peg
        mov ecx, dword 0            ; index for eax

        findDisc2:
            cmp edx, [eax+ecx]      ; loop if edx < eax[i]
            jl foundDisc2           ; jump to foundDisc2
            add ecx, 4              ; ecx += 4 (because index is memory address)
        jmp findDisc2               ; loop again

    foundDisc2:
        sub ecx, 4                  ; ecx -= 4 (because we want the next empty disc, not current occupied one)
        mov [eax+ecx], ebx          ; second peg arg gets disc1

    call read_char                  ; wait for user to click ENTER
    call print                      ; call print routine

    mov esp, ebp                    ; restore stack  pointer
    pop ebp                         ; restore base pointer
    ret                             ; return back to caller

; ========== MAIN ========== ;
asm_main:
    enter 0,0                       ; setup routine
    pusha                           ; save all registers
    call print_nl                   ; print new line

	; get and check the argument that the user enters to make sure it is valid
    mov eax, dword [ebp+8]          ; eax = address of 1st arg
    cmp eax, dword 2                ; compare eax with 2
    ja tooManyArgs                  ; throw error tooManyArgs
    jb notEnoughArgs                ; throw error notEnoughArgs
    mov ebx, dword [ebp+12]         ; ebx += 4
    add ebx, 4                      ; ebx = address of 2ng arg
    mov ebx, dword [ebx]            ; ebx = ebx
    add ebx, 1                      ; ebx += 1
    mov ecx, 0                      ; ecx = 0
    mov cl, [ebx]                   ; move byte
    cmp ecx, byte 0                 ; cmp ecx with 0
    jne incorrectArg                ; throw incorrectArg
    sub ebx, 1                      ; ebx -= 1
    mov ecx, 0                      ; ecx = 0
    mov cl, [ebx]                   ; move byte
    cmp ecx, byte '2'               ; compare ecx with 2
    jb invalidArg                   ; throw invalidArg if ecx < 2
    cmp ecx, byte '8'               ; compare ecx with 8
    ja invalidArg                   ; throw invalidArg if ecx > 8
    sub ecx, byte '0'               ; convert to numeric value
    mov eax, ecx                    ; eax = arg (for later)
    mov edx, ecx                    ; edx = arg (for later)

    ; create the peg1 array with the first argument if it is a valid argument
    mov ebx, dword 1                ; ebx = 1 [count]
    mov ecx, dword 28               ; ecx = 28 [index]
    createPeg:                      ; loop createPeg
        mov [peg1+ecx], eax         ; peg1[ecx] = eax
        sub eax, dword 1            ; eax -= 1
        sub ecx, dword 4            ; ecx -= 4 [index]
        cmp ebx, eax                ; loop if ebx < eax
    jbe createPeg                   ; jump before createPeg

    ; call the hanoi routine to find the solution
    call print                      ; print the initial peg set up
    push peg3                       ; help peg
    push peg2                       ; dest peg
    push peg1                       ; orig peg
    push edx                        ; n
    call hanoi                      ; hanoi(n, orig, dest, help)
    add esp, 16                     ; fix stack

    mov eax, done                   ; eax = done
    call print_string               ; print done message
    call print_nl                   ; print new line
    call print_nl                   ; print new line

    popa                            ; restore all registers
    mov eax, 0                      ; eax = 0
    leave                           ; leave the program
    ret                             ; terminate the program

; END
