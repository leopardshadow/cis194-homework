{- CIS 194 HW 11
   due Monday, 8 April
-}

module SExpr where

import AParser
import Control.Applicative
import Data.Char

------------------------------------------------------------
--  1. Parsing repetitions
------------------------------------------------------------

zeroOrMore :: Parser a -> Parser [a]
zeroOrMore p = oneOrMore p <|> pure []

oneOrMore :: Parser a -> Parser [a]
oneOrMore p = (:) <$> p <*> zeroOrMore p

testzeroOrMore :: Bool
testzeroOrMore = and
    [
        runParser (zeroOrMore (satisfy isUpper)) "ABCdEfgH" == Just ("ABC","dEfgH"),
        runParser (zeroOrMore (satisfy isUpper)) "abcdeFGh" == Just ("","abcdeFGh")
    ]

testOneOrMore :: Bool
testOneOrMore = and
    [
        runParser (oneOrMore (satisfy isUpper)) "ABCdEfgH" == Just ("ABC","dEfgH"),
        runParser (oneOrMore (satisfy isUpper)) "abcdeFGh" == Nothing
    ]

------------------------------------------------------------
--  2. Utilities
------------------------------------------------------------

spaces :: Parser String
spaces = zeroOrMore (satisfy isSpace)

ident :: Parser String
ident = (:) <$> (satisfy isAlpha) <*> (zeroOrMore (satisfy isAlphaNum))


testIdent :: Bool
testIdent = and
    [
        runParser ident "foobar baz" == Just ("foobar"," baz"),
        runParser ident "foo33fA" == Just ("foo33fA",""),
        runParser ident "2bad" == Nothing,
        runParser ident "" == Nothing
    ]

------------------------------------------------------------
--  3. Parsing S-expressions
------------------------------------------------------------

-- An "identifier" is represented as just a String; however, only
-- those Strings consisting of a letter followed by any number of
-- letters and digits are valid identifiers.
type Ident = String

-- An "atom" is either an integer value or an identifier.
data Atom = N Integer | I Ident
  deriving Show

-- An S-expression is either an atom, or a list of S-expressions.
data SExpr = A Atom
           | Comb [SExpr]
  deriving Show



 -- parseSExpr :: Parser SExpr
 -- parseSExpr


 