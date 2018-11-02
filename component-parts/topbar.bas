SUB topbar
	LOCATE 1, 1: PRINT SPACE$(80);
	COLOR 11
	LOCATE 1, 10: PRINT "Input your decisions now for "; force$(side); " side "; : COLOR 14: PRINT month$(month); ","; year; "  "

	CALL flags((side), 0, 0)
	COLOR 4: IF bw > 0 THEN COLOR 7
	LOCATE 6, 68: PRINT "Difficulty "; LTRIM$(RTRIM$(STR$(difficult)))
	LOCATE 7, 68: PRINT "Funds:"; cash(side);

	FOR i = 1 TO 2
		IF victory(i) < 0 THEN victory(i) = 0
	NEXT i
	x = victory(1) + victory(2): y = 0
	c = 9: IF side = 2 THEN c = 7
	LINE (580, 15)-(580, 35), 15
	LINE (530, 20)-(630, 30), 8 - c, BF
	IF x > 0 THEN y = 100 * (victory(side) / x)

	LINE (530, 20)-(530 + y, 30), c, BF
	COLOR c: LOCATE 4, 68: PRINT "VP :"; victory(side)

	LOCATE 5, 68: PRINT "("; y; "%)"

a$ = "  Snd"
IF noise < 2 THEN a$ = "   Snd": IF noise = 0 THEN a$ = "      "
IF graf > 0 THEN a$ = a$ + " G" + LTRIM$(STR$(graf))
a$ = a$ + STR$(player)
COLOR c
LOCATE 26, 68: PRINT "F3 Redrw Scrn"
LOCATE 27, 68: PRINT "F7 End Turn"
LOCATE 28, 68: PRINT a$
END SUB