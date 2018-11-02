SUB battle (attack, defend, win, lose)
IF armysize(defend) < 1 THEN armysize(defend) = 1
IF armysize(attack) < 1 THEN armysize(attack) = 1

CALL icon(armyloc(defend), 0, 9)
LOCATE 1, 1: PRINT SPACE$(80)
CALL clrrite: y = 68: COLOR 11: LOCATE 1, y: PRINT "Attacker"
c = 9: IF attack > 20 THEN c = 7
COLOR c: LOCATE 2, y: PRINT armyname$(attack)
LOCATE 3, y: CALL strong(attack)
x = .01 * armysize(attack): IF x > TCR THEN x = TCR
LOCATE 4, y: PRINT "Base    "; x
IF armysize(attack) / armysize(defend) > .2 THEN x = x + .3 * armylead(attack) + .3 * armyexper(attack): IF x > TCR THEN x = TCR
IF armyexper(attack) > 8 THEN x = x + 1: IF x > TCR THEN x = TCR
LOCATE 5, y: PRINT "Ldr/Exp "; x
IF armysize(attack) < 15 THEN x = .5 * x: IF x > TCR THEN x = TCR
LOCATE 6, y: PRINT "Small   "; x
IF armysize(attack) / armysize(defend) <= .5 THEN x = x - 2: IF x < 1 THEN x = 1
IF armysize(attack) / armysize(defend) > 3 THEN x = x + 2: IF x > TCR THEN x = TCR
IF armysize(attack) / armysize(defend) > 10 THEN x = TCR
IF armysize(attack) / armysize(defend) <= .2 THEN x = 1
LOCATE 7, y: PRINT "Outman  "; x
IF supply(attack) < 1 THEN x = .5 * x: COLOR 13
LOCATE 8, y: PRINT "Supply  "; x: COLOR c
IF x < 1 THEN x = 1
'                       Adjust attack advantage
IF attack < 21 AND side = 2 AND difficult > 3 THEN x = x + 2 * difficult - 6
IF attack > 20 AND side = 1 AND difficult < 3 THEN x = x + 6 - 2 * difficult
LOCATE 9, y: PRINT "Difclt  "; x
IF x > TCR THEN x = TCR
COLOR 11: LOCATE 11, y: PRINT "Attack  "; x
LINE (530, 155)-(635, 175), 11, B

x1 = .013 * armysize(defend) + 1: IF realism = 1 THEN x1 = .02 * armysize(defend) + 2: IF x1 > 20 THEN x1 = 20
LOCATE 13, y: PRINT "Defender"
COLOR 16 - c: LOCATE 14, y: PRINT armyname$(defend)
LOCATE 15, y: CALL strong(defend)
LOCATE 16, y: PRINT "Base    "; INT(.01 * armysize(defend))
LOCATE 17, y: PRINT "Defense "; x1
IF armysize(defend) / armysize(attack) > .2 THEN x1 = x1 + .3 * armylead(defend) + .3 * armyexper(defend): IF x1 > TCR THEN x1 = TCR
IF armyexper(defend) > 8 THEN x1 = x1 + 1: IF x1 > TCR THEN x1 = TCR
LOCATE 18, y: PRINT "Ldr/Exp "; x1
IF armysize(defend) < 15 THEN x1 = .5 * x1
LOCATE 19, y: PRINT "Small   "; x1

R! = armysize(defend) / armysize(attack)
SELECT CASE R!
	CASE IS > 10
		x1 = TCR
	CASE IS > 1.5
		x1 = x1 + 2
	CASE IS < .5
		x1 = .8 * x1
	CASE IS < .2
		x1 = .5 * x1
END SELECT
	IF x1 < 1 THEN x1 = 1
	IF x1 > TCR THEN x1 = TCR

LOCATE 20, y: PRINT "Outman  "; x1
IF supply(defend) < 1 THEN x1 = .5 * x1: COLOR 13
LOCATE 21, y: PRINT "Supply  "; x1: COLOR 16 - c
IF x1 < 1 THEN x1 = 1
'                       Adjust defend advantage
IF defend < 21 AND side = 2 AND difficult > 3 THEN x1 = x1 + 2 * difficult - 6
IF defend > 20 AND side = 1 AND difficult < 3 THEN x1 = x1 + 6 - 2 * difficult
LOCATE 22, y: PRINT "Difclt  "; x1

a$ = "Fort": IF armymove(defend) = 0 THEN x1 = x1 * (1 + fort(armyloc(defend)))
IF x1 > TCR THEN x1 = TCR
IF fort(armyloc(defend)) > 0 AND armymove(defend) = 0 THEN
	COLOR 13: a$ = "Fort+"
	IF fort(armyloc(defend)) = 2 THEN a$ = "Fort++"
