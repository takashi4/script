import Queue
import Data.List

-- 条件
-- ３組の夫婦が川を舟で渡ろうと思った。舟には一度に２人しか乗ることができない。
-- ところが、かれらはきわめて嫉妬深く、妻は自分の夫が対でない他の夫人と
-- 一緒にいることは我慢がならない。夫の方も自分の妻が対でない他の男と
-- 一緒にいることは許さない。どうしたらトラブルなしに川を渡ることができるだろうか。

data Boat   = LEFT | RIGHT deriving (Show,Eq)
data Person = M1 | M2 | M3 | W1 | W2 | W3 deriving (Show,Eq,Ord) -- 問題によって異なる
data State  = State {boat::Boat, left::[Person], right::[Person]} deriving Show

-- 集合の等値判定
isEqSet :: Eq a => [a] -> [a] -> Bool
isEqSet xs ys = null( xs\\ys ) && null( ys\\xs )

-- Stateの等値判定
instance Eq State where
  State b1 l1 r1 == State b2 l2 r2 =
    b1==b2 && isEqSet l1 l2 && isEqSet r1 r2

-- 安全確認 問題によって異なる
-- 禁止：つがいの相手のいない異性が含まれないように
safe :: [Person] -> Bool
safe []  = True
safe [x] = True
safe xs  = m1 && m2 && m3 where
  ys = delCouple xs
  m1 = (M1 `notElem` ys) || (null $ intersect ys [W2,W3])
  m2 = (M2 `notElem` ys) || (null $ intersect ys [W1,W3])
  m3 = (M3 `notElem` ys) || (null $ intersect ys [W1,W2])
-- カップルを除く
delCouple :: [Person] -> [Person]
delCouple xs = ys where
  xs'  = if M1 `elem` xs   && W1 `elem` xs   then xs   \\ [M1,W1] else xs
  xs'' = if M2 `elem` xs'  && W2 `elem` xs'  then xs'  \\ [M2,W2] else xs'
  ys   = if M3 `elem` xs'' && W3 `elem` xs'' then xs'' \\ [M3,W3] else xs''


-- 船乗りの条件 問題によって異なる
-- みんな船を漕げるので安全確認のみ
safe_boat = safe

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
toLeft s xs = State LEFT (sort $ union (left s) xs) (sort $ (right s) \\ xs)

toRight :: State -> [Person] -> State
toRight s xs = State RIGHT (sort $ (left s) \\ xs) (sort $ union (right s) xs)

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
  person = [M1,M2,M3,W1,W2,W3] -- 初期条件は問題によって異なる
  isGoal s = s==State RIGHT [] person
  iter q
    | isEmptyQueue q = []
    | otherwise =
      let (xs@(s:_), q1) = dequeue q
      in if isGoal s then reverse xs
         else iter $ moveBoat q1 xs

