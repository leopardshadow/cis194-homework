{-# OPTIONS_GHC -Wall #-}

module LogAnalysis where

import Log

-- Exercise 1

-- parse a single message
parseMessage :: String -> LogMessage
parseMessage str = let strList = words str in
    case strList of
        ("I":ts:m) -> LogMessage Info (read ts) (unwords m)
        ("W":ts:m) -> LogMessage Warning (read ts) (unwords m)
        ("E":level:ts:m) -> LogMessage (Error $ read level) (read ts) (unwords m)
        _ -> Unknown (unwords strList)

-- Q: How to reduce the repeted part like (read ts)...

-- -- checkpoint
-- exercise1 = do
--     print $ parseMessage "E 2 562 help help" 
--                 == LogMessage (Error 2) 562 "help help" 
--     print $ parseMessage "I 29 la la la"
--                 == LogMessage Info 29 "la la la"
--     print $ parseMessage "This is not in the right format"
--                 == Unknown "This is not in the right format"

-- parse many messages
parse :: String -> [LogMessage]
parse msgs = map parseMessage (lines msgs)


-- exercise 2
-- build a binary tree that
-- messages are sorted by timestamp
insert :: LogMessage -> MessageTree -> MessageTree
insert lmsg Leaf =  Node Leaf lmsg Leaf
insert lmsg1@(LogMessage _ ts1 _) (Node left lmsg2@(LogMessage _ ts2 _) right)
    | ts1 > ts2 = Node left lmsg2 (insert lmsg1 right)
    | otherwise = Node (insert lmsg1 left) lmsg2 right
insert _ tree = tree



-- exercise 3
-- build a message tree from messages
build :: [LogMessage] -> MessageTree
build msgs = foldr insert Leaf msgs

-- build msgs = foldl insert Leaf msgs -- doesn't work ???

-- eexercise 4
-- MessageTree to list of LogMessage in timestamp order
inOrder :: MessageTree -> [LogMessage]
inOrder Leaf = []
inOrder (Node left msg right) = (inOrder left) ++ [msg] ++ (inOrder right)


-- exercise 5
-- whatWentWrong :: [LogMessage] -> [String]




