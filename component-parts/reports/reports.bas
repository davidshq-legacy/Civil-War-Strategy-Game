SUB report (who)
DIM summ(40)
IF who = -1 GOTO frep
IF who > 100 GOTO batrep
mtx$(0) = "Information"
mtx$(1) = force$(side) + " Armies"
mtx$(2) = force$(3 - side) + " Armies"
mtx$(3) = "Cities"
mtx$(4) = "Force Summary"
mtx$(5) = "Intelligence"
mtx$(6) = "Battles": size = 6
IF _FILEEXISTS("cws.his") THEN mtx$(7) = "Recap": size = 7
CALL menu(0)
SELECT CASE choose
CASE IS < 0
	CLS
	CALL usa
	EXIT SUB
CASE 2: who = 3 - side
CASE 3: GOTO cityrep
CASE 4: GOTO frep
CASE 5: GOTO srep
CASE 6: GOTO batrep
CASE 7: GOTO recap
CASE ELSE
END SELECT

'                               Army Report
IF choose < 0 GOTO endrep
IF choose = 4 GOTO frep
CALL starfin(star, fin, who)
CLS : LOCATE 1, 1: c = 9: IF who = 2 THEN c = 15
COLOR c
PRINT " Report for "; force$(who); " Forces"; TAB(30); month$(month); ","; year; TAB(49); : COLOR 14: PRINT " Victory Points "; victory(who);
IF c = 15 THEN c = 7
x = victory(who) + victory(3 - who)
IF x = 0 THEN
	PRINT
ELSE
	y = (victory(who) / x) * 100
	PRINT "("; y; " %)";
END IF
CALL armyxy(215, 8, who)
COLOR c: PRINT control(who); "/ 40"; TAB(15); "CITIES CONTROLLED"; TAB(40); : PRINT "("; : x = INT(control(who) * 2.5 + .5): PRINT x; "%)";
PRINT TAB(50); : COLOR 12: PRINT "Capital: "; city$(capcity(who))
y = vptotal: IF capcity(1) > 0 THEN y = y + 100
IF capcity(2) > 0 THEN y = y + 100
PRINT income(who); "/"; y; TAB(15); "INCOME"; TAB(40); "("; : x = (income(who) / vptotal) * 100: PRINT x; "%)   "; : COLOR 14: PRINT "Cash:"; cash(who)
COLOR 11: PRINT " #      Name             Size  Location   Ldr Exp Suply Move To"
x = 0: FOR i = star TO fin
COLOR c
IF armyloc(i) < 1 GOTO deadeye
x = x + armysize(i)
PRINT i; TAB(5); armyname$(i); TAB(25); : y = CSRLIN
CALL strong(i): PRINT TAB(32); city$(armyloc(i));
IF who <> side THEN PRINT : GOTO deadeye
PRINT TAB(43); armylead(i); TAB(47); armyexper(i); TAB(52); supply(i);
PRINT TAB(57); : IF armymove(i) > -1 THEN PRINT city$(armymove(i)) ELSE PRINT "Resting"
IF fort(armyloc(i)) > 0 THEN LOCATE y, 68: PRINT "FORT +"; fort(armyloc(i))
deadeye:
NEXT i
PRINT " "; STRING$(70, "-")
PRINT " Total Forces "; TAB(25); LTRIM$(STR$(x)); "00"; TAB(40); "[ Enemy Forces "; LTRIM$(STR$(INT(aggress! * x))); "00 ]"
PRINT " "; STRING$(70, "-")
PRINT " "; force$(who); " NAVY has "; navysize(who); " ship(s) ";
x = 0
FOR k = 1 TO navysize(who)
	IF MID$(fleet$(who), k, 1) = "I" THEN x = x + 1
NEXT k
IF x > 0 THEN PRINT "("; x; "Ironclads) ";
IF navyloc(who) > 0 AND navyloc(who) < 99 THEN PRINT "in "; city$(navyloc(who)) ELSE PRINT
IF rr(who) > 0 THEN COLOR 14: PRINT " Army #"; rr(who); armyname$(rr(who)); " on train to "; city$(armymove(rr(who)));
LINE (0, 0)-(639, 449), 15, B
LINE (0, 62)-(639, 62), 15
GOTO endrep

cityrep: ' City Report
CLS : LOCATE 1, 1: COLOR 14
PRINT "City Report"; TAB(20); month$(month); ","; year: COLOR 15
PRINT " #    City       Control   Value"; TAB(41); " #    City       Control   Value"
LINE (1, 30)-(630, 30), 15
FOR i = 1 TO 20: COLOR 4: a$ = "neutral": IF cityp(i) = 1 THEN COLOR 9: a$ = "UNION"
IF cityp(i) = 2 THEN COLOR 7: a$ = "REBEL"
LOCATE 2 + i, 1: PRINT i; TAB(6); city$(i); TAB(18); a$; TAB(29); cityv(i)
NEXT i

