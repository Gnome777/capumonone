	db DEX_GOLEM ; pokedex id

	db  80, 110, 130,  50,  60
	;   hp  atk  def  spd  spc

	db ROCK, ROCK ; type
	db 128 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/front/golem.pic", 0, 1 ; sprite dimensions
	dw GolemPicFront, GolemPicBack

	db TACKLE, DEFENSE_CURL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm
	; end

	db 0 ; padding
