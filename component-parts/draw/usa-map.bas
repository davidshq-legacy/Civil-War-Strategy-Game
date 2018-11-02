SUB usa
SCREEN 12
LINE (1, 16)-(527, 440), 10, B
PAINT (200, 200), 2, 10
COLOR 10
'==========================  Mountains =================================
IF _FILEEXISTS("mtn.vga") THEN
	PUT (380, 30), mtn, PSET
	PUT (270, 200), mtn, PSET
	PUT (310, 160), mtn, PSET
	PUT (350, 120), mtn, PSET
	PUT (200, 185), mtn, PSET
	PUT (250, 130), mtn, PSET
	PUT (320, 80), mtn, PSET
	PUT (30, 150), mtn, PSET
	LINE (30, 150)-(70, 190), 2, BF
END IF
'===========================  Kentucky =================================
LINE (105, 190)-(150, 190)
LINE -(150, 185)
LINE -(290, 185)
LINE (276, 185)-(301, 175)
LINE -(305, 160)
LINE -(310, 155)
LINE -(305, 145)
LINE -(300, 125)
LINE -(290, 110)

LINE -(275, 95), 1
LINE -(270, 95), 1
LINE -(260, 100), 1
LINE -(250, 100), 1
LINE -(240, 90), 1
LINE -(235, 85), 1
LINE -(230, 85), 1
LINE -(220, 90), 1
LINE -(220, 100), 1
LINE -(210, 105), 1
LINE -(205, 115), 1
LINE -(195, 125), 1
LINE -(170, 130), 1
LINE -(165, 135), 1
LINE -(130, 140), 1
LINE -(120, 150), 1
LINE -(120, 160), 1
LINE -(115, 165), 1
LINE -(105, 170), 1
LINE -(105, 190), 1
'===========================  Tennessee =================================
LINE (290, 185)-(320, 185)
LINE -(320, 185)
LINE -(315, 195)
LINE -(302, 210)
LINE -(290, 215)
LINE -(275, 230)
LINE -(260, 241)
LINE -(260, 241)
LINE -(70, 241)

LINE (105, 190)-(95, 200), 1
LINE -(80, 220), 1
LINE -(70, 241), 1
'===========================  Mississippi =================================
LINE (143, 241)-(145, 405)
LINE -(135, 400)
LINE -(125, 400)
LINE -(115, 405)
LINE -(110, 400)
LINE -(110, 390)
LINE -(115, 380)
LINE -(115, 375)
LINE -(50, 375)
LINE (115, 375)-(60, 375)

LINE (70, 241)-(65, 280), 1
LINE -(60, 295), 1
LINE -(65, 325), 1
LINE -(65, 335), 1
LINE -(50, 375), 1
'===========================  Alabama =================================
LINE (215, 241)-(232, 375)
LINE (176, 395)-(181, 410)
LINE -(166, 415)
LINE -(161, 400)
LINE -(156, 405)
LINE -(146, 405)
LINE (176, 395)-(176, 385)
LINE -(231, 385)
'===========================  Georgia & Florida ============================
LINE (261, 241)-(296, 241)
LINE -(291, 265)
LINE -(350, 340)
LINE -(336, 390)
LINE -(366, 440)
LINE (336, 385)-(325, 385)   'Fla /Ga Border
LINE -(320, 388)
LINE -(245, 388)
LINE -(230, 385)
LINE (180, 410)-(195, 410)
LINE -(215, 415)
LINE -(225, 425)
LINE -(255, 420)
LINE -(265, 420)
LINE -(270, 425)
LINE -(275, 440)
LINE (347, 409)-(343, 409)
LINE -(343, 431)
LINE -(346, 431)
LINE -(346, 412)
LINE -(349, 412)
LINE (347, 411)-(350, 411), 1

LINE (353, 333)-(358, 336), 10, B
'===========================  South Carolina ================================
LINE (290, 241)-(305, 240)
LINE -(345, 240)
LINE -(350, 250)
LINE -(380, 250)
LINE -(415, 280)
LINE -(385, 315)
LINE -(380, 320)
LINE -(375, 325)
LINE -(350, 330)
LINE -(350, 340)
'===========================  North Carolina ================================
LINE (320, 185)-(500, 185)
LINE -(505, 190)
LINE -(490, 195)
LINE -(490, 205)
LINE -(505, 205)
LINE -(500, 215)
LINE -(485, 220)
LINE -(490, 225)
LINE -(500, 225)
LINE -(500, 230)
LINE -(490, 235)
LINE -(488, 240)
LINE -(480, 241)
LINE -(460, 250)
LINE -(455, 255)
LINE -(440, 265)
LINE -(439, 270)
LINE -(425, 278)
LINE -(415, 280)
LINE (510, 190)-(513, 200), , B
LINE (510, 206)-(510, 226)
LINE -(500, 236)
LINE -(502, 241)
LINE -(512, 228)
LINE -(512, 208)
LINE -(510, 206)

'=========================== Chesapeake ====================================
CALL chessie
'=============== Ohio, Pennslyvania, Maryland, Virginia =====================
LINE (291, 111)-(301, 101), 1
LINE -(316, 96), 1
LINE -(331, 76), 1
LINE -(345, 51), 1
LINE -(351, 30), 1
LINE -(370, 35), 1

