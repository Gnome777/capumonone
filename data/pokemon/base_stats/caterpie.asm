	db DEX_CATERPIE ; pokedex id

	db  50,  30,  40,  50,  20
	;   hp  atk  def  spd  spc

	db BUG, BUG ; type
	db 255 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/front/caterpie.pic", 0, 1 ; sprite dimensions
	dw CaterpiePicFront, CaterpiePicBack

	db TACKLE, STRING_SHOT, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm
	; end

	db 0 ; padding
