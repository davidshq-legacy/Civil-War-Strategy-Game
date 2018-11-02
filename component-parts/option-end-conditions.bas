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