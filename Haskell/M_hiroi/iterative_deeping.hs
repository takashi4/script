import Control.Monad

-- 反復深化
-- 深さ優先探索を深さを規定して探索
-- 成功するまで深さを変化させる

-- 隣接リスト
adjacent :: [[Int]]
adjacent = [
  [1,2],
  [0,2,3],
  [0,1,4],
  [1,4,5],
  [2,3,6],
  [3],
  [4]]

-- 次の頂点に進む
nextPath :: [Int] -> [[Int]]
nextPath path@(x:xs) = [y:path | y<-adjacent !! x, y `notElem` xs]

-- 反復深化（最短経路を出力）
ids::Int->Int->IO()
ids start goal=iter 1 where
  dfs n m path@(x:xs)
    |n==m = if x==goal then print (reverse path) else return()
    |n/=m = mapM_ (dfs (n+1) m) $ nextPath path
  iter 7 = return()
  iter m = do
    dfs 0 m [start]
    iter (m+1)

-- 反復深化（リストに格納）
ids'::Int->Int->[[Int]]
ids' start goal = iter 1 where
  dfs n m ys path@(x:xs)
    |n==m = if x==goal then reverse path:ys else ys
    |n/=m = foldl (dfs (n+1) m) ys $ nextPath path
  iter 7 = []
  iter m = dfs 0 m [] [start] ++ iter (m+1)

ids_min::Int->Int->[Int]
ids_min start goal = iter 1 where
  dfs n m path@(x:xs)
    |n==m = if x==goal then reverse path else []
    |n/=m = foldl (\b p->if null b then dfs (n+1) m p else b) [] $ nextPath path
  iter 7 = []
  iter m = let res = dfs 0 m [start]
           in  if null res then iter (m+1) else res

---- 探索の一般化
-- 解をリストに
search::(a->Bool)->(a->b)->(b->[a]->[a])->[a]->[a]
search _ _ _ []=[]
search isGoal nextState combine (x:xs)=
  if isGoal x then x:search isGoal nextState combine xs
  else search isGoal nextState combine$combine (nextState x) xs

-- 解を一つだけ
search'::(a->Bool)->(a->b)->(b->[a]->[a])->[a]->Maybe a
search' _ _ _ []=Nothing
search' isGoal nextState combine (x:xs)=
  if isGoal x then Just x
  else search' isGoal nextState combine$combine (nextState x) xs

-- 上記二つをMonadを使ってまとめる
searchM::MonadPlus m=>(a->Bool)->(a->b)->(b->[a]->[a])->[a]->m a
searchM _ _ _ [] = mzero
searchM isGoal nextState combine (x:xs) =
  if isGoal x then return x `mplus` searchM isGoal nextState combine xs
  else searchM isGoal nextState combine$combine (nextState x) xs

-- 深さ優先探索（Monad版）
dfsM::Int->Int->[[Int]]
dfsM start goal =
  searchM (\x->head x==goal) nextPath (++) [[start]]

dfsM'::Int->Int->Maybe [Int]
dfsM' start goal =
  searchM (\x->head x==goal) nextPath (++) [[start]]

-- 幅優先探索（Monad版）
bfsM::Int->Int->[[Int]]
bfsM start goal =
  searchM (\x->head x==goal) nextPath (flip (++)) [[start]]

bfsM'::Int->Int->Maybe [Int]
bfsM' start goal =
  searchM (\x->head x==goal) nextPath (flip (++)) [[start]]

-- 呼び出し方
-- mapM_ (print.reverse) $ dfsM 0 6
-- mapM_ (print.reverse) $ bfsM 0 6
-- print $ reverse <$> dfsM' 0 6
-- print $ reverse <$> bfsM' 0 6


-- ※search_graph.hs Stack/Queue を使わずを参照
-- 　上記を見ると、深さ優先と幅優先が (++) と (flip (++)) の違いだけなのがわかる


