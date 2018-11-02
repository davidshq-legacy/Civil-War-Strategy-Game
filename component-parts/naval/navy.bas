SUB navy (who, chx)
DIM hit(2)
IF chx > 0 THEN
	IF navyloc(who) < 1 THEN
		chx = 1
	ELSE
		IF commerce = 3 - who AND raider > 0 THEN chx = 4
		IF grudge > 0 THEN chx = 3
	END IF
END IF
COLOR 11
ahoy:
cost = 100: cityp(0) = who
IF chx = 0 THEN CALL clrbot: PRINT "Funds available "; cash(who);
IF chx = 1 THEN
	IF cash(who) < cost THEN EXIT SUB
	IF navysize(who) > 9 THEN EXIT SUB
END IF
mtx$(0) = "Ships"
mtx$(1) = "Build"
IF navyloc(who) <> 99 THEN
IF cash(who) < cost OR navysize(who) > 9 OR cityp(navyloc(who)) <> who THEN mtx$(1) = "-": choose = 23
END IF
mtx$(2) = "Attack"
IF navyloc(who) <> 99 THEN
IF cityp(navyloc(who)) <> 3 - who THEN mtx$(2) = "-": choose = 22
ELSE
mtx$(1) = "-": mtx$(2) = "-": choose = 24
END IF
mtx$(3) = "Sail": IF navyloc(who) < 1 THEN mtx$(3) = "-": IF chx = 3 THEN chx = 1
mtx$(4) = "Raid": IF navysize(who) < 1 OR commerce = who THEN mtx$(4) = "-"
tlx = 67: tly = 12: size = 4
IF navyloc(who) <> 99 THEN
IF who = 1 AND navysize(who) > 1 AND cityp(navyloc(who)) = 0 THEN size = 5: mtx$(5) = "Invasion": CALL void(navyloc(1), defend): IF chx > 0 AND defend < 100 THEN chx = 5
IF realism = 0 AND who = 2 AND navysize(who) > 1 AND cityp(navyloc(who)) = 0 THEN size = 5: mtx$(5) = "Invasion": CALL void(navyloc(1), defend): IF chx > 0 AND defend < 100 THEN chx = 5
END IF

IF chx > 0 THEN choose = chx: GOTO anchor
IF nflag > 0 AND choose <> 1 THEN EXIT SUB
CALL menu(0): CALL clrrite
anchor:

SELECT CASE choose
	CASE 1 ' Build Ship
	IF cash(who) < cost OR navyloc(who) = 99 GOTO ahoy
	IF chx = 1 AND navysize(who) > 9 THEN EXIT SUB
	IF chx = 0 AND navysize(who) > 9 THEN GOTO ahoy

	IF chx = 0 AND navyloc(who) > 0 THEN
		IF cityp(navyloc(who)) <> who GOTO ahoy
		IF matrix(navyloc(who), 7) < 99 GOTO ahoy
	END IF
	IF chx = 1 AND RND < .07 * navysize(who) THEN EXIT SUB
	a$ = "W"

	IF realism > 0 AND ((year < 1862) OR (year = 1862 AND month < 3)) GOTO noiron
	IF cash(who) >= 2 * cost THEN
		tlx = 67: tly = 12: colour = 9
		IF who = side THEN
			mtx$(0) = "Type"
			mtx$(1) = "Wooden"
			mtx$(2) = "Ironclad"
			size = 2
			CALL menu(0)
			CALL clrrite
			IF choose < 1 GOTO ahoy
			IF choose = 2 THEN a$ = "I": cost = 2 * cost
		ELSE
			a$ = "I"
		END IF
	END IF

noiron:
	navysize(who) = navysize(who) + 1
	IF a$ = "W" THEN
		fleet$(who) = fleet$(who) + a$: a = 1
	ELSE
		fleet$(who) = a$ + fleet$(who): a = 2
	END IF
	IF navysize(who) > 1 GOTO add2ship
