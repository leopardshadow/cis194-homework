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

--           n          k       src    dst    tmp1   tmp2         
hanoi4 :: Integer -> Integer -> Peg -> Peg -> Peg -> Peg -> [Move]
hanoi4 1 _ src dst _ _ = [ (src, dst) ]
hanoi4 n k src dst tmp1 tmp2 = mFromSrc2Tmp ++ restFromSrc2Dst ++ mFromTmp2Dst
                                where n' = fromIntegral n :: Double
                                      m  = n - round ( sqrt ( (2*n'+1) ) ) + 1
                                      leftN = n - m
                                      mFromSrc2Tmp    = hanoi4 m k src tmp1 dst tmp2
                                      restFromSrc2Dst = hanoi leftN src dst tmp2
                                      mFromTmp2Dst    = hanoi4 m k tmp1 dst src tmp2



-- hanoi4 15 4 "a" "b" "c" "d"