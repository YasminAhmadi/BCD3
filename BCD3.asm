%ifndef SYS_EQUAL
%define SYS_EQUAL
    sys_read     equ     0
    sys_write    equ     1
    sys_open     equ     2
    sys_close    equ     3
   
    sys_lseek    equ     8
    sys_create   equ     85
    sys_unlink   equ     87
     

    sys_mmap     equ     9
    sys_mumap    equ     11
    sys_brk      equ     12
   
     
    sys_exit     equ     60
   
    stdin        equ     0
    stdout       equ     1
    stderr       equ     3

 
 
    PROT_READ     equ   0x1
    PROT_WRITE    equ   0x2
    MAP_PRIVATE   equ   0x2
    MAP_ANONYMOUS equ   0x20
   
    ;access mode
    O_RDONLY    equ     0q000000
    O_WRONLY    equ     0q000001
    O_RDWR      equ     0q000002
    O_CREAT     equ     0q000100
    O_APPEND    equ     0q002000

   
; create permission mode
    sys_IRUSR     equ     0q400      ; user read permission
    sys_IWUSR     equ     0q200      ; user write permission

    NL            equ   0xA
    Space         equ   0x20

%endif
;----------------------------------------------------
newLine:
   push   rax
   mov    rax, NL
   call   putc
   pop    rax
   ret
;---------------------------------------------------------
putc:

   push   rcx
   push   rdx
   push   rsi
   push   rdi
   push   r11

   push   ax
   mov    rsi, rsp    ; points to our char
   mov    rdx, 1      ; how many characters to print
   mov    rax, sys_write
   mov    rdi, stdout
   syscall
   pop    ax

   pop    r11
   pop    rdi
   pop    rsi
   pop    rdx
   pop    rcx
   ret
;---------------------------------------------------------
writeNum:
   push   rax
   push   rbx
   push   rcx
   push   rdx

   sub    rdx, rdx
   mov    rbx, 10
   sub    rcx, rcx
   cmp    rax, 0
   jge    wAgain
   push   rax
   mov    al, '-'
   call   putc
   pop    rax
   neg    rax  

wAgain:
   cmp    rax, 9
   jle    cEnd
   div    rbx
   push   rdx
   inc    rcx
   sub    rdx, rdx
   jmp    wAgain

cEnd:
   add    al, 0x30
   call   putc
   dec    rcx
   jl     wEnd
   pop    rax
   jmp    cEnd
wEnd:
   pop    rdx
   pop    rcx
   pop    rbx
   pop    rax
   ret

;---------------------------------------------------------
getc:
   push   rcx
   push   rdx
   push   rsi
   push   rdi
   push   r11

 
   sub    rsp, 1
   mov    rsi, rsp
   mov    rdx, 1
   mov    rax, sys_read
   mov    rdi, stdin
   syscall
   mov    al, [rsi]
   add    rsp, 1

   pop    r11
   pop    rdi
   pop    rsi
   pop    rdx
   pop    rcx

   ret
;---------------------------------------------------------

readNum:
   push   rcx
   push   rbx
   push   rdx

   mov    bl,0
   mov    rdx, 0
rAgain:
   xor    rax, rax
   call   getc
   cmp    al, '-'
   jne    sAgain
   mov    bl,1  
   jmp    rAgain
sAgain:
   cmp    al, NL
   je     rEnd
   cmp    al, ' ' ;Space
   je     rEnd
   sub    rax, 0x30
   imul   rdx, 10
   add    rdx,  rax
   xor    rax, rax
   call   getc
   jmp    sAgain
rEnd:
   mov    rax, rdx
   cmp    bl, 0
   je     sEnd
   neg    rax
sEnd:  
   pop    rdx
   pop    rbx
   pop    rcx
   ret

;-------------------------------------------
printString:
    push    rax
    push    rcx
    push    rsi
    push    rdx
    push    rdi

    mov     rdi, rsi
    call    GetStrlen
    mov     rax, sys_write  
    mov     rdi, stdout
    syscall
   
    pop     rdi
    pop     rdx
    pop     rsi
    pop     rcx
    pop     rax
    ret
;-------------------------------------------
; rsi : zero terminated string start
GetStrlen:
    push    rbx
    push    rcx
    push    rax  

    xor     rcx, rcx
    not     rcx
    xor     rax, rax
    cld
    repne   scasb
    not     rcx
    lea     rdx, [rcx -1]  ; length in rdx

    pop     rax
    pop     rcx
    pop     rbx
    ret
;-------------------------------------------


section .data
        Perfect db 'Perfect'
        space db ' ',0
        Nope db 'Nope'
        newline db 0ah
section .bss
        num1: resb 4
        num2: resb 4
section .text
        global _start

_start:
       
