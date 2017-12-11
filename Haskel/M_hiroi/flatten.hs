flatten :: [[a]] -> [a]
flatten [[]] = []
flatten (x:[]) = x
flatten ([]:xs) = flatten xs
flatten (x:xs) =
  case x of
    (y:ys) -> [y] ++ ys ++ flatten xs

flatten' :: [[a]] -> [a]
flatten' [] = []
flatten' (x:xs) = x ++ flatten' xs

flatten'' :: [[a]] -> [a]
flatten'' xss = [x | xs <-xss, x <- xs]