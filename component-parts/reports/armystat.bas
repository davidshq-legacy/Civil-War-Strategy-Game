SUB armystat (index)
LINE (530, 60)-(639, 150), 0, BF
COLOR 15
LOCATE 5, 68: PRINT armyname$(index)
COLOR 9: IF index > 20 THEN COLOR 7
LOCATE 6, 68: PRINT "Size:"; : CALL strong(index)
LOCATE 7, 68: PRINT "Leader:"; TAB(75); armylead(index)
LOCATE 8, 68: PRINT "Exper:"; TAB(75); armyexper(index)
IF supply(index) < 2 THEN COLOR 12
LOCATE 9, 68: PRINT "Supply:"; TAB(75); supply(index)
END SUB