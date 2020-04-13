module Golf where


-- exercise 1: Hopscotch

skips :: [a] -> [[a]]
skips list = let steps = [ i | i <- [1 .. length list]] in 
              let ids = map (\step -> [step-1, 2*step-1 .. length list-1]) steps in
                    [ (indexAt id list) | id <- ids]
          
indexAt:: [Int] -> [a] -> [a]
indexAt indices list = [list!!x | x <- indices]


-- skips x = [ (foldr \i->{} [] [n | n <- [1, 1+m .. length x]] ) | m <- [1..length x]]

-- erxrcise 2: Local maxima

-- 

--localMaxima :: [Integer] -> [Integer]
--localMaxima 




-- exercise 3: Histogram



