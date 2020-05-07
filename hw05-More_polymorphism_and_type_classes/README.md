# CIS194 - Homework 5

hw5 大致沿著 `ExprT` 這個 datatype 展開

```Haskell
data ExprT  = Lit Integer
             | Add ExprT ExprT
             | Mul ExprT ExprT
   deriving (Show, Eq)
```

## Exercise 1

這裡要幫 `ExprT` 寫個算出值 的 function

```haskell
eval :: ExprT -> Integer
eval (Lit n) = n
eval (Add n1 n2) = eval n1 + eval n2
eval (Mul n1 n2) = eval n1 * eval n2
```

## Exercise 2

Parser.hs 中定義了 `parseExp`，他接收 `ExprT` 的 constructor \(Lit, Add 和 Mul\)和一個代表運算的 String 作為參數，回傳 `Maybe ExprT`。他的 type signature 是

`(Integer -> a)
     -> (a -> a -> a) -> (a -> a -> a) -> String -> Maybe a`
     
這裡的 `a` 就是 `ExprT`，可以看到最後回傳的是 `Maybe a`，也就是 `Maybe ExprT`

這裡要把 `Just` 裡面的東西 和 `Nothing` 分別處理，所以我用了 `case ... of ...` 來做，也可以用後面教的 `fmap` 來做 \(Maybe 是 Functor !\)，會更簡潔。

```haskell
evalStr :: String -> Maybe Integer
evalStr str = case (parseExp Lit Add Mul str) of
                (Just expr) -> Just (eval expr)
                Nothing -> Nothing 
```

## Exercise 3

還沒仔細看題目之前我以為是這樣寫，只是把 constructor 換成不同寫法而已，但其實要做的事情沒有這麼簡單。

```haskell
lit :: Integer -> ExprT
lit n = Lit n 

add :: ExprT -> ExprT -> ExprT
add e1 e2 = Add e1 e2

mul :: ExprT -> ExprT -> ExprT
mul e1 e2 = Mul e1 e2
```

在題目裡說到

> Unfortunately, there seems to be some disagreement over exactly how the calculator should go about its calculating business.

> Create a type class called Expr with three methods called lit, add, and mul which parallel the constructors of ExprT. Make an instance of Expr for the ExprT type, in such a way that ` mul (add (lit 2) (lit 3)) (lit 4) :: ExprT == Mul (Add (Lit 2) (Lit 3)) (Lit 4)`


題目提示要好好想想 type，可以先看看 Lit, Add 和 Mul 的 type
```haskell
Lit :: Integer -> ExprT
Add :: ExprT -> ExprT -> ExprT
Mul :: ExprT -> ExprT -> ExprT
```

這裡我們先定義了 `Expr`

```haskell
class Expr a where
    lit :: Integer -> a
    add :: a -> a -> a
    mul :: a -> a -> a
```

`ExprT` 算是 `Expr` 的一個特例 \(Expr Integer\)，讓 `ExprT` 成為 `Expr` 的 instance。想成為 instance，要定義 lit, add 和 mul，而這其實就是上面的 Lit, Add 和 Mul。

```haskell
instance Expr ExprT where
    lit n = Lit n
    add e1 e2 = Add e1 e2
    mul e1 e2 = Mul e1 e2
```


另外，題目在這裡提到

```
*Calc> :t mul (add (lit 2) (lit 3)) (lit 4)
Expr a => a
```

`mul (add (lit 2) (lit 3)) (lit 4)` 這個 expression 可能是任何 type a。GHC 不知道要用哪種 type 去實作。

一個解決的辦法是幫他加上 type signature。另一個方式是

```haskell
reify :: ExprT -> ExprT
reify = id
```

如此一來，


## Exercise 4

這題要為 Integer, Bool, MinMax 和 Mod7 弄 instance。

完成後，給一個 `testExp` 再指定不同的 type，能讓他用不同的方式去做。

```haskell
testExp :: Expr a => Maybe a
testExp = parseExp lit add mul "(3 * -4) + 5"

testInteger  = testExp :: Maybe Integer
testBool     = testExp :: Maybe Bool
testMM       = testExp :: Maybe MinMax
testSat      = testExp :: Maybe Mod7
```

實作起來都差不多，讓某個 type 成為 Expr 的 instance，並為他定義 lit, add 和 mul 函數。

```haskell
instance Expr Integer where
    lit = id
    add = (+)
    mul = (*)


instance Expr Bool where
    lit = (>0)
    add = (||)
    mul = (&&)

---
newtype MinMax  = MinMax Integer deriving (Eq, Show)

instance Expr MinMax where
    lit x = MinMax x
    add (MinMax x) (MinMax y) = MinMax $ min x y
    mul (MinMax x) (MinMax y) = MinMax $ max x y

---
newtype Mod7 = Mod7 Integer deriving (Eq, Show)

instance Expr Mod7 where
    lit x   = Mod7 $ x `mod` 7
    add (Mod7 x) (Mod7 y) = Mod7 $ (x + y) `mod` 7
    mul (Mod7 x) (Mod7 y) = Mod7 $ (x * y) `mod` 7
```






## Exercise 5

這題要模擬一個模擬組合語言的計算機。

指令包括

```haskell
data StackExp = PushI Integer
              | PushB Bool
              | Add
              | Mul
              | And
              | Or
               deriving Show
```


而 `Program` 是一串指令

```haskell
type Program = [StackExp]
```






###### tags: `Haskell`, `CIS194`