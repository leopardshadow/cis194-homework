{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleInstances #-}
{-# OPTIONS_GHC -fno-warn-missing-methods #-}


module Fibonacci where

-- Exercise 1

fib :: Integer -> Integer
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)


fibs1 :: [Integer]
fibs1 = map fib [0..]


-- Exercise 2

-- fibs2 :: [Integer]
-- fibs2 = 0 : 1 : next fibs2
--          where next xs = (head xs + head (tail xs)) : next (tail xs)

fibs2 :: [Integer]
fibs2 = 0 : 1 : next fibs2
            where next (a : t@(b:_)) = (a+b) : next t


-- Exercise 3

data Stream a = Cons a (Stream a)

streamToList :: Stream a -> [a]
streamToList (Cons x xs) = x : streamToList xs

-- show :: a -> String
-- instance Show a => Show (Stream a) where
--     show s = foldr (\x y -> x ++ " " ++ y ) [] (map show (take 20 $ streamToList s))

instance Show a => Show (Stream a) where
    show = show . take 20 . streamToList


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


-- ruler :: Stream Integer
-- ruler = streamMap timesDiv2 (streamFromSeed (+1) 1)


-- timesDiv2 :: Integer -> Integer
-- timesDiv2 n 
--     | n `mod` 2 == 0 = 1 + timesDiv2 ( n `div` 2 )
--     | otherwise = 0


ruler :: Stream Integer
ruler = streamInterleave (streamRepeat 0) (streamMap (+1) ruler)

streamInterleave :: Stream a -> Stream a -> Stream a
streamInterleave (Cons x xs) ys = Cons x (streamInterleave ys xs)



-- Exercise 6


z :: Stream Integer
z = Cons 0 $ Cons 1 $ streamRepeat 0

-- x0 = streamMap (\x -> if x == 1 then 1 else 0) nats

instance Num (Stream Integer) where
    fromInteger n = Cons n (streamRepeat 0)
    negate (Cons x xs) = Cons (negate x) xs 
    (+) (Cons x0 xs) (Cons y0 ys) = Cons (x0 + y0) (xs + ys)
    (*) (Cons x0 xs) t2@(Cons y0 ys) = Cons (x0 * y0) (streamMap (*x0) ys + xs * t2)


instance Fractional (Stream Integer) where
    (/) t1@(Cons x0 xs) (Cons y0 ys) = q 
        where q = Cons (x0 `div` y0) (streamMap (`div` y0) (t1 - q * ys))


-- some testcases
case1 :: Stream Integer
case1 = fromInteger 10 :: Stream Integer

case2 :: Stream Integer
case2 = fromInteger 3 :: Stream Integer

testNegate  :: Stream Integer
testNegate = fromInteger (-10) :: Stream Integer
-----


fibs3 :: Stream Integer
fibs3 = z / (1 - z - z^2)



-- Exercise 7

-- fib4 :: Integer -> Integer
