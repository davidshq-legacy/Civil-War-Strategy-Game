SUB placearmy (which)
who = 1: IF which > 20 THEN who = 2
x = cityx(armyloc(which)) - 12
y = cityy(armyloc(which)) - 11
CALL armyxy(x, y, who)
IF supply(which) < 1 THEN
	x = x - 3: y = y + 4
	PSET (x, y), 13: DRAW "C11S8"
	DRAW font$(19)
	DRAW "S4"
END IF
END SUB