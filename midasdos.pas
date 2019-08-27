unit midasdos;

interface

uses
  libcemu, irqhack;

{$LINKLIB libmidas.a}

type
    MIDASmodule = pointer;
    MIDASmodulePlayHandle = DWORD;
    MIDASsample = DWORD;
    MIDASsamplePlayHandle = DWORD;
    MIDASstreamHandle = pointer;
    MIDASechoHandle = pointer;

function MIDASstartup : boolean; cdecl; external;
function MIDASconfig : boolean; cdecl; external;
function MIDASinit : boolean; cdecl; external;
function MIDASsetOption(option : integer; value : dword) : boolean; cdecl; external;
function MIDASgetOption(option : integer) : dword; cdecl; external;
function MIDASclose : boolean; cdecl; external;

function MIDASloadModule(fileName : PChar) : MIDASmodule; cdecl; external;
function MIDASplayModule(module : MIDASmodule; loopSong : boolean) :
    MIDASmodulePlayHandle; cdecl; external;
function MIDASplayModuleSection(module : MIDASmodule; startPos, endPos,
    restartPos : dword; loopSong : boolean) : MIDASmodulePlayHandle; cdecl; external;
function MIDASstopModule(playHandle : MIDASmodulePlayHandle) : boolean;
    cdecl; external;
function MIDASfreeModule(module : MIDASmodule) : boolean; cdecl; external;


implementation

begin
end.
