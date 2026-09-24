;
; 2026 cc65 project (added for PRINTER driver support, see grc65)
;

; void __fastcall__ GetDimensions (char *width, char *height);

            .export _GetDimensions
            .import popax
            .importzp ptr1, ptr2, tmp1, tmp2

            .include "printdrv.inc"

_GetDimensions:
        sta ptr1                ; height -- passed in A/X (fastcall, pointer)
        stx ptr1+1
        jsr popax               ; width
        sta ptr2
        stx ptr2+1
        jsr GetDimensions       ; returns width in X, height in Y
        stx tmp1
        sty tmp2
        ldy #0
        lda tmp1
        sta (ptr2),y            ; *width = tmp1
        lda tmp2
        sta (ptr1),y            ; *height = tmp2
        rts
