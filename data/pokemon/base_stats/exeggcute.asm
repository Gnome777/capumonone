	db DEX_EXEGGCUTE ; pokedex id

	db  60,  40,  80,  40,  60
	;   hp  atk  def  spd  spc

	db GRASS, PSYCHIC_TYPE ; type
	db 200 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/front/exeggcute.pic", 0, 1 ; sprite dimensions
	dw ExeggcutePicFront, ExeggcutePicBack

	db BARRAGE, GROWTH, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm
	; end

	db 0 ; padding
