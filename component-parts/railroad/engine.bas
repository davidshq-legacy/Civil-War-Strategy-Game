SUB engine
IF rr(1) + rr(2) = 0 GOTO notrain
LINE (5, 17)-(100, 63), 3, BF
LINE (5, 17)-(100, 47), 0, B
LINE (5, 47)-(100, 63), 0, B

FOR i = 1 TO 2
IF rr(i) = 0 GOTO notrane
PSET (15, 25), 3: c = 9: IF i = 2 THEN c = 15: PSET (60, 25), 3
DRAW "C0S4R9D4R6U3R3D3R7U5H3U2R9D3G2D6F1D3F5L10D1G1L4H2L7G2L3H2L3U8L2U5BF4"
x = POINT(0): y = POINT(1): PAINT (x, y), c, 0
LOCATE 4, 6 * (i - 1) + 2: PRINT LEFT$(city$(armymove(rr(i))), 5)
notrane:
NEXT i

notrain:
END SUB