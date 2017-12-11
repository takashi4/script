mapping :: (a -> b) -> [a] -> [b]
mapping _ [] = []
mapping func (x:xs) = func x : mapping func xs

mapping_fold :: (a -> b) -> [a] -> [b]
mapping_fold func xs = fold_right' (\qs -> \p -> func p : qs) [] xs

fold_right' :: (b -> a -> b) -> b -> [a] -> b
fold_right' _ b [] = b
fold_right' func b (x:xs) = func (fold_right' func b xs) x
