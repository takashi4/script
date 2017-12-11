length' :: [a] -> Integer
length' x = if null x then 0 else 1+(length' $ tail x)

length'' :: [a] -> Integer
length'' []     = 0
length'' (_:xs) = 1 + length'' xs

length''' :: [a] -> Integer
length''' xs =
  case xs of
    []     -> 0
    (y:ys) -> 1 + length''' ys
    
length_fold :: [a] -> Integer
length_fold xs = fold_left' count 0 xs

count :: Integer -> a -> Integer
count a _ = a + 1

fold_left' :: (a -> b -> a) -> a -> [b] -> a
fold_left' _ a []        = a
fold_left' func a (x:xs) = fold_left' func (func a x) xs

