{-# OPTIONS_GHC -Wall #-}

data Tree a = Leaf
             | Node Integer (Tree a) a (Tree a)
    deriving (Show, Eq)


foldTree :: [a] -> Tree a 
foldTree = foldr insert Leaf 

insert :: a -> Tree a -> Tree a
insert n Leaf =

    