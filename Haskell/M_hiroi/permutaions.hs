permutations :: [a] -> [[a]]
permutations [x] = [[x]]
permutations xs = [y:zs |(y,ys) <- select xs, zs <- permutations ys]
-- [y:z:a:_as|(y,ys) <- select [1..3], (z,zs) <- select ys, (a, _as) <- select zs]

permutations' :: [a] -> [[a]]
permutations' [] = [[]]
permutations' xs = concatMap (\(y,ys) -> map (y:) (permutations' ys)) $ select xs

permutations'' :: [a] -> [[a]]
permutations'' xs = perm xs [] []
  where perm [] ys zs = reverse ys : zs
        perm xs ys zs = foldr (\(x,xs) a -> perm xs (x:ys) a) zs $ select xs
    

select [x] = [(x,[])]
select (x:xs) = (x, xs) : map (\(y,ys) -> (y, x:ys)) (select xs)

-- selectを使わない方法

permutations''' :: Eq a => [a] -> [[a]]
permutations''' [] = [[]]
permutations''' xs =
  concatMap (\x -> map (x:) (permutations''' (filter (/=x) xs))) xs
  
permutations'''' :: Eq a => [a] -> [[a]]
permutations'''' [] = [[]]
permutations'''' xs =
  [x:ys| x <- xs, ys <- permutations'''' (filter (/=x) xs)]


perm_n :: Eq a => Int -> [a] -> [[a]]
perm_n 0 _  = [[]]
perm_n _ [] = [[]] -- 不要？
perm_n n xs =
  [x:ys| x<-xs, ys <- perm_n (n-1) (filter (/=x) xs)]

perm_n' :: Int -> [a] -> [[a]]
perm_n' 0 _ = [[]]
perm_n' n xs =
  concatMap (\(y,ys) -> map (y:) (perm_n' (n-1) ys)) $ select xs

perm_n'' :: Int -> [a] -> [[a]]
perm_n'' 0 _ = [[]]
perm_n'' n xs =
  [y:zs| (y,ys) <- select xs, zs <- perm_n'' (n-1) ys]

rperm_n :: Int -> [a] -> [[a]]
rperm_n 0 _  = [[]]
rperm_n n xs = [x:xs | x<-xs, ys<-rperm_n (n-1) xs]