' Used to Draw Victory Conditions Window.
SUB center (y, a$)
    x = LEN(a$)
    x = 26 - x \ 2
    LOCATE y, 7 + x: PRINT a$
END SUB