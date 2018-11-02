SUB tupdate
flag = 0
IF player = 1 THEN
	CALL smarts
ELSE
	FOR i = 1 TO 40
	IF armyloc(i) > 0 AND armymove(i) > 0 THEN CALL icon(armyloc(i), armymove(i), 1)
	NEXT i
END IF
COLOR 14: LOCATE 1, 1: PRINT SPACE$(80);
LOCATE 1, 20: PRINT "Update for "; month$(month); ","; year
CALL clrbot: PRINT "press any key for "; month$(month); ","; year; " events";
DO WHILE INKEY$ = "": LOOP
GOSUB upbox

'                       Assign Time of Action
FOR i = 1 TO 2: IF rr(i) > 0 THEN CALL railroad(i): LINE (5, 17)-(100, 63), 3, BF: LINE (5, 17)-(100, 63), 0, B: CALL engine
NEXT i

FOR i = 1 TO 40
brray(i) = 999
IF armymove(i) < 0 THEN armymove(i) = 0
IF armyloc(i) > 0 AND armymove(i) > 0 THEN brray(i) = INT(4 + 4 * RND) * 100 + i
IF supply(i) < 1 AND armymove(i) > 0 THEN brray(i) = 900 + i
SELECT CASE armysize(i)         'bigger armies move slower
	CASE IS > 400
		IF brray(i) < 900 THEN brray(i) = brray(i) + 100: x = 2
	CASE IS > 800
		IF brray(i) < 800 THEN brray(i) = brray(i) + 200: x = 3
	CASE IS > 1000
		IF brray(i) < 700 THEN brray(i) = brray(i) + 300: x = 4
	CASE ELSE
		x = 1
END SELECT
IF brray(i) <> 999 AND armylead(i) > 10 * RND THEN
		brray(i) = brray(i) - 100 * (armylead(i) \ 2)
		IF brray(i) < 100 THEN brray(i) = 100 + i
END IF
NEXT i

CALL bub2(40)

'                       Begin Main Loop
FOR j = 1 TO 40
flag = 0
IF brray(j) = 999 GOTO allthru
active = INT(brray(j) / 100): active = brray(j) - 100 * active: s = 1: IF active > 20 THEN s = 2
IF armymove(active) < 1 GOTO digin
COLOR 11: CALL clrbot: PRINT armyname$(active); " is moving to "; city$(armymove(active));

supply(active) = supply(active) - 1: IF supply(active) < 0 THEN supply(active) = 0: CALL TICK(turbo!): CALL clrbot: PRINT armyname$(active); " is out of supplies !";

CALL placearmy(active)
CALL icon(armyloc(active), armymove(active), 5)

CALL animate(active, 0)

target = armymove(active)
IF occupied(target) = 0 GOTO easy
IF (s = 1 AND occupied(target) < 21) OR (s = 2 AND occupied(target) > 20) GOTO friend ELSE GOTO enemy


friend: '                         Join Forces
COLOR 11: CALL clrbot: PRINT armyname$(active); " and "; armyname$(occupied(target)); " meet in "; city$(target); : CALL TICK(turbo!)
CALL icon(armymove(active), 0, 6)
CALL clrbot
GOTO easy

enemy: ' Attack
CALL icon(target, 0, 3)
defend = occupied(target)

COLOR 11: CALL clrbot: PRINT armyname$(active); " attacks "; armyname$(defend); " in "; city$(armyloc(defend)); : CALL TICK(turbo! - 1)
IF armysize(defend) > 0 THEN CALL battle(active, defend, win, lose): flag = 1: IF graf > 0 THEN GOSUB upbox
IF armyexper(win) < 10 THEN armyexper(win) = armyexper(win) + 1

IF armysize(lose) < 2 THEN
	CALL clrbot
	a$ = armyname$(lose) + "'s army is crushed in " + city$(armyloc(defend))
	CALL scribe(a$, 2)
	index = lose: GOTO crushed
