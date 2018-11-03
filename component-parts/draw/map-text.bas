' Only called by sub USA.
' Only on if graphics level are higher than 1.
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