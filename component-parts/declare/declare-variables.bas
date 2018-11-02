'==========================================================================
COMMON SHARED choose%, tlx%, tly%, size%, mtx$(), wtype%, colour%, hilite%
COMMON SHARED cityx(), cityy(), cityv(), cityp(), city$(), lname$(), filel
COMMON SHARED cash(), control(), matrix(), income(), anima(), rating(), rflag
COMMON SHARED nflag, bold, turbo!, rr(), starx(), stary(), mtn(), rrfrom()
COMMON SHARED image(), force$(), armyloc(), armyname$(), player, aggress!
COMMON SHARED armysize(), armylead(), armyexper(), supply(), month$()
COMMON SHARED rcity(), price(), vicflag(), tracks(), batwon(), cityo()
COMMON SHARED armymove(), month, year, array(), mflag, side, ATKFAC, DEFAC, TCR
COMMON SHARED navyloc(), navysize(), navymove(), occupied(), vptotal, fort()
COMMON SHARED victory(), graf, noise, capcity(), difficult, usadv, bw
COMMON SHARED train(), font$(), brray(), jancam, randbal, realism, casualty&()
COMMON SHARED pcode, history, thrill, fleet$(), commerce, raider, grudge
'==========================================================================
DIM SHARED cityx(40), cityy(40), cityv(40), cityp(40), city$(40), lname$(40), rcity(5)
DIM SHARED cash(2), control(2), matrix(40, 7), income(2), anima(300), rating(40)
DIM SHARED mtx$(21), image(300), force$(2), armyloc(40), armyname$(40), vicflag(6)
DIM SHARED armysize(40), armylead(40), armyexper(40), supply(40), month$(12)
DIM SHARED armymove(40), array(40), starx(8), stary(8), mtn(1 TO 1564), rrfrom(2)
DIM SHARED navyloc(2), navysize(2), navymove(2), occupied(40), fort(40), rr(2)
DIM SHARED victory(2), capcity(2), emancipate, price(3), tracks(2), fleet$(2)
DIM SHARED train(2), font$(26), brray(40), casualty&(2), batwon(2), cityo(40)

DIM SHARED graphic(1 TO 1564), Ncap(60)
DIM SHARED graft(1 TO 1564)