ships:
	mtx$(0) = "Port": size = 0: tlx = 67: tly = 12
	FOR i = 1 TO 40: IF matrix(i, 7) = 99 AND cityp(i) = who AND navyloc(3 - who) <> i THEN size = size + 1: mtx$(size) = city$(i): array(size) = i
	NEXT i
	IF chx = 1 THEN choose = 1 + INT(size * RND)
	IF size < 1 THEN
		navysize(who) = 0: fleet$(who) = ""
		IF chx = 0 THEN CALL clrbot: PRINT "NO SHIPYARDS AVAILABLE !"; : EXIT SUB
		IF chx = 1 THEN EXIT SUB
	END IF
	IF chx = 0 THEN CALL menu(9): CALL clrrite

	IF choose < 1 GOTO ships
	navyloc(who) = array(choose)
	cash(who) = cash(who) - cost: navysize(who) = 1
	x = cityx(array(choose)) + 25: y = cityy(array(choose)) + 25: CALL ships
	CALL clrbot: COLOR 11: PRINT force$(who); " is building NEW fleet in "; city$(array(choose));
	PSET (400, 465), 0: CALL shipicon(who, a)
	IF noise > 0 THEN SOUND 3000, 1
	CALL TICK(turbo!)
	GOTO ahoy
add2ship:
	cash(who) = cash(who) - cost
	CALL clrbot: PRINT force$(who); " navy increased to "; navysize(who);
	PSET (400, 465), 0: CALL shipicon(who, a)
	CALL ships
	IF noise > 0 THEN SOUND 3000, 1
	CALL TICK(turbo!)
	CASE 2 ' Attack City
	IF navyloc(who) = 99 GOTO ahoy
	IF chx = 2 AND cityp(navyloc(who)) = who THEN EXIT SUB
	IF chx = 2 AND occupied(navyloc(who)) > 0 AND RND > .5 THEN chx = 3: GOTO anchor
	IF chx = 2 AND cityp(navyloc(who)) = 0 THEN chx = 3: GOTO ahoy
	IF navyloc(who) < 1 THEN EXIT SUB
	IF who = side THEN nflag = 1
	IF cityp(navyloc(who)) <> 3 - who GOTO ahoy
	CALL clrbot: COLOR 12: PRINT force$(who); " fleet bombards "; city$(navyloc(who));
	CALL icon(navyloc(who), 0, 3)
	      
	target = navyloc(who): index = occupied(target): IF index = 0 GOTO deserted
	pct! = .005 * navysize(who) + .02 * RND: killd = armysize(index) * pct!: IF killd < 1 THEN killd = 1
	CALL clrbot: PRINT armyname$(index); " suffered "; 100 * killd; " casualties";
	x = .5 * navysize(who) + 1: IF x > supply(index) THEN x = supply(index)
	supply(index) = supply(index) - x
	CALL TICK(turbo!)
	armysize(index) = armysize(index) - killd: IF armysize(index) < 1 THEN armysize(index) = 1
	EXIT SUB
deserted:
	IF fort(target) = 0 GOTO blast
	IF RND < .7 + .03 * (navysize(who) - fort(target)) GOTO hurt1
	CALL barnacle(who)
	CALL clrbot
	PRINT force$(cityp(target)); " shore battery sunk an attacking ship!"; navysize(who); "ship(s) left! ";
	IF noise > 0 THEN SOUND 77, .5: SOUND 59, .5
	CALL TICK(turbo!)
	IF navysize(who) < 1 THEN
		navyloc(who) = 0: fleet$(who) = "": GOSUB box2
		LOCATE 12, 27: PRINT force$(who); " fleet eliminated"
		CALL TICK(9)
		victory(3 - who) = victory(3 - who) + 5
		IF who = side THEN grudge = 0
		GOTO sail3
	END IF
	GOTO deserted
hurt1:
	CALL clrbot: PRINT city$(target); " fortifications damaged";
	fort(target) = fort(target) - 1: x = cityx(target): y = cityy(target): LINE (x - 5, y - 5)-(x + 5, y + 5), 2, BF
	CALL showcity
	CALL TICK(turbo!)
	EXIT SUB
