assembler; nostackframe;
const
  HANDLER_VEC: pointer = @irq_handler[HANDLER_NUM].handler;
asm
   pushw %ds                              {* save registers *}
   pushw %es
   pushw %fs
   pushw %gs
   pushal

   movw %cs:___v2prt0_ds_alias, %ax       {* cs: override *}
   movw %ax, %ds                          {* set up selectors *}
   movw %ax, %es
   movw %ax, %fs
   movw %ax, %gs
(*
   movl $MAX_IRQS-1, %ecx               {* look for a free stack *}

.Lstack_search_loop:
   movl $irq_stack, %ebx
   leal (%ebx,%ecx,4), %ebx
   cmpl $0, (%ebx)
   jnz .Lfound_stack                    {* found one! *}

   decl %ecx
   jge .Lstack_search_loop

   jmp .Lget_out                        {* oh shit.. *}
*)
{$IF HANDLER_NUM=0}
   leal _stack_0, %ebx
{$ELSEIF HANDLER_NUM=1}
   leal _stack_1, %ebx
{$ELSEIF HANDLER_NUM=2}
   leal _stack_2, %ebx
{$ELSEIF HANDLER_NUM=3}
   leal _stack_3, %ebx
{$ELSEIF HANDLER_NUM=4}
   leal _stack_4, %ebx
{$ELSEIF HANDLER_NUM=5}
   leal _stack_5, %ebx
{$ELSEIF HANDLER_NUM=6}
   leal _stack_6, %ebx
{$ELSEIF HANDLER_NUM=7}
   leal _stack_7, %ebx
{$ELSE}
{$ERROR Unknown handler number.}
{$ENDIF}

   movl %esp, %ecx                        {* old stack in ecx + dx *}
   movw %ss, %dx

   movl (%ebx), %esp                      {* set up our stack *}
   movw %ax, %ss

   pushl %edx                             {* push old stack onto new *}
   pushl %ecx
   pushl %ebx

   cld                                    {* clear the direction flag *}

//   movl GLOBL(_irq_handler) + IRQ_HANDLER + IRQ_SIZE*x, %eax
   movl HANDLER_VEC, %eax
   movl (%eax),%eax
   call *%eax                             {* call the C handler *}

   cli

   popl %ebx                              {* restore the old stack *}
   popl %ecx
   popl %edx
   movw %dx, %ss
   movl %ecx, %esp

   orl %eax, %eax                         {* check return value *}
   jz .Lget_out

   popal                                  {* chain to old handler *}
   popw %gs
   popw %fs
   popw %es
   popw %ds

{$IF HANDLER_NUM=0}
   ljmp %cs:_old_vector_0
{$ELSEIF HANDLER_NUM=1}
   ljmp %cs:_old_vector_1
{$ELSEIF HANDLER_NUM=2}
   ljmp %cs:_old_vector_2
{$ELSEIF HANDLER_NUM=3}
   ljmp %cs:_old_vector_3
{$ELSEIF HANDLER_NUM=4}
   ljmp %cs:_old_vector_4
{$ELSEIF HANDLER_NUM=5}
   ljmp %cs:_old_vector_5
{$ELSEIF HANDLER_NUM=6}
   ljmp %cs:_old_vector_6
{$ELSEIF HANDLER_NUM=7}
   ljmp %cs:_old_vector_7
{$ELSE}
{$ERROR Unknown handler number.}
{$ENDIF}

.Lget_out:
   popal                                  {* iret *}
   popw %gs
   popw %fs
   popw %es
   popw %ds
   sti
   iret
end;
