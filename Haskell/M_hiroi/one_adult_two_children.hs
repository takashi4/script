import Queue
import Data.List

data Boat   = LEFT | RIGHT deriving (Show,Eq)
data Person = ADULT | CHILD1 | CHILD2 deriving (Show,Eq) -- 問題によって異なる
data State  = State {boat::Boat, left::[Person], right::[Person]} deriving Show

-- 集合の等値判定
isEqSet :: Eq a => [a] -> [a] -> Bool
isEqSet xs ys = null( xs\\ys ) && null( ys\\xs )

-- Stateの等値判定
instance Eq State where
  State b1 l1 r1 == State b2 l2 r2 =
    b1==b2 && isEqSet l1 l2 && isEqSet r1 r2

-- 安全確認 問題によって異なる
-- 大人一人か子供一人か子供二人
safe :: [Person] -> Bool
safe []      = True
safe [x]     = True
safe (x:[y]) = x/=ADULT && y/=ADULT
safe _       = False

-- ボートに乗る組合せ生成
combinations :: Int -> [a] -> [[a]]
combinations n xs = comb n xs [] [] where
  comb 0 _ ys zs = reverse ys : zs
  comb _ [] _ zs = zs
  comb n (x:xs) ys zs = comb (n-1) xs (x:ys) (comb n xs ys zs)

selectPerson :: [Person] -> [[Person]]
selectPerson xs = filter safe $ combinations 1 xs ++ combinations 2 xs -- ボート乗組員条件

-- 新しい局面生成
isLeft s = boat s==LEFT

toLeft :: State -> [Person] -> State
toLeft s xs = State LEFT (union (left s) xs) ((right s) \\ xs)

toRight :: State -> [Person] -> State
toRight s xs = State RIGHT ((left s) \\ xs) (union (right s) xs)

-- 両岸での条件は無い 問題によって異なる
check :: State -> [State] -> Bool
check s xs = s `notElem` xs

moveBoat q xs@(s:_) =
  foldl (\a x-> let s1=if isLeft s then toRight s x else toLeft s x
                in if check s1 xs then enqueue a (s1:xs) else a)
  q $ selectPerson $ if isLeft s then left s else right s

-- 幅優先探索
solver :: [State]
solver = iter $ singleton [State LEFT person []] where
  person = [ADULT,CHILD1,CHILD2] -- 初期条件は問題によって異なる
  isGoal s = s==State RIGHT [] person
  iter q
    | isEmptyQueue q = []
    | otherwise =
      let (xs@(s:_), q1) = dequeue q
      in if isGoal s then reverse xs
         else iter $ moveBoat q1 xs

