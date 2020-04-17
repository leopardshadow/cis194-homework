# CIS194 - Homework 6

## Exercise 1

經典費氏數列

```Haskell
fib :: Integer -> Integer
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)
```

```Haskell
fibs1 :: [Integer]
fibs1 = map fib [0..]
```

## Exercise 2

Exercise 2 要做和 `fib1` 一樣的結果，但只要 O\(n\) 的時間的時間複雜度

我的想法是從儲存 費氏數列的 list 下手，下一個元素是前兩個的和，這樣遞推接下去

```Haskell
fibs2 :: [Integer]
fibs2 = 0 : 1 : next fibs2
			where next xs = (head xs + head (tail xs)) : next (tail xs)
```
[Haskell wiki](https://wiki.haskell.org/The_Fibonacci_sequence#With_iterate) 上比較精簡的寫法是

```Haskell
fibs2 :: [Integer]
fibs2 = 0 : 1 : next fibs2
			where next (a : t@(b:_)) = (a+b) : next t
```

但上面兩個寫法都會有 Warning
```
Pattern match(es) are non-exhaustive
In an equation for ‘next’:
    Patterns not matched:
        []
        [_]
```


看到網路上有一些[解法](https://stackoverflow.com/questions/1105765/generating-fibonacci-numbers-in-haskell)

```Haskell
fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
```

他的想法大概是
```
      fibs   = 0 1 1 2 3  5  8 13 ...
+) tail fibs = 1 1 2 3 5  8 13 21 ...
--------------------------------------
               1 2 3 5 8 13 21 34 ...
```
很帥，但我沒想到



## Exercise 3

題目要 先定義 Stream
```Haskell
data Stream a = Cons a (Stream a)
```

Cons 的 type signature
```
Cons :: a -> Stream a -> Stream a
```

接著要求把 Stream 轉為 List，就這樣無限接下去
```Haskell
streamToList :: Stream a -> [a]
streamToList (Cons x xs) = x : streamToList xs
```


最後，要幫 Stream 定義一個 show 函式，show 是 `a -> String` ，要只秀出前 20 個
* 把 Stream 轉成 List
* 取前 20 個
* map show 上一步的list ，轉成 list of string
* 用 fold 把 list of string 串成一個 String

```Haskell
instance Show a => Show (Stream a) where
    show s = foldr (\x y -> x ++ " " ++ y ) [] (map show (take 20 $ streamToList s))
```

後來看了別人的寫法，不用這麼麻煩啊，因為 list 本來就是 `Show` 可以 `show`

```Haskell
instance Show a => Show (Stream a) where
    show = show . take 20 . streamToList
```



## Exercise 4

在 streamMap 中再次感受到 **pattern matching** 好好用 !
```Haskell
streamMap :: (a -> b) -> Stream a -> Stream b
streamMap f (Cons x xs) = Cons (f x) (streamMap f xs)
```


一開始我的寫法是
```Haskell
streamFromSeed :: (a -> a) -> a -> Stream a
streamFromSeed f x = let next = f x in Cons (next) (streamFromSeed f next)
```
但題目要的是一開始的 seed 會是整個 Stream 的第一個，所以應該改成
```Haskell
streamFromSeed :: (a -> a) -> a -> Stream a
streamFromSeed f x = Cons x (streamFromSeed f (f x) )
```
一開始 Cons 的第一個參數是 x 而不是 f x



## Exercise 5

題外話，natural number 他是從 0 開始的
```Haskell
nats :: Stream Integer
nats = streamFromSeed (+1) 0
```

以下是 ruler function 我的解法，```ruler :: Stream Integer```
這個函數換一個方式說就是 [1,2,3,4,5..] 對應的數字 可以被幾次 2 整除
```Haskell
ruler :: Stream Integer
ruler = streamMap timesDiv2 (streamFromSeed (+1) 1)


timesDiv2 :: Integer -> Integer
timesDiv2 n 
    | n `mod` 2 == 0 = 1 + timesDiv2 ( n `div` 2 )
    | otherwise = 0
```

在旁邊的提示中，他提到

> Hint: define a function interleaveStreams which alternates the elements from two streams. Can you use this function to implement ruler in a clever way that does not have to do any divisibility testing?

參考了 [reddit Haskell版](https://www.reddit.com/r/haskell/comments/b559cu/questions_about_implementing_the_ruler_function/)，別人是這樣寫的

```Haskell
ruler :: Stream Integer
ruler = streamInterleave (streamRepeat 0) (streamMap (+1) ruler)

streamInterleave :: Stream a -> Stream a -> Stream a
streamInterleave (Cons x xs) ys = Cons x (streamInterleave ys xs)
```

用了 Haskell 的 lazy 特性，這我還真的想不到 ...


## Exercise 6

x 太常用了，所以我改成 `z`，一直跑 `warning: [-Wname-shadowing] This binding for ‘x’ shadows the existing binding` 好煩

總覺得有些句子在這裡有點難懂，例如說這句

> Define an instance of the Num type class for Stream Integer.
> 

他的意思是，讓 \(Stream Integer\) 成為 Num 這個 type class 的 instance

Num 這個 type class 定義了
```
class  (Eq a, Show a) => Num a  where
    (+), (-), (*)    :: a -> a -> a
    negate           :: a -> a
    abs, signum      :: a -> a
    fromInteger      :: Integer -> a
```
這些函數。 換言之，就是要定義 Num 的這些函數。而要坐後面的事情，只需要定義 `fromIneger`, `negate`, `(+)` 和 `(*)` ，其他不需要定義，可以用 `{-# OPTIONS_GHC -fno-warn-missing-methods #-}` 把 提醒沒有定義完所有的 function 這個 Warning 關起來。



接著，讓 \(Stream Integer\) 成為 Fractional 這個 type class 的 instance

exercise 6 的 code:
```Haskell
z :: Stream Integer
z = Cons 0 $ Cons 1 $ streamRepeat 0

-- x0 = streamMap (\x -> if x == 1 then 1 else 0) nats

instance Num (Stream Integer) where
    fromInteger n = Cons n (streamRepeat 0)
    negate (Cons x xs) = Cons (negate x) xs 
    (+) (Cons x0 xs) (Cons y0 ys) = Cons (x0 + y0) (xs + ys)
    (*) (Cons x0 xs) t2@(Cons y0 ys) = Cons (x0 * y0) (streamMap (*x0) ys + xs * t2)


instance Fractional (Stream Integer) where
    (/) (Cons x0 xs) (Cons y0 ys) = q 
        where q = Cons (x0 `div` y0) (streamMap (`div` y0) (xs - q * ys))


fibs3 :: Stream Integer
fibs3 = z / (1 - z - z^2)
```

## Exercise 7

除了用多項式的算法，也可以用矩陣來算費氏數列\~

```Haskell

{-
    | a b |
    | c d |

    F^n = | F^{n+1}   F^n   |
          |   F^n   F^{n-1} |
-}
data Matrix = Matrix { a :: Integer, b :: Integer, c :: Integer, d :: Integer} 
                deriving Show

instance Num Matrix where
    (*) (Matrix a1 b1 c1 d1) (Matrix a2 b2 c2 d2) = 
            Matrix (mmul a1 b1 a2 c2) (mmul a1 b1 b2 d2) (mmul c1 d1 a2 c2) (mmul c1 d1 b2 d2)
            where mmul x1 x2 y1 y2 = x1 * y1 + x2 * y2 

f :: Matrix
f = Matrix 1 1 1 0

fib4 :: Integer -> Integer
fib4 0 = 0
fib4 n = b (f ^ n)
```

0 要特別處理


###### tags: `Haskell`, `CIS194`