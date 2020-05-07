{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE TypeSynonymInstances #-}

module Calc where

import ExprT
import Parser
-- import StackVM


-- Exercise 1

eval :: ExprT -> Integer
eval (ExprT.Lit n) = n
eval (ExprT.Add n1 n2) = eval n1 + eval n2
eval (ExprT.Mul n1 n2) = eval n1 * eval n2

testEx1 :: Bool
testEx1 = and
    [
        eval (ExprT.Mul (ExprT.Add (ExprT.Lit 2) (ExprT.Lit 3)) (ExprT.Lit 4)) == 20
    ]


-- Erercise 2

evalStr :: String -> Maybe Integer
evalStr str = case (parseExp ExprT.Lit ExprT.Add ExprT.Mul str) of
                (Just expr) -> Just (eval expr)
                Nothing -> Nothing 

testEx2 :: Bool
testEx2 = and
    [
        evalStr "(2+3)*4" == Just 20, --Just (ExprT.Mul (ExprT.Add (ExprT.Lit 2) (ExprT.Lit 3)) (ExprT.Lit 4)),
        evalStr "2+3*4" == Just 14, --Just (ExprT.Add (ExprT.Lit 2) (ExprT.Mul (ExprT.Lit 3) (ExprT.Lit 4))),
        evalStr "2+3*" == Nothing
    ]


-- Erercise 3

class Expr a where
    lit :: Integer -> a
    add :: a -> a -> a
    mul :: a -> a -> a


instance Expr ExprT where
    lit n = ExprT.Lit n
    add e1 e2 = ExprT.Add e1 e2
    mul e1 e2 = ExprT.Mul e1 e2


reify :: ExprT -> ExprT
reify = id


testEx3 :: Bool
testEx3 = and
    [
        (mul (add (lit 2) (lit 3)) (lit 4) :: ExprT) == ExprT.Mul (ExprT.Add (ExprT.Lit 2) (ExprT.Lit 3)) (ExprT.Lit 4),
        reify (mul (add (lit 2) (lit 3)) (lit 4)) == ExprT.Mul (ExprT.Add (ExprT.Lit 2) (ExprT.Lit 3)) (ExprT.Lit 4)
    ]


-- Erercise 4

-- newtype MinMax  = MinMax Integer deriving (Eq, Show)


instance Expr Integer where
    lit = id
    add = (+)
    mul = (*)


instance Expr Bool where
    lit = (>0)
    add = (||)
    mul = (&&)

---
newtype MinMax  = MinMax Integer deriving (Eq, Show)

instance Expr MinMax where
    lit x = MinMax x
    add (MinMax x) (MinMax y) = MinMax $ min x y
    mul (MinMax x) (MinMax y) = MinMax $ max x y

---
newtype Mod7 = Mod7 Integer deriving (Eq, Show)

instance Expr Mod7 where
    lit x   = Mod7 $ x `mod` 7
    add (Mod7 x) (Mod7 y) = Mod7 $ (x + y) `mod` 7
    mul (Mod7 x) (Mod7 y) = Mod7 $ (x * y) `mod` 7


testExp :: Expr a => Maybe a
testExp = parseExp lit add mul "(3 * -4) + 5"

testInteger :: Maybe Integer
testInteger = testExp :: Maybe Integer

testBool :: Maybe Bool
testBool = testExp :: Maybe Bool

testMM :: Maybe MinMax
testMM = testExp :: Maybe MinMax

testSat :: Maybe Mod7
testSat = testExp :: Maybe Mod7


testEx4 :: Bool
testEx4 = and
    [
        testInteger == Just (-7), 
        testBool == Just True,
        testMM == Just (MinMax 3),
        testSat == Just (Mod7 0)
    ]

