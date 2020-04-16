# CIS194 - Homework 2


## Exercise 1

解析指令  pattern matching !!

```Haskell
parseMessage :: String -> LogMessage
parseMessage str = let strList = words str in
    case strList of
        ("I":ts:m) -> LogMessage Info (read ts) (unwords m)
        ("W":ts:m) -> LogMessage Warning (read ts) (unwords m)
        ("E":level:ts:m) -> LogMessage (Error $ read level) (read ts) (unwords m)
        _ -> Unknown (unwords strList)
```

## Exercise 2

建一棵 binary search tree，依照 timestamp 排序

我一開始的寫法是這樣，但這樣會出現一個問題 : 如果他插入 Unknown 的 LogMessage 時，跑到 Leaf 後就會把整棵樹取代掉。

```Haskell
insert :: LogMessage -> MessageTree -> MessageTree
insert lmsg Leaf =  Node Leaf lmsg Leaf
insert lmsg1@(LogMessage _ ts1 _) (Node left lmsg2@(LogMessage _ ts2 _) right)
    | ts1 > ts2 = Node left lmsg2 (insert lmsg1 right)
    | otherwise = Node (insert lmsg1 left) lmsg2 right
insert _ tree = tree
```

所以要改成

```Haskell
insert :: LogMessage -> MessageTree -> MessageTree
insert lmsg@(LogMessage _ _ _) Leaf =  Node Leaf lmsg Leaf
insert lmsg1@(LogMessage _ ts1 _) (Node left lmsg2@(LogMessage _ ts2 _) right)
    | ts1 > ts2 = Node left lmsg2 (insert lmsg1 right)
    | otherwise = Node (insert lmsg1 left) lmsg2 right
insert _ tree = tree
```
第二行把 `lmsg` 改成了 `lmsg@(LogMessage _ _ _)`，如果是 LogMessage 才要建， `Unknown` 會跑到最下面的 `_` 去。

## Exercise 3

用 fold 把所有東西跑一遍，因為 insert 的參數是先 `LogMessage` 再 `MessageTree`，所以用 `foldr`

```Haskell
build msgs = foldr insert Leaf msgs
```

(硬要用 `foldl` 其實也可以，但就會變得很冗)
```Hasjell
build msgs = foldl (\t m -> insert m t) Leaf msgs
```

## Exercise 4

把建好的 binary tree 換成 指令的 list，順著從左到右 recursively 的走

```Haskell
inOrder :: MessageTree -> [LogMessage]
inOrder Leaf = []
inOrder (Node left msg right) = (inOrder left) ++ [msg] ++ (inOrder right)
```

## Exercise 5

要把 Error 數字大於 50 的錯誤訊息按照 timestamp 放在一個 list 裡。我是先把所有訊息按時間排好後再來挑，所以會用到 Exercise 3, 4的東西。

接收一個 LogMessage，如果是 Error 且值大於 50，則回傳 Error 的字串訊息，其他情況都回傳空陣列。
```Haskell
bigError :: LogMessage -> [String]
bigError (LogMessage (Error lvl) _ m)
    | lvl > 50 = [m]  
    | otherwise = []
bigError _ = []
```

排好後，對每一個 LogMessage 做 bigError 這個函式，並把結果放到 list 裡
```Haskell
whatWentWrong :: [LogMessage] -> [String]
whatWentWrong msgs = foldr (\m ms -> (bigError m) ++ ms) [] sortedMsgs
                        where sortedMsgs = inOrder $ build msgs
```


###### tags: `Haskell`, `CIS194`
