{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE GeneralizedNewtypeDeriving, FlexibleInstances #-}

module Scrabble where 

-- import Data.Monoid
import Data.Char

newtype Score = Score Int
    deriving (Eq, Ord, Show, Num)


getScore :: Score -> Int
getScore (Score i) = i


instance Semigroup Score where
  (<>) = (+)

instance Monoid Score where
    mempty  = Score 0
    mappend = (+)


score :: Char -> Score 
score ch
    | c <= ord 'z' && c >= ord 'a' = Score (scoreTable !! (c - ord 'a') )
    | c <= ord 'Z' && c >= ord 'A' = Score (scoreTable !! (c - ord 'A') )
    | otherwise = 0
    where c = ord ch


testScore :: Bool
testScore = and
    [
        score 'A' == 1,
        score 'b' == 3,
        score ' ' == 0
    ]


scoreTable :: [Int]
scoreTable = 
    [   1,3,3,2,1,  4, 2,4,1,8,
        5,1,3,1,1,  3,10,1,1,1,
        1,4,4,8,4, 10           
    ]


scoreString :: String -> Score
scoreString s = foldr mappend mempty (map score s)
-- scoreString s = mconcat (map score s)



testScoreString :: Bool
testScoreString = and
    [
        (scoreString "yay ") + (scoreString "haskell!") == Score 23
    ]

    
