{$MODE FPC}
program fpcmidas;

uses
  crt, midasdos, irqhack;

var
  m: MIDASmodule;
  p: MIDASModulePlayHandle;
  ps: MIDASPlayStatus;

begin
  MIDASstartup;
  MIDASconfig;
  MIDASinit;
  m:=MIDASloadmodule('chrono.xm');
  writeln('MODULE: $',hexstr(m));
  p:=MIDASPlayModule(m,true);
  writeln('<Press ENTER to quit>');

  repeat
    MIDASgetPlayStatus(p,@ps);
    write('Position:',ps.position:3,' - Pattern:',ps.pattern:3,' - Row:',ps.row:3,#13);
  until keypressed;

  ReadKey;
  MIDASStopModule(p);
  MIDASclose;
end.
