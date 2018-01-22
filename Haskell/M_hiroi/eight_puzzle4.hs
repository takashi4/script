-- 反復深化による解法
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

-- 局面定義
data State = State {board::[Int], space::Int, piece::Int} deriving Show

-- 駒を動かす
movePiece :: [Int] -> Int -> [Int]
movePiece [] _ = []
movePiece (x:xs) p
  | x==0      = p : movePiece xs p
  | x==p      = 0 : movePiece xs p
  | otherwise = x : movePiece xs p

-- 新しい局面を作る
makeState :: State -> [State]
makeState s =
  foldr (\x a-> let b=board s
                    p=b !! x
                 in  if piece s==p then a -- 前の状態に戻るので、追加しない
                     else let b'=movePiece b p
                          in  State b' x p : a)
  [] (adjacent !! (space s))

-- 反復深化
solver::[Int]->[Int]->First [State]
solver start goal = iter 1 where
  z=fromJust $ elemIndex 0 start
  dfs n limit xs@(x:_)
    |n==limit = if board x==goal then First $ Just $ reverse xs
                else mempty
    |otherwise = foldl (\a s->mappend a $ dfs (n+1) limit (s:xs))
                       mempty $ makeState x
  iter 32=mempty
  iter n =dfs 0 n [State start z 0] `mappend` iter (n+1)

main::IO()
main=do
  a<-getCurrentTime
  print $ solver [8,6,7,2,5,4,3,0,1] [1,2,3,4,5,6,7,8,0]
  b<-getCurrentTime
  print $ diffUTCTime b a
