{-# LANGUAGE GeneralizedNewtypeDeriving #-}

{-# OPTIONS_GHC -Wall #-}


module Risk where

import Control.Monad.Random
import Data.List (sortBy)


------------------------------------------------------------
-- Die values

newtype DieValue = DV { unDV :: Int } 
  deriving (Eq, Ord, Show, Num)

first :: (a -> b) -> (a, c) -> (b, c)
first f (a, c) = (f a, c)

instance Random DieValue where
  random           = first DV . randomR (1,6)
  randomR (low,hi) = first DV . randomR (max 1 (unDV low), min 6 (unDV hi))

die :: Rand StdGen DieValue
die = getRandom

------------------------------------------------------------
-- Risk

type Army = Int

data Battlefield = Battlefield { attackers :: Army, defenders :: Army } deriving Show



-- Exercise 2

--
atkUnit :: Army -> Army
atkUnit n = min 3 (n-1)

defUnit :: Army -> Army
defUnit = min 2

--
rollDices :: Army -> Rand StdGen [DieValue]
rollDices n = replicateM n die 

--
sortDices :: [DieValue] -> [DieValue]
sortDices = sortBy (flip compare)

--
matchDices :: [DieValue] -> [DieValue] -> [Ordering]
matchDices = zipWith compare

-- 
updateBf :: Battlefield -> [Ordering] -> Battlefield
updateBf (Battlefield atk def) xs = (Battlefield atk' def')
    where atkDeath = length . filter (==GT) $ xs
          defDeath = length . filter (/=GT) $ xs
          atk' = atk - atkDeath 
          def' = def - defDeath

--
battle :: Battlefield -> Rand StdGen Battlefield
battle bf@(Battlefield atk def) = do
    atkDices <- sortDices <$> rollDices (atkUnit atk)
    defDices <- sortDices <$> rollDices (defUnit def)
    return $ updateBf bf (matchDices atkDices defDices)



--
-- evalRandIO (return (Battlefield 5 5)) >>= print
-- evalRandIO (battle (Battlefield 5 5)) >>= print
-- evalRandIO (return (Battlefield 5 5) >>= battle) >>= print
-- evalRandIO (return (Battlefield 5 5) >>= battle >>= battle) >>= print


-- Exercise 3

invade :: Battlefield -> Rand StdGen Battlefield
invade bf = do
    bf' <- battle bf
    if not $ endGame bf'
    then invade bf'
    else return bf'


endGame :: Battlefield -> Bool
endGame (Battlefield atk def) = (atk < 2) || (def == 0)



-- 
-- evalRandIO (invade (Battlefield 5 5)) >>= print


-- exercise 4


atkWin :: Battlefield -> Bool
atkWin (Battlefield _ def) = def == 0

successProb :: Battlefield -> Rand StdGen Double
successProb bf = do
    simulations <- replicateM 1000 (invade bf)
    let wins = length . filter atkWin $ simulations
    return (fromIntegral wins / 1000)

-- evalRandIO (successProb (Battlefield 5 5)) >>= print


-- Exercise 5
exactSuccessProb :: Battlefield -> Double
exactSuccessProb = undefined


