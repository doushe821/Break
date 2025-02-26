.model tiny
.186
.data 
UserInput db 0FFH
          db 0h  
          db 09H dup(0)

Decision:
            db 0eah
ofs         dw 0h 
segm        dw 0h

.code
org 100h

locals ll 


main:
    mov cs:[ofs], offset  llWrong
    mov cs:[segm], cs
    mov bx, offset Decision ; 01DC

    mov dx, offset InitialMessage
    mov ah, 09h
    int 21h

    call ReadUserInput

    mov dx, offset Confirmation
    mov ah, 09h
    int 21h 

llConfirmation:
    in al, 60h
    cmp al, 29h
jne llConfirmation

    mov di, offset Password
    mov dx, cs 
    mov es, dx 

    mov ds, dx
    mov si, offset UserInput + 2h

    mov cx, 9h
    
    repe cmpsb
    je llRight ; 0142 - 66, 01

    jmp Decision ; 01FF

    llWrong:
    mov dx, offset IncorrectInput
    mov ah, 09h
    int 21h 

    mov ax, 4c00h
    int 21h


llRight: ;0165
    mov dx, offset CorrectInput
    mov ah, 09h 
    int 21h

    mov ax, 4c00h 
    int 21h


ReadUserInput proc 

    mov ah, 0Ah
    mov dx, offset UserInput
    int 21h

    ret 

endp 


Password db 'I am crab'
WrongInput db 'Wrong password!$'
CorrectInput db 0ah, 0dh, 'Correct! Now get boiled.$'
IncorrectInput db 0ah, 0dh, 0ah, 0dh, 'Loser. Bye.$'
Confirmation db 0ah, 0dh, 'Press tilda to continue:$'
InitialMessage db 'Greetings! This is a vulnerable program.', 0Ah, 0Dh, 'Enter the password:$'


end main