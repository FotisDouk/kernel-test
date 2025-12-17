BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov si, msg
    call print

    ; load stage2 (sectors 2–10)
    mov bx, 0x8000
    mov dh, 0
    mov dl, 0x80
    mov ch, 0
    mov cl, 2
    mov ah, 0x02
    mov al, 8
    int 0x13

    jc disk_error
    jmp 0x0000:0x8000

disk_error:
    hlt

print:
    mov ah, 0x0E
.loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

msg db "Stage 1 Loaded Successfully", 0

times 510 - ($ - $$) db 0
dw 0xAA55
