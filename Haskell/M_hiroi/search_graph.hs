-- リスト : 隣接リスト
import Stack as S
import Queue as Q
import Control.Monad

adjacent :: [[Int]]
adjacent =
  [[1, 2],     -- A 0
   [0, 2, 3],  -- B 1
   [0, 1, 4],  -- C 2
   [1, 4, 5],  -- D 3
   [2, 3, 6],  -- E 4
   [3],        -- F 5
   [4]]        -- G 6

-- これだと dfs 0 6 の時には解を得られるが、 dfs 6 0 だと無限ループする

dfs :: Int -> Int -> [[Int]]
dfs start end = _dfs [start] end [] []
  where
    _dfs [] _ res _        = res
    _dfs (x:xs) ed res tmp
      | x == ed = (reverse (x:tmp)):res ++ _dfs xs ed res tmp
      | otherwise =
          if x `elem` tmp then _dfs xs ed res tmp
          else _dfs (adjacent!!x) ed res (x:tmp) ++ _dfs xs ed res tmp

{-
 dfs 0 6 = _dfs [0] 6 [] []
         = _dfs [1,2] 6 [] [0]     ++ _dfs [] 6 [] []
         = _dfs [0,2,3] 6 [] [1,0]                              ++ _dfs [2] 6 [] [0]
         = _dfs [2,3] 6 [] [1,0]                                ++ _dfs [0,1,4] 6 [] [2,0]
         = _dfs [0,1,4] 6 [] [2,1,0] ++ _dfs [3] 6 [] [1,0]     ++ _dfs [1,4] 6 [] [2,0]
         = _dfs [4] 6 [] [2,1,0]     ++ _dfs [1,4,5] 6 [] [1,0] ++ _dfs [0,2,3] 6 [1,2,0] ++ _dfs [4] 6 [] [2,0]
         = _dfs [2,3,6] 6 [] [4,2,1,0] ++ _dfs [] [] [2,1,0] ++ _dfs [4,5] 6 [] [1,0] ++ _dfs [3] 6 [1,2,0] ++ _dfs [2,3,6] 6 [] [4,2,0]
         = _dfs [1,4,5] 6 [] [3,4,2,1,0] ++ _dfs [6] 6 [] [4,2,1,0] ....

dfs 6 0 = _dfs [6] 0 [] []
        = _dfs [4] 0 [] [6]
        = _dfs [2,3,6] 0 [] [4,6]
        = _dfs [0,1,4] 0 [] [2,4,6] ++ _dfs [3,6] 0 [] [4,6]
        = _dfs [1,4] 0 [[6,4,2,0]] [2,4,6] ++ _dfs [1,4,5] 0 [] [3,4,6] ++ _dfs [6] 0 [4,6]
        = _dfs [0,2,3] 0 [[6,4,2,0]] [1] 
-}

-- 模範解答
-- 次の頂点へ進む
nextPath :: [Int] -> [[Int]]
-- nextPath path@(x:xs) = [y:path | y <- adjacent!!x, y `notElem` xs] -- path への変更は自分でやった
nextPath path@(x:xs) = [y:path | y <- adjacent!!x, y `notElem` path]

-- 深さ優先探索
dfs' :: Int -> Int -> IO ()
dfs' start goal = iter (S.singleton [start]) where
  iter s
    | isEmptyStack s = return ()
    | otherwise      =
        let (path,s1) = pop s
        in if head path == goal then do
             print (reverse path)
             iter s1
           else
             iter $ foldl push s1 $ nextPath path

-- リストに格納する
dfs'' :: Int -> Int -> [[Int]]
dfs'' start goal = iter (S.singleton [start]) where
  iter s
    | isEmptyStack s = []
    | otherwise      =
        let (path,s1) = pop s
        in if head path == goal then reverse path : iter s1
           else iter $ foldl push s1 $ nextPath path

-- Stack を使わず ++ で
dfs''' :: Int -> Int -> [[Int]]
dfs''' start goal = iter [[start]] where
  iter [] = []
  iter (path:xs)
    | head path == goal = reverse path : iter xs
    | otherwise         = iter (nextPath path ++ xs)

-- 再帰関数で
dfs1 :: Int -> Int -> IO ()
dfs1 start goal = search [start] where
  search path@(x:xs)
    | x==goal   = print (reverse path)
    | otherwise = mapM_ search $ nextPath path

-- 再帰関数（リストに保持）
dfs1' :: Int -> Int -> [[Int]]
dfs1' start goal = search [] [start] where
  search ys path@(x:xs)
    | x==goal   = reverse path : ys
    | otherwise = foldl search ys $ nextPath path

-- 再帰関数（リストモナド）
dfs1'' :: Int -> Int -> [[Int]]
dfs1'' start goal = search [start] where
  search path@(x:xs)
    | x==goal   = return (reverse path)
    | otherwise = do
        y <- (adjacent!!x)
        guard( y `notElem` xs )
        search (y:path)

-- 幅優先探索
bfs start goal = iter (Q.singleton [start]) where
  iter q
    | Q.isEmptyQueue q = return ()
    | otherwise =
        let (path, q1) = Q.dequeue q
        in if head path == goal then do
             print (reverse path)
             iter q1
           else iter $ foldl Q.enqueue q1 $ nextPath path

-- リストに格納版
bfs' :: Int -> Int -> [[Int]]
bfs' start goal = iter (Q.singleton [start]) where
  iter q
    | Q.isEmptyQueue q = []
    | otherwise =
        let (path,q1) = Q.dequeue q
        in if head path == goal then reverse path : iter q1
           else iter $ foldl Q.enqueue q1 $ nextPath path

-- Queueを使わず
bfs'' :: Int -> Int -> [[Int]]
bfs'' start goal = iter [[start]] where
  iter [] = []
  iter (path:q)
    | head path==goal = reverse path : iter q
    | otherwise       = iter (q ++ nextPath path)
