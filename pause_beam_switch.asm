; Pause menu beam switch handling
; Call Pause_BeamSwitchHandler from the pause input routine (when paused). If SELECT pressed, cycles the active beam.

	INCLUDE "wram_vars.inc"

SECTION "PauseBeamSwitch", ROMX

Pause_BeamSwitchHandler:
    ; assume input flags are readable from (wJoy) or your project's input buffer
    ; This is an integration point: the caller should call this only while paused and leave A unchanged if not handling.
    ; For portability, the caller should set the carry flag or a register to indicate 'select pressed' OR we can read your input buffer here.
    ; Placeholder implementation expects the caller to have checked Select and simply call this routine to cycle the beam.
    ld a, (wActiveBeam)
    or a
    ; If no beams owned at all, do nothing
    ld b, (wBeam_Ice)
    or b
    ld b, (wBeam_Wave)
    or b
    ld b, (wBeam_Spazer)
    or b
    ld b, (wBeam_Plasma)
    or b
    jr z, .no_beams ; none owned

    ; Cycle in order: none -> Ice -> Wave -> Spazer -> Plasma -> Ice ...
    ; If current is 0 (none), pick first owned beam in order
    ld a, (wActiveBeam)
    cp #0
    jr z, .pick_first
    ; advance to next
    inc a
    cp #5
    jr nz, .wrap_check
    ld a, #1
.wrap_check:
    ; if the beam in 'a' is owned, keep it; otherwise keep incrementing until we find one
.find_owned:
    cp #1
    jr z, .check_ice
    cp #2
    jr z, .check_wave
    cp #3
    jr z, .check_spazer
    cp #4
    jr z, .check_plasma
    ; safety fallback
    ld a, (wActiveBeam)
    ret

.check_ice:
    ld c, (wBeam_Ice)
    or c
    jr nz, .set_active
    inc a
    jr .find_owned

.check_wave:
    ld c, (wBeam_Wave)
    or c
    jr nz, .set_active
    inc a
    jr .find_owned

.check_spazer:
    ld c, (wBeam_Spazer)
    or c
    jr nz, .set_active
    inc a
    jr .find_owned

.check_plasma:
    ld c, (wBeam_Plasma)
    or c
    jr nz, .set_active
    ; loop back to ice
    ld a, #1
    jr .find_owned

.set_active:
    ld (wActiveBeam), a
    ; Optionally trigger a sound/visual to indicate current beam selection