LINE (351, 16)-(351, 54)
LINE -(527, 54)
LINE (381, 54)-(381, 81)
LINE -(431, 66)
LINE -(456, 81)
LINE -(471, 111)
LINE (226, 85)-(226, 16)
'=============== Louisiana, Arkansas, Missouri =============================
LINE (50, 375)-(60, 395), 1
LINE -(105, 405), 1
LINE -(110, 420), 1
LINE -(125, 438), 1
LINE (110, 398)-(105, 398)

LINE -(90, 396)
LINE -(90, 400)


LINE -(105, 402)
LINE -(120, 415)
LINE -(115, 420)
LINE -(125, 435)
LINE -(120, 440)
LINE -(110, 425)
LINE -(100, 435)
LINE -(90, 440)
LINE -(50, 430)
LINE -(25, 435)
LINE -(1, 435)
'----------------------------------
PAINT (250, 430), 1, 10
PAINT (110, 439), 1, 10
PAINT (50, 439), 1, 10
'----------------------------------
LINE (1, 300)-(61, 300)       'Ark
LINE (91, 205)-(71, 205)
LINE -(76, 190)
LINE -(71, 185)
LINE -(1, 185)

LINE (106, 170)-(91, 140), 1    'Missouri
LINE -(71, 120), 1
LINE -(76, 110), 1
LINE -(76, 95), 1
LINE -(71, 90), 1
LINE -(61, 95), 1
LINE -(56, 85), 1
LINE -(50, 35), 1
LINE -(46, 20), 1

LINE -(38, 16)

LINE (46, 20)-(61, 17), 1        'Illinois

LINE (150, 17)-(150, 110)
LINE -(147, 125), 1
LINE -(140, 138), 1
'========================== Rivers =========================================

LINE (1, 80)-(15, 77), 1    'Missouri River
LINE -(25, 95), 1
LINE -(50, 98), 1
LINE -(75, 96), 1

LINE (120, 160)-(130, 200), 1  'Tenn River
LINE -(135, 240), 1
LINE -(130, 247), 1
LINE -(160, 250), 1
LINE -(200, 260), 1
LINE -(240, 244), 1
LINE -(245, 240), 1
LINE -(270, 200), 1

LINE (120, 160)-(140, 200), 1  'Cumberland River
LINE -(160, 210), 1
LINE -(200, 208), 1
LINE -(240, 170), 1

LINE (161, 400)-(155, 320), 1  'Tombigbee River
LINE -(145, 300), 1

LINE (161, 400)-(170, 370), 1  'Alabama River
LINE -(200, 350), 1

LINE (230, 425)-(231, 385), 1  'Chattahoochee River
LINE -(233, 350), 1
LINE -(240, 330), 1
LINE -(270, 290), 1

LINE (381, 81)-(431, 66), 1   'Potomac River
LINE -(456, 81), 1
LINE -(471, 111), 1

LINE (485, 150)-(455, 145), 1   'James River
LINE -(400, 150), 1

LINE (489, 200)-(415, 185), 1   'Roanoke River
LINE -(400, 160), 1

LINE (296, 241)-(291, 265), 1   'Savannah River
LINE -(350, 340), 1

LINE (438, 271)-(430, 235), 1  'Cape Fear River
LINE -(420, 205), 1

LINE (500, 80)-(498, 50), 1 'Susquehanna River
LINE -(470, 30), 1

LINE (405, 290)-(360, 240), 1 'Pee Dee River

LINE (400, 300)-(350, 280), 1 'Santee River

LINE (270, 423)-(280, 410), 1 'Suwanee River
LINE -(290, 390), 1

LINE (342, 370)-(300, 350), 1 'Altamaha River

LINE (50, 370)-(1, 330), 1 'Red River

LINE (65, 280)-(1, 240), 1 'Arkansas River

LINE (430, 66)-(400, 100), 1 ' Shenandoah River
LINE -(380, 120), 1

CALL showcity
PSET (493, 280), 1
IF navyloc(1) = 30 OR navyloc(2) = 30 THEN
	DRAW "C11U7R4D3L3BR6BU3D7BU4R3U3D7BR3U7BD4BR4BU4D7R4"
	LINE (485, 241)-(525, 270), 11, B
END IF

IF graf > 1 THEN CALL maptext
IF commerce > 0 THEN
LINE (447, 291)-(525, 317), 4, BF: LINE (447, 291)-(525, 317), 10, B
y = 312
a$ = "COMMERCE"
FOR j = 1 TO LEN(a$): x = ASC(MID$(UCASE$(a$), j, 1)) - 64
PSET (440 + 10 * j, y), 0: DRAW font$(x)
NEXT j
ELSE
LINE (447, 291)-(525, 335), 1, BF
END IF

FOR i = 1 TO 40
IF armyloc(i) > 0 THEN CALL placearmy(i)
NEXT i

FOR k = 1 TO 2
CALL stax(k)
NEXT k

IF player = 2 GOTO nosee
FOR i = 1 TO 40: IF armyloc(i) > 0 AND armymove(i) > 0 THEN CALL icon(armyloc(i), armymove(i), 1)
NEXT i
nosee:
CALL ships
CALL engine
COLOR 13: LOCATE 24, 51: PRINT " "; UCASE$(LEFT$(month$(month), 3)); ","; year
END SUB