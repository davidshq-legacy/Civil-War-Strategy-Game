DEFINT A-Z
DECLARE SUB animate (index%, flag%)
DECLARE SUB armies ()
DECLARE SUB armystat (index%)
DECLARE SUB armyxy (x%, y%, z%)
DECLARE SUB barnacle (who%)
DECLARE SUB battle (attack%, defend%, win%, lose%)
DECLARE SUB bub2 (limit%)
DECLARE SUB bubble (size%)
DECLARE SUB cancel (side%)
DECLARE SUB cannon ()
DECLARE SUB capitol ()
DECLARE SUB capture (active%, c%, s%, flag%)
DECLARE SUB center (y%, a$)
DECLARE SUB chessie ()
DECLARE SUB choices (b1%, wide%)
DECLARE SUB clrbot ()
DECLARE SUB combine (who%)
DECLARE SUB clrrite ()
DECLARE SUB commander (who%, empty%)
DECLARE SUB cutoff (who%, target%, a%)
DECLARE SUB endit ()
DECLARE SUB engine ()
DECLARE SUB evaluate (index%, x%)
DECLARE SUB events ()
DECLARE SUB filer (switch%)
DECLARE SUB flags (who%, w%, a%)
DECLARE SUB flashcity (which%)
DECLARE SUB fortify (target%)
DECLARE SUB icon (from%, dest%, kind%)
DECLARE SUB image2 (a$, s%)
DECLARE SUB integrity ()
DECLARE SUB iterate ()
DECLARE SUB ironclad ()
DECLARE SUB maptext ()
DECLARE SUB maxx ()
DECLARE SUB menu (switch%)
DECLARE SUB movefrom (index%, target%)
DECLARE SUB mxw (wide%)
DECLARE SUB navy (who%, x%)
DECLARE SUB newarmy (who%, empty%, target%)
DECLARE SUB newcity (index%)
DECLARE SUB normal (xbar%, vary%, result%)
DECLARE SUB occupy (x%)
DECLARE SUB placearmy (which%)
DECLARE SUB railroad (who%)
DECLARE SUB recruit (who%)
DECLARE SUB relieve (who%)
DECLARE SUB report (who%)
DECLARE SUB resupply (index%)
DECLARE SUB retreat (active%, x%)
DECLARE SUB roman (target%, a$)
DECLARE SUB rwin ()
DECLARE SUB schooner ()
DECLARE SUB scribe (a$, flag%)
DECLARE SUB shen ()
DECLARE SUB ships ()
DECLARE SUB shipicon (who%, flag%)
DECLARE SUB shiptype (who%, i%)
DECLARE SUB showcity ()
DECLARE SUB smarts ()
DECLARE SUB snapshot (x%, y%, flag%)
DECLARE SUB starfin (star%, fin%, who%)
DECLARE SUB stax (who%)
DECLARE SUB strong (index%)
DECLARE SUB surrender (who%)
DECLARE SUB TICK (sec!)
DECLARE SUB touchup ()
DECLARE SUB tupdate ()
DECLARE SUB tinytrain (who%, flag%)
DECLARE SUB traincapacity (who%, limit%)
DECLARE SUB topbar ()
DECLARE SUB usa ()
DECLARE SUB usamap ()
DECLARE SUB victor ()
DECLARE SUB void (a%, y%)
'==========================================================================
COMMON SHARED choose%, tlx%, tly%, size%, mtx$(), wtype%, colour%, hilite%
COMMON SHARED cityx(), cityy(), cityv(), cityp(), city$(), lname$(), filel
COMMON SHARED cash(), control(), matrix(), income(), anima(), rating(), rflag
COMMON SHARED nflag, bold, turbo!, rr(), starx(), stary(), mtn(), rrfrom()
COMMON SHARED image(), force$(), armyloc(), armyname$(), player, aggress!
COMMON SHARED armysize(), armylead(), armyexper(), supply(), month$()
COMMON SHARED rcity(), price(), vicflag(), tracks(), batwon(), cityo()
COMMON SHARED armymove(), month, year, array(), mflag, side, ATKFAC, DEFAC, TCR
COMMON SHARED navyloc(), navysize(), navymove(), occupied(), vptotal, fort()
COMMON SHARED victory(), graf, noise, capcity(), difficult, usadv, bw
COMMON SHARED train(), font$(), brray(), jancam, randbal, realism, casualty&()
COMMON SHARED pcode, history, thrill, fleet$(), commerce, raider, grudge
COMMON SHARED cwsdatapath$
'==========================================================================
DIM SHARED cityx(40), cityy(40), cityv(40), cityp(40), city$(40), lname$(40), rcity(5)
DIM SHARED cash(2), control(2), matrix(40, 7), income(2), anima(300), rating(40)
DIM SHARED mtx$(21), image(300), force$(2), armyloc(40), armyname$(40), vicflag(6)
DIM SHARED armysize(40), armylead(40), armyexper(40), supply(40), month$(12)
DIM SHARED armymove(40), array(40), starx(8), stary(8), mtn(1 TO 1564), rrfrom(2)
DIM SHARED navyloc(2), navysize(2), navymove(2), occupied(40), fort(40), rr(2)
DIM SHARED victory(2), capcity(2), emancipate, price(3), tracks(2), fleet$(2)
DIM SHARED train(2), font$(26), brray(40), casualty&(2), batwon(2), cityo(40)
DIM shared mtz$(21)

DIM SHARED graphic(1 TO 1564), Ncap(60)
DIM SHARED graft(1 TO 1564)

$EXEICON: 'cws.ico'
_ICON
_TITLE "VGA Civil War Strategy Game"

	' Necessary Preparations for File Management
	' That Supports Microsoft UWP restrictions
	' Create CWS Folder in Local App Data Folder.
	localappdatapath$ = ENVIRON$("LOCALAPPDATA")
	cwsdatapath$ = localappdatapath$ + "\cws"
	IF NOT _DIREXISTS(cwsdatapath$) THEN
		MKDIR cwsdatapath$
	END IF

	' Copy files from current application directory to CWS in Local App Data.
	CALL CopyFile("ALTLEAD.DAT", cwsdatapath$ + "\ALTLEAD.DAT")
	CALL CopyFile("ALTMAP.BAT", cwsdatapath$ + "\ALTMAP.BAT")
	CALL CopyFile("ALTMAP.INI", cwsdatapath$ + "\ALTMAP.INI")
	CALL CopyFile("CITIES.GRD", cwsdatapath$ + "\CITIES.GRD")
	CALL CopyFile("CWS.CFG", cwsdatapath$ + "\CWS.CFG")
	CALL CopyFile("CWS.INI", cwsdatapath$ + "\CWS.INI")
	CALL CopyFile("CWSLEAD.DAT", cwsdatapath$ + "\CWSLEAD.DAT")
	CALL CopyFile("HISCORE.CWS", cwsdatapath$ + "\HISCORE.CWS")

replay = 0
newgame:
pcode = 0: rflag = 0
FOR k = 1 TO 40: armysize(k) = 0: armyloc(k) = 0: armymove(k) = 0: armylead(k) = 0: armyname$(k) = "": NEXT k
usadv = 0: emancipate = 0
FOR k = 1 TO 2
navysize(k) = 0: navyloc(k) = 0: navymove(k) = 0
rr(k) = 0: victory(k) = 0: tracks(k) = 0
NEXT k

filel = 1: vicflag(1) = 1
CALL filer(1)
IF _FILEEXISTS("mtn.vga") THEN
	DEF SEG = VARSEG(mtn(1))
	BLOAD "mtn.vga", VARPTR(mtn(1))
	DEF SEG
ELSE
	COLOR 15: BEEP: PRINT "ERROR: Missing File  'MTN.VGA'": TICK 9
END IF

RESTORE
FOR k = 1 TO 26: READ font$(k): NEXT k

IF realism > 0 AND year < 1862 THEN
		FOR i = 1 TO 2
			a$ = STRING$(LEN(fleet$(i)), "W")
			fleet$(i) = a$
		NEXT i
END IF

IF player < 1 OR player > 2 THEN player = 1
IF player = 2 OR side = 0 THEN side = 1
IF side = 1 THEN randbal = 7
IF side = 2 THEN randbal = 3
	IF turbo! < 1 THEN turbo! = 2
	IF side = 1 AND difficult < 3 THEN cash(2) = cash(2) + 600 - 100 * difficult
	IF side = 2 AND difficult > 3 THEN cash(1) = cash(1) + 100 * difficult


FOR i = 1 TO 2: income(i) = cash(i): cash(i) = cash(i) + 50 * RND: NEXT i
choose = 0

_FULLSCREEN _SQUAREPIXELS, _SMOOTH
SCREEN 12
	DEF SEG = VARSEG(graphic(1))
	BLOAD "cwsicon.vga", VARPTR(graphic(1))
	DEF SEG
	PUT (100, 100), graphic(), PSET
	GET (101, 101)-(113, 113), Ncap
CLS
COLOR 11: LOCATE 14, 27: PRINT "VGA CIVIL WAR STRATEGY GAME"
COLOR 4: LOCATE 15, 32: PRINT "Registered Edition"
COLOR 14: LOCATE 28, 1: PRINT TAB(8); "(c) 1998, 2017, 2018 by W. R. Hutsell and Dave Mackey"
LOCATE 28, 60: PRINT "v2.10"
LINE (190, 170)-(440, 260), 1, B
LINE (180, 180)-(450, 250), 7, B
CALL flags(1, -440, 0): CALL flags(2, -100, 0)
IF replay = 0 AND noise = 2 AND choose = 0 THEN
IF side = 1 THEN
	IF INKEY$ <> "" GOTO notitle
	PLAY "MST170o1e8o0b8o1e8"
	IF INKEY$ <> "" GOTO notitle
	PLAY "e8e4f#8g4f#8"
	IF INKEY$ <> "" GOTO notitle
	PLAY "g4e8d2o0b8o1d2 "
	IF INKEY$ <> "" GOTO notitle
	PLAY "o1e8o0b8o1e8e8e4f#8g4f#8g4a8b2g8b2MLg16a16"
	IF INKEY$ <> "" GOTO notitle
	PLAY "MSb4b8b8a8g8a4a8a4f#8g4g8MLg8f#8"
	IF INKEY$ <> "" GOTO notitle
	PLAY "MSe8f#4f#8f#8g8a8b4.a4.g4.f#4.o0b8o1e8e8e4d8e2."
    ELSE
	CALL shen
    END IF
END IF
notitle:
GOSUB unionplus

city$(0) = "NONE"
OPEN "I", 1, cwsdatapath$ + "\cities.grd"
vptotal = usadv + 200
FOR i = 1 TO 40: INPUT #1, a, cityx(i), cityy(i), city$(i), cityp(i), cityv(i)
cityo(i) = cityp(i)
CALL occupy(i)
FOR j = 1 TO 7: INPUT #1, matrix(i, j): NEXT j: INPUT #1, fort(i)
IF cityp(i) > 0 THEN x = cityp(i): control(x) = control(x) + 1: victory(x) = victory(x) + cityv(i)
IF cityp(i) > 0 THEN cash(cityp(i)) = cash(cityp(i)) + cityv(i)
vptotal = vptotal + cityv(i)
NEXT i
CLOSE #1: CALL clrbot

RANDOMIZE TIMER
TICK .3
wtype = 2
hilite = 15
replay = 1
IF player = 2 THEN GOSUB blanken
mtx$(0) = "VGA CIVIL WAR STRATEGY"
mtx$(1) = "Resume Saved Game"
mtx$(2) = "Start NEW Game"
mtx$(3) = "Quit"
tlx = 33: tly = 20: colour = 5: size = 3
choose = 23
CALL menu(0)
IF choose = 1 THEN
	CLS
	GOTO loader
	GOTO menu0
END IF
IF choose = 3 THEN CLS : END
IF history = 1 THEN
	CLS
	makeoldhistory$ = "copy " + cwsdatapath$ + "\cws.his " + cwsdatapath$ + "\oldhist.ory"
	IF _FILEEXISTS(cwsdatapath$ + "\cws.his") THEN SHELL makeoldhistory$ ' "copy cws.his oldhist.ory"
	OPEN "O", 2, cwsdatapath$ + "\cws.his"
	PRINT #2, TAB(20); "[ HISTORY OF GAME BEGUN "; DATE$; " ]"
	CLOSE #2
ELSE
	SCREEN 12: CLS
END IF
CALL usa
GOTO menu0
'                              New Month
newmonth:
IF side > 2 THEN side = 1
a$ = "--------> EVENTS FOR " + month$(month) + " " + STR$(year) + " --------"
CALL scribe(a$, 0)
CALL tupdate
control(1) = 0: control(2) = 0

FOR i = 1 TO 2
income(i) = 0
IF cash(i) > 19999 THEN cash(i) = 19999
IF cash(i) < 0 THEN cash(i) = 0
NEXT i
IF player = 1 AND side = 2 THEN income(1) = income(1) + usadv

FOR i = 1 TO 40
IF cityp(i) > 0 THEN x = cityp(i): control(x) = control(x) + 1: income(x) = income(x) + cityv(i)
armymove(i) = 0
NEXT i

FOR i = 1 TO 2: navymove(i) = 0: IF capcity(i) > 0 THEN income(i) = income(i) + 100
cash(i) = cash(i) + income(i)
IF commerce > 0 AND i <> commerce THEN cash(i) = cash(i) - raider
NEXT i
vptotal = income(1) + income(2)

chosit = 22
IF player = 2 THEN GOSUB blanken: CALL usa
CALL victor
ON ERROR GOTO 0
IF pcode > 0 THEN
	FOR k = 1 TO 40: armyloc(k) = 0: NEXT k
	GOTO newgame
END IF

'                              Main Menu
menu0:
CALL topbar
IF player = 2 AND side = 0 THEN side = 1
IF cash(side) < 100 AND navyloc(side) = 0 THEN nflag = 1

hilite = 11
colour = 4
tlx = 67: tly = 13
mtx$(0) = "Main"
mtx$(1) = "Troops": IF rflag < 0 OR cash(side) < 100 THEN mtx$(1) = "-": chosit = 23
mtx$(2) = "Moves": IF mflag > 0 THEN mtx$(2) = "-": IF chosit = 23 THEN chosit = 24
mtx$(3) = "Ships": IF nflag > 0 THEN mtx$(3) = "-": IF chosit = 24 THEN chosit = 25
mtx$(4) = "Railroad": IF rr(side) > 0 THEN mtx$(4) = "-": IF chosit = 25 THEN chosit = 26
mtx$(5) = "END TURN"
mtx$(6) = "Inform"
mtx$(7) = "COMMANDS"
mtx$(8) = "UTILITY"
mtx$(9) = "Files"

size = 9
choose = chosit
CALL menu(0): CALL clrrite
'==========================================================================
'                            Main Menu
'==========================================================================
SELECT CASE choose
	CASE 1 ' Recruit
		IF cash(side) < 100 OR rflag < 0 THEN rflag = -1: GOTO menu0
		CALL recruit((side))
		chosit = 23
		GOTO menu0
	CASE 2 ' Armies
		CALL armies
		chosit = 23
		GOTO menu0
	CASE 3 ' Navies
		IF nflag = 0 THEN CALL navy((side), 0)
		chosit = 25
	CASE 4 ' Railroad
		IF rr(side) = 0 THEN
			COLOR 15: LOCATE 4, 68: PRINT "RAILROAD MOVE"
			PSET (550, 20), 0
			DRAW "C15S6R9D4R6U3R3D3R7U5H3U2R9D3G2D6F1D3F5L10D1G1L4H2L7G2L3H2L3U9L2U5R1BF4"
			z = 9
			IF side = 2 THEN z = 7
			x = POINT(0): y = POINT(1)
			PAINT (x, y), z, 15
			COLOR 15
			IF side = 1 THEN COLOR 11
			CALL traincapacity(side, limit)
			CALL clrbot: PRINT "Railroad capacity ="; RTRIM$(STR$(limit)); "00";
			CALL railroad(side)
		ELSE
			CALL clrbot: COLOR 11: PRINT "Railroad is already carrying "; armyname$(rr(side)); " to "; city$(armymove(rr(side))); : GOTO menu0
		END IF
	CASE 5 ' End Turn
		tlx = 67: tly = 15
		hilite = 15: colour = 3: choose = 23
		mtx$(0) = "End Turn"
		mtx$(1) = "Yes"
		mtx$(2) = "NOT YET"
		size = 2
		CALL menu(0)
		CALL clrrite
		IF choose <> 1 THEN chosit = 24: GOTO menu0
	endrnd:
		rflag = 0: mflag = 0: nflag = 0
		IF player = 2 THEN side = side + 1: IF side = 2 THEN GOSUB blanken: CALL usa: GOTO menu0
		GOTO newmonth
	CASE 6
		CALL report((side)): chosit = 27
		CALL starfin(star, fin, side)
		FOR i = star TO fin
			IF armymove(i) > 0 THEN CALL icon(armyloc(i), armymove(i), 1)
		NEXT i
	CASE 7 ' Commands
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
		CASE 2 ' Fortify
			IF cash(side) < 200 THEN COLOR 11: CALL clrbot: PRINT "Not enough money for fort"; : GOTO menu0
			CALL fortify(target)
			IF cash(side) < 200 GOTO menu0
			choose = 23
			GOTO optmen
		CASE 3 ' Combine
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
		CASE 5' Move Capital
			IF capcity(side) = 0 OR cash(side) < 500 THEN CALL clrbot: COLOR 11: PRINT "Cannot move capital"; : GOTO menu0
			cash(side) = cash(side) - 500
			victory(3 - side) = victory(3 - side) + 50
			CALL clrrite
			mtx$(0) = "Capital"
			a$ = city$(capcity(side))
			index = capcity(side)
			CALL newcity(index)
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
	CASE 8 ' Utility Menu
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
			a$ = ""
			IF randbal = 0 THEN a$ = "OFF"
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
			FOR k = 1 TO 40
				CALL occupy(k)
			NEXT k
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
			a$ = "PROHIBITED"
			IF jancam = 1 THEN a$ = "ALLOWED"
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
			a$ = "OFF"
			IF history = 1 THEN a$ = "ON"
			CALL clrbot: PRINT "History is now "; a$;
			choose = 34: GOTO utile
	   CASE 14 ' Aggression
			bold = bold + 1
			IF bold > 5 THEN bold = 0
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
	CASE 9 ' Files
	IF _FILEEXISTS(cwsdatapath$ + "\*.sav") THEN filel = 0
	filex:
	choose = 23: chosit = 30: IF year = 1861 THEN choose = 22
	mtx$(0) = "Options"
	mtx$(1) = "Load": IF filel = 0 THEN mtx$(1) = "-": choose = 23
	mtx$(2) = "Save"
	mtx$(3) = "New Game"
	mtx$(4) = "Quit"
	size = 4: tlx = 67: tly = 15
	CALL menu(0): CALL clrrite
	SELECT CASE choose
		CASE IS < 1: GOTO menu0
		CASE 1, 2
			loader:
			IF choose = 1 AND filel = 0 GOTO filex
			CALL filer(choose + 1)
			IF choose = 1 THEN rflag = 0: mflag = 0: nflag = 0
			GOTO menu0
		CASE 3
			OPEN "O", 1, cwsdatapath$ + "\cws.cfg"
			WRITE #1, side, graf, noise, difficult, player, turbo!, randbal, train(1), train(2), jancam, realism, batwon(1), batwon(2), casualty&(1), casualty&(2), history, bold
			CLOSE #1
			CLS
			GOTO newgame
		CASE 4
			choose = 23
			mtx$(0) = "Quit"
			mtx$(1) = "Yes"
			mtx$(2) = "No"
			size = 2: colour = 5
			tlx = 67: tly = 15
			CALL menu(0): CALL clrrite: IF choose = 1 THEN END ELSE GOTO menu0
	END SELECT
	CASE 99
		GOTO endrnd
	CASE ELSE
		chosit = 22
		GOTO menu0
END SELECT
GOTO menu0
'............................................................................
'                               Subs
'............................................................................
'............................................................................
unionplus:
	usadv = 120 * difficult: IF player = 2 THEN usadv = 50 * difficult
	IF realism > 0 THEN usadv = usadv * .7
	RETURN
'............................................................................
blanken:
	c = 1: IF side = 2 THEN c = 7
	CLS : LINE (100, 200)-(500, 300), c, BF
	LINE (100, 200)-(500, 300), 8 - c, B
	COLOR 7: LOCATE 14, 31: PRINT " "; month$(month); year
	COLOR 11: LOCATE 17, 30: PRINT force$(side); " PLAYER TURN"
	DO WHILE INKEY$ = "": LOOP
	RETURN
'............................................................................
DATA "U2E2F2D2BU1L3","U4R3F1G1L2BR2BF1G1L2","H1U2E1R2F1BD2G1L1"
DATA "U4R3F1D1D1G1L2","U4R3BD2BL1L2D2R3","U4R3BD2BL1L2","H1U2E1R3BD2L2BD2R2U1"
DATA "U4BD2BR1R3U2BD3D1","R1U4L1R2BL1BD4R1","R1E1U3BG3F1","U4BR3G2F2"
DATA "U4BD4BR1R1","U4F2E2D4","U4F4U4","H1U2E1R2F1D2G1L1","U4R3F1G1L2"
DATA "H1U2E1R2F1D2G1L1BE1F1R1","U4R3F1G1L2BR1F2","R3E1H1L2H1E1R3"
DATA "U4L2BR3R1","H1U3BR4D3G1L1","H2U2BR4D2G2","H2U2BF3BU1D1F1E2U2"
DATA "E4BD4H4","U2H2BR4G2","E4L4BD4R4"

SUB animate (index, flag)
	from = armyloc(index): to2 = armymove(index): armyloc(index) = 0
	x = cityx(from) - 12
	y = cityy(from) - 11
	x1 = .5 * (cityx(to2) + cityx(from))
	y1 = .5 * (cityy(to2) + cityy(from))

	CALL occupy(from): IF occupied(from) > 0 THEN CALL placearmy(occupied(from))
		
	IF flag > 0 GOTO already
		GET (x - 9, y - 7)-(x + 9, y + 6), anima
		IF occupied(from) = 0 THEN LINE (x - 9, y - 8)-(x + 10, y + 8), 2, BF
	already:

		FOR i = 2 TO 8
		x1 = .1 * (i * cityx(to2) + (10 - i) * cityx(from))
		y1 = .1 * (i * cityy(to2) + (10 - i) * cityy(from))
		GET (x1 - 10, y1 - 10)-(x1 + 9, y1 + 9), image
		PUT (x1 - 10, y1 - 10), anima, PSET
		IF turbo! > 1 THEN CALL TICK(.1) ELSE CALL TICK(.02)
		IF noise > 0 THEN SOUND 200, .1: SOUND 50, .1
		PUT (x1 - 10, y1 - 10), image, PSET
		NEXT i
		armyloc(index) = from
END SUB

SUB armies
	CALL movefrom(index, target): IF target > 0 AND index > 0 GOTO tent
		IF index = -1 THEN mflag = 1
		GOTO dudd
	tent:
	tlx = 67: tly = 12

	CALL armystat(index)
	COLOR 11: LOCATE 11, 68: PRINT city$(target)
	size = 0
	mtx$(0) = "To"
	FOR i = 1 TO 6: IF matrix(target, i) > 0 THEN size = size + 1: mtx$(size) = city$(matrix(target, i)): array(size) = matrix(target, i)
	NEXT i
	CALL bubble(size)

	hilite = 10: colour = 3: CALL menu(2): CALL clrrite
	IF choose < 0 GOTO dudd
	IF month < 3 AND jancam = 0 AND cityp(array(choose)) <> side THEN COLOR 11: CALL clrbot: PRINT "No campaigns in January"; : CALL TICK(9): CALL clrbot: GOTO dudd

	CALL clrbot: PRINT "Army "; index; " "; armyname$(index); " is moving from "; city$(target); " to "; city$(array(choose));
	IF noise > 0 THEN SOUND 2200, .5: SOUND 2900, .7
	CALL icon(target, array(choose), 1)
	armymove(index) = array(choose): CALL TICK(turbo!): CALL clrbot
	CALL clrrite
	dudd:
END SUB

SUB armystat (index)
	LINE (530, 60)-(639, 150), 0, BF
	COLOR 15
	LOCATE 5, 68: PRINT armyname$(index)
	COLOR 9: IF index > 20 THEN COLOR 7
	LOCATE 6, 68: PRINT "Size:"; : CALL strong(index)
	LOCATE 7, 68: PRINT "Leader:"; TAB(75); armylead(index)
	LOCATE 8, 68: PRINT "Exper:"; TAB(75); armyexper(index)
	IF supply(index) < 2 THEN COLOR 12
	LOCATE 9, 68: PRINT "Supply:"; TAB(75); supply(index)
END SUB

SUB barnacle (who)
	navysize(who) = navysize(who) - 1
	IF navysize(who) > 0 THEN
		fleet$(who) = LEFT$(fleet$(who), navysize(who))
	ELSE
		fleet$(who) = "": navyloc(who) = 0: navysize(who) = 0
	END IF
END SUB