END IF
LOCATE 23, y: PRINT a$; TAB(76); x1
IF x1 > TCR THEN x1 = TCR
COLOR 11: LOCATE 25, y: PRINT "Defend  "; x1
LINE (530, 380)-(635, 400), 11, B

spin = 0
scale = x: IF x1 > scale THEN scale = x1
scale = scale + 1

odds! = x / (x + x1): a = INT(100 * odds!): IF a < 1 THEN a = 1
a$ = LTRIM$(RTRIM$(STR$(a))) + "%"
COLOR 14: LOCATE 27, y: PRINT "Odds:  "; a$;
LINE (530, 412)-(635, 435), 14, B
LINE (528, 410)-(637, 437), 14, B
DO WHILE INKEY$ = "": LOOP
IF graf > 2 THEN
	CALL cannon
	k = fort(armyloc(defend))
	t$ = "fort" + LTRIM$(STR$(k)) + ".vga"
	IF _FILEEXISTS(t$) THEN
		DEF SEG = VARSEG(graphic(1))
		BLOAD t$, VARPTR(graphic(1))
		DEF SEG
		PUT (550, 270), graphic, PSET
	END IF
ELSE
	CALL clrrite
END IF
FOR i = 1 TO 2: IF supply(i) > 0 THEN supply(i) = supply(i) - 1
NEXT i

grapple:
hit = 0: hit1 = 0
star = scale * RND: fin = scale * RND
IF noise > 0 THEN SOUND 77, .5: SOUND 59, .5: CALL TICK(.1)
IF star <= x THEN hit = 1
IF fin <= x1 THEN hit1 = 1

IF hit = 0 AND hit1 = 0 GOTO grapple
IF hit = 1 AND hit1 = 1 GOTO grapple
win = defend: lose = attack: IF hit = 1 THEN win = attack: lose = defend

a$ = "UNION": IF win > 20 THEN a$ = "REBEL"
COLOR 14: LOCATE 3, 68: PRINT a$; " VICTORY"
LOCATE 4, 71: PRINT "in"
LOCATE 5, 69: PRINT city$(armyloc(defend))
a = 1: IF win > 20 THEN a = 2
CALL flags(a, 0, 0)
CALL clrbot: COLOR 11: PRINT armyname$(win); " defeats "; armyname$(lose); " in "; city$(armyloc(defend)); : CALL TICK(9)

pct! = .01 * DEFAC - .03 * fort(armyloc(defend)): IF win = attack THEN pct! = 1.3 * pct!
SELECT CASE armysize(defend)
	CASE IS > 300
		pct! = .9 * pct!
	CASE IS > 800
		pct! = .8 * pct!
END SELECT
xbar = armysize(attack) * pct!
vary = xbar * (1 - pct!)
CALL normal(xbar, vary, killd)

pct! = .01 * ATKFAC + .02 * fort(armyloc(defend)): IF win = defend THEN pct! = 1.5 * pct!
SELECT CASE armysize(attack)
	CASE IS > 300
		pct! = .9 * pct!
	CASE IS > 800
		pct! = .8 * pct!
END SELECT
xbar = armysize(defend) * pct!
vary = xbar * (1 - pct!)
CALL normal(xbar, vary, killa)

killa = .8 * killa + .2 * killd: IF killa < 1 THEN killa = 1
killd = .8 * killd + .2 * killa: IF killd < 1 THEN killd = 1
IF killa > 9 * killd THEN killa = 9 * killd
IF killd > 5 * killa THEN killd = 5 * killa

IF killa >= armysize(attack) THEN killa = armysize(attack) - 1
IF killd >= armysize(defend) THEN killd = armysize(defend) - 1

x = INT(100 * odds!): IF x < 1 THEN x = 1
a$ = LTRIM$(RTRIM$(STR$(x))) + "%"

COLOR c
LOCATE 1, 1: PRINT "Attack Loss: ";
PRINT LTRIM$(RTRIM$(STR$(killa)) + "00"); "/";
CALL strong(attack)
PRINT " ("; LTRIM$(RTRIM$(STR$(INT(100 * (killa / armysize(attack)))))); "%) |";
COLOR 16 - c: PRINT "| Defend Loss: "; : PRINT LTRIM$(RTRIM$(STR$(killd)) + "00"); "/";
CALL strong(defend)
PRINT " ("; LTRIM$(RTRIM$(STR$(INT(100 * (killd / armysize(defend)))))); "%)"

