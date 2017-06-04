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
  mov bl, 01h ;; Function argument goes in bl.
  int 10h

  mov dh, 10
  mov dl, 17
  call move_cursor
  mov si, banner_1
  call print_string
  mov dh, 11
  mov dl, 17
  call move_cursor
  mov si, banner_2
  call print_string
  mov dh, 12
  mov dl, 17
  call move_cursor
  mov si, banner_3
  call print_string
  mov dh, 13
  mov dl, 17
  call move_cursor
  mov si, banner_4
  call print_string
  mov dh, 14
  mov dl, 17
  call move_cursor
  mov si, banner_5
  call print_string
  
  jmp $

  text_string db "Emmarating Opersystem", 0

banner_1 db " _____                            ___  ____  ", 0
banner_2 db "| ____|_ __ ___  _ __ ___   __ _ / _ \/ ___| ", 0
banner_3 db "|  _| | '_ ` _ \| '_ ` _ \ / _` | | | \___ \ ", 0
banner_4 db "| |___| | | | | | | | | | | (_| | |_| |___) |", 0
banner_5 db "|_____|_| |_| |_|_| |_| |_|\__,_|\___/|____/ ", 0

;; Prints a string whose pointer is in the si register to the screen.
print_string:
  mov ah, 0Eh
  mov bl, 0Eh
  .repeat:
    lodsb
    cmp al, 0
    je .done
    int 10h
    jmp .repeat
  .done:
    ret

;; Move to a new line and carraige return.
increment_line:
  mov ah, 03h
  int 10h
  add dh, 1
  mov dl, 0
  mov ah, 02h
  mov bh, 00h
  int 10h
  ret

;; Prints a string from si and moves to the next line.
print_line:
  call print_string
  call increment_line


;; Move the text cursor to the given location on the screen.
;; dh: The y coordinate (row)
;; dl: The x coordinate (column)
move_cursor:
  mov ah, 02h
  mov bh, 00h
  int 10h
  ret

times 510-($-$$) db 0
dw 0xAA55
