SUB armyxy (x, y, z)
LINE (x - 5, y - 3)-(x + 10, y + 8), 0, BF
SELECT CASE z
	CASE 1
	LINE (x - 7, y - 5)-(x + 7, y + 5), 4, BF
	LINE (x - 7, y - 5)-(x - 1, y), 1, BF
	LINE (x, y - 2)-(x + 7, y - 1), 7, B
	LINE (x - 7, y + 2)-(x + 7, y + 3), 7, B
	LINE (x - 8, y - 6)-(x + 8, y + 6), 0, B
	CASE 2
	LINE (x - 7, y - 5)-(x + 7, y + 5), 4, BF
	LINE (x - 8, y - 6)-(x + 8, y + 6), 0, B
	LINE (x - 7, y - 4)-(x + 6, y + 5), 9
	LINE (x - 7, y + 4)-(x + 6, y - 5), 9
	LINE (x - 7, y - 5)-(x + 7, y + 5), 9
	LINE (x - 7, y + 5)-(x + 7, y - 5), 9
	CASE ELSE
END SELECT
END SUB