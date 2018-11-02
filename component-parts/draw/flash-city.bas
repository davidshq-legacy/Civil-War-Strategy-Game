SUB flashcity (which)
FOR c = 1 TO 15 STEP 2
CIRCLE (cityx(which), cityy(which)), 4, 0
CIRCLE (cityx(which), cityy(which)), 3, c
PAINT (cityx(which), cityy(which)), c, c
CALL TICK(.1)
NEXT c
c = 9: IF cityp(which) = 2 THEN c = 7
IF cityp(which) = 0 THEN c = 12
CIRCLE (cityx(which), cityy(which)), 4, 0
CIRCLE (cityx(which), cityy(which)), 3, c
PAINT (cityx(which), cityy(which)), c, c
END SUB