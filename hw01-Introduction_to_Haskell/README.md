# CIS194 - Homework 1

* Exercise 1~ 4 是一組，驗證信用卡卡號
* Exercise 5~ 6 是河內塔，經典的三柱和變形的四柱版本

## Exercise 1

要注意的是在List頭、尾加新東西的寫法不大一樣 `:` vs. `++`，而且一個有 `[]`

在 List 的頭加新東西
Add an element to the start of a list.
```Haskell
new_element : xs
```
在 List 最後加新東西
Add an element to the end of a list.
```Haskell
xs ++ [new_element]
```


## Exercise 2

這是我的寫法，大概是 扣掉最後兩個的部分 遞迴地繼續做 ; 取最後兩個出來，最後的那個不變，直接貼回去 ; 倒數第二個\*2黏上去，
但這樣缺點是 code 有點長，很難懂
有看到別人的做法是用`reverse`, `zipWith` 和 `(cycle [1,2])`，這樣比較短也比較好懂

```Haskell
doubleEveryOther :: [Integer] -> [Integer]
doubleEveryOther []  = []
doubleEveryOther [x] = [x]
doubleEveryOther xs  = (doubleEveryOther $ init $ init xs) ++ [ (*2) $ last $ init xs] ++ [last xs] 
```

## Exercise 3

因為 doubleEveryOther 結果只會是 一位數或二位數，所以取值的部分只要處理十位數和個位數，太大不考慮了
```Haskell
sumDigits :: [Integer] -> Integer
sumDigits [] = 0
sumDigits (x:xs) = x `div` 10 + x `mod` 10 + sumDigits xs 
```

## Exercise 4

把前面的東西都串起來 : 一個卡號 n
* 先 `toDigits`
* 再 `doubleEveryOther`
* 接著 `sumDigits`
* 最後檢查 `mod 10 == 0`

```Haskell
validate :: Integer -> Bool
validate n =  ( sumDigits $ doubleEveryOther $ toDigits n) `mod` 10 == 0
```

發現有個網站 http://pointfree.io/
可以把 code 換成 pointfree 的版本，上面的 validate 輸進去可以寫成

```Haskell
validate = (0 ==) . (`mod` 10) . sumDigits . doubleEveryOther . toDigits
```

酷

## Exercise 5

經典河內塔問題 ~


## Exercise 6

從三柱改為四柱

Frame 和 Stewart 在 1941年 提出演算法，但一直到 2014年 才被證明 Frame-Stewart 演算法在四柱時就是最佳解，但五柱以上好像還沒被證明。

下面是 [Frame-Stewart 演算法](https://en.wikipedia.org/wiki/Tower_of_Hanoi#Frame%E2%80%93Stewart_algorithm)


另 f\(n, k\) 是 k 根柱子時，把 n 個盤子移動到其他柱子所需要的步數。

1. 先將 m 個盤子移動到輔助的柱子上  --> f\(m, k\) 步 
2. 接著將剩餘的 \(n-m\) 個盤子移動到目標柱  --> f\(n-m, k-1\) 步 
3. 最後再將那一開始移的 m 個盤移動到目標柱上  --> f\(m, k\) 步 

m 是 ```n - round (sqrt (2*n + 1)) + 1``` !!!

\( 用 Haskell 要注意的是 n 是 Integer 但 ```sqrt :: Floating a => a -> a```，所以要先做轉型 \)


以這題一開始 k = 4 為例

```
     f (n, 4)
 =   f (m, 4)  --> 1. 將 m 個盤子從 src 移動到 tmp (有兩根輔助的，是哪一根沒差)
   + f(n-m, 3) --> 2. k = 3 時就是經典的三駐河內塔 (4 變 3 因為一根背上一步的 m 個盤子佔走)
   + f (m, 4)  --> 3. 將 m 個盤子從 tmp 移動到 dst (還沒移動前，有 n-m 盤 在 dst, m 在 tmp)
 =   2 * f (m, 4) + f(n-m, 3)
 = ...
就這樣遞迴下去
 
```

Haskell code

```Haskell
--           n          k       src    dst    tmp1   tmp2         
hanoi4 :: Integer -> Integer -> Peg -> Peg -> Peg -> Peg -> [Move]
hanoi4 1 _ src dst _ _ = [ (src, dst) ]
hanoi4 n k src dst tmp1 tmp2 = mFromSrc2Tmp ++ restFromSrc2Dst ++ mFromTmp2Dst
                                where n' = fromIntegral n :: Double
                                      m  = n - round ( sqrt ( (2*n'+1) ) ) + 1
                                      leftN = n - m
                                      mFromSrc2Tmp    = hanoi4 m k src tmp1 dst tmp2
                                      restFromSrc2Dst = hanoi leftN src dst tmp2
                                      mFromTmp2Dst    = hanoi4 m k tmp1 dst src tmp2
```

我的邊界條件是寫 `hanoi4 1 _ src dst _ _ = [ (src, dst) ]`，只要移動一個時，就直接移動了，不用管有幾根輔助的


總而言之，n 根柱子的河內塔可以套用 (n-1) 根柱子的河內塔~


###### tags: `Haskell`, `CIS194`