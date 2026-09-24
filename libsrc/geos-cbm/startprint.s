;
; 2026 cc65 project (added for PRINTER driver support, see grc65)
;

; char StartPrint (void);
;
; Returns 0 on success, or a Kernal I/O error code.

            .export _StartPrint

            .include "printdrv.inc"

_StartPrint:
        jsr StartPrint
        txa
        rts
