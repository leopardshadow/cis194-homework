{-# OPTIONS_GHC -Wall #-}

-- Exercise 1
toDigits :: Integer -> [Integer]
toDigits n
    | n <= 0    = []
    | otherwise = (toDigits $ n `div` 10) ++ [n `mod` 10]

toDigitsRev :: Integer -> [Integer]
toDigitsRev n
    | n <= 0  = []
    | otherwise = n `mod` 10  : (toDigitsRev $ n `div` 10)


exercise1 = do
    print $ toDigits 1234 == [1,2,3,4]
    print $ toDigitsRev 1234 == [4,3,2,1]
    print $ toDigits 0 == []
    print $ toDigits (-17) == []


-------------
-- NOTES:
-- Add an element to the start of a list.
--     new_element : xs
-- Add an element to the end of a list.
--     xs ++ [new_element]
-------------


-- Exercise 2
doubleEveryOther :: [Integer] -> [Integer]
doubleEveryOther []  = []
doubleEveryOther [x] = [x]
doubleEveryOther xs  = (doubleEveryOther $ init $ init xs) ++ [ (*2) $ last $ init xs] ++ [last xs] 

exercise2 = do
    print $ doubleEveryOther [8,7,6,5] == [16,7,12,5] 
    print $ doubleEveryOther [1,2,3] == [1,4,3]
-------------


-- Exercise 3
sumDigits :: [Integer] -> Integer
sumDigits [] = 0
sumDigits (x:xs) = x `div` 10 + x `mod` 10 + sumDigits xs 
-- sumDigits (x:xs) = sumDigits $ toDigits x + (sumDigits xs)
    
exercise3 = do
    print $ sumDigits [16,7,12,5] == 22
-------------


-- Exercise4
validate :: Integer -> Bool
validate n =  ( sumDigits $ doubleEveryOther $ toDigits n) `mod` 10 == 0

exercise4 = do
    print $ validate 4012888888881881 == True
    print $ validate 4012888888881882 == False
-------------


