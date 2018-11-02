	IF _FILEEXISTS("*.sav") THEN filel = 0
filex:
	choose = 23: chosit = 30: IF year = 1861 THEN choose = 22
	mtx$(0) = "Options"
	mtx$(1) = "Load": IF filel = 0 THEN mtx$(1) = "-": choose = 23
	mtx$(2) = "Save"
	mtx$(3) = "New Game"
	mtx$(4) = "Quit"
	size = 4: tlx = 67: tly = 15
	CALL menu(0): CALL clrrite
	SELECT CASE choose
		CASE IS < 1: GOTO menu0
		CASE 1, 2
loader:
			IF choose = 1 AND filel = 0 GOTO filex
			CALL filer(choose + 1)
			IF choose = 1 THEN rflag = 0: mflag = 0: nflag = 0
			GOTO menu0
		CASE 3
			OPEN "O", 1, "cws.cfg"
			WRITE #1, side, graf, noise, difficult, player, turbo!, randbal, train(1), train(2), jancam, realism, batwon(1), batwon(2), casualty&(1), casualty&(2), history, bold
			CLOSE #1
			CLS
			GOTO newgame
		CASE 4: GOTO rusure
	END SELECT
	CASE 99
	GOTO endrnd