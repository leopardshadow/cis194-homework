# CIS194 - Homework 10

## 說明

hw10 要做一個 Parser

```Haskell
newtype Parser a
    = Parser { runParser :: String -> Maybe (a, String) }
```

一個 Parser 是一個 function 

* 接受 String 作為參數
* 如果成功的話回傳 1. 成功解析出的東西 和 2. 剩下的字串 \(失敗的話就是 `Nothing`\)


接下來他展示了由一個 `Char -> Bool` 的 predicate 建構出 Parser

```Haskell
satisfy :: (Char -> Bool) -> Parser Char
satisfy p = Parser f
  where
    f [] = Nothing    -- fail on the empty input
    f (x:xs)          -- check if x satisfies the predicate
                        -- if so, return x along with the remainder
                        -- of the input (that is, xs)
        | p x       = Just (x, xs)
        | otherwise = Nothing  -- otherwise, fail
```

他執行的例子
```
*Parser> runParser (satisfy isUpper) "ABC"
 Just (’A’,"BC")
*Parser> runParser (satisfy isUpper) "abc"
 Nothing
```

接著是一個對 `Integer` 的例子

```Haskell
posInt :: Parser Integer
posInt = Parser f
  where
    f xs
      | null ns   = Nothing
      | otherwise = Just (read ns, rest)
      where (ns, rest) = span isDigit xs
```


`span :: (a -> Bool) -> [a] -> ([a], [a])` 
span 會回傳 `[a]` 中從頭開始都符合 `(a -> Bool)` 的 作為 tuple 中的第一個，而第二個是剩餘的 `[a]`。也就是第一個開始不符合 `(a -> Bool)` 之後的東西。

posInt 執行的例子

```
*AParser> runParser posInt "123"
 Just (123,"")
*AParser> runParser posInt "123abc456"
 Just (123,"abc456")
```


## Exercise 1

### 讓 `Parser` 成為 `Functor` 的 instance 


題目的 Hint 是先從 `first` 這個函數下手

```Haskell
first :: (a -> b) -> (a,c) -> (b,c)
first f (a, c) = (f a, c)
```

給一個 type 是 `(a -> b)` 的函數和一個 `(a, c)` tuple，結果是 `(b, c)` tuple

---

接著，`fmap` 的 type signature 應該要是
```fmap :: (a -> b) -> Parser a -> Parser b```

回想一下 Parser 的定義

 ```
 newtype Parser a
    = Parser { runParser :: String -> Maybe (a, String) }
 ```

綜合來說，把 `Maybe (a, String)` map 成 `Maybe (b, String)`


```Haskell
instance Functor Parser where
  fmap f (Parser p) = Parser (fmap (first f) . p)
```


```
Parser (fmap (first f) . p)
                    | --------* a -> b
             (.......) -------* (a,c) -> (b,c)
```

而 `p` 是 `String -> Maybe (a, String)` 的 function，用 fmap 把轉換的 function `f` map 進去。


---

整理一下一開始不太懂的地方：

1. 對 `newtype` 不太熟，還有 record syntax 之前看到的都是 String, Int 等 type，而不是函數。
2. 一共有兩層要拆解，一個是題目要求的，讓 `Parser` 成為 `Functor` 的 instance ; 另外一層是 `Maybe` 本身也是個 Functor，所以在裡面還是要用到 fmap 


## Exercise 2

### 讓 `Parser` 成為 `Applicative` instance 

要讓 `Parser` 成為 `Applicative` 的 instance，必須實作 `pure` 和 `<*>`

#### pure

```Haskell
pure a = Parser f
          where f str = Just (a, str)
```

沒有消耗任何 input \(str 過去還是 str\)
a 就直接放在 Just 的 tuple 裡

#### p1 <*> p2

題目說是會先跑 `p1` 這個 Parser，他會消耗一些 input 字串並產生一個 function ; 接著剩下的 input 字串會餵給 `p2` 這個 Parser，並產生值。這兩個 Parser 中如果有任一或都 Fail (`Nothing`)，結果都是 Fail，換句話說，只有兩者都成功才算成功。

```Haskell
(<*>) p1 p2 = Parser f
  where f str = case (runParser p1) str of
                Nothing -> Nothing
                Just (fr, sr) -> case runParser p2 sr of
                                  Nothing -> Nothing
                                  Just (fx, sx) -> Just (fr fx, sx)
```

但在對 `runParser p2 sr` 做 `case ... of` 的地方可以不用這麼麻煩

```
(<*>) p1 p2 = Parser f
  where f str = case (runParser p1) str of
                Nothing -> Nothing
                Just (fr, sr) -> first fr <$> runParser p2 sr
```


## Exercise 3

### abParser

這裡要寫一個 abParser

像是這樣

```
*AParser> runParser abParser "abcdef"
Just ((’a’,’b’),"cdef")
*AParser> runParser abParser "aebcdf"
Nothing
```

所以就是第一個 Parser 要消耗一個 'a'，接著，第二 Parser 要消耗一個 'b'，把這兩個 Parser 組合起來。

上面定義了 char 這個 function，從一個 Char 產生一個 Parser Char

```Haskell
char :: Char -> Parser Char
char c = satisfy (== c)
```


```Haskell
abParser :: Parser (Char, Char)
abParser = (,) <$> char 'a' <*> char 'b'
```

### abParser_

和 abParser 差不多，只是 tuple 中第一個元素從 (’a’,’b’) 換成 ()

```Haskell
abParser_ :: Parser ()
abParser_ = const () <$> abParser
```

### intPair

吃進 `Int` ` (空白)` `Int`，把兩個 Int 放進 list 裡放在 tuple 第一位。

```
*Parser> runParser intPair "12 34"
Just ([12,34],"")
```

```Haskell
intPair :: Parser [Integer]
intPair = (\a _ b -> [a, b]) <$> posInt <*> char ' ' <*> posInt
```

## Exercise 4

### 讓 `Parser` 成為 `Alternative` instance 

要讓 `Parser` 成為 `Alternative` 的 instance，必須實作 `empty` 和 `<|>`

#### empty

empty 表示一直都 Fail \(`Nothing`\)

#### `<|>`

`p1 <|> p2` 表示先試 p1，如果 p1 成功就不理 p2 了，而如果 p1 失敗換試 p2

```Haskell
instance Alternative Parser where

  empty = Parser $ const Nothing
  
  p1 <|> p2 = Parser p
                where p s = runParser p1 s <|> runParser p2 s
```


## Exercise 5


parse 出 Int 或 大寫的 Char


```Haskell
intOrUppercase :: Parser ()
intOrUppercase = (const () <$> posInt) <|> (const () <$> satisfy isUpper)
```




###### tags: `Haskell`