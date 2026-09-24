;
; 2026 cc65 project (added for PRINTER driver support, see grc65)
;

; void __fastcall__ PrintBuffer (char *buffer, char *scratchBuf, char color);

            .export _PrintBuffer
            .import popax

            .include "printdrv.inc"
            .include "geossym.inc"

_PrintBuffer:
        pha                     ; color -- passed in A (fastcall, single byte)
        jsr popax               ; scratchBuf
        sta r1L
        stx r1H
        jsr popax               ; buffer
        sta r0L
        stx r0H
        pla
        sta r2L
        jsr PrintBuffer
        rts
