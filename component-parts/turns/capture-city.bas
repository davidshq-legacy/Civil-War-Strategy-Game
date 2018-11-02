SUB capture (active, c, s, flag)
	cityp(c) = s: CALL clrbot
	a$ = armyname$(active) + " has captured " + city$(c)
	COLOR 11: PRINT armyname$(active) + " has captured " + city$(c);
	IF active < 21 AND noise > 1 THEN PLAY "MNMFL16o2T120dd.dd.co1b.o2do3g.ab.bb.ag"
	IF active > 20 AND noise > 1 THEN PLAY "MNMFT160o2L16geL8ccL16cdefL8ggge"
	IF c <> capcity(3 - s) THEN CALL flashcity(c)
	victory(s) = victory(s) + cityv(c)
	IF c = capcity(3 - s) THEN
		victory(s) = victory(s) + 100
		victory(3 - s) = victory(3 - s) - 100
		a$ = force$(3 - s) + " CAPITAL captured !"
		CALL scribe(a$, 1)
		CALL image2(city$(capcity(3 - s)) + " has fallen!", 4)
		capcity(3 - s) = 0
		CALL flashcity(c)
	END IF
	IF fort(c) > 0 AND flag > 0 THEN fort(c) = fort(c) - 1: x = cityx(c): y = cityy(c): LINE (x - 5, y - 5)-(x + 5, y + 5), 2, BF: CALL showcity
END SUB