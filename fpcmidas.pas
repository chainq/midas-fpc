{$MODE FPC}
program fpcmidas;

uses
  midasdos, irqhack;

var
  m: MIDASmodule;
  p: MIDASModulePlayHandle;

begin
  MIDASstartup;
  MIDASconfig;
  MIDASinit;
  m:=MIDASloadmodule('chrono.xm');
  writeln('MODULE: $',hexstr(m));
  p:=MIDASPlayModule(m,true);
  writeln('<Press ENTER to quit>');
  readln;
  MIDASStopModule(p);
  MIDASclose;
end.
