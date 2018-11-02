rusure:
choose = 23
mtx$(0) = "Quit"
mtx$(1) = "Yes"
mtx$(2) = "No"
size = 2: colour = 5
tlx = 67: tly = 15
CALL menu(0): CALL clrrite: IF choose = 1 THEN END ELSE GOTO menu0