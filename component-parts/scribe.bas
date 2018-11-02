SUB scribe (a$, flag)
	SELECT CASE flag
			CASE 1: CALL clrbot: PRINT a$;
			CASE 2: CALL image2(a$, 4)
	END SELECT
	IF history > 0 THEN
		OPEN "A", 2, "cws.his"
		a$ = LTRIM$(RTRIM$(a$))
		PRINT #2, a$
		CLOSE #2
	END IF
END SUB