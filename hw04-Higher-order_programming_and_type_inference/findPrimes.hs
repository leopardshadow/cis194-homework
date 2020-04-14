import Data.List

sieveSundaram :: Integer -> [Integer]
sieveSundaram n = map (\x->x*2+1) $ [1..n] \\ foldr (\(x,y) l ->  (x+y+2*x*y):l) [] ijPair
                    where ijPair = [(i,j) | j<-[1..n], i<-[1..j]]