SUB battle (attack, defend, win, lose)
	IF armysize(defend) < 1 THEN armysize(defend) = 1
	IF armysize(attack) < 1 THEN armysize(attack) = 1

	CALL icon(armyloc(defend), 0, 9)
	LOCATE 1, 1: PRINT SPACE$(80)
	CALL clrrite: y = 68: COLOR 11: LOCATE 1, y: PRINT "Attacker"
	c = 9: IF attack > 20 THEN c = 7
	COLOR c: LOCATE 2, y: PRINT armyname$(attack)
	LOCATE 3, y: CALL strong(attack)
	x = .01 * armysize(attack): IF x > TCR THEN x = TCR
	LOCATE 4, y: PRINT "Base    "; x
	IF armysize(attack) / armysize(defend) > .2 THEN x = x + .3 * armylead(attack) + .3 * armyexper(attack): IF x > TCR THEN x = TCR
	IF armyexper(attack) > 8 THEN x = x + 1: IF x > TCR THEN x = TCR
	LOCATE 5, y: PRINT "Ldr/Exp "; x
	IF armysize(attack) < 15 THEN x = .5 * x: IF x > TCR THEN x = TCR
	LOCATE 6, y: PRINT "Small   "; x
	IF armysize(attack) / armysize(defend) <= .5 THEN x = x - 2: IF x < 1 THEN x = 1
	IF armysize(attack) / armysize(defend) > 3 THEN x = x + 2: IF x > TCR THEN x = TCR
	IF armysize(attack) / armysize(defend) > 10 THEN x = TCR
	IF armysize(attack) / armysize(defend) <= .2 THEN x = 1
	LOCATE 7, y: PRINT "Outman  "; x
	IF supply(attack) < 1 THEN x = .5 * x: COLOR 13
	LOCATE 8, y: PRINT "Supply  "; x: COLOR c
	IF x < 1 THEN x = 1
	'                       Adjust attack advantage
	IF attack < 21 AND side = 2 AND difficult > 3 THEN x = x + 2 * difficult - 6
	IF attack > 20 AND side = 1 AND difficult < 3 THEN x = x + 6 - 2 * difficult
	LOCATE 9, y: PRINT "Difclt  "; x
	IF x > TCR THEN x = TCR
	COLOR 11: LOCATE 11, y: PRINT "Attack  "; x
	LINE (530, 155)-(635, 175), 11, B

	x1 = .013 * armysize(defend) + 1: IF realism = 1 THEN x1 = .02 * armysize(defend) + 2: IF x1 > 20 THEN x1 = 20
	LOCATE 13, y: PRINT "Defender"
	COLOR 16 - c: LOCATE 14, y: PRINT armyname$(defend)
	LOCATE 15, y: CALL strong(defend)
	LOCATE 16, y: PRINT "Base    "; INT(.01 * armysize(defend))
	LOCATE 17, y: PRINT "Defense "; x1
	IF armysize(defend) / armysize(attack) > .2 THEN x1 = x1 + .3 * armylead(defend) + .3 * armyexper(defend): IF x1 > TCR THEN x1 = TCR
	IF armyexper(defend) > 8 THEN x1 = x1 + 1: IF x1 > TCR THEN x1 = TCR
	LOCATE 18, y: PRINT "Ldr/Exp "; x1
	IF armysize(defend) < 15 THEN x1 = .5 * x1
	LOCATE 19, y: PRINT "Small   "; x1

	R! = armysize(defend) / armysize(attack)
	SELECT CASE R!
		CASE IS > 10
			x1 = TCR
		CASE IS > 1.5
			x1 = x1 + 2
		CASE IS < .5
			x1 = .8 * x1
		CASE IS < .2
			x1 = .5 * x1
	END SELECT
		IF x1 < 1 THEN x1 = 1
		IF x1 > TCR THEN x1 = TCR

	LOCATE 20, y: PRINT "Outman  "; x1
	IF supply(defend) < 1 THEN x1 = .5 * x1: COLOR 13
	LOCATE 21, y: PRINT "Supply  "; x1: COLOR 16 - c
	IF x1 < 1 THEN x1 = 1
	'                       Adjust defend advantage
	IF defend < 21 AND side = 2 AND difficult > 3 THEN x1 = x1 + 2 * difficult - 6
	IF defend > 20 AND side = 1 AND difficult < 3 THEN x1 = x1 + 6 - 2 * difficult
	LOCATE 22, y: PRINT "Difclt  "; x1

	a$ = "Fort": IF armymove(defend) = 0 THEN x1 = x1 * (1 + fort(armyloc(defend)))
	IF x1 > TCR THEN x1 = TCR
	IF fort(armyloc(defend)) > 0 AND armymove(defend) = 0 THEN
		COLOR 13: a$ = "Fort+"
		IF fort(armyloc(defend)) = 2 THEN a$ = "Fort++"
	END IF
	LOCATE 23, y: PRINT a$; TAB(76); x1
	IF x1 > TCR THEN x1 = TCR
	COLOR 11: LOCATE 25, y: PRINT "Defend  "; x1
	LINE (530, 380)-(635, 400), 11, B

	spin = 0
	scale = x: IF x1 > scale THEN scale = x1
	scale = scale + 1

	odds! = x / (x + x1): a = INT(100 * odds!): IF a < 1 THEN a = 1
	a$ = LTRIM$(RTRIM$(STR$(a))) + "%"
	COLOR 14: LOCATE 27, y: PRINT "Odds:  "; a$;
	LINE (530, 412)-(635, 435), 14, B
	LINE (528, 410)-(637, 437), 14, B
	DO WHILE INKEY$ = "": LOOP
	IF graf > 2 THEN
		CALL cannon
		k = fort(armyloc(defend))
		t$ = "fort" + LTRIM$(STR$(k)) + ".vga"
		IF _FILEEXISTS(t$) THEN
			DEF SEG = VARSEG(graphic(1))
			BLOAD t$, VARPTR(graphic(1))
			DEF SEG
			PUT (550, 270), graphic, PSET
		END IF
	ELSE
		CALL clrrite
	END IF
	FOR i = 1 TO 2: IF supply(i) > 0 THEN supply(i) = supply(i) - 1
	NEXT i

	grapple:
	hit = 0: hit1 = 0
	star = scale * RND: fin = scale * RND
	IF noise > 0 THEN SOUND 77, .5: SOUND 59, .5: CALL TICK(.1)
	IF star <= x THEN hit = 1
	IF fin <= x1 THEN hit1 = 1

	IF hit = 0 AND hit1 = 0 GOTO grapple
	IF hit = 1 AND hit1 = 1 GOTO grapple
	win = defend: lose = attack: IF hit = 1 THEN win = attack: lose = defend

	a$ = "UNION": IF win > 20 THEN a$ = "REBEL"
	COLOR 14: LOCATE 3, 68: PRINT a$; " VICTORY"
	LOCATE 4, 71: PRINT "in"
	LOCATE 5, 69: PRINT city$(armyloc(defend))
	a = 1: IF win > 20 THEN a = 2
	CALL flags(a, 0, 0)
	CALL clrbot: COLOR 11: PRINT armyname$(win); " defeats "; armyname$(lose); " in "; city$(armyloc(defend)); : CALL TICK(9)

	pct! = .01 * DEFAC - .03 * fort(armyloc(defend)): IF win = attack THEN pct! = 1.3 * pct!
	SELECT CASE armysize(defend)
		CASE IS > 300
			pct! = .9 * pct!
		CASE IS > 800
			pct! = .8 * pct!
	END SELECT
	xbar = armysize(attack) * pct!
	vary = xbar * (1 - pct!)
	CALL normal(xbar, vary, killd)

	pct! = .01 * ATKFAC + .02 * fort(armyloc(defend)): IF win = defend THEN pct! = 1.5 * pct!
	SELECT CASE armysize(attack)
		CASE IS > 300
			pct! = .9 * pct!
		CASE IS > 800
			pct! = .8 * pct!
	END SELECT
	xbar = armysize(defend) * pct!
	vary = xbar * (1 - pct!)
	CALL normal(xbar, vary, killa)

	killa = .8 * killa + .2 * killd: IF killa < 1 THEN killa = 1
	killd = .8 * killd + .2 * killa: IF killd < 1 THEN killd = 1
	IF killa > 9 * killd THEN killa = 9 * killd
	IF killd > 5 * killa THEN killd = 5 * killa

	IF killa >= armysize(attack) THEN killa = armysize(attack) - 1
	IF killd >= armysize(defend) THEN killd = armysize(defend) - 1

	x = INT(100 * odds!): IF x < 1 THEN x = 1
	a$ = LTRIM$(RTRIM$(STR$(x))) + "%"

	COLOR c
	LOCATE 1, 1: PRINT "Attack Loss: ";
	PRINT LTRIM$(RTRIM$(STR$(killa)) + "00"); "/";
	CALL strong(attack)
	PRINT " ("; LTRIM$(RTRIM$(STR$(INT(100 * (killa / armysize(attack)))))); "%) |";
	COLOR 16 - c: PRINT "| Defend Loss: "; : PRINT LTRIM$(RTRIM$(STR$(killd)) + "00"); "/";
	CALL strong(defend)
	PRINT " ("; LTRIM$(RTRIM$(STR$(INT(100 * (killd / armysize(defend)))))); "%)"

	mtx$(1) = " (" + LTRIM$(RTRIM$(STR$(killa) + "00")) + "/" + LTRIM$(STR$(armysize(attack)) + "00") + ") "
	t$ = " (" + LTRIM$(RTRIM$(STR$(killd) + "00")) + "/" + LTRIM$(STR$(armysize(defend)) + "00") + ")"
	mtx$(2) = t$
	IF win = defend THEN mtx$(2) = mtx$(1): mtx$(1) = t$
	mtx$(3) = "*" + armyname$(win): mtx$(4) = armyname$(lose)
	IF win = defend THEN mtx$(3) = armyname$(win): mtx$(4) = "*" + armyname$(lose)
	a$ = city$(armyloc(defend)) + ": " + mtx$(3) + mtx$(1) + " defeats " + mtx$(4) + mtx$(2)
	CALL scribe(a$, 0)

	IF player = 1 AND (side = 1 AND attack > 20) OR (side = 2 AND attack < 21) THEN
	COLOR 14: CALL clrbot: PRINT "hit any key to continue"; : DO WHILE INKEY$ = "": LOOP
	END IF

	armysize(attack) = armysize(attack) - killa
	armysize(defend) = armysize(defend) - killd
	IF armysize(defend) < 1 THEN armysize(defend) = 1

	s = 1: IF attack > 2 THEN s = 2
	casualty&(s) = casualty&(s) + killa
	casualty&(3 - s) = casualty&(3 - s) + killd

	s = 1: IF win > 20 THEN s = 2
	batwon(s) = batwon(s) + 1
	victory(s) = victory(s) + 1
	CALL icon(armyloc(defend), 0, 8)
END SUB

SUB combine (who)
		colour = 3: target = 0: hilite = 3
		tlx = 67: tly = 2
		CALL starfin(star, fin, who)
		size = 0
		FOR i = 1 TO 40
			IF cityp(i) = who AND occupied(i) > 0 THEN
				FOR j = star TO fin
				IF armyloc(j) = i AND occupied(i) <> j AND armymove(j) = 0 THEN size = size + 1: mtx$(size) = city$(i): array(size) = i: EXIT FOR
				NEXT j
			END IF
		NEXT i
		
		IF size = 0 THEN who = -1: EXIT SUB
		CALL bubble(size)

		IF who <> side THEN choose = 1 + INT(size * RND): GOTO join
		mtx$(0) = "Join"
			choose = 31: hilite = 11
			CALL menu(9): CALL clrrite
	join:
			IF choose < 1 GOTO nocity2
			target = array(choose)
			CALL clrbot: PRINT "Combining "; force$(who); " armies in "; city$(target); :  CALL TICK(turbo!)

			armysize(0) = 0: armylead(0) = 0: armyexper(0) = 0: armyloc(0) = target
			armyname$(0) = "": supply(0) = 0: armymove(0) = 0

			best = 0: x = 0: spin = 0
			FOR j = star TO fin
			IF armymove(j) <> 0 OR armyloc(j) <> target OR armysize(j) = 0 GOTO dork1
			IF armysize(0) + armysize(j) > 1250 THEN CALL clrbot: PRINT "Cannot combine "; armyname$(j); "... TOO LARGE"; : CALL TICK(turbo!): GOTO dork1

			IF armylead(j) > x THEN
				x = armylead(j)
				armyname$(0) = armyname$(j)
				armylead(0) = armylead(j)
				best = j
			END IF

			armysize(0) = armysize(0) + armysize(j)
			IF armysize(0) < 1 GOTO dork1
			pct! = (armysize(j) / armysize(0))
			spin = spin + 1
			armyexper(0) = (1 - pct!) * armyexper(0) + pct! * armyexper(j)
			CALL clrbot: PRINT armyname$(j); " is combining his "; : CALL strong(j): PRINT " forces"; : CALL TICK(turbo!)
			supply(0) = supply(0) + supply(j)
			IF supply(0) > 10 THEN supply(0) = 10
			armysize(j) = 0: armyloc(j) = 0: armyexper(j) = 0: armymove(j) = 0
			lname$(j) = armyname$(j)
			armylead(j) = 0: supply(j) = 0: armyname$(j) = ""
	dork1:
			NEXT j

			CALL clrbot
			IF who <> side AND spin = 0 THEN EXIT SUB
			IF spin = 0 THEN
					PRINT "No valid armies to combine at this time in "; city$(target);
					TICK turbo!
					EXIT SUB
			END IF
			armysize(best) = armysize(0): armylead(best) = armylead(0)
			armyexper(best) = armyexper(0): supply(best) = supply(0)
			armyloc(best) = target
			armyname$(best) = armyname$(0)
			lname$(best) = ""
			IF spin > 1 THEN
			PRINT "New army "; best; " of "; : CALL strong(best): PRINT " is commanded by "; armyname$(best);
			armymove(best) = -1
			ELSE
			PRINT "Only 1 eligible army -- cannot combine at this time";
			END IF
			IF who = side THEN CALL TICK(turbo!)
			IF noise > 0 THEN SOUND 4000, .7
			
			CALL showcity
			CALL placearmy(best)
			CALL icon(target, 0, 6)
			occupied(target) = best
			CALL stax(who)
	nocity2:
END SUB

SUB cutoff (who, target, a)
	a = 0
	FOR j = 1 TO 6
	y = matrix(target, j)
	IF y > 0 AND cityp(y) = who THEN a = a + 1
	NEXT j
END SUB

SUB filer (switch)
	SELECT CASE switch
		CASE 1 ' Load General Game Data
			' Load Commanders Data.
			OPEN "I", 1, cwsdatapath$ + "\cwslead.dat"
				FOR i = 1 TO 40
					INPUT #1, lname$(i), rating(i)
				NEXT i
			CLOSE #1

			' Load Settings Data.
			OPEN "I", 1, cwsdatapath$ + "\cws.ini"
				FOR i = 0 TO 2
					INPUT #1, force$(i)
				NEXT i
				FOR i = 1 TO 12
					INPUT #1, month$(i)
				NEXT i
				INPUT #1, month, year

				' Set the End Game Conditions.
				FOR i = 1 TO 6
					INPUT #1, vicflag(i)
				NEXT i
				vicflag(3) = .4 * vicflag(3)

				' Load Union Armies.
				INPUT #1, a
				FOR i = 1 TO a
					INPUT #1, armyloc(i), armysize(i), armyexper(i), supply(i): occupied(armyloc(i)) = i: armyname$(i) = lname$(i): armylead(i) = rating(i): lname$(i) = ""
				NEXT i

				' Load Rebel Armies.
				INPUT #1, a
				FOR i = 21 TO 20 + a
					INPUT #1, armyloc(i), armysize(i), armyexper(i), supply(i)
					occupied(armyloc(i)) = i: armyname$(i) = lname$(i): armylead(i) = rating(i): lname$(i) = ""
				NEXT i
				FOR i = 1 TO 2
					INPUT #1, cash(i)
				NEXT i
				INPUT #1, ATKFAC, DEFAC, TCR

				' Load Navies
				INPUT #1, fleet$(1), navyloc(1), fleet$(2), navyloc(2)
				FOR k = 1 TO 2
					navysize(k) = LEN(fleet$(k))
				NEXT k
				INPUT #1, capcity(1), capcity(2)
				
				' Set Star Locations on Flag
				FOR i = 1 TO 8
					INPUT #1, starx(i), stary(i)
				NEXT i
			CLOSE #1

			' Load Config Data.
			OPEN "I", 1, cwsdatapath$ + "\cws.cfg"
				INPUT #1, side, graf, noise, difficult, player, turbo!, randbal, train(1), train(2), jancam, realism, batwon(1), batwon(2), casualty&(1), casualty&(2), history, bold
			CLOSE #1

		CASE 2 ' Load Specific Game File
			' We check in the cwsdatapath for the file.
			IF _FILEEXISTS(cwsdatapath$ + "\*.sav") THEN choose = -1: EXIT SUB
			mtx$(0) = "Load"
			size = 0
			FOR k = 1 TO 9
				t$ = cwsdatapath$ + "\cws" + LTRIM$(STR$(k)) + ".sav"
				IF _FILEEXISTS(t$) THEN
					' But if the file exists, we don't want to show the full path, just the file name.
					t$ = "cws" + LTRIM$(STR$(k)) + ".sav"
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
			OPEN "I", 1, cwsdatapath$ + "\cws" + LTRIM$(STR$(array(choose))) + ".sav"
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
			FOR i = 1 TO 40
				INPUT #1, occupied(i), cityp(i), fort(i): PRINT ".";
			NEXT i
			FOR i = 1 TO 2
				INPUT #1, cash(i), control(i), income(i), victory(i), capcity(i)
				INPUT #1, fleet$(i), navyloc(i), navymove(i), rr(i), tracks(i)
				navysize(i) = LEN(fleet$(i))
			NEXT i
		
			CLOSE #1
			OPEN "I", 1, cwsdatapath$ + "\cws.cfg"
			INPUT #1, myside, graf, noise, difficult, player, turbo!, randbal, train(1), train(2), jancam, realism, batwon(1), batwon(2), casualty&(1), casualty&(2), history, bold
			CLOSE #1
			SCREEN 12: CLS
			CLOSE #1: CALL usa: CALL clrbot
			FOR k = 1 TO 2
			IF rr(k) > 0 THEN CALL tinytrain(k, 1)
			NEXT k
			side = a

		CASE 3 ' Save Game
			mtx$(0) = "Save Game"
			FOR k = 1 TO 9
				mtx$(k) = "cws" + LTRIM$(STR$(k)) + ".sav"
				mtz$(k) = cwsdatapath$ + "\cws" + LTRIM$(STR$(k)) + ".sav"
				IF _FILEEXISTS(mtz$(k)) THEN mtx$(k) = mtx$(k) + " +"
			NEXT k
			tlx = 67: size = 9
			CALL menu(0)
			IF choose < 1 THEN clrrite: EXIT SUB
			COLOR 11: CALL clrbot: PRINT "Saving";

			OPEN "O", 1, cwsdatapath$ + "\cws" + LTRIM$(STR$(choose)) + ".sav"
			WRITE #1, month, year, usadv, side
			FOR i = 1 TO 40
				WRITE #1, armyname$(i), armysize(i), armylead(i), armyloc(i), armyexper(i), supply(i), armymove(i)
			NEXT i
			FOR i = 1 TO 40
				WRITE #1, occupied(i), cityp(i), fort(i): PRINT ".";
			NEXT i
			FOR i = 1 TO 2
				WRITE #1, cash(i), control(i), income(i), victory(i), capcity(i)
				WRITE #1, fleet$(i), navyloc(i), navymove(i), rr(i), tracks(i)
			NEXT i
			CLOSE #1
		
			myside = side
			IF myside < 1 OR myside > 2 THEN myside = 1
			OPEN "O", 1, cwsdatapath$ + "\cws.cfg"
			WRITE #1, myside, graf, noise, difficult, player, turbo!, randbal, train(1), train(2), jancam, realism, batwon(1), batwon(2), casualty&(1), casualty&(2), history, bold
			CLOSE #1
			CLS : CALL usa
	END SELECT
END SUB

SUB flashcity (which)
	FOR c = 1 TO 15 STEP 2
	CIRCLE (cityx(which), cityy(which)), 4, 0
	CIRCLE (cityx(which), cityy(which)), 3, c
	PAINT (cityx(which), cityy(which)), c, c
	CALL TICK(.1)
	NEXT c
	c = 9: IF cityp(which) = 2 THEN c = 7
	IF cityp(which) = 0 THEN c = 12
	CIRCLE (cityx(which), cityy(which)), 4, 0
	CIRCLE (cityx(which), cityy(which)), 3, c
	PAINT (cityx(which), cityy(which)), c, c
	END SUB

	SUB fortify (target)
		target = 0: hilite = 11
		tlx = 67: tly = 2
		who = side
		CALL starfin(star, fin, who)
		size = 0
		FOR i = star TO fin
		IF armyloc(i) > 0 AND fort(armyloc(i)) < 2 THEN
			size = size + 1
			mtx$(size) = city$(armyloc(i))
			array(size) = armyloc(i)
		END IF
		NEXT i
		IF size = 0 THEN CALL clrbot: COLOR 11: PRINT "No cities eligible to fortify"; : EXIT SUB
		CALL bubble(size)
		mtx$(0) = "Fortify"
			choose = 31
			CALL menu(9): CALL clrrite
			IF choose < 0 GOTO nocity
			target = array(choose): CALL occupy(target): x = occupied(target): IF x < 0 GOTO nocity
			IF fort(target) > 1 THEN CALL clrbot: PRINT city$(target); " at MAXIMUM fortification level of 2"; : CALL TICK(4): GOTO nocity
			cost = 200
			IF cash(side) < cost THEN CALL clrbot: PRINT "Fortifications for "; city$(target); " cost "; cost; " and you only have "; cash(side); : CALL TICK(4): GOTO nocity
			COLOR 3
			fort(target) = fort(target) + 1
			cash(side) = cash(side) - cost
			CALL clrbot: PRINT city$(target); " fortifications increased to "; fort(target);
			CALL icon(target, 0, 6)
			CALL showcity
			IF armymove(x) > 0 THEN CALL icon(armyloc(x), armymove(x), 5)
			armymove(x) = -1
			CALL placearmy(x)
			CALL stax(who)
	nocity:
END SUB

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

SUB iterate
	FOR i = 1 TO 40: IF armyloc(i) > 0 THEN CALL placearmy(i)
	NEXT i

	month = month + 2
	IF month > 12 THEN month = 1: year = year + 1

	s = 1
	FOR i = 1 TO 40: IF armyloc(i) < 1 GOTO rip
	IF i > 20 THEN s = 2
	IF cash(s) >= .2 * armysize(i) THEN
		a = 1: IF realism > 0 THEN CALL cutoff(s, armyloc(i), a)
		IF a > 0 THEN
			supply(i) = supply(i) + 1
			cash(s) = cash(s) - .2 * armysize(i)
		END IF
	END IF
	IF (month < 7 OR month > 10) AND matrix(armyloc(i), 7) < 99 THEN supply(i) = supply(i) - 1
	IF matrix(armyloc(i), 7) = 99 AND navyloc(3 - s) = armyloc(i) THEN supply(i) = supply(i) - 1: CALL clrbot: PRINT armyname$(i); " is blockaded"; : CALL TICK(turbo!)
	COLOR 13
	IF supply(i) < 1 THEN
		supply(i) = 0
		CALL clrbot
		PRINT armyname$(i); " is out of supplies";
		CALL placearmy(i)
		CALL TICK(turbo!)
		IF RND > .8 AND armysize(i) > 50 THEN armysize(i) = .9 * armysize(i)
	END IF
	rip:
	NEXT i
	FOR k = 1 TO 2: CALL stax(k): NEXT k
	y = 0: FOR i = 1 TO 20: y = y + .1 * armysize(i): NEXT i
	x = 0: FOR i = 21 TO 40: x = x + .1 * armysize(i): NEXT i
	IF side = 2 AND x > 0 THEN aggress! = y / x ELSE aggress! = 1
	IF side = 1 AND y > 0 THEN aggress! = x / y ELSE IF side = 1 THEN aggress! = 1
END SUB

SUB movefrom (index, target)
	colour = 3: tlx = 67: tly = 5: index = 0: size = 0: target = 0
	who = side: CALL starfin(star, fin, who)
	FOR i = star TO fin
	IF armyloc(i) > 0 AND armymove(i) = 0 THEN size = size + 1: mtx$(size) = city$(armyloc(i)): array(size) = armyloc(i)
	NEXT i
	IF size = 0 THEN index = -1: GOTO notarg
	mtx$(0) = "From"
	CALL bubble(size)
	movopt:
		tlx = 67: tly = 5
			hilite = 15: CALL menu(1): CALL clrrite
			IF choose < 0 THEN target = 0: GOTO notarg
			target = array(choose)

			size = 0
			FOR i = star TO fin
			IF armyloc(i) = target AND armymove(i) = 0 THEN index = i: size = size + 1: mtx$(size) = "Army" + STR$(i): array(size) = i
			NEXT i
			IF size = 1 GOTO notarg
			mtx$(0) = "Which"
			CALL bubble(size)
			tlx = 67: tly = 15: CALL menu(4): CALL clrrite
			IF choose < 0 THEN index = 0: GOTO notarg
			index = array(choose)
	notarg:
END SUB

