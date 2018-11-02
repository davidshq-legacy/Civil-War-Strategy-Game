' Trims empty spaces at beginning and end of armysize(index)
' Adds 00 to value returned by armysize(index)
SUB strong (index)
a$ = LTRIM$(RTRIM$(STR$(armysize(index)))) + "00"
PRINT a$;
END SUB