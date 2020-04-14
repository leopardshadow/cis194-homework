{-# OPTIONS_GHC -Wall #-}


module Golf where

-- exercise 1: Hopscotch

skips :: [a] -> [[a]]
skips list = let steps = [ i | i <- [1 .. length list]] in 
              let indices = map (\step -> [step-1, 2*step-1 .. length list-1]) steps in
                    [ (indexAt index list) | index <- indices]
          
indexAt:: [Int] -> [a] -> [a]
indexAt indices list = [list!!x | x <- indices]



-- TO-DO: Try using fold !!
-- skips x = [ (foldr \i->{} [] [n | n <- [1, 1+m .. length x]] ) | m <- [1..length x]]

-- erxrcise 2: Local maxima
localMaxima :: [Integer] -> [Integer]
localMaxima (n1:n2:n3:list)
    | n1 < n2 && n2 > n3 = n2 : localMaxima restLst
    | otherwise = localMaxima restLst
    where restLst = (n2:n3:list)
localMaxima _ = []


exercise2 :: Bool
exercise2 = and
    [
        localMaxima [2,9,5,6,1] == [9,6],
        localMaxima [2,3,4,1,5] == [4],
        localMaxima [1,2,3,4,5] == []
    ]


-- exercise 3: Histogram
histogram :: [Integer] -> String
histogram lst = unlines $ [ [ if (cntLst!!num >= line) then '*' else ' ' | num <- [0..9] ] | line <- liness  ] ++ legends
                    where cntLst = count lst
                          liness = [maximum cntLst, maximum cntLst-1 .. 1] -- from top bottom
                          legends = ["==========", "0123456789"]


count :: [Integer] -> [Int]
count lst = [ length $ filter (==n) lst | n <- [0..9] ]

{-
putStr $ histogram [1,4,5,4,6,6,3,4,2,4,9]
putStr $ histogram [1,1,1,5]
-}

