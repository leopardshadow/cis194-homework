# CIS194 - Homework 12

[TOC]

## 說明

在這個遊戲中分成 **攻擊方** 和 **守備方**，兩方各自有數字代表他們的攻擊/守備單位

攻擊方：一次最多攻擊 3 單位，但一定要至少留 1 單位 \(例. 如果有 3 單位，那他最多攻擊 2 單位\)

守備方：一次最多防禦 2 單位 \(或 1 單位，如果他就只有 1\)


決定一場 battle 的結果：
攻/守雙方根據擁有的 攻/守單位 來骰 對應數量 的骰子。從上面的規則可知攻方骰的骰子數量是 0, 1 或 2 ; 而守方是 0 或 1


攻擊、守備方把各自的點數從大到小 \(descending order\) 排列，如此一來，攻守雙方的點數會形成一組組的 pair

如果攻方點數較大，則守方損失一單位 ; 其他情況 \(守方點數 大於等於 攻方點數\) 則攻方死一單位。  \(不管怎樣都會有人死，就看是攻還是守\)


下面是說明中提供的例子：

* A \(攻\) 有 3 單位，A 最多用 2 單位來攻擊，A 骰出 3, 5
* B \(守\) 有 5 單位，B 可以用 2 單位來防禦，B 骰出 4, 3

弄成 pair 之後

| A | B | 結果  |
| - | - | ---- |
| 5 | 4 | A > B，B 死一單位     |
| 3 | 3 | A = B，A 死一單位 |

這場 battle 結束後，A 剩 2 單位，B 還有 4 單位

接下來 A 攻擊只能出 1 單位，骰 1 顆骰子 ; 而 B 還有 2 單位，可以骰 2 顆。如此一來 B 的獲勝機率比較高，因為他骰 2 顆骰子中較大點數比只骰 1 顆骰子大的機率大。


下面就是要實作這個遊戲

---


## Exercise 1

安裝 cabal

```
brew install cabal-install
```

用 cabal 安裝套件
```
cabal install MonadRandom --lib
```

我在用 cabal 安裝 MonadRandom 時有出現 Warning，所以加了 `--lib` 來安裝

```
Resolving dependencies...
Up to date
Warning: You asked to install executables, but there are no executables in
target: MonadRandom. Perhaps you want to use --lib to install libraries
instead.
```

## Exercise 2 - 單一 battle

可以拆成以下幾個 function

### 決定攻/守雙方出的單位

這裡題目說可以假設他們都會出自己最大可以出的

```haskell
atkUnit :: Army -> Army
atkUnit n = min 3 (n-1)

defUnit :: Army -> Army
defUnit = min 2
```

### 骰骰子

```haskell
rollDices :: Army -> Rand StdGen [DieValue]
rollDices n = replicateM n die 
```

### 排序骰子點數

```haskell
sortDices :: [DieValue] -> [DieValue]
sortDices = sortBy (flip compare)
```

### 比較骰子點數

```haskell
matchDices :: [DieValue] -> [DieValue] -> [Ordering]
matchDices = zipWith compare
```

### 根據骰子比較結果更新 Battlefield

```haskell
updateBf :: Battlefield -> [Ordering] -> Battlefield
updateBf (Battlefield atk def) xs = (Battlefield atk def)
    where atkDeath = length . filter (==GT) $ xs
          defDeath = length . filter (/=GT) $ xs
          atk' = atk - atkDeath 
          def' = def - defDeath
```

### 最後一步，把上面的 function 串起來

```haskell
battle :: Battlefield -> Rand StdGen Battlefield
battle bf@(Battlefield atk def) = do
    atkDices <- sortDices <$> rollDices (atkUnit atk)
    defDices <- sortDices <$> rollDices (defUnit def)
    return $ updateBf bf (matchDices atkDices defDices)
```

### 試跑 & 秀出結果

為方便顯示，我讓 `Battlefield` deriving Show

