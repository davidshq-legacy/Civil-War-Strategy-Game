menu0:
CALL topbar
IF player = 2 AND side = 0 THEN side = 1
IF cash(side) < 100 AND navyloc(side) = 0 THEN nflag = 1

hilite = 11
colour = 4
tlx = 67: tly = 13
mtx$(0) = "Main"
mtx$(1) = "Troops": IF rflag < 0 OR cash(side) < 100 THEN mtx$(1) = "-": chosit = 23
mtx$(2) = "Moves": IF mflag > 0 THEN mtx$(2) = "-": IF chosit = 23 THEN chosit = 24
mtx$(3) = "Ships": IF nflag > 0 THEN mtx$(3) = "-": IF chosit = 24 THEN chosit = 25
mtx$(4) = "Railroad": IF rr(side) > 0 THEN mtx$(4) = "-": IF chosit = 25 THEN chosit = 26
mtx$(5) = "END TURN"
mtx$(6) = "Inform"
mtx$(7) = "COMMANDS"
mtx$(8) = "UTILITY"
mtx$(9) = "Files"

size = 9
choose = chosit
CALL menu(0): CALL clrrite