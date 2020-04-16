xor :: [Bool] -> Bool
xor = foldr (\b1 b2 -> (b1 && (not b2)) || ((not b1) && b2)) False
-- pointfree :)
-- xor lst = foldr (\b1 b2 -> (b1 && (not b2)) || ((not b1) && b2)) False lst

testXor = and
    [
        xor [False, True, False] == True,
        xor [False, True, False, False, True] == False
    ]


map' :: (a -> b) -> [a] -> [b]
map' f lst = foldr (\x l -> f x : l) [] lst

testMap = and
    [
        map (+10) [1..10] == map' (+10) [1..10],
        map (*3) [1..10] == map' (*3) [1..10]
    ]


-- myFoldl :: (a -> b -> a) -> a -> [b] -> a 
-- myFoldl f base xs = foldr 