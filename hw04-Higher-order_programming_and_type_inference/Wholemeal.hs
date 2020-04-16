fun1 :: [Integer] -> Integer
fun1 [] = 1
fun1 (x:xs)
    | even x = (x - 2) * fun1 xs
    | otherwise = fun1 xs

fun1' :: [Integer] -> Integer
fun1' = product .  map (subtract 2) . filter even

-- fun1' lst = foldr (*) 1 (map (\x -> if even x then x-1 else 1) lst)

fun1Test = and
    [
        fun1 [1,2,3,4,5] == fun1' [1,2,3,4,5],
        fun1 [2,4..10] == fun1' [2,4..10],
        fun1 [-3,5,8,9] == fun1' [-3,5,8,9]
    ]


-- never stop when the number <= 0
fun2 :: Integer -> Integer
fun2 1 = 0
fun2 n
    | even n = n + fun2 (n `div` 2)
    | otherwise = fun2 (3 * n + 1)

fun2' :: Integer -> Integer
fun2' = sum
        . filter even
        . takeWhile (/=1)
        . iterate (\x -> if even x then x `div` 2 else 3 * x + 1)



-- fun2' num = foldl (\x y-> if even y then x+y else x) 0 $ takeWhile (/=1) $ iterate (\x -> if even x then x `div` 2 else 3 * x + 1) num

-- using foldr would become
-- fun2' num = foldr (\x y-> if even x then x+y else y) 0 $ takeWhile (/=1) $ iterate (\x -> if even x then x `div` 2 else 3 * x + 1) num

fun2Test = and
    [
        fun2 10 == fun2' 10,
        fun2  1 == fun2'  1,
        fun2 48 == fun2' 48
    ]
