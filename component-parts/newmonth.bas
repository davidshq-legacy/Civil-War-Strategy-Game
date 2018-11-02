newmonth:
IF side > 2 THEN side = 1
a$ = "--------> EVENTS FOR " + month$(month) + " " + STR$(year) + " --------"
CALL scribe(a$, 0)
CALL tupdate
control(1) = 0: control(2) = 0

FOR i = 1 TO 2
income(i) = 0
IF cash(i) > 19999 THEN cash(i) = 19999
IF cash(i) < 0 THEN cash(i) = 0
NEXT i
IF player = 1 AND side = 2 THEN income(1) = income(1) + usadv

FOR i = 1 TO 40
IF cityp(i) > 0 THEN x = cityp(i): control(x) = control(x) + 1: income(x) = income(x) + cityv(i)
armymove(i) = 0
NEXT i

FOR i = 1 TO 2: navymove(i) = 0: IF capcity(i) > 0 THEN income(i) = income(i) + 100
cash(i) = cash(i) + income(i)
IF commerce > 0 AND i <> commerce THEN cash(i) = cash(i) - raider
NEXT i
vptotal = income(1) + income(2)

chosit = 22
IF player = 2 THEN GOSUB blanken: CALL usa
CALL victor
ON ERROR GOTO 0
IF pcode > 0 THEN
	FOR k = 1 TO 40: armyloc(k) = 0: NEXT k
	GOTO newgame
END IF