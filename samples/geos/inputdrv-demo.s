;
; Minimal GEOS input driver skeleton.
;
; 2026, cc65 team
;

            .export InitMouse, SlowMouse, UpdateMouse

; ------------------------------------------------------------------------
; The jump table itself must be exactly these 3 3-byte jmp instructions,
; with nothing else before or between them: GEOS and applications call
; this driver's routines by jsr-ing to MOUSE_BASE (this driver's own
; load address) plus a fixed offset -- 0, 3, 6 -- matching
; libsrc/geos-cbm/inputdrv.inc.

.segment "STARTUP"

InitMouse:      jmp DoInitMouse
SlowMouse:      jmp DoSlowMouse
UpdateMouse:    jmp DoUpdateMouse

; ------------------------------------------------------------------------

.segment "CODE"

DoInitMouse:
        rts

DoSlowMouse:
        rts

DoUpdateMouse:
        rts
  
