sort :: Ord a => [a] -> [a]
sort [] = []
sort xs = y : sort ys where
  y = minimum xs
  ys = delete y xs
  
