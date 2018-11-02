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

SUB maptext
FOR k = 1 TO 40
	FOR j = 1 TO LEN(city$(k))
	a = cityx(k) + 6 * (j - 4) - 3
	x = ASC(MID$(UCASE$(city$(k)), j, 1)) - 64
	IF a > 527 GOTO nextc
	PSET (a, cityy(k) + 12), 10
	
	IF matrix(k, 7) < 90 THEN
		IF bw = 0 THEN DRAW "S4C0" ELSE DRAW "S4C7"
	ELSE
		DRAW "C10"
	END IF
	IF x > 0 AND x < 27 THEN DRAW font$(x)
	NEXT j
nextc:
NEXT k
END SUB