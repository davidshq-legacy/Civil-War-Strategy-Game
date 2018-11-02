' Checks integrity of map links.
' Can be called from utility menu.
SUB integrity
	CLS : COLOR 15
	x = 0: y = 0
	FOR i = 1 TO 40
	FOR j = 1 TO 6: IF matrix(i, j) = 0 GOTO done
		index = matrix(i, j)
		FOR k = 1 TO 6
		IF matrix(index, k) = i GOTO ret
		IF matrix(index, k) = 0 THEN matrix(index, k) = i: PRINT "+ Adding return route from "; city$(index); " to "; city$(i): y = y + 1: GOTO ret
		NEXT k
		x = x + 1: PRINT "Error in CITIES.GRD entry for city #"; i; city$(index); ": no return route to "; city$(i): TICK 1
	ret:
	NEXT j
	done:
	NEXT i
	IF x + y = 0 THEN PRINT "ALL MAP LINKS ARE OK": EXIT SUB
	IF y > 0 THEN PRINT "* "; y; " fixes made to provide RETURN ROUTES"
	IF x > 0 THEN PRINT "** "; x; " UNRESOLVED RETURN ROUTES"
END SUB