blast:
	IF RND > .25 + .07 * navysize(who) THEN CALL clrbot: PRINT "Citizens of "; city$(target); " stand firm against the attack"; : CALL TICK(turbo!): EXIT SUB
	IF navyloc(who) = capcity(3 - who) THEN CALL clrbot: PRINT "The CAPITAL steadfastly stands loyal"; : CALL TICK(turbo!): EXIT SUB
	cityp(navyloc(who)) = 0
	CALL clrbot: PRINT city$(navyloc(who)); " is now  NEUTRAL";
	CALL showcity
	victory(who) = victory(who) + cityv(navyloc(who))
	EXIT SUB
	CASE 3  ' Sail
	navysize(who) = LEN(fleet$(who))
	IF navysize(who) < 1 AND chx > 0 THEN EXIT SUB
	IF navyloc(who) < 1 OR navysize(who) < 1 THEN CALL clrbot: PRINT "No ships remain"; : TICK 1: GOTO ahoy

	size = 0
	FOR i = 1 TO 40: IF matrix(i, 7) > 90 AND navyloc(who) <> i THEN size = size + 1: mtx$(size) = city$(i): array(size) = i
	NEXT i
	IF chx = 3 THEN
		IF size = 0 THEN EXIT SUB
		IF grudge > 0 THEN choose = 1: array(1) = navyloc(3 - who): GOTO admiral
		GOSUB nest: IF choose > 0 GOTO admiral ELSE EXIT SUB
	END IF
	COLOR 11: LOCATE 11, 68
	IF navyloc(who) < 41 THEN
		PRINT city$(navyloc(who))
	ELSE
		PRINT "Raiding"
	END IF
	mtx$(0) = "To"
	colour = 3: tlx = 67: tly = 12
      
	CALL menu(9): CALL clrrite: IF choose < 1 THEN EXIT SUB
admiral:
	IF array(choose) = navyloc(who) THEN EXIT SUB
	IF array(choose) < 1 THEN EXIT SUB
	IF navysize(who) < 1 GOTO ships
	IF who = side THEN nflag = 1
	GOSUB box2
	LOCATE 10, 25: PRINT force$(who); " fleet of"; navysize(who); "ship(s) is sailing"
	LOCATE 11, 25: PRINT "From ";
	IF navyloc(who) < 41 THEN
		PRINT city$(navyloc(who));
	ELSE
		PRINT "Raiding";
	END IF
	PRINT " to ";
	IF array(choose) <> 99 THEN
		PRINT city$(array(choose));
	ELSE
		PRINT "Raid Commerce";
	END IF

	FOR i = 1 TO navysize(who)
		PSET (120 + 41 * i, 210), 0
		CALL shiptype(who, i)
	NEXT i
	IF graf > 2 THEN
		a = ASC(LEFT$(fleet$(who), 1))
		SELECT CASE a
			CASE 73
				CALL ironclad
			CASE 87
				CALL schooner
		END SELECT
		TICK 2 * turbo!
	ELSE
		TICK turbo!
	END IF
	navyloc(who) = array(choose)
	IF navyloc(1) = navyloc(2) GOTO pirate
	GOTO sail3
	CASE 4 ' Raid Commerce
	navysize(who) = LEN(fleet$(who))
	IF navysize(who) < 1 AND chx > 0 THEN EXIT SUB
	IF navysize(who) < 1 OR commerce = who GOTO ahoy

	IF who = side THEN nflag = 1
	GOSUB box2
	LOCATE 10, 25: PRINT force$(who); " fleet of"; navysize(who); "ship(s) is sailing"
	LOCATE 11, 25: PRINT "to RAID "; force$(3 - who); " COMMERCE !"

	FOR i = 1 TO navysize(who)
		PSET (120 + 41 * i, 210), 0
		CALL shiptype(who, i)
	NEXT i
	IF graf > 2 THEN
		a = ASC(LEFT$(fleet$(who), 1))
		SELECT CASE a
			CASE 73
				CALL ironclad
			CASE 87
				CALL schooner
		END SELECT
		TICK 2 * turbo!
	ELSE
		TICK turbo!
	END IF
	navyloc(who) = 99: commerce = who
	IF navyloc(1) = navyloc(2) GOTO pirate
	CLS : CALL usa
	EXIT SUB
	CASE 5  ' Invasion
	CALL commander((who), empty)
	IF chx > 0 AND empty = 0 THEN chx = 3: GOTO anchor
	x = 35
	CALL barnacle(who)
	c = navyloc(who): CALL newarmy((who), empty, c)
	cash(who) = cash(who) + 100     'compensate for cost of recruiting new army
	CALL capture(empty, c, who, 0)
	armysize(empty) = x
	IF who = side THEN nflag = 1
	EXIT SUB
	CASE ELSE ' Exit
	EXIT SUB
