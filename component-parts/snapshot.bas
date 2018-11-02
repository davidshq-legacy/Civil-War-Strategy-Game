SUB snapshot (x, y, flag)
IF flag = 0 THEN GET (x - 10, y - 10)-(x + 10, y + 10), image
IF flag = 1 THEN PUT (x - 10, y - 10), image, PSET
END SUB