-- Hoppers（正方形で13穴）
import Data.Bits
import Data.Monoid

-- 飛び先表
jumpTable::[[(Int,Int)]]
jumpTable = [
  [(1, 2), (3, 6), (5, 10)],
  [(3, 5), (6, 11), (4, 7)],
  [(1, 0), (4, 6), (7, 12)],
  [(6, 9)],
  [(6, 8)],
  [(3, 1), (6, 7), (8, 11)],
  [(3, 0), (4, 2), (8, 10), (9, 12)],
  [(4, 1), (6, 5), (9, 11)],
  [(6, 4)],
  [(6, 3)],
  [(5, 0), (8, 6), (11, 12)],
  [(8, 5), (6, 1), (9, 7)],
  [(11, 10), (9, 6), (7, 2)]]

-- ペグの移動
-- from:飛び元 to:飛び先 del:削除ペグ位置
movePeg::Int->Int->Int->Int->Int
movePeg board from del to=
  setBit (clearBit (clearBit board from) del) to

-- 新しい盤面の生成
makeBoard::Int->[(Int,Int,Int)]
makeBoard board=
  foldl (\a x->if testBit board x then (makeBoard' x) ++ a else a)
        [] [0..12]
  where makeBoard' from=
          foldr (\(del,to) a-> if (testBit board del) && (not $ testBit board to)
                                 then (movePeg board from del to, from, to):a
                                 else a)
                [] (jumpTable !! from)

-- 手順の表示
makeAnswer::[(Int,Int)]->[[Int]]
makeAnswer ((a,b):xs) = iter xs [b,a] [] where
  iter [] ys zs = zs ++ [reverse ys]
  iter ((a,b):xs) ys@(y:_) zs
    |y==a = iter xs (b:ys) zs
    |y/=a = iter xs [b,a] (zs ++ [reverse ys])

-- 反復深化による解法（最短手順）
solver::First [[Int]]
solver = iter 2 where
  start=(clearBit 8191 6) -- 8191="1111111111111"
  goal =bit 6
  incJc jc x y=if x==y then jc else jc+1
  dfs board jc limit move@((from',to'):_)
    |jc>limit          = mempty
    |popCount board==1 = if board==goal then First $ Just $ makeAnswer $ reverse move else mempty
    |otherwise         = foldl (\a (board',from,to)->mappend a $ dfs board' (incJc jc from to') limit $ (from,to):move)
                               mempty (makeBoard board)
  iter 12 = mempty
  iter n  =  dfs (movePeg start 0 3 6) 1 n [(0,6)] `mappend` iter (n+1)

-- 反復深化による解法（全手順）
solver'::[[[Int]]]
solver' = iter 2 where
  start = clearBit 8191 6
  goal  = bit 6
  incJc jc x y = if x==y then jc else jc+1
  dfs board jc limit ys move@((from',to'):_)
    |jc>limit          = ys
    |popCount board==1 = if board==goal then (makeAnswer $ reverse move):ys else ys
    |otherwise         = foldr (\(board',from,to) a->dfs board' (incJc jc from to') limit a $ (from,to):move)
                               ys (makeBoard board)
  iter 12 = mempty
  iter n  = let ans=dfs (movePeg start 0 3 6) 1 n [] [(0,6)]
            in  if null ans then iter (n+1) else ans
