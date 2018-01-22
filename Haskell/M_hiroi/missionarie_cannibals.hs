import Queue
import Data.List

-- 条件
-- 3人の宣教師と3人の先住民が川岸にいる。川には2人まで乗れるボートが1艘ある。
-- ボートを漕げるのは宣教師のうちの1人と、先住民のうちの1人だけである。
-- どちらかの岸で先住民の数が宣教師の数より多くなると、先住民は反旗を翻し宣教師に襲い掛かる。

data Boat   = LEFT | RIGHT deriving (Show,Eq)
data Person = M | M1 | M2 | C | C1 | C2 deriving (Show,Eq) -- 問題によって異なる
data State  = State {boat::Boat, left::[Person], right::[Person]} deriving Show

-- 集合の等値判定
isEqSet :: Eq a => [a] -> [a] -> Bool
isEqSet xs ys = null( xs\\ys ) && null( ys\\xs )

-- Stateの等値判定
instance Eq State where
  State b1 l1 r1 == State b2 l2 r2 =
    b1==b2 && isEqSet l1 l2 && isEqSet r1 r2

-- 安全確認 問題によって異なる
-- 禁止：Cs > Ms
safe :: [Person] -> Bool
safe []  = True
safe [x] = True
safe xs  = c <= m || m==0 where
  c = length $ intersect [C,C1,C2] xs
  m = length $ intersect [M,M1,M2] xs

-- 船乗りの条件 問題によって異なる
-- 操縦できる C か M が含まれる必要あり
safe_boat :: [Person] -> Bool
safe_boat xs = safe xs && length xs >= 1 && (M `elem` xs || C `elem` xs)

-- ボートに乗る組合せ生成
combinations :: Int -> [a] -> [[a]]
combinations n xs = comb n xs [] [] where
  comb 0 _ ys zs = reverse ys : zs
  comb _ [] _ zs = zs
  comb n (x:xs) ys zs = comb (n-1) xs (x:ys) (comb n xs ys zs)

selectPerson :: [Person] -> [[Person]]
selectPerson xs = filter safe_boat $ combinations 1 xs ++ combinations 2 xs -- ボート乗組員条件

-- 新しい局面生成
isLeft s = boat s==LEFT

toLeft :: State -> [Person] -> State
toLeft s xs = State LEFT (union (left s) xs) ((right s) \\ xs)

toRight :: State -> [Person] -> State
toRight s xs = State RIGHT ((left s) \\ xs) (union (right s) xs)

-- 両岸での条件
check :: State -> [State] -> Bool
check s xs = safe (left s) && safe (right s) && s `notElem` xs

moveBoat q xs@(s:_) =
  foldl (\a x-> let s1=if isLeft s then toRight s x else toLeft s x
                in if check s1 xs then enqueue a (s1:xs) else a)
  q $ selectPerson $ if isLeft s then left s else right s

-- 幅優先探索
solver :: [State]
solver = iter $ singleton [State LEFT person []] where
  person = [M,M1,M2,C,C1,C2] -- 初期条件は問題によって異なる
  isGoal s = s==State RIGHT [] person
  iter q
    | isEmptyQueue q = []
    | otherwise =
      let (xs@(s:_), q1) = dequeue q
      in if isGoal s then reverse xs
         else iter $ moveBoat q1 xs

