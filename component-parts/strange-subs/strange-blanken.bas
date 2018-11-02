blanken:        c = 1: IF side = 2 THEN c = 7
		CLS : LINE (100, 200)-(500, 300), c, BF
		LINE (100, 200)-(500, 300), 8 - c, B
		COLOR 7: LOCATE 14, 31: PRINT " "; month$(month); year
		COLOR 11: LOCATE 17, 30: PRINT force$(side); " PLAYER TURN"
		DO WHILE INKEY$ = "": LOOP
		RETURN