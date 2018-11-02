SUB fortify (target)
	target = 0: hilite = 11
	tlx = 67: tly = 2
	who = side
	CALL starfin(star, fin, who)
	size = 0
	FOR i = star TO fin
	IF armyloc(i) > 0 AND fort(armyloc(i)) < 2 THEN
		size = size + 1
		mtx$(size) = city$(armyloc(i))
		array(size) = armyloc(i)
	END IF
	NEXT i
	IF size = 0 THEN CALL clrbot: COLOR 11: PRINT "No cities eligible to fortify"; : EXIT SUB
	CALL bubble(size)
	mtx$(0) = "Fortify"
		choose = 31
		CALL menu(9): CALL clrrite
		IF choose < 0 GOTO nocity
		target = array(choose): CALL occupy(target): x = occupied(target): IF x < 0 GOTO nocity
		IF fort(target) > 1 THEN CALL clrbot: PRINT city$(target); " at MAXIMUM fortification level of 2"; : CALL TICK(4): GOTO nocity
		cost = 200
		IF cash(side) < cost THEN CALL clrbot: PRINT "Fortifications for "; city$(target); " cost "; cost; " and you only have "; cash(side); : CALL TICK(4): GOTO nocity
		COLOR 3
		fort(target) = fort(target) + 1
		cash(side) = cash(side) - cost
		CALL clrbot: PRINT city$(target); " fortifications increased to "; fort(target);
		CALL icon(target, 0, 6)
		CALL showcity
		IF armymove(x) > 0 THEN CALL icon(armyloc(x), armymove(x), 5)
		armymove(x) = -1
		CALL placearmy(x)
		CALL stax(who)
nocity:
END SUB