evalRandIO :: Rand StdGen a -> IO a 
[Control.Monad.Random](https://hackage.haskell.org/package/MonadRandom-0.1.3/docs/Control-Monad-Random.html)

```
-- 什麼都不做
*Risk> evalRandIO (return (Battlefield 5 5)) >>= print
Battlefield {attackers = 5, defenders = 5}

-- 跑 1 次 battle
*Risk> evalRandIO (battle (Battlefield 5 5)) >>= print
Battlefield {attackers = 3, defenders = 5}

-- 跑 1 次 battle，另一種寫法
*Risk> evalRandIO (return (Battlefield 5 5) >>= battle) >>= print
Battlefield {attackers = 4, defenders = 4}

-- 跑 2 次
*Risk> evalRandIO (return (Battlefield 5 5) >>= battle >>= battle) >>= print
Battlefield {attackers = 2, defenders = 4}
```




## Exercise 3 多場 battle

**一場比賽** 中，可能不會一場 battle 就結束了，而是會經歷 **多場battle**。\(一場比賽中有幾場 battle 跟一開始給的攻守雙方幾單位有關。\) 現在要模擬多個 battle。一場比賽的終止條件是下面兩者其中之一

* \(守方贏\) 攻方少於 2 單位 \(只有 1 單位的話，根據規則無法出人\)
* \(攻方贏\) 守方沒人了

### 先寫出一場比賽的終止條件

```haskell
endGame :: Battlefield -> Bool
endGame (Battlefield atk def) = (atk < 2) || (def == 0)
```

### 跑，直到終止條件發生

如果是在 C++ 我會寫個 while 迴圈

```
while (!endGame(bf)) {
    battle ...
}
```

在 Haskell 我用 recursive 的方式寫

```haskell
invade :: Battlefield -> Rand StdGen Battlefield
invade bf = do
    bf' <- battle bf
    if endGame bf'
    then invade bf'
    else return bf'
```


[Control-Monad-Loops  iterateUntilM](http://hackage.haskell.org/package/monad-loops-0.4.3/docs/src/Control-Monad-Loops.html#iterateUntilM)
中其實定義了類似的事

```haskell
-- | Analogue of @('Prelude.until')@
-- Yields the result of applying f until p holds.
iterateUntilM :: (Monad m) => (a -> Bool) -> (a -> m a) -> a -> m a
iterateUntilM p f v 
    | p v       = return v
    | otherwise = f v >>= iterateUntilM p f
```


用 `iterateUntilM` 來改寫的話
\(要 `import Control.Monad.Loops (iterateUntilM)` \)

```haskell
invade' :: Battlefield -> Rand StdGen Battlefield
invade' bf = iterateUntilM endGame invade bf
```


### 試跑

```
*Risk> evalRandIO (invade (Battlefield 5 5)) >>= print
Battlefield {attackers = 1, defenders = 2}

*Risk> evalRandIO (invade (Battlefield 5 5)) >>= print
Battlefield {attackers = 4, defenders = 0}

*Risk> evalRandIO (invade (Battlefield 5 5)) >>= print
Battlefield {attackers = 1, defenders = 4}

*Risk> evalRandIO (invade (Battlefield 5 5)) >>= print
Battlefield {attackers = 2, defenders = 0}
```


## Exercise 4

### 從結果看是誰贏

攻方贏的話，從最後的結果 \(Battlefield\) 來看就是 守方沒人了

```haskell
atkWin :: Battlefield -> Bool
atkWin (Battlefield atk def) = def == 0
```

### 跑 n 局

用 `replicateM` 跑 1000 次

```haskell
successProb :: Battlefield -> Rand StdGen Double
successProb bf = do
    simulations <- replicateM 1000 (invade bf)
    let wins = length . filter atkWin $ simulations
    return (fromIntegral wins / fromIntegral 1000)
```

### 試跑

```
*Risk> evalRandIO (successProb (Battlefield 5 5)) >>= print
0.485

*Risk> evalRandIO (successProb (Battlefield 5 5)) >>= print
0.457

*Risk> evalRandIO (successProb (Battlefield 5 5)) >>= print
0.444

*Risk> evalRandIO (successProb (Battlefield 5 5)) >>= print
0.442
```



## Exercise 5

不用模擬算機率，暫略

[別人的 github/CIS194-hw12](https://github.com/OctaviPascual/cis194-IntroductionToHaskell/tree/master/homework-12)


###### tags: `Haskell`, `CIS194`