' When commanders have been exhausted, this creates the generic names
' for commanders using Roman Numerals.
SUB roman (target, a$)
	a$ = "Union "
	IF target > 20 THEN a$ = "Rebel "
	IF target > 20 THEN target = target - 20
	IF target > 10 THEN a$ = a$ + "X": target = target - 10
	SELECT CASE target
		CASE IS < 4
		x = target: GOSUB add1s
		CASE 4
		a$ = a$ + "IV"
		CASE 5 TO 8
		a$ = a$ + "V"
		x = target - 5
		GOSUB add1s
		CASE 9
		a$ = a$ + "IX"
		CASE 10
		a$ = a$ + "X"
	END SELECT
	EXIT SUB

	add1s:
	IF x > 0 THEN FOR k = 1 TO x: a$ = a$ + "I": NEXT k
	RETURN

END SUB