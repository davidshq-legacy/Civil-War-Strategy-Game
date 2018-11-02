SUB armies
CALL movefrom(index, target): IF target > 0 AND index > 0 GOTO tent
	IF index = -1 THEN mflag = 1
	GOTO dudd
tent:
tlx = 67: tly = 12

CALL armystat(index)
COLOR 11: LOCATE 11, 68: PRINT city$(target)
size = 0
mtx$(0) = "To"
FOR i = 1 TO 6: IF matrix(target, i) > 0 THEN size = size + 1: mtx$(size) = city$(matrix(target, i)): array(size) = matrix(target, i)
NEXT i
CALL bubble(size)

hilite = 10: colour = 3: CALL menu(2): CALL clrrite
IF choose < 0 GOTO dudd
IF month < 3 AND jancam = 0 AND cityp(array(choose)) <> side THEN COLOR 11: CALL clrbot: PRINT "No campaigns in January"; : CALL TICK(9): CALL clrbot: GOTO dudd

CALL clrbot: PRINT "Army "; index; " "; armyname$(index); " is moving from "; city$(target); " to "; city$(array(choose));
IF noise > 0 THEN SOUND 2200, .5: SOUND 2900, .7
CALL icon(target, array(choose), 1)
armymove(index) = array(choose): CALL TICK(turbo!): CALL clrbot
CALL clrrite
dudd:
END SUB