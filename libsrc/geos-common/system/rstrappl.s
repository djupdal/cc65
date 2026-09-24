;
; 2026 cc65 project (added for DESK_ACC support, see grc65)
;

; void RstrAppl (void);
;
; Leave a desk accessory and resume the application that opened it. This
; never returns to the caller: control passes into the resumed application
; at the point where it called GetFile()/LdDeskAcc to open the accessory.

            .import donelib
            .import __GEOS_SAVED_ZP__
            .import __ZP_START__, __ZP_SIZE__            ; Linker generated
            .export _RstrAppl

            .include "jumptab.inc"
            .include "diskdrv.inc"

_RstrAppl:
        jsr donelib

; Restore zero page saved at startup before handing control back -- GEOS's
; own memory swap doesn't cover it, since it knows nothing about zero
; page, which is shared with whatever application is running underneath.
; __GEOS_SAVED_ZP__ is provided by whatever startup code the final
; program links against; see samples/geos/deskacc-crt0.s, which a desk
; accessory links in place of the standard crt0.s specifically to save
; it, without costing every other GEOS program a buffer it never reads
; back.

        ldy #<(__ZP_SIZE__ - 1)
RstrZP: lda __GEOS_SAVED_ZP__,y
        sta __ZP_START__,y
        dey
        bpl RstrZP

        jmp RstrAppl
