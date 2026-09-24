;
; 2026 cc65 project (added for PRINTER driver support, see grc65)
;

; char StartASCII (void);
;
; Returns 0 on success, or a Kernal I/O error code.

            .export _StartASCII

            .include "printdrv.inc"

_StartASCII:
        jsr StartASCII
        txa
        rts
