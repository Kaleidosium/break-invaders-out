INCLUDE "defines.asm"

SECTION "Sprite Paddle Update", ROM0

SpritePaddleUpdate::

    ldh a, [hHeldKeys]
    bit PADB_LEFT, a
    jr nz, .moveLeft
    bit PADB_RIGHT, a
    jr nz, .moveRight

.render
    ld bc, (150.0 >> 12) & $FFFF ; Y Position of the Metasprite
    ld a, [wPaddlePosition]
    ld e, a
    ld a, [wPaddlePosition + 1]
    ld d, a
    ld hl, PaddleMetasprite
    call RenderMetasprite

    ret
.moveLeft
    ; If going out of bounds, then do nothing
    ld hl, wPaddlePosition + 1 ; High byte
    ld a, [hld]

    ; Add 1 to check for > instead of >=
    cp a, HIGH(8 << 4) + 1
    ld a, [hl]
    jr nc, .inBoundsLeft
    cp a, LOW(8 << 4)
    jr c, .render

.inBoundsLeft
    sub a, 1 << 4  ; Subtract 1.0 to low byte
    ld [hli], a ; Write new value back

    ; If no carry, nothing else to do
    jr nc, .render
    dec [hl]    ; Subtract carry to high byte (HL incremented by `ld [hli], a`)
    jr .render

.moveRight
    ; If going out of bounds, then do nothing

    ld hl, wPaddlePosition + 1 ; High byte
    ld a, [hld]
    
    cp a, HIGH(148 << 4) ; SCRN_X - 12
    ld a, [hl]
    jr c, .inBoundsRight
    cp a, LOW(148 << 4)
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
    db 0, 0, $01, 0
    db 0, 8, $02, 0
    db 0, 16, $03, 0
    db 128

SECTION "Sprite Ball Update", ROM0

; TODO(alt): Bounch back if Ball goes OOB
SpriteBallUpdate::
    ld de, $0400
    ld a, [wBallPosition]
    dec a
    ld [wBallPosition], a
    ld b, a
    ld a, [wBallPosition + 1]
    ld c, a
    call RenderSimpleSprite

    ret

SECTION "Position Vars", WRAM0
; Q12.4 fixed-point X posiition
wPaddlePosition::
    ds 2

wBallPosition::
    ds 1