' Only called by sub navy.
SUB shiptype (who, i)
    a = 1
    IF MID$(fleet$(who), i, 1) = "I" THEN a = 2
    CALL shipicon(who, a)
END SUB