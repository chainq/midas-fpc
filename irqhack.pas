{$MODE FPC}
{$MACRO ON}
{$PACKRECORDS C}
{$IMPLICITEXCEPTIONS OFF}
{ - Has this code been ported from Allegro library v4's C version?
  - Not Really. Maybe. It's classified... }
unit irqhack;

interface

implementation

uses
  go32, ctypes;

type
  _IRQ_HANDLER_FUNC = function(): cint; cdecl;

type
  pseginfo = ^tseginfo;

type
  _IRQ_HANDLER = record
    handler: _IRQ_HANDLER_FUNC;
    number: cint;
    old_vector: pseginfo;
  end;

const
  MAX_IRQS = 8;
  STACK_SIZE = 8192;

var
  irq_stack: array[0..MAX_IRQS-1] of pbyte;

  irq_handler: array[0..MAX_IRQS-1] of _IRQ_HANDLER;

var
  ___v2prt0_ds_alias : word; external name '___v2prt0_ds_alias';

{$ASMMODE ATT}
{$define HANDLER_NUM:=0}
var _old_vector_0: tseginfo;
procedure _irq_wrapper_0;
{$i irqhack.inc}
{$undef HANDLER_NUM}
{$define HANDLER_NUM:=1}
var _old_vector_1: tseginfo;
procedure _irq_wrapper_1;
{$i irqhack.inc}
{$undef HANDLER_NUM}
{$define HANDLER_NUM:=2}
var _old_vector_2: tseginfo;
procedure _irq_wrapper_2;
{$i irqhack.inc}
{$undef HANDLER_NUM}
{$define HANDLER_NUM:=3}
var _old_vector_3: tseginfo;
procedure _irq_wrapper_3;
{$i irqhack.inc}
{$undef HANDLER_NUM}
{$define HANDLER_NUM:=4}
var _old_vector_4: tseginfo;
procedure _irq_wrapper_4;
{$i irqhack.inc}
{$undef HANDLER_NUM}
{$define HANDLER_NUM:=5}
var _old_vector_5: tseginfo;
procedure _irq_wrapper_5;
{$i irqhack.inc}
{$undef HANDLER_NUM}
{$define HANDLER_NUM:=6}
var _old_vector_6: tseginfo;
procedure _irq_wrapper_6;
{$i irqhack.inc}
{$undef HANDLER_NUM}
{$define HANDLER_NUM:=7}
var _old_vector_7: tseginfo;
procedure _irq_wrapper_7;
{$i irqhack.inc}
{$undef HANDLER_NUM}
procedure _irq_wrapper_end; assembler; nostackframe;
asm
end;


procedure irqhack_init;
var
  i: longint;
begin
  lock_data(irq_handler,sizeof(irq_handler));
  lock_data(irq_stack,sizeof(irq_stack));
  lock_code(pointer(@_irq_wrapper_0),pointer(@_irq_wrapper_end)-pointer(@_irq_wrapper_0));

  for i:=low(irq_handler) to high(irq_handler) do
    begin
      irq_handler[i].handler:=nil;
      irq_handler[i].number:=0;
    end;

  for i:=low(irq_stack) to high(irq_stack) do
    begin
      irq_stack[i]:=GetMem(STACK_SIZE);
      if assigned(irq_stack[i]) then
        begin
          lock_data(irq_stack[i],STACK_SIZE);
          inc(irq_stack[i],STACK_SIZE-32);
//          writeln('stack ',i,' ',hexstr(irq_stack[i]));
        end;
    end;
end;


procedure irqhack_done;
var
  i: longint;
begin
  for i:=low(irq_stack) to high(irq_stack) do
    begin
      dec(irq_stack[i],STACK_SIZE-32);
      unlock_data(irq_stack[i],STACK_SIZE);
      FreeMem(irq_stack[i]);
      irq_stack[i]:=nil;
    end;

  unlock_data(irq_stack,sizeof(irq_stack));
  unlock_data(irq_handler,sizeof(irq_handler));
end;


function _install_irq(num: cint; handler: _IRQ_HANDLER_FUNC): cint; cdecl; public name '__install_irq';
var
  i: longint;
  addr: tseginfo;
  oldvector: pseginfo;
begin
//  writeln('InstallIRQ: ',num);

  for i:=low(irq_handler) to high(irq_handler) do
    begin
      if irq_handler[i].handler = nil then
        begin
          addr.segment:=Get_CS;
//          writeln('segment: ',hexstr(addr.segment,4));
          case i of
            0: begin
                 addr.offset := @_irq_wrapper_0;
                 oldvector := @_old_vector_0;
               end;
            1: begin
                 addr.offset := @_irq_wrapper_1;
                 oldvector := @_old_vector_1;
               end;
            2: begin
                 addr.offset := @_irq_wrapper_2;
                 oldvector := @_old_vector_2;
               end;
            3: begin
                 addr.offset := @_irq_wrapper_3;
                 oldvector := @_old_vector_3;
               end;
            4: begin
                 addr.offset := @_irq_wrapper_4;
                 oldvector := @_old_vector_4;
               end;
            5: begin
                 addr.offset := @_irq_wrapper_5;
                 oldvector := @_old_vector_5;
               end;
            6: begin
                 addr.offset := @_irq_wrapper_6;
                 oldvector := @_old_vector_6;
               end;
            7: begin
                 addr.offset := @_irq_wrapper_7;
                 oldvector := @_old_vector_7;
               end;
            else
              begin
                _install_irq:=-1;
                exit;
              end;
          end;

//          writeln('wrapper: ',hexstr(addr.offset));
//          writeln('handler: ',hexstr(handler));
          irq_handler[i].handler:=handler;
          irq_handler[i].number:=num;
          irq_handler[i].old_vector:=oldvector;

          get_pm_interrupt(num, oldvector^);
          set_pm_interrupt(num, addr);

          _install_irq:=0;
          exit;
        end;
    end;
  _install_irq:=-1;
end;




procedure _remove_irq(num: cint); cdecl; public name '__remove_irq';
var
  i: longint;
begin
//  writeln('RemoveIRQ: ',num);

  for i:=low(irq_handler) to high(irq_handler) do
    begin
      if irq_handler[i].number = num then
        begin
          set_pm_interrupt(num, irq_handler[i].old_vector^);
          irq_handler[i].number:=0;
          irq_handler[i].handler:=nil;
          break;
        end;
    end;
end;


initialization
    irqhack_init;
finalization
    irqhack_done;

end.