call readNum
        mov [num1], rax
        mov r9,[num1]
        ;call writeNum
        xor r13, r13
        mov rax, r9
        mov r8, 100000000000
        div r8
        mov r15, rdx
        mov r12, rax
        mov r9, rax
        mov r11, 8
        mov rax, r12
        mul r11
 
        ;call writeNum
        add r13, rax

        mov rax, r15
        mov r8, 10000000000
        div r8
        mov r15, rdx
        mov r12, rax
        mov r9, rax
        mov r11, 4
        mov rax, r12
        mul r11

        ;call writeNum
        add r13, rax
       
        mov rax, r15
        mov r8, 1000000000
        div r8
        mov r15, rdx
        mov r12, rax
        mov r9, rax
        mov r11, 2
        mov rax, r12
        mul r11
       
        ;call writeNum
        add r13, rax
       
        mov rax, r15
        mov r8, 100000000
        div r8
        mov r15, rdx
        mov r12, rax
        mov r9, rax
        mov r11, 1
        mov rax, r12
        mul r11
       
        ;call writeNum
        add r13, rax
        mov rax, r13
        ;call writeNum
       
        ;sadgan r13
        ;adade decimal nahaee dar r14 pas r13 x 100 ra dar r14 mirizim
        mov r11, 100
        mov rax, r13
        mul r11
        xor r14, r14
        mov r14, rax
        ;call writeNum
        ;hala dar r13 dahgan ra mirizim
        xor r13, r13

       
        mov rax, r15
        mov r8, 10000000
        div r8
        mov r15, rdx
        mov r12, rax
        mov r9, rax
        mov r11, 8
        mov rax, r12
        mul r11
       
        ;call writeNum
        add r13, rax
        mov rax, r13
        ;call writeNum
       
       
        mov rax, r15
        mov r8, 1000000
        div r8
        mov r15, rdx
        mov r12, rax
        mov r9, rax
        mov r11, 4
        mov rax, r12
        mul r11
       
        ;call writeNum
        add r13, rax
        mov rax, r13
        ;call writeNum
       
       
        mov rax, r15
        mov r8, 100000
        div r8
        mov r15, rdx
        mov r12, rax
        mov r9, rax
        mov r11, 2
        mov rax, r12
        mul r11
       
        ;call writeNum
        add r13, rax
        mov rax, r13
        ;call writeNum
       
        mov rax, r15
        mov r8, 10000
        div r8
        mov r15, rdx
        mov r12, rax
        mov r9, rax
        mov r11, 1
        mov rax, r12
        mul r11
       
        ;call writeNum
        add r13, rax
        mov rax, r13
        ;call writeNum
       
        ;dahgan r13
        ;adade decimal nahaee dar r14 pas r13 x 10 ra be r14 ezafe mikonim
        mov r11, 10
        mov rax, r13
        mul r11
        add r14, rax
        ;call writeNum
        ;hala dar r13 dahgan ra mirizim
        xor r13, r13
        mov rax, r14
        ;call writeNum


        mov rax, r15
        mov r8, 1000
        div r8
        mov r15, rdx
        mov r12, rax
        mov r9, rax
        mov r11, 8
        mov rax, r12
        mul r11
       
        ;call writeNum
        add r13, rax
        mov rax, r13
        ;call writeNum
       
       
        mov rax, r15
        mov r8, 100
        div r8
        mov r15, rdx
        mov r12, rax
        mov r9, rax
        mov r11, 4
        mov rax, r12
        mul r11
       
        ;call writeNum
        add r13, rax
        mov rax, r13
        ;call writeNum


        mov rax, r15
        mov r8, 10
        div r8
        mov r15, rdx
        mov r12, rax
        mov r9, rax
        mov r11, 2
        mov rax, r12
        mul r11
       
        ;call writeNum
        add r13, rax
        mov rax, r13
        ;call writeNum
       

        mov rax, r15
        mov r8, 1
        div r8
        mov r15, rdx
        mov r12, rax
        mov r9, rax
        mov r11, 1
        mov rax, r12
        mul r11
       
         
        add r13, rax
        mov rax, r13

        ;yekan r13
        ;adade decimal nahaee dar r14 pas r13 ra be r14 ezafe mikonim
        mov r11, 10
        mov rax, r13
        add r14, rax
       
        ;r14 contains the answer but decimal
        ;now we have to convert decimal to binary
        xor r13, r13
        mov rax, r14
        mov r8, r14
        mov r10, 2
     
        xor r12, r12
        xor r13, r13
        inc r13
        mov r15, 10
        ;everytime we get a remainder in the BDC to Binary process,
        ;we cant just print it because we find them in reverse order
        ;so we store them somewhere (r14)
        ;the way we store them is each time we multiply the number by
        ;10^(n) and add it to sum (r14) then 10^(n) x 10 --> 10^(n+1)
        xor r14, r14
        jmp loop
loop:
        mov rax,r8
        ;call writeNum
        xor rdx, rdx
        div r10
        xor r11, r11
        cmp rax, r11
        je ex
        ;if the divisor becomes 0 we are done => go to ex to do the one last thing
        ;add the last remaineder (which resulted in the 0 divisor) to r14(sum)
        mov r8, rax
        mov rax,rdx
        ;call writeNum
        mul r13
        add r14, rax
        mov rax, r13
        mul r15
        mov r13, rax
        ;call writeNum
        jmp loop
 
ex:  
        mov rax, rdx
        ;we just have to add the last divisor to r14
        ;(after multiplying by the corrosponding 10^(n) --> r13 )
        mul r13
        add r14, rax
        mov rax, r14
        call writeNum
        jmp Exit
Exit:
        call newLine
        mov rax, 1
        mov rbx, 0
        int 0x80