SUB navy (who, chx)
	DIM hit(2)
	IF chx > 0 THEN
		IF navyloc(who) < 1 THEN
			chx = 1
		ELSE
			IF commerce = 3 - who AND raider > 0 THEN chx = 4
			IF grudge > 0 THEN chx = 3
		END IF
	END IF
	COLOR 11
	ahoy:
	cost = 100: cityp(0) = who
	IF chx = 0 THEN CALL clrbot: PRINT "Funds available "; cash(who);
	IF chx = 1 THEN
		IF cash(who) < cost THEN EXIT SUB
		IF navysize(who) > 9 THEN EXIT SUB
	END IF
	mtx$(0) = "Ships"
	mtx$(1) = "Build"
	IF navyloc(who) <> 99 THEN
	IF cash(who) < cost OR navysize(who) > 9 OR cityp(navyloc(who)) <> who THEN mtx$(1) = "-": choose = 23
	END IF
	mtx$(2) = "Attack"
	IF navyloc(who) <> 99 THEN
	IF cityp(navyloc(who)) <> 3 - who THEN mtx$(2) = "-": choose = 22
	ELSE
	mtx$(1) = "-": mtx$(2) = "-": choose = 24
	END IF
	mtx$(3) = "Sail": IF navyloc(who) < 1 THEN mtx$(3) = "-": IF chx = 3 THEN chx = 1
	mtx$(4) = "Raid": IF navysize(who) < 1 OR commerce = who THEN mtx$(4) = "-"
	tlx = 67: tly = 12: size = 4
	IF navyloc(who) <> 99 THEN
	IF who = 1 AND navysize(who) > 1 AND cityp(navyloc(who)) = 0 THEN size = 5: mtx$(5) = "Invasion": CALL void(navyloc(1), defend): IF chx > 0 AND defend < 100 THEN chx = 5
	IF realism = 0 AND who = 2 AND navysize(who) > 1 AND cityp(navyloc(who)) = 0 THEN size = 5: mtx$(5) = "Invasion": CALL void(navyloc(1), defend): IF chx > 0 AND defend < 100 THEN chx = 5
	END IF

	IF chx > 0 THEN choose = chx: GOTO anchor
	IF nflag > 0 AND choose <> 1 THEN EXIT SUB
	CALL menu(0): CALL clrrite
	anchor:

	SELECT CASE choose
		CASE 1 ' Build Ship
		IF cash(who) < cost OR navyloc(who) = 99 GOTO ahoy
		IF chx = 1 AND navysize(who) > 9 THEN EXIT SUB
		IF chx = 0 AND navysize(who) > 9 THEN GOTO ahoy

		IF chx = 0 AND navyloc(who) > 0 THEN
			IF cityp(navyloc(who)) <> who GOTO ahoy
			IF matrix(navyloc(who), 7) < 99 GOTO ahoy
		END IF
		IF chx = 1 AND RND < .07 * navysize(who) THEN EXIT SUB
		a$ = "W"

		IF realism > 0 AND ((year < 1862) OR (year = 1862 AND month < 3)) GOTO noiron
		IF cash(who) >= 2 * cost THEN
			tlx = 67: tly = 12: colour = 9
			IF who = side THEN
				mtx$(0) = "Type"
				mtx$(1) = "Wooden"
				mtx$(2) = "Ironclad"
				size = 2
				CALL menu(0)
				CALL clrrite
				IF choose < 1 GOTO ahoy
				IF choose = 2 THEN a$ = "I": cost = 2 * cost
			ELSE
				a$ = "I"
			END IF
		END IF

	noiron:
		navysize(who) = navysize(who) + 1
		IF a$ = "W" THEN
			fleet$(who) = fleet$(who) + a$: a = 1
		ELSE
			fleet$(who) = a$ + fleet$(who): a = 2
		END IF
		IF navysize(who) > 1 GOTO add2ship
	ships:
		mtx$(0) = "Port": size = 0: tlx = 67: tly = 12
		FOR i = 1 TO 40: IF matrix(i, 7) = 99 AND cityp(i) = who AND navyloc(3 - who) <> i THEN size = size + 1: mtx$(size) = city$(i): array(size) = i
		NEXT i
		IF chx = 1 THEN choose = 1 + INT(size * RND)
		IF size < 1 THEN
			navysize(who) = 0: fleet$(who) = ""
			IF chx = 0 THEN CALL clrbot: PRINT "NO SHIPYARDS AVAILABLE !"; : EXIT SUB
			IF chx = 1 THEN EXIT SUB
		END IF
		IF chx = 0 THEN CALL menu(9): CALL clrrite

		IF choose < 1 GOTO ships
		navyloc(who) = array(choose)
		cash(who) = cash(who) - cost: navysize(who) = 1
		x = cityx(array(choose)) + 25: y = cityy(array(choose)) + 25: CALL ships
		CALL clrbot: COLOR 11: PRINT force$(who); " is building NEW fleet in "; city$(array(choose));
		PSET (400, 465), 0: CALL shipicon(who, a)
		IF noise > 0 THEN SOUND 3000, 1
		CALL TICK(turbo!)
		GOTO ahoy
	add2ship:
		cash(who) = cash(who) - cost
		CALL clrbot: PRINT force$(who); " navy increased to "; navysize(who);
		PSET (400, 465), 0: CALL shipicon(who, a)
		CALL ships
		IF noise > 0 THEN SOUND 3000, 1
		CALL TICK(turbo!)
		CASE 2 ' Attack City
		IF navyloc(who) = 99 GOTO ahoy
		IF chx = 2 AND cityp(navyloc(who)) = who THEN EXIT SUB
		IF chx = 2 AND occupied(navyloc(who)) > 0 AND RND > .5 THEN chx = 3: GOTO anchor
		IF chx = 2 AND cityp(navyloc(who)) = 0 THEN chx = 3: GOTO ahoy
		IF navyloc(who) < 1 THEN EXIT SUB
		IF who = side THEN nflag = 1
		IF cityp(navyloc(who)) <> 3 - who GOTO ahoy
		CALL clrbot: COLOR 12: PRINT force$(who); " fleet bombards "; city$(navyloc(who));
		CALL icon(navyloc(who), 0, 3)
			
		target = navyloc(who): index = occupied(target): IF index = 0 GOTO deserted
		pct! = .005 * navysize(who) + .02 * RND: killd = armysize(index) * pct!: IF killd < 1 THEN killd = 1
		CALL clrbot: PRINT armyname$(index); " suffered "; 100 * killd; " casualties";
		x = .5 * navysize(who) + 1: IF x > supply(index) THEN x = supply(index)
		supply(index) = supply(index) - x
		CALL TICK(turbo!)
		armysize(index) = armysize(index) - killd: IF armysize(index) < 1 THEN armysize(index) = 1
		EXIT SUB
	deserted:
		IF fort(target) = 0 GOTO blast
		IF RND < .7 + .03 * (navysize(who) - fort(target)) GOTO hurt1
		CALL barnacle(who)
		CALL clrbot
		PRINT force$(cityp(target)); " shore battery sunk an attacking ship!"; navysize(who); "ship(s) left! ";
		IF noise > 0 THEN SOUND 77, .5: SOUND 59, .5
		CALL TICK(turbo!)
		IF navysize(who) < 1 THEN
			navyloc(who) = 0: fleet$(who) = "": GOSUB box2
			LOCATE 12, 27: PRINT force$(who); " fleet eliminated"
			CALL TICK(9)
			victory(3 - who) = victory(3 - who) + 5
			IF who = side THEN grudge = 0
			GOTO sail3
		END IF
		GOTO deserted
	hurt1:
		CALL clrbot: PRINT city$(target); " fortifications damaged";
		fort(target) = fort(target) - 1: x = cityx(target): y = cityy(target): LINE (x - 5, y - 5)-(x + 5, y + 5), 2, BF
		CALL showcity
		CALL TICK(turbo!)
		EXIT SUB
	blast:
		IF RND > .25 + .07 * navysize(who) THEN CALL clrbot: PRINT "Citizens of "; city$(target); " stand firm against the attack"; : CALL TICK(turbo!): EXIT SUB
		IF navyloc(who) = capcity(3 - who) THEN CALL clrbot: PRINT "The CAPITAL steadfastly stands loyal"; : CALL TICK(turbo!): EXIT SUB
		cityp(navyloc(who)) = 0
		CALL clrbot: PRINT city$(navyloc(who)); " is now  NEUTRAL";
		CALL showcity
		victory(who) = victory(who) + cityv(navyloc(who))
		EXIT SUB
		CASE 3  ' Sail
		navysize(who) = LEN(fleet$(who))
		IF navysize(who) < 1 AND chx > 0 THEN EXIT SUB
		IF navyloc(who) < 1 OR navysize(who) < 1 THEN CALL clrbot: PRINT "No ships remain"; : TICK 1: GOTO ahoy

		size = 0
		FOR i = 1 TO 40: IF matrix(i, 7) > 90 AND navyloc(who) <> i THEN size = size + 1: mtx$(size) = city$(i): array(size) = i
		NEXT i
		IF chx = 3 THEN
			IF size = 0 THEN EXIT SUB
			IF grudge > 0 THEN choose = 1: array(1) = navyloc(3 - who): GOTO admiral
			GOSUB nest: IF choose > 0 GOTO admiral ELSE EXIT SUB
		END IF
		COLOR 11: LOCATE 11, 68
		IF navyloc(who) < 41 THEN
			PRINT city$(navyloc(who))
		ELSE
			PRINT "Raiding"
		END IF
		mtx$(0) = "To"
		colour = 3: tlx = 67: tly = 12
		
		CALL menu(9): CALL clrrite: IF choose < 1 THEN EXIT SUB
	admiral:
		IF array(choose) = navyloc(who) THEN EXIT SUB
		IF array(choose) < 1 THEN EXIT SUB
		IF navysize(who) < 1 GOTO ships
		IF who = side THEN nflag = 1
		GOSUB box2
		LOCATE 10, 25: PRINT force$(who); " fleet of"; navysize(who); "ship(s) is sailing"
		LOCATE 11, 25: PRINT "From ";
		IF navyloc(who) < 41 THEN
			PRINT city$(navyloc(who));
		ELSE
			PRINT "Raiding";
		END IF
		PRINT " to ";
		IF array(choose) <> 99 THEN
			PRINT city$(array(choose));
		ELSE
			PRINT "Raid Commerce";
		END IF

		FOR i = 1 TO navysize(who)
			PSET (120 + 41 * i, 210), 0
			CALL shiptype(who, i)
		NEXT i
		IF graf > 2 THEN
			a = ASC(LEFT$(fleet$(who), 1))
			SELECT CASE a
				CASE 73
					CALL ironclad
				CASE 87
					CALL schooner
			END SELECT
			TICK 2 * turbo!
		ELSE
			TICK turbo!
		END IF
		navyloc(who) = array(choose)
		IF navyloc(1) = navyloc(2) GOTO pirate
		GOTO sail3
		CASE 4 ' Raid Commerce
		navysize(who) = LEN(fleet$(who))
		IF navysize(who) < 1 AND chx > 0 THEN EXIT SUB
		IF navysize(who) < 1 OR commerce = who GOTO ahoy

		IF who = side THEN nflag = 1
		GOSUB box2
		LOCATE 10, 25: PRINT force$(who); " fleet of"; navysize(who); "ship(s) is sailing"
		LOCATE 11, 25: PRINT "to RAID "; force$(3 - who); " COMMERCE !"

		FOR i = 1 TO navysize(who)
			PSET (120 + 41 * i, 210), 0
			CALL shiptype(who, i)
		NEXT i
		IF graf > 2 THEN
			a = ASC(LEFT$(fleet$(who), 1))
			SELECT CASE a
				CASE 73
					CALL ironclad
				CASE 87
					CALL schooner
			END SELECT
			TICK 2 * turbo!
		ELSE
			TICK turbo!
		END IF
		navyloc(who) = 99: commerce = who
		IF navyloc(1) = navyloc(2) GOTO pirate
		CLS : CALL usa
		EXIT SUB
		CASE 5  ' Invasion
		CALL commander((who), empty)
		IF chx > 0 AND empty = 0 THEN chx = 3: GOTO anchor
		x = 35
		CALL barnacle(who)
		c = navyloc(who): CALL newarmy((who), empty, c)
		cash(who) = cash(who) + 100     'compensate for cost of recruiting new army
		CALL capture(empty, c, who, 0)
		armysize(empty) = x
		IF who = side THEN nflag = 1
		EXIT SUB
		CASE ELSE ' Exit
		EXIT SUB
	END SELECT
	GOTO ahoy
	'---------------------------------------------------------------------------
	'                               Ship vs. Ship
	'---------------------------------------------------------------------------
	pirate:
		CLS : LOCATE 1, 30: COLOR 11: PRINT "NAVAL COMBAT"
		FOR k = 1 TO 2
		hit(k) = 10
		IF RIGHT$(fleet$(k), 1) = "I" THEN hit(k) = 20
		NEXT k
	cannon:
		LOCATE 9, 1: PRINT SPACE$(79)
		LOCATE 15, 1: PRINT SPACE$(79)
		x = 10: y = 100
		COLOR 9: LOCATE 5, 25: PRINT "UNION"; navysize(1); "ship(s)"
		GOSUB boxes
		COLOR 1
		FOR i = 1 TO navysize(1)
		x = x + 50: PSET (x, y)
		CALL shiptype(1, i)
		NEXT i
		COLOR 11: LOCATE 11, 22: PRINT "CONFEDERATES "; navysize(2); "ship(s)"
		LINE (10, 180)-(530, 210), 1, BF
		LINE (10, 180)-(530, 210), 11, B
		x = 10: y = 200
		COLOR 1
		FOR i = 1 TO navysize(2)
		x = x + 50: PSET (x, y)
		CALL shiptype(2, i)
		NEXT i
		COLOR 11
	wave:
		mtx$(0) = "Options"
		mtx$(1) = "Attack"
		mtx$(2) = "Retreat"
		IF chx > 0 THEN choose = 1: GOTO powder
		
		size = 2: colour = 3: hilite = 14: tlx = 50: tly = 18: CALL menu(0)
	powder:
		SELECT CASE choose
		CASE 1
	firemore:
		IF noise > 0 THEN SOUND 77, .5: SOUND 59, .5: CALL TICK(.1)
		pct! = 0: a$ = RIGHT$(fleet$(who), 1)
		IF a$ <> RIGHT$(fleet$(3 - who), 1) THEN
			IF a$ = "I" THEN pct! = .1 ELSE pct! = -.1
		END IF
		IF RND <= .5 + pct! GOTO hitem ELSE GOTO hitme1
		GOTO firemore
	hitem:
		hit(3 - who) = hit(3 - who) - 1: GOSUB showhit: IF hit(3 - who) > 0 GOTO firemore
		x = 10 + 50 * navysize(3 - who)
		y = 90: IF who = 1 THEN y = 190
		GOSUB xout
		LOCATE 17, 5: PRINT force$(3 - who); " ship SUNK!": CALL TICK(turbo! + 1): GOSUB clr1
		CALL barnacle(3 - who)
		IF navysize(3 - who) < 1 THEN
			LOCATE 19, 5: COLOR 12
			PRINT force$(3 - who); " fleet DEFEATED"
			CALL TICK(turbo!)
			navyloc(3 - who) = 0: fleet$(3 - who) = ""
			victory(3 - who) = victory(3 - who) + 10
			IF who = side THEN grudge = 1 ELSE grudge = 0
			GOTO sail3
		END IF
		hit(3 - who) = 10
		IF RIGHT$(fleet$(3 - who), 1) = "I" THEN hit(3 - who) = 20
		GOTO cannon
	hitme1:
		hit(who) = hit(who) - 1: GOSUB showhit: IF hit(who) > 0 GOTO firemore
		x = 10 + 50 * navysize(who)
		y = 190: IF who = 1 THEN y = 90
		GOSUB xout
		LOCATE 17, 5: PRINT "One of the "; force$(who); " ships was SUNK!": CALL TICK(turbo!): GOSUB clr1
		CALL barnacle(who)
		IF navysize(who) < 1 THEN
			LOCATE 19, 5: COLOR 12
			PRINT "Attacking "; force$(who); " fleet has been ELIMINATED !"
			CALL TICK(turbo!)
			navyloc(who) = 0: fleet$(who) = ""
			victory(who) = victory(who) + 10
			IF who <> side THEN grudge = 1 ELSE grudge = 0
			GOTO sail3
		END IF
		hit(who) = 10
		IF RIGHT$(fleet$(who), 1) = "I" THEN hit(who) = 20
		GOTO cannon

		CASE 2
		target = 0
		FOR i = 1 TO 40
		IF cityp(i) = who THEN IF i <> navyloc(who) AND matrix(i, 7) = 99 THEN target = i: IF RND > .3 GOTO found1
		NEXT i
	found1:
		CALL clrbot: COLOR 11: PRINT force$(who); " is retreating to "; city$(target); : CALL TICK(turbo!)
		navyloc(who) = target
		GOTO sail3
		CASE ELSE
		GOTO wave
		END SELECT
		GOTO pirate
	'---------------------------------------------------------------------------
	'                               Subs
	'---------------------------------------------------------------------------
	showhit:
		LOCATE 9, 6 * navysize(1): PRINT hit(1); " ";
		LOCATE 15, 6 * navysize(2): PRINT hit(2); " ";
		IF noise = 0 THEN TICK .1 * turbo!
		RETURN
	clr1:
		LOCATE 17, 1: PRINT SPACE$(60): RETURN
	nest:
		best = 0: x = 0
		FOR i = 1 TO size
		target = array(i)
		IF cityp(target) = 0 GOTO neutral

		IF target = navyloc(3 - who) THEN IF navysize(who) >= navysize(3 - who) AND RND > .1 THEN choose = i: RETURN
		IF cityp(target) <> who THEN
			best = i: x = x + 1
			IF RND > .8 THEN choose = best: RETURN
		END IF
	neutral:
		NEXT i
		IF best = 0 THEN
			choose = 1 + INT(RND * size)
		ELSE
			choose = best
		END IF

		IF who = 2 AND navyloc(2) = 30 THEN IF RND > .5 THEN choose = 30: RETURN
		RETURN
	boxes:
		LINE (10, 80)-(530, 110), 1, BF
		LINE (10, 80)-(530, 110), 11, B
		RETURN
	box2:
		CLS
		LINE (100, 110)-(550, 240), 1, B
		LINE (95, 115)-(555, 235), 7, B
		RETURN
	xout:
			PSET (x, y)
			DRAW "S5C15G5F5G3H5G5H3E5H5E3F5E5F3"
			PAINT (x - 3, y + 1), 12, 15
		RETURN
	sail3:
		commerce = 0
		FOR k = 1 TO 2
		IF navyloc(k) = 99 THEN commerce = k
		NEXT k
		CLS : CALL usa
END SUB

SUB newarmy (who, empty, target)
	supply(empty) = 3 + 5 * RND: IF who = 1 THEN supply(empty) = supply(empty) + 2
	armyexper(empty) = 1: IF who = 2 THEN armyexper(empty) = 2
	armylead(empty) = rating(empty)
	armyname$(empty) = lname$(empty): lname$(empty) = ""
	COLOR 12: CALL clrbot: PRINT "Placing NEW army "; empty; armyname$(empty); " in "; city$(target);

	x = 70: IF realism > 0 THEN x = 3 * cityv(target) + 33
	CALL cutoff(who, target, a): IF a < 1 THEN x = x \ 3
	occupied(target) = empty: armysize(empty) = x
	PRINT " Size = "; : CALL strong(empty)
	cash(who) = cash(who) - 100: IF noise > 0 THEN SOUND 2222, .5
	armyloc(empty) = target: CALL placearmy(empty)
	CALL TICK(turbo! - .5)
	armymove(empty) = -1
END SUB

SUB newcity (index)
		mtx$(1) = "  "
		mtx$(3) = "  "
		size = 3: a$ = city$(index)
	morecap:
			tlx = 68: tly = 15: colour = 3: choose = 23
			mtx$(2) = city$(index)
			CALL menu(3): CALL clrrite
			SELECT CASE choose
			CASE IS = -27
			index = 0: EXIT SUB
			CASE IS < 1
			a$ = CHR$(ABS(choose))
			x = 0
			FOR k = 1 TO 40
			IF LEFT$(city$(k), 1) = a$ THEN
				y = index: index = k
	spin2:
				IF cityp(index) = side GOTO morecap
					index = index + 1
					IF index > 40 THEN index = 1
					x = x + 1: IF x < 39 GOTO spin2
					index = y: GOTO morecap
			END IF
			NEXT k
			GOTO morecap
			CASE 1
	minus1:
			index = index - 1: IF index < 1 THEN index = 40
			IF cityp(index) <> side GOTO minus1 ELSE GOTO morecap
			CASE 2
			GOTO fnew
			CASE 3
	plus1:
			index = index + 1: IF index > 40 THEN index = 1
			IF cityp(index) <> side GOTO plus1 ELSE GOTO morecap
			CASE ELSE
			index = 0
			END SELECT
	fnew:
END SUB

SUB normal (xbar, vary, result)
	' NOTE : vary is VARIANCE
	pct! = 0
	FOR k = 1 TO 12: pct! = pct! + RND: NEXT k
	pct! = pct! - 5.5
	result = xbar + pct! * SQR(vary)
END SUB

SUB placearmy (which)
	who = 1: IF which > 20 THEN who = 2
	x = cityx(armyloc(which)) - 12
	y = cityy(armyloc(which)) - 11
	CALL armyxy(x, y, who)
	IF supply(which) < 1 THEN
		x = x - 3: y = y + 4
		PSET (x, y), 13: DRAW "C11S8"
		DRAW font$(19)
		DRAW "S4"
	END IF
END SUB

SUB railroad (who)
	SELECT CASE rr(who)
		CASE 0
		IF who = side GOTO human
		CALL starfin(star, fin, who): max = 32767
		index = 0
		FOR i = star TO fin: IF armyloc(i) = 0 OR armymove(i) <> 0 GOTO puter
		x = 0: FOR j = 1 TO 6: from = matrix(armyloc(i), j): IF from > 0 AND cityp(from) <> who THEN x = x + 1
		NEXT j
		IF occupied(capcity(who)) > 0 AND x > 1 GOTO puter
		CALL void(armyloc(i), defend)
		IF vicflag(5) > 0 AND occupied(capcity(who)) = 0 THEN IF defend > max THEN defend = max - 1
		IF defend < max THEN target = armyloc(i): GOSUB route: IF x > 1 THEN max = defend: index = i
	puter:  NEXT i
		IF index = 0 OR max > .3 * armysize(index) GOTO toot
		CALL traincapacity(who, limit)
		IF armysize(index) > limit THEN GOTO toot
		from = armyloc(index)
		x1 = 0: FOR i = 1 TO 40: IF cityp(i) <> who GOTO puted
		CALL void(i, defend): IF defend = 0 OR defend > 3 * armysize(index) GOTO puted
		IF occupied(i) > 0 GOTO puted
		target = i
		GOSUB route: IF x = 0 GOTO puted
		IF side = 1 AND cityy(i) < cityy(from) THEN x1 = i
		IF side = 2 AND cityy(i) > cityy(from) THEN x1 = i
		IF fort(i) > 0 AND occupied(i) = 0 THEN x1 = i: EXIT FOR
	puted:  NEXT i
		IF vicflag(5) > 0 AND occupied(capcity(who)) = 0 THEN
			GOSUB route
			IF x > 0 THEN
				CALL void(capcity(who), defend)
				IF defend > 0 THEN x1 = capcity(who)
			END IF
		END IF
		IF x1 > 0 GOTO haul ELSE GOTO toot
	human:
		CALL movefrom(index, a): IF a < 1 OR index < 1 THEN COLOR 11: CALL clrbot: PRINT "Railroad move not allowed"; : GOTO toot
		x = 1: IF index > 20 THEN x = 2
		CALL traincapacity(who, limit)
		IF armysize(index) > limit THEN CALL clrbot: PRINT "Too many troops for railroad capacity"; : GOTO toot
		
		target = armyloc(index): GOSUB route: IF x > 1 GOTO aboard
		CALL clrbot: PRINT "Track from "; city$(target); " is blocked"; : GOTO toot
	aboard:
		CALL clrbot: PRINT "Select destination for "; armyname$(index); " from "; city$(target);
		mtx$(0) = "To": from = target: x1 = from: IF from = 0 GOTO toot
		CALL newcity(x1): IF x1 = from OR x1 = 0 GOTO toot

		target = x1: GOSUB route: IF x > 1 GOTO haul
		CALL clrbot: PRINT armyname$(index); "'s train cannot go to "; city$(x1); " - select another city"; : CALL TICK(9)
		GOTO aboard
	haul:
		COLOR 11: CALL clrbot: PRINT armyname$(index); " is taking the train from "; city$(from); " to "; city$(x1);
		tracks(who) = armyloc(index)
		from = armyloc(index)
		rrfrom(who) = from
		rr(who) = index: armyloc(index) = 0: armymove(index) = x1
		CALL tinytrain(who, 1)
		IF noise > 0 THEN SOUND 2222, 1
		CALL engine

		CALL occupy(from)
		IF occupied(from) > 0 THEN CALL placearmy(occupied(from))
		GOTO toot

		CASE IS > 0
		CALL tinytrain(who, 0)
		CALL occupy(rrfrom(who))
		IF occupied(rrfrom(who)) > 0 THEN CALL placearmy(occupied(rrfrom(who)))

		index = rr(who)
		tracks(who) = armymove(index)
		CALL tinytrain(who, 1)

		rr(who) = 0: armyloc(index) = armymove(index): armymove(index) = -1
		COLOR 11: CALL clrbot: PRINT "Train with "; armyname$(index); " has arrived in "; city$(armyloc(index)); : IF noise > 0 THEN SOUND 1200, 2
		CALL TICK(turbo!)
		x = cityx(armyloc(index)) - 12: y = cityy(armyloc(index)) - 11
		LINE (x - 9, y - 8)-(x + 10, y + 8), 2, BF
		IF cityp(armyloc(index)) <> who THEN CALL capture(index, armyloc(index), who, 0)
		CALL placearmy(index)
		IF occupied(armyloc(index)) > 0 THEN CALL stax(who): GOTO toot
		CALL occupy(armyloc(index)): CALL placearmy(index)
		GOTO toot
	END SELECT

	route:
		x = 0: FOR j = 1 TO 6
		y = matrix(target, j)
		IF y > 0 AND cityp(y) = who THEN
		x = x + 1
			FOR m = 1 TO 6
			z = matrix(y, m)
			IF z > 0 AND z <> target AND cityp(z) = who THEN x = x + 1
			NEXT m
		END IF
	NEXT j
	RETURN

	toot:
		IF who = side THEN CALL TICK(9)
		CALL clrrite
		clrbot
	END SUB

	SUB recruit (who)
		IF cash(who) < 100 GOTO menu1
		size = 0: COLOR 12
		mtx$(0) = "Recruit"
		IF who = side AND rflag > 0 THEN FOR i = 1 TO rflag: x = rcity(i): mtx$(i) = city$(x): array(i) = x: NEXT i: size = rflag: GOTO alldone
		max = 4: IF RND > .8 THEN max = max - 1
		IF difficult < 3 THEN max = max + 1

		FOR i = 1 TO 40
		IF control(who) > 0 THEN pct! = .6 * max / control(who) ELSE pct! = .3
		IF size = 0 AND i > 20 THEN pct! = .3
		IF size < 2 AND i > 30 THEN pct! = .3
		array(i) = 0
		IF occupied(i) > 0 AND cityp(i) = who THEN pct! = .4
		IF RND < pct! AND cityp(i) = who THEN
			IF realism > 0 AND cityo(i) = 3 - who GOTO foe
			size = size + 1
			mtx$(size) = city$(i)
			array(size) = i
			IF size > max - 1 GOTO alldone
		END IF
	foe:
		NEXT i
	alldone:
		IF size = 0 GOTO menu1
		IF who = side AND rflag = 0 THEN FOR i = 1 TO size: rcity(i) = array(i): NEXT i: rflag = size
		CALL bubble(size)

	levy:
		IF cash(who) < 100 GOTO menu1
		IF (who = side) OR (player = 2) THEN CALL clrbot: PRINT force$(who); " funds available "; cash(who);
		tlx = 67: tly = 12: colour = 3
		IF who <> side THEN GOSUB randsel: GOTO auto1
		
		IF choose > 0 THEN choose = 21 + choose
		CALL menu(2): CALL clrrite
		IF choose < 1 GOTO menu1
	auto1:
		empty = 0
		index = array(choose)
		CALL occupy(index)
		IF occupied(index) > 0 THEN i = occupied(index): GOTO add2
		CALL commander((who), empty)
		
		IF who <> side AND empty = 0 GOTO menu1
		IF empty = 0 GOTO levy
		armyloc(empty) = index
		GOSUB playb
		CALL newarmy(who, empty, index)
		GOTO levy

	add2:
		target = array(choose)
		x = 45: a$ = ""
		IF realism > 0 THEN
			x = 2 * cityv(armyloc(i)) + 20
			CALL cutoff(who, target, a)
			IF a < 1 THEN x = x \ 3: a$ = " ISOLATED !"
		END IF
		armysize(i) = armysize(i) + x

		GOSUB playb
		cash(who) = cash(who) - 100
		from = armyloc(i): x = cityx(from) - 12: y = cityy(from) - 11
		GET (x - 9, y - 7)-(x + 9, y + 6), anima
		CALL icon(armyloc(i), 0, 2)
		IF noise > 0 THEN SOUND 2222, 1
		COLOR 11: CALL clrbot: PRINT "Army "; i; armyname$(i); " in "; city$(armyloc(i)); " strength increased to "; : CALL strong(i)
		IF a$ <> "" THEN PRINT a$;
		PUT (x - 9, y - 7), anima, PSET
		CALL TICK(turbo! - .5)
		GOTO levy
	randsel:
			choose = 0: x = 0
			FOR i = 1 TO size
			target = array(i)
			LOCATE 14 + i, 69
			x = occupied(target)
			IF x = 0 XOR armysize(x) < 155 THEN choose = i
			NEXT i

		IF choose = 0 THEN choose = 1 + INT(RND * size)
		IF realism > 0 THEN
			x = 0
			FOR i = 1 TO size
			target = array(i)
			IF occupied(target) = 0 THEN
				y = 3 * cityv(target) + 33
				CALL cutoff(who, target, a)
				IF a < 1 THEN y = y \ 3
			ELSE
				y = 2 * cityv(target) + 20
				CALL cutoff(who, target, a)
				IF a < 1 THEN y = y \ 3
			END IF
			IF y > x AND RND > .5 THEN x = y: choose = i
			NEXT i
		END IF
		IF cash(who) < 100 THEN choose = size
		RETURN
	playb:
		IF side = 1 AND difficult < 3 THEN armysize(empty) = armysize(empty) + 15 - 5 * difficult
		IF side = 2 AND difficult > 3 THEN armysize(empty) = armysize(empty) + 5 * difficult - 15
		RETURN
	menu1:
