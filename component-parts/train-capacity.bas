SUB traincapacity (who, limit)
IF realism = 0 THEN limit = train(who): EXIT SUB
x = 11: IF side = 2 THEN x = 23
limit = train(who) + 5 * (control(who) - x)
x = 2 * train(who)
IF limit > x THEN limit = x
IF limit < x \ 4 THEN limit = x \ 4
END SUB