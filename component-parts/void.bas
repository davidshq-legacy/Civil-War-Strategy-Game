SUB void (a, y)
	y = 0
	FOR j = 1 TO 6
	x = matrix(a, j): IF x = 0 GOTO tally5
	IF cityp(x) = side AND occupied(x) > 0 THEN y = y + armysize(occupied(x))
		FOR k = 1 TO 6: m = matrix(x, k): IF m = 0 OR m = a GOTO tally4
		IF cityp(m) = side AND occupied(m) > 0 THEN y = y + .1 * armysize(occupied(m))
	tally4:
		NEXT k
	NEXT j
	tally5:
END SUB