END SUB

SUB shiptype (who, i)
	a = 1: IF MID$(fleet$(who), i, 1) = "I" THEN a = 2
	CALL shipicon(who, a)
END SUB

SUB showcity
	FOR i = 1 TO 40
	c = 9: IF cityp(i) = 2 THEN c = 7
	IF cityp(i) = 0 THEN c = 12
	x = cityx(i): y = cityy(i)
	IF i = capcity(1) OR i = capcity(2) THEN
		PUT (x - 6, y - 6), Ncap, PSET
		LINE (x + 9, y - 4)-(x + 15, y + 4), 0, BF
		LINE (x + 8, y - 5)-(x + 13, y + 2), 3, BF
		PSET (x + 8, y - 4)
		IF fort(i) = 1 THEN DRAW "BR2C0e1D6BL1R2"
		IF fort(i) = 2 THEN DRAW "C0e1R1F1D1G3R3"
	ELSE
		IF fort(i) = 1 THEN LINE (x - 5, y - 5)-(x + 5, y + 5), 0, B
		IF fort(i) > 1 THEN LINE (x - 5, y - 5)-(x + 5, y + 5), 0, BF
		CIRCLE (cityx(i), cityy(i)), 4, 0
		CIRCLE (cityx(i), cityy(i)), 3, c
		PAINT (cityx(i), cityy(i)), c, c
	END IF
	IF graf = 0 GOTO nocon
		FOR j = 1 TO 6: IF matrix(i, j) > 0 THEN CALL icon(i, matrix(i, j), 11)
		NEXT j
	nocon:
	NEXT i
END SUB

SUB smarts
	CALL events
	slush = 0: who = 3 - side
	c = 9: IF side = 1 THEN c = 15
	LOCATE 1, 1: PRINT SPACE$(80);
	COLOR c: LOCATE 1, 10: PRINT force$(who); " Side is making decisions";
	CALL starfin(star, fin, who)

	'                       Check Supply
	FOR i = star TO fin: IF armyloc(i) > 0 AND supply(i) < 1 THEN CALL resupply(i)
	NEXT i

	'                       Fortify Capital or Other City
	cost = 200
	IF cost > cash(who) GOTO signup

	target = 0: IF occupied(capcity(who)) = 0 OR fort(capcity(who)) > 1 GOTO city2
	target = capcity(who)
	IF cityp(target) = who GOTO capital ELSE GOTO city2
	IF target > 0 GOTO capital

	city2:
	IF 1 + RND < bold + aggress! GOTO signup
	target = 0: FOR i = star TO fin
	x = armyloc(i): IF x = 0 OR armymove(occupied(x)) < 0 OR armymove(i) < 0 GOTO endlook
	IF fort(x) > 1 GOTO endlook
		CALL void(x, defend): IF defend > armysize(i) THEN target = armyloc(i): GOTO capital
	endlook:
	NEXT i

	capital:
		IF target = 0 GOTO signup
		IF fort(target) > 1 GOTO signup
		fort(target) = fort(target) + 1
		x = occupied(target): armymove(x) = -1
		cash(who) = cash(who) - cost
		CALL clrbot: PRINT city$(target); " fortifications increased to "; fort(target);
		CALL icon(target, 0, 6)
		CALL showcity
		IF who = 1 AND navysize(1) < 1 AND RND > .5 AND cash < 222 GOTO signup
		IF 3 * RND > 1 + aggress! AND cash(who) >= cost GOTO city2

	'                       Recruit New Armies
	signup:
	IF who = 1 AND navysize(1) < 1 AND cash(1) > 100 THEN CALL navy(1, 1): IF cash(who) < 100 GOTO isok
	GOSUB enufarmies
	IF x > 2 + 3 * side + 3 * RND GOTO isok
	IF navysize(who) < 5 AND cash(who) > 100 AND navyloc(who) <> 99 THEN IF cityp(navyloc(who)) = who THEN slush = slush + 100: cash(who) = cash(who) - 100: IF cash(who) < 100 GOTO isok
	CALL recruit(who)

	'                         Naval Commands
	isok:
		cash(who) = cash(who) + slush
	dock:
		IF side = 2 AND navyloc(1) = 0 AND navysize(1) < 1 AND cityp(30) = 1 AND cash(1) > 100 THEN navyloc(1) = 30: CALL navy(1, 1): GOTO movenavy
		IF navyloc(who) = 99 THEN
			IF RND < .9 THEN CALL navy(who, 3)
			GOTO movearmy
		END IF
		IF cash(who) < 100 OR navysize(who) > 9 OR cityp(navyloc(who)) <> who GOTO movenavy
		CALL navy(who, 1)

	movenavy:
		IF navysize(who) = 0 THEN navyloc(who) = 0
		IF navyloc(who) = 0 GOTO movearmy

	'                     move ships & prohibit further action this turn
		IF navyloc(who) <> 99 THEN
			IF cityp(navyloc(who)) = who THEN CALL navy(who, 3): GOTO movearmy   'move ships & prohibit further action this turn
			IF cityp(navyloc(who)) = 0 THEN CALL navy(who, 3): GOTO movearmy
		ELSE
			IF RND < .5 THEN CALL navy(who, 3)
			GOTO movearmy
		END IF

		IF cityp(navyloc(who)) <> who THEN
			IF occupied(navyloc(who)) = 0 OR RND > .3 THEN
				CALL navy(who, 2) 'attack
			ELSE
				CALL navy(who, 3) 'move
			END IF
		END IF

	'                       Give Move Orders to Each Army
	movearmy:
		CALL ships

	'                               Check to Combine
	a = who: CALL combine(a)
	CALL railroad(who)

	'                               Top Priority
	FOR i = star TO fin
	target = armyloc(i)
	IF armyloc(i) < 1 OR armymove(i) < 0 GOTO deadman
	x = armysize(i): IF supply(i) < 1 AND RND > .1 GOTO deadman

	choose = 0

	CALL void(target, defend)

	IF defend > 0 AND target = capcity(who) AND occupied(target) = i GOTO deadman   'hold capital
	IF target <> capcity(who) GOTO nocap
	IF vicflag(5) = 0 GOTO nocap
		FOR j = 1 TO 6
		k = matrix(target, j): IF j = 0 GOTO nocap
		CALL void(k, flag): IF flag > 0 GOTO deadman
		NEXT j
	nocap:
	CALL evaluate(i, best): IF best = 0 GOTO deadman
	move9:
		IF best = 0 THEN choose = 1 + INT((j - 1) * RND)
		IF choose = 0 THEN choose = best
		armymove(i) = matrix(target, choose)

		IF cityp(armymove(i)) = who THEN y = occupied(armymove(i)): IF y > 0 THEN IF armymove(y) = x THEN armymove(i) = 0: GOTO deadman  ' eliminate crossing moves
		IF month = 1 AND jancam = 0 AND cityp(armymove(i)) <> who THEN armymove(i) = 0: GOTO deadman

		IF turbo! > 1 THEN
			COLOR c: CALL clrbot
			PRINT armyname$(i); " plans to move from "; city$(armyloc(i)); " to "; city$(armymove(i));
		END IF
			CALL icon(armyloc(i), armymove(i), 1)
			CALL icon(armyloc(i), armymove(i), 9)
		CALL TICK(turbo! - 1)
		PUT (cityx(armyloc(i)) - 20, cityy(armyloc(i)) - 19), image, PSET
	deadman:
	NEXT i
		FOR i = star TO fin
		IF armymove(i) = 0 AND armyexper(i) < 6 AND armyexper(i) < armylead(i) THEN
			armyexper(i) = armyexper(i) + 1

			IF turbo! > 1 THEN
			CALL clrbot
				PRINT armyname$(i); " has drilled to reach experience level "; armyexper(i);
			END IF
			armymove(i) = -1
			CALL TICK(turbo! - 1)
		END IF
		NEXT i
	EXIT SUB

	enufarmies:
	CALL starfin(star, fin, 3 - who)
	FOR i = star TO fin
		IF armyloc(i) > 0 THEN y = y + .1 * armysize(i)
	NEXT i
	CALL starfin(star, fin, who)
	x = 0: z = 0: FOR i = star TO fin: IF armyloc(i) > 0 THEN x = x + 1: z = z + .1 * armysize(i)
	NEXT i
	IF y > z THEN x = x - 2
	IF y > 2 * z THEN x = 0
	RETURN
END SUB

SUB snapshot (x, y, flag)
	IF flag = 0 THEN GET (x - 10, y - 10)-(x + 10, y + 10), image
	IF flag = 1 THEN PUT (x - 10, y - 10), image, PSET
END SUB

SUB strong (index)
	a$ = LTRIM$(RTRIM$(STR$(armysize(index)))) + "00"
	PRINT a$;
END SUB

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

SUB tupdate
	flag = 0
	IF player = 1 THEN
		CALL smarts
	ELSE
		FOR i = 1 TO 40
		IF armyloc(i) > 0 AND armymove(i) > 0 THEN CALL icon(armyloc(i), armymove(i), 1)
		NEXT i
	END IF
	COLOR 14: LOCATE 1, 1: PRINT SPACE$(80);
	LOCATE 1, 20: PRINT "Update for "; month$(month); ","; year
	CALL clrbot: PRINT "press any key for "; month$(month); ","; year; " events";
	DO WHILE INKEY$ = "": LOOP
	GOSUB upbox

	'                       Assign Time of Action
	FOR i = 1 TO 2: IF rr(i) > 0 THEN CALL railroad(i): LINE (5, 17)-(100, 63), 3, BF: LINE (5, 17)-(100, 63), 0, B: CALL engine
	NEXT i

	FOR i = 1 TO 40
	brray(i) = 999
	IF armymove(i) < 0 THEN armymove(i) = 0
	IF armyloc(i) > 0 AND armymove(i) > 0 THEN brray(i) = INT(4 + 4 * RND) * 100 + i
	IF supply(i) < 1 AND armymove(i) > 0 THEN brray(i) = 900 + i
	SELECT CASE armysize(i)         'bigger armies move slower
		CASE IS > 400
			IF brray(i) < 900 THEN brray(i) = brray(i) + 100: x = 2
		CASE IS > 800
			IF brray(i) < 800 THEN brray(i) = brray(i) + 200: x = 3
		CASE IS > 1000
			IF brray(i) < 700 THEN brray(i) = brray(i) + 300: x = 4
		CASE ELSE
			x = 1
	END SELECT
	IF brray(i) <> 999 AND armylead(i) > 10 * RND THEN
			brray(i) = brray(i) - 100 * (armylead(i) \ 2)
			IF brray(i) < 100 THEN brray(i) = 100 + i
	END IF
	NEXT i

	CALL bub2(40)

	'                       Begin Main Loop
	FOR j = 1 TO 40
	flag = 0
	IF brray(j) = 999 GOTO allthru
	active = INT(brray(j) / 100): active = brray(j) - 100 * active: s = 1: IF active > 20 THEN s = 2
	IF armymove(active) < 1 GOTO digin
	COLOR 11: CALL clrbot: PRINT armyname$(active); " is moving to "; city$(armymove(active));

	supply(active) = supply(active) - 1: IF supply(active) < 0 THEN supply(active) = 0: CALL TICK(turbo!): CALL clrbot: PRINT armyname$(active); " is out of supplies !";

	CALL placearmy(active)
	CALL icon(armyloc(active), armymove(active), 5)

	CALL animate(active, 0)

	target = armymove(active)
	IF occupied(target) = 0 GOTO easy
	IF (s = 1 AND occupied(target) < 21) OR (s = 2 AND occupied(target) > 20) GOTO friend ELSE GOTO enemy


	friend: '                         Join Forces
	COLOR 11: CALL clrbot: PRINT armyname$(active); " and "; armyname$(occupied(target)); " meet in "; city$(target); : CALL TICK(turbo!)
	CALL icon(armymove(active), 0, 6)
	CALL clrbot
	GOTO easy

	enemy: ' Attack
	CALL icon(target, 0, 3)
	defend = occupied(target)

	COLOR 11: CALL clrbot: PRINT armyname$(active); " attacks "; armyname$(defend); " in "; city$(armyloc(defend)); : CALL TICK(turbo! - 1)
	IF armysize(defend) > 0 THEN CALL battle(active, defend, win, lose): flag = 1: IF graf > 0 THEN GOSUB upbox
	IF armyexper(win) < 10 THEN armyexper(win) = armyexper(win) + 1

	IF armysize(lose) < 2 THEN
		CALL clrbot
		a$ = armyname$(lose) + "'s army is crushed in " + city$(armyloc(defend))
		CALL scribe(a$, 2)
		index = lose: GOTO crushed
	END IF

	CALL clrrite

	'                       Attacker Loses
	IF win = active GOTO kickbutt
	armymove(active) = armyloc(active)
	armyloc(active) = target
	COLOR 11: CALL clrbot: PRINT armyname$(active); " withdrew to "; city$(armymove(active));

	CALL placearmy(armyloc(active))
	CALL animate(active, 1)

	armyloc(active) = armymove(active)
	CALL placearmy(armyloc(active))
	CALL placearmy(active)
	occupied(armyloc(active)) = active
	armymove(active) = -2
			
	IF 11 * RND > armylead(defend) THEN CALL icon(armyloc(defend), armymove(defend), 4): IF armymove(defend) > 0 THEN armymove(defend) = -2

	CALL TICK(turbo!): GOTO digin

	kickbutt: ' Defender Retreats
		CALL icon(armyloc(active), target, 4)
		IF armymove(defend) > 0 THEN CALL icon(target, armymove(defend), 4)

		CALL retreat(defend, flee): IF flee > 0 THEN move2 = flee: GOTO outta

		best = 0: flee = 0
		FOR i = 1 TO 6
		x = matrix(target, i)
		IF x > 0 AND (cityp(x) = 3 - s) AND cityv(x) > best THEN
			IF best = 0 THEN
				flee = i: best = cityv(x)
			ELSE
				IF occupied(x) = 0 THEN flee = i: best = cityv(x)
			END IF
		END IF
		NEXT i
		IF flee = 0 GOTO deadmeat
		move2 = matrix(target, flee)
	outta:
		CALL placearmy(defend)                  ' in old city

		armymove(defend) = move2
		CALL animate(defend, 0)                 ' animate retreat
		
		armyloc(defend) = move2
		occupied(move2) = defend
		CALL clrbot
		PRINT armyname$(defend) + " is withdrawing to " + city$(move2);

		CALL placearmy(defend)                  ' in new city
		
		CALL icon(target, 0, 6)
		armymove(defend) = -2
		GOTO holdon

	deadmeat:
		index = defend
		a$ = armyname$(index) + " surrenders to " + armyname$(active) + " in " + city$(armyloc(index))
		CALL scribe(a$, 2)
	crushed:
		IF graf > 2 THEN CALL surrender(index): COLOR 14: LOCATE 3, 68: PRINT armyname$(index): LOCATE 4, 68: PRINT "surrenders !"
		x = 1: IF index > 20 THEN x = 2
		IF noise > 1 AND x <> side THEN PLAY "MFMST220o3e4g8g2.g8g8g8o4c2"
		IF armymove(index) > 0 THEN CALL icon(armyloc(index), armymove(index), 4)
		victory(3 - s) = victory(3 - s) + 25
		armyloc(index) = 0: lname$(index) = "": armyname$(index) = ""
		armysize(index) = 0: armylead(index) = 0
		armyexper(index) = 0: armymove(index) = 0: supply(index) = 0
		supply(active) = supply(active) + supply(index): supply(index) = 0
		IF supply(active) > 10 THEN supply(active) = 10
		CALL TICK(9): CALL clrrite
		IF armyloc(active) = 0 GOTO digin

	holdon: ' check for more defenders
		CALL occupy(target): IF occupied(target) = 0 GOTO easy
		COLOR 11: CALL clrbot: PRINT "There are still defenders in "; city$(target); : CALL TICK(99)
		GOTO enemy

	easy: ' Move into new city
	CALL icon(armyloc(active), target, 4)
	armyloc(active) = target: armymove(active) = -2
	CALL occupy(armyloc(active))
	CALL placearmy(active)

	'                            City Capture
		IF cityp(armyloc(active)) = s GOTO horde
		c = armyloc(active)
		IF player = 1 AND s = side AND fort(c) > 0 AND flag = 0 THEN
			tlx = 67: tly = 15
			hilite = 15: colour = 3
			mtx$(0) = "Raze ?"
			mtx$(1) = "No"
			mtx$(2) = "Yes"
			size = 2
			CALL menu(0)
			CALL clrrite
			IF choose = 2 GOTO smoke
		END IF
		IF player = 1 AND s <> side AND fort(c) > 0 AND flag = 0 THEN
			IF realism > 0 AND cityy(c) > 150 THEN
	smoke:
				fort(c) = 0
				x = cityx(c)
				y = cityy(c)
				LINE (x - 5, y - 5)-(x + 5, y + 5), 2, BF
				CALL showcity
				CALL clrbot
				PRINT armyname$(active); " has destroyed the forts at "; city$(c);
				TICK 3
			END IF
		END IF
		CALL capture(active, c, s, flag)
	horde:
	IF supply(active) < 10 THEN supply(active) = supply(active) + 1: IF RND > .8 GOTO horde
	digin:
	NEXT j
	GOTO allthru

	upbox:
	LINE (450, 318)-(526, 420), 1, BF
	LINE (527, 315)-(527, 439), 10
	COLOR 14: LOCATE 23, 50: PRINT "|=============|"
	LOCATE 24, 50: PRINT "| U P D A T E |"
	LOCATE 25, 50: PRINT "|=============|"
	RETURN

	allthru:
	IF navysize(commerce) < 1 THEN commerce = 0
	IF commerce > 0 THEN
		CALL clrbot
		IF RND < .8 + .02 * navysize(commerce) THEN
			raider = .05 * navysize(commerce) * (1 + RND) * (income(3 - commerce))
			IF raider < 1 THEN raider = 1
			IF raider / income(3 - commerce) > .3 THEN raider = .3 * income(3 - commerce)
			COLOR 15: PRINT force$(commerce); " raiders have sunk $"; raider; " of "; force$(3 - commerce); " commerce";
			a = 1: IF LEFT$(fleet$(commerce), 1) = "I" THEN a = 2
			PSET (500, 465), 0: CALL shipicon(commerce, a)
			IF noise > 0 THEN PLAY "t210l8o4co3bo4l4co3ccL8gfego4co3bo4c"
			IF commerce = side THEN grudge = 1
			TICK 9
		ELSE
			raider = 0
			CALL barnacle(commerce)
			COLOR 15: PRINT force$(commerce); " raiders have lost a ship ("; navysize(commerce); " remain)";
			IF noise > 0 THEN SOUND 590, .5: SOUND 999, .5: SOUND 1999, .5
			IF navyloc(commerce) > 0 THEN
				TICK 9
				GOTO allthru
			ELSE
				commerce = 0
				LINE (447, 291)-(525, 335), 1, BF
				FOR k = 1 TO 5: CIRCLE (480, 315), 4 * k, 11: NEXT k
				TICK 9
				LINE (447, 291)-(525, 335), 1, BF
			END IF
		END IF
	END IF

	CALL touchup
	CALL ships: CALL iterate

	CALL clrbot
	LINE (390, 350)-(520, 400), 1, BF
	COLOR 13: LOCATE 24, 51: PRINT " "; UCASE$(LEFT$(month$(month), 3)); ","; year
	victory(1) = .8 * victory(1) + .3 * (income(1) + control(1))
	IF control(1) > 29 THEN victory(1) = victory(1) + 50: IF control(1) > 34 THEN victory(1) = victory(1) + 100
	IF side = 2 AND control(1) < 11 THEN aggress! = aggress! + .7

	IF victory(1) < 1 THEN victory(1) = 0
	victory(2) = .8 * victory(2) + .3 * (income(2) + control(2))
	IF control(2) > 29 THEN victory(2) = victory(2) + 50: IF control(2) > 34 THEN victory(2) = victory(1) + 100
	IF side = 1 AND control(2) < 11 THEN aggress! = aggress! + .7
	IF player = 2 THEN CALL clrbot: COLOR 14: PRINT "press a key"; : DO WHILE INKEY$ = "": LOOP
END SUB

SUB armyxy (x, y, z)
	LINE (x - 5, y - 3)-(x + 10, y + 8), 0, BF
	SELECT CASE z
		CASE 1
		LINE (x - 7, y - 5)-(x + 7, y + 5), 4, BF
		LINE (x - 7, y - 5)-(x - 1, y), 1, BF
		LINE (x, y - 2)-(x + 7, y - 1), 7, B
		LINE (x - 7, y + 2)-(x + 7, y + 3), 7, B
		LINE (x - 8, y - 6)-(x + 8, y + 6), 0, B
		CASE 2
		LINE (x - 7, y - 5)-(x + 7, y + 5), 4, BF
		LINE (x - 8, y - 6)-(x + 8, y + 6), 0, B
		LINE (x - 7, y - 4)-(x + 6, y + 5), 9
		LINE (x - 7, y + 4)-(x + 6, y - 5), 9
		LINE (x - 7, y - 5)-(x + 7, y + 5), 9
		LINE (x - 7, y + 5)-(x + 7, y - 5), 9
		CASE ELSE
	END SELECT
END SUB

SUB bub2 (limit)
	DO
		swaps% = FALSE
		FOR i = 1 TO limit - 1
		IF brray(i) > brray(i + 1) THEN
			SWAP brray(i), brray(i + 1)
			swaps% = i
		END IF
		NEXT i
	LOOP WHILE swaps%
