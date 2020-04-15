{-# OPTIONS_GHC -Wall #-}

-- Exercise 1

fib :: Integer -> Integer
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)


fibs1 :: [Integer]
fibs1 = map fib [0..]


-- Exercise 2

-- fibs2 :: [Integer]



-- Exercise 3

data Stream a = Cons a (Stream a)

streamToList :: Stream a -> [a]
streamToList (Cons x xs) = x : streamToList xs

-- show :: a -> String
instance Show a => Show (Stream a) where
    show s = foldr (\x y -> x ++ " " ++ y ) [] (map show (take 20 $ streamToList s))


-- test case
s1 :: Stream Int
s1 = Cons 1 s1

s2 :: Stream Char
s2 = Cons 'a' s2


-- Exercise 4

streamRepeat :: a -> Stream a
streamRepeat x = Cons x (streamRepeat x)

streamMap :: (a -> b) -> Stream a -> Stream b
streamMap f (Cons x xs) = Cons (f x) (streamMap f xs)

streamFromSeed :: (a -> a) -> a -> Stream a
streamFromSeed f x = Cons x (streamFromSeed f (f x) )


-- Exercise 5

nats :: Stream Integer
nats = streamFromSeed (+1) 0


ruler :: Stream Integer
ruler = streamMap timesDiv2 (streamFromSeed (+1) 1)


timesDiv2 :: Integer -> Integer
timesDiv2 n 
    | n `mod` 2 == 0 = 1 + timesDiv2 ( n `div` 2 )
    | otherwise = 0

-- interleaveStreams
