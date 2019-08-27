{ Don't try this at home... }

{$MODE FPC}
{$IMPLICITEXCEPTIONS OFF}
unit libcemu;

interface

{ this unit doesn't publish anything on the Pascal level, but
  publishes a bunch of symbols from the implementation section
  which satisfies the linker w/o actually linking libc }

implementation

uses
  ports, ctypes, go32, crt;


function malloc(a: cint): pointer; cdecl; public name '_malloc';
begin
  malloc:=GetMem(a);
end;

procedure free(p: pointer); cdecl; public name '_free';
begin
  FreeMem(p);
end;

procedure memset(p: pointer; ch: cint; num: csize_t); cdecl; public name '_memset';
begin
  FillChar(p^,num,ch);
end;

function inp(portnum: word): byte; cdecl; public name '_inp';
begin
  inp:=port[portnum];
end;

function inpw(portnum: word): word; cdecl; public name '_inpw';
begin
  inpw:=portw[portnum];
end;

procedure outp(portnum: word; data: byte); cdecl; public name '_outp';
begin
  port[portnum]:=data;
end;

procedure outpw(portnum: word; data: word); cdecl; public name '_outpw';
begin
  portw[portnum]:=data;
end;

function memcpy(dst: pointer; src: pointer; num: cint): pointer; cdecl; public name '_memcpy';
begin
//  writeln('MemCpy:');
  move(src^,dst^,num);
  memcpy:=dst;
end;

function strcat(s1: pchar; s2: pchar): pchar; cdecl; public name '_strcat';
var
  l1,l2: cint;
begin
//  writeln('StrCat:');
  l1:=length(s1);
  l2:=length(s2);
  move(s2^,s1[l1],l2);
  s1[l1+l2]:=#0;
  strcat:=s1;
end;

function strcpy(s1: pchar; s2: pchar): pchar; cdecl; public name '_strcpy';
begin
//  writeln('StrCpy:');
  move(s2^,s1^,length(s2));
  strcpy:=s1;
end;

procedure _exit(exit_code: cint); cdecl; public name '_exit';
begin
//  writeln('Exit: called');
  halt(exit_code);
end;

procedure dosmemput(buffer: pointer; length: cint; offset: cint); cdecl; public name '_dosmemput';
begin
//  writeln('DOSMemPut:');
  seg_move(get_ds,longint(buffer),dosmemselector,offset,length);
end;

function getenv(envvar: pchar): pchar; cdecl; public name '_getenv';
var
  hp    : ppchar;
  hs    : shortstring;
  eqpos : longint;
  uenvvar: shortstring;
begin
//  writeln('GetEnv: ',envvar);
  uenvvar:=upcase(envvar);
  hp:=envp;

  getenv:=nil;
  while assigned(hp^) do
   begin
     hs:=strpas(hp^);
     eqpos:=pos('=',hs);
     if upcase(copy(hs,1,eqpos-1))=uenvvar then
      begin
        getenv:=@hp^[eqpos];
//        writeln('GetEnv: ',envvar,' Returns:',pchar(@hp^[eqpos]));
        exit;
      end;
     inc(hp);
   end;
//  writeln('GetEnv: Quits');
end;


{ KLUDGE: MIDAS only uses scanf at two places, with these simple format strings }
{         varargs are not handled, _va1 offset is only correct with a dummy _va2 arg... }
function sscanf(s: pchar; format: pchar; var _va1: clong; var _va2: clong): cint; cdecl; public name '_sscanf';
var
  res: clong;
  tmpstr: shortstring;
  e: word;
begin
//  writeln('SscanF:',format);
  sscanf:=0;
  tmpstr:=s;
  if format='%x' then
    Val('$'+tmpstr,res,e);
  if format='%d' then
    Val(tmpstr,res,e);
  if e=0 then
    begin
      sscanf:=1;
      _va1:=res;
    end;
end;

{ KLUDGE: MIDAS only uses sprintf at three places, with %-XXs format strings }
{         varargs or true format strings are not handled }
function sprintf(buf: pchar; format: pchar; va: pchar): cint; cdecl; public name '_sprintf';
begin
//  writeln('SprintF:',format,' ',va);
  sprintf:=0;
  move(format^,buf^,length(format));
  move(va^,buf[pos('%',format)-1],length(va)+1);
end;

function getch: cint; cdecl; public name '_getch';
begin
//  writeln('GetCh:');
  getch:=cint(ReadKey);
end;

var
   errno: cint; public name '_errno';
   dj_stderr: cint; public name '___dj_stderr';

type
  pfilehack = ^tfilehack;
  tfilehack = record
    f: file;
  end;

type
  cfile = pfilehack;

function fputs(str: pchar; cfile: pointer): cint; cdecl; public name '_fputs';
begin
{$WARNING FIX ME: _fputs}
//  writeln('FPuts:');
  fputs:=0;
end;

function fopen(filename: pchar; mode: pchar): cfile; cdecl; public name '_fopen';
begin
{$WARNING FIX ME: _fopen}
//  writeln('FOpen: ',filename,' Mode:',mode);
  fopen:=GetMem(sizeof(tfilehack));
  Assign(fopen^.f,filename);
  if mode='rb' then
    Reset(fopen^.f,1);
//  writeln('FOpen: $',hexstr(fopen));
end;

function fclose(f: cfile): cint; cdecl; public name '_fclose';
begin
{.$WARNING FIX ME: _fclose}
//  writeln('FClose: $',hexstr(f));
  Close(f^.f);
  FreeMem(f);
  fclose:=0;
end;

function feof(f: cfile): cint; cdecl; public name '_feof';
begin
{.$WARNING FIX ME: _feof}
//  writeln('FEof:',hexstr(f));
  feof:=ord(eof(f^.f));
end;

function ferror(f: cfile): cint; cdecl; public name '_ferror';
begin
{$WARNING FIX ME: _ferror}
//  writeln('FError:',hexstr(f));
  ferror:=0;
end;

function ftell(f: cfile): clong; cdecl; public name '_ftell';
begin
{.$WARNING FIX ME: _ftell}
//  writeln('FTell:',hexstr(f));
  ftell:=FilePos(f^.f);
end;

function fread(buffer: pointer; size: csize_t; num: csize_t; f: cfile): csize_t; cdecl; public name '_fread';
begin
{.$WARNING FIX ME: _fread}
//  writeln('FRead: $',hexstr(f),' Size:',size,' Num:',num);
  BlockRead(f^.f,buffer^,size*num,fread);
  { fread returns the number of items read, not the number of bytes read }
  fread:=fread div size;
//  writeln('FRead: Result:',fread);
end;

function fwrite(buffer: pointer; size: csize_t; num: csize_t; f: cfile): csize_t; cdecl; public name '_fwrite';
begin
{$WARNING FIX ME: _fwrite}
//  writeln('FWrite: $',hexstr(f),' Size:',size,' Num:',num);
  fwrite:=0;
end;

function fseek(f: cfile; offset: clong; mode: cint): cint; cdecl; public name '_fseek';
begin
{.$WARNING FIX ME: _fseek}
//  writeln('FSeek: $',hexstr(f),' Offset:',offset,' Mode:',mode);
  if mode = 1 then
    offset:=FilePos(f^.f)+offset;
  if mode = 2 then
    offset:=FileSize(f^.f)+offset;
  Seek(f^.f,offset);
  fseek:=0;
end;


end.
