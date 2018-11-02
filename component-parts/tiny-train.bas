SUB tinytrain (who, flag)
	IF tracks(who) = 0 THEN EXIT SUB
	from = tracks(who)
	x = cityx(from) - 12: y = cityy(from) - 11
SELECT CASE flag
	CASE IS > 0
	LINE (x - 8, y - 6)-(x + 10, y + 7), 10, BF
	PSET (x - 6, y - 2), 3: c = 9: IF who = 2 THEN c = 15
	DRAW "C0S2R9D4R6U3R3D3R7U5H3U2R9D3G2D6F1D3F5L10D1G1L4H2L7G2L3H2L3U8L2U5BF4S4"
	x = POINT(0): y = POINT(1): PAINT (x, y), c, 0
	CASE ELSE
	LINE (x - 9, y - 8)-(x + 10, y + 8), 2, BF
END SELECT
END SUB