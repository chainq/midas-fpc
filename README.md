# MIDAS to Free Pascal/go32v2

This tiny piece of code allows linking`libmidas.a` from MIDAS Sound
System _(a.k.a Housemarque Audio System)_ against Free Pascal/go32v2
code, and it allows it without also linking against DJGPP's `libc.a`
and `liballegro.a`, simplifying the linking process and preventing
potential interoperability issues with other Pascal code accessing
hardware or DPMI services directly.

The libc and IRQ handler stubs included in this repository provide just
enough functionality to put some music in your oldschool DOS demo,
or game, but extending it to support the full MIDAS API in theory
should be possible.

Only tested with recent Free Pascal 3.3.1 trunk version. Needs external
i386-go32v2-binutils.

Note that using MIDAS/HMQAudio is free, but only for non commercial
applications. See more details on the HMQAudio homepage.

## Credits

The IRQ stub code was ripped from Allegro v4 and was heavily modified to
work with Free Pascal. The IRQ setup/release code was ported from the C
version in Allegro v4.

## Links and references

* Housemarque Audio System homepage: http://www.s2.org/hmqaudio/
* Modern DJGPP crosscompiler (binutils): https://github.com/andrewwutw/build-djgpp
* Allegro v4: https://github.com/liballeg/allegro5/tree/4.4