END SUB

SUB bubble (limit)
	DO
		swaps% = FALSE
		FOR i = 1 TO limit - 1
		IF mtx$(i) > mtx$(i + 1) THEN
			SWAP mtx$(i), mtx$(i + 1)
			SWAP array(i), array(i + 1)
			swaps% = i
		END IF
		NEXT i
	LOOP WHILE swaps%
END SUB

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

SUB cannon
	CALL clrrite
	LINE (528, 80)-(639, 310), 3, BF
	LINE (528, 310)-(639, 435), 2, BF
	LINE (528, 405)-(639, 420), 0, BF
	PSET (580, 380), 0

	DRAW "BR15"
	x = POINT(0): y = POINT(1): CIRCLE (x, y), 25, 1, , , 1.4
	CIRCLE (x + 5, y), 27, 1, 4, 1.5, 1.4
	CIRCLE (x, y), 29, 1, , , 1.4
	DRAW "BR20"
	x = POINT(0): y = POINT(1): PAINT (x, y), 3, 1
	DRAW "BR3BU7"
	x = POINT(0): y = POINT(1): PAINT (x, y), 5, 1
	DRAW "BL15C7G4L50H1L12H1L7H3U1H1U4E5R6E1R13E1R52F3D2R1E1R1F2D5G3H2G2BL2"
	DRAW "BH2C6"
	x = POINT(0): y = POINT(1): PAINT (x, y), 7
	DRAW "BD2R4C0G4L50H1L12H1L7H3U1H1U4E5R6E1R13E1R52F3D2R1E1R1F2D5G3H2G2BR5U3"
	DRAW "C8G2H2G6L15G1L32H1L1H1L19H3E2R2F1R6"
	DRAW "E2R4F1R6E1R58F1G2BL9BH2BU5BR3C15H1L48G1L13G1L4"
	DRAW "BD3BF3BR9"
	x = POINT(0): y = POINT(1): PAINT (x, y), 8
	DRAW "BR34BE1BR7BL5BD8C6R16F5D1F4D6F7R17D7L30H18L8H4L18H3U5R33BR17BD5"
	x = POINT(0): y = POINT(1): PAINT (x, y), 6
	DRAW "BU5C8F8D7F6R1F1R16D7E3U7G3E2BE2C8L16H6U8C8G3BE3C8H8G6BR5"
	x = POINT(0): y = POINT(1): PAINT (x, y), 8
	DRAW "BL38"
	x = POINT(0): y = POINT(1): CIRCLE (x, y), 30, 4, , , 1.4
	CIRCLE (x + 5, y), 35, 4, 4, 1.5, 1.4
	CIRCLE (x, y), 35, 4, , , 1.4
	CIRCLE (x, y), 8, 4, , , 1.4: PAINT (x, y), 1, 4: PAINT (x, y), 0, 4
	DRAW "BR23"
	x = POINT(0): y = POINT(1): PAINT (x, y), 1, 4: PAINT (x, y), 4, 4
	DRAW "BR5BU7"
	x = POINT(0): y = POINT(1): PAINT (x, y), 1, 4: PAINT (x, y), 0, 4
	DRAW "BU22BL28"
	DRAW "C4D20R1U19BD37C4D20L1U21BH2BL1BH1C4G12F1E11BU3BH2"
	DRAW "BU3BL1C4L13U1R15BR1BU3C4H12E1F11BF5BE4C4E11F1G11BD3C4R13D1L10D3BL3BD1C4"
	DRAW "F12G1H12BL33BH13BU3BH2BU1BE1BR2BU1BE1BR1"
	DRAW "BL5BU5C8E4U1"
	DRAW "H4E3H3U3E3H6L3G7F1H7E2U2E2H7L7G9D6F8G3L1H3L5G7D4F4R2D3F3R2G5D4L4G4D5F8D2"
	DRAW "R5F9E3F5R6E6H4E2F6R3E8F1E4H5U2H3U1H1U7E4H7BL5"
	x = POINT(0): y = POINT(1): PAINT (x, y), 8, 8
	DRAW "BR9BD6C15H8L1H2L12G1F5L8G4F4R3G3D1G2D3F2E5G1D8R4E3D6F3E12H1U1H1U6E5BH6BU4"
	DRAW "BD15"
	x = POINT(0): y = POINT(1): PAINT (x, y), 14, 15
END SUB

SUB capitol
	SCREEN 12
	CLS
	LINE (1, 1)-(639, 150), 4, BF
	LINE (1, 150)-(639, 300), 15, BF
	LINE (1, 300)-(639, 450), 1, BF
	x = 0
	LINE (150, 190)-(500, 254), 7, B
	LINE (270, 190)-(370, 254), 7, B
	LINE (270, 185)-(370, 175), 7, B
	LINE (280, 173)-(360, 168), 7, B
	LINE (270, 235)-(370, 254), 7, B
	CIRCLE (320, 150), 74, 7, .2, 2.95, 2.1
	LINE (285, 138)-(355, 168), 7, B
	lwing:
	PSET (180 + 120 * x, 200), 0

	DRAW "C7ER1E1R1E1R1E1R1E1R1E1R1E1R1E1R1E1R1E1R1E1R1F1R1F1R1F1"
	DRAW "R1F1R1F1R1F1R1F1R1F1R1F1R1F1R1F1R1F1L47D4R48U3D51L4U17L41D17L3U47"
	FOR i = 1 TO 7: DRAW "BR6R2D25L2U25": NEXT i
	DRAW "BD33R2"
	FOR i = 1 TO 5: DRAW "L40BR40D3": NEXT i
	x = x + 1: IF x < 3 GOTO lwing
	PSET (270, 190), 0
	FOR i = 1 TO 3: DRAW "C7BR6R2D45L2U45": NEXT i
	PSET (344, 190), 0
	FOR i = 1 TO 3: DRAW "C7BR6R2D45L2U45": NEXT i
	PSET (283, 140), 0
	FOR i = 1 TO 11: DRAW "C7BR6R2D25L2U25": NEXT i
	PSET (283, 120), 0
	FOR i = 1 TO 11: DRAW "C7BR6R2D15L2U15": NEXT i
	LINE (315, 55)-(325, 77), 7, B
	LINE (318, 57)-(322, 75), 7, B
	PSET (315, 53), 0
	DRAW "S3C7R13U6L13D5BU5C7U2E1U2E2U3H2U3H1E3U2H1U2E2U2E2F2D2F4D3R2E2F1G4L1D7F1D2F1D1G2"
	LINE (140, 270)-(510, 430), 14, BF
	COLOR 15
	IF noise = 2 THEN PLAY "T130MFMSO2f16f8.f16f8.e-16d8.f16b-8.o3c16d8.d16d8.c16o2b-4"
	LOCATE 20, 20: PRINT CHR$(34); "... and that the government of the people,"
	IF noise = 2 THEN PLAY "o2b-8.a16g8.g16g8.a16b-8.a16b-8.g16f8.g16f8.d16f4"
	LOCATE 21, 20: PRINT "by the people, for the people,"
	IF noise = 2 THEN PLAY "f8.f16f8.f16f8.e-16d8.f16b-8.o3c16d8.d16d8.c16o2b-4b-4MNo3c4c4o2b-4a4b-2"
	LOCATE 22, 20: PRINT "shall not perish from the earth."; CHR$(34)
	LOCATE 25, 40: PRINT "- Abraham Lincoln"
	FOR i = -565 TO 50 STEP 50: CALL flags(1, i, 0): NEXT i
	IF noise = 2 THEN PLAY "P2f4..e-16d8.f16b-8.o3c16d2o2b-2g4..a16b-8.a16b-8.g16f2d2": PLAY "f4..e-16d8.f16b-8.o3c16d2o2b-4b-4o3c4c4o2b-4a4b-2.."
END SUB

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

SUB center (y, a$)
	x = LEN(a$)
	x = 26 - x \ 2
	LOCATE y, 7 + x: PRINT a$
END SUB

SUB chessie
	COLOR 10
	LINE (500, 185)-(505, 180): LINE -(505, 175)
	LINE -(500, 170): LINE -(490, 165)
	LINE -(495, 160): LINE -(490, 155)
	LINE -(485, 150): LINE -(495, 155)
	LINE -(495, 145): LINE -(490, 140)
	LINE -(485, 130): LINE -(470, 120)
	LINE -(470, 110): LINE -(475, 120)
	LINE -(485, 120): LINE -(485, 115)
	LINE -(480, 100): LINE -(485, 90)
	LINE -(495, 80): LINE -(500, 80)
	LINE -(500, 85): LINE -(495, 90)
	LINE -(495, 100): LINE -(495, 115)
	LINE -(500, 120): LINE -(500, 130)
	LINE -(515, 135): LINE -(515, 140)
	LINE -(510, 160): LINE -(520, 145)
	LINE -(525, 120): LINE -(525, 115)
	LINE -(515, 85): LINE -(527, 95)
	PAINT (500, 400), 1, 10
	PAINT (510, 110), 2
END SUB

SUB clrbot
	LOCATE 29, 1: PRINT SPACE$(79);
	LOCATE 29, 1
END SUB

SUB clrrite
	VIEW (528, 1)-(639, 450)
	CLS 1
	VIEW
END SUB

SUB commander (who, empty)
	empty = 0
	CALL starfin(star, fin, who)
	FOR i = star TO fin
	IF armyloc(i) = 0 AND lname$(i) <> "" THEN empty = i: EXIT SUB
	NEXT i

	'                 generic leaders if set list is exhausted
	FOR i = star TO fin
	IF armyloc(i) = 0 THEN
		x = i
		CALL roman(x, a$)
		empty = i
		lname$(i) = a$
		rating(i) = 1 + 8 * RND
		EXIT SUB
	END IF
	NEXT i
	CALL clrbot: PRINT "No more "; force$(who); " commanders available"; : CALL TICK(turbo!)
END SUB

SUB endit
		a$ = STR$(ABS(vicflag(3)) * 2.5) + "% Cities"
		t$ = STR$(ABS(vicflag(3)) * 2.5) + "% Total Income"
		mtx$(8) = "Time: " + month$(vicflag(1)) + STR$(ABS(vicflag(2)))
		mtx$(9) = RTRIM$(STR$(ABS(vicflag(6)))) + ":1 Force Ratio"
		COLOR 15: LOCATE 1, 1: PRINT "Press ENTER to toggle ending conditions";
		COLOR 14: PRINT "				ESC when done"
	what4:
		FOR i = 2 TO 6: IF vicflag(i) > 0 THEN mtx$(i - 1) = "+ " ELSE mtx$(i - 1) = "  "
		NEXT i
		choose = chosit
		mtx$(0) = "Victory Conditions"
		mtx$(1) = mtx$(1) + mtx$(8)
		mtx$(2) = mtx$(2) + a$
		mtx$(3) = mtx$(3) + t$
		mtx$(4) = mtx$(4) + "Capital Captured"
		mtx$(5) = mtx$(5) + mtx$(9)
		mtx$(6) = "DONE"
		wtype = 2: colour = 3: size = 6: hilite = 14
		CALL menu(0)
		chosit = 21 + choose
	SELECT CASE choose
		CASE 1
		vicflag(2) = -vicflag(2)
		CASE 2 TO 5
		vicflag(choose + 1) = -vicflag(choose + 1)
		CASE ELSE
		GOTO cheer
	END SELECT
		GOTO what4
	cheer:
		CLS
		CALL usa
END SUB

SUB engine
	IF rr(1) + rr(2) = 0 GOTO notrain
	LINE (5, 17)-(100, 63), 3, BF
	LINE (5, 17)-(100, 47), 0, B
	LINE (5, 47)-(100, 63), 0, B

	FOR i = 1 TO 2
	IF rr(i) = 0 GOTO notrane
	PSET (15, 25), 3: c = 9: IF i = 2 THEN c = 15: PSET (60, 25), 3
	DRAW "C0S4R9D4R6U3R3D3R7U5H3U2R9D3G2D6F1D3F5L10D1G1L4H2L7G2L3H2L3U8L2U5BF4"
	x = POINT(0): y = POINT(1): PAINT (x, y), c, 0
	LOCATE 4, 6 * (i - 1) + 2: PRINT LEFT$(city$(armymove(rr(i))), 5)
	notrane:
	NEXT i

	notrain:
END SUB

SUB evaluate (index, x)
	from = armyloc(index)
	x = 200: IF aggress! > 1.5 THEN x = 80: IF aggress! > 2 THEN x = 20: IF aggress! > 3 THEN x = 5
	CALL void(from, defend): IF defend = 0 THEN x = 0
	IF bold > 1 THEN x = .5 * x

	best = armysize(index)

	FOR j = 1 TO 6: array(j) = -1
	a = matrix(from, j): IF a > 0 THEN IF occupied(a) > 0 THEN best = best - armysize(occupied(a)): y = 1
	NEXT j: best = .01 * best
	IF bold > 0 THEN best = best + 20 * bold

	CALL starfin(star, fin, 3 - side)

	FOR j = 1 TO 6
		y = -1: a = matrix(from, j): IF a = 0 THEN max = j - 1: GOTO alleval
		
		c = occupied(a)
		FOR k = star TO fin: IF armyloc(k) > 0 THEN IF armymove(k) = a AND c = 0 GOTO alle
		NEXT k
		
		y = best - x * fort(from) - cityv(from) + 30 * RND
		IF fort(from) > 0 THEN IF index = occupied(from) THEN y = y - 25: IF realism > 0 THEN y = y - 50
		IF a = capcity(side) THEN IF vicflag(5) > 0 THEN y = y + 200
		IF cityp(a) <> 3 - side THEN y = y + 5 * cityv(a) + 10 * fort(a)
		IF cityp(a) <> side GOTO ourn
		IF c = 0 THEN y = y + 10 * cityv(a): GOTO ourn
		x1 = 1: IF fort(a) = 1 THEN x1 = 2: IF fort(a) = 3 THEN x1 = 3

		IF armysize(c) > 0 THEN
			odds! = armysize(index) / (x1 * armysize(c))
			IF realism > 1 THEN odds! = .8 * odds!
		ELSE
			odds! = 5
		END IF

		IF armysize(index) < 15 THEN y = y - 300: odds! = .1
		IF bold < 3 AND armysize(index) < 40 AND odds! < .8 THEN y = 0
		IF realism > 0 THEN y = y - 15
		IF odds! < .5 THEN y = y - 200
		IF bold = 0 AND RND > .9 THEN y = y + 10 * (armylead(index) - armylead(c) + armyexper(index) - armylead(index))
		IF supply(index) < 1 THEN y = y - 100
		SELECT CASE odds! + .5 * bold
			CASE IS < .3
			y = -9999
			CASE IS < .5
			y = y - 300
			CASE IS <= .8
			y = y - 20
			CASE .8 TO 1.2
			y = y - 5
			CASE 1.2 TO 1.5
			y = y + 10
			CASE ELSE
			y = y + .5 * (armysize(index) - armysize(c)) + 50 * RND
		END SELECT
	ourn:
		IF cityp(a) = 3 - side AND c > 0 AND armymove(c) = 0 THEN y = y - armysize(c)
		IF side = 1 AND cityy(a) < cityy(from) THEN y = y + 2
		IF side = 2 AND cityy(a) > cityy(from) THEN y = y + 2

		FOR k = 1 TO 6: m = matrix(a, k): IF m = 0 GOTO tally3
		IF cityp(m) = 0 THEN y = y + 3 * cityv(m) + 4 * fort(m)
		IF cityp(m) = side THEN y = y + 3 * cityv(m) + 4 * fort(m)
		IF cityp(m) = side AND c > 0 THEN
			odds! = 5 - 4 * RND
			IF armysize(c) > 0 THEN odds! = armysize(index) / armysize(c) ELSE odds! = 5
			IF odds! < 1 THEN y = y - 2
		END IF
		IF cityp(m) = capcity(side) THEN y = y + 50
	tally3:
		NEXT k

		array(j) = y
	alle:
	NEXT j: max = 6
	alleval:
	x = 0: best = 0
	FOR j = 1 TO max
	IF array(j) < 0 GOTO allof
		IF array(j) > x THEN x = array(j): best = j
	allof:
	NEXT j
		IF defend > armysize(index) AND array(best) < 50 THEN best = 0
		x = best
END SUB

SUB events' Special Events
	IF realism > 0 AND year = 1862 AND month < 3 THEN
		COLOR 14: CALL clrbot
		PRINT "SPECIAL DEVELOPMENT : IRONCLAD ships now available";
		IF noise > 0 THEN FOR k = 1 TO 5: SOUND 140, 1: SOUND 37, 1: NEXT k
		DO WHILE INKEY$ = "": LOOP
		EXIT SUB
	END IF
	IF randbal = 0 THEN EXIT SUB
	plus = difficult: IF side = 1 THEN plus = 6 - difficult
	pct! = .005 * (year - 1860) * plus * plus: IF pct! > .9 THEN pct! = .9
	IF RND > pct! THEN EXIT SUB

	CALL clrbot: COLOR 14: PRINT "SPECIAL EVENT...";
	who = 1: IF RND > .1 * randbal THEN who = 2

	SELECT CASE who
		CASE 1 ' Good for South
		IF year = 1864 AND month = 1 THEN victory(2) = victory(2) + 50
		IF year = 1865 AND month = 1 THEN victory(2) = victory(2) + 100
		IF RND > .9 THEN GOSUB riot: EXIT SUB

		CALL clrbot
		IF RND > .2 OR navysize(2) > 9 GOTO mercen
		IF navysize(2) > 0 AND navyloc(2) <> 99 THEN empty = navyloc(2): GOTO float1
			empty = 0
			FOR i = 1 TO 40
			IF cityp(i) = 2 AND matrix(i, 7) = 99 AND navyloc(1) <> i THEN empty = i: EXIT FOR
			NEXT i
		IF empty = 0 GOTO mercen
	float1:
		CALL scribe("England has given ships to the South", 2)
		navysize(2) = navysize(2) + 2 * plus
		IF navysize(2) > 10 THEN navysize(2) = 10
		x = navysize(2) - LEN(fleet$(2))
		fleet$(2) = fleet$(2) + STRING$(x, "W")
		navyloc(2) = empty: CALL ships
		GOTO dull1
	mercen:
		IF RND > .1 OR control(2) < 30 GOTO money
		a$ = "French": IF RND > .5 THEN a$ = "British"
		CALL scribe(a$ + " mercenaries join " + armyname$(index) + "'s army", 2)
		armysize(index) = armysize(index) + 100 * plus
		armyexper(index) = 10: supply(index) = 10
		GOTO dull1
	money:
		IF RND > .3 OR control(2) < 12 GOTO cotton
			CALL scribe("The South has obtained a loan from Europe", 2)
			GOTO purse
	cotton:
		IF RND > .5 OR control(2) < 12 GOTO uprising
		CALL scribe("Cash from cotton sales fill the Rebel Treasury", 2)
	purse:
		cash(2) = cash(2) + 100 * plus
		GOTO dull1
	uprising:
		pct! = .9
		a$ = "Union troops diverted to fight Western Indian uprisings"
		IF RND > .5 THEN a$ = "Union 90-day enlistees return home"
		IF year = 1864 AND month > 5 THEN a$ = "20% of Union forces take furloughs to vote in 1864 elections": pct! = .8
		CALL scribe(a$, 2)
		FOR k = 1 TO 20
		armysize(k) = pct! * armysize(k)
		NEXT k
		GOTO dull1

	riot:
		IF realism = 0 THEN RETURN
		IF control(who) = 1 THEN EXIT SUB
		FOR k = 1 TO 99
		x = 1 + INT(40 * RND)
			IF cityo(x) <> who AND cityp(x) = who AND occupied(x) = 0 THEN
				CALL clrbot: COLOR 15
				PRINT " Riots have broken out in "; city$(x);
				cityp(x) = 0
				CALL showcity
				TICK turbo!
				CALL clrbot
				CALL image2(city$(x) + " is now NEUTRAL !", 4)
				TICK turbo!
				RETURN
			END IF
		NEXT k
		RETURN
		CASE 2 ' Good for Union
		IF RND > .1 OR navyloc(1) = 0 OR navysize(1) > 9 GOTO event2
		IF RND > .95 THEN GOSUB riot: EXIT SUB
		CALL scribe("Union shipworks have produced extra ships", 2)
		navysize(1) = navysize(1) + plus
		IF navysize(1) > 10 THEN navysize(1) = 10
		x = navysize(1) - LEN(fleet$(1))
		fleet$(1) = fleet$(1) + STRING$(x, "W")
		GOTO dull2
	event2:
		IF RND < .7 GOTO abe
		CALL scribe("Volunteer troops swell the Union ranks", 2)
		x = 0: FOR i = 1 TO 20: x = x + 1: IF x > 5 GOTO dull2
		IF armysize(i) > 0 AND RND > .5 THEN armysize(i) = armysize(i) * 1.1 + plus
		NEXT i: GOTO dull2
	abe:
		IF emancipate = 0 AND year > 1862 THEN

			emancipate = 1
			CALL scribe("Abraham Lincoln announces the Emancipation Proclamation", 2)
			victory(1) = victory(1) + 100: victory(2) = victory(2) - 100
			CALL usa
			GOTO dull2
		END IF
		IF year = 1864 AND month = 11 THEN
			CALL scribe("Lincoln has been reelected", 2)
			victory(2) = .5 * victory(2)
			GOTO dull2
		END IF
		IF RND > .5 THEN
			CALL scribe("Wealthy Unionists give generously to the Federal Cause", 2)
			cash(1) = cash(1) + 100 * plus
			GOTO dull2
		END IF
		IF RND > .5 AND year > 1861 THEN
			CALL scribe("Rebel deserters leave the battlefield to go home", 2)
			FOR i = 21 TO 40: armysize(i) = .92 * armysize(i): NEXT i: GOTO dull2
		END IF
		IF RND > .5 AND year > 1861 THEN
			CALL scribe("Union soldiers now have repeating rifles", 2)
			FOR i = 1 TO 20
				IF armyexper(i) < 9 THEN armyexper(i) = armyexper(i) + 2
			NEXT i
		END IF
			CALL scribe("Secretary of War Stanton predicts the end of the Rebellion", 2)
			victory(1) = victory(1) + 10: GOTO dull2
		CASE ELSE
	END SELECT

	dull2:
		IF noise = 2 THEN PLAY "MNMFL16o2T120dd.dd.co1b.o2do3g.ab.bb.ag"
		DO WHILE INKEY$ = "": LOOP: EXIT SUB
	dull1:
		IF noise = 2 THEN PLAY "MNMFT160o2L16geL8ccL16cdefL8ggge"
		DO WHILE INKEY$ = "": LOOP
END SUB

SUB flags (who, w, a)
	x = 585 + w: y = 200: IF w = 0 THEN y = 180
	IF a <> 0 THEN y = a
	SELECT CASE who
		CASE 1
		LINE (x - 17, y - 15)-(x + 17, y + 7), 4, BF
		FOR i = -13 TO 9 STEP 5
		LINE (x - 17, y + i)-(x + 17, y + i - 1), 7, B
		NEXT i
		LINE (x - 17, y - 15)-(x, y), 1, BF
		IF w = 0 THEN COLOR 9: LOCATE 10, 70: PRINT "U N I O N"
		FOR i = -16 TO -1 STEP 3
			FOR j = -14 TO -1 STEP 4: PSET (x + i, y + j), 7: NEXT j
		NEXT i
		CASE 2
		LINE (x - 17, y - 15)-(x + 17, y + 7), 4, BF
		LINE (x - 17, y - 13)-(x + 15, y + 7), 7
		LINE (x - 15, y - 15)-(x + 17, y + 5), 7

		LINE (x - 17, y + 7)-(x + 17, y - 15), 1
		LINE (x - 17, y + 6)-(x + 16, y - 15), 1
		LINE (x - 16, y + 7)-(x + 17, y - 14), 1
		LINE (x - 17, y + 5)-(x + 15, y - 15), 7
		LINE (x - 15, y + 7)-(x + 17, y - 13), 7

		LINE (x - 17, y - 15)-(x + 17, y + 7), 1
		LINE (x - 17, y - 14)-(x + 16, y + 7), 1
		LINE (x - 16, y - 15)-(x + 17, y + 6), 1
		LINE (x - 17, y - 15)-(x + 17, y + 7), 4, B

		IF w = 0 THEN COLOR 4: LOCATE 10, 70: PRINT "R E B E L"
		CASE ELSE
	END SELECT
END SUB

SUB image2 (a$, s)
	DIM g2(1 TO 8000)
	mtx$(1) = a$
	tlx = 32 - LEN(a$) \ 2
	tly = 10: size = 1
	CALL mxw(wide)
	IF wide > 59 THEN wide = 59: a$ = LEFT$(a$, 59)
	x = 8 * (tlx + wide)
	y = 16 * (tly + 1)
	GET (8 * tlx - 4, 16 * tly - 3)-(8 * (tlx + wide + 1) + 15, 16 * (tly + 3) + 7), g2
	VIEW (8 * tlx - 4, 16 * tly - 3)-(8 * (tlx + wide + 1) + 7, 16 * (tly + 3) + 4)
	CLS 1
	VIEW
	LINE (8 * tlx, 16 * tly - 1)-(8 * (tlx + wide + 1) + 15, 16 * (tly + 3) + 7), 0, BF
	LINE (8 * tlx - 4, 16 * tly - 3)-(8 * (tlx + wide + 1) + 7, 16 * (tly + 3)), s, BF
	LINE (8 * tlx - 4, 16 * tly - 3)-(8 * (tlx + wide + 1) + 7, 16 * (tly + 3)), 15, B
	COLOR 14
	LOCATE tly + 2, tlx + 2: PRINT a$
	CALL TICK(9)
	PUT (8 * tlx - 4, 16 * tly - 3), g2, PSET
