module Stack (
  Stack,
  emptyStack,
  singleton,
  push,
  pop,
  top,
  isEmptyStack
) where

-- スタックの定義
data Stack a = S [a] deriving Show

-- 空のスタック
emptyStack :: Stack a
emptyStack = S []

-- 要素が一つのスタックを作る
singleton :: a -> Stack a
singleton x = S [x]

-- データの追加
push :: Stack a -> a -> Stack a
push (S xs) x = S (x:xs)

-- データの削除
pop :: Stack a -> (a,Stack a)
pop (S []) = error "Empty Stack"
pop (S (x:xs)) = (x,S xs)

-- データの取得
top :: Stack a -> a
top (S []) = error "Empty Stack"
top (S (x:_)) = x

-- スタックは空か
isEmptyStack :: Stack a -> Bool
isEmptyStack (S []) = True
isEmptyStack (S _)  = False


