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
        parseExp Lit Add Mul "(2+3)*4" == Just (Mul (Add (Lit 2) (Lit 3)) (Lit 4)),
        parseExp Lit Add Mul "2+3*4" == Just (Add (Lit 2) (Mul (Lit 3) (Lit 4))),
        parseExp Lit Add Mul "2+3*" == Nothing
    ]

