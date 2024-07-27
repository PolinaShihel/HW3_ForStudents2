.global count_above

.section .text
count_above: # r8 - seperator, -8(%rbp) - limit, r9 - counter, r10 - fd bacup, rcx - base of buffer, r11 - 
  pushq %rbp
  movq %rsp, %rbp
  subq $68,%rsp # TODO: see how local vars many things needed for frame 

  movq %rdi, %r8  # seperator 
  movq %rsi, -8(%rbp)  # limit
  movq $0, -16(%rbp) # this will count the above nums 

  call get_path # now rax holds pointer to file
  movq %rax, %rdi
  movq $2, %rax # open syscall with read only 
  movq $0, %rsi
  movq $0, %rdx
  syscall # returns the fd of the file
  movq %rax, %r10 # backup the fd 
  movq %rax, %rdi # the fd for the read syscall 
  movq %rsp, %rcx # rcx will point to base of buffer
  movq %rsp, %r11 # used to restore rcx in each new number

read_loop_HW3:
  movq $0, %rax # read syscall 
  movq %rcx, %rsi 
  movq $1, %rdx
  movq %r11, -24(%rbp)
  movq %rcx, -32(%rbp)
  syscall
  movq  -24(%rbp),%r11
  movq  -32(%rbp),%rcx
  testq %rax,%rax # check if bytes were read
  jz done_HW3
  cmpb %r8b,(%rsi)
  je finished_num_HW3
  xorq %r9,%r9
  movb (%rsi),%r9b
  movb %r9b,(%rcx)
  add $1, %rcx
  jmp read_loop_HW3
finished_num_HW3:
  movb $0x00,(%rcx)
  movq %r11, %rdi # passing null terminated string to function atam_atol
  movq %r11, -24(%rbp)
  movq %rcx, -32(%rbp)
  movq %r8, -40(%rbp)
  movq %r10 ,-48(%rbp)
  call atam_atol
  movq  -24(%rbp),%r11
  movq  -32(%rbp),%rcx
  movq  -40(%rbp),%r8
  movq  -48(%rbp),%r10
  movq %r10, %rdi #restored fd for read
  cmpq %rax, -8(%rbp)
  jge restore_buffer_HW3
  incq -16(%rbp)
restore_buffer_HW3:
  movq %r11, %rcx #restore buffer
  jmp read_loop_HW3

done_HW3: #last number in file
  movb $0x00,(%rcx)
  movq %r11, %rdi # passing null terminated string to function atam_atol
  movq %r11, -24(%rbp)
  movq %rcx, -32(%rbp)
  movq %r8, -40(%rbp)
  movq %r10, -48(%rbp)
  call atam_atol
  movq  -24(%rbp),%r11
  movq  -32(%rbp),%rcx
  movq  -40(%rbp),%r8
  movq  -48(%rbp),%r10
  movq %r10, %rdi #restored fd for read
  cmpq %rax, -8(%rbp)
  jge return_HW3
  incq -16(%rbp)
return_HW3:
  movq -16(%rbp), %rax
  movq %rbp, %rsp
  popq %rbp
  ret


