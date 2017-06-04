BITS 16

start:
  ;; Set up 4K of stack space after the bootloader.
  mov ax, 07C0h
  ;; (4096 + 512) / 16 bytes per paragraph.
  add ax, 288
  mov ss, ax
  ;; Set the stack pointer to the top of the stack.
  mov sp, 4096

  ;; Set the start of the data segment to the load location.
  mov ax, 07c0h
  mov ds, ax

  ;; Set up the video mode for color output.
  ;; 80x30 8x16 640x480 16 colors
  mov ah, 00h ; Interrupt function code.
  mov al, 12h ; Mode argument.
  int 10h
  ;; Set up a background color.
  mov ah, 0Bh ;; Interrupt function code.
  mov bh, 00h ;; Interrupt function code.
  mov bl, 01h ;; Function argument goes in bh.
  int 10h

  mov si, text_string
  call print_string

  jmp $

  text_string db "Welcome to the Emmarating Opersystem (EmmaOS)!", 0

print_string:
  mov ah, 0Eh
  mov bl, 0Eh
  .repeat:
    lodsb
    cmp al, 0
    je .done
    int 10h
    jmp .repeat
  .done
    ret

times 510-($-$$) db 0
dw 0xAA55
