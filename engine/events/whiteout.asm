Script_BattleWhiteout::
	callasm BattleBGMap
	sjump Script_Whiteout

Script_OverworldWhiteout::
	refreshscreen
	callasm OverworldBGMap

Script_Whiteout:
	writetext .WhitedOutText
	waitbutton
	special FadeOutPalettes
	pause 40
	special HealParty
	checkflag ENGINE_BUG_CONTEST_TIMER
	iftrue .bug_contest
	callasm HalveMoney
	callasm GetWhiteoutSpawn
	farscall Script_AbortBugContest
	special WarpToSpawnPoint
	newloadmap MAPSETUP_WARP
	endall

.bug_contest
	jumpstd bugcontestresultswarp

.WhitedOutText:
	text_far _WhitedOutText
	text_end

OverworldBGMap:
	call ClearPalettes
	call ClearScreen
	call WaitBGMap2
	call HideSprites
	call RotateThreePalettesLeft
	ret

BattleBGMap:
	ld b, SCGB_BATTLE_GRAYSCALE
	call GetSGBLayout
	call SetPalettes
	ret

HalveMoney:
; Halve the player's money.
	ld hl, wMoney
	ld a, [hl]
	srl a
	ld [hli], a
	ld a, [hl]
	rra
	ld [hli], a
	ld a, [hl]
	rra
	ld [hl], a
	ret

GetWhiteoutSpawn:
	ld a, [wd9fb]
	ld d, a
	ld a, [wd9fc]
	ld e, a

	ld a, $05
	ld hl, $5465
	rst $08

	ld a, c
	jr c, .yes
	xor a ; SPAWN_HOME

.yes
	ld [wDefaultSpawnpoint], a
	ret
