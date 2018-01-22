import Queue
import qualified Data.IntMap as IMap
import Data.Maybe
import Data.List hiding (insert)
import Data.Time.Clock

-- 双方向探索

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

-- 方向を表すデータ型
data Dir = F | B deriving (Show,Eq)

-- 局面定義
data State = Null | State {board::[Int], space::Int, piece::Int, dir::Dir, prev::State} deriving Show

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
                          in  State b' x p (dir s) s : a)
  [] (adjacent !! (space s))

-- 手順をリストに格納
makeAnswer :: State -> State -> [[Int]]
makeAnswer s1 s2 = if dir s1 == F then iterF s1 [] ++ iterB (prev s2)
                   else iterF s2 [] ++ iterB (prev s1)
    where
      iterF Null xs = xs
      iterF s    xs = iterF (prev s) (board s : xs)
      iterB Null    = []
      iterB s       = board s : iterB (prev s)

-- 幅優先探索（双方向）
solver :: [Int] -> [Int] -> [[Int]]
solver start goal = iter que IMap.empty where
  gs   = State goal  (fromJust (elemIndex 0 goal))  0 B Null
  ss   = State start (fromJust (elemIndex 0 start)) 0 F Null
  que  = enqueue (singleton ss) gs
  iter q t
    | isEmptyQueue q = []
    | otherwise =
      let (s,q1)=dequeue q
          k=makeKey (board s)
      in  case IMap.lookup k t of
        Nothing -> iter (foldl enqueue q1 (makeState s)) (IMap.insert k s t)
        Just s1 -> if dir s1 /= dir s then makeAnswer s s1
                   else iter q1 t

main :: IO ()
main = do
  a <- getCurrentTime
  print $ solver [8,6,7,2,5,4,3,0,1] [1,2,3,4,5,6,7,8,0]
  b <- getCurrentTime
  print $ diffUTCTime b a