END SUB

SUB integrity
	CLS : COLOR 15
	x = 0: y = 0
	FOR i = 1 TO 40
	FOR j = 1 TO 6: IF matrix(i, j) = 0 GOTO done
		index = matrix(i, j)
		FOR k = 1 TO 6
		IF matrix(index, k) = i GOTO ret
		IF matrix(index, k) = 0 THEN matrix(index, k) = i: PRINT "+ Adding return route from "; city$(index); " to "; city$(i): y = y + 1: GOTO ret
		NEXT k
		x = x + 1: PRINT "Error in CITIES.GRD entry for city #"; i; city$(index); ": no return route to "; city$(i): TICK 1
	ret:
	NEXT j
	done:
	NEXT i
	IF x + y = 0 THEN PRINT "ALL MAP LINKS ARE OK": EXIT SUB
	IF y > 0 THEN PRINT "* "; y; " fixes made to provide RETURN ROUTES"
	IF x > 0 THEN PRINT "** "; x; " UNRESOLVED RETURN ROUTES"
END SUB

SUB maptext
	FOR k = 1 TO 40
		FOR j = 1 TO LEN(city$(k))
		a = cityx(k) + 6 * (j - 4) - 3
		x = ASC(MID$(UCASE$(city$(k)), j, 1)) - 64
		IF a > 527 GOTO nextc
		PSET (a, cityy(k) + 12), 10
		
		IF matrix(k, 7) < 90 THEN
			IF bw = 0 THEN DRAW "S4C0" ELSE DRAW "S4C7"
		ELSE
			DRAW "C10"
		END IF
		IF x > 0 AND x < 27 THEN DRAW font$(x)
		NEXT j
	nextc:
	NEXT k
END SUB

SUB maxx ' Leader Board Screen.
	COLOR 14: LOCATE 28, 1: PRINT "press a key"; : DO WHILE INKEY$ = "": LOOP
	SCREEN 0: COLOR 14, 5: CLS : COLOR 11, 0

	LOCATE 2, 7: PRINT STRING$(57, "|")
	LOCATE 9, 7: PRINT STRING$(57, "|")
	FOR i = 1 TO 6
		LOCATE 2 + i, 7: PRINT "|"; SPACE$(55); "|"
	NEXT i

	OPEN "I", 1, cwsdatapath$ + "\hiscore.cws"
	FOR s = 1 TO 2
		COLOR 14, 4: LOCATE 3, 30 * (s - 1) + 10: PRINT force$(s); " HALL of FAME"
		COLOR 15, 0
		FOR i = 1 TO 5
			INPUT #1, city$(5 * (s - 1) + i), matrix(s, i)
			LOCATE 3 + i, 30 * (s - 1) + 8: PRINT i, city$(5 * (s - 1) + i), matrix(s, i)
		NEXT i
	NEXT s
	CLOSE #1
		      
	FOR s = 1 TO 2
		FOR i = 1 TO 5
			IF victory(s) < matrix(s, i) then
			ELSE
				FOR j = 5 TO i + 1 STEP -1
					matrix(s, j) = matrix(s, j - 1)
					city$(5 * (s - 1) + j) = city$(5 * (s - 1) + j - 1)
				NEXT j

				COLOR 15, 1
				IF s = 2 THEN COLOR 4, 7
				FOR k = 12 TO 14
					LOCATE k, 1: PRINT SPACE$(80);
				NEXT k
				LOCATE 12, 1: PRINT "Congratulations ! Score of"; victory(s)
				PRINT "New Entry into "; force$(s); " HALL of FAME in place "; i
				IF player = 1 AND s <> side THEN a$ = "COMPUTER": PRINT a$; " was "; force$(s); " commander": GOTO automate
				PRINT "What is name of "; force$(s); " commander"; : INPUT a$
				automate:
				city$(5 * (s - 1) + i) = a$
				matrix(s, i) = victory(s): GOTO foun
		END IF
		NEXT i
	foun:
	NEXT s
	       
	OPEN "O", 1, cwsdatapath$ + "\hiscore.cws"
	FOR s = 1 TO 2
		FOR i = 1 TO 5
			WRITE #1, city$(5 * (s - 1) + i), matrix(s, i)
		NEXT i
	NEXT s
	CLOSE #1: PRINT "Game Over": DO WHILE INKEY$ = "": LOOP: pcode = 1
END SUB

SUB occupy (x)
	occupied(x) = 0
	FOR i = 1 TO 40
	IF armyloc(i) = x THEN occupied(x) = i: GOTO holdup
	NEXT i
	holdup:
END SUB

SUB relieve (who)
	colour = 3: target = 0: hilite = 3
	tlx = 67: tly = 2
	CALL starfin(star, fin, who)
	size = 0
	FOR i = star TO fin
	IF armysize(i) > 0 AND armyloc(i) > 0 AND armymove(i) = 0 THEN
		size = size + 1
		mtx$(size) = armyname$(i)
		IF LEN(mtx$(size)) > 11 THEN mtx$(size) = LEFT$(mtx$(size), 11)
		array(size) = i
	END IF
	NEXT i

	IF size = 0 THEN EXIT SUB
	CALL bubble(size)
	mtx$(0) = "Relieve"
	choose = 31: hilite = 11
	CALL menu(6): CALL clrrite

	IF choose < 1 THEN EXIT SUB
	index = array(choose)
	CALL icon(armyloc(index), 0, 9)

	t$ = armyname$(index)
	lname$(index) = t$

	size = 0
	FOR i = star TO fin
	IF lname$(i) <> "" THEN
		size = size + 1
		mtx$(size) = lname$(i)
		IF LEN(mtx$(size)) > 11 THEN mtx$(size) = LEFT$(mtx$(size), 11)
		array(size) = i
	END IF
	NEXT i
	CALL bubble(size)

	have2:
	mtx$(0) = "New Leader"
	tlx = 67: tly = 2
	CALL menu(0): CALL clrrite
	IF choose < 1 GOTO have2
	armymove(index) = -1
	armylead(index) = rating(array(choose))
	IF armylead(index) > 0 THEN armylead(index) = armylead(index) - 1
	IF armyexper(index) > 0 THEN armyexper(index) = armyexper(index) - 1
	COLOR 15: CALL clrbot: PRINT lname$(array(choose)); " has replaced "; t$; " in "; city$(armyloc(index)); : TICK 9
	armyname$(index) = lname$(array(choose))
	lname$(array(choose)) = ""
	CALL icon(armyloc(index), 0, 8)
	CALL clrbot
END SUB

SUB report (who)
	DIM summ(40)
	IF who = -1 GOTO frep
	IF who > 100 GOTO batrep
	mtx$(0) = "Information"
	mtx$(1) = force$(side) + " Armies"
	mtx$(2) = force$(3 - side) + " Armies"
	mtx$(3) = "Cities"
	mtx$(4) = "Force Summary"
	mtx$(5) = "Intelligence"
	mtx$(6) = "Battles": size = 6
	IF _FILEEXISTS("cws.his") THEN mtx$(7) = "Recap": size = 7
	CALL menu(0)
	SELECT CASE choose
	CASE IS < 0
		CLS
		CALL usa
		EXIT SUB
	CASE 2: who = 3 - side
	CASE 3: GOTO cityrep
	CASE 4: GOTO frep
	CASE 5: GOTO srep
	CASE 6: GOTO batrep
	CASE 7: GOTO recap
	CASE ELSE
	END SELECT

	'                               Army Report
	IF choose < 0 GOTO endrep
	IF choose = 4 GOTO frep
	CALL starfin(star, fin, who)
	CLS : LOCATE 1, 1: c = 9: IF who = 2 THEN c = 15
	COLOR c
	PRINT " Report for "; force$(who); " Forces"; TAB(30); month$(month); ","; year; TAB(49); : COLOR 14: PRINT " Victory Points "; victory(who);
	IF c = 15 THEN c = 7
	x = victory(who) + victory(3 - who)
	IF x = 0 THEN
		PRINT
	ELSE
		y = (victory(who) / x) * 100
		PRINT "("; y; " %)";
	END IF
	CALL armyxy(215, 8, who)
	COLOR c: PRINT control(who); "/ 40"; TAB(15); "CITIES CONTROLLED"; TAB(40); : PRINT "("; : x = INT(control(who) * 2.5 + .5): PRINT x; "%)";
	PRINT TAB(50); : COLOR 12: PRINT "Capital: "; city$(capcity(who))
	y = vptotal: IF capcity(1) > 0 THEN y = y + 100
	IF capcity(2) > 0 THEN y = y + 100
	PRINT income(who); "/"; y; TAB(15); "INCOME"; TAB(40); "("; : x = (income(who) / vptotal) * 100: PRINT x; "%)   "; : COLOR 14: PRINT "Cash:"; cash(who)
	COLOR 11: PRINT " #      Name             Size  Location   Ldr Exp Suply Move To"
	x = 0: FOR i = star TO fin
	COLOR c
	IF armyloc(i) < 1 GOTO deadeye
	x = x + armysize(i)
	PRINT i; TAB(5); armyname$(i); TAB(25); : y = CSRLIN
	CALL strong(i): PRINT TAB(32); city$(armyloc(i));
	IF who <> side THEN PRINT : GOTO deadeye
	PRINT TAB(43); armylead(i); TAB(47); armyexper(i); TAB(52); supply(i);
	PRINT TAB(57); : IF armymove(i) > -1 THEN PRINT city$(armymove(i)) ELSE PRINT "Resting"
	IF fort(armyloc(i)) > 0 THEN LOCATE y, 68: PRINT "FORT +"; fort(armyloc(i))
	deadeye:
	NEXT i
	PRINT " "; STRING$(70, "-")
	PRINT " Total Forces "; TAB(25); LTRIM$(STR$(x)); "00"; TAB(40); "[ Enemy Forces "; LTRIM$(STR$(INT(aggress! * x))); "00 ]"
	PRINT " "; STRING$(70, "-")
	PRINT " "; force$(who); " NAVY has "; navysize(who); " ship(s) ";
	x = 0
	FOR k = 1 TO navysize(who)
		IF MID$(fleet$(who), k, 1) = "I" THEN x = x + 1
	NEXT k
	IF x > 0 THEN PRINT "("; x; "Ironclads) ";
	IF navyloc(who) > 0 AND navyloc(who) < 99 THEN PRINT "in "; city$(navyloc(who)) ELSE PRINT
	IF rr(who) > 0 THEN COLOR 14: PRINT " Army #"; rr(who); armyname$(rr(who)); " on train to "; city$(armymove(rr(who)));
	LINE (0, 0)-(639, 449), 15, B
	LINE (0, 62)-(639, 62), 15
	GOTO endrep

	cityrep: ' City Report
	CLS : LOCATE 1, 1: COLOR 14
	PRINT "City Report"; TAB(20); month$(month); ","; year: COLOR 15
	PRINT " #    City       Control   Value"; TAB(41); " #    City       Control   Value"
	LINE (1, 30)-(630, 30), 15
	FOR i = 1 TO 20: COLOR 4: a$ = "neutral": IF cityp(i) = 1 THEN COLOR 9: a$ = "UNION"
	IF cityp(i) = 2 THEN COLOR 7: a$ = "REBEL"
	LOCATE 2 + i, 1: PRINT i; TAB(6); city$(i); TAB(18); a$; TAB(29); cityv(i)
	NEXT i

	FOR i = 21 TO 40: COLOR 4: a$ = "neutral": IF cityp(i) = 1 THEN COLOR 9: a$ = "UNION"
	IF cityp(i) = 2 THEN COLOR 7: a$ = "REBEL"
	LOCATE i - 18, 41: PRINT i; TAB(46); city$(i); TAB(58); a$; TAB(69); cityv(i)
	NEXT i
	LINE (1, 360)-(630, 360), 15
	COLOR 9: LOCATE 24, 1: PRINT "Side    No. Cities   Income    Cash"
	COLOR 9: PRINT force$(1); TAB(12); control(1); TAB(23); income(1); TAB(32); cash(1)
	COLOR 7: PRINT force$(2); TAB(12); control(2); TAB(23); income(2); TAB(32); cash(2)
	COLOR 4: PRINT force$(0); TAB(12); 40 - control(1) - control(2)
	LINE (1, 382)-(630, 382), 15
	GOTO endrep

	srep:' Intelligence
	c = 9: IF side = 2 THEN c = 7
	CALL usa
	CALL starfin(star, fin, side)
	FOR k = star TO fin
		IF armysize(k) > 0 THEN
		COLOR c
		x = cityx(armyloc(k))
		y = cityy(armyloc(k))
		z = 10: IF armysize(k) < 1000 THEN z = 9
		x = x / 8 - 2: y = y / 16
		IF y > 26 THEN y = 26
		FOR j = 0 TO 3
		LOCATE y + j, x: PRINT SPACE$(z);
		NEXT j
		LOCATE y, x: PRINT "Siz:"; : CALL strong(k)
		LOCATE y + 1, x: PRINT "Ldr:"; armylead(k)
		LOCATE y + 2, x: PRINT "Xpr:"; armyexper(k)
		LOCATE y + 3, x: PRINT "Sup:"; supply(k);
		LINE (8 * (x - 1) - 1, 16 * (y - 1) - 1)-(8 * (x + z - 1) + 1, 16 * (y + 3) + 1), 15, B
		TICK 1
	END IF
	NEXT k
	GOTO endrep

	frep: ' Force Summary
	FOR k = 1 TO 40
		IF occupied(k) > 0 THEN
			FOR j = 1 TO 40
			IF armyloc(j) = k THEN summ(k) = summ(k) + armysize(j)
			NEXT j
		END IF
	NEXT k

	CLS : CALL usa
	FOR k = 1 TO 40
	IF summ(k) > 0 THEN
		c = 9: IF cityp(k) = 2 THEN c = 7
		COLOR c
		LOCATE INT(cityy(k) / 16 + 1), cityx(k) / 8: PRINT summ(k)
	END IF
	NEXT k
	COLOR 14: LOCATE 1, 20: PRINT "Total Forces in Cities (100's)"
	GOTO endrep

	batrep: ' Battle Report
	VIEW (200, 123)-(400, 284)
	CLS 1
	VIEW
	LINE (200, 123)-(400, 284), 15, B
	COLOR 14
	LOCATE 9, 32: PRINT "BATTLE SUMMARY"
	CALL armyxy(320, 160, 1)
	CALL armyxy(370, 160, 2)
	LINE (200, 176)-(400, 230), 15, B
	LINE (200, 230)-(400, 284), 15, B
	LINE (290, 176)-(345, 284), 15, B
	LOCATE 13, 27: PRINT "BATTLES"
	LOCATE 14, 27: PRINT "WON"
	LOCATE 16, 27: PRINT "MEN LOST"
	LOCATE 17, 27: PRINT "(1000's)"
	LOCATE 14, 38: PRINT batwon(1)
	LOCATE 14, 45: PRINT batwon(2)
	LOCATE 17, 38: PRINT INT(.1 * casualty&(1))
	LOCATE 17, 45: PRINT INT(.1 * casualty&(2))
	IF history > 0 AND who > 2 THEN
		OPEN "O", #1, cwsdatapath$ + "\battsumm"
		PRINT #1, " SIDE      BATTLES WON       LOSSES"
		FOR k = 1 TO 2
		a$ = " ": IF thrill = k THEN a$ = "*"
		PRINT #1, a$; force$(k), batwon(k), 100 * casualty&(k)
		NEXT k
		CLOSE #1
	END IF
	GOTO endrep

	recap: ' Recap History
	CLS : x = 0
	OPEN "I", 2, cwsdatapath$ + "\cws.his"
	DO WHILE NOT EOF(2)
	INPUT #2, a$
	COLOR 7: IF INSTR(a$, "[") THEN COLOR 15
	IF INSTR(a$, ">") THEN COLOR 14
	IF INSTR(a$, "..") THEN COLOR 11
	IF INSTR(a$, "!") THEN COLOR 12
	LOCATE 29, 1: PRINT a$
	x = x + 1
	IF x > 27 THEN TICK .4
	LOOP
	CLOSE #2

	endrep:
	COLOR 14: LOCATE 29, 29: PRINT "press a key";
	DO WHILE INKEY$ = "": LOOP
	IF who < 3 THEN
		CLS
		CALL usa
	END IF
END SUB

SUB resupply (index)
		who = 1: IF index > 20 THEN who = 2
		IF realism > 0 THEN
			CALL cutoff(who, armyloc(index), a)
			IF a < 1 THEN EXIT SUB
		END IF
		IF armysize(index) > 0 THEN x = cash(who) / armysize(index) * 10
		y = x + supply(index): IF y > 5 THEN x = 5 - supply(index)
		IF x < 1 THEN CALL clrbot: PRINT "Not enough funds in the Treasury to supply "; armyname$(index); : GOTO nocash
		supply(index) = supply(index) + x: cash(who) = cash(who) - .1 * x * armysize(index)
		CALL clrbot: PRINT armyname$(index); " has received supplies "; : IF noise > 0 THEN SOUND 4500, .5
	nocash:
		CALL TICK(turbo!): IF cash(who) < 0 THEN cash(who) = 0
END SUB

SUB retreat (defend, x)
	x = 0
	IF player = 1 THEN
		IF (side = 1 AND defend > 20) OR (side = 2 AND defend < 21) THEN EXIT SUB
	END IF

	hilite = 13: colour = 3: tlx = 67: tly = 5: size = 0
	y = armyloc(defend)
	who = 1: IF defend > 20 THEN who = 2
	FOR k = 1 TO 6
		IF matrix(y, k) > 0 AND cityp(matrix(y, k)) = who THEN size = size + 1: mtx$(size) = city$(matrix(y, k)): array(size) = matrix(y, k)
	NEXT k
		IF size = 0 THEN EXIT SUB
		IF size = 1 THEN x = array(1): EXIT SUB
		mtx$(0) = "Retreat"
		CALL bubble(size)
		CALL menu(9)
		CALL clrrite
		IF choose < 0 OR choose > size THEN x = 0: EXIT SUB
		x = array(choose)
END SUB

SUB roman (target, a$)
	a$ = "Union ": IF target > 20 THEN a$ = "Rebel "
	IF target > 20 THEN target = target - 20
	IF target > 10 THEN a$ = a$ + "X": target = target - 10
	SELECT CASE target
		CASE IS < 4
		x = target: GOSUB add1s
		CASE 4
		a$ = a$ + "IV"
		CASE 5 TO 8
		a$ = a$ + "V"
		x = target - 5
		GOSUB add1s
		CASE 9
		a$ = a$ + "IX"
		CASE 10
		a$ = a$ + "X"
	END SELECT
	EXIT SUB

	add1s:
	IF x > 0 THEN FOR k = 1 TO x: a$ = a$ + "I": NEXT k
	RETURN
END SUB

SUB rwin
	LINE (2, 2)-(637, 239), 4, BF
	COLOR 15: LINE (2, 40)-(597, 239): LINE -(637, 239): LINE -(637, 199): LINE -(40, 2): LINE -(2, 2): LINE -(2, 40)
	COLOR 15: LINE (2, 199)-(2, 239): LINE -(40, 239): LINE -(637, 40): LINE -(637, 2): LINE -(597, 2): LINE -(2, 199)
	LINE (242, 95)-(395, 145), 4, BF
	PAINT (4, 20), 1, 15

	LINE (2, 239)-(637, 438), 2, BF
	GOSUB stars

	'                               landscape
	PSET (1, 240)
	DRAW "s14BR68C0E6U1E3R2E4R10F2R7F2R5E3R12F7R4F2E3R5E3R9F4"
	DRAW "C0R6F2R5F1R3F3L44F2L42E1H1L29E2R1BH5BL3BR5"
	PAINT (300, 230), 5, 0
	PSET (2, 330)
	DRAW "C0D18U1R32E4R26E2R27E5R20E2R1E2U1E2U2E4H4L5H2L9H1L5H3L4H2L5H1L3H2L12H4"
	DRAW "C0D1F4R5F2R3F2R4F5R5F3L13G1L8G2L24G1L30G1L18D21"
	DRAW "BE5": x = POINT(0): y = POINT(1) + 5: PAINT (x, y), 9, 0
	DRAW "BU12C11R21F1R2BR2BD6C11R9E1R9E1R6BH7C11R9E1R9BF5C11R9E1R1E1R10"
	LINE (1, 1)-(638, 440), 14, B
	LINE (2, 2)-(637, 439), 14, B

	'                               mansion
	x = 100: y = 240
	CIRCLE (x + 50, y + 40), 80, 0, , , .2
	PAINT (x + 50, y + 40), 6, 0
	LINE (x + 95, y - 14)-(x + 102, y + 8), 8, BF
	LINE (x + 100, y - 14)-(x + 102, y + 8), 7, BF
	LINE (x, y)-(x + 100, y + 36), 7, BF
	FOR i = 1 TO 6: LINE (x + 17 * i, y + 6)-(x + 17 * i + 4, y + 32), 0, BF: NEXT i
	LINE (x + 12, y + 18)-(x + 98, y + 22), 7, BF
	LINE (x + 50, y + 20)-(x + 57, y + 36), 8, BF
	LINE (x + 100, y + 36)-(x + 105, y + 39), 7
	LINE -(x + 5, y + 39), 7: LINE -(x, y + 38), 7

	LINE (x, y)-(x - 7, y - 7), 8: LINE -(x - 14, y + 5), 8
	LINE -(x - 14, y + 33), 8: LINE -(x, y + 36), 8: LINE -(x, y), 8
	COLOR 10: LINE (x - 5, y - 7)-(x + 95, y - 7): LINE -(x + 107, y + 7)
	LINE -(x + 7, y + 7): LINE -(x - 5, y - 7)
	PAINT (x, y - 3), 10
	PAINT (x - 5, y + 15), 8

	FOR i = 1 TO 6: LINE (x + 19 * i - 12, y + 7)-(x + 19 * i - 12 + 2, y + 40), 15, BF: NEXT i

	IF noise < 2 GOTO relee
	PLAY "MBMS T120"
	PLAY "O3 L16 g e L8 c c L16 c d e f L8 g g g e a a a. L16 g a8. g a b"
	PLAY "O4 L16 c d e4. c O3 g O4 c4. O3 g e g4. d e c4 P8"
	PLAY "L16 g e L8 c c L16 c d e f L8 g g g e a a a. L16 g a8. g a b"
	PLAY "O4 L16 c d e4. c O3 g O4 c4. O3 g e g4. d e c4."
	PLAY "L16 T150 g a b T120 O4 L8 c e d. c16 O3 a O4 c4 O3 a O4 d4."
	PLAY "O3 a O4 d4. O3 T150 L16 g a b T120 L8 O4 c e d. c16"
	PLAY "L8 O3 a b O4 c. O3 a16 g e O4 c. O3 e16 e d4 e c4. e d4. a"
	PLAY "L8 g e O4 c. e16 d c4 O3 e c4. e d4. a g e O4 e4. c16 d c4"

	GOTO relee

	stars:
	FOR i = 1 TO 8
	x = starx(i): y = stary(i)
	PSET (x, y), 0
	LINE (x + 2, y - 1)-(x + 8, y + 16), 15
	LINE -(x - 6, y + 2): LINE -(x - 20, y + 16)
	LINE -(x - 14, y - 1): LINE -(x - 30, y - 9)
	LINE -(x - 12, y - 9): LINE -(x - 6, y - 25)
	LINE -(x, y - 9): LINE -(x + 16, y - 9)
	LINE -(x + 2, y - 1): PAINT (x, y), 15
	NEXT i
	RETURN
	relee:
END SUB

SUB scribe (a$, flag)
	SELECT CASE flag
			CASE 1: CALL clrbot: PRINT a$;
			CASE 2: CALL image2(a$, 4)
	END SELECT
	IF history > 0 THEN
		OPEN "A", 2, cwsdatapath$ + "\cws.his"
		a$ = LTRIM$(RTRIM$(a$))
		PRINT #2, a$
		CLOSE #2
	END IF
END SUB

SUB shen
	'                       Shenandoah
	IF noise = 2 THEN
		IF INKEY$ <> "" THEN choose = 1: EXIT SUB
		PLAY "T90MFMNo1c4f8f8f4."
		IF INKEY$ <> "" THEN choose = 1: EXIT SUB
		PLAY "g8a8b-8o2d8c4."
		IF INKEY$ <> "" THEN choose = 1: EXIT SUB
		PLAY "MLf8e8MNd4.c8d8c8o1a8o2c4.c4d8d8d4."
		IF INKEY$ <> "" THEN choose = 1: EXIT SUB
		PLAY "o1a8o2c8o1a8g8f4.g4a4.f8"
		IF INKEY$ <> "" THEN choose = 1: EXIT SUB
		PLAY "a8o2d8c4.o1f8g8a4.f8g4f2."
	END IF
END SUB

SUB shipicon (who, flag)
		x = POINT(0) - 10: y = POINT(1) - 10
		CIRCLE (x, y), 18, 9, , , .4
		PAINT (x + 3, y + 4), 9, 9
		CIRCLE (x, y), 18, 10, , , .4
	SELECT CASE flag
	CASE 1                          'wooden ship
		DRAW "BF5R5D1C4L20C0H1R22E1L9": DRAW "BL6": DRAW "C0L10H1L1H2": DRAW "BR9D2"
		DRAW "C0U9": DRAW "BR13": DRAW "C0D9BU7R3"
		DRAW "C0L7BL5C0L7BD3BL2BD1BL1BD1C0R11BR3": DRAW "C0R10BL12"
		PSET (x + 8, y - 1)
		GOSUB jack

	CASE 2                          'ironclad
		DRAW "BL15BD4E1"
		DRAW "C0R30H1L2C8L24E1R1"
		DRAW "C8E1R18F1L19BR4C6C5C4C3C2C1": DRAW "C0R2BR3C0R2BR3C0R2"
		DRAW "BU3BL10D1": DRAW "C0U4R1D4BR9"
		PSET (x + 8, y - 1)
		GOSUB jack
	CASE ELSE
	END SELECT
	EXIT SUB
	jack:
		SELECT CASE who
		CASE 1
		DRAW "C4R7BU1C7L6BU1C1R3C4R3BU1C7L2BL1C1L3"
		CASE 2
		DRAW "C4R4U1L4U1R4U1L4C3F4BU4C3G4BD2BR2BU1"
		END SELECT
		RETURN
