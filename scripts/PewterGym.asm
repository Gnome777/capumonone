PewterGym_Script:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	call nz, .LoadNames
	call EnableAutoTextBoxDrawing
	ld hl, PewterGymTrainerHeaders
	ld de, PewterGym_ScriptPointers
	ld a, [wPewterGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPewterGymCurScript], a
	ret

.LoadNames:
	ld hl, .CityName
	ld de, .LeaderName
	jp LoadGymLeaderAndCityName

.CityName:
	db "PEWTER CITY@"

.LeaderName:
	db "BROCK@"

PewterGymResetScripts:
	xor a
	ld [wJoyIgnore], a
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
	ret

PewterGym_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_PEWTERGYM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_PEWTERGYM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_PEWTERGYM_END_BATTLE
	dw_const PewterGymBrockPostBattle,              SCRIPT_PEWTERGYM_BROCK_POST_BATTLE

PewterGymBrockPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PewterGymResetScripts
	ld a, D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, [wGameStage] ; Check if player has beat the game
	and a
	jr nz, BrockRematchPostBattle
; fallthrough
PewterGymScriptReceiveTM34:
	; ld a, TEXT_PEWTERGYM_BROCK_WAIT_TAKE_THIS
	; ldh [hTextID], a
	; call DisplayTextID
	SetEvent EVENT_BEAT_BROCK
	; lb bc, TM_BIDE, 1
	; call GiveItem
	; jr nc, .BagFull
	; ld a, TEXT_PEWTERGYM_RECEIVED_TM34
	; ldh [hTextID], a
	; call DisplayTextID
	; SetEvent EVENT_GOT_TM34
	jr .gymVictory
.BagFull
	ld a, TEXT_PEWTERGYM_TM34_NO_ROOM
	ldh [hTextID], a
	call DisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_BOULDERBADGE, [hl]
	ld hl, wBeatGymFlags
	set BIT_BOULDERBADGE, [hl]

	ld a, HS_GYM_GUY
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_ROUTE_22_RIVAL_1
	ld [wMissableObjectIndex], a
	predef HideObject

	ResetEvents EVENT_1ST_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE

	; deactivate gym trainers
	SetEvent EVENT_BEAT_PEWTER_GYM_TRAINER_0

	jp PewterGymResetScripts

BrockRematchPostBattle:
	ld a, TEXT_PEWTERGYM_REMATCH_POST_BATTLE
	ldh [hSpriteIndex], a
	call DisplayTextID
	jp PewterGymResetScripts

PewterGym_TextPointers:
	def_text_pointers
	dw_const PewterGymBrockText,             TEXT_PEWTERGYM_BROCK
	dw_const PewterGymCooltrainerMText,      TEXT_PEWTERGYM_COOLTRAINER_M
	dw_const PewterGymGuideText,             TEXT_PEWTERGYM_GYM_GUIDE
	dw_const PewterGymBrockWaitTakeThisText, TEXT_PEWTERGYM_BROCK_WAIT_TAKE_THIS
	dw_const PewterGymReceivedTM34Text,      TEXT_PEWTERGYM_RECEIVED_TM34
	dw_const PewterGymTM34NoRoomText,        TEXT_PEWTERGYM_TM34_NO_ROOM
	dw_const PewterGymRematchPostBattleText, TEXT_PEWTERGYM_REMATCH_POST_BATTLE

PewterGymTrainerHeaders:
	def_trainers 2
PewterGymTrainerHeader0:
	trainer EVENT_BEAT_PEWTER_GYM_TRAINER_0, 5, PewterGymCooltrainerMBattleText, PewterGymCooltrainerMEndBattleText, PewterGymCooltrainerMAfterBattleText
	db -1 ; end

PewterGymBrockText:
	text_asm
	CheckEvent EVENT_BEAT_BROCK
	jr z, .beforeBeat
	jr .afterBeat
.afterBeat
	ld a, [wGameStage] ; Check if player has beat the game
	and a
	jr nz, .BrockRematch
	ld hl, .PostBattleAdviceText
	call PrintText
	jp .done
.beforeBeat
	; Show Brock's intro text
	ld hl, .PreBattleText
	call PrintText

	; Badge-based TrainerNo selector
	ld a, [wObtainedBadges]
	and %01111111 ; mask out Earth Badge
	ld b, 1
.loop
	bit 0, a
	jp z, .skip
	inc b
.skip
	srl a
	jp nz, .loop

	; cap b at 7
	ld a, b
	cp 7
	jp c, .setTrainerNo
	ld a, 7
