# CIS194 - Homework 12


在這個遊戲中分成 **攻擊方** 和 **守備方**，兩方各自有數字代表他們的攻擊/守備單位

攻擊方：一次最多攻擊 3 單位，但一定要至少留 1 單位 \(例. 如果有 3 單位，那他最多攻擊 2 單位\)

守備方：一次最多防禦 2 單位 \(或 1 單位，如果他就只有 1\)


決定一場 battle 的結果：
攻/守雙方根據擁有的 攻/守單位 來骰 對應數量 的骰子。從上面的規則可知攻方骰的骰子數量是 0, 1 或 2 ; 而守方是 0 或 1



攻擊、守備方把各自的點數從大到小 \(descending order\) 排列，如此一來，攻守雙方的點數會形成一組組 pair

如果攻方大，那守方死，其他情況則攻方死




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

## Exercise 2





###### tags: `Haskell`