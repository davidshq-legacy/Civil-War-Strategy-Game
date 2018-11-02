SUB bubble (limit)
DO
	swaps% = FALSE
	FOR i = 1 TO limit - 1
	IF mtx$(i) > mtx$(i + 1) THEN
		SWAP mtx$(i), mtx$(i + 1)
		SWAP array(i), array(i + 1)
		swaps% = i
	END IF
	NEXT i
LOOP WHILE swaps%
END SUB