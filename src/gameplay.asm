INCLUDE "defines.asm"

SECTION "Sprite Paddle Update", ROM0

SpritePaddleUpdate::

    ldh a, [hHeldKeys]
    bit PADB_LEFT, a
    jr nz, .moveLeft
    bit PADB_RIGHT, a
    jr nz, .moveRight

.renderPaddle
    ld bc, (150.0 >> 12) & $FFFF ; Y Position of the Metasprite
    ld a, [wPaddlePosition]
    ld e, a
    ld a, [wPaddlePosition + 1]
    ld d, a
    ld hl, PaddleMetasprite
    jr RenderMetasprite

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
    jr c, .renderPaddle

.inBoundsLeft
    sub a, 1 << 4  ; Subtract 1.0 to low byte
    ld [hli], a ; Write new value back

    ; If no carry, nothing else to do
    jr nc, .renderPaddle
    dec [hl]    ; Subtract carry to high byte (HL incremented by `ld [hli], a`)
    jr .renderPaddle

.moveRight
    ; If going out of bounds, then do nothing

    ld hl, wPaddlePosition + 1 ; High byte
    ld a, [hld]
    
    cp a, HIGH(148 << 4) ; SCRN_X - 12
    ld a, [hl]
    jr c, .inBoundsRight
    cp a, LOW(148 << 4)
    jr nc, .renderPaddle

.inBoundsRight
    add a, 1 << 4  ; Add 1.0 to low byte
    ld [hli], a ; Write new value back

    ; If no carry, nothing else to do
    jr nc, .renderPaddle
    inc [hl]    ; Add carry to high byte (HL incremented by `ld [hli], a`)
    jr .renderPaddle

PaddleMetasprite:
    ; Offsets, not Positions
    db 0, 0, $01, 0
    db 0, 8, $02, 0
    db 0, 16, $03, 0
    db 128

SECTION "Sprite Ball Update", ROM0

; TODO(alt): Bounch back if Ball goes OOB
; Preferably using wBallVelocity
SpriteBallUpdate::

.renderBall
    ld de, $0400

    ; Load X position and velocity
    ; We're checking X first due to a bug if we checked Y first
    ld a, [wBallPosition.x]
    ld hl, wBallVelocity.x

    add a, [hl]

    ; Check if we're out of bounds horizontally
    ; if not, load the new value to wBallPosition
    cp a, 1
    jr c, .outOfBounds
    cp a, 168
    jr nc, .outOfBounds
    ld [wBallPosition.x], a

    ; Load Y position
    ld a, [wBallPosition.y]
    ld hl, wBallVelocity.y

    add a, [hl]

    ; Check if we're out of bounds vertically
    ; if not, load the new value to wBallPosition.y
    cp a, 1
    jr c, .outOfBounds
    cp a, 144
    jr nc, .outOfBounds
    ld [wBallPosition.y], a

    jr .storePositions

.outOfBounds
    ; Load wBallVelocity.y, and then invert it
    ld hl, wBallVelocity.y
    xor a
    sub [hl]
    ld [hl], a

    ; Load wBallVelocity.x, and then invert it
    ASSERT wBallVelocity.y + 1 == wBallVelocity.x
    inc hl
    xor a
    sub [hl]
    ld [hl], a

.storePositions
    ld a, [wBallPosition.y]
    ld b, a

    ld a, [wBallPosition.x]
    ld c, a
    
    jp RenderSimpleSprite


SECTION "Position Vars", WRAM0
; Q12.4 fixed-point X posiition
wPaddlePosition::
    .x:: DS 2
    ; Y doesn't change

wBallPosition::
    .y:: DB
    .x:: DB

wBallVelocity::
    .y:: DB
    .x:: DB