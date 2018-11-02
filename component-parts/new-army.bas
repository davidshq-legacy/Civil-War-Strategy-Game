' Called from subs recruit and navy.
SUB newarmy (who, empty, target)
	supply(empty) = 3 + 5 * RND
	IF who = 1 THEN supply(empty) = supply(empty) + 2
	armyexper(empty) = 1
	IF who = 2 THEN armyexper(empty) = 2
	armylead(empty) = rating(empty)
	armyname$(empty) = lname$(empty): lname$(empty) = ""
	COLOR 12: CALL clrbot: PRINT "Placing NEW army "; empty; armyname$(empty); " in "; city$(target);

	x = 70
	IF realism > 0 THEN x = 3 * cityv(target) + 33
	CALL cutoff(who, target, a)
	IF a < 1 THEN x = x \ 3
	occupied(target) = empty: armysize(empty) = x
	PRINT " Size = "; : CALL strong(empty)
	cash(who) = cash(who) - 100
	IF noise > 0 THEN SOUND 2222, .5
	armyloc(empty) = target: CALL placearmy(empty)
	CALL TICK(turbo! - .5)
	armymove(empty) = -1
END SUB