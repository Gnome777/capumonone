; try to initiate a wild pokemon encounter
; returns success in Z
TryDoWildEncounter:
	ld a, [wPartyCount]
	and a
	jp z, .CantEncounter
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz
	ld a, [wMovementFlags]
	and a ; is player exiting a door, jumping over a ledge, or fishing?
	ret nz
	callfar IsPlayerStandingOnDoorTileOrWarpTile
	jr nc, .notStandingOnDoorOrWarpTile
.CantEncounter
	ld a, $1
	and a
	ret
.notStandingOnDoorOrWarpTile
	callfar IsPlayerJustOutsideMap
	jr z, .CantEncounter
	ld a, [wRepelRemainingSteps]
	and a
	jr z, .next
	dec a
	jr z, .lastRepelStep
	ld [wRepelRemainingSteps], a
.next
; determine if wild pokemon can appear in the half-block we're standing in
; is the bottom left tile (8,9) of the half-block we're standing in a grass/water tile?
	hlcoord 8, 9
	ld c, [hl]
	call TestGrassTile
	ld a, [wGrassRate]
	jr z, .CanEncounter
	ld a, $14 ; in all tilesets with a water tile, this is its id
	cp c
	ld a, [wWaterRate]
	jr z, .CanEncounter
	ld a, $32 ; left shore id
	cp c
	ld a, [wWaterRate]
	jr z, .CanEncounter ; left shore can spawn pokémon
; even if not in grass/water, standing anywhere we can encounter pokemon
; so long as the map is "indoor" and has wild pokemon defined.
; ...as long as it's not Viridian Forest or Safari Zone.
	ld a, [wCurMap]
	cp FIRST_INDOOR_MAP ; is this an indoor map?
	jr c, .CantEncounter2
	ld a, [wCurMapTileset]
	cp FOREST ; Viridian Forest/Safari Zone
	jr z, .CantEncounter2
	ld a, [wGrassRate]
.CanEncounter
; compare encounter chance with a random number to determine if there will be an encounter
	ld b, a
	ldh a, [hRandomAdd]
	cp b
	jr nc, .CantEncounter2
	ldh a, [hRandomSub]
	ld b, a
	ld hl, WildMonEncounterSlotChances
.determineEncounterSlot
	ld a, [hli]
	cp b
	jr nc, .gotEncounterSlot
	inc hl
	jr .determineEncounterSlot
.gotEncounterSlot
; determine which wild pokemon (grass or water) can appear in the half-block we're standing in
	ld c, [hl]
	ld hl, wGrassMons
	lda_coord 8, 9
	cp $14 ; is the bottom left tile (8,9) of the half-block we're standing in a water tile?
	jr z, .water
	cp $32
	jr nz, .gotWildEncounterType
.water
	ld hl, wWaterMons
.gotWildEncounterType
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld [wCurEnemyLevel], a
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld [wEnemyMonSpecies2], a
	ld a, [wRepelRemainingSteps]
	and a
	jr z, .willEncounter
	ld a, [wPartyMon1Level]
	ld b, a
	ld a, [wCurEnemyLevel]
	cp b
	jr c, .CantEncounter2 ; repel prevents encounters if the leading party mon's level is higher than the wild mon
	jr .willEncounter
.lastRepelStep
	ld [wRepelRemainingSteps], a
	ld a, TEXT_REPEL_WORE_OFF
	ldh [hTextID], a
	call EnableAutoTextBoxDrawing
	call DisplayTextID
.CantEncounter2
	ld a, $1
	and a
	ret
.willEncounter
	xor a
	ret

TestGrassTile:
	ld a, [wGrassTile]
	cp c
	jr z, .return
	ld a, [wCurMapTileset]
	cp FOREST
	jr nz, .return
	ld a, $34	; check for the extra grass tile in the forest tileset
	cp c
.return
	ret

INCLUDE "data/wild/probabilities.asm"
