	db DEX_VENOMOTH ; pokedex id

	db  70,  70,  60,  90,  90
	;   hp  atk  def  spd  spc

	db BUG, POISON ; type
	db 100 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/front/venomoth.pic", 0, 1 ; sprite dimensions
	dw VenomothPicFront, VenomothPicBack

	db LEECH_LIFE, POISONPOWDER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm
	; end

	db 0 ; padding
