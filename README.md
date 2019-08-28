# MIDAS to Free Pascal/go32v2

This tiny piece of code allows linking MIDAS Sound System's `libmidas.a`
against modern Free Pascal/go32v2 code, and it allows it without also
linking against DJGPP's `libc.a` and `liballegro.a`.

The libc and IRQ handler stubs included in this repository provide just
enough functionality to put some music in your oldschool DOS demo,
or game, but extending it to supports the full MIDAS API in theory
should be possible.

Only tested with recent Free Pascal 3.3.1 trunk version. Needs external
i386-go32v2-binutils.
