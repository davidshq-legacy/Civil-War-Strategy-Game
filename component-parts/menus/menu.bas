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