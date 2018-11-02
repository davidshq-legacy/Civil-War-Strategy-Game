' Called by turn update.
SUB iterate
	FOR i = 1 TO 40: IF armyloc(i) > 0 THEN CALL placearmy(i)
	NEXT i

	month = month + 2
	IF month > 12 THEN month = 1: year = year + 1

	s = 1
	FOR i = 1 TO 40: IF armyloc(i) < 1 GOTO rip
	IF i > 20 THEN s = 2
	IF cash(s) >= .2 * armysize(i) THEN
		a = 1: IF realism > 0 THEN CALL cutoff(s, armyloc(i), a)
		IF a > 0 THEN
			supply(i) = supply(i) + 1
			cash(s) = cash(s) - .2 * armysize(i)
		END IF
	END IF
	IF (month < 7 OR month > 10) AND matrix(armyloc(i), 7) < 99 THEN supply(i) = supply(i) - 1
	IF matrix(armyloc(i), 7) = 99 AND navyloc(3 - s) = armyloc(i) THEN supply(i) = supply(i) - 1: CALL clrbot: PRINT armyname$(i); " is blockaded"; : CALL TICK(turbo!)
	COLOR 13
	IF supply(i) < 1 THEN
		supply(i) = 0
		CALL clrbot
		PRINT armyname$(i); " is out of supplies";
		CALL placearmy(i)
		CALL TICK(turbo!)
		IF RND > .8 AND armysize(i) > 50 THEN armysize(i) = .9 * armysize(i)
	END IF
	rip:
	NEXT i
	FOR k = 1 TO 2: CALL stax(k): NEXT k
	y = 0: FOR i = 1 TO 20: y = y + .1 * armysize(i): NEXT i
	x = 0: FOR i = 21 TO 40: x = x + .1 * armysize(i): NEXT i
	IF side = 2 AND x > 0 THEN aggress! = y / x ELSE aggress! = 1
	IF side = 1 AND y > 0 THEN aggress! = x / y ELSE IF side = 1 THEN aggress! = 1
END SUB