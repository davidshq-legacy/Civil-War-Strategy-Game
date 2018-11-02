SUB relieve (who)
colour = 3: target = 0: hilite = 3
tlx = 67: tly = 2
CALL starfin(star, fin, who)
size = 0
FOR i = star TO fin
IF armysize(i) > 0 AND armyloc(i) > 0 AND armymove(i) = 0 THEN
	size = size + 1
	mtx$(size) = armyname$(i)
	IF LEN(mtx$(size)) > 11 THEN mtx$(size) = LEFT$(mtx$(size), 11)
	array(size) = i
END IF
NEXT i

IF size = 0 THEN EXIT SUB
CALL bubble(size)
mtx$(0) = "Relieve"
choose = 31: hilite = 11
CALL menu(6): CALL clrrite

IF choose < 1 THEN EXIT SUB
index = array(choose)
CALL icon(armyloc(index), 0, 9)

t$ = armyname$(index)
lname$(index) = t$

size = 0
FOR i = star TO fin
IF lname$(i) <> "" THEN
	size = size + 1
	mtx$(size) = lname$(i)
	IF LEN(mtx$(size)) > 11 THEN mtx$(size) = LEFT$(mtx$(size), 11)
	array(size) = i
END IF
NEXT i
CALL bubble(size)

have2:
mtx$(0) = "New Leader"
tlx = 67: tly = 2
CALL menu(0): CALL clrrite
IF choose < 1 GOTO have2
armymove(index) = -1
armylead(index) = rating(array(choose))
IF armylead(index) > 0 THEN armylead(index) = armylead(index) - 1
IF armyexper(index) > 0 THEN armyexper(index) = armyexper(index) - 1
COLOR 15: CALL clrbot: PRINT lname$(array(choose)); " has replaced "; t$; " in "; city$(armyloc(index)); : TICK 9
armyname$(index) = lname$(array(choose))
lname$(array(choose)) = ""
CALL icon(armyloc(index), 0, 8)
CALL clrbot
END SUB