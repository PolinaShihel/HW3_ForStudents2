.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  # we dont really know how 'what_to_do'works, 
  # so we're saving all the regs
  pushq %rbp
  pushq %rsp
  pushq %rsi
  pushq %rdi
  pushq %rax
  pushq %rbx
  pushq %rcx
  pushq %rdx
  pushq %r8
  pushq %r9
  pushq %r10
  pushq %r11
  pushq %r12
  pushq %r13
  pushq %r14
  pushq %r15

  movq $0, %rax
  movq $0, %rbx
  movq $0, %rdi

  movq 128(%rsp), %rax  # 8 bytes*16 regs = 128
  movb (%rax), %al      # loads first byte

  cmp $0x0f, %al
  jne byte_command

# else it's a 2 byte command, these are the only 2 options
two_byte_command:
  movb 1(%rax), %al     # loads last byte
  movq $2, %rbx         # contains the len of the opcode
  jmp call_handling

byte_command:
  movq $1, %rbx         # contains the len of the opcode
  jmp call_handling

call_handling: 
  movq %rax, %rdi
  pushq %rbx

  call what_to_do
  
  popq %rbx
  test %rax, %rax
  jz original
  jmp special

original:
  popq %r15             # poping from end to start
  popq %r14
  popq %r13
  popq %r12
  popq %r11
  popq %r10
  popq %r9
  popq %r8
  popq %rdx
  popq %rcx
  popq %rbx
  popq %rax
  popq %rdi
  popq %rsi
  popq %rsp
  popq %rbp
  
  jmp (old_ili_handler)  # need to check if works

special:
  movq %rax, %rdi        # specifically asked in the pdf
  addq $rbx, 128(%rsp)   # next command
  
  popq %r15
  popq %r14
  popq %r13
  popq %r12
  popq %r11
  popq %r10
  popq %r9
  popq %r8
  popq %rdx
  popq %rcx
  popq %rbx
  popq %rax
  popq %rdi
  popq %rsi
  popq %rsp
  popq %rbp
  
  iretq
