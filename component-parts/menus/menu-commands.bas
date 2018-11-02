optmen:
	tlx = 67: tly = 13
	COLOR 11: LOCATE tly - 2, tlx: PRINT "esc=Main Menu"
	hilite = 15: colour = 3: chosit = 24
	mtx$(0) = "Commands"
	mtx$(1) = "Cancel"
	mtx$(2) = "Fortify": IF cash(side) < 200 THEN mtx$(2) = "-"
	mtx$(3) = "Join"
	mtx$(4) = "Supply"
	mtx$(5) = "Capital": IF capcity(side) = 0 OR cash(side) < 500 THEN mtx$(5) = "-"
	mtx$(6) = "Detach": IF side = 1 THEN mtx$(6) = "-"
	mtx$(7) = "Army Drill"
	mtx$(8) = "Relieve"
	mtx$(9) = "MAIN MENU"
	size = 9
	CALL menu(0): CALL clrrite
	chosit = 28
     SELECT CASE choose

		CASE 1 ' Cancel
	CALL cancel(side): mflag = 0
	choose = 22
		CASE 2 '                               Fortify
	IF cash(side) < 200 THEN COLOR 11: CALL clrbot: PRINT "Not enough money for fort"; : GOTO menu0
	CALL fortify(target)
	IF cash(side) < 200 GOTO menu0
	choose = 23
	GOTO optmen

		CASE 3'                               Combine
	x = side
	CALL combine(x)
	IF x < 0 THEN
		CALL clrbot
		COLOR 11
		PRINT "No eligible armies in same city to combine";
		CALL stax(side)
		GOTO menu0
	END IF
	choose = 24
	GOTO optmen
		CASE 4 '                               Supply
		CALL starfin(star, fin, (side))
		mtx$(0) = "Supply"
		tlx = 67: tly = 5: colour = 5
		size = 0
		FOR i = star TO fin
		IF armyloc(i) = 0 OR supply(i) > 1 GOTO alone
		IF realism > 0 THEN
			CALL cutoff(side, armyloc(i), a)
			IF a < 1 THEN CALL clrbot: COLOR 15: PRINT force$(side); " army in "; city$(armyloc(i)); " is CUT OFF !"; : TICK turbo!: GOTO alone
		END IF
		size = size + 1
		max = 11: IF LEN(armyname$(i)) < 11 THEN max = LEN(armyname$(i))
		mtx$(size) = LEFT$(armyname$(i), max)
		array(size) = i
alone:
		NEXT i
		IF size = 0 THEN COLOR 11: CALL clrbot: PRINT "All eligible "; force$(side); " armies have supplies"; : GOTO menu0
		CALL menu(6): CALL clrrite
		IF choose < 0 GOTO menu0
		index = array(choose)
		IF supply(index) < 2 THEN
		CALL resupply(index)
		CALL placearmy(index)
		END IF
		choose = 25
		GOTO optmen
		CASE 5'                               Move Capital
	IF capcity(side) = 0 OR cash(side) < 500 THEN CALL clrbot: COLOR 11: PRINT "Cannot move capital"; : GOTO menu0
	cash(side) = cash(side) - 500
	victory(3 - side) = victory(3 - side) + 50
	CALL clrrite
	mtx$(0) = "Capital"
	a$ = city$(capcity(side))
	index = capcity(side): CALL newcity(index)
	IF index = 0 GOTO menu0
	capcity(side) = index
	CALL clrbot: PRINT force$(side); " capital moved from "; a$; " to "; city$(capcity(side));
	CALL clrrite
	CALL showcity
	CALL TICK(9): CALL clrbot
		CASE 6 ' Detach
	IF side = 1 THEN CALL clrbot: COLOR 11: PRINT "Option not available to Union"; : GOTO menu0
	COLOR 14: LOCATE 4, 68: PRINT "DETACH UNIT"
	CALL movefrom(index, target): IF target < 1 OR index < 1 GOTO menu0
	IF armysize(index) < 65 THEN CALL clrbot: PRINT "Too small to detach"; : CALL TICK(turbo!): GOTO menu0
	CALL commander(2, empty): IF empty = 0 GOTO menu0
	supply(empty) = .3 * supply(index): supply(index) = supply(index) - supply(empty): IF supply(index) < 0 THEN supply(index) = 0
	armysize(empty) = .3 * armysize(index): armysize(index) = armysize(index) - armysize(empty)
	armyloc(empty) = target: armyexper(empty) = armyexper(index): armymove(empty) = 0
	armylead(empty) = rating(empty)
	armyname$(empty) = lname$(empty): lname$(empty) = ""
	armyexper(empty) = armyexper(index)
	COLOR 11: CALL clrbot: PRINT "Unit #"; empty; " with "; : CALL strong(empty): PRINT " men detached under "; armyname$(empty); : CALL TICK(turbo!): IF noise > 0 THEN SOUND 2222, 1
	CALL stax(side)
	choose = 27
	GOTO optmen
		CASE 7 ' Drill
	COLOR 14: LOCATE 4, 68: PRINT "DRILL ARMY"
	CALL movefrom(index, target)
	IF target < 1 OR index < 1 THEN COLOR 11: CALL clrbot: PRINT "No armies remain eligible for drills in "; month$(month); : GOTO menu0
	IF armyexper(index) > 5 OR armyexper(index) >= armylead(index) THEN COLOR 12: CALL clrbot: PRINT armyname$(index); ": Army has reached maximum improvement through drilling"; : GOTO optmen
	armyexper(index) = armyexper(index) + 1
	CALL clrbot: PRINT armyname$(index); " has drilled to reach experience level "; armyexper(index); : IF noise > 0 THEN SOUND 2222, 1
	CALL TICK(turbo!): clrbot
	armymove(index) = -1
	choose = 28
	GOTO optmen
		CASE 8 ' Relieve
		CALL relieve(side)
		choose = 29
		GOTO optmen
		CASE ELSE
		chosit = 28
		GOTO menu0
      END SELECT
	choose = 21 + choose: GOTO optmen
