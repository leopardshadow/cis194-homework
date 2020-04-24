# CIS194 - Homework 11

延續上週 Parser 的例子

## Exercise 1

這裡要 parse 零次以上 \(\*\) 或 一次以上 \(+\)

題目 Hint 給的是
* 對 `zeroOrMore` 先 parse 一次，如果失敗的話就回傳空的 list
* 對 `oneOrMore` 也是先 parse 一次，再接 `zeroOrMore`

就這樣在兩個之間跳來跳去 !

如果在 imperative programming 裡我一定是想用 do ... while

```Haskell
zeroOrMore :: Parser a -> Parser [a]
zeroOrMore p = oneOrMore p <|> pure []

oneOrMore :: Parser a -> Parser [a]
oneOrMore p = (:) <$> p <*> zeroOrMore p
```


## Exercise 2

零或多個 space~

```Haskell
spaces :: Parser String
spaces = zeroOrMore (satisfy isSpace)
```



串起來：parse 一個英文字，再 parse 一串英數組

```Haskell
ident :: Parser String
ident = (:) <$> (satisfy isAlpha) <*> (zeroOrMore (satisfy isAlphaNum))
```


## Exercise 3







###### tags: `Haskell`, `CIS194`