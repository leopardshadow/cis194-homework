module Golf where


-- exercise 1: Hopscotch

skips :: [a] -> [[a]]
skips list = let steps = [ i | i <- [1 .. length list]] in 
              let ids = map (\step -> [step-1, 2*step-1 .. length list-1]) steps in
                    [ (indexAt id list) | id <- ids]
          
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

exercise2 = do 
    print $ localMaxima [2,9,5,6,1] == [9,6]
    print $ localMaxima [2,3,4,1,5] == [4]
    print $ localMaxima [1,2,3,4,5] == []

-- exercise 3: Histogram



