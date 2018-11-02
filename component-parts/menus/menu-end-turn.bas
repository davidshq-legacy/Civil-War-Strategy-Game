	tlx = 67: tly = 15
	hilite = 15: colour = 3: choose = 23
	mtx$(0) = "End Turn"
	mtx$(1) = "Yes"
	mtx$(2) = "NOT YET"
	size = 2: CALL menu(0): CALL clrrite: IF choose <> 1 THEN chosit = 24: GOTO menu0
endrnd:
	rflag = 0: mflag = 0: nflag = 0
	IF player = 2 THEN side = side + 1: IF side = 2 THEN GOSUB blanken: CALL usa: GOTO menu0
	GOTO newmonth