SUB bub2 (limit)
DO
	swaps% = FALSE
	FOR i = 1 TO limit - 1
	IF brray(i) > brray(i + 1) THEN
		SWAP brray(i), brray(i + 1)
		swaps% = i
	END IF
	NEXT i
LOOP WHILE swaps%
END SUB