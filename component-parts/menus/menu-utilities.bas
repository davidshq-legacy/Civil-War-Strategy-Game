utile:
	chosit = 29
	mtx$(0) = "Utility"
	mtx$(1) = "Side": IF player = 2 THEN mtx$(2) = ""
	mtx$(2) = "1 Player": IF player = 2 THEN mtx$(2) = "2 Player"
	mtx$(3) = "Graphics" + STR$(graf)
	mtx$(4) = "Noise": IF noise > 0 THEN mtx$(4) = mtx$(4) + STRING$(noise, "*")
	mtx$(5) = "Display" + STR$(turbo!)
	a$ = STR$(difficult): IF side = 1 THEN a$ = STR$(6 - difficult)
	mtx$(6) = "Balance" + a$
	mtx$(7) = "End Cond"
	a$ = "+": IF randbal = 0 THEN a$ = ""
	mtx$(8) = "Rndom Evt " + a$
	mtx$(9) = "Vary Start"
	a$ = "": IF jancam = 1 THEN a$ = "+"
	mtx$(10) = "Jan Campgn" + a$
	a$ = "": IF realism = 1 THEN a$ = "+"
	mtx$(11) = "Realism " + a$
	mtx$(12) = "Chk Links"
	a$ = "": IF history = 1 THEN a$ = "+"
	mtx$(13) = "History" + a$
	size = 13: tlx = 67: tly = 11
	COLOR 11: LOCATE tly - 2, tlx: PRINT "esc=Main Menu"
	IF player = 1 THEN size = 14: mtx$(14) = "Aggress" + STR$(bold)
	CALL menu(-1): CALL clrrite
	    SELECT CASE choose
	    CASE 1 ' Swap Sides
		IF player = 2 GOTO menu0
		side = 3 - side: COLOR 9: IF side = 2 THEN COLOR 7
		CALL clrbot: PRINT "Now playing "; force$(side); " side"; : IF noise > 0 THEN SOUND 999, 1
		IF side = 1 THEN randbal = 7
		IF side = 2 THEN randbal = 3
		CALL topbar
		GOTO menu0
	    CASE 2  ' Solo or Two Player
		player = 3 - player: CALL clrbot: COLOR 12
		IF noise > 0 THEN SOUND 999, 1
		a$ = "Solo": IF player = 2 THEN a$ = "2 Player"
		PRINT a$; " Game";
		choose = 23: GOTO utile
	    CASE 3 ' Graphics
		graf = graf + 1
		IF graf > 3 THEN graf = 0
		a$ = "ROADS"
		IF graf = 0 THEN a$ = "DISABLED"
		IF graf = 2 THEN a$ = "CITY NAMES"
		IF graf = 3 THEN a$ = "FULL"
		CLS
		CALL usa
		CALL clrbot: COLOR 11: PRINT "Graphics : "; a$; : IF noise > 0 THEN SOUND 2700, 1
		choose = 24: GOTO utile
	    CASE 4 ' Sounds
		CALL clrrite: choose = noise + 22
		mtx$(0) = "SOUNDS"
		mtx$(1) = "Quiet"
		mtx$(2) = "Sound"
		mtx$(3) = "Full"
		size = 3: tlx = 67: tly = 12
		CALL menu(0): CALL clrrite
		IF choose < 1 GOTO menu0
		COLOR 11: CALL clrbot: PRINT "Sound Option : "; mtx$(choose);
		noise = choose - 1
		IF noise > 0 THEN SOUND 999, 1
		choose = 25: GOTO utile
	    CASE 5 ' Display Speed
		choose = turbo! + 21
		mtx$(0) = "Display"
		mtx$(1) = "Fast"
		mtx$(2) = "Normal"
		mtx$(3) = "Slow"
		mtx$(4) = "Very Slow"
		mtx$(5) = "Reg Color": IF bw > 0 THEN mtx$(5) = "Alt Color"
		tlx = 67: tly = 15: size = 5
		CALL menu(0): CALL clrrite
		SELECT CASE choose
			CASE IS < 1
			CASE IS < 5
				turbo! = choose
				IF turbo! = 4 THEN turbo! = 8
				CALL clrbot: COLOR 11
				PRINT "Display Speed : "; mtx$(choose);
			CASE 5
				bw = 1 - bw
				CLS
				CALL usa
				CALL topbar
		END SELECT
		choose = 26: GOTO utile
	   CASE 6 ' Play Balance
		choose = difficult + 21
		mtx$(0) = "Balance"
		mtx$(1) = "Rebel ++"
		mtx$(2) = "Rebel +"
		mtx$(3) = "Balanced"
		mtx$(4) = "Union +"
		mtx$(5) = "Union ++"
		tlx = 67: tly = 15: size = 5
		CALL menu(8): CALL clrrite
		IF choose < 1 GOTO menu0
		CALL clrbot
		COLOR 11: CALL clrbot: PRINT "Play Balance : "; mtx$(choose);
		difficult = choose
		GOSUB unionplus
		choose = 27: GOTO utile
	   CASE 7 ' Ending Conditions
		CALL endit
		choose = 28: GOTO utile
	   CASE 8 ' Random Event Options
		 mtx$(0) = "Random Events"
		 size = 4: tlx = 30: tly = 8
		 mtx$(1) = "OFF"
		 mtx$(2) = "Favor Union ": IF randbal = 3 THEN mtx$(2) = mtx$(2) + " +"
		 mtx$(3) = "Neutral     ": IF randbal = 5 THEN mtx$(3) = mtx$(3) + " +"
		 mtx$(4) = "Favor Rebels": IF randbal = 7 THEN mtx$(4) = mtx$(4) + " +"
		 colour = 5
		 CALL menu(0)
		 colour = 4

		 SELECT CASE choose
		 CASE 1
		 randbal = 0: t$ = ""
		 CASE 2
		 randbal = 3
		 CASE 3
		 randbal = 5
		 CASE 4
		 randbal = 7
		 CASE ELSE
		 END SELECT
		 IF choose > 1 AND choose < 5 THEN t$ = mtx$(choose)
		 CALL clrbot
		 a$ = "": IF randbal = 0 THEN a$ = "OFF"
		 COLOR 11: PRINT "Random Events : "; a$; " "; t$;
		 COLOR 14: PRINT "			press a key";
		 DO WHILE INKEY$ = "": LOOP
		 CLS
		 CALL usa
		 choose = 29
		 GOTO utile
	   CASE 9 ' Vary Start Conditions
		CALL filer(1)
		cash(1) = cash(1) - 100 + 200 * RND
		cash(2) = cash(2) + 100 + 200 * RND
		bold = 5 * RND
		FOR k = 1 TO 6
			IF RND > .6 THEN
			armyloc(k) = 0: armysize(k) = 0: armylead(k) = 0
			armyexper(k) = 0: armymove(k) = 0: supply(k) = 0
			END IF
		NEXT k
		FOR k = 21 TO 6
			IF RND > .6 THEN
			armyloc(k) = 0: armysize(k) = 0: armylead(k) = 0
			armyexper(k) = 0: armymove(k) = 0: supply(k) = 0
			END IF
		NEXT k
		FOR k = 1 TO 40: CALL occupy(k): NEXT k
		navysize(1) = 10 * RND: IF navysize(1) = 0 THEN navyloc(1) = 0
		navysize(2) = 10 * RND: IF navysize(2) > 0 THEN navyloc(2) = 27
		FOR i = 1 TO 2
			fleet$(i) = ""
			FOR j = 1 TO navysize(i)
			a$ = "W": IF RND > .45 * side THEN a$ = "I"
			fleet$(i) = fleet$(i) + a$
		NEXT j
		NEXT i
		IF RND > .7 THEN capcity(2) = 25

		FOR k = 1 TO 40
		IF RND > .8 THEN rating(k) = rating(k) - 3 + 6 * RND: IF rating(k) > 9 THEN rating(k) = 9
		IF rating(k) < 1 THEN rating(k) = 1
		NEXT k
		CLS
		CALL usa
		choose = 30: GOTO utile
	   CASE 10 ' January Campaigns
		jancam = 1 - jancam
		a$ = "PROHIBITED": IF jancam = 1 THEN a$ = "ALLOWED"
		COLOR 11
		CALL clrbot
		PRINT "January Campaigns : "; a$;
		choose = 31: GOTO utile
	   CASE 11 ' Realism Switch
		realism = 1 - realism
		CALL clrbot: COLOR 11
	IF realism = 0 THEN
		PRINT "Recruiting FIXED :  7000 for NEW Armies   4500 for Additions";
	ELSE
		PRINT "REALISM ON: Recruiting based on CITY SIZE";
		IF side = 2 AND randbal = 1 AND randbal < 5 THEN randbal = randbal + 2
		GOSUB unionplus
	END IF
		choose = 32: GOTO utile
	   CASE 12 ' Check Map Linkages
		CALL integrity
		CALL TICK(99)
		CALL usa
	   CASE 13 ' History
		history = 1 - history
		a$ = "OFF": IF history = 1 THEN a$ = "ON"
		CALL clrbot: PRINT "History is now "; a$;
		choose = 34: GOTO utile
	   CASE 14 ' Aggression
		bold = bold + 1: IF bold > 5 THEN bold = 0
		SELECT CASE bold
		CASE 0: a$ = "PASSIVE"
		CASE 1: a$ = "TIMID"
		CASE 2: a$ = "CAUTIOUS"
		CASE 3: a$ = "NORMAL"
		CASE 4: a$ = "BOLD"
		CASE 5: a$ = "RECKLESS"
		END SELECT
		CALL clrbot
		COLOR 11
		PRINT "Enemy Aggression : "; a$; " ("; bold; ")";
		choose = 35: GOTO utile
		CASE ELSE
	   END SELECT