END SUB

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

SUB starfin (star, fin, who)
	star = 1: fin = 20: IF who = 2 THEN star = 21: fin = 40
END SUB

SUB stax (who)
	CALL starfin(star, fin, who)
	FOR i = star TO fin
	IF armysize(i) > 0 AND occupied(armyloc(i)) <> i THEN
		target = armyloc(i)
		x = cityx(target) - 12: y = cityy(target) - 12
		CIRCLE (x, y), 3, 14
	END IF
	NEXT i
END SUB

SUB surrender (who)
	SCREEN 12
	s = 1: c = 1: COLOR 0: w = 514
	IF who > 20 THEN c = 7: s = 2
	'               background
	LINE (w + 15, 440)-(w + 125, 16), 2, BF
	LINE (w + 15, 16)-(w + 125, 290), 3, BF
	LINE (w + 14, 16)-(w + 125, 440), c, B
	x = 77: y = 280
	CIRCLE (w + x + 10, y + 30), 30, 4, , , .1
	PAINT (w + x + 10, y + 30), 6, 4
	LINE (w + x, y + 28)-(w + x + 6, y + 28): LINE -(w + x + 6, y + 8)
	LINE -(w + x + 8, y + 8): LINE -(w + x + 8, y + 28)
	LINE -(w + x + 12, y + 28): LINE -(w + x + 12, y + 12)
	LINE -(w + x + 15, y + 12): LINE -(w + x + 15, y + 30)
	LINE -(w + x + 18, y + 30): LINE -(w + x + 18, y + 20)
	LINE -(w + x + 21, y + 21): LINE -(w + x + 21, y + 32)
	LINE -(w + x + 25, y + 32): LINE -(w + x + 25, y + 17)
	LINE -(w + x + 27, y + 17): LINE -(w + x + 25, y - 10)
	LINE -(w + x + 19, y - 14): LINE -(w + x + 15, y - 5)
	LINE -(w + x + 12, y - 12): LINE -(w + x + 8, y - 15)
	LINE -(w + x + 6, y - 15): LINE -(w + x + 6, y - 11)
	LINE -(w + x + 3, y - 14): LINE -(w + x + 2, y - 14)
	LINE -(w + x + 1, y - 10): LINE -(w + x - 3, y - 11)
	LINE -(w + x - 3, y + 15): LINE -(w + x, y + 15)
	LINE -(w + x, y - 3): LINE -(w + x + 2, y - 3)
	LINE -(w + x, y + 28)
	PAINT (w + x + 10, y), 8 - c, 0

	CIRCLE (w + x + 7, y - 10), 3, 0: PAINT (w + x + 7, y - 10), 0, 0
	CIRCLE (w + x + 20, y - 8), 3, 0: PAINT (w + x + 20, y - 8), 0, 0

	LINE (w + x + 5, y - 30)-(w + x + 6, y - 9)
	LINE (w + x + 20, y)-(w + x + 35, y + 30)
	LINE (w + x + 20, y + 1)-(w + x + 35, y + 31)
	LINE (w + x + 22, y - 31)-(w + x + 21, y - 8)
	LINE (w + x - 1, y - 28)-(w + x, y - 8)
	'                       boot
	CIRCLE (w + 37, 425), 22, 8, , , .3
	PAINT (w + 37, 430), 8, 8
	LINE (w + 26, 426)-(w + 46, 426)
	LINE -(w + 46, 423): LINE -(w + 36, 419)
	LINE -(w + 36, 397): LINE -(w + 26, 397)
	LINE -(w + 26, 426)
	PAINT (w + 27, 399), 0, 0
	'                       arm
	LINE (w + 26, 397)-(w + 25, 396): LINE -(w + 24, 374)
	LINE -(w + 25, 346): LINE (w + 25, 346)-(w + 22, 341)
	LINE -(w + 46, 341): LINE -(w + 46, 349)
	LINE -(w + 41, 365): LINE -(w + 41, 380)
	LINE -(w + 36, 398)
	PAINT (w + 30, 350), c, 0
	'                       saber
	LINE (w + 55, 288)-(w + 58, 360), 14, BF
	LINE (w + 55, 288)-(w + 55, 360), 14
	LINE (w + 56, 361)-(w + 55, 360), 14
	LINE (w + 57, 361)-(w + 58, 350), 14
	LINE (w + 58, 350)-(w + 58, 288), 14
	LINE (w + 55, 272)-(w + 62, 288), 6, B
	LINE (w + 56, 273)-(w + 61, 287), 6, B
	LINE (w + 57, 274)-(w + 60, 286), 6, B
			
	LINE (w + 54, 295)-(w + 60, 305), 12, BF
	LINE (w + 53, 294)-(w + 61, 306), 0, B
	LINE (w + 57, 303)-(w + 61, 303)
	LINE (w + 57, 298)-(w + 61, 298)
	LINE (w + 34, 310)-(w + 46, 312), c, BF
	LINE (w + 25, 380)-(w + 35, 378)
	LINE (w + 25, 365)-(w + 34, 366)
	'                       shoulder
	COLOR 0
	LINE (w + 53, 297)-(w + 31, 305): LINE -(w + 25, 270)
	LINE -(w + 18, 270): LINE -(w + 16, 275)
	LINE -(w + 21, 309): LINE -(w + 28, 316)
	LINE -(w + 52, 306): LINE -(w + 53, 298)
	PAINT (w + 20, 280), c, 0
	LINE (w + 30, 310)-(w + 32, 305): LINE -(w + 25, 307)
	LINE (w + 46, 298)-(w + 47, 275)
	LINE (w + 47, 275)-(w + 41, 269)
	LINE (w + 41, 269)-(w + 25, 269)
	PAINT (w + 45, 275), c, 0
	CIRCLE (w + 40, 275), 1, 14
	CIRCLE (w + 40, 285), 1, 14
	CIRCLE (w + 40, 295), 1, 14

	LINE (w + 21, 306)-(w + 18, 340)
	LINE (w + 18, 340)-(w + 47, 340)
	LINE (w + 46, 310)-(w + 48, 339)
	PAINT (w + 30, 330), c, 0
	LINE (w + 46, 312)-(w + 21, 316), 0, BF
	LINE (w + 25, 312)-(w + 35, 313), c, BF

	LINE (w + 30, 268)-(w + 41, 264), 12, BF
	LINE (w + 30, 263)-(w + 41, 263), 0
	LINE (w + 30, 264)-(w + 26, 260): LINE -(w + 25, 248)
	LINE -(w + 28, 243): LINE -(w + 46, 243)
	LINE -(w + 48, 245): LINE -(w + 48, 248)
	LINE -(w + 51, 254): LINE -(w + 51, 255)
	LINE -(w + 48, 256): LINE -(w + 48, 261)
	LINE -(w + 46, 263): LINE -(w + 39, 263)
	PAINT (w + 40, 250), 12, 0

	LINE (w + 16, 242)-(w + 57, 241), 0, BF
	LINE (w + 45, 240)-(w + 28, 240)
	LINE -(w + 31, 232): LINE -(w + 45, 232)
	LINE -(w + 48, 240)
	PAINT (w + 40, 235), c, 0

	LINE (w + 80, 303)-(w + 81, 200), 6, BF

	LINE (w + 48, 251)-(w + 44, 250), 0, B
	LINE (w + 29, 263)-(w + 43, 266)
	LINE -(w + 46, 266): LINE -(w + 48, 263)
	LINE -(w + 48, 260): LINE -(w + 37, 258)
	LINE -(w + 36, 255): LINE -(w + 37, 250)
	LINE -(w + 39, 246): LINE -(w + 40, 243)
	c = 0: IF s = 2 THEN c = 15: LINE (547, 263)-(558, 263), 15
	PAINT (w + 33, 250), c, 0
	PAINT (w + 42, 264), c, 0

	CALL flags(3 - s, 26, 0)
	IF who < 99 THEN CALL TICK(turbo!)
END SUB

SUB TICK (sec!)
	start! = TIMER
	DO WHILE TIMER - start! < sec! AND INKEY$ = "": LOOP
END SUB

SUB topbar
	LOCATE 1, 1: PRINT SPACE$(80);
	COLOR 11
	LOCATE 1, 10: PRINT "Input your decisions now for "; force$(side); " side "; : COLOR 14: PRINT month$(month); ","; year; "  "

	CALL flags((side), 0, 0)
	COLOR 4: IF bw > 0 THEN COLOR 7
	LOCATE 6, 68: PRINT "Difficulty "; LTRIM$(RTRIM$(STR$(difficult)))
	LOCATE 7, 68: PRINT "Funds:"; cash(side);

	FOR i = 1 TO 2: IF victory(i) < 0 THEN victory(i) = 0
	NEXT i
	x = victory(1) + victory(2): y = 0
	c = 9: IF side = 2 THEN c = 7
	LINE (580, 15)-(580, 35), 15
	LINE (530, 20)-(630, 30), 8 - c, BF
	IF x > 0 THEN y = 100 * (victory(side) / x)

	LINE (530, 20)-(530 + y, 30), c, BF
	COLOR c: LOCATE 4, 68: PRINT "VP :"; victory(side)

	LOCATE 5, 68: PRINT "("; y; "%)"

	a$ = "  Snd": IF noise < 2 THEN a$ = "   Snd": IF noise = 0 THEN a$ = "      "
	IF graf > 0 THEN a$ = a$ + " G" + LTRIM$(STR$(graf))
	a$ = a$ + STR$(player)
	COLOR c
	LOCATE 26, 68: PRINT "F3 Redrw Scrn"
	LOCATE 27, 68: PRINT "F7 End Turn"
	LOCATE 28, 68: PRINT a$
END SUB

SUB touchup

	LINE (500, 170)-(490, 165), 10 'Norfolk Coast
	LINE -(495, 160), 10
	LINE -(490, 155), 10
	LINE -(485, 150), 10

	'PAINT (502, 160), 1, 10

	LINE (145, 375)-(145, 405), 10   'Mobile border

	LINE (291, 111)-(301, 101), 1
	LINE -(316, 96), 1
	LINE -(331, 76), 1
	LINE -(345, 51), 1
	LINE -(351, 30), 1
	LINE -(370, 35), 1

	LINE (381, 81)-(431, 66), 1  'Potomac River
	LINE -(456, 81), 1
	LINE -(471, 111), 1

	LINE (115, 165)-(105, 170), 1  'Paducah
	LINE -(105, 190), 1
	LINE (106, 170)-(91, 140), 1   'Missouri R

	LINE (105, 190)-(150, 190), 10
	LINE (120, 160)-(130, 200), 1  'Tenn River

	LINE (60, 295)-(65, 325), 1 'Vicksburg
	LINE -(65, 335), 1


	LINE (195, 125)-(170, 130), 1
	LINE -(165, 135), 1

	LINE (50, 375)-(60, 395), 1

	LINE (60, 395)-(105, 405), 1
	LINE -(110, 420), 1

	LINE (291, 265)-(350, 340), 1   'Savannah R.

	LINE (1, 80)-(15, 77), 1    'Missouri River
	LINE -(25, 95), 1
	LINE -(50, 98), 1
	LINE -(75, 96), 1

	LINE (71, 90)-(61, 95), 1
	LINE -(56, 85), 1

	LINE (110, 398)-(105, 398), 10
	LINE -(90, 396), 10
	LINE -(90, 400), 10
	LINE -(105, 402), 10
	LINE -(120, 415), 10
	LINE -(115, 420), 10
	'PAINT (108, 400), 1, 10

	LINE (66, 375)-(52, 375), 10
	END SUB

	SUB traincapacity (who, limit)
	IF realism = 0 THEN limit = train(who): EXIT SUB
	x = 11: IF side = 2 THEN x = 23
	limit = train(who) + 5 * (control(who) - x)
	x = 2 * train(who)
	IF limit > x THEN limit = x
	IF limit < x \ 4 THEN limit = x \ 4
	END SUB

	SUB usa
	SCREEN 12
	LINE (1, 16)-(527, 440), 10, B
	PAINT (200, 200), 2, 10
	COLOR 10
	'==========================  Mountains =================================
	IF _FILEEXISTS("mtn.vga") THEN
		PUT (380, 30), mtn, PSET
		PUT (270, 200), mtn, PSET
		PUT (310, 160), mtn, PSET
		PUT (350, 120), mtn, PSET
		PUT (200, 185), mtn, PSET
		PUT (250, 130), mtn, PSET
		PUT (320, 80), mtn, PSET
		PUT (30, 150), mtn, PSET
		LINE (30, 150)-(70, 190), 2, BF
	END IF
	'===========================  Kentucky =================================
	LINE (105, 190)-(150, 190)
	LINE -(150, 185)
	LINE -(290, 185)
	LINE (276, 185)-(301, 175)
	LINE -(305, 160)
	LINE -(310, 155)
	LINE -(305, 145)
	LINE -(300, 125)
	LINE -(290, 110)

	LINE -(275, 95), 1
	LINE -(270, 95), 1
	LINE -(260, 100), 1
	LINE -(250, 100), 1
	LINE -(240, 90), 1
	LINE -(235, 85), 1
	LINE -(230, 85), 1
	LINE -(220, 90), 1
	LINE -(220, 100), 1
	LINE -(210, 105), 1
	LINE -(205, 115), 1
	LINE -(195, 125), 1
	LINE -(170, 130), 1
	LINE -(165, 135), 1
	LINE -(130, 140), 1
	LINE -(120, 150), 1
	LINE -(120, 160), 1
	LINE -(115, 165), 1
	LINE -(105, 170), 1
	LINE -(105, 190), 1
	'===========================  Tennessee =================================
	LINE (290, 185)-(320, 185)
	LINE -(320, 185)
	LINE -(315, 195)
	LINE -(302, 210)
	LINE -(290, 215)
	LINE -(275, 230)
	LINE -(260, 241)
	LINE -(260, 241)
	LINE -(70, 241)

	LINE (105, 190)-(95, 200), 1
	LINE -(80, 220), 1
	LINE -(70, 241), 1
	'===========================  Mississippi =================================
	LINE (143, 241)-(145, 405)
	LINE -(135, 400)
	LINE -(125, 400)
	LINE -(115, 405)
	LINE -(110, 400)
	LINE -(110, 390)
	LINE -(115, 380)
	LINE -(115, 375)
	LINE -(50, 375)
	LINE (115, 375)-(60, 375)

	LINE (70, 241)-(65, 280), 1
	LINE -(60, 295), 1
	LINE -(65, 325), 1
	LINE -(65, 335), 1
	LINE -(50, 375), 1
	'===========================  Alabama =================================
	LINE (215, 241)-(232, 375)
	LINE (176, 395)-(181, 410)
	LINE -(166, 415)
	LINE -(161, 400)
	LINE -(156, 405)
	LINE -(146, 405)
	LINE (176, 395)-(176, 385)
	LINE -(231, 385)
	'===========================  Georgia & Florida ============================
	LINE (261, 241)-(296, 241)
	LINE -(291, 265)
	LINE -(350, 340)
	LINE -(336, 390)
	LINE -(366, 440)
	LINE (336, 385)-(325, 385)   'Fla /Ga Border
	LINE -(320, 388)
	LINE -(245, 388)
	LINE -(230, 385)
	LINE (180, 410)-(195, 410)
	LINE -(215, 415)
	LINE -(225, 425)
	LINE -(255, 420)
	LINE -(265, 420)
	LINE -(270, 425)
	LINE -(275, 440)
	LINE (347, 409)-(343, 409)
	LINE -(343, 431)
	LINE -(346, 431)
	LINE -(346, 412)
	LINE -(349, 412)
	LINE (347, 411)-(350, 411), 1

	LINE (353, 333)-(358, 336), 10, B
	'===========================  South Carolina ================================
	LINE (290, 241)-(305, 240)
	LINE -(345, 240)
	LINE -(350, 250)
	LINE -(380, 250)
	LINE -(415, 280)
	LINE -(385, 315)
	LINE -(380, 320)
	LINE -(375, 325)
	LINE -(350, 330)
	LINE -(350, 340)
	'===========================  North Carolina ================================
	LINE (320, 185)-(500, 185)
	LINE -(505, 190)
	LINE -(490, 195)
	LINE -(490, 205)
	LINE -(505, 205)
	LINE -(500, 215)
	LINE -(485, 220)
	LINE -(490, 225)
	LINE -(500, 225)
	LINE -(500, 230)
	LINE -(490, 235)
	LINE -(488, 240)
	LINE -(480, 241)
	LINE -(460, 250)
	LINE -(455, 255)
	LINE -(440, 265)
	LINE -(439, 270)
	LINE -(425, 278)
	LINE -(415, 280)
	LINE (510, 190)-(513, 200), , B
	LINE (510, 206)-(510, 226)
	LINE -(500, 236)
	LINE -(502, 241)
	LINE -(512, 228)
	LINE -(512, 208)
	LINE -(510, 206)

	'=========================== Chesapeake ====================================
	CALL chessie
	'=============== Ohio, Pennslyvania, Maryland, Virginia =====================
	LINE (291, 111)-(301, 101), 1
	LINE -(316, 96), 1
	LINE -(331, 76), 1
	LINE -(345, 51), 1
	LINE -(351, 30), 1
	LINE -(370, 35), 1

	LINE (351, 16)-(351, 54)
	LINE -(527, 54)
	LINE (381, 54)-(381, 81)
	LINE -(431, 66)
	LINE -(456, 81)
	LINE -(471, 111)
	LINE (226, 85)-(226, 16)
	'=============== Louisiana, Arkansas, Missouri =============================
	LINE (50, 375)-(60, 395), 1
	LINE -(105, 405), 1
	LINE -(110, 420), 1
	LINE -(125, 438), 1
	LINE (110, 398)-(105, 398)

	LINE -(90, 396)
	LINE -(90, 400)


	LINE -(105, 402)
	LINE -(120, 415)
	LINE -(115, 420)
	LINE -(125, 435)
	LINE -(120, 440)
	LINE -(110, 425)
	LINE -(100, 435)
	LINE -(90, 440)
	LINE -(50, 430)
	LINE -(25, 435)
	LINE -(1, 435)
	'----------------------------------
	PAINT (250, 430), 1, 10
	PAINT (110, 439), 1, 10
	PAINT (50, 439), 1, 10
	'----------------------------------
	LINE (1, 300)-(61, 300)       'Ark
	LINE (91, 205)-(71, 205)
	LINE -(76, 190)
	LINE -(71, 185)
	LINE -(1, 185)

	LINE (106, 170)-(91, 140), 1    'Missouri
	LINE -(71, 120), 1
	LINE -(76, 110), 1
	LINE -(76, 95), 1
	LINE -(71, 90), 1
	LINE -(61, 95), 1
	LINE -(56, 85), 1
	LINE -(50, 35), 1
	LINE -(46, 20), 1

	LINE -(38, 16)

	LINE (46, 20)-(61, 17), 1        'Illinois

	LINE (150, 17)-(150, 110)
	LINE -(147, 125), 1
	LINE -(140, 138), 1
	'========================== Rivers =========================================

	LINE (1, 80)-(15, 77), 1    'Missouri River
	LINE -(25, 95), 1
	LINE -(50, 98), 1
	LINE -(75, 96), 1

	LINE (120, 160)-(130, 200), 1  'Tenn River
	LINE -(135, 240), 1
	LINE -(130, 247), 1
	LINE -(160, 250), 1
	LINE -(200, 260), 1
	LINE -(240, 244), 1
	LINE -(245, 240), 1
	LINE -(270, 200), 1

	LINE (120, 160)-(140, 200), 1  'Cumberland River
	LINE -(160, 210), 1
	LINE -(200, 208), 1
	LINE -(240, 170), 1

	LINE (161, 400)-(155, 320), 1  'Tombigbee River
	LINE -(145, 300), 1

	LINE (161, 400)-(170, 370), 1  'Alabama River
	LINE -(200, 350), 1

	LINE (230, 425)-(231, 385), 1  'Chattahoochee River
	LINE -(233, 350), 1
	LINE -(240, 330), 1
	LINE -(270, 290), 1

	LINE (381, 81)-(431, 66), 1   'Potomac River
	LINE -(456, 81), 1
	LINE -(471, 111), 1

	LINE (485, 150)-(455, 145), 1   'James River
	LINE -(400, 150), 1

	LINE (489, 200)-(415, 185), 1   'Roanoke River
	LINE -(400, 160), 1

	LINE (296, 241)-(291, 265), 1   'Savannah River
	LINE -(350, 340), 1

	LINE (438, 271)-(430, 235), 1  'Cape Fear River
	LINE -(420, 205), 1

	LINE (500, 80)-(498, 50), 1 'Susquehanna River
	LINE -(470, 30), 1

	LINE (405, 290)-(360, 240), 1 'Pee Dee River

	LINE (400, 300)-(350, 280), 1 'Santee River

	LINE (270, 423)-(280, 410), 1 'Suwanee River
	LINE -(290, 390), 1

	LINE (342, 370)-(300, 350), 1 'Altamaha River

	LINE (50, 370)-(1, 330), 1 'Red River

	LINE (65, 280)-(1, 240), 1 'Arkansas River

	LINE (430, 66)-(400, 100), 1 ' Shenandoah River
	LINE -(380, 120), 1

	CALL showcity
	PSET (493, 280), 1
	IF navyloc(1) = 30 OR navyloc(2) = 30 THEN
		DRAW "C11U7R4D3L3BR6BU3D7BU4R3U3D7BR3U7BD4BR4BU4D7R4"
		LINE (485, 241)-(525, 270), 11, B
	END IF

	IF graf > 1 THEN CALL maptext
	IF commerce > 0 THEN
	LINE (447, 291)-(525, 317), 4, BF: LINE (447, 291)-(525, 317), 10, B
	y = 312
	a$ = "COMMERCE"
	FOR j = 1 TO LEN(a$): x = ASC(MID$(UCASE$(a$), j, 1)) - 64
	PSET (440 + 10 * j, y), 0: DRAW font$(x)
	NEXT j
	ELSE
	LINE (447, 291)-(525, 335), 1, BF
	END IF

	FOR i = 1 TO 40
	IF armyloc(i) > 0 THEN CALL placearmy(i)
	NEXT i

	FOR k = 1 TO 2
	CALL stax(k)
	NEXT k

	IF player = 2 GOTO nosee
	FOR i = 1 TO 40: IF armyloc(i) > 0 AND armymove(i) > 0 THEN CALL icon(armyloc(i), armymove(i), 1)
	NEXT i
	nosee:
	CALL ships
	CALL engine
	COLOR 13: LOCATE 24, 51: PRINT " "; UCASE$(LEFT$(month$(month), 3)); ","; year
END SUB