END SELECT
GOTO ahoy
'---------------------------------------------------------------------------
'                               Ship vs. Ship
'---------------------------------------------------------------------------
pirate:
	CLS : LOCATE 1, 30: COLOR 11: PRINT "NAVAL COMBAT"
	FOR k = 1 TO 2
	hit(k) = 10
	IF RIGHT$(fleet$(k), 1) = "I" THEN hit(k) = 20
	NEXT k
cannon:
	LOCATE 9, 1: PRINT SPACE$(79)
	LOCATE 15, 1: PRINT SPACE$(79)
	x = 10: y = 100
	COLOR 9: LOCATE 5, 25: PRINT "UNION"; navysize(1); "ship(s)"
	GOSUB boxes
	COLOR 1
	FOR i = 1 TO navysize(1)
	x = x + 50: PSET (x, y)
	CALL shiptype(1, i)
	NEXT i
	COLOR 11: LOCATE 11, 22: PRINT "CONFEDERATES "; navysize(2); "ship(s)"
	LINE (10, 180)-(530, 210), 1, BF
	LINE (10, 180)-(530, 210), 11, B
	x = 10: y = 200
	COLOR 1
	FOR i = 1 TO navysize(2)
	x = x + 50: PSET (x, y)
	CALL shiptype(2, i)
	NEXT i
	COLOR 11
wave:
	mtx$(0) = "Options"
	mtx$(1) = "Attack"
	mtx$(2) = "Retreat"
	IF chx > 0 THEN choose = 1: GOTO powder
      
	size = 2: colour = 3: hilite = 14: tlx = 50: tly = 18: CALL menu(0)
powder:
	SELECT CASE choose
	 CASE 1
firemore:
	 IF noise > 0 THEN SOUND 77, .5: SOUND 59, .5: CALL TICK(.1)
	 pct! = 0: a$ = RIGHT$(fleet$(who), 1)
	 IF a$ <> RIGHT$(fleet$(3 - who), 1) THEN
		IF a$ = "I" THEN pct! = .1 ELSE pct! = -.1
	 END IF
	 IF RND <= .5 + pct! GOTO hitem ELSE GOTO hitme1
	 GOTO firemore
hitem:
	 hit(3 - who) = hit(3 - who) - 1: GOSUB showhit: IF hit(3 - who) > 0 GOTO firemore
	 x = 10 + 50 * navysize(3 - who)
	 y = 90: IF who = 1 THEN y = 190
	 GOSUB xout
	 LOCATE 17, 5: PRINT force$(3 - who); " ship SUNK!": CALL TICK(turbo! + 1): GOSUB clr1
	 CALL barnacle(3 - who)
	 IF navysize(3 - who) < 1 THEN
		LOCATE 19, 5: COLOR 12
		PRINT force$(3 - who); " fleet DEFEATED"
		CALL TICK(turbo!)
		navyloc(3 - who) = 0: fleet$(3 - who) = ""
		victory(3 - who) = victory(3 - who) + 10
		IF who = side THEN grudge = 1 ELSE grudge = 0
		GOTO sail3
	 END IF
	 hit(3 - who) = 10
	 IF RIGHT$(fleet$(3 - who), 1) = "I" THEN hit(3 - who) = 20
	 GOTO cannon
