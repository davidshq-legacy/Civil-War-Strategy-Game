SUB flags (who, w, a)
x = 585 + w: y = 200: IF w = 0 THEN y = 180
IF a <> 0 THEN y = a
SELECT CASE who
	CASE 1
	LINE (x - 17, y - 15)-(x + 17, y + 7), 4, BF
	FOR i = -13 TO 9 STEP 5
	LINE (x - 17, y + i)-(x + 17, y + i - 1), 7, B
	NEXT i
	LINE (x - 17, y - 15)-(x, y), 1, BF
	IF w = 0 THEN COLOR 9: LOCATE 10, 70: PRINT "U N I O N"
	FOR i = -16 TO -1 STEP 3
		FOR j = -14 TO -1 STEP 4: PSET (x + i, y + j), 7: NEXT j
	NEXT i
	CASE 2
	LINE (x - 17, y - 15)-(x + 17, y + 7), 4, BF
	LINE (x - 17, y - 13)-(x + 15, y + 7), 7
	LINE (x - 15, y - 15)-(x + 17, y + 5), 7

	LINE (x - 17, y + 7)-(x + 17, y - 15), 1
	LINE (x - 17, y + 6)-(x + 16, y - 15), 1
	LINE (x - 16, y + 7)-(x + 17, y - 14), 1
	LINE (x - 17, y + 5)-(x + 15, y - 15), 7
	LINE (x - 15, y + 7)-(x + 17, y - 13), 7

	LINE (x - 17, y - 15)-(x + 17, y + 7), 1
	LINE (x - 17, y - 14)-(x + 16, y + 7), 1
	LINE (x - 16, y - 15)-(x + 17, y + 6), 1
	LINE (x - 17, y - 15)-(x + 17, y + 7), 4, B

	IF w = 0 THEN COLOR 4: LOCATE 10, 70: PRINT "R E B E L"
	CASE ELSE
END SELECT
END SUB