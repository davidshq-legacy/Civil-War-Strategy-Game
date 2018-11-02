' Only called by victory.
' Shows high scores.
SUB maxx
COLOR 14: LOCATE 28, 1: PRINT "press a key"; : DO WHILE INKEY$ = "": LOOP
SCREEN 0: COLOR 14, 5: CLS : COLOR 11, 0

LOCATE 2, 7: PRINT STRING$(57, "|")
LOCATE 9, 7: PRINT STRING$(57, "|")
FOR i = 1 TO 6: LOCATE 2 + i, 7: PRINT "|"; SPACE$(55); "|": NEXT i

		OPEN "I", 1, "hiscore.cws"
		FOR s = 1 TO 2
		COLOR 14, 4: LOCATE 3, 30 * (s - 1) + 10: PRINT force$(s); " HALL of FAME"
		COLOR 15, 0: FOR i = 1 TO 5
		INPUT #1, city$(5 * (s - 1) + i), matrix(s, i)
		LOCATE 3 + i, 30 * (s - 1) + 8: PRINT i, city$(5 * (s - 1) + i), matrix(s, i)
		NEXT i: NEXT s: CLOSE #1
		      
			FOR s = 1 TO 2: FOR i = 1 TO 5
			IF victory(s) < matrix(s, i) GOTO oldskor
				FOR j = 5 TO i + 1 STEP -1
				matrix(s, j) = matrix(s, j - 1)
				city$(5 * (s - 1) + j) = city$(5 * (s - 1) + j - 1)
				NEXT j

			COLOR 15, 1: IF s = 2 THEN COLOR 4, 7
			FOR k = 12 TO 14: LOCATE k, 1: PRINT SPACE$(80); : NEXT k
			LOCATE 12, 1: PRINT "Congratulations ! Score of"; victory(s)
			PRINT "New Entry into "; force$(s); " HALL of FAME in place "; i
			IF player = 1 AND s <> side THEN a$ = "COMPUTER": PRINT a$; " was "; force$(s); " commander": GOTO automate
who4:
			PRINT "What is name of "; force$(s); " commander"; : INPUT a$: IF a$ = "" GOTO who4
automate:
			city$(5 * (s - 1) + i) = a$
			matrix(s, i) = victory(s): GOTO foun
oldskor:
			NEXT i
foun:
			NEXT s
	       
		OPEN "O", 1, "hiscore.cws"
		FOR s = 1 TO 2
			FOR i = 1 TO 5
			WRITE #1, city$(5 * (s - 1) + i), matrix(s, i)
			NEXT i
		NEXT s: CLOSE #1: PRINT "Game Over": DO WHILE INKEY$ = "": LOOP: pcode = 1
END SUB