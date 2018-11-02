SUB mxw (wide)
	wide = LEN(mtx$(0)) + 1
	FOR i = 1 TO size
	x = LEN(mtx$(i))
	IF x > wide THEN wide = x
	NEXT i
END SUB