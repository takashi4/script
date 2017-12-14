filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' func (x:xs)
  | func x    = x : filter' func xs
  | otherwise =     filter' func xs

filter_fold :: (a -> Bool) -> [a] -> [a]
filter_fold func xs = fold_right' (\qs p -> if (func p) then p:qs else qs) [] xs


fold_right' :: (b -> a -> b) -> b -> [a] -> b
fold_right' _ b [] = b
fold_right' func b (x:xs) = func (fold_right' func b xs) x