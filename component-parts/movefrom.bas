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