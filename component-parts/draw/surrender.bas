SUB surrender (who)
SCREEN 12
s = 1: c = 1: COLOR 0: w = 514
IF who > 20 THEN c = 7: s = 2
'               background
LINE (w + 15, 440)-(w + 125, 16), 2, BF
LINE (w + 15, 16)-(w + 125, 290), 3, BF
LINE (w + 14, 16)-(w + 125, 440), c, B
x = 77: y = 280
CIRCLE (w + x + 10, y + 30), 30, 4, , , .1
PAINT (w + x + 10, y + 30), 6, 4
LINE (w + x, y + 28)-(w + x + 6, y + 28): LINE -(w + x + 6, y + 8)
LINE -(w + x + 8, y + 8): LINE -(w + x + 8, y + 28)
LINE -(w + x + 12, y + 28): LINE -(w + x + 12, y + 12)
LINE -(w + x + 15, y + 12): LINE -(w + x + 15, y + 30)
LINE -(w + x + 18, y + 30): LINE -(w + x + 18, y + 20)
LINE -(w + x + 21, y + 21): LINE -(w + x + 21, y + 32)
LINE -(w + x + 25, y + 32): LINE -(w + x + 25, y + 17)
LINE -(w + x + 27, y + 17): LINE -(w + x + 25, y - 10)
LINE -(w + x + 19, y - 14): LINE -(w + x + 15, y - 5)
LINE -(w + x + 12, y - 12): LINE -(w + x + 8, y - 15)
LINE -(w + x + 6, y - 15): LINE -(w + x + 6, y - 11)
LINE -(w + x + 3, y - 14): LINE -(w + x + 2, y - 14)
LINE -(w + x + 1, y - 10): LINE -(w + x - 3, y - 11)
LINE -(w + x - 3, y + 15): LINE -(w + x, y + 15)
LINE -(w + x, y - 3): LINE -(w + x + 2, y - 3)
LINE -(w + x, y + 28)
PAINT (w + x + 10, y), 8 - c, 0

CIRCLE (w + x + 7, y - 10), 3, 0: PAINT (w + x + 7, y - 10), 0, 0
CIRCLE (w + x + 20, y - 8), 3, 0: PAINT (w + x + 20, y - 8), 0, 0

LINE (w + x + 5, y - 30)-(w + x + 6, y - 9)
LINE (w + x + 20, y)-(w + x + 35, y + 30)
LINE (w + x + 20, y + 1)-(w + x + 35, y + 31)
LINE (w + x + 22, y - 31)-(w + x + 21, y - 8)
LINE (w + x - 1, y - 28)-(w + x, y - 8)
'                       boot
CIRCLE (w + 37, 425), 22, 8, , , .3
PAINT (w + 37, 430), 8, 8
LINE (w + 26, 426)-(w + 46, 426)
LINE -(w + 46, 423): LINE -(w + 36, 419)
LINE -(w + 36, 397): LINE -(w + 26, 397)
LINE -(w + 26, 426)
PAINT (w + 27, 399), 0, 0
'                       arm
LINE (w + 26, 397)-(w + 25, 396): LINE -(w + 24, 374)
LINE -(w + 25, 346): LINE (w + 25, 346)-(w + 22, 341)
LINE -(w + 46, 341): LINE -(w + 46, 349)
LINE -(w + 41, 365): LINE -(w + 41, 380)
LINE -(w + 36, 398)
PAINT (w + 30, 350), c, 0
'                       saber
LINE (w + 55, 288)-(w + 58, 360), 14, BF
LINE (w + 55, 288)-(w + 55, 360), 14
LINE (w + 56, 361)-(w + 55, 360), 14
LINE (w + 57, 361)-(w + 58, 350), 14
LINE (w + 58, 350)-(w + 58, 288), 14
LINE (w + 55, 272)-(w + 62, 288), 6, B
LINE (w + 56, 273)-(w + 61, 287), 6, B
LINE (w + 57, 274)-(w + 60, 286), 6, B
		  
LINE (w + 54, 295)-(w + 60, 305), 12, BF
LINE (w + 53, 294)-(w + 61, 306), 0, B
LINE (w + 57, 303)-(w + 61, 303)
LINE (w + 57, 298)-(w + 61, 298)
LINE (w + 34, 310)-(w + 46, 312), c, BF
LINE (w + 25, 380)-(w + 35, 378)
LINE (w + 25, 365)-(w + 34, 366)
'                       shoulder
COLOR 0
LINE (w + 53, 297)-(w + 31, 305): LINE -(w + 25, 270)
LINE -(w + 18, 270): LINE -(w + 16, 275)
LINE -(w + 21, 309): LINE -(w + 28, 316)
LINE -(w + 52, 306): LINE -(w + 53, 298)
PAINT (w + 20, 280), c, 0
LINE (w + 30, 310)-(w + 32, 305): LINE -(w + 25, 307)
LINE (w + 46, 298)-(w + 47, 275)
LINE (w + 47, 275)-(w + 41, 269)
LINE (w + 41, 269)-(w + 25, 269)
PAINT (w + 45, 275), c, 0
CIRCLE (w + 40, 275), 1, 14
CIRCLE (w + 40, 285), 1, 14
CIRCLE (w + 40, 295), 1, 14

LINE (w + 21, 306)-(w + 18, 340)
LINE (w + 18, 340)-(w + 47, 340)
LINE (w + 46, 310)-(w + 48, 339)
PAINT (w + 30, 330), c, 0
LINE (w + 46, 312)-(w + 21, 316), 0, BF
LINE (w + 25, 312)-(w + 35, 313), c, BF

LINE (w + 30, 268)-(w + 41, 264), 12, BF
LINE (w + 30, 263)-(w + 41, 263), 0
LINE (w + 30, 264)-(w + 26, 260): LINE -(w + 25, 248)
LINE -(w + 28, 243): LINE -(w + 46, 243)
LINE -(w + 48, 245): LINE -(w + 48, 248)
LINE -(w + 51, 254): LINE -(w + 51, 255)
LINE -(w + 48, 256): LINE -(w + 48, 261)
LINE -(w + 46, 263): LINE -(w + 39, 263)
PAINT (w + 40, 250), 12, 0

LINE (w + 16, 242)-(w + 57, 241), 0, BF
LINE (w + 45, 240)-(w + 28, 240)
LINE -(w + 31, 232): LINE -(w + 45, 232)
LINE -(w + 48, 240)
PAINT (w + 40, 235), c, 0

LINE (w + 80, 303)-(w + 81, 200), 6, BF

LINE (w + 48, 251)-(w + 44, 250), 0, B
LINE (w + 29, 263)-(w + 43, 266)
LINE -(w + 46, 266): LINE -(w + 48, 263)
LINE -(w + 48, 260): LINE -(w + 37, 258)
LINE -(w + 36, 255): LINE -(w + 37, 250)
LINE -(w + 39, 246): LINE -(w + 40, 243)
c = 0: IF s = 2 THEN c = 15: LINE (547, 263)-(558, 263), 15
PAINT (w + 33, 250), c, 0
PAINT (w + 42, 264), c, 0

CALL flags(3 - s, 26, 0)
IF who < 99 THEN CALL TICK(turbo!)
END SUB