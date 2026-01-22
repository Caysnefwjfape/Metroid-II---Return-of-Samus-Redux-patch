; Beam pickup + non-stackable behavior
; Pause beam switching uses wActiveBeam; firearm routine should consult wActiveBeam and the wBeam_* flags.

	INCLUDE "wram_vars.inc"

SECTION "Beams", ROMX

; Beam_PickupHook: called when Samus would normally receive a beam
; A = beam type id (convention chosen here):
;   1 = Ice
;   2 = Wave
;   3 = Spazer
;   4 = Plasma
; The integrator should pass the beam id in A before calling this routine (or adapt to your project's calling convention).
Beam_PickupHook:
    cp #1
    jr z, .beam_ice
    cp #2
    jr z, .beam_wave
    cp #3
    jr z, .beam_spazer
    cp #4
    jr z, .beam_plasma
    ret

.beam_ice:
    ld a, (wBeam_Ice)
    or a
    jr nz, .already_have
    ld (wBeam_Ice), #1
    ; If no active beam, set this as active
    ld a, (wActiveBeam)
    or a
    jr nz, .done
    ld (wActiveBeam), #1
    ret

.beam_wave:
    ld a, (wBeam_Wave)
    or a
    jr nz, .already_have
    ld (wBeam_Wave), #1
    ld a, (wActiveBeam)
    or a
    jr nz, .done
    ld (wActiveBeam), #2
    ret

.beam_spazer:
    ld a, (wBeam_Spazer)
    or a
    jr nz, .already_have
    ld (wBeam_Spazer), #1
    ld a, (wActiveBeam)
    or a
    jr nz, .done
    ld (wActiveBeam), #3
    ret

.beam_plasma:
    ld a, (wBeam_Plasma)
    or a
    jr nz, .already_have
    ld (wBeam_Plasma), #1
    ld a, (wActiveBeam)
    or a
    jr nz, .done
    ld (wActiveBeam), #4
    ret

.already_have:
    ; Optionally play a sound or show effect to indicate pickup did nothing
    ; Integrator: you can call the existing "cannot pick up" effect routine here.
    ret

.done:
    ; Optionally play pickup sound/effect for new beam
    ret

; Fire beam: The existing firing routine should check wActiveBeam and branch to the appropriate beam firing code.
; Example (pseudo):
;    ld a, (wActiveBeam)
;    cp #1 ; ice
;    jr z, Fire_Ice
;    cp #2 ; wave
;    jr z, Fire_Wave
;    ...
; Integrator: replace or wrap your existing fire logic with above branching.