' Called from foritfy, animate, menu-utiltiies, railroad, recruit, and turn-update.
SUB occupy (x)
    occupied(x) = 0
    FOR i = 1 TO 40
    IF armyloc(i) = x THEN occupied(x) = i: GOTO holdup
    NEXT i
    holdup:
END SUB