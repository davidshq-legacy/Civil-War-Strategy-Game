' Called by commander, cancel-move, fortify, relieve-commander, menu-command, menu-reports
' movefrom, railroad, reports, stax, battle, computer-player, evaluate, filemanage
SUB starfin (star, fin, who)
    star = 1
    fin = 20
    IF who = 2 THEN star = 21: fin = 40
END SUB