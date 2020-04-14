{-# OPTIONS_GHC -Wall #-}

module Calc where

import ExprT
import Parser


-- Exercise 1

eval :: ExprT -> Integer
eval (Lit n) = n
eval (Add n1 n2) = eval n1 + eval n2
eval (Mul n1 n2) = eval n1 * eval n2

testEx1 :: Bool
testEx1 = and
    [
        eval (Mul (Add (Lit 2) (Lit 3)) (Lit 4)) == 20
    ]


-- Erercise 2

evalStr :: String -> Maybe Integer
evalStr str = case (parseExp Lit Add Mul str) of
                (Just expr) -> Just (eval expr)
                Nothing -> Nothing 

testEx2 :: Bool
testEx2 = and
    [
        evalStr "(2+3)*4" == Just 20, --Just (Mul (Add (Lit 2) (Lit 3)) (Lit 4)),
        evalStr "2+3*4" == Just 14, --Just (Add (Lit 2) (Mul (Lit 3) (Lit 4))),
        evalStr "2+3*" == Nothing
    ]


-- Erercise 3

class Expr a where
    lit :: Integer -> a
    add :: a -> a -> a
    mul :: a -> a -> a


instance Expr ExprT where
    lit n = Lit n
    add e1 e2 = Add e1 e2
    mul e1 e2 = Mul e1 e2


reify :: ExprT -> ExprT
reify = id


testEx3 :: Bool
testEx3 = and
    [
        (mul (add (lit 2) (lit 3)) (lit 4) :: ExprT) == Mul (Add (Lit 2) (Lit 3)) (Lit 4),
        reify (mul (add (lit 2) (lit 3)) (lit 4)) == Mul (Add (Lit 2) (Lit 3)) (Lit 4)
    ]


-- Erercise 4








