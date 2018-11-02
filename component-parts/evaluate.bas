SUB evaluate (index, x)
from = armyloc(index)
x = 200: IF aggress! > 1.5 THEN x = 80: IF aggress! > 2 THEN x = 20: IF aggress! > 3 THEN x = 5
CALL void(from, defend): IF defend = 0 THEN x = 0
IF bold > 1 THEN x = .5 * x

best = armysize(index)

FOR j = 1 TO 6: array(j) = -1
a = matrix(from, j): IF a > 0 THEN IF occupied(a) > 0 THEN best = best - armysize(occupied(a)): y = 1
NEXT j: best = .01 * best
IF bold > 0 THEN best = best + 20 * bold

CALL starfin(star, fin, 3 - side)

FOR j = 1 TO 6
	y = -1: a = matrix(from, j): IF a = 0 THEN max = j - 1: GOTO alleval
      
	c = occupied(a)
	FOR k = star TO fin: IF armyloc(k) > 0 THEN IF armymove(k) = a AND c = 0 GOTO alle
	NEXT k
	
	y = best - x * fort(from) - cityv(from) + 30 * RND
	IF fort(from) > 0 THEN IF index = occupied(from) THEN y = y - 25: IF realism > 0 THEN y = y - 50
	IF a = capcity(side) THEN IF vicflag(5) > 0 THEN y = y + 200
	IF cityp(a) <> 3 - side THEN y = y + 5 * cityv(a) + 10 * fort(a)
	IF cityp(a) <> side GOTO ourn
	   IF c = 0 THEN y = y + 10 * cityv(a): GOTO ourn
	   x1 = 1: IF fort(a) = 1 THEN x1 = 2: IF fort(a) = 3 THEN x1 = 3

	   IF armysize(c) > 0 THEN
		odds! = armysize(index) / (x1 * armysize(c))
		IF realism > 1 THEN odds! = .8 * odds!
	   ELSE
		odds! = 5
	   END IF

	   IF armysize(index) < 15 THEN y = y - 300: odds! = .1
	   IF bold < 3 AND armysize(index) < 40 AND odds! < .8 THEN y = 0
	   IF realism > 0 THEN y = y - 15
	   IF odds! < .5 THEN y = y - 200
	   IF bold = 0 AND RND > .9 THEN y = y + 10 * (armylead(index) - armylead(c) + armyexper(index) - armylead(index))
	   IF supply(index) < 1 THEN y = y - 100
	   SELECT CASE odds! + .5 * bold
		CASE IS < .3
		y = -9999
		CASE IS < .5
		y = y - 300
		CASE IS <= .8
		y = y - 20
		CASE .8 TO 1.2
		y = y - 5
		CASE 1.2 TO 1.5
		y = y + 10
		CASE ELSE
		y = y + .5 * (armysize(index) - armysize(c)) + 50 * RND
	   END SELECT
ourn:
	IF cityp(a) = 3 - side AND c > 0 AND armymove(c) = 0 THEN y = y - armysize(c)
	IF side = 1 AND cityy(a) < cityy(from) THEN y = y + 2
	IF side = 2 AND cityy(a) > cityy(from) THEN y = y + 2

	FOR k = 1 TO 6: m = matrix(a, k): IF m = 0 GOTO tally3
	IF cityp(m) = 0 THEN y = y + 3 * cityv(m) + 4 * fort(m)
	IF cityp(m) = side THEN y = y + 3 * cityv(m) + 4 * fort(m)
	IF cityp(m) = side AND c > 0 THEN
		odds! = 5 - 4 * RND
		IF armysize(c) > 0 THEN odds! = armysize(index) / armysize(c) ELSE odds! = 5
		IF odds! < 1 THEN y = y - 2
	END IF
	IF cityp(m) = capcity(side) THEN y = y + 50
tally3:
	NEXT k

	array(j) = y
alle:
NEXT j: max = 6
alleval:
x = 0: best = 0
FOR j = 1 TO max
IF array(j) < 0 GOTO allof
	IF array(j) > x THEN x = array(j): best = j
allof:
NEXT j
	IF defend > armysize(index) AND array(best) < 50 THEN best = 0
	x = best
END SUB