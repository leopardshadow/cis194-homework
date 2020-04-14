# CIS194 - Homework 1


## Exercise 1

要注意的是在List頭、尾加新東西的寫法不大一樣 `:` vs. `++`，且一個有 `[]`

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

這是我的寫法，大概是 扣掉最後兩個的部分 遞迴地繼續做，取最後兩個出來，最後的那個不變，直接貼回去 ; 倒數第二個\*2黏上去，
但這樣缺點是 code 有點長，很難懂
有看到別人的做法是用`reverse`, `zipWith` 和 `(cycle [1,2])`，這樣比較短也比較好懂

```Haskell
doubleEveryOther :: [Integer] -> [Integer]
doubleEveryOther []  = []
doubleEveryOther [x] = [x]
doubleEveryOther xs  = (doubleEveryOther $ init $ init xs) ++ [ (*2) $ last $ init xs] ++ [last xs] 
```
