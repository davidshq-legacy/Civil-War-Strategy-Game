	CALL report((side)): chosit = 27
	CALL starfin(star, fin, side)
	FOR i = star TO fin
	IF armymove(i) > 0 THEN CALL icon(armyloc(i), armymove(i), 1)
	NEXT i