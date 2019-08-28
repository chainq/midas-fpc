{$MODE DELPHI}
{$PACKRECORDS C}
unit midasdos;

interface

uses
  libcemu, irqhack;

{$LINKLIB libmidas.a}

{*
   NOTICE: All structures and function declarations here are copied from
   midasdll.pas, but might be slightly modified to work with the DOS version,
   as needed.

   All licensing restrictions which applies with MIDAS/HMQAudio itself
   applies to these.
 *}

type
    MIDASmodule = pointer;
    MIDASmodulePlayHandle = DWORD;
    MIDASsample = DWORD;
    MIDASsamplePlayHandle = DWORD;
    MIDASstreamHandle = pointer;
    MIDASechoHandle = pointer;

type MIDASmoduleInfo =
    record
        songName : array[0..31] of char;
        songLength : integer;
        numPatterns : integer;
        numInstruments : integer;
        numChannels : integer;
    end;
    PMIDASmoduleInfo = ^MIDASmoduleInfo;

type MIDASinstrumentInfo =
    record
        instName : array[0..31] of char;
    end;
    PMIDASinstrumentInfo = ^MIDASinstrumentInfo;

type MIDASplayStatus =
    record
        position : dword;
        pattern : dword;
        row : dword;
        syncInfo : integer;
        songLoopCount : dword
    end;
    PMIDASplayStatus = ^MIDASplayStatus;



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

function MIDASgetPlayStatus(playHandle : MIDASmodulePlayHandle;
    status : PMIDASplayStatus) : boolean; cdecl; external;
function MIDASsetPosition(playHandle : MIDASmodulePlayHandle;
    newPosition : integer) : boolean; cdecl; external;
function MIDASsetMusicVolume(playHandle : MIDASmodulePlayHandle;
    volume : dword) : boolean; cdecl; external;
function MIDASgetModuleInfo(module : MIDASmodule; info : PMIDASmoduleInfo) :
    boolean; cdecl; external;
function MIDASgetInstrumentInfo(module : MIDASmodule; instNum : integer;
    info : PMIDASinstrumentInfo) : boolean; cdecl; external;
function MIDASfadeMusicChannel(playHandle : MIDASmodulePlayHandle; channel,
    fade : dword) : boolean; cdecl; external;


implementation

begin
end.
