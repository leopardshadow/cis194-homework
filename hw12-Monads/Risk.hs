{-# LANGUAGE GeneralizedNewtypeDeriving #-}

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

data Battlefield = Battlefield { attackers :: Army, defenders :: Army }



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
updateBf (Battlefield atk def) xs = (Battlefield atk def)
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



-- Exercise 3

invade :: Battlefield -> Rand StdGen Battlefield
invade = undefined

endGame :: Battlefield -> Bool
endGame (Battlefield atk def) = (atk < 2) || (def == 0)

