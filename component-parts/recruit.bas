SUB recruit (who)
	IF cash(who) < 100 GOTO menu1
	size = 0: COLOR 12
	mtx$(0) = "Recruit"
	IF who = side AND rflag > 0 THEN FOR i = 1 TO rflag: x = rcity(i): mtx$(i) = city$(x): array(i) = x: NEXT i: size = rflag: GOTO alldone
	max = 4: IF RND > .8 THEN max = max - 1
	IF difficult < 3 THEN max = max + 1

	FOR i = 1 TO 40
	IF control(who) > 0 THEN pct! = .6 * max / control(who) ELSE pct! = .3
	IF size = 0 AND i > 20 THEN pct! = .3
	IF size < 2 AND i > 30 THEN pct! = .3
	array(i) = 0
	IF occupied(i) > 0 AND cityp(i) = who THEN pct! = .4
	IF RND < pct! AND cityp(i) = who THEN
		IF realism > 0 AND cityo(i) = 3 - who GOTO foe
		size = size + 1
		mtx$(size) = city$(i)
		array(size) = i
		IF size > max - 1 GOTO alldone
	END IF
foe:
	NEXT i
alldone:
	IF size = 0 GOTO menu1
	IF who = side AND rflag = 0 THEN FOR i = 1 TO size: rcity(i) = array(i): NEXT i: rflag = size
	CALL bubble(size)

levy:
	IF cash(who) < 100 GOTO menu1
	IF (who = side) OR (player = 2) THEN CALL clrbot: PRINT force$(who); " funds available "; cash(who);
	tlx = 67: tly = 12: colour = 3
	IF who <> side THEN GOSUB randsel: GOTO auto1
      
	IF choose > 0 THEN choose = 21 + choose
	CALL menu(2): CALL clrrite
	IF choose < 1 GOTO menu1
auto1:
	empty = 0
	index = array(choose)
	CALL occupy(index)
	IF occupied(index) > 0 THEN i = occupied(index): GOTO add2
	CALL commander((who), empty)
       
	IF who <> side AND empty = 0 GOTO menu1
	IF empty = 0 GOTO levy
	armyloc(empty) = index
	GOSUB playb
	CALL newarmy(who, empty, index)
	GOTO levy

add2:
	target = array(choose)
	x = 45: a$ = ""
	IF realism > 0 THEN
		x = 2 * cityv(armyloc(i)) + 20
		CALL cutoff(who, target, a)
		IF a < 1 THEN x = x \ 3: a$ = " ISOLATED !"
	END IF
	armysize(i) = armysize(i) + x

	GOSUB playb
	cash(who) = cash(who) - 100
	from = armyloc(i): x = cityx(from) - 12: y = cityy(from) - 11
	GET (x - 9, y - 7)-(x + 9, y + 6), anima
	CALL icon(armyloc(i), 0, 2)
	IF noise > 0 THEN SOUND 2222, 1
	COLOR 11: CALL clrbot: PRINT "Army "; i; armyname$(i); " in "; city$(armyloc(i)); " strength increased to "; : CALL strong(i)
	IF a$ <> "" THEN PRINT a$;
	PUT (x - 9, y - 7), anima, PSET
	CALL TICK(turbo! - .5)
	GOTO levy
randsel:
		choose = 0: x = 0
		FOR i = 1 TO size
		target = array(i)
		LOCATE 14 + i, 69
		x = occupied(target)
		IF x = 0 XOR armysize(x) < 155 THEN choose = i
		NEXT i

	IF choose = 0 THEN choose = 1 + INT(RND * size)
	IF realism > 0 THEN
		x = 0
		FOR i = 1 TO size
		target = array(i)
		IF occupied(target) = 0 THEN
			y = 3 * cityv(target) + 33
			CALL cutoff(who, target, a)
			IF a < 1 THEN y = y \ 3
		ELSE
			y = 2 * cityv(target) + 20
			CALL cutoff(who, target, a)
			IF a < 1 THEN y = y \ 3
		END IF
		IF y > x AND RND > .5 THEN x = y: choose = i
		NEXT i
	END IF
	IF cash(who) < 100 THEN choose = size
	RETURN
playb:
	IF side = 1 AND difficult < 3 THEN armysize(empty) = armysize(empty) + 15 - 5 * difficult
	IF side = 2 AND difficult > 3 THEN armysize(empty) = armysize(empty) + 5 * difficult - 15
	RETURN
menu1:
END SUB