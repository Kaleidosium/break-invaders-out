SECTION "Sprite Paddle Update", ROM0

SpritePaddleUpdate::

    ; TODO(alt): Use Metasprites here, seems this code is super messy
    ; Basically, it renders 3 sprites, I should really use a metasprite
    ld hl, wShadowOAM
    ld [hl], $98
    inc hl
    ld [hl], $4C
    inc hl
    ld [hl], $02
    inc hl
    ld [hl], $0
    inc hl
    ld [hl], $98
    inc hl
    ld [hl], $54
    inc hl
    ld [hl], $03
    inc hl
    ld [hl], $0
    inc hl
    ld [hl], $98
    inc hl
    ld [hl], $5C
    inc hl
    ld [hl], $04
    inc hl
    ld [hl], $0

    ret