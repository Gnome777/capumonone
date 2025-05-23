	object_const_def
	const_export POKEMONTOWER5F_CHANNELER1
	const_export POKEMONTOWER5F_CHANNELER2
	const_export POKEMONTOWER5F_CHANNELER3
	const_export POKEMONTOWER5F_CHANNELER4
	const_export POKEMONTOWER5F_CHANNELER5
	const_export POKEMONTOWER5F_NUGGET

PokemonTower5F_Object:
	db $1 ; border block

	def_warp_events
	warp_event  3,  9, POKEMON_TOWER_4F, 1
	warp_event 18,  9, POKEMON_TOWER_6F, 1

	def_bg_events

	def_object_events
	object_event 12,  8, SPRITE_CHANNELER, STAY, NONE, TEXT_POKEMONTOWER5F_CHANNELER1
	object_event 17,  7, SPRITE_CHANNELER, STAY, LEFT, TEXT_POKEMONTOWER5F_CHANNELER2, OPP_CHANNELER, 14
	object_event 14,  3, SPRITE_CHANNELER, STAY, LEFT, TEXT_POKEMONTOWER5F_CHANNELER3, OPP_CHANNELER, 16
	object_event  6, 10, SPRITE_CHANNELER, STAY, RIGHT, TEXT_POKEMONTOWER5F_CHANNELER4, OPP_CHANNELER, 17
	object_event  9, 16, SPRITE_CHANNELER, STAY, RIGHT, TEXT_POKEMONTOWER5F_CHANNELER5, OPP_CHANNELER, 18
	; object_event  6, 14, SPRITE_POKE_BALL, STAY, NONE, TEXT_POKEMONTOWER5F_NUGGET, NUGGET

	def_warps_to POKEMON_TOWER_5F
