import Queue
import TreeMap1 hiding (singleton)
import Data.Maybe
import Data.List hiding (insert)
import Data.Time.Clock

-- TreeMap と Queue を使ったバージョン

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
data State = Null | State {board::[Int], space::Int, piece::Int, prev::State} deriving Show

-- 盤面をキーとするため、数値に変換
makeKey :: [Int] -> Int
makeKey xs = foldl1 (\a x -> a*10+x) xs

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
                          in  State b' x p s : a)
  [] (adjacent !! (space s))

-- 手順をリストに格納
makeAnswer :: State -> [[Int]]
makeAnswer state = iter state [] where
  iter Null xs = xs
  iter s    xs = iter (prev s) (board s:xs)

-- 幅優先探索
solver :: [Int] -> [Int] -> [[Int]]
solver start goal = iter (que,tree) where
  ss   = State start (fromJust (elemIndex 0 start)) 0 Null
  que  = singleton ss
  tree = insert (makeKey start) ss emptyTree
  check (q,t) s =
    let k=makeKey (board s)
    in  case search k t of
          Nothing -> (enqueue q s, insert k s t)
          Just _  -> (q,t)
  iter (q,t)
    | isEmptyQueue q = []
    | otherwise =
      let (s,q1)=dequeue q
      in  if goal==board s then makeAnswer s
          else iter $ foldl check (q1,t) $ makeState s

main :: IO ()
main = do
  a <- getCurrentTime
  print $ solver [8,6,7,2,5,4,3,0,1] [1,2,3,4,5,6,7,8,0]
  b <- getCurrentTime
  print $ diffUTCTime b a

