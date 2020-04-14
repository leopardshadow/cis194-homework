# CIS194 - Homework 3

## Exercise 1

這題 input 是給一個 list。

output 是一個 list of lists。第一個 list 和 input list 一樣 ; 第二個 list 是 input list 2,4,6,8..的元素組成的 ; 第三個 list 是 input list 3,6,9,12..的元素組成的 ; 依此類推。

我的想法是 output list 中每個 list 的要求都很清楚了，所以直接用 list comprehension 的方式寫。

* 第一個 list 和 input list 一樣，所以取的元素 index 相差 1
* 第二個 list 是 input list 2,4,6,8 .. 的元素組成的，index 間相差 2
* 第三個 list 是 input list 3,6,9,12 .. 的元素組成的，index 間相差 3

可以看出會有兩層 list comprehension 的形式，外層是跑 step 從 1 到 n ; 而內層是跑 根據 step，把元素取出來

```Haskell
skips :: [a] -> [[a]]
skips list = let steps = [ i | i <- [1 .. length list]] in 
              let indices = map (\step -> [step-1, 2*step-1 .. length list-1]) steps in
                    [ (indexAt index list) | index <- indices]
          
indexAt:: [Int] -> [a] -> [a]
indexAt indices list = [list!!x | x <- indices]
```

也有看到別人的寫法是在 每隔多少取 的部分用 drop 下去跑遞迴 !!


## Exercise 2

這題要找 local maxima，可以寫出 `(n1:n2:n3:list)` 就差不多出來了
```Haskell
localMaxima (n1:n2:n3:list)
    | n1 < n2 && n2 > n3 = n2 : localMaxima restLst
    | otherwise = localMaxima restLst
    where restLst = (n2:n3:list)
```
一開始我還在想用前後相減，剪完後如果前面是負，後面是正，則代表他是 local maxima ，不過這樣的想法好像有點麻煩
```
 2   9   5   6   1
  -7   4   -1  5
  - ... +   -...+
     9!       6!
```

## Exercise 3

這題要畫出一個0~ 9組成的 list 的 柱狀圖

我的想法是
* 首先，先統計在這個 list 出現的次數，
* 接著取出最大的出現次數，這個數字代表這些圖案會有這麼高(圖形長的是 寬＝10，高 = 最大出現次數)
* 最後就是在指定位置上畫上 ` `(空白) 或 `*`


```
  *        5 \
  *        4  \
  *        3   line
  *        2  /
  *     *  1 /
==========
0123456789  --> num
```
```Haskell
histogram :: [Integer] -> String
histogram lst = let cntLst = count lst in
                    unlines $ [ [ if (cntLst!!num >= line) then '*' else ' ' | num <- [0..9] ] | line <- [maximum cntLst, maximum cntLst-1 .. 1] ] ++ ["==========", "0123456789"]

count :: [Integer] -> [Int]
count lst = [ length $ filter (==n) lst | n <- [0..9] ]
```
但這樣的寫法其實有點難懂，整個句子拖很長，而且寫法很 imperative programming，弄成 functional 反而更難懂

查了其他人的寫法後，一個比較直關的看法是先把圖形做成橫的，再把它轉成題目要的直的

橫的比較直觀的原因是 : 就直接印出有幾個 `*` ，後面接無限個 ` ` (空白)，最後再取 前最大次數個 (分別用 `replicate` 和 `repeat` 以及 `take`)

另外，一些長的、固定的東西或一些值也儘量在 `where` 裡面給他其他名字比較清楚

```
0|
1| * * *
2| 
.
.
---------
 *
 *
 *
012..
```



###### tags: `Haskell`, `CIS194`