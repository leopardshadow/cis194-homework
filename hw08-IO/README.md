# CIS194 - Homework 8

## Exercise 1

### Ex. 1-1

```Haskell
glCons :: Employee -> GuestList -> GuestList
```

把 Employee 加進 list 中，並更新當前的 fun 值

```Haskell
glCons :: Employee -> GuestList -> GuestList
glCons emp (GL empList fun) = GL (emp : empList) (fun + empFun emp)
```

### Ex. 1-2

讓 GuestList 成為 Monoid instance：

完成 mempty 和 mappend

```Haskell
instance Semigroup GuestList where
    (<>) (GL empList1 fun1) (GL empList2 fun2) = GL (empList1 ++ empList2) (fun1 + fun2)

instance Monoid GuestList where
    mempty = (GL [] 0)
    mappend (GL empList1 fun1) (GL empList2 fun2) = GL (empList1 ++ empList2) (fun1 + fun2)
```

mempty 就是空的 Employee list，fun 值是 0
mappend 則是兩個 Employee list 串接，fun 值相加

### Ex. 1-3

回傳兩個 GuestList 中比較大的 

一開始我寫
```Haskell
moreFun :: GuestList -> GuestList -> GuestList
moreFun gl1@(GL _ fun1) gl2@(GL _ fun2)
    | fun1 > fun2 = gl1
    | otherwise = gl2
```

但不用這麼麻煩，因為在 Employee.hs 檔案中，GuestList 有 deriving Eq，也有實作 compare，所以可以直接 call `max`。

```Haskell
moreFun :: GuestList -> GuestList -> GuestList
moreFun = max
```


## Exercise 2

Data.Tree 中定義了 subtree 不只一個的資料型態，這裡要幫他弄一個 fold 函數。

```Haskell
treeFold :: (a -> [b] -> b) -> Tree a -> b
treeFold f (Node a sf) = f a [ treeFold f subTree | subTree <- sf]
```

![](https://i.imgur.com/ZFkDB9T.jpg)

圈起來的部分是  `(a -> [b] -> b)` 這個 function


這裡我用 list comprehension 的寫法，但其實 Tree 也是 Functor 的 instance，用 `<$>` 的寫法更簡潔。


## Exercise 3

寫 ```nextLevel :: Employee -> [(GuestList, GuestList)] -> (GuestList, GuestList)```


```Haskell
nextLevel :: Employee -> [(GuestList, GuestList)] -> (GuestList, GuestList)
nextLevel boss gls = (bestGlWithBoss, bestGlWithoutBoss)
    where subGlWBoss = mconcat $ map fst gls
          subGlWOBoss = mconcat $ map snd gls
          bestGlWithBoss = glCons boss (subGlWOBoss)
          bestGlWithoutBoss = subGlWBoss
```

在這一層中，如果 boss 不去的話，就用自己的下屬有去的 ; 如果 boss 要去的話，就把 boss 自己 fun 值加上去，用自己的下屬沒去的


## Exercise 4

用 Exercise 2 中的 treeFold 和 Exercise 3 的 nextLevel 一路算到最上層，這時候回傳的是一個 tuple，tuple 中都是 GuestList，分別代表的是
* 最上層的boss 去 的話最好的結果
* 最上層的boss 不去 的話最好的結果

這兩者取其大就會有最大 fun 值

可以用 `uncurry` 函數來比較 tuple 中的值

```
uncurry :: (a -> b -> c) -> (a, b) -> c
```

組合起來

```Haskell
maxFun :: Tree Employee -> GuestList
maxFun = uncurry moreFun . treeFold nextLevel
```


## Exercise 5

IO
待補



###### tags: `Haskell`, `CIS194`