mtx$(1) = " (" + LTRIM$(RTRIM$(STR$(killa) + "00")) + "/" + LTRIM$(STR$(armysize(attack)) + "00") + ") "
t$ = " (" + LTRIM$(RTRIM$(STR$(killd) + "00")) + "/" + LTRIM$(STR$(armysize(defend)) + "00") + ")"
mtx$(2) = t$
IF win = defend THEN mtx$(2) = mtx$(1): mtx$(1) = t$
mtx$(3) = "*" + armyname$(win): mtx$(4) = armyname$(lose)
IF win = defend THEN mtx$(3) = armyname$(win): mtx$(4) = "*" + armyname$(lose)
a$ = city$(armyloc(defend)) + ": " + mtx$(3) + mtx$(1) + " defeats " + mtx$(4) + mtx$(2)
CALL scribe(a$, 0)

IF player = 1 AND (side = 1 AND attack > 20) OR (side = 2 AND attack < 21) THEN
COLOR 14: CALL clrbot: PRINT "hit any key to continue"; : DO WHILE INKEY$ = "": LOOP
END IF

armysize(attack) = armysize(attack) - killa
armysize(defend) = armysize(defend) - killd
IF armysize(defend) < 1 THEN armysize(defend) = 1

s = 1: IF attack > 2 THEN s = 2
casualty&(s) = casualty&(s) + killa
casualty&(3 - s) = casualty&(3 - s) + killd

s = 1: IF win > 20 THEN s = 2
batwon(s) = batwon(s) + 1
victory(s) = victory(s) + 1
CALL icon(armyloc(defend), 0, 8)
END SUB

SUB combine (who)
	colour = 3: target = 0: hilite = 3
	tlx = 67: tly = 2
	CALL starfin(star, fin, who)
	size = 0
	FOR i = 1 TO 40
		IF cityp(i) = who AND occupied(i) > 0 THEN
			FOR j = star TO fin
			IF armyloc(j) = i AND occupied(i) <> j AND armymove(j) = 0 THEN size = size + 1: mtx$(size) = city$(i): array(size) = i: EXIT FOR
			NEXT j
		END IF
	NEXT i
	
	IF size = 0 THEN who = -1: EXIT SUB
	CALL bubble(size)

	IF who <> side THEN choose = 1 + INT(size * RND): GOTO join
	mtx$(0) = "Join"
		choose = 31: hilite = 11
		CALL menu(9): CALL clrrite
join:
		IF choose < 1 GOTO nocity2
		target = array(choose)
		CALL clrbot: PRINT "Combining "; force$(who); " armies in "; city$(target); :  CALL TICK(turbo!)

		armysize(0) = 0: armylead(0) = 0: armyexper(0) = 0: armyloc(0) = target
		armyname$(0) = "": supply(0) = 0: armymove(0) = 0

		best = 0: x = 0: spin = 0
		FOR j = star TO fin
		IF armymove(j) <> 0 OR armyloc(j) <> target OR armysize(j) = 0 GOTO dork1
		IF armysize(0) + armysize(j) > 1250 THEN CALL clrbot: PRINT "Cannot combine "; armyname$(j); "... TOO LARGE"; : CALL TICK(turbo!): GOTO dork1

		IF armylead(j) > x THEN
			x = armylead(j)
			armyname$(0) = armyname$(j)
			armylead(0) = armylead(j)
			best = j
		END IF

		armysize(0) = armysize(0) + armysize(j)
		IF armysize(0) < 1 GOTO dork1
		pct! = (armysize(j) / armysize(0))
		spin = spin + 1
		armyexper(0) = (1 - pct!) * armyexper(0) + pct! * armyexper(j)
		CALL clrbot: PRINT armyname$(j); " is combining his "; : CALL strong(j): PRINT " forces"; : CALL TICK(turbo!)
		supply(0) = supply(0) + supply(j)
		IF supply(0) > 10 THEN supply(0) = 10
		armysize(j) = 0: armyloc(j) = 0: armyexper(j) = 0: armymove(j) = 0
		lname$(j) = armyname$(j)
		armylead(j) = 0: supply(j) = 0: armyname$(j) = ""
dork1:
		NEXT j

		CALL clrbot
		IF who <> side AND spin = 0 THEN EXIT SUB
		IF spin = 0 THEN
				PRINT "No valid armies to combine at this time in "; city$(target);
				TICK turbo!
				EXIT SUB
		END IF
		armysize(best) = armysize(0): armylead(best) = armylead(0)
		armyexper(best) = armyexper(0): supply(best) = supply(0)
		armyloc(best) = target
		armyname$(best) = armyname$(0)
		lname$(best) = ""
		IF spin > 1 THEN
		PRINT "New army "; best; " of "; : CALL strong(best): PRINT " is commanded by "; armyname$(best);
		armymove(best) = -1
		ELSE
		PRINT "Only 1 eligible army -- cannot combine at this time";
		END IF
		IF who = side THEN CALL TICK(turbo!)
		IF noise > 0 THEN SOUND 4000, .7
	       
		CALL showcity
		CALL placearmy(best)
		CALL icon(target, 0, 6)
		occupied(target) = best
		CALL stax(who)
nocity2:
END SUB