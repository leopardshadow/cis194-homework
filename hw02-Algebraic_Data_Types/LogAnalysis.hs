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

exercise1 :: Bool
exercise1 = and
    [
        parseMessage "E 2 562 help help" 
                    == LogMessage (Error 2) 562 "help help" ,
        parseMessage "I 29 la la la"
                    == LogMessage Info 29 "la la la" ,
        parseMessage "This is not in the right format"
                    == Unknown "This is not in the right format"
    ]

-- parse many messages
parse :: String -> [LogMessage]
parse msgs = map parseMessage (lines msgs)


-- exercise 2
-- build a binary tree that
-- messages are sorted by timestamp

 -- data MessageTree = Leaf
 --                  | Node MessageTree LogMessage MessageTree

insert :: LogMessage -> MessageTree -> MessageTree
insert lmsg@(LogMessage _ _ _) Leaf =  Node Leaf lmsg Leaf
insert lmsg1@(LogMessage _ ts1 _) (Node left lmsg2@(LogMessage _ ts2 _) right)
    | ts1 > ts2 = Node left lmsg2 (insert lmsg1 right)
    | otherwise = Node (insert lmsg1 left) lmsg2 right
insert _ tree = tree


-- exercise 3
-- build a message tree from messages
build :: [LogMessage] -> MessageTree
build msgs = foldr insert Leaf msgs
-- build msgs = foldl (\t m -> insert m t) Leaf msgs


exercise3 :: MessageTree
exercise3 = build msgs
                where msgs = [ Unknown "This is not in the right format",
                               LogMessage (Error 2) 50 "help help",
                               LogMessage Info 20 "la la la", 
                               LogMessage Info 30 "OAO",
                               LogMessage Warning 60 "OAO",
                               Unknown "This is not in the right format"
                             ]
                             
-- exercise 4
-- MessageTree to list of LogMessage in timestamp order
inOrder :: MessageTree -> [LogMessage]
inOrder Leaf = []
inOrder (Node left msg right) = (inOrder left) ++ [msg] ++ (inOrder right)


-- exercise 5
-- whatWentWrong :: [LogMessage] -> [String]




