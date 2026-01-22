# Metroid II — Gameplay Patch (assembly modules)

What this patch implements:
- 120-frame invincibility after taking damage (with flashing).
- Repeated air-respin (press Jump in air, performs a somersault / "respin").
- Spider Ball top speed increased by 20%.
- Beam pickups now permanent, non-stackable (you can only acquire each beam type once).
- Pause menu "beam switch": while paused press SELECT to cycle the active beam (Ice → Wave → Spazer → Plasma).
- Small stability hardenings (input sanitization, bounds checks).

Integration overview:
1. Add the `asm/*.asm` files included here to your disassembly source tree.
2. Add WRAM labels contained in `asm/wram_vars.inc` to your WRAM variable definitions (or include that file).
3. Place each new module into a free ROM bank or wherever your disassembly keeps custom patches:
   - In RGBDS use `SECTION "Name", ROMX, BANK_X` or `SECTION "Name", ROM0` per your project's conventions.
4. Add calls/hooks at the points listed below (Player_TakeDamage, Sprite_Draw, Jump input handler, SpiderBall move routine, Beam pickup routine, Pause menu input handler).
   - If you have named symbols different from the ones in the examples, search for the functionality (damage handler, sprite draw, jump handling, spider-ball movement, beam pickup, pause input) and hook there.
5. Build the patched ROM with your normal RGBDS build system.
6. Create an IPS by comparing the original ROM and the patched ROM:
   - Example: `flips original.gb patched.gb -o mypatch.ips` or use Lunar IPS GUI.

Hook recommendations (where to call into new code):
- After the existing damage effects finish, call `SetInvincibility` (invincibility.asm).
- In the sprite drawing routine (before drawing Samus), insert `call Invincibility_SkipSpriteIfFlashing` to implement flashing.
- At the end of the jump-input handling (when jump button pressed and Samus is airborne), call `TryRespin` (respin.asm).
- In spider-ball movement routine, replace or adjust the speed constant(s) with `SPIDER_SPEED` (spiderball_speed.asm).
- In beam pickup handler, replace beam granting logic with a call to `Beam_PickupHook` (beams_patch.asm).
- In pause-menu input handler, call `Pause_BeamSwitchHandler` (pause_beam_switch.asm) so that SELECT cycles beams.

Testing checklist (after building patched ROM):
- Take damage — Samus should flash and be invulnerable for ~120 frames (~2 seconds at 60Hz).
- While airborne, press Jump repeatedly — each press should trigger a respin animation/state until landing.
- Enter spider-ball mode and confirm movement feels ~20% faster.
- Pick up a beam type — it should be granted if not previously acquired; trying to pick it up again should do nothing (no stacking).
- Pause the game, press SELECT — the active beam should cycle through Ice → Wave → Spazer → Plasma (and the currently selected beam is used when firing).
- Basic playthrough for stability: explore gravity transitions, repeated respins, and damage sequences to ensure no crashes.

If you want, tell me the disassembly repo (or paste some symbol names/nearby code snippets) and I'll adapt these to exact labels and produce a git-style patch/diff.