.setTrainerNo
	ld [wTrainerNo], a
	ld a, OPP_BROCK
	ld [wCurOpponent], a

	; standard battle setup
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]

	ld hl, PewterGymBrockReceivedBoulderBadgeText
	ld de, PewterGymBrockReceivedBoulderBadgeText
	call SaveEndBattleTextPointers

	ld a, SCRIPT_PEWTERGYM_BROCK_POST_BATTLE
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a

	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer

	jp .done
.BrockRematch
	ld hl, PewterPreBattleRematch1Text
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .refused
	ld hl, PewterPreBattleRematch2Text
	call PrintText
	call Delay3
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, PewterGymRematchDefeatedText
	ld de, PewterGymRematchVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_BROCK
	ld [wCurOpponent], a
	ld a, 8
	ld [wTrainerNo], a
	ld a, $4 ; new script
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
	jr .endBattle
.refused
	ld hl, PewterGymRematchRefusedText
	call PrintText
	jr .done
.endBattle
	ld a, SCRIPT_PEWTERGYM_BROCK_POST_BATTLE
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
.done
	jp TextScriptEnd

.PreBattleText:
	text_far _PewterGymBrockPreBattleText
	text_end

.PostBattleAdviceText:
	text_far _PewterGymBrockPostBattleAdviceText
	text_end

PewterGymBrockWaitTakeThisText:
	text_far _PewterGymBrockWaitTakeThisText
	text_end

PewterGymReceivedTM34Text:
	text_far _PewterGymReceivedTM34Text
	sound_get_item_1
	text_far _TM34ExplanationText
	text_end

PewterGymTM34NoRoomText:
	text_far _PewterGymTM34NoRoomText
	text_end

PewterGymBrockReceivedBoulderBadgeText:
	text_far _PewterGymBrockReceivedBoulderBadgeText
	sound_level_up ; probably supposed to play SFX_GET_ITEM_1 but the wrong music bank is loaded
	text_far _PewterGymBrockBoulderBadgeInfoText ; Text to tell that the flash technique can be used
	text_end

PewterGymCooltrainerMText:
	text_asm
	ld hl, PewterGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PewterGymCooltrainerMBattleText:
	text_far _PewterGymCooltrainerMBattleText
	text_end

PewterGymCooltrainerMEndBattleText:
	text_far _PewterGymCooltrainerMEndBattleText
	text_end

PewterGymCooltrainerMAfterBattleText:
	text_far _PewterGymCooltrainerMAfterBattleText
	text_end

PewterGymGuideText:
	text_asm
	ld a, [wBeatGymFlags]
	bit BIT_BOULDERBADGE, a
	jr nz, .afterBeat
	ld hl, PewterGymGuidePreAdviceText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .PewterGymGuideBeginAdviceText
	ld hl, PewterGymGuideBeginAdviceText
	call PrintText
	jr .PewterGymGuideAdviceText
.PewterGymGuideBeginAdviceText
	ld hl, PewterGymGuideFreeServiceText
	call PrintText
.PewterGymGuideAdviceText
	ld hl, PewterGymGuideAdviceText
	call PrintText
	jr .done
.afterBeat
	ld hl, PewterGymGuidePostBattleText
	call PrintText
.done
	jp TextScriptEnd

PewterGymGuidePreAdviceText:
	text_far _PewterGymGuidePreAdviceText
	text_end

PewterGymGuideBeginAdviceText:
	text_far _PewterGymGuideBeginAdviceText
	text_end

PewterGymGuideAdviceText:
	text_far _PewterGymGuideAdviceText
	text_end

PewterGymGuideFreeServiceText:
	text_far _PewterGymGuideFreeServiceText
	text_end

PewterGymGuidePostBattleText:
	text_far _PewterGymGuidePostBattleText
	text_end

PewterGymRematchRefusedText:
	text_far _PewterGymRematchRefusedText
	text_end

PewterGymRematchVictoryText:
	text_far _PewterGymRematchVictoryText
	text_end

PewterGymRematchDefeatedText:
	text_far _PewterGymRematchDefeatedText
	text_end

PewterPreBattleRematch1Text:
	text_far _PewterGymRematchPreBattle1Text
	text_end

PewterPreBattleRematch2Text:
	text_far _PewterGymPreRematchBattle2Text
	text_end

PewterGymRematchPostBattleText:
	text_far _PewterGymRematchPostBattleText
	text_end
