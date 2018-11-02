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