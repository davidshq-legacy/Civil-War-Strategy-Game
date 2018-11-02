SUB cutoff (who, target, a)
a = 0
FOR j = 1 TO 6
y = matrix(target, j)
IF y > 0 AND cityp(y) = who THEN a = a + 1
NEXT j
END SUB