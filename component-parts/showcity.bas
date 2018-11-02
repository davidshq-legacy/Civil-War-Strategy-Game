SUB showcity
FOR i = 1 TO 40
c = 9: IF cityp(i) = 2 THEN c = 7
IF cityp(i) = 0 THEN c = 12
x = cityx(i): y = cityy(i)
IF i = capcity(1) OR i = capcity(2) THEN
	PUT (x - 6, y - 6), Ncap, PSET
	LINE (x + 9, y - 4)-(x + 15, y + 4), 0, BF
	LINE (x + 8, y - 5)-(x + 13, y + 2), 3, BF
	PSET (x + 8, y - 4)
	IF fort(i) = 1 THEN DRAW "BR2C0e1D6BL1R2"
	IF fort(i) = 2 THEN DRAW "C0e1R1F1D1G3R3"
ELSE
	IF fort(i) = 1 THEN LINE (x - 5, y - 5)-(x + 5, y + 5), 0, B
	IF fort(i) > 1 THEN LINE (x - 5, y - 5)-(x + 5, y + 5), 0, BF
	CIRCLE (cityx(i), cityy(i)), 4, 0
	CIRCLE (cityx(i), cityy(i)), 3, c
	PAINT (cityx(i), cityy(i)), c, c
END IF
IF graf = 0 GOTO nocon
	FOR j = 1 TO 6: IF matrix(i, j) > 0 THEN CALL icon(i, matrix(i, j), 11)
	NEXT j
nocon:
NEXT i
END SUB