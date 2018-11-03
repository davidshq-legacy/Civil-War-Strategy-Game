' Called by cancel-move, fortify, usa-map, menu-commands, railroad, battle, and iterate
SUB stax (who)
	CALL starfin(star, fin, who)
	FOR i = star TO fin
	IF armysize(i) > 0 AND occupied(armyloc(i)) <> i THEN
		target = armyloc(i)
		x = cityx(target) - 12: y = cityy(target) - 12
		CIRCLE (x, y), 3, 14
	END IF
	NEXT i
END SUB