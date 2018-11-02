SUB resupply (index)
		who = 1: IF index > 20 THEN who = 2
		IF realism > 0 THEN
			CALL cutoff(who, armyloc(index), a)
			IF a < 1 THEN EXIT SUB
		END IF
		IF armysize(index) > 0 THEN x = cash(who) / armysize(index) * 10
		y = x + supply(index): IF y > 5 THEN x = 5 - supply(index)
		IF x < 1 THEN CALL clrbot: PRINT "Not enough funds in the Treasury to supply "; armyname$(index); : GOTO nocash
		supply(index) = supply(index) + x: cash(who) = cash(who) - .1 * x * armysize(index)
		CALL clrbot: PRINT armyname$(index); " has received supplies "; : IF noise > 0 THEN SOUND 4500, .5
nocash:
		CALL TICK(turbo!): IF cash(who) < 0 THEN cash(who) = 0
END SUB