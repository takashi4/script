combinations :: Ord a => Int -> [a] -> [[a]]
combinations _ [] = []
combinations 0 _  = [[]]
combinations n xs =
  filter (\as -> length as == n) [x:zs| x <- xs, zs <- combinations (n-1) (filter (>x) xs)]

combinations' :: Int -> [a] -> [[a]]
combinations' n xs = comb n (length xs) xs
  where
    comb 0 _ _ = [[]]
    comb r n a@(x:xs)
      | n==r      = [a]
      | otherwise = map (x:) (comb (r-1) (n-1) xs) ++ comb r (n-1) xs

comb' :: Int -> [a] -> [[a]]
comb' 0 _  = [[]]
comb' _ [] = []
comb' n (x:xs) = map (x:) (comb' (n-1) xs) ++ comb' n xs

combinations'' :: Int -> [a] -> [[a]]
combinations'' n xs = comb n xs [] []
  where
    comb 0 _ ys zs = reverse ys : zs
    comb _ [] _ zs = zs
    comb n (x:xs) ys zs = comb (n-1) xs (x:ys) (comb n xs ys zs)