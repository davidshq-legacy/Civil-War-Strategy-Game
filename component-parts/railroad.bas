SUB railroad (who)
SELECT CASE rr(who)
	CASE 0
	IF who = side GOTO human
	CALL starfin(star, fin, who): max = 32767
	index = 0
	FOR i = star TO fin: IF armyloc(i) = 0 OR armymove(i) <> 0 GOTO puter
	x = 0: FOR j = 1 TO 6: from = matrix(armyloc(i), j): IF from > 0 AND cityp(from) <> who THEN x = x + 1
	NEXT j
	IF occupied(capcity(who)) > 0 AND x > 1 GOTO puter
	CALL void(armyloc(i), defend)
	IF vicflag(5) > 0 AND occupied(capcity(who)) = 0 THEN IF defend > max THEN defend = max - 1
	IF defend < max THEN target = armyloc(i): GOSUB route: IF x > 1 THEN max = defend: index = i
puter:  NEXT i
	IF index = 0 OR max > .3 * armysize(index) GOTO toot
	CALL traincapacity(who, limit)
	IF armysize(index) > limit THEN GOTO toot
	from = armyloc(index)
	x1 = 0: FOR i = 1 TO 40: IF cityp(i) <> who GOTO puted
	CALL void(i, defend): IF defend = 0 OR defend > 3 * armysize(index) GOTO puted
	IF occupied(i) > 0 GOTO puted
	target = i
	GOSUB route: IF x = 0 GOTO puted
	IF side = 1 AND cityy(i) < cityy(from) THEN x1 = i
	IF side = 2 AND cityy(i) > cityy(from) THEN x1 = i
	IF fort(i) > 0 AND occupied(i) = 0 THEN x1 = i: EXIT FOR
puted:  NEXT i
	IF vicflag(5) > 0 AND occupied(capcity(who)) = 0 THEN
		GOSUB route
		IF x > 0 THEN
			CALL void(capcity(who), defend)
			IF defend > 0 THEN x1 = capcity(who)
		END IF
	END IF
	IF x1 > 0 GOTO haul ELSE GOTO toot
human:
	CALL movefrom(index, a): IF a < 1 OR index < 1 THEN COLOR 11: CALL clrbot: PRINT "Railroad move not allowed"; : GOTO toot
	x = 1: IF index > 20 THEN x = 2
	CALL traincapacity(who, limit)
	IF armysize(index) > limit THEN CALL clrbot: PRINT "Too many troops for railroad capacity"; : GOTO toot
	
	target = armyloc(index): GOSUB route: IF x > 1 GOTO aboard
	CALL clrbot: PRINT "Track from "; city$(target); " is blocked"; : GOTO toot
aboard:
	CALL clrbot: PRINT "Select destination for "; armyname$(index); " from "; city$(target);
	mtx$(0) = "To": from = target: x1 = from: IF from = 0 GOTO toot
	CALL newcity(x1): IF x1 = from OR x1 = 0 GOTO toot

	target = x1: GOSUB route: IF x > 1 GOTO haul
	CALL clrbot: PRINT armyname$(index); "'s train cannot go to "; city$(x1); " - select another city"; : CALL TICK(9)
	GOTO aboard
haul:
	COLOR 11: CALL clrbot: PRINT armyname$(index); " is taking the train from "; city$(from); " to "; city$(x1);
	tracks(who) = armyloc(index)
	from = armyloc(index)
	rrfrom(who) = from
	rr(who) = index: armyloc(index) = 0: armymove(index) = x1
	CALL tinytrain(who, 1)
	IF noise > 0 THEN SOUND 2222, 1
	CALL engine

	CALL occupy(from)
       IF occupied(from) > 0 THEN CALL placearmy(occupied(from))
	GOTO toot

	CASE IS > 0
	CALL tinytrain(who, 0)
	CALL occupy(rrfrom(who))
	IF occupied(rrfrom(who)) > 0 THEN CALL placearmy(occupied(rrfrom(who)))

	index = rr(who)
	tracks(who) = armymove(index)
	CALL tinytrain(who, 1)

	rr(who) = 0: armyloc(index) = armymove(index): armymove(index) = -1
	COLOR 11: CALL clrbot: PRINT "Train with "; armyname$(index); " has arrived in "; city$(armyloc(index)); : IF noise > 0 THEN SOUND 1200, 2
	CALL TICK(turbo!)
	x = cityx(armyloc(index)) - 12: y = cityy(armyloc(index)) - 11
	LINE (x - 9, y - 8)-(x + 10, y + 8), 2, BF
	IF cityp(armyloc(index)) <> who THEN CALL capture(index, armyloc(index), who, 0)
	CALL placearmy(index)
	IF occupied(armyloc(index)) > 0 THEN CALL stax(who): GOTO toot
	CALL occupy(armyloc(index)): CALL placearmy(index)
	GOTO toot
END SELECT

route:
	x = 0: FOR j = 1 TO 6
	y = matrix(target, j)
	IF y > 0 AND cityp(y) = who THEN
	x = x + 1
		FOR m = 1 TO 6
		z = matrix(y, m)
		IF z > 0 AND z <> target AND cityp(z) = who THEN x = x + 1
		NEXT m
	END IF
NEXT j
RETURN

toot:
	IF who = side THEN CALL TICK(9)
	CALL clrrite
	clrbot
END SUB