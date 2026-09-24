;
; 2026 cc65 project (added for PRINTER driver support, see grc65)
;

; void SetNLQ (void);

            .export _SetNLQ

            .include "printdrv.inc"

_SetNLQ:
        jmp SetNLQ
