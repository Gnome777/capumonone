CeruleanTradeHouse_Script:
	jp EnableAutoTextBoxDrawing

CeruleanTradeHouse_TextPointers:
	def_text_pointers
	dw_const MoveRelearnerText1,  TEXT_CERULEANTRADEHOUSE_GRANNY
	dw_const MoveDeleterText1, TEXT_CERULEANTRADEHOUSE_GAMBLER

CeruleanTradeHouseGrannyText:
	text_far _CeruleanTradeHouseGrannyText
	text_end

CeruleanTradeHouseGamblerText:
	text_asm
	ld a, TRADE_FOR_LOLA
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd
