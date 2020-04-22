{-# OPTIONS_GHC -Wall #-}

module Party where

import Employee


-- Exercise 1

glCons :: Employee -> GuestList -> GuestList
glCons emp (GL empList fun) = GL (emp : empList) (fun + empFun emp)


instance Semigroup GuestList where
    (<>) (GL empList1 fun1) (GL empList2 fun2) = GL (empList1 ++ empList2) (fun1 + fun2)

instance Monoid GuestList where
    mempty = (GL [] 0)
    mappend (GL empList1 fun1) (GL empList2 fun2) = GL (empList1 ++ empList2) (fun1 + fun2)


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

