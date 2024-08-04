.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  # we dont really know how 'what_to_do'works, 
  # so we're saving all the regs
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
  pushq %rbp
  pushq %rsp

  movq $0, %rax
  movq $0, %rbx
  movq $0, %rcx
  movq $0, %rdi

  movq 128(%rsp), %rbx  # 8 bytes*16 regs = 128
  movb (%rbx), %al      # move first byte to al   

  cmp $0x0f, %al
  jne byte_command

# else it's a 2 byte command, these are the only 2 options
two_byte_command:
  movb 1(%rbx), %al         # loads second(last) byte
  movq $2, %rcx         # contains the len of the opcode
  jmp call_handling

byte_command:
  movq $1, %rcx         # contains the len of the opcode

call_handling: 
  movq %rax, %rdi
  pushq %rcx

  call what_to_do
  
  popq %rcx
  test %rax, %rax
  jz original

special:
  movq %rax, %rdi        # specifically asked in the pdf
  
  popq %rsp
  popq %rbp
  addq %rcx, 112(%rsp)   # next command
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
  popq %rsi
  popq %rsi
  
  iretq

original:
  popq %rsp
  popq %rbp             # poping from end to start
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
  
  jmp * old_ili_handler  # need to check if works
