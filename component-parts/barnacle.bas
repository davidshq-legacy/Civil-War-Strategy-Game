SUB barnacle (who)
navysize(who) = navysize(who) - 1
IF navysize(who) > 0 THEN
	fleet$(who) = LEFT$(fleet$(who), navysize(who))
ELSE
	fleet$(who) = "": navyloc(who) = 0: navysize(who) = 0
END IF
END SUB