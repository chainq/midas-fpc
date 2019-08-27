export PATH=$PATH:$HOME/DevPriv/i386-go32v2-binutils
FPC=$HOME/DevPriv/fpc-bin/i386-go32v2/lib/fpc/3.3.1

$FPC/ppcross386 -Tgo32v2  -Xs -Xe -g -al -O- -B -FD./ -Fu$FPC/units/go32v2/* fpcmidas.pas
