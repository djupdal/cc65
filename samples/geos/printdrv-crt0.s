;
; Startup code for a GEOS printer driver, providing the fixed 8-entry
; jump table GEOS/an application expects at the driver's load address.
;

            .export __STARTUP__ : absolute = 1          ; Mark as startup
            .import __STACKADDR__, __STACKSIZE__        ; Linker generated
            .import __ZP_START__, __ZP_SIZE__           ; Linker generated
            .import initlib
            .import zerobss
            .importzp c_sp

            .import _InitForPrint, _StartPrint, _PrintBuffer, _StopPrint
            .import _GetDimensions, _PrintASCII, _StartASCII, _SetNLQ

            .include "geossym.inc"

GEOS_SAVED_ZP_SIZE = $20       ; generous upper bound, checked below

.segment "STARTUP"

InitForPrint:   jmp DoInitForPrint
StartPrint:     jmp DoStartPrint
PrintBuffer:    jmp DoPrintBuffer
StopPrint:      jmp DoStopPrint
GetDimensions:  jmp DoGetDimensions
PrintASCII:     jmp DoPrintASCII
StartASCII:     jmp DoStartASCII
SetNLQ:         jmp DoSetNLQ

; ------------------------------------------------------------------------
; Save the calling application's zero page into savedZP, then give the
; driver its own C stack

.segment "CODE"

EnterDriver:
        .assert __ZP_SIZE__ <= GEOS_SAVED_ZP_SIZE, lderror, "GEOS ZP area grew past the saved-ZP buffer, update printdrv-crt0.s"
        ldy #<(__ZP_SIZE__ - 1)
@SaveZP:
        lda __ZP_START__,y
        sta savedZP,y
        dey
        bpl @SaveZP
        lda #<(__STACKADDR__ + __STACKSIZE__)
        ldx #>(__STACKADDR__ + __STACKSIZE__)
        sta c_sp
        stx c_sp+1
        rts

LeaveDriver:
        ldy #<(__ZP_SIZE__ - 1)
@RestoreZP:
        lda savedZP,y
        sta __ZP_START__,y
        dey
        bpl @RestoreZP
        rts

; ------------------------------------------------------------------------
; The actual routines the jump table above calls into.

DoInitForPrint:
        jsr EnterDriver
        jsr zerobss
        jsr initlib
        jsr _InitForPrint
        jsr LeaveDriver
        rts

DoStartPrint:
        jsr EnterDriver
        jsr _StartPrint         ; error code (0 = success) returned in A
        tax                     ; ...but the caller expects it in X
        beq @Success
        sec                      ; nonzero -> error: carry set, per the
        jmp @Leave               ; reference guide
@Success:
        clc                      ; zero -> success: carry clear
@Leave:
        jsr LeaveDriver
        rts

DoPrintBuffer:
        jsr EnterDriver
        jsr _PrintBuffer
        jsr LeaveDriver
        rts

DoStopPrint:
        jsr EnterDriver
        jsr _StopPrint
        jsr LeaveDriver
        rts

DoGetDimensions:
        jsr EnterDriver
        jsr _GetDimensions
        jsr LeaveDriver         ; clobbers Y (its own restore-loop counter),
                                 ; so this must come before loading X/Y below
        ldx r3L                 ; the caller expects width in X, height in Y
        ldy r4L
        rts

DoPrintASCII:
        jsr EnterDriver
        jsr _PrintASCII
        jsr LeaveDriver
        rts

DoStartASCII:
        jsr EnterDriver
        jsr _StartASCII         ; error code (0 = success) returned in A
        tax                     ; ...but the caller expects it in X
        beq @Success
        sec                      ; nonzero -> error: carry set, per the
        jmp @Leave               ; reference guide
@Success:
        clc                      ; zero -> success: carry clear
@Leave:
        jsr LeaveDriver
        rts

DoSetNLQ:
        jsr EnterDriver
        jsr _SetNLQ
        jsr LeaveDriver
        rts

.segment "BSS"

savedZP:        .res GEOS_SAVED_ZP_SIZE
