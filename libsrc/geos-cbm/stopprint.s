;
; 2026 cc65 project (added for PRINTER driver support, see grc65)
;

; void __fastcall__ StopPrint (char *buffer, char *scratchBuf);

            .export _StopPrint
            .import popax

            .include "printdrv.inc"
            .include "geossym.inc"

_StopPrint:
        sta r1L                 ; scratchBuf -- passed in A/X (fastcall, pointer)
        stx r1H
        jsr popax               ; buffer
        sta r0L
        stx r0H
        jsr StopPrint
        rts
