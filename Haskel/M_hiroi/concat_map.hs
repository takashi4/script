concatMap' :: (a -> [b]) -> [a] -> [b]
concatMap' _ [] = []
concatMap' func (x:xs) = func x ++ concatMap' func xs
