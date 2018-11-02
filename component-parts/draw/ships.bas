' Draws ships representing each navy on map.
SUB ships
	FOR s = 1 TO 2
	IF navysize(s) = 0 OR navyloc(s) = 0 THEN navyloc(s) = 0: GOTO sink
	IF navyloc(s) = 30 THEN x = 515: y = 268: GOTO float
	IF navyloc(s) = 28 THEN x = 517: y = 172: GOTO float
	IF navyloc(s) = 17 THEN x = 380: y = 425: GOTO float
	IF navyloc(s) = 99 THEN x = 495: y = 310: GOTO float
	x = cityx(navyloc(s)) + 25: y = cityy(navyloc(s)) + 25
	IF navyloc(s) = 24 THEN y = y + 5: x = x - 5
	float:
		PSET (x, y), 1
		a = 1: IF LEFT$(fleet$(s), 1) = "I" THEN a = 2
		CALL shipicon(s, a)
	sink:
	NEXT s
END SUB