FOR i = 21 TO 40: COLOR 4: a$ = "neutral": IF cityp(i) = 1 THEN COLOR 9: a$ = "UNION"
IF cityp(i) = 2 THEN COLOR 7: a$ = "REBEL"
LOCATE i - 18, 41: PRINT i; TAB(46); city$(i); TAB(58); a$; TAB(69); cityv(i)
NEXT i
LINE (1, 360)-(630, 360), 15
COLOR 9: LOCATE 24, 1: PRINT "Side    No. Cities   Income    Cash"
COLOR 9: PRINT force$(1); TAB(12); control(1); TAB(23); income(1); TAB(32); cash(1)
COLOR 7: PRINT force$(2); TAB(12); control(2); TAB(23); income(2); TAB(32); cash(2)
COLOR 4: PRINT force$(0); TAB(12); 40 - control(1) - control(2)
LINE (1, 382)-(630, 382), 15
GOTO endrep

srep:' Intelligence
c = 9: IF side = 2 THEN c = 7
CALL usa
CALL starfin(star, fin, side)
FOR k = star TO fin
	IF armysize(k) > 0 THEN
	COLOR c
	x = cityx(armyloc(k))
	y = cityy(armyloc(k))
	z = 10: IF armysize(k) < 1000 THEN z = 9
	x = x / 8 - 2: y = y / 16
	IF y > 26 THEN y = 26
	FOR j = 0 TO 3
	LOCATE y + j, x: PRINT SPACE$(z);
	NEXT j
	LOCATE y, x: PRINT "Siz:"; : CALL strong(k)
	LOCATE y + 1, x: PRINT "Ldr:"; armylead(k)
	LOCATE y + 2, x: PRINT "Xpr:"; armyexper(k)
	LOCATE y + 3, x: PRINT "Sup:"; supply(k);
	LINE (8 * (x - 1) - 1, 16 * (y - 1) - 1)-(8 * (x + z - 1) + 1, 16 * (y + 3) + 1), 15, B
	TICK 1
END IF
NEXT k
GOTO endrep

frep: ' Force Summary
FOR k = 1 TO 40
	IF occupied(k) > 0 THEN
		FOR j = 1 TO 40
		IF armyloc(j) = k THEN summ(k) = summ(k) + armysize(j)
		NEXT j
	END IF
NEXT k

CLS : CALL usa
FOR k = 1 TO 40
IF summ(k) > 0 THEN
	c = 9: IF cityp(k) = 2 THEN c = 7
	COLOR c
	LOCATE INT(cityy(k) / 16 + 1), cityx(k) / 8: PRINT summ(k)
END IF
NEXT k
COLOR 14: LOCATE 1, 20: PRINT "Total Forces in Cities (100's)"
GOTO endrep

batrep: ' Battle Report
VIEW (200, 123)-(400, 284)
CLS 1
VIEW
LINE (200, 123)-(400, 284), 15, B
COLOR 14
LOCATE 9, 32: PRINT "BATTLE SUMMARY"
CALL armyxy(320, 160, 1)
CALL armyxy(370, 160, 2)
LINE (200, 176)-(400, 230), 15, B
LINE (200, 230)-(400, 284), 15, B
LINE (290, 176)-(345, 284), 15, B
LOCATE 13, 27: PRINT "BATTLES"
LOCATE 14, 27: PRINT "WON"
LOCATE 16, 27: PRINT "MEN LOST"
LOCATE 17, 27: PRINT "(1000's)"
LOCATE 14, 38: PRINT batwon(1)
LOCATE 14, 45: PRINT batwon(2)
LOCATE 17, 38: PRINT INT(.1 * casualty&(1))
LOCATE 17, 45: PRINT INT(.1 * casualty&(2))
IF history > 0 AND who > 2 THEN
	OPEN "O", #1, "battsumm"
	PRINT #1, " SIDE      BATTLES WON       LOSSES"
	FOR k = 1 TO 2
	a$ = " ": IF thrill = k THEN a$ = "*"
	PRINT #1, a$; force$(k), batwon(k), 100 * casualty&(k)
	NEXT k
	CLOSE #1
END IF
GOTO endrep

recap: ' Recap History
CLS : x = 0
OPEN "I", 2, "cws.his"
DO WHILE NOT EOF(2)
INPUT #2, a$
COLOR 7: IF INSTR(a$, "[") THEN COLOR 15
IF INSTR(a$, ">") THEN COLOR 14
IF INSTR(a$, "..") THEN COLOR 11
IF INSTR(a$, "!") THEN COLOR 12
LOCATE 29, 1: PRINT a$
x = x + 1
IF x > 27 THEN TICK .4
LOOP
CLOSE #2

endrep:
COLOR 14: LOCATE 29, 29: PRINT "press a key";
DO WHILE INKEY$ = "": LOOP
IF who < 3 THEN
	CLS
	CALL usa
END IF
END SUB
