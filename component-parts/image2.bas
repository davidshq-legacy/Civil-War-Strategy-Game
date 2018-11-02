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