END IF

CALL clrrite

'                       Attacker Loses
IF win = active GOTO kickbutt
armymove(active) = armyloc(active)
armyloc(active) = target
COLOR 11: CALL clrbot: PRINT armyname$(active); " withdrew to "; city$(armymove(active));

CALL placearmy(armyloc(active))
CALL animate(active, 1)

armyloc(active) = armymove(active)
CALL placearmy(armyloc(active))
CALL placearmy(active)
occupied(armyloc(active)) = active
armymove(active) = -2
	      
IF 11 * RND > armylead(defend) THEN CALL icon(armyloc(defend), armymove(defend), 4): IF armymove(defend) > 0 THEN armymove(defend) = -2

CALL TICK(turbo!): GOTO digin

kickbutt: ' Defender Retreats
	CALL icon(armyloc(active), target, 4)
	IF armymove(defend) > 0 THEN CALL icon(target, armymove(defend), 4)

	CALL retreat(defend, flee): IF flee > 0 THEN move2 = flee: GOTO outta

	best = 0: flee = 0
	FOR i = 1 TO 6
	x = matrix(target, i)
	IF x > 0 AND (cityp(x) = 3 - s) AND cityv(x) > best THEN
		IF best = 0 THEN
			flee = i: best = cityv(x)
		ELSE
			IF occupied(x) = 0 THEN flee = i: best = cityv(x)
		END IF
	END IF
	NEXT i
	IF flee = 0 GOTO deadmeat
	move2 = matrix(target, flee)
outta:
	CALL placearmy(defend)                  ' in old city

	armymove(defend) = move2
	CALL animate(defend, 0)                 ' animate retreat
       
	armyloc(defend) = move2
	occupied(move2) = defend
	CALL clrbot
	PRINT armyname$(defend) + " is withdrawing to " + city$(move2);

	CALL placearmy(defend)                  ' in new city
       
	CALL icon(target, 0, 6)
	armymove(defend) = -2
	GOTO holdon

deadmeat:
	index = defend
	a$ = armyname$(index) + " surrenders to " + armyname$(active) + " in " + city$(armyloc(index))
	CALL scribe(a$, 2)
crushed:
	IF graf > 2 THEN CALL surrender(index): COLOR 14: LOCATE 3, 68: PRINT armyname$(index): LOCATE 4, 68: PRINT "surrenders !"
	x = 1: IF index > 20 THEN x = 2
	IF noise > 1 AND x <> side THEN PLAY "MFMST220o3e4g8g2.g8g8g8o4c2"
	IF armymove(index) > 0 THEN CALL icon(armyloc(index), armymove(index), 4)
	victory(3 - s) = victory(3 - s) + 25
	armyloc(index) = 0: lname$(index) = "": armyname$(index) = ""
	armysize(index) = 0: armylead(index) = 0
	armyexper(index) = 0: armymove(index) = 0: supply(index) = 0
	supply(active) = supply(active) + supply(index): supply(index) = 0
	IF supply(active) > 10 THEN supply(active) = 10
	CALL TICK(9): CALL clrrite
	IF armyloc(active) = 0 GOTO digin

holdon: ' check for more defenders
	CALL occupy(target): IF occupied(target) = 0 GOTO easy
	COLOR 11: CALL clrbot: PRINT "There are still defenders in "; city$(target); : CALL TICK(99)
	GOTO enemy

easy: ' Move into new city
CALL icon(armyloc(active), target, 4)
armyloc(active) = target: armymove(active) = -2
CALL occupy(armyloc(active))
CALL placearmy(active)

