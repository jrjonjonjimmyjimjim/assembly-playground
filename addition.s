.global _main
.align 2

_main:

  adrp x1, first_operand_str@PAGE
  add x1, x1, first_operand_str@PAGEOFF
  mov x2, #32 ; How long is the thing it's writing
  bl print_str

  adrp x1, first_operand_buffer@PAGE
  add x1, x1, first_operand_buffer@PAGEOFF
  mov x2, #63 ; How long is the thing it's reading
  bl read_str

  adrp x1, first_operand_buffer@PAGE
  add x1, x1, first_operand_buffer@PAGEOFF
  ldr x24, [x1]
  sub x19, x24, #48

  adrp x1, second_operand_str@PAGE
  add x1, x1, second_operand_str@PAGEOFF
  mov x2, #33 ; How long is the thing it's writing
  bl print_str

  adrp x1, second_operand_buffer@PAGE
  add x1, x1, second_operand_buffer@PAGEOFF
  mov x2, #63 ; How long is the thing it's reading
  bl read_str

  adrp x1, second_operand_buffer@PAGE
  add x1, x1, second_operand_buffer@PAGEOFF
  ldr x23, [x1]
  sub x20, x23, #48


  add x21, x19, x20
  add x21, x21, #48
  adrp x1, output_str@PAGE
  add x1, x1, output_str@PAGEOFF
  str x21, [x1]


  mov x2, #63 ; How long is the thing it's writing
  bl print_str

  ; The string has now been dumped into first_operand_buffer
  ; Subtract 48 from character at position 0. Store in X19-X28
  ; Call read for second_operand_buffer
  ; The string has now been dumped into second_operand_buffer
  ; Subtract 48 from character at position 0. Store in X19-X28
  ; Execute add, store result in X19-X28
  ; Add 48 to result
  ; Dump result into output_str





  mov x0, #0 ; exit with status code "0"

  mov x16, #1 ; exit, syscall 1
  svc #0x80 ; syscall with 0x80 b/c convention

read_str: ; Read a string from stdin. Args: x1=address of string to populate, x2=length of string
  mov x0, #0

  mov x16, #3
  svc #0x80 ; READ from STDIN
  ret

print_str: ; Print a string to stdout. Args: x1=address of string to print, x2=length of string
  mov x0, #1 ; What is it writing to (stdout)

  mov x16, #4 ; write, syscall 4
  svc #0x80 ; syscall with 0x80 b/c convention
  ret

.data
.align 3
first_operand_str:
  .ascii "Please enter the first operand> "

second_operand_str:
  .ascii "Please enter the second operand> "

first_operand_buffer:
  .space 64

second_operand_buffer:
  .space 64

output_str:
  .space 64
