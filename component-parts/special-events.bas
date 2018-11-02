SUB events' Special Events
IF realism > 0 AND year = 1862 AND month < 3 THEN
	COLOR 14: CALL clrbot
	PRINT "SPECIAL DEVELOPMENT : IRONCLAD ships now available";
	IF noise > 0 THEN FOR k = 1 TO 5: SOUND 140, 1: SOUND 37, 1: NEXT k
	DO WHILE INKEY$ = "": LOOP
	EXIT SUB
END IF
IF randbal = 0 THEN EXIT SUB
plus = difficult: IF side = 1 THEN plus = 6 - difficult
pct! = .005 * (year - 1860) * plus * plus: IF pct! > .9 THEN pct! = .9
IF RND > pct! THEN EXIT SUB

CALL clrbot: COLOR 14: PRINT "SPECIAL EVENT...";
who = 1: IF RND > .1 * randbal THEN who = 2

SELECT CASE who
	CASE 1 ' Good for South
	IF year = 1864 AND month = 1 THEN victory(2) = victory(2) + 50
	IF year = 1865 AND month = 1 THEN victory(2) = victory(2) + 100
	IF RND > .9 THEN GOSUB riot: EXIT SUB

	CALL clrbot
	IF RND > .2 OR navysize(2) > 9 GOTO mercen
	IF navysize(2) > 0 AND navyloc(2) <> 99 THEN empty = navyloc(2): GOTO float1
		empty = 0
		FOR i = 1 TO 40
		IF cityp(i) = 2 AND matrix(i, 7) = 99 AND navyloc(1) <> i THEN empty = i: EXIT FOR
		NEXT i
	IF empty = 0 GOTO mercen
float1:
	CALL scribe("England has given ships to the South", 2)
	navysize(2) = navysize(2) + 2 * plus
	IF navysize(2) > 10 THEN navysize(2) = 10
	x = navysize(2) - LEN(fleet$(2))
	fleet$(2) = fleet$(2) + STRING$(x, "W")
	navyloc(2) = empty: CALL ships
	GOTO dull1
mercen:
	IF RND > .1 OR control(2) < 30 GOTO money
	a$ = "French": IF RND > .5 THEN a$ = "British"
	CALL scribe(a$ + " mercenaries join " + armyname$(index) + "'s army", 2)
	armysize(index) = armysize(index) + 100 * plus
	armyexper(index) = 10: supply(index) = 10
	GOTO dull1
money:
	IF RND > .3 OR control(2) < 12 GOTO cotton
		CALL scribe("The South has obtained a loan from Europe", 2)
		GOTO purse
cotton:
	IF RND > .5 OR control(2) < 12 GOTO uprising
	CALL scribe("Cash from cotton sales fill the Rebel Treasury", 2)
purse:
	cash(2) = cash(2) + 100 * plus
	GOTO dull1
uprising:
	pct! = .9
	a$ = "Union troops diverted to fight Western Indian uprisings"
	IF RND > .5 THEN a$ = "Union 90-day enlistees return home"
	IF year = 1864 AND month > 5 THEN a$ = "20% of Union forces take furloughs to vote in 1864 elections": pct! = .8
	CALL scribe(a$, 2)
	FOR k = 1 TO 20
	armysize(k) = pct! * armysize(k)
	NEXT k
	GOTO dull1

riot:
	IF realism = 0 THEN RETURN
	IF control(who) = 1 THEN EXIT SUB
	FOR k = 1 TO 99
	x = 1 + INT(40 * RND)
		IF cityo(x) <> who AND cityp(x) = who AND occupied(x) = 0 THEN
			CALL clrbot: COLOR 15
			PRINT " Riots have broken out in "; city$(x);
			cityp(x) = 0
			CALL showcity
			TICK turbo!
			CALL clrbot
			CALL image2(city$(x) + " is now NEUTRAL !", 4)
			TICK turbo!
			RETURN
		END IF
	NEXT k
	RETURN
	CASE 2 ' Good for Union
	IF RND > .1 OR navyloc(1) = 0 OR navysize(1) > 9 GOTO event2
	IF RND > .95 THEN GOSUB riot: EXIT SUB
	CALL scribe("Union shipworks have produced extra ships", 2)
	navysize(1) = navysize(1) + plus
	IF navysize(1) > 10 THEN navysize(1) = 10
	x = navysize(1) - LEN(fleet$(1))
	fleet$(1) = fleet$(1) + STRING$(x, "W")
	GOTO dull2
event2:
	IF RND < .7 GOTO abe
	CALL scribe("Volunteer troops swell the Union ranks", 2)
	x = 0: FOR i = 1 TO 20: x = x + 1: IF x > 5 GOTO dull2
	IF armysize(i) > 0 AND RND > .5 THEN armysize(i) = armysize(i) * 1.1 + plus
	NEXT i: GOTO dull2
abe:
	IF emancipate = 0 AND year > 1862 THEN

		emancipate = 1
		CALL scribe("Abraham Lincoln announces the Emancipation Proclamation", 2)
		victory(1) = victory(1) + 100: victory(2) = victory(2) - 100
		CALL usa
		GOTO dull2
	END IF
	IF year = 1864 AND month = 11 THEN
		CALL scribe("Lincoln has been reelected", 2)
		victory(2) = .5 * victory(2)
		GOTO dull2
	END IF
	IF RND > .5 THEN
		CALL scribe("Wealthy Unionists give generously to the Federal Cause", 2)
		cash(1) = cash(1) + 100 * plus
		GOTO dull2
	END IF
	IF RND > .5 AND year > 1861 THEN
		CALL scribe("Rebel deserters leave the battlefield to go home", 2)
		FOR i = 21 TO 40: armysize(i) = .92 * armysize(i): NEXT i: GOTO dull2
	END IF
	IF RND > .5 AND year > 1861 THEN
		CALL scribe("Union soldiers now have repeating rifles", 2)
		FOR i = 1 TO 20
			IF armyexper(i) < 9 THEN armyexper(i) = armyexper(i) + 2
		NEXT i
	END IF
		CALL scribe("Secretary of War Stanton predicts the end of the Rebellion", 2)
		victory(1) = victory(1) + 10: GOTO dull2
	CASE ELSE
END SELECT

dull2:
	IF noise = 2 THEN PLAY "MNMFL16o2T120dd.dd.co1b.o2do3g.ab.bb.ag"
	DO WHILE INKEY$ = "": LOOP: EXIT SUB
dull1:
	IF noise = 2 THEN PLAY "MNMFT160o2L16geL8ccL16cdefL8ggge"
	DO WHILE INKEY$ = "": LOOP
END SUB