SUB cancel (side)
CALL starfin(star, fin, (side))
counter:
CALL clrrite
	size = 0
	FOR j = star TO fin
	a$ = armyname$(j): IF LEN(a$) > 10 THEN x = INSTR(a$, " "): a$ = RIGHT$(a$, LEN(a$) - x)
	IF armyloc(j) > 0 AND armymove(j) > 0 THEN size = size + 1: mtx$(size) = a$: array(size) = armyloc(j)
	NEXT j
	CALL bubble(size)
	tlx = 67: tly = 2: wtype = 2
	mtx$(0) = "Cancel"
	IF size < 1 THEN CALL clrbot: COLOR 11: PRINT "No units have orders to cancel"; : EXIT SUB
	CALL menu(1)
	SELECT CASE choose
	 CASE 1 TO size
		target = array(choose)
	       
		FOR i = star TO fin
		IF armyloc(i) = target THEN x = INSTR(armyname$(i), mtx$(choose)): IF x > 0 AND armymove(i) > 0 THEN index = i
		NEXT i

		CALL clrbot: COLOR 11: PRINT armyname$(index); " has cancelled move to "; city$(armymove(index)); : CALL TICK(turbo + 1)
		CALL icon(armyloc(index), armymove(index), 4)
		armymove(index) = 0: IF noise > 0 THEN SOUND 2999, .5
		CALL stax(side)
	 CASE ELSE
		GOTO finix
	END SELECT
finix:
	CALL clrrite
END SUB