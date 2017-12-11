count_if :: (a -> Bool) -> [a] -> Integer
count_if func xs = fold_right' (\z y -> if func y then z+1 else z) 0 xs

fold_right' :: (b -> a -> b) -> b -> [a] -> b
fold_right' _ b [] = b
fold_right' func b (x:xs) = func (fold_right' func b xs) x

count_if' :: (a -> Bool) -> [a] -> Integer
count_if' func xs = fold_left' (\z y -> if func y then z+1 else z) 0 xs

fold_left' :: (a -> b -> a) -> a -> [b] -> a
fold_left' _ a []        = a
fold_left' func a (x:xs) = fold_left' func (func a x) xs
