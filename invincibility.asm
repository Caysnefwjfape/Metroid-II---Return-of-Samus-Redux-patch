; Invincibility routines
; Place into a free ROM bank and add to link list.
	INCLUDE "wram_vars.inc"

SECTION "Invincibility", ROMX

; SetInvincibility( ) - called after player takes damage
; Sets timer to 120 frames and sets the invincible flag
SetInvincibility:
    ld a, #120           ; frames
    ld (wInvincibilityTimer), a
    ld a, #1
    ld (wInvincibleFlag), a
    ret

; Called from sprite draw routine: if invincibility timer is active and low bit is set -> skip drawing Samus (flash)
Invincibility_SkipSpriteIfFlashing:
    ld a, (wInvincibilityTimer)
    or a
    jr z, .draw_normal   ; if zero, draw normally
    ; flash pattern: blink every other frame
    ld a, (wInvincibilityTimer)
    and #1
    jr z, .draw_normal   ; even -> draw
    ; odd -> skip draw (return with Z flag set to indicate skip)
    xor a
    ld (wPatchWorkByte), a
    ; return with a known state — calling code should check for a flag or just jump into draw skip
    ret

.draw_normal:
    ret

; Timer tick: called once per frame by the main game loop or player update routine
Invincibility_Tick:
    ld a, (wInvincibilityTimer)
    or a
    jr z, .done
    dec a
    ld (wInvincibilityTimer), a
    ; if reached zero, clear flag
    ld a, (wInvincibilityTimer)
    or a
    jr nz, .done
    ld (wInvincibleFlag), #0
.done:
    ret