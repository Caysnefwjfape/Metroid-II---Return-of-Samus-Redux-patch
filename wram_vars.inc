; WRAM variables required by the patch.
; Add these to your project's WRAM allocation (or include this file in your wram header).

; Invincibility
wInvincibilityTimer:    ds 1    ; frames remaining (0 = no invuln)
wInvincibleFlag:        ds 1    ; boolean: 0 = normal, 1 = invulnerable

; Respin / Jump state
wRespinAllowed:         ds 1    ; internal flag (0/1) - used for repeated respin gating if you want
wPlayerAirState:        ds 1    ; (if your disasm already has player state, use that variable instead)

; Spider ball
; If your disasm already has a spider-speed constant or variable, replace it with SPIDER_SPEED constant there
; (no WRAM needed unless you prefer runtime adjustable value).

; Beam ownership + active beam
wBeam_Ice:              ds 1    ; 0/1
wBeam_Wave:             ds 1    ; 0/1
wBeam_Spazer:           ds 1    ; 0/1
wBeam_Plasma:           ds 1    ; 0/1
wActiveBeam:            ds 1    ; 0 = none, 1 = Ice, 2 = Wave, 3 = Spazer, 4 = Plasma

; Misc
wPatchWorkByte:         ds 1    ; temporary scratch used by routines