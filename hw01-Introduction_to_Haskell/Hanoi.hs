{-# OPTIONS_GHC -Wall #-}

-- Exercise 5

type Peg = String
type Move = (Peg, Peg)

hanoi :: Integer -> Peg -> Peg -> Peg -> [Move]
hanoi 0 _ _ _ = []
hanoi n src dst tmp = fromSrc2Tmp ++ fromSrc2Dst ++ fromTmp2Dst
                        where fromSrc2Tmp = hanoi (n-1) src tmp dst
                              fromSrc2Dst = [(src, dst)]
                              fromTmp2Dst = hanoi (n-1) tmp dst src

-- length $ hanoi 15 "a" "b" "c"

-- Exercise 6


-- hanoi4 :: Integer -> Peg -> Peg -> Peg -> Peg -> [Move]
-- hanoi4 0 _ _ _ _ = []
-- hanoi4 n src dst tmp1 tmp2 = fromSrc2Tmp ++ fromSrc2Dst ++ fromTmp2Dst
--                                 where fromSrc2Tmp = hanoi4 (n-1) src tmp dst
--                                       fromSrc2Dst = [(src, dst)]
--                                       fromTmp2Dst = hanoi4 (n-1) tmp dst src
