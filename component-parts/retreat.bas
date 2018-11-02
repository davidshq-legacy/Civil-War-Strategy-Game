SUB retreat (defend, x)
x = 0
IF player = 1 THEN
	IF (side = 1 AND defend > 20) OR (side = 2 AND defend < 21) THEN EXIT SUB
END IF

hilite = 13: colour = 3: tlx = 67: tly = 5: size = 0
y = armyloc(defend)
who = 1: IF defend > 20 THEN who = 2
FOR k = 1 TO 6
	IF matrix(y, k) > 0 AND cityp(matrix(y, k)) = who THEN size = size + 1: mtx$(size) = city$(matrix(y, k)): array(size) = matrix(y, k)
NEXT k
	IF size = 0 THEN EXIT SUB
	IF size = 1 THEN x = array(1): EXIT SUB
	mtx$(0) = "Retreat"
	CALL bubble(size)
	CALL menu(9)
	CALL clrrite
	IF choose < 0 OR choose > size THEN x = 0: EXIT SUB
	x = array(choose)
END SUB