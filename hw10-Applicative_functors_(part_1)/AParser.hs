{- CIS 194 HW 10
   due Monday, 1 April
-}

module AParser where

import           Control.Applicative
import           Data.Char

-- A parser for a value of type a is a function which takes a String
-- represnting the input to be parsed, and succeeds or fails; if it
-- succeeds, it returns the parsed value along with the remainder of
-- the input.
newtype Parser a = Parser { runParser :: String -> Maybe (a, String) }

-- For example, 'satisfy' takes a predicate on Char, and constructs a
-- parser which succeeds only if it sees a Char that satisfies the
-- predicate (which it then returns).  If it encounters a Char that
-- does not satisfy the predicate (or an empty input), it fails.
satisfy :: (Char -> Bool) -> Parser Char
satisfy p = Parser f
  where
    f [] = Nothing    -- fail on the empty input
    f (x:xs)          -- check if x satisfies the predicate
                        -- if so, return x along with the remainder
                        -- of the input (that is, xs)
        | p x       = Just (x, xs)
        | otherwise = Nothing  -- otherwise, fail

-- Using satisfy, we can define the parser 'char c' which expects to
-- see exactly the character c, and fails otherwise.
char :: Char -> Parser Char
char c = satisfy (== c)

{- For example:

*Parser> runParser (satisfy isUpper) "ABC"
Just ('A',"BC")
*Parser> runParser (satisfy isUpper) "abc"
Nothing
*Parser> runParser (char 'x') "xyz"
Just ('x',"yz")

-}

-- For convenience, we've also provided a parser for positive
-- integers.
posInt :: Parser Integer
posInt = Parser f
  where
    f xs
      | null ns   = Nothing
      | otherwise = Just (read ns, rest)
      where (ns, rest) = span isDigit xs

------------------------------------------------------------
-- Your code goes below here
------------------------------------------------------------



-- Exercise 1

-- instance Functor Parser where
--   fmap f p = Parser (first f (runParser p))

instance Functor Parser where
  fmap f (Parser p) = Parser (fmap (first f) . p)

first :: (a -> b) -> (a,c) -> (b,c)
first f (a, c) = (f a, c)


-- Exercise 2

instance Applicative Parser where
  pure a = Parser f
              where f str = Just (a, str)

  (<*>) p1 p2 = Parser f
      where f str = case (runParser p1) str of
                    Nothing -> Nothing
                    Just (fr, sr) -> case runParser p2 sr of
                                      Nothing -> Nothing
                                      Just (fx, sx) -> Just (fr fx, sx)


  -- (<*>) p1 p2 = Parser f
  --     where f str = case (runParser p1) str of
  --                   Nothing -> Nothing
  --                   Just (fr, sr) -> first fr <$> runParser p2 sr





-- Exercise 3



abParser :: Parser (Char, Char)
abParser = (,) <$> char 'a' <*> char 'b'



abParser_ :: Parser ()
abParser_ = const () <$> abParser


intPair :: Parser [Integer]
intPair = (\a _ b -> [a, b]) <$> posInt <*> char ' ' <*> posInt




-- Exercise 4

instance Alternative Parser where

  empty = Parser $ const Nothing
  p1 <|> p2 = Parser p
                  where p s = runParser p1 s <|> runParser p2 s




-- Exercise 5

-- intOrUppercase :: Parser ()







