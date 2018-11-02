SUB rwin
LINE (2, 2)-(637, 239), 4, BF
COLOR 15: LINE (2, 40)-(597, 239): LINE -(637, 239): LINE -(637, 199): LINE -(40, 2): LINE -(2, 2): LINE -(2, 40)
COLOR 15: LINE (2, 199)-(2, 239): LINE -(40, 239): LINE -(637, 40): LINE -(637, 2): LINE -(597, 2): LINE -(2, 199)
LINE (242, 95)-(395, 145), 4, BF
PAINT (4, 20), 1, 15

LINE (2, 239)-(637, 438), 2, BF
GOSUB stars

'                               landscape
PSET (1, 240)
DRAW "s14BR68C0E6U1E3R2E4R10F2R7F2R5E3R12F7R4F2E3R5E3R9F4"
DRAW "C0R6F2R5F1R3F3L44F2L42E1H1L29E2R1BH5BL3BR5"
PAINT (300, 230), 5, 0
PSET (2, 330)
DRAW "C0D18U1R32E4R26E2R27E5R20E2R1E2U1E2U2E4H4L5H2L9H1L5H3L4H2L5H1L3H2L12H4"
DRAW "C0D1F4R5F2R3F2R4F5R5F3L13G1L8G2L24G1L30G1L18D21"
DRAW "BE5": x = POINT(0): y = POINT(1) + 5: PAINT (x, y), 9, 0
DRAW "BU12C11R21F1R2BR2BD6C11R9E1R9E1R6BH7C11R9E1R9BF5C11R9E1R1E1R10"
LINE (1, 1)-(638, 440), 14, B
LINE (2, 2)-(637, 439), 14, B

'                               mansion
x = 100: y = 240
CIRCLE (x + 50, y + 40), 80, 0, , , .2
PAINT (x + 50, y + 40), 6, 0
LINE (x + 95, y - 14)-(x + 102, y + 8), 8, BF
LINE (x + 100, y - 14)-(x + 102, y + 8), 7, BF
LINE (x, y)-(x + 100, y + 36), 7, BF
FOR i = 1 TO 6: LINE (x + 17 * i, y + 6)-(x + 17 * i + 4, y + 32), 0, BF: NEXT i
LINE (x + 12, y + 18)-(x + 98, y + 22), 7, BF
LINE (x + 50, y + 20)-(x + 57, y + 36), 8, BF
LINE (x + 100, y + 36)-(x + 105, y + 39), 7
LINE -(x + 5, y + 39), 7: LINE -(x, y + 38), 7

LINE (x, y)-(x - 7, y - 7), 8: LINE -(x - 14, y + 5), 8
LINE -(x - 14, y + 33), 8: LINE -(x, y + 36), 8: LINE -(x, y), 8
COLOR 10: LINE (x - 5, y - 7)-(x + 95, y - 7): LINE -(x + 107, y + 7)
LINE -(x + 7, y + 7): LINE -(x - 5, y - 7)
PAINT (x, y - 3), 10
PAINT (x - 5, y + 15), 8

FOR i = 1 TO 6: LINE (x + 19 * i - 12, y + 7)-(x + 19 * i - 12 + 2, y + 40), 15, BF: NEXT i

IF noise < 2 GOTO relee
PLAY "MBMS T120"
PLAY "O3 L16 g e L8 c c L16 c d e f L8 g g g e a a a. L16 g a8. g a b"
PLAY "O4 L16 c d e4. c O3 g O4 c4. O3 g e g4. d e c4 P8"
PLAY "L16 g e L8 c c L16 c d e f L8 g g g e a a a. L16 g a8. g a b"
PLAY "O4 L16 c d e4. c O3 g O4 c4. O3 g e g4. d e c4."
PLAY "L16 T150 g a b T120 O4 L8 c e d. c16 O3 a O4 c4 O3 a O4 d4."
PLAY "O3 a O4 d4. O3 T150 L16 g a b T120 L8 O4 c e d. c16"
PLAY "L8 O3 a b O4 c. O3 a16 g e O4 c. O3 e16 e d4 e c4. e d4. a"
PLAY "L8 g e O4 c. e16 d c4 O3 e c4. e d4. a g e O4 e4. c16 d c4"

GOTO relee

stars:
FOR i = 1 TO 8
x = starx(i): y = stary(i)
PSET (x, y), 0
LINE (x + 2, y - 1)-(x + 8, y + 16), 15
LINE -(x - 6, y + 2): LINE -(x - 20, y + 16)
LINE -(x - 14, y - 1): LINE -(x - 30, y - 9)
LINE -(x - 12, y - 9): LINE -(x - 6, y - 25)
LINE -(x, y - 9): LINE -(x + 16, y - 9)
LINE -(x + 2, y - 1): PAINT (x, y), 15
NEXT i
RETURN
relee:
END SUB