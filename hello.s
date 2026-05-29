.global _main
.align 2

_main:
  ; This is a comment
  mov x0, #1 ; What is it writing to (stdout)
  adrp x1, hello_str@PAGE
  add x1, x1, hello_str@PAGEOFF ; What is it writing
  mov x2, #14 ; How long is the thing it's writing

  mov x16, #4 ; write, syscall 4
  svc #0x80 ; syscall with 0x80 b/c convention

  mov x0, #0 ; exit with status code "0"

  mov x16, #1 ; exit, syscall 1
  svc #0x80 ; syscall with 0x80 b/c convention

.data
hello_str:
  .ascii "Hello, world!\n"

