-- 8 Queen
--  0 1 2 3 4 5 6 7  <- 列の位置
-- [0,6,4,7,1,3,5,2] <- 行の位置
import Data.List
import Debug.Trace
import Control.Monad

queen :: [Int] -> [[Int]]
queen xs = [x| x <- perm_n (length xs) xs, is_ok x]
    
is_ok :: [Int]  -> Bool
is_ok xs = _is_ok xs 0 (xs!!0)
    where 
      _is_ok ys i j = (i == length ys) || (
                        (_is_ok_lu ys (i-1,j-1)) && (_is_ok_ld ys (i-1,j+1)) &&
                        (_is_ok_ru ys (i+1,j-1)) && (_is_ok_rd ys (i+1,j+1)) &&
                        _is_ok ys (i+1) (ys!!(i+1)))

_is_ok_lu :: [Int] -> (Int, Int) -> Bool
_is_ok_lu xs (i,j)
  | i<0 || j<0 = True
  | otherwise  = (xs!!i) /= j && _is_ok_lu xs (i-1,j-1)

_is_ok_ld xs (i,j)
  | i<0 || j>=length xs = True
  | otherwise = (xs!!i) /= j && _is_ok_ld xs (i-1,j+1)
_is_ok_ru xs (i,j)
  | j<0 || i>=length xs = True
  | otherwise = (xs!!i) /= j && _is_ok_ru xs (i+1,j-1)
_is_ok_rd xs (i,j)
  | i>=length xs || j>=length xs = True
  | otherwise = (xs!!i) /= j && _is_ok_rd xs (i+1,j+1)

-- 0 1 2 3 4 5 6 7 8 9
-- i=3
-- take 3 ys ++ reverse $ take (10-3-1) $ reverse ys 
    
perm_n :: Eq a => Int -> [a] -> [[a]]
perm_n 0 _  = [[]]
perm_n _ [] = [[]] -- 不要？
perm_n n xs =
  [x:ys| x<-xs, ys <- perm_n (n-1) (filter (/=x) xs)]

indexer :: [a] -> [(a,Int)]
indexer xs = _indexer xs 0
  where _indexer [] _ = []
        _indexer (y:ys) n = (y,n) : _indexer ys (n+1)


        
-- 模範解１
queen' :: [Int] -> [[Int]]
queen' xs = filter safe $ perm_n (length xs) xs

safe :: [Int] -> Bool
safe [] = True
safe (x:xs) = if attack 1 x xs then False else safe xs

attack :: Int -> Int -> [Int] -> Bool
attack _ _ []     = False
attack n x (y:ys) =
    if x == y+n || x == y-n
    then True
    else attack (n+1) x ys


    
-- 模範解２（高速版)
queen'' :: [Int] -> [[Int]]
queen'' xs = iter (length xs) [(xs,[])]
  where
    iter 0 xs = map snd (trace ("xs:"++show xs) xs)
    iter n xs = iter (n-1) $ concatMap select_queen xs

select_queen :: ([Int], [Int]) -> [([Int], [Int])]
select_queen (xs,ys) = 
--  foldr (\(z,zs) a -> if attack 1 z ys then a else (zs, z:ys):a) []
--  foldr (\(z,zs) a -> if trace ("z:"++show z++" zs:"++show zs) $ attack 1 z ys then a else (zs, z:ys):a) []
  foldr (\(z,zs) a -> if attack 1 z ys then a else trace ("(zs,z:ys):a="++show ((zs, z:ys):a)) $ (zs, z:ys):a) []
    $ select xs

select :: [a] -> [(a,[a])]
select [x] = [(x,[])]
select (x:xs) = (x,xs) : map (\(y,ys) -> (y,x:ys)) (select xs)

-- Monad 版

queen''' :: [Int] -> [[Int]]
queen''' xs = _queen xs []
  where
    _queen [] ys = return (reverse ys)
    _queen xs ys = do
      x <- xs
      guard (not (attack 1 x ys))
      _queen (filter (/=x) xs) (x:ys)