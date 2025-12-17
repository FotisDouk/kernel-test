BITS 16
ORG 0x8000

start:
    cli
    lgdt [gdt_desc]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE32:init_pm

[BITS 32]
init_pm:
    mov ax, DATA32
    mov ds, ax
    mov ss, ax
    mov esp, 0x9FC00

    call setup_paging
    call enable_long_mode

    jmp CODE64:kernel_entry

setup_paging:
    ret

enable_long_mode:
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax
    ret

[BITS 64]
kernel_entry:
    extern _start
    call _start
    hlt

gdt:
    dq 0
    dq 0x00AF9A000000FFFF
    dq 0x00AF92000000FFFF

gdt_desc:
    dw gdt_desc - gdt - 1
    dq gdt

CODE32 equ 0x08
DATA32 equ 0x10
CODE64 equ 0x08
