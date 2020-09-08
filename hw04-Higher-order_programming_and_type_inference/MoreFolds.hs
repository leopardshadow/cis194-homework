{-# OPTIONS_GHC -Wall #-}


xor :: [Bool] -> Bool
xor = foldr (/=) False

testXor :: Bool
testXor = and
    [
        xor [False, True, False] == True,
        xor [False, True, False, False, True] == False
    ]


map' :: (a -> b) -> [a] -> [b]
map' f lst = foldr (\x l -> f x : l) [] lst

testMap :: [String]
testMap =
    [
        show $ map' (+10) [4..10],
        show $ map' (*3) [8..11]
    ]


-- myFoldl :: (a -> b -> a) -> a -> [b] -> a 
-- myFoldl = foldr . flip
-- myFoldl f base lst = foldr (\x y -> f y x) base lst 

myFoldl :: (b -> a -> b) -> b -> [a] -> b
myFoldl f base xs = foldr (\e acc -> acc `f` e) base (reverse xs)



testFold :: Bool
testFold = and
    [
        foldl (-) 0 [1..3] == myFoldl (-) 0 [1..3], 
        myFoldl (++) "000" ["A", "bb", "CCC"] == foldl (++) "000" ["A", "bb", "CCC"]
    ]
