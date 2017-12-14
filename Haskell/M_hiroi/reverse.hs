reverse' :: [a] -> [a]
reverse' xs = if  null xs then [] else reverse'(tail xs) ++ [head xs] 

reverse'' :: [a] -> [a]
reverse'' []     = []
reverse'' (x:xs) = reverse'' xs ++ [x]

reverse''' x =
  case x of
    []     -> []
    (y:ys) -> reverse''' ys ++ [y]

reverse''' = foldl (\acc x -> x : acc) []

