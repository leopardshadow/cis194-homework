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

-- testEx5 :: bool
-- testEx5 = hanoi 2 "a" "b" "c" == [("a","c"), ("a","b"), ("c","b")]