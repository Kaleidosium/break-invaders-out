INCLUDE "defines.asm"

SECTION "Sprite Paddle Update", ROM0

SpritePaddleUpdate::

    ld hl, wPaddlePosition
    ld [hl], LOW((SCRN_X / 2) << 4)
    inc hl
    ld [hl], HIGH((SCRN_X / 2) << 4)

    ldh a, [hHeldKeys]
    bit PADB_LEFT, a
    jr nz, .moveLeft
    bit PADB_RIGHT, a
    jr nz, .moveRight

.render
    ld bc, (156.0 >> 12) & $FFFF ; Y Position of the Metasprite
    ld a, [wPaddlePosition]
    ld e, a
    ld a, [wPaddlePosition + 1]
    ld d, a
    ld hl, PaddleMetasprite
    call RenderMetasprite

    ret
.moveLeft
    ; ld hl, wPaddlePosition ; Low byte
    ; ld a, [hl]
    
    ; ; If going out of bounds, then do nothing
    ; cp LOW(8 << 4)
    ; jr c, .render
    ld hl, wPaddlePosition + 1 ; High byte
    
    ; If going out of bounds, then do nothing
    ld a, [hld]
    cp a, HIGH(8 << 4)
    jr c, .inBoundsLeft
    ld a, [hl]
    cp a, LOW(8 << 4)
    jr nc, .render

.inBoundsLeft
    sub a, 1 << 4  ; Subtract 1.0 to low byte
    ld [hli], a ; Write new value back

    ; If no carry, nothing else to do
    jr nc, .render
    dec [hl]    ; Subtract carry to high byte (HL incremented by `ld [hli], a`)
    jr .render

.moveRight
    ld hl, wPaddlePosition + 1 ; High byte
    
    ; If going out of bounds, then do nothing
    ld a, [hld]
    cp a, HIGH(152 << 4)
    jr c, .inBoundsRight
    ld a, [hl]
    cp a, LOW(152 << 4)
    jr nc, .render

.inBoundsRight
    add a, 1 << 4  ; Add 1.0 to low byte
    ld [hli], a ; Write new value back
    ; If no carry, nothing else to do
    jr nc, .render
    inc [hl]    ; Add carry to high byte (HL incremented by `ld [hli], a`)
    jr .render

PaddleMetasprite:
    ; Offsets, not Positions
    db -4, -12, $02, 0
    db -4, -4, $03, 0
    db -4, 4, $04, 0
    db 128

SECTION "Position Vars", WRAM0
; Q12.4 fixed-point X posiition
wMetaspritePosition:
    dw

wPaddlePosition:
    ds 2