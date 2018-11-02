DEFINT A-Z
' Declare Subs
' Declare Variables

$EXEICON: 'cws.ico'
_ICON
_TITLE "VGA Civil War Strategy Game"

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
iron:
IF player < 1 OR player > 2 THEN player = 1
IF player = 2 OR side = 0 THEN side = 1
IF side = 1 THEN randbal = 7
IF side = 2 THEN randbal = 3
	IF turbo! < 1 THEN turbo! = 2
	IF side = 1 AND difficult < 3 THEN cash(2) = cash(2) + 600 - 100 * difficult
	IF side = 2 AND difficult > 3 THEN cash(1) = cash(1) + 100 * difficult


FOR i = 1 TO 2: income(i) = cash(i): cash(i) = cash(i) + 50 * RND: NEXT i
choose = 0

notitle2:
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
OPEN "I", 1, "cities.grd"
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
mtx$(0) = "VGA CIVILWAR STRATEGY"
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
	IF _FILEEXISTS("cws.his") THEN SHELL "copy cws.his oldhist.ory"
	OPEN "O", 2, "cws.his"
	PRINT #2, TAB(20); "[ HISTORY OF GAME BEGUN "; DATE$; " ]"
	CLOSE #2
ELSE
	SCREEN 12: CLS
END IF
CALL usa
GOTO menu0
' New Month
' Main Menu - Top Level
' Main Menu - Show Sub-Menus
SELECT CASE choose
	CASE 1 ' Recruit
	CASE 2 ' Armies
	CASE 3 ' Navies
	CASE 4 ' Railroad
	CASE 5 ' End Turn
	CASE 6 ' Reports
	CASE 7 ' Commands
	CASE 8 ' Utility Menu
	CASE 9 ' Files
CASE ELSE
	chosit = 22
	GOTO menu0
END SELECT
GOTO menu0
'............................................................................
'                               Subs
' topbar
' rusure
' unionplus
' blanken
' DATA