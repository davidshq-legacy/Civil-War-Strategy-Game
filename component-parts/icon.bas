SUB icon (from, dest, kind)
	IF from < 1 OR from > 40 GOTO noshow
	IF dest < 0 GOTO noshow
	IF from = 999 GOTO noshow
	x = cityx(from) - 12: y = cityy(from) - 11
	x1 = cityx(dest): y1 = cityy(dest)
	SELECT CASE kind
		CASE 1
		LINE (x, y)-(x1, y1), 15, , &HF0F0
		
		CASE 2
		FOR i = 6 TO 8
		LINE (x - i, y - i + 3)-(x + i, y + i - 3), 14, B
		NEXT i
		CALL TICK(.1)
		
		CASE 3
		x = cityx(from): y = cityy(from)
		CALL snapshot(x, y, 0)
		FOR j = 1 TO 3
		FOR i = 4 TO 10 STEP 1
		CIRCLE (x, y), i, 4
		PAINT (x, y), 14, 4
		IF noise > 0 THEN SOUND 37 + 50 * RND, .03
		NEXT i
		CALL TICK(.1)
		CALL snapshot(x, y, 1)
		NEXT j
		
		CASE 4
		IF occupied(from) = 0 THEN LINE (x - 8, y - 6)-(x + 10, y + 8), 2, BF
		IF x1 + y1 > 0 THEN LINE (x, y)-(x1, y1), 2, , &HF0F0
		IF from = 27 OR from = 28 THEN CALL touchup

		CASE 5
		IF x1 + y1 > 0 THEN LINE (x, y)-(x1, y1), 2, , &HF0F0

		CASE 6
		x = cityx(from): y = cityy(from)
		CALL snapshot(x, y, 0)
		LINE (x - 9, y - 9)-(x + 9, y + 9), 15, B
		LINE (x - 10, y - 10)-(x + 10, y + 10), 15, B
		IF noise > 0 THEN SOUND 3999, .3
		CALL TICK(turbo! - .5)
		CALL snapshot(x, y, 1)
		CASE 7          ' draw white box
		x = cityx(from) - 12: y = cityy(from) - 11
		GET (x - 8, y - 8)-(x + 8, y + 8), image
		LINE (x - 7, y - 7)-(x + 7, y + 7), 15, B
		LINE (x - 8, y - 6)-(x + 8, y + 6), 15, B
			CASE 8     ' replace old image
		x = cityx(from) - 12: y = cityy(from) - 11
		IF x > 0 THEN PUT (x - 8, y - 8), image, PSET
		
		CASE 9          ' draw arrow pointer
		x = cityx(from) - 12: y = cityy(from) - 11
		GET (x - 8, y - 8)-(x + 10, y + 7), image
		x = x + 7: y = y + 5
		LINE (x + 2, y)-(x + 2, y - 8), 12
		LINE -(x, y - 6), 12
		LINE -(x - 5, y - 11), 12
		LINE -(x - 10, y - 6), 12
		LINE -(x - 6, y - 2), 12
		LINE -(x - 10, y), 12
		LINE -(x + 1, y), 12
		PAINT (x - 2, y - 1), 15, 12

		CASE 11
		LINE (x + 12, y + 11)-(x1, y1), 0, , &H1111

		CASE ELSE
	END SELECT
	noshow:
END SUB