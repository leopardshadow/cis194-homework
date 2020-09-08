# CIS194 - Homework 4

Exercise 1- 4 各自對應不同的檔案

## Exercise 1: Wholemeal programming

Wholemeal.hs

這題給了兩個 function，要我們把這兩個 function 換一種方式寫。

> Reimplement each of the following functions in a more idiomatic Haskell style.
> Use wholemeal programming practices, breaking each function into a pipeline of incremental transformations to an entire data structure.

```Haskell
fun1' :: [Integer] -> Integer
fun1' lst = foldr (*) 1 (map (\x -> if even x then x-1 else 1) lst)
```

```Haskell
fun2' :: Integer -> Integer
fun2' num = foldl (\x y-> if even y then x+y else x) 0 $ takeWhile (/=1) $ iterate (\x -> if even x then x `div` 2 else 3 * x + 1) num
```
結果也對但沒有達到他的要求 **pipeline of incremental transformations to an entire data structure**

像 `fun2'` 在前面的 `foldl (\x y-> if even y then x+y else x) 0 ` 可以改用 filter

後來改成
```Haskell
fun1' :: [Integer] -> Integer
fun1' = product .  map (subtract 2) . filter even
```

```Haskell
fun2' :: Integer -> Integer
fun2' = sum
        . filter even
        . takeWhile (/=1)
        . iterate (\x -> if even x then x `div` 2 else 3 * x + 1)
```

改用 function composition `.` 的寫法和換行看起來比較清楚 !

## Exercise 2: Folding with trees

Tree.hs

(待補)


## Exercise 3: More folds!

MoreFolds.hs

`xor` 就是 `/=` !!
```Haskell
xor :: [Bool] -> Bool
xor = foldr (/=) False
```

`map’ :: (a -> b) -> [a] -> [b]`
把 map 用 folr 做，就是從 `[]` 開始，每次都接上經由 `f` 這個 function 轉換過後的東西
```Haskell
map' :: (a -> b) -> [a] -> [b]
map' f lst = foldr (\x l -> f x : l) [] lst
```

foldl 用 folr 做

Prelude> :i foldl

下面是 foldr 和 foldl 的 type signature

```
class Foldable (t :: * -> *) where
  ...
  foldl :: (b -> a -> b) -> b -> t a -> b
  ...
  	-- Defined in ‘Data.Foldable’
Prelude> :i foldr
class Foldable (t :: * -> *) where
  ...
  foldr :: (a -> b -> b) -> b -> t a -> b
  ...
  	-- Defined in ‘Data.Foldable’
```


下面是我對 foldr 和 foldl 的理解，除了第一個參數 type signature 的不同，兩者在做的順序也不同。foldr 可以看成把起始值放在右邊，一路往左收 ; 而 foldl 則剛好相反，是把起始值放在左邊，往右收。

![](https://i.imgur.com/iZU6vIp.png)

來看一個例子

```
Prelude> foldr (++) "000" ["A", "bb", "CCC"]
"AbbCCC000"
Prelude> foldl (++) "000" ["A", "bb", "CCC"]
"000AbbCCC"
```

所以啊，**不是**只要把參數順序調換過來就好，還有順序

以下是我的 code

```
myFoldl :: (b -> a -> b) -> b -> [a] -> b
myFoldl f base xs = foldr (\e acc -> acc `f` e) base (reverse xs)
```


## Exercise 4: Finding primes

FindPrimes.hs

[Sieve of Sundaram](https://en.wikipedia.org/wiki/Sieve_of_Sundaram) 是一個產生質數的方法

步驟是
* 產生 `(i, j)` pair, i j 是正整數, 1 <= i <= j
* 從 `[1..n]` 排除掉 `i + j + 2*i*j`  (還有一個條件是 `i + j + 2*i*j` 要 <= n ，不過用集合的 差集 來看就沒差，沒有的東西就不能減)
* 最後把這個 list 每項都 `*2+1`，就是所有小於 \(2n+2\) 的質數 \(除了 2\)

會用到 `\\` 這個 function，要 `import Data.List`
```
(\\) :: Eq a => [a] -> [a] -> [a]
```
```
> [1..10] \\ [5..12]
[1,2,3,4]
```

我一開始的寫法是
```Haskell
sieveSundaram :: Integer -> [Integer]
sieveSundaram n = map (\x->x*2+1) $ [1..n] \\ foldr (\(x,y) l ->  (x+y+2*x*y):l) [] ijPair
                    where ijPair = [(i,j) | j<-[1..n], i<-[1..j]]
```

但換成這樣更清楚
```Haskell
sieveSundaram :: Integer -> [Integer]
sieveSundaram n =  map ( (+1) . (*2) )
                    $ (\\) [1..n]
                    $ map (\(i, j) -> i+j+2*i*j) ijPair
                        where ijPair = [(i,j) | j<-[1..n], i<-[1..j]]
```
用 `$` 隔開有資料流動的感覺。

他題目寫
> Implement the algorithm using function composition

不知道算不算達到他的要求。就先這樣吧，也許之後會有不同想法。


###### tags: `Haskell`, `CIS194`