' Only used by battle.
SUB normal (xbar, vary, result)
    ' NOTE : vary is VARIANCE
    pct! = 0
    FOR k = 1 TO 12: pct! = pct! + RND: NEXT k
    pct! = pct! - 5.5
    result = xbar + pct! * SQR(vary)
END SUB