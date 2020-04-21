{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE  GeneralizedNewtypeDeriving, TypeSynonymInstances, FlexibleInstances #-}

module JoinList where


import Data.Monoid()

import Sized
import Buffer
-- import Editor

import Scrabble



data JoinList m a = Empty
                  | Single m a
                  | Append m (JoinList m a) (JoinList m a)
    deriving (Eq, Show)


-- Exercise 1

(+++) :: Monoid m => JoinList m a -> JoinList m a -> JoinList m a
(+++) jl1 jl2 = Append (tag jl1 <> tag jl2) jl1 jl2


tag :: Monoid m => JoinList m a -> m
tag Empty          = mempty
tag (Single m _)   = m
tag (Append m _ _) = m



exercise1 :: JoinList String Char
exercise1 = ( y +++ (e +++ a) ) +++ h
    where y = Single "5" 'y'
          e = Single "2" 'e'
          a = Single "3" 'a'
          h = Single "7" 'h'



-- Exercise 2


jlToList :: JoinList m a -> [a]
jlToList Empty = []
jlToList (Single _ a) = [a]
jlToList (Append _ l1 l2) = jlToList l1 ++ jlToList l2


-- Exercise 2 - 1

indexJ :: (Sized b, Monoid b) => Int -> JoinList b a -> Maybe a

indexJ _ Empty = Nothing 

indexJ 0 (Single _ a) = Just a
indexJ _ (Single _ _) = Nothing

indexJ i (Append m jl1 jl2)
    | i < 0 || i >= root = Nothing
    | i < left = indexJ i jl1
    | otherwise = indexJ (i - left) jl2
    where root = getSize . size $ m
          left = getSize . size . tag $ jl1


exercise2_1 :: Bool
exercise2_1 = (indexJ i jl) == (jlToList jl !!? i)
    where i = 1        
          y = Single (Size 1) 'y'
          e = Single (Size 1) 'e'
          a = Single (Size 1) 'a'
          h = Single (Size 1) 'h'
          jl = ( y +++ (e +++ a) ) +++ h
 


(!!?) :: [a] -> Int -> Maybe a 
[] !!? _ = Nothing
_ !!? i | i < 0 = Nothing 
(x:xs) !!? 0 =Just x 
(x:xs) !!? i = xs !!? (i-1)


-- Exercise 2 - 2

-- discard index < i
dropJ :: (Sized b, Monoid b) => Int -> JoinList b a -> JoinList b a

dropJ index jl | index <= 0 = jl

dropJ _ Empty = Empty

dropJ _ (Single _ _) = Empty

dropJ i (Append m jl1 jl2)
    | i >= root = Empty
    | i < left = dropJ i jl1 +++ jl2
    | otherwise = dropJ i jl1 +++ dropJ (i - left) jl2
    where root = getSize . size $ m
          left = getSize . size . tag $ jl1


exercise2_2 :: Bool
exercise2_2 = jlToList (dropJ n jl) == drop n (jlToList jl)
    where n = 2        
          y = Single (Size 1) 'y'
          e = Single (Size 1) 'e'
          a = Single (Size 1) 'a'
          h = Single (Size 1) 'h'
          jl = ( y +++ (e +++ a) ) +++ h

    
-- Exercise 2 - 3

takeJ :: (Sized b, Monoid b) => Int -> JoinList b a -> JoinList b a
takeJ i _ | i <= 0 = Empty

takeJ _ Empty = Empty

takeJ _ jl@(Single _ _) = jl

takeJ i jl@(Append m jl1 jl2)
    | i >= root = jl
    | i < left  = takeJ i jl1
    | otherwise = takeJ i jl1 +++ takeJ (i - left) jl2
    where root = getSize . size $ m
          left = getSize . size . tag $ jl1


-- Exercise 3

scoreLine :: String -> JoinList Score String
scoreLine s = Single (scoreString s) s


exercise3 :: JoinList Score String
exercise3 = scoreLine "yay " +++ scoreLine "haskell!"



-- Exercise 4

-- m is Monoid, make (JoinList m a) a Semigroup instance
instance Monoid m => Semigroup (JoinList m a) where
    (<>) = (+++)

-- m is Monoid, make (JoinList m a) a Monoid instance
instance Monoid m => Monoid (JoinList m a) where
    mempty  = Empty
    mappend = (+++)


instance Buffer (JoinList (Score, Size) String) where

    -- toString :: b -> String
    toString = unlines . jlToList

    -- fromString :: String -> b
    fromString = mconcat . fmap jl . lines
                    where jl s = Single (scoreString s, Size 1) s

    -- line :: Int -> b -> Maybe String
    line n buf = indexJ n buf

    -- replaceLine :: Int -> String -> b -> b
    replaceLine l s buf = (takeJ l buf) +++  (fromString s) +++ (dropJ (l+1) buf)

    --  (Score, Size)
    --    fst   snd

    -- | Compute the number of lines in the buffer.
    -- numLines :: b -> Int
    numLines = getSize  . snd . tag

    -- -- | Compute the value of the buffer, i.e. the amount someone would
    -- --   be paid for publishing the contents of the buffer.
    -- value :: b -> Int
    value = getScore . fst . tag