'                            City Capture
	IF cityp(armyloc(active)) = s GOTO horde
	c = armyloc(active)
	IF player = 1 AND s = side AND fort(c) > 0 AND flag = 0 THEN
		tlx = 67: tly = 15
		hilite = 15: colour = 3
		mtx$(0) = "Raze ?"
		mtx$(1) = "No"
		mtx$(2) = "Yes"
		size = 2
		CALL menu(0)
		CALL clrrite
		IF choose = 2 GOTO smoke
	END IF
	IF player = 1 AND s <> side AND fort(c) > 0 AND flag = 0 THEN
		IF realism > 0 AND cityy(c) > 150 THEN
smoke:
			fort(c) = 0
			x = cityx(c)
			y = cityy(c)
			LINE (x - 5, y - 5)-(x + 5, y + 5), 2, BF
			CALL showcity
			CALL clrbot
			PRINT armyname$(active); " has destroyed the forts at "; city$(c);
			TICK 3
		END IF
	END IF
	CALL capture(active, c, s, flag)
horde:
IF supply(active) < 10 THEN supply(active) = supply(active) + 1: IF RND > .8 GOTO horde
digin:
NEXT j
GOTO allthru

upbox:
LINE (450, 318)-(526, 420), 1, BF
LINE (527, 315)-(527, 439), 10
COLOR 14: LOCATE 23, 50: PRINT "|=============|"
LOCATE 24, 50: PRINT "| U P D A T E |"
LOCATE 25, 50: PRINT "|=============|"
RETURN

allthru:
IF navysize(commerce) < 1 THEN commerce = 0
IF commerce > 0 THEN
	CALL clrbot
	IF RND < .8 + .02 * navysize(commerce) THEN
		raider = .05 * navysize(commerce) * (1 + RND) * (income(3 - commerce))
		IF raider < 1 THEN raider = 1
		IF raider / income(3 - commerce) > .3 THEN raider = .3 * income(3 - commerce)
		COLOR 15: PRINT force$(commerce); " raiders have sunk $"; raider; " of "; force$(3 - commerce); " commerce";
		a = 1: IF LEFT$(fleet$(commerce), 1) = "I" THEN a = 2
		PSET (500, 465), 0: CALL shipicon(commerce, a)
		IF noise > 0 THEN PLAY "t210l8o4co3bo4l4co3ccL8gfego4co3bo4c"
		IF commerce = side THEN grudge = 1
		TICK 9
	ELSE
		raider = 0
		CALL barnacle(commerce)
		COLOR 15: PRINT force$(commerce); " raiders have lost a ship ("; navysize(commerce); " remain)";
		IF noise > 0 THEN SOUND 590, .5: SOUND 999, .5: SOUND 1999, .5
		IF navyloc(commerce) > 0 THEN
			TICK 9
			GOTO allthru
		ELSE
			commerce = 0
			LINE (447, 291)-(525, 335), 1, BF
			FOR k = 1 TO 5: CIRCLE (480, 315), 4 * k, 11: NEXT k
			TICK 9
			LINE (447, 291)-(525, 335), 1, BF
		END IF
	END IF
END IF

CALL touchup
CALL ships: CALL iterate

CALL clrbot
LINE (390, 350)-(520, 400), 1, BF
COLOR 13: LOCATE 24, 51: PRINT " "; UCASE$(LEFT$(month$(month), 3)); ","; year
victory(1) = .8 * victory(1) + .3 * (income(1) + control(1))
IF control(1) > 29 THEN victory(1) = victory(1) + 50: IF control(1) > 34 THEN victory(1) = victory(1) + 100
IF side = 2 AND control(1) < 11 THEN aggress! = aggress! + .7

IF victory(1) < 1 THEN victory(1) = 0
victory(2) = .8 * victory(2) + .3 * (income(2) + control(2))
IF control(2) > 29 THEN victory(2) = victory(2) + 50: IF control(2) > 34 THEN victory(2) = victory(1) + 100
IF side = 1 AND control(2) < 11 THEN aggress! = aggress! + .7
IF player = 2 THEN CALL clrbot: COLOR 14: PRINT "press a key"; : DO WHILE INKEY$ = "": LOOP
END SUB