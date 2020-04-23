{-# OPTIONS_GHC -Wall #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Party where

import Employee
import Data.Tree


-- Exercise 1

-- adds an Employee to the GuestList (update Fun score)

glCons :: Employee -> GuestList -> GuestList
glCons emp (GL empList fun) = GL (emp : empList) (fun + empFun emp)


-- Semigroup and Monoid instance for GuestList

instance Semigroup GuestList where
    (<>) (GL empList1 fun1) (GL empList2 fun2) = GL (empList1 ++ empList2) (fun1 + fun2)

instance Monoid GuestList where
    mempty = (GL [] 0)
    mappend (GL empList1 fun1) (GL empList2 fun2) = GL (empList1 ++ empList2) (fun1 + fun2)


-- retuen the the guest list with more Fun score from 2 guest list

moreFun :: GuestList -> GuestList -> GuestList
moreFun gl1@(GL _ fun1) gl2@(GL _ fun2)
    | fun1 > fun2 = gl1
    | otherwise = gl2

test1 :: [String]
test1 = 
    [
        show $ gl12,
        show $ moreFun gl12 gl3
    ] 
    where a = Emp "a" 1
          b = Emp "b" 2
          c = Emp "c" 4
          gl1 = glCons a (GL [] 0)
          gl2 = glCons b (GL [] 0)
          gl3 = glCons c (GL [] 0)
          gl12 = mconcat [gl1, gl2]


-- Exercise 2

-- treeFold :: (a -> [b] -> b) -> b -> Tree a -> b

-- treeFold f z (Node a []) = f a [z]
-- treeFold f z (Node a sf) = f a [ treeFold f z subTree | subTree <- sf]

-- define fold function for Data.Tree


treeFold :: (a -> [b] -> b) -> Tree a -> b
treeFold f (Node a sf) = f a [ treeFold f subTree | subTree <- sf]

-- treeFold f (Node a []) = f a []


tree :: Tree Int
tree = Node 2 [ 
            Node 3 [],
            Node 4 [
                Node 5 [],
                Node 1 []
            ]
    ]


treeEmp :: Tree Employee
treeEmp = Node (Emp "0" 10) [ 
            Node (Emp "0/A" 2) [],
            Node (Emp "0/B" 4) [
                Node (Emp "0/B/x" 1) [],
                Node (Emp "0/B/y" 1) [],
                Node (Emp "0/B/z" 1) []
            ]
    ]


test2 :: [String]
test2 = [
        show $ treeFold (\x l -> x + sum l) tree,
        show $ treeFold (\x l -> max x (maxx l)) tree,
        show $ treeFold (\e l -> empFun e + sum l) treeEmp
    ] where maxx [] = 0    -- to avoid execption ...
            maxx xs = maximum xs



-- Exercise 3

nextLevel :: Employee -> [(GuestList, GuestList)] -> (GuestList, GuestList)
nextLevel boss gls = (bestGlWithBoss, bestGlWithoutBoss)
    where subGlWBoss = map fst gls
          subGlWOBoss = map snd gls
          bestGlWithBoss = glCons boss (mostFunGl subGlWOBoss)
          bestGlWithoutBoss = mostFunGl subGlWBoss


mostFunGl :: [GuestList] -> GuestList
mostFunGl gl = foldr (moreFun) (GL [] 0) gl

-- testMostFunGl :: Bool
-- testMostFunGl = and
--     [
--         moreFun [  (Emp "a" 1) `glCons`  `glCons`
 
--                 ]
--     ]


-- Exercise 4

-- maxFun :: Tree Employee -> GuestList

-- maxFun tree = fst $ treeFold (nextLevel) (mempty, mempty) tree



