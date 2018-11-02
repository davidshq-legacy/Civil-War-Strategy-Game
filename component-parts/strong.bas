SUB strong (index)
a$ = LTRIM$(RTRIM$(STR$(armysize(index)))) + "00"
PRINT a$;
END SUB