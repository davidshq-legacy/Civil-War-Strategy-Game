SUB smarts
CALL events
slush = 0: who = 3 - side
c = 9: IF side = 1 THEN c = 15
LOCATE 1, 1: PRINT SPACE$(80);
COLOR c: LOCATE 1, 10: PRINT force$(who); " Side is making decisions";
CALL starfin(star, fin, who)

'                       Check Supply
FOR i = star TO fin: IF armyloc(i) > 0 AND supply(i) < 1 THEN CALL resupply(i)
NEXT i

'                       Fortify Capital or Other City
cost = 200
IF cost > cash(who) GOTO signup

target = 0: IF occupied(capcity(who)) = 0 OR fort(capcity(who)) > 1 GOTO city2
target = capcity(who)
IF cityp(target) = who GOTO capital ELSE GOTO city2
IF target > 0 GOTO capital

city2:
IF 1 + RND < bold + aggress! GOTO signup
target = 0: FOR i = star TO fin
x = armyloc(i): IF x = 0 OR armymove(occupied(x)) < 0 OR armymove(i) < 0 GOTO endlook
IF fort(x) > 1 GOTO endlook
	CALL void(x, defend): IF defend > armysize(i) THEN target = armyloc(i): GOTO capital
endlook:
NEXT i

capital:
	IF target = 0 GOTO signup
	IF fort(target) > 1 GOTO signup
	fort(target) = fort(target) + 1
	x = occupied(target): armymove(x) = -1
	cash(who) = cash(who) - cost
	CALL clrbot: PRINT city$(target); " fortifications increased to "; fort(target);
	CALL icon(target, 0, 6)
	CALL showcity
	IF who = 1 AND navysize(1) < 1 AND RND > .5 AND cash < 222 GOTO signup
	IF 3 * RND > 1 + aggress! AND cash(who) >= cost GOTO city2

'                       Recruit New Armies
signup:
IF who = 1 AND navysize(1) < 1 AND cash(1) > 100 THEN CALL navy(1, 1): IF cash(who) < 100 GOTO isok
GOSUB enufarmies
IF x > 2 + 3 * side + 3 * RND GOTO isok
IF navysize(who) < 5 AND cash(who) > 100 AND navyloc(who) <> 99 THEN IF cityp(navyloc(who)) = who THEN slush = slush + 100: cash(who) = cash(who) - 100: IF cash(who) < 100 GOTO isok
CALL recruit(who)

'                         Naval Commands
isok:
	cash(who) = cash(who) + slush
dock:
	IF side = 2 AND navyloc(1) = 0 AND navysize(1) < 1 AND cityp(30) = 1 AND cash(1) > 100 THEN navyloc(1) = 30: CALL navy(1, 1): GOTO movenavy
	IF navyloc(who) = 99 THEN
		IF RND < .9 THEN CALL navy(who, 3)
		GOTO movearmy
	END IF
	IF cash(who) < 100 OR navysize(who) > 9 OR cityp(navyloc(who)) <> who GOTO movenavy
	CALL navy(who, 1)

movenavy:
	IF navysize(who) = 0 THEN navyloc(who) = 0
	IF navyloc(who) = 0 GOTO movearmy

'                     move ships & prohibit further action this turn
	IF navyloc(who) <> 99 THEN
		IF cityp(navyloc(who)) = who THEN CALL navy(who, 3): GOTO movearmy   'move ships & prohibit further action this turn
		IF cityp(navyloc(who)) = 0 THEN CALL navy(who, 3): GOTO movearmy
	ELSE
		IF RND < .5 THEN CALL navy(who, 3)
		GOTO movearmy
	END IF

	IF cityp(navyloc(who)) <> who THEN
		IF occupied(navyloc(who)) = 0 OR RND > .3 THEN
			CALL navy(who, 2) 'attack
		ELSE
			CALL navy(who, 3) 'move
		END IF
	END IF

'                       Give Move Orders to Each Army
movearmy:
	CALL ships

'                               Check to Combine
a = who: CALL combine(a)
CALL railroad(who)

'                               Top Priority
FOR i = star TO fin
target = armyloc(i)
IF armyloc(i) < 1 OR armymove(i) < 0 GOTO deadman
x = armysize(i): IF supply(i) < 1 AND RND > .1 GOTO deadman

choose = 0

CALL void(target, defend)

IF defend > 0 AND target = capcity(who) AND occupied(target) = i GOTO deadman   'hold capital
IF target <> capcity(who) GOTO nocap
IF vicflag(5) = 0 GOTO nocap
	FOR j = 1 TO 6
	k = matrix(target, j): IF j = 0 GOTO nocap
	CALL void(k, flag): IF flag > 0 GOTO deadman
	NEXT j
nocap:
CALL evaluate(i, best): IF best = 0 GOTO deadman
move9:
	IF best = 0 THEN choose = 1 + INT((j - 1) * RND)
	IF choose = 0 THEN choose = best
	armymove(i) = matrix(target, choose)

	IF cityp(armymove(i)) = who THEN y = occupied(armymove(i)): IF y > 0 THEN IF armymove(y) = x THEN armymove(i) = 0: GOTO deadman  ' eliminate crossing moves
	IF month = 1 AND jancam = 0 AND cityp(armymove(i)) <> who THEN armymove(i) = 0: GOTO deadman

	IF turbo! > 1 THEN
		COLOR c: CALL clrbot
		PRINT armyname$(i); " plans to move from "; city$(armyloc(i)); " to "; city$(armymove(i));
	END IF
		CALL icon(armyloc(i), armymove(i), 1)
		CALL icon(armyloc(i), armymove(i), 9)
	CALL TICK(turbo! - 1)
	PUT (cityx(armyloc(i)) - 20, cityy(armyloc(i)) - 19), image, PSET
deadman:
NEXT i
	FOR i = star TO fin
	IF armymove(i) = 0 AND armyexper(i) < 6 AND armyexper(i) < armylead(i) THEN
		armyexper(i) = armyexper(i) + 1

		IF turbo! > 1 THEN
		CALL clrbot
			PRINT armyname$(i); " has drilled to reach experience level "; armyexper(i);
		END IF
		armymove(i) = -1
		CALL TICK(turbo! - 1)
	END IF
	NEXT i
EXIT SUB

enufarmies:
CALL starfin(star, fin, 3 - who)
FOR i = star TO fin
	IF armyloc(i) > 0 THEN y = y + .1 * armysize(i)
NEXT i
CALL starfin(star, fin, who)
x = 0: z = 0: FOR i = star TO fin: IF armyloc(i) > 0 THEN x = x + 1: z = z + .1 * armysize(i)
NEXT i
IF y > z THEN x = x - 2
IF y > 2 * z THEN x = 0
RETURN
END SUB
