SUB filer (switch)
	SELECT CASE switch
		CASE 1
			OPEN "I", 1, "cwslead.dat"
			FOR i = 1 TO 40
				INPUT #1, lname$(i), rating(i)
			NEXT i
			CLOSE #1
			OPEN "I", 1, "cws.ini"
			FOR i = 0 TO 2
				INPUT #1, force$(i)
			NEXT i
			FOR i = 1 TO 12
				INPUT #1, month$(i)
			NEXT i
			INPUT #1, month, year
			'               set end game conditions
			FOR i = 1 TO 6
				INPUT #1, vicflag(i)
			NEXT i
			vicflag(3) = .4 * vicflag(3)
			INPUT #1, a             ' number of Yankee armies
			FOR i = 1 TO a
				INPUT #1, armyloc(i), armysize(i), armyexper(i), supply(i): occupied(armyloc(i)) = i: armyname$(i) = lname$(i): armylead(i) = rating(i): lname$(i) = ""
			NEXT i
			INPUT #1, a             ' number of Rebel armies
			FOR i = 21 TO 20 + a
				INPUT #1, armyloc(i), armysize(i), armyexper(i), supply(i)
				occupied(armyloc(i)) = i: armyname$(i) = lname$(i): armylead(i) = rating(i): lname$(i) = ""
			NEXT i
			FOR i = 1 TO 2
				INPUT #1, cash(i)
			NEXT i
				INPUT #1, ATKFAC, DEFAC, TCR
				INPUT #1, fleet$(1), navyloc(1), fleet$(2), navyloc(2)
				FOR k = 1 TO 2: navysize(k) = LEN(fleet$(k)): NEXT k
				INPUT #1, capcity(1), capcity(2)

			FOR i = 1 TO 8 ' star locations on flag
				INPUT #1, starx(i), stary(i)
			NEXT i 
				CLOSE #1
				OPEN "I", 1, "cws.cfg"
				INPUT #1, side, graf, noise, difficult, player, turbo!, randbal, train(1), train(2), jancam, realism, batwon(1), batwon(2), casualty&(1), casualty&(2), history, bold
				CLOSE #1
		CASE 2
			IF _FILEEXISTS("*.sav") THEN choose = -1: EXIT SUB
			mtx$(0) = "Load"
			size = 0
			FOR k = 1 TO 9
				t$ = "cws" + LTRIM$(STR$(k)) + ".sav"
				IF _FILEEXISTS(t$) THEN
					size = size + 1
					mtx$(size) = t$
					array(size) = k
				END IF
			NEXT k
			CALL bubble((size))
			tlx = 67: tly = 14 - .5 * size
			CALL menu(0)
			CALL clrrite
			IF choose < 1 THEN EXIT SUB
			OPEN "I", 1, "cws" + LTRIM$(STR$(array(choose))) + ".sav"
			COLOR 11: CALL clrbot: PRINT "Loading";
			INPUT #1, month, year, usadv, a
			FOR i = 1 TO 40: INPUT #1, armyname$(i), armysize(i), armylead(i), armyloc(i), armyexper(i), supply(i), armymove(i)
			IF armyloc(i) > 0 THEN
				IF armyname$(i) = lname$(i) THEN
					lname$(i) = ""
				ELSE
					who = 1: IF i > 20 THEN who = 2
					CALL starfin(star, fin, who)
					FOR k = star TO fin
					IF armyname$(i) = lname$(k) THEN lname$(k) = "": EXIT FOR
					NEXT k
				END IF
			END IF
			NEXT i
			FOR i = 1 TO 40: INPUT #1, occupied(i), cityp(i), fort(i): PRINT "."; : NEXT i
			FOR i = 1 TO 2: INPUT #1, cash(i), control(i), income(i), victory(i), capcity(i)
			INPUT #1, fleet$(i), navyloc(i), navymove(i), rr(i), tracks(i)
			navysize(i) = LEN(fleet$(i))
			NEXT i
			
			CLOSE #1
			OPEN "I", 1, "cws.cfg"
			INPUT #1, myside, graf, noise, difficult, player, turbo!, randbal, train(1), train(2), jancam, realism, batwon(1), batwon(2), casualty&(1), casualty&(2), history, bold
			CLOSE #1
			SCREEN 12: CLS
			CLOSE #1: CALL usa: CALL clrbot
			FOR k = 1 TO 2
			IF rr(k) > 0 THEN CALL tinytrain(k, 1)
			NEXT k
			side = a

		CASE 3
		mtx$(0) = "Save Game"
		FOR k = 1 TO 9
		mtx$(k) = "cws" + LTRIM$(STR$(k)) + ".sav"
		IF _FILEEXISTS(mtx$(k)) THEN mtx$(k) = mtx$(k) + " +"
		NEXT k
		tlx = 67: size = 9
		CALL menu(0)
		IF choose < 1 THEN clrrite: EXIT SUB
		COLOR 11: CALL clrbot: PRINT "Saving";

		OPEN "O", 1, "cws" + LTRIM$(STR$(choose)) + ".sav"
		WRITE #1, month, year, usadv, side
		FOR i = 1 TO 40: WRITE #1, armyname$(i), armysize(i), armylead(i), armyloc(i), armyexper(i), supply(i), armymove(i)
		NEXT i
		FOR i = 1 TO 40: WRITE #1, occupied(i), cityp(i), fort(i): PRINT "."; : NEXT i
		FOR i = 1 TO 2: WRITE #1, cash(i), control(i), income(i), victory(i), capcity(i)
		WRITE #1, fleet$(i), navyloc(i), navymove(i), rr(i), tracks(i)
		NEXT i
		CLOSE #1
		
		myside = side
		IF myside < 1 OR myside > 2 THEN myside = 1
		OPEN "O", 1, "cws.cfg"
		WRITE #1, myside, graf, noise, difficult, player, turbo!, randbal, train(1), train(2), jancam, realism, batwon(1), batwon(2), casualty&(1), casualty&(2), history, bold
		CLOSE #1
		CLS : CALL usa
	END SELECT
END SUB