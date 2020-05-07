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

從 Exercise 3 開始就變得比較抽象難懂了 ...

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

\(\( 不是逐字翻譯，部份是我的想法 \)\)

> Unfortunately, there seems to be some disagreement over exactly how the calculator should go about its calculating business.

對於這個 Calculator 究竟要怎麼運算有不同的聲音

> The problem the software department (i.e. you) has is that while ExprT is nice, it is also rather inflexible, which makes catering to diverse demographics a bit clumsy. You decide to abstract away the properties of ExprT with a type class.

ExprT 不彈性，沒辦法迎合不同人的需求

> Create a type class called Expr with three methods called lit, add, and mul which parallel the constructors of ExprT. Make an instance of Expr for the ExprT type, in such a way that ` mul (add (lit 2) (lit 3)) (lit 4) :: ExprT == Mul (Add (Lit 2) (Lit 3)) (Lit 4)`

創一個 typeclass `Expr` \(有 lit, add 和 mul 這三個 function\)，讓 `ExprT` 成為 `Expr` 的 instance

也就是說之後我們讓某一個 type 成為 `Expr` 的 instance 後，就可以用 lit, add 和 mul 這三個 function 來操作他。

讓 `ExprT` 成為 `Expr` 的 instance 後，用 lit, add 和 mul 來操作，而不是直接用內部如何實作的 Lit, Add 和 Mul

也因此

```haskell
 mul (add (lit 2) (lit 3)) (lit 4) :: ExprT
   == Mul (Add (Lit 2) (Lit 3)) (Lit 4)
```

對 ExprT 來說，lit, add, mul 就等同於 Lit, Add, Mul


題目提示要好好想想 type，可以先看看 Lit, Add 和 Mul 的 type
```haskell
Lit :: Integer -> ExprT
Add :: ExprT -> ExprT -> ExprT
Mul :: ExprT -> ExprT -> ExprT
```

這裡我們先定義了 `Expr` 這個 typeclass

```haskell
class Expr a where
    lit :: Integer -> a
    add :: a -> a -> a
    mul :: a -> a -> a
```

`ExprT` 算是 `Expr` 的一個特例 \(Expr Integer\)，讓 `ExprT` 成為 `Expr` 的 instance。想成為 instance，要定義 lit, add 和 mul，而這其實就是上面的 Lit, Add 和 Mul。

> You decide to abstract away the properties of ExprT with a type class.

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

`mul (add (lit 2) (lit 3)) (lit 4)` 這個 expression 可能是任何 type，只要他是 Expr 的 instance。GHC 不知道要用哪種實作方式 \(會依 type 而有所不同\)。

一個解決的辦法是幫他加上 type signature。

另一個方式是

```haskell
reify :: ExprT -> ExprT
reify = id
```

如此一來，他的 type 就被限制住了

```haskell
reify $ mul (add (lit 2) (lit 3)) (lit 4)
```

我猜是跟 Haskell 的 Type inference \(型別推論\) 有關，`reify` 是 `ExprT -> ExprT`，後面雖然沒寫明是 Expr 什麼，但根據這個 `reify`，他的 type 會被推論成 `ExprT`。



## Exercise 4

這題要為 Integer, Bool, MinMax 和 Mod7 弄 instance。

完成後，給一個 `testExp` 再指定不同的 type，能讓他用不同的方式去做。

```haskell
testExp :: Expr a => Maybe a
testExp = parseExp lit add mul "(3 * -4) + 5"

testInteger  = testExp :: Maybe Integer  -- Just (-7)
testBool     = testExp :: Maybe Bool  -- Just True
testMM       = testExp :: Maybe MinMax  -- Just (MinMax 3)
testSat      = testExp :: Maybe Mod7  -- Just (Mod7 0)
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

這題要模擬一個模擬組合語言的計算機，他總共有六個指令

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

* PushI 和 PushB 會把值 \(分別是Integer 和 Bool\) push 進 stack 最上面 ; 
* Add, Mul, And 和 Or 會從 stack 中取最上面兩個做運算後，push 結果進 stack

如 運算元 \(operand\) 不夠或操作對應的 datatype 不對，他說處理器會融化成一灘矽 w


先來說我在做這題時遇到的問題

True / False 在字串裡怎麼表示







> Simply create an instance of the Expr type class for Program, so that arithmetic expressions can be interpreted as compiled programs. 



最後我們的結果會是一個 compile function 
`compile :: String -> Maybe Program`






## Exercise 6



###### tags: `Haskell`, `CIS194`