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
-- myFoldl f base xs = foldr 