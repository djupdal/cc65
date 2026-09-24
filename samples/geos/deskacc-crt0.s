;
; Startup code for a GEOS desk accessory (DESK_ACC), based on
; libsrc/geos-common/system/crt0.s
;
; The only difference is the block below saving cc65's own runtime zero
; page (c_sp, ptr1-4, ...) into a dedicated buffer before anything else
; gets a chance to use it. RstrAppl() (see libsrc/geos-common/system/
; rstrappl.s) restores it before handing control back to the calling
; application.

            .export _exit
            .export __STARTUP__ : absolute = 1          ; Mark as startup
            .export __GEOS_SAVED_ZP__
            .import __STACKADDR__, __STACKSIZE__        ; Linker generated
            .import __BACKBUFSIZE__                     ; Linker generated
            .import __ZP_START__, __ZP_SIZE__           ; Linker generated
            .import initlib, donelib
            .import callmain
            .import zerobss
            .importzp c_sp

            .include "jumptab.inc"
            .include "geossym.inc"
            .include "const.inc"

; ------------------------------------------------------------------------
; Somewhere to save cc65's own runtime zero page block while this
; accessory is running.

GEOS_SAVED_ZP_SIZE = $20       ; generous upper bound, checked below

.segment        "DATA"

__GEOS_SAVED_ZP__:
        .res    GEOS_SAVED_ZP_SIZE

; ------------------------------------------------------------------------
; Place the startup code in a special segment.

.segment        "STARTUP"

; Save zero page before anything below gets a chance to use it.

        .assert __ZP_SIZE__ <= GEOS_SAVED_ZP_SIZE, lderror, "GEOS ZP area grew past the saved-ZP buffer, update deskacc-crt0.s"
        ldy #<(__ZP_SIZE__ - 1)
SaveZP: lda __ZP_START__,y
        sta __GEOS_SAVED_ZP__,y
        dey
        bpl SaveZP

; GEOS 64/128 initializes the screen before starting an application while
; Apple GEOS does not. In order to provide identical startup conditions,
; we initialize the screen here, on Apple GEOS. For the same reason, we set
; the pattern and dispBufferOn, even on GEOS 64/128, although we don't use
; them here.

        lda #2                  ; Checkerboard pattern
        jsr SetPattern
        lda #<(ST_WR_FORE | .MIN (ST_WR_BACK, __BACKBUFSIZE__))
        sta dispBufferOn
.ifdef __GEOS_APPLE__
        jsr i_Rectangle
        .byte 0
        .byte SC_PIX_HEIGHT-1
        .word 0
        .word SC_PIX_WIDTH-1
.endif

; Clear the BSS data.

        jsr zerobss

; Set up the stack.

        lda #<(__STACKADDR__ + __STACKSIZE__)
        ldx #>(__STACKADDR__ + __STACKSIZE__)
        sta c_sp
        stx c_sp+1

; Call the module constructors.

        jsr initlib

; Push the command-line arguments; and, call main().

        cli
        jsr callmain

; Call the module destructors.

_exit:  jsr donelib

        jmp EnterDeskTop        ; Return control to the system
