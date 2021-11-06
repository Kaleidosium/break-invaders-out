SECTION "Tiledata", ROMX

xTilesetBG::
    INCBIN "res/levels.tileset.BG.2bpp"
.end::

xTilesetSprites::
    INCBIN "res/levels.tileset.SPRITES.2bpp"
.end::    

xTilemap::
    INCBIN "res/level01.tilemap"
.end::


SECTION "OAM Vars", WRAM0

wSpritePaddle:: DS 4*3
wSpriteBall:: DS 4*1

  