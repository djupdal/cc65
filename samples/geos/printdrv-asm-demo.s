;
; Minimal GEOS printer driver example
;
; 2026, cc65 team
;

            .export InitForPrint, StartPrint, PrintBuffer, StopPrint
            .export GetDimensions, PrintASCII, StartASCII, SetNLQ

; ------------------------------------------------------------------------
; The jump table itself must be exactly these 8 3-byte jmp instructions,
; with nothing else before or between them: an application calls this
; driver's routines by jsr-ing to PRINTBASE (this driver's own load
; address) plus a fixed offset -- 0, 3, 6, 9, 12, 15, 18, 21 -- matching
; libsrc/geos-cbm/printdrv.inc.

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
; The actual routines the jump table above calls into.

.segment "CODE"

DoInitForPrint:
        rts

DoStartPrint:
        ldx #0
        clc
        rts

DoPrintBuffer:
        rts

DoStopPrint:
        rts

DoGetDimensions:
        ldx #80
        ldy #105
        rts

DoPrintASCII:
        rts

DoStartASCII:
        ldx #0
        clc
        rts

DoSetNLQ:
        rts
