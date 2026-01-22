; Spider ball speed adjust
; Replace or patch the constant(s) your disassembly uses for spider movement.
; Here we provide a symbolic constant SPIDER_SPEED you can use.

SECTION "SpiderSpeed", ROMX

; Recommended: change the constant(s) used by SpiderBall_Move to SPIDER_SPEED
; SPIDER_SPEED is 20% larger than the original. If your disassembly stores speed as one byte:
;   new_speed = original_speed * 1.20 (rounded)
; You can either:
;  - Replace immediate operand in SpiderBall_Move with SPIDER_SPEED
;  - Or load SPIDER_SPEED from WRAM or ROM table.

SPIDER_SPEED: ; for direct replacement, place the byte where the code reads constants
    db 0x14 ; example value (replace with computed value for your project's original speed)
; NOTE: The above is a placeholder. Find your SpiderBall speed constant(s) and multiply by 1.20,
; then replace them with the new constant(s). If speed uses signed byte arithmetic, adjust appropriately.