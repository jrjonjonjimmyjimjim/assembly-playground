.global _main
.align 2

_main:

  mov x28, #10 ; const x28 = 10

  adrp x1, first_operand_str@PAGE
  add x1, x1, first_operand_str@PAGEOFF
  mov x2, #32 ; How long is the thing it's writing
  bl print_str

  adrp x1, first_operand_buffer@PAGE
  add x1, x1, first_operand_buffer@PAGEOFF
  mov x2, #63 ; How long is the thing it's reading
  bl read_str

; parse int
; the syscall should give back the length of what it read
; I want to read 1 byte at a time
; For each byte, subtract 48 and add that to an accumulator
; If we are not at the last byte, mult accumulator by 10 and loop.
; At least for first implementation, let's call ldrb on every byte, incrementing by just one byte each time
  sub x0, x0, #1 ; Stop reading before newline
  adrp x1, first_operand_buffer@PAGE
  add x1, x1, first_operand_buffer@PAGEOFF
  mov x22, #0 ; our index
  parse_int_loop:
    add x24, x1, x22 ; ptr x24 = x1 + x22
    ldrb x21, [x24] ; char x21 = *x24
    sub x23, x21, #48
	madd x19, x19, x28, x23
	; check if we still have chars to loop through
	; if so, jump to loop end. else, mult by 10, increment index
	; if index makes it to x0, break
	add x22, x22, #1
	cmp x22, x0
	b.ne parse_int_loop


  adrp x1, second_operand_str@PAGE
  add x1, x1, second_operand_str@PAGEOFF
  mov x2, #33 ; How long is the thing it's writing
  bl print_str

  adrp x1, second_operand_buffer@PAGE
  add x1, x1, second_operand_buffer@PAGEOFF
  mov x2, #63 ; How long is the thing it's reading
  bl read_str

; parse int, for operand 2
; parse int can be made a subroutine, i'll worry about that later
  sub x0, x0, #1
  adrp x1, second_operand_buffer@PAGE
  add x1, x1, second_operand_buffer@PAGEOFF
  mov x22, #0 ; our index
  parse_int_loop_2:
    add x24, x1, x22
    ldrb x21, [x24]
    sub x23, x21, #48
	madd x20, x20, x28, x23
	add x22, x22, #1
	cmp x22, x0
	b.ne parse_int_loop_2



; x19 and x20 hold int values of the operands
  add x21, x19, x20

; Now turn the int into a string
; Until the number hits 0...
; Divide by 10
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
