import Queue

-- 数字を動かす
movePiece :: Int -> [Int] -> [Int]
movePiece _ [] = []
movePiece n (x:xs)
  | x==n      = 0:movePiece n xs
  | x==0      = n:movePiece n xs
  | otherwise = x:movePiece n xs

-- 状態を表すデータ型
data State = State {
  board :: [Int],
  space :: Int
} deriving (Eq,Show)

makeState :: State -> [State]
makeState s =
  foldr (\x a-> let b=board s
                    n=x+space s
                    p=b!!n
                in  if n<0 || n>=length b then a
                    else (State (movePiece p b) n): a)
        [] [-2,-1,1,2]

-- 幅優先探索
solver :: State -> State -> [State]
solver start goal = iter (singleton [start]) where
  check xs q s = if s `elem` xs then q else enqueue q (s:xs)
  iter q
    | isEmptyQueue q = []
    | otherwise =
      let (xs,q1) = dequeue q
          s1 = head xs
      in if s1==goal then reverse xs
         else iter $ foldl (check xs) q1 (makeState s1)
    
