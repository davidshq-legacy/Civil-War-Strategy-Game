SUB victor
	x = 0: FOR j = 1 TO 20: IF armyloc(j) > 0 THEN x = x + armysize(j)
	NEXT j
	y = 0: FOR j = 21 TO 40: IF armyloc(j) > 0 THEN y = y + armysize(j)
	NEXT j

	CALL clrbot: COLOR 14
	IF vicflag(2) > 0 AND year >= vicflag(2) AND month < vicflag(1) THEN
		a$ = "Time almost expired (" + month$(vicflag(1)) + "," + STR$(vicflag(2)) + ")"
		CALL image2(a$, 4)
	END IF
    FOR i = 1 TO 2
	IF (i = 1 AND y = 0) OR (i = 2 AND x = 0) THEN j = 7: victory(i) = victory(i) + 300: GOTO finis

	IF year >= vicflag(2) AND month >= vicflag(1) AND vicflag(2) > 0 THEN j = 2: GOTO finis
	IF control(i) >= vicflag(3) AND vicflag(3) > 0 THEN j = 3: GOTO finis
	IF income(i) / (income(1) + income(2)) >= .01 * vicflag(4) AND vicflag(4) > 0 THEN j = 4: GOTO finis
	IF vicflag(5) > 0 AND capcity(3 - i) = 0 AND capcity(i) > 0 THEN j = 5: GOTO finis

	IF vicflag(6) > 0 THEN
		IF i = 1 THEN
			IF y = 0 THEN j = 7: GOTO finis
			IF x / y > vicflag(6) THEN j = 6: GOTO finis
		END IF
		IF i = 2 THEN
			IF x = 0 THEN j = 7: GOTO finis
			IF y / x > vicflag(6) THEN j = 6: GOTO finis
		END IF
	END IF

	CALL clrbot: COLOR 14
	IF vicflag(3) > 0 AND control(i) >= .9 * vicflag(3) THEN
		a$ = force$(i) + " side almost controls" + STR$(vicflag(3)) + " cities"
		CALL image2(a$, 4)
	END IF

	IF vicflag(4) > 0 AND income(i) / (income(1) + income(2)) >= .009 * vicflag(4) THEN
		a$ = force$(i) + " side close to" + STR$(vicflag(4)) + " % of total income"
		CALL image2(a$, 4)
	END IF

	IF vicflag(6) > 0 AND x > 0 AND y > 0 THEN
		IF (i = 1 AND x / y > .9 * vicflag(6)) OR (i = 2 AND y / x > .9 * vicflag(6)) THEN
		a$ = force$(i) + "side close to" + STR$(vicflag(6)) + ":1 strength ratio"
		CALL image2(a$, 4)
		END IF
	END IF
	GOTO stale

finis:
	SELECT CASE j
		CASE IS < 3
		a$ = "TIME EXPIRED"
		CASE 3
		a$ = STR$(2.5 * vicflag(3)) + "% CITIES CONTROLLED"
		CASE 4
		a$ = STR$(vicflag(4)) + " % OF TOTAL INCOME"
		CASE 5
		a$ = "CAPITAL CAPTURED"
		CASE 6
		a$ = STR$(vicflag(6)) + ":1 ARMY STRENGTH RATIO"
		CASE 7
		a$ = "ENEMY ANNIHILATED"
END SELECT
	CLS
	c = 1: IF i = 2 THEN c = 7
	LINE (0, 0)-(639, 479), 4, BF
	LINE (0, 40)-(550, 460), 0, BF
	CALL usa
	LINE (70, 140)-(485, 265), 0, BF
	LINE (50, 120)-(465, 250), c, BF
	LINE (50, 120)-(465, 250), 4, B
	COLOR 14
	t$ = force$(i) + " SIDE IS WINNING"
	IF j = 2 THEN CALL center(10, "Confederates will win a technical victory") ELSE CALL center(10, t$)

	COLOR 15
	t$ = "END GAME VICTORY CONDITION" + STR$(j - 1) + " REACHED"
	CALL center(12, t$)
	CALL center(14, a$)

	mtx$(0) = "End Game"
	mtx$(1) = "Yes"
	mtx$(2) = "No-Override"
	size = 2: colour = 4
	tlx = 27: tly = 18
	hilite = 15
	IF j = 7 THEN size = 1
	CALL menu(0)

	IF choose <> 1 AND j < 7 THEN
play4ever:
			vicflag(j) = vicflag(j) + 1
			IF j = 5 THEN vicflag(j) = 0
			CLS
			CALL usa
			EXIT SUB
	END IF
	mtx$(0) = "Options"
	mtx$(1) = "Quit this Game"
	mtx$(2) = "Play More"
	IF player = 1 THEN mtx$(2) = "No - Press Onward to " + city$(capcity(3 - side))
	size = 2: colour = 8
	tlx = 27: tly = 18
	IF j <> 7 THEN
		CALL menu(0)
		IF choose <> 1 GOTO play4ever
	ELSE
		victory(i) = victory(i) + 100
	END IF

	thrill = i
	CALL usa: CALL report(100 + side)
	IF j = 2 THEN FOR k = 1 TO 2: victory(k) = .7 * victory(k): NEXT k: CALL rwin: GOTO death

	IF i = 1 THEN CALL capitol: COLOR 15: LOCATE 2, 27: t$ = "UNION VICTORY  VP's=" + STR$(victory(1)): PRINT t$: GOTO death
	IF i = 2 THEN CALL rwin: COLOR 15: LOCATE 2, 27: t$ = "REBEL VICTORY  VP's=" + STR$(victory(2)): PRINT t$
death:
	COLOR 14: LOCATE 4, 40 - .5 * LEN(a$)
	IF history > 0 THEN
		CALL scribe(t$, 0)
		CALL scribe(a$, 0)
	END IF
	PRINT a$: CALL maxx
	EXIT SUB
stale:
    NEXT i
END SUB
