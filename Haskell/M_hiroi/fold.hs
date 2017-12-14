fold_left :: Num a => (a -> a -> a) -> [a] -> a
fold_left _ []        = 1
fold_left func (x:xs) = func (fold_left func xs) x

fold_right :: Num a => (a -> a -> a) -> [a] -> a
fold_right _ [] = 1
fold_right func (x:xs) = func x (fold_right func xs)

fold_left' :: (a -> b -> a) -> a -> [b] -> a
fold_left' _ a []        = a
fold_left' func a (x:xs) = fold_left' func (func a x) xs

fold_right' :: (b -> a -> b) -> b -> [a] -> b
fold_right' _ b [] = b
fold_right' func b (x:xs) = func (fold_right' func b xs) x