IF rr(side) = 0 THEN
	COLOR 15: LOCATE 4, 68: PRINT "RAILROAD MOVE"
	PSET (550, 20), 0
	DRAW "C15S6R9D4R6U3R3D3R7U5H3U2R9D3G2D6F1D3F5L10D1G1L4H2L7G2L3H2L3U9L2U5R1BF4"
	z = 9: IF side = 2 THEN z = 7
	x = POINT(0): y = POINT(1)
	PAINT (x, y), z, 15
	COLOR 15: IF side = 1 THEN COLOR 11
	CALL traincapacity(side, limit)
	CALL clrbot: PRINT "Railroad capacity ="; RTRIM$(STR$(limit)); "00";
	CALL railroad(side)
ELSE
	CALL clrbot: COLOR 11: PRINT "Railroad is already carrying "; armyname$(rr(side)); " to "; city$(armymove(rr(side))); : GOTO menu0
END IF