-- リストのマージ
merge_list :: Ord a => [a] -> [a] -> [a]
merge_list [] ys = ys
merge_list xs [] = xs
merge_list a@(x:xs) b@(y:ys)
  | x<=y = x : merge_list xs b
  | x>y  = y : merge_list a ys

-- マージソート
merge_sort :: Ord a => [a] -> [a]
merge_sort [] = []
merge_sort lis = iter (length lis) lis where
  iter 1 xs = xs
  iter n xs = merge_list (iter n1 xs1) (iter n2 xs2) where
    n1 = div n 2
    n2 = n - n1
    xs1 = take n1 xs
    xs2 = drop n1 xs

-- 別解（引数が異なる）
merge_sort' :: Ord a => Int -> [a] -> [a]
merge_sort' _ []      = []
merge_sort' 1 (x:_)   = [x]
merge_sort' 2 (x:y:_) = if x>y then [y,x] else [x,y]
merge_sort' n xs      =
  merge_list (merge_sort' m xs) (merge_sort' (n-m) (drop m xs)) where
    m=div n 2

-- 別解２
merge_sort'' :: Ord a => [a] -> [a]
merge_sort'' xs = iter1 (map (:[]) xs) where
  iter1 [x] = x
  iter1 xs  = iter1 (iter2 xs)
  iter2 []       = []
  iter2 [x]      = [x]
  iter2 (x:y:zs) = merge_list x y : iter2 zs 
  