SUB victor
	x = 0: FOR j = 1 TO 20: IF armyloc(j) > 0 THEN x = x + armysize(j)
	NEXT j
	y = 0: FOR j = 21 TO 40: IF armyloc(j) > 0 THEN y = y + armysize(j)
	NEXT j

	CALL clrbot: COLOR 14
	IF vicflag(2) > 0 AND year >= vicflag(2) AND month < vicflag(1) THEN
		a$ = "Time almost expired (" + month$(vicflag(1)) + "," + STR$(vicflag(2)) + ")"
		CALL image2(a$, 4)
	END IF
    FOR i = 1 TO 2
	IF (i = 1 AND y = 0) OR (i = 2 AND x = 0) THEN j = 7: victory(i) = victory(i) + 300: GOTO finis

	IF year >= vicflag(2) AND month >= vicflag(1) AND vicflag(2) > 0 THEN j = 2: GOTO finis
	IF control(i) >= vicflag(3) AND vicflag(3) > 0 THEN j = 3: GOTO finis
	IF income(i) / (income(1) + income(2)) >= .01 * vicflag(4) AND vicflag(4) > 0 THEN j = 4: GOTO finis
	IF vicflag(5) > 0 AND capcity(3 - i) = 0 AND capcity(i) > 0 THEN j = 5: GOTO finis

	IF vicflag(6) > 0 THEN
		IF i = 1 THEN
			IF y = 0 THEN j = 7: GOTO finis
			IF x / y > vicflag(6) THEN j = 6: GOTO finis
		END IF
		IF i = 2 THEN
			IF x = 0 THEN j = 7: GOTO finis
			IF y / x > vicflag(6) THEN j = 6: GOTO finis
		END IF
	END IF

	CALL clrbot: COLOR 14
	IF vicflag(3) > 0 AND control(i) >= .9 * vicflag(3) THEN
		a$ = force$(i) + " side almost controls" + STR$(vicflag(3)) + " cities"
		CALL image2(a$, 4)
	END IF

	IF vicflag(4) > 0 AND income(i) / (income(1) + income(2)) >= .009 * vicflag(4) THEN
		a$ = force$(i) + " side close to" + STR$(vicflag(4)) + " % of total income"
		CALL image2(a$, 4)
	END IF

	IF vicflag(6) > 0 AND x > 0 AND y > 0 THEN
		IF (i = 1 AND x / y > .9 * vicflag(6)) OR (i = 2 AND y / x > .9 * vicflag(6)) THEN
		a$ = force$(i) + "side close to" + STR$(vicflag(6)) + ":1 strength ratio"
		CALL image2(a$, 4)
		END IF
	END IF
	GOTO stale

	finis:
		SELECT CASE j
			CASE IS < 3
			a$ = "TIME EXPIRED"
			CASE 3
			a$ = STR$(2.5 * vicflag(3)) + "% CITIES CONTROLLED"
			CASE 4
			a$ = STR$(vicflag(4)) + " % OF TOTAL INCOME"
			CASE 5
			a$ = "CAPITAL CAPTURED"
			CASE 6
			a$ = STR$(vicflag(6)) + ":1 ARMY STRENGTH RATIO"
			CASE 7
			a$ = "ENEMY ANNIHILATED"
	END SELECT
		CLS
		c = 1: IF i = 2 THEN c = 7
		LINE (0, 0)-(639, 479), 4, BF
		LINE (0, 40)-(550, 460), 0, BF
		CALL usa
		LINE (70, 140)-(485, 265), 0, BF
		LINE (50, 120)-(465, 250), c, BF
		LINE (50, 120)-(465, 250), 4, B
		COLOR 14
		t$ = force$(i) + " SIDE IS WINNING"
		IF j = 2 THEN CALL center(10, "Confederates will win a technical victory") ELSE CALL center(10, t$)

		COLOR 15
		t$ = "END GAME VICTORY CONDITION" + STR$(j - 1) + " REACHED"
		CALL center(12, t$)
		CALL center(14, a$)

		mtx$(0) = "End Game"
		mtx$(1) = "Yes"
		mtx$(2) = "No-Override"
		size = 2: colour = 4
		tlx = 27: tly = 18
		hilite = 15
		IF j = 7 THEN size = 1
		CALL menu(0)

		IF choose <> 1 AND j < 7 THEN
	play4ever:
				vicflag(j) = vicflag(j) + 1
				IF j = 5 THEN vicflag(j) = 0
				CLS
				CALL usa
				EXIT SUB
		END IF
		mtx$(0) = "Options"
		mtx$(1) = "Quit this Game"
		mtx$(2) = "Play More"
		IF player = 1 THEN mtx$(2) = "No - Press Onward to " + city$(capcity(3 - side))
		size = 2: colour = 8
		tlx = 27: tly = 18
		IF j <> 7 THEN
			CALL menu(0)
			IF choose <> 1 GOTO play4ever
		ELSE
			victory(i) = victory(i) + 100
		END IF

		thrill = i
		CALL usa: CALL report(100 + side)
		IF j = 2 THEN FOR k = 1 TO 2: victory(k) = .7 * victory(k): NEXT k: CALL rwin: GOTO death

		IF i = 1 THEN CALL capitol: COLOR 15: LOCATE 2, 27: t$ = "UNION VICTORY  VP's=" + STR$(victory(1)): PRINT t$: GOTO death
		IF i = 2 THEN CALL rwin: COLOR 15: LOCATE 2, 27: t$ = "REBEL VICTORY  VP's=" + STR$(victory(2)): PRINT t$
	death:
		COLOR 14: LOCATE 4, 40 - .5 * LEN(a$)
		IF history > 0 THEN
			CALL scribe(t$, 0)
			CALL scribe(a$, 0)
		END IF
		PRINT a$: CALL maxx
		EXIT SUB
	stale:
    NEXT i
END SUB

SUB void (a, y)
	y = 0
	FOR j = 1 TO 6
	x = matrix(a, j): IF x = 0 GOTO tally5
	IF cityp(x) = side AND occupied(x) > 0 THEN y = y + armysize(occupied(x))
		FOR k = 1 TO 6: m = matrix(x, k): IF m = 0 OR m = a GOTO tally4
		IF cityp(m) = side AND occupied(m) > 0 THEN y = y + .1 * armysize(occupied(m))
	tally4:
		NEXT k
	NEXT j
	tally5:
END SUB

'============================================================================
'                GENmenu 3.05 : Generic Menu Main Module Level  12/91
'                Updated to Use Graphic Screens 8, 9, 12
'============================================================================
'       tlx  = top left x  (if zero, automatically centered)
'       tly = top left y   (if zero, automatically centered)
'       size = # rows (current maximum=20)
'       mtx$() = text for menu
'                mtx$(0) = heading (blank defaults to M E N U)
'                mtx$(1-size) are options
'       choose = option selected (row #)
'            -1 indicates ESC key pressed
'            entering with choose+21 causes choose to be default entry
'       wtype = window type (0 = no line; 1=single line;
'                            2=double line
'               if >10 then 10's digit=box color  1's digit= window type

SUB choices (b1, wide)
	boxc = colour: IF wtype > 10 THEN boxc = INT(wtype / 10): wtype = wtype - 10 * boxc
	COLOR boxc
	VIEW (8 * tlx - 6, 16 * tly - 11)-(8 * (tlx + wide + 1) + 7, 16 * (tly + size + 2) + 8)
	CLS 1
	VIEW
	LINE (8 * tlx - 6, 16 * tly - 11)-(8 * (tlx + wide + 1) + 7, 16 * (tly + size + 2) + 8), colour, B
	LINE (8 * tlx - 2, 16 * (tly + 1) + 3)-(8 * (tlx + wide + 1) + 3, 16 * (tly + 1) + 6), colour, B
	IF ABS(wtype) = 2 THEN
	LINE (8 * tlx - 2, 16 * tly - 8)-(8 * (tlx + wide + 1) + 3, 16 * (tly + size + 2) + 4), colour, B
	END IF
	COLOR colour

	LOCATE tly + 1, tlx + b1: PRINT mtx$(0)
	FOR i = 1 TO size
	LOCATE tly + 2 + i, tlx + 2: PRINT mtx$(i);
	NEXT i
END SUB

SUB ironclad
	SCREEN 12
	LINE (1, 240)-(639, 309), 3, BF
	LINE (639, 309)-(1, 479), 1, BF

	COLOR 7
	LINE (478, 368)-(174, 389): LINE -(86, 363): LINE -(78, 353)
	LINE -(161, 337): LINE -(162, 337): LINE -(406, 326): LINE -(478, 368)
	PAINT (300, 350), 7

	COLOR 15
	LINE (427, 358)-(203, 373): LINE -(247, 322): LINE -(205, 312)
	LINE -(167, 342): LINE -(203, 373): LINE -(246, 323): LINE -(401, 318)
	LINE -(427, 358): LINE -(400, 318): LINE -(363, 306): LINE -(204, 312)
	PAINT (300, 315), 7, 15
	PAINT (200, 325), 8, 15
	PAINT (300, 325), 8, 15

	COLOR 7
	LINE (77, 353)-(76, 363): LINE -(84, 370): LINE -(85, 363)
	LINE -(84, 369): LINE -(169, 396): LINE -(170, 389): LINE -(168, 396)
	LINE -(477, 375): LINE -(478, 369)
	PAINT (80, 363), 7
	PAINT (150, 385), 8, 7
	PAINT (190, 390), 0, 7

	COLOR 0
	LINE (299, 261)-(294, 254): LINE -(303, 250): LINE -(299, 243)
	LINE -(316, 243): LINE -(321, 247): LINE -(326, 241): LINE -(335, 240)
	LINE -(345, 240): LINE -(357, 246): LINE -(366, 241): LINE -(381, 245)
	LINE -(384, 253): LINE -(398, 248): LINE -(410, 248): LINE -(413, 259)
	LINE -(424, 264): LINE -(425, 254): LINE -(444, 258): LINE -(445, 270)
	LINE -(436, 277): LINE -(426, 281): LINE -(418, 270): LINE -(411, 272)
	LINE -(400, 263): LINE -(392, 275): LINE -(374, 270): LINE -(370, 262)
	LINE -(357, 257): LINE -(345, 256): LINE -(335, 257): LINE -(335, 262)
	LINE -(324, 257): LINE -(317, 258): LINE -(309, 257): LINE -(305, 262)
	LINE -(300, 261)
	PAINT (320, 250), 0

	LINE (211, 341)-(196, 357): LINE -(179, 346)
	LINE -(194, 335): LINE -(211, 341)
	PAINT (190, 350), 0
	LINE (211, 341)-(225, 330), 7: LINE -(209, 324), 7: LINE -(188, 340), 0

	FOR k = 0 TO 3
	x = 260 + 40 * k: y = 344 - 2 * k
	LINE (x, y)-(x + 2, y + 20): LINE -(x + 17, y + 19): LINE -(x + 15, y)
	LINE -(x, y)
	PAINT (x + 10, 350), 0
	LINE (x, y)-(x + 15, y), 7: LINE -(x + 13, y - 14), 7: LINE -(x - 2, y - 14), 7: LINE -(x, y)
	NEXT k

	COLOR 8
	LINE (168, 340)-(85, 355): LINE -(91, 361): LINE -(173, 386): LINE -(466, 366)
	LINE -(414, 334)

	LINE (358, 307)-(382, 315): LINE -(249, 320): LINE -(220, 314)
	LINE -(358, 307)

	LINE (314, 255)-(330, 314), 8, BF
	LINE (297, 310)-(309, 262), 8, BF
	LINE (323, 257)-(329, 314), 0, BF
	LINE (303, 310)-(308, 262), 0, BF
	LINE (319, 257)-(320, 315), 15, BF
	LINE (300, 262)-(301, 312), 15, BF

	LINE (96, 297)-(94, 357), 8, BF
	LINE (98, 299)-(106, 317), 4, BF
	LINE (107, 304)-(110, 319), 9, BF
	LINE (111, 300)-(114, 312), 15, BF

	y = 387: FOR x = 180 TO 470 STEP 15: y = y - 1: LINE (x, y)-(x + 1, y + 1), 0, BF: NEXT x
	y = 360: FOR x = 90 TO 170 STEP 15: y = y + 4: LINE (x, y)-(x + 1, y + 1), 0, BF: NEXT x
	y = 373: FOR x = 216 TO 250 STEP 7: y = y - 8: LINE (x, y)-(x + 1, y + 1), 0, BF: NEXT x
	y = 373: FOR x = 205 TO 243 STEP 7: y = y - 8: LINE (x, y)-(x + 1, y + 1), 0, BF: NEXT x
	y = 350: FOR x = 172 TO 200 STEP 9: y = y - 8: LINE (x, y)-(x + 1, y + 1), 0, BF: NEXT x
	y = 310: FOR x = 397 TO 425 STEP 8: y = y + 11: LINE (x, y)-(x + 1, y + 1), 0, BF: NEXT x
	COLOR 11
	LINE (70, 361)-(68, 369): LINE -(106, 384): LINE -(166, 394)
	LINE -(210, 385): LINE -(255, 391): LINE -(219, 394)
	LINE -(242, 402): LINE -(202, 405): LINE -(162, 402)
	LINE -(121, 387)
	PAINT (190, 400), 3, 11

	LINE (331, 391)-(365, 387)
	LINE -(403, 375): LINE -(446, 382): LINE -(471, 384)
	LINE -(446, 391): LINE -(478, 395): LINE -(449, 407)
	LINE -(445, 406): LINE -(414, 395): LINE -(412, 395)
	LINE -(369, 396): LINE -(323, 391)
	PAINT (390, 390), 3, 11

	LINE (476, 379)-(531, 372)
	LINE (420, 329)-(497, 327), 3
	LINE -(464, 340): LINE -(535, 343), 3
	LINE (141, 337)-(67, 349): LINE -(58, 372)

	LINE (525, 405)-(587, 392): LINE -(628, 402): LINE -(588, 415)
	LINE -(563, 409): LINE -(562, 409): LINE -(527, 423)
	LINE -(540, 410): LINE -(523, 406)
	PAINT (560, 405), 9, 11

	LINE (106, 320)-(101, 318), 0, BF
	LINE (110, 313)-(114, 315), 0, BF
END SUB

SUB menu (switch%)
	remenu:
		IF colour = 0 THEN colour = 7
		LOCATE 1, 1, 0
		IF mtx$(0) = "" THEN mtx$(0) = "M E N U"

		IF wide = 0 THEN CALL mxw(wide)
		IF tlx = 0 THEN GOSUB noadjust
		IF choose < 21 THEN choose = 1
		IF choose > 21 THEN choose = choose - 21
		IF choose > 21 THEN choose = 1
		row = choose: IF row < 1 THEN row = 1
		IF row > size THEN row = 1
		choose = row
		row1 = row
		
		IF tly = 0 THEN tly = INT(11.5 - .5 * size)
		IF tly + size > 26 THEN tly = 26 - size
		
		brx = tlx + wide + 1
		bry = tly + size + 3
		
		boxc = colour: IF wtype > 10 THEN boxc = INT(wtype / 10): wtype = wtype - 10 * boxc

		COLOR boxc

		VIEW (8 * tlx - 6, 16 * tly - 11)-(8 * (tlx + wide + 1) + 7, 16 * (tly + size + 2) + 8)
		CLS 1
		VIEW
		LINE (8 * tlx - 6, 16 * tly - 11)-(8 * (tlx + wide + 1) + 7, 16 * (tly + size + 2) + 8), colour, B
		LINE (8 * tlx - 2, 16 * (tly + 1) + 3)-(8 * (tlx + wide + 1) + 3, 16 * (tly + 1) + 6), colour, B
		IF ABS(wtype) = 2 THEN
			LINE (8 * tlx - 2, 16 * tly - 8)-(8 * (tlx + wide + 1) + 3, 16 * (tly + size + 2) + 4), colour, B
		END IF

		COLOR colour
		b1 = INT(.5 * (wide - LEN(mtx$(0))) + .5) + 1

		CALL choices(b1, wide)
	sel1:
		SELECT CASE switch
			CASE 1: CALL icon(array(row), 0, 7)
			CASE 2: CALL icon(array(row), 0, 9)
				target = occupied(array(row))
				IF target > 0 THEN
				flag = 1
				t$ = armyname$(target)
				IF LEN(t$) > wide THEN t$ = LEFT$(t$, wide)
				COLOR 12
				LOCATE tly + 2 + row, tlx + 2: PRINT SPACE$(wide);
				LOCATE tly + 2 + row, tlx + 2: PRINT t$;
				LOCATE tly + 4 + size, tlx + 1: PRINT SPACE$(12);
				LOCATE tly + 4 + size, tlx + 1: PRINT "Size"; armysize(target);
				x = POS(0): y = CSRLIN: LOCATE y, x - 1: PRINT "00";
				ELSE
				flag = 0
				LOCATE tly + 4 + size, tlx + 1: PRINT SPACE$(12);
				END IF
			CASE 4: CALL armystat(array(row))
			CASE 5: COLOR 11: CALL clrbot: PRINT armyname$(index); "  Exp="; armyexper(index); " Cash="; cash(side);
			CASE 6: CALL icon(armyloc(array(row)), 0, 9)
			CASE 8
				IF graf > 2 AND row > 0 THEN
					LINE (548, 148)-(592, 216), 15, B
					a = row: IF side = 1 THEN a = 6 - row
					t$ = "face" + LTRIM$(STR$(a)) + ".vga"
					IF _FILEEXISTS(t$) THEN
						DEF SEG = VARSEG(graft(1))
						BLOAD t$, VARPTR(graft(1))
						DEF SEG
						PUT (550, 150), graft, PSET
						IF side = 2 THEN
							PAINT (560, 160), 8, 0
							PAINT (570, 155), 7, 0
						END IF
					END IF
				END IF
			CASE 9: CALL icon(array(row), 0, 9)
		END SELECT
		IF flag = 0 THEN
			COLOR hilite
			LOCATE tly + 2 + row, tlx + 2
			PRINT mtx$(row)
			IF bw > 0 THEN LINE (8 * (tlx + 1), 16 * (tly + row + 1))-(8 * (tlx + LEN(mtx$(row)) + 1) - 1, 16 * (tly + row + 2) - 1), hilite, B
		END IF
		GOSUB crsr
		IF switch <> 3 GOTO reglr
		IF a$ = "H" THEN choose = 1: GOTO called
		IF ASC(a$) = 13 THEN choose = 2: GOTO called
		IF a$ = "P" THEN choose = 3: GOTO called
	reglr:
		IF ASC(a$) = 13 GOTO called
		IF switch = 2 THEN LOCATE tly + 2 + row1, tlx + 2: PRINT SPACE$(wide);
		COLOR colour
		LOCATE tly + 2 + row1, tlx + 2: PRINT mtx$(row1)

		SELECT CASE switch
			CASE 1, 2, 9
				IF mtx$(row1) <> "EXIT" THEN CALL icon(array(row1), 0, 8)
			CASE 6
				IF mtx$(row1) <> "EXIT" THEN CALL icon(armyloc(array(row1)), 0, 8)
		END SELECT

		choose = row
		GOTO sel1
	crsr:   a$ = INKEY$: IF a$ = "" GOTO crsr
		IF ASC(a$) = 13 THEN RETURN
		IF LEN(a$) = 2 GOTO arrows
		IF switch = 3 THEN choose = -ASC(UCASE$(a$)): GOTO called
		IF ASC(a$) = 27 THEN choose = -1: GOTO called
			row1 = row
			FOR k = 1 TO size
			c1$ = UCASE$(LEFT$(LTRIM$(mtx$(k)), 1))
			IF c1$ = UCASE$(a$) THEN choose = k: GOSUB limits: GOTO called
			NEXT k
		GOTO crsr
	arrows:
		a$ = RIGHT$(a$, 1)
		row1 = row
		IF a$ = "H" THEN row = row - 1: GOSUB limits: RETURN
		IF a$ = "I" THEN row = 1: GOSUB limits: RETURN
		IF a$ = "P" THEN row = row + 1: GOSUB limits: RETURN
		IF a$ = "Q" THEN row = size: GOSUB limits: RETURN
		IF a$ = ";" AND switch = 0 THEN
			SCREEN 0: CLS
			SCREEN 12: CALL usa
			CALL choices(b1, wide)
			CALL topbar
			RETURN
		END IF
		IF a$ = "=" AND switch = 0 THEN
			CLS
			CALL usa
			CALL choices(b1, wide)
			CALL topbar
			RETURN
		END IF
		IF a$ = "A" AND switch = 0 THEN
			choose = 99
			GOTO called
			RETURN
		END IF
		IF a$ = ">" AND switch = 0 THEN
			CALL report(-1)
			CALL choices(b1, wide)
			CALL topbar
			RETURN
		END IF
		RETURN

	limits:
		IF row > size THEN row = 1
		IF row < 1 THEN row = size
		RETURN
	noadjust:
		IF tlx = 0 THEN tlx = INT(40.5 - .5 * wide)
		RETURN
	boss1:
		CLS
		CALL usa
		GOTO remenu
	called:
	IF noise > 0 THEN SOUND 700, .5
	COLOR colour
	tlx = 0: tly = 0
	SELECT CASE switch
	CASE 1, 2, 9
		CALL icon(array(row), 0, 8)
	CASE 6
		CALL icon(armyloc(array(row)), 0, 8)
	END SELECT
	VIEW
END SUB

SUB mxw (wide)
	wide = LEN(mtx$(0)) + 1
	FOR i = 1 TO size
	x = LEN(mtx$(i))
	IF x > wide THEN wide = x
	NEXT i
END SUB

SUB schooner
	SCREEN 12
	LINE (1, 240)-(639, 309), 3, BF
	LINE (639, 309)-(1, 479), 1, BF
	COLOR 6
	LINE (243, 241)-(247, 395), , BF
	LINE (369, 395)-(373, 241), , BF
	LINE (183, 395)-(435, 400), , BF
	LINE (188, 395)-(107, 356): LINE -(106, 360): LINE -(173, 392)
	LINE -(182, 419): LINE -(191, 429): LINE -(230, 426): LINE -(275, 432)
	LINE -(314, 418): LINE -(354, 431): LINE -(390, 421): LINE -(390, 422)
	LINE -(413, 427): LINE -(437, 419): LINE -(447, 401): LINE -(447, 377)
	LINE -(401, 377): LINE -(399, 396)
	PAINT (300, 415), 6

	LINE (378, 290)-(434, 262): LINE -(432, 258): LINE -(377, 286)
	LINE -(378, 290)
	PAINT (380, 286), 6

	LINE (378, 346)-(456, 336): LINE -(457, 340): LINE -(376, 350)
	LINE -(378, 346)
	PAINT (382, 347), 6


	COLOR 15
	LINE (109, 355)-(131, 361)
	LINE -(239, 259): LINE -(239, 256): LINE -(109, 355)
	PAINT (140, 340)

	LINE (238, 268)-(256, 273)
	LINE -(241, 295): LINE -(240, 309): LINE -(250, 322)
	LINE -(226, 321): LINE -(220, 299): LINE -(227, 284)
	LINE -(239, 269)
	PAINT (245, 275), 15

	LINE (232, 327)-(225, 350): LINE -(233, 385): LINE -(251, 387)
	LINE -(242, 352): LINE -(243, 345): LINE -(249, 333)
	LINE -(232, 327)
	PAINT (235, 335), 15

	LINE (381, 268)-(368, 286)
	LINE -(366, 303): LINE -(374, 317): LINE -(350, 315)
	LINE -(347, 297): LINE -(361, 264): LINE -(381, 268)
	PAINT (365, 275), 15

	LINE (379, 335)-(360, 328)
	LINE -(351, 347): LINE -(355, 367)
	LINE -(357, 382): LINE -(378, 386): LINE -(368, 373)
	LINE -(369, 345): LINE -(379, 334)
	PAINT (360, 345), 15

	LINE (379, 290)-(406, 342): LINE -(456, 336): LINE -(435, 289)
	LINE -(433, 264): LINE -(378, 291)
	PAINT (410, 325), 15

	FOR k = 260 TO 400 STEP 25
	CIRCLE (k, 405), 3, 0
	PAINT (k, 405), 0
	NEXT k

	COLOR 11
	LINE (247, 437)-(290, 422): LINE -(314, 416): LINE -(334, 423)
	LINE -(305, 432): LINE -(287, 430): LINE -(286, 430)
	LINE -(267, 441): LINE -(225, 439): LINE -(225, 438)
	LINE -(246, 437)
	PAINT (300, 425), 3, 11

	LINE (362, 428)-(385, 419)
	LINE -(394, 421): LINE -(375, 437): LINE -(354, 432)
	LINE -(345, 429): LINE -(362, 428)
	PAINT (370, 430), 3, 11

	LINE (16, 383)-(43, 379)
	LINE -(44, 379): LINE -(78, 385): LINE -(16, 384)
	PAINT (40, 383), 9, 11

	LINE (173, 440)-(204, 431): LINE -(227, 431): LINE -(210, 439)
	LINE -(175, 441): LINE -(173, 440)
	PAINT (200, 435), 11

	LINE (445, 417)-(552, 409)
	LINE -(599, 416): LINE -(539, 415): LINE -(468, 415)
	PAINT (550, 411), 9, 11

	LINE (509, 349)-(540, 351)
	LINE -(541, 351)
	LINE -(517, 343): LINE -(509, 349)
	PAINT (520, 347), 3, 11

	LINE (577, 342)-(598, 343)
	LINE (275, 340)-(287, 342), 9

	LINE (149, 346)-(188, 345), 9
	LINE (24, 337)-(72, 338), 3

	COLOR 7
	LINE (227, 354)-(236, 383): LINE -(246, 386): LINE -(239, 356)
	LINE -(233, 357): LINE -(227, 354)
	PAINT (238, 365), 7

	LINE (223, 301)-(231, 321): LINE -(244, 321): LINE -(237, 308): LINE -(240, 303)
	LINE -(223, 301)
	PAINT (236, 312), 7

	LINE (349, 299)-(353, 313): LINE -(370, 316)
	LINE -(363, 302): LINE -(364, 303): LINE -(350, 300)
	PAINT (360, 310), 7

	LINE (356, 359)-(359, 380): LINE -(375, 385): LINE -(366, 372): LINE -(368, 364)
	LINE -(356, 360)
	PAINT (360, 370), 7

	LINE (393, 302)-(394, 302): LINE -(409, 323)
	LINE -(417, 309): LINE -(434, 325): LINE -(429, 304): LINE -(428, 291)
	LINE -(410, 296): LINE -(400, 290): LINE -(394, 302)
	PAINT (420, 300), 7

	COLOR 0
	LINE (247, 256)-(291, 394)
	LINE (247, 256)-(284, 394)
	LINE (244, 256)-(191, 394)
	LINE (244, 256)-(184, 394)

	LINE (371, 257)-(321, 394)
	LINE (371, 257)-(314, 394)
	LINE (375, 257)-(431, 378)
	LINE (375, 257)-(438, 378)

	LINE (375, 258)-(434, 259)

	COLOR 8
	LINE (180, 400)-(183, 415): LINE -(192, 426): LINE -(212, 426)
	LINE -(202, 421): LINE -(210, 414): LINE -(191, 408): LINE -(201, 402)
	LINE -(180, 400)
	PAINT (185, 410), 8

	LINE (445, 381)-(445, 400): LINE -(435, 417)
	LINE -(413, 424): LINE -(422, 413): LINE -(418, 404): LINE -(434, 401)
	LINE -(427, 393): LINE -(435, 391): LINE -(437, 384): LINE -(445, 382)
	PAINT (440, 388), 8

	LINE (186, 425)-(155, 429), 11: LINE -(146, 433), 11
	LINE (150, 417)-(116, 425), 11
	LINE (123, 452)-(153, 460), 11
	LINE (297, 463)-(319, 468), 11

	FOR k = 1 TO 4
	x = 185 + 200 * RND
	LINE (x, 390)-(x + 2, 392), 12, BF: LINE (x - 2, 392)-(x + 4, 394), 8, BF
	NEXT k
END SUB

SUB CopyFile(source$, dest$)
	OPEN source$ FOR BINARY AS #1
	OPEN dest$ FOR BINARY AS #2
	temp$ = SPACE$(LOF(1))
	GET #1, 1, temp$
	PUT #2, 1, temp$
	CLOSE
END SUB