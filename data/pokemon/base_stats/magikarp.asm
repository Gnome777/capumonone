	db DEX_MAGIKARP ; pokedex id

	db  20,  10,  60,  80,  20
	;   hp  atk  def  spd  spc

	db WATER, WATER ; type
	db 200 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/front/magikarp.pic", 0, 1 ; sprite dimensions
	dw MagikarpPicFront, MagikarpPicBack

	db SPLASH, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm
	; end

	db 0 ; padding
