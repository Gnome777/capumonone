	db DEX_PARASECT ; pokedex id

	db  60,  70,  80,  30,  80
	;   hp  atk  def  spd  spc

	db BUG, GRASS ; type
	db 100 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/front/parasect.pic", 0, 1 ; sprite dimensions
	dw ParasectPicFront, ParasectPicBack

	db LEECH_LIFE, SLEEP_POWDER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm
	; end

	db 0 ; padding