hitme1:
	 hit(who) = hit(who) - 1: GOSUB showhit: IF hit(who) > 0 GOTO firemore
	 x = 10 + 50 * navysize(who)
	 y = 190: IF who = 1 THEN y = 90
	 GOSUB xout
	 LOCATE 17, 5: PRINT "One of the "; force$(who); " ships was SUNK!": CALL TICK(turbo!): GOSUB clr1
	 CALL barnacle(who)
	 IF navysize(who) < 1 THEN
		LOCATE 19, 5: COLOR 12
		PRINT "Attacking "; force$(who); " fleet has been ELIMINATED !"
		CALL TICK(turbo!)
		navyloc(who) = 0: fleet$(who) = ""
		victory(who) = victory(who) + 10
		IF who <> side THEN grudge = 1 ELSE grudge = 0
		GOTO sail3
	 END IF
	 hit(who) = 10
	 IF RIGHT$(fleet$(who), 1) = "I" THEN hit(who) = 20
	 GOTO cannon

	 CASE 2
	 target = 0
	 FOR i = 1 TO 40
	 IF cityp(i) = who THEN IF i <> navyloc(who) AND matrix(i, 7) = 99 THEN target = i: IF RND > .3 GOTO found1
	 NEXT i
found1:
	 CALL clrbot: COLOR 11: PRINT force$(who); " is retreating to "; city$(target); : CALL TICK(turbo!)
	 navyloc(who) = target
	 GOTO sail3
	 CASE ELSE
	 GOTO wave
	 END SELECT
	 GOTO pirate
'---------------------------------------------------------------------------
'                               Subs
'---------------------------------------------------------------------------
showhit:
	 LOCATE 9, 6 * navysize(1): PRINT hit(1); " ";
	 LOCATE 15, 6 * navysize(2): PRINT hit(2); " ";
	 IF noise = 0 THEN TICK .1 * turbo!
	 RETURN
clr1:
	LOCATE 17, 1: PRINT SPACE$(60): RETURN
nest:
	best = 0: x = 0
	FOR i = 1 TO size
	target = array(i)
	IF cityp(target) = 0 GOTO neutral

	IF target = navyloc(3 - who) THEN IF navysize(who) >= navysize(3 - who) AND RND > .1 THEN choose = i: RETURN
	IF cityp(target) <> who THEN
		best = i: x = x + 1
		IF RND > .8 THEN choose = best: RETURN
	END IF
neutral:
	NEXT i
	IF best = 0 THEN
		choose = 1 + INT(RND * size)
	ELSE
		choose = best
	END IF

	IF who = 2 AND navyloc(2) = 30 THEN IF RND > .5 THEN choose = 30: RETURN
	RETURN
boxes:
	LINE (10, 80)-(530, 110), 1, BF
	LINE (10, 80)-(530, 110), 11, B
	RETURN
box2:
	CLS
	LINE (100, 110)-(550, 240), 1, B
	LINE (95, 115)-(555, 235), 7, B
	RETURN
xout:
		PSET (x, y)
		DRAW "S5C15G5F5G3H5G5H3E5H5E3F5E5F3"
		PAINT (x - 3, y + 1), 12, 15
	RETURN
sail3:
	commerce = 0
	FOR k = 1 TO 2
	IF navyloc(k) = 99 THEN commerce = k
	NEXT k
	CLS : CALL usa
END SUB

SUB newcity (index)
		mtx$(1) = "  "
		mtx$(3) = "  "
		size = 3: a$ = city$(index)
morecap:
		tlx = 68: tly = 15: colour = 3: choose = 23
		mtx$(2) = city$(index)
		CALL menu(3): CALL clrrite
	       SELECT CASE choose
		CASE IS = -27
		index = 0: EXIT SUB
		CASE IS < 1
		a$ = CHR$(ABS(choose))
		x = 0
		FOR k = 1 TO 40
		IF LEFT$(city$(k), 1) = a$ THEN
			y = index: index = k
spin2:
			IF cityp(index) = side GOTO morecap
				index = index + 1
				IF index > 40 THEN index = 1
				x = x + 1: IF x < 39 GOTO spin2
				index = y: GOTO morecap
		END IF
		NEXT k
		GOTO morecap
		CASE 1
minus1:
		index = index - 1: IF index < 1 THEN index = 40
		IF cityp(index) <> side GOTO minus1 ELSE GOTO morecap
		CASE 2
		GOTO fnew
		CASE 3
plus1:
		index = index + 1: IF index > 40 THEN index = 1
		IF cityp(index) <> side GOTO plus1 ELSE GOTO morecap
		CASE ELSE
		index = 0
		END SELECT
fnew:
END SUB