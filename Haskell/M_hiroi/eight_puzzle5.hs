-- 反復深化による解法（下限値枝刈り法）
import Data.List
import Data.Maybe
import Data.Monoid
import Data.Time

-- 隣接リスト
adjacent :: [[Int]]
adjacent = [
  [1,3],
  [0,2,4],
  [1,5],
  [0,4,6],
  [1,3,5,7],
  [2,4,8],
  [3,7],
  [4,6,8],
  [5,7]]

-- 移動距離 ※追加
distance::[[Int]]
distance=[
  [0,0,0,0,0,0,0,0,0], -- dummy for "0"
  [0,1,2,1,2,3,2,3,4],
  [1,0,1,2,1,2,3,2,3],
  [2,1,0,3,2,1,4,3,2],
  [1,2,3,0,1,2,1,2,3],
  [2,1,2,1,0,1,2,1,2],
  [3,2,1,2,1,0,3,2,1],
  [2,3,4,1,2,3,0,1,2],
  [3,2,3,2,1,2,1,0,1]]

-- アクセス関数 ※追加
getDistance::Int->Int->Int
getDistance piece pos = (distance !! piece) !! pos

-- 移動距離を求める ※追加
calcDistance::[Int]->Int
calcDistance board =
  foldl (\a (piece,pos)-> a+getDistance piece pos)
        0 $ zip board [0..8]

-- 局面定義 ※修正
data State = State {board::[Int], space::Int, piece::Int, lower::Int} deriving Show

-- 下限値の更新 ※追加
update::State->Int->Int->Int
update s x p = let l=lower s
                   z=space s
                   d1=getDistance p x
                   d2=getDistance p z
               in  l-(d1-d2)

-- 駒を動かす
movePiece :: [Int] -> Int -> [Int]
movePiece [] _ = []
movePiece (x:xs) p
  | x==0      = p : movePiece xs p
  | x==p      = 0 : movePiece xs p
  | otherwise = x : movePiece xs p

-- 新しい局面を作る ※修正
makeState :: State -> [State]
makeState s =
  foldr (\x a-> let b=board s
                    p=b !! x
                 in  if piece s==p then a -- 前の状態に戻るので、追加しない
                     else let b'=movePiece b p
                          in  (State b' x p $ update s x p) : a)
  [] (adjacent !! (space s))

-- 反復深化 ※修正
solver::[Int]->[Int]->First [State]
solver start goal = iter low where
  low=calcDistance start
  zero=fromJust $ elemIndex 0 start
  init=[State start zero 0 low]
  dfs n limit xs@(x:_)
    |n+lower x>limit = mempty
    |n==limit        = if board x==goal then First $ Just $ reverse xs
                       else mempty
    |otherwise       = foldl (\a s->mappend a $ dfs (n+1) limit (s:xs))
                       mempty $ makeState x
  iter 32=mempty
  iter n =dfs 0 n init `mappend` iter (n+1)

main::IO()
main=do
  a<-getCurrentTime
  print $ solver [8,6,7,2,5,4,3,0,1] [1,2,3,4,5,6,7,8,0]
  b<-getCurrentTime
  print $ diffUTCTime b a
