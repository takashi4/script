data Number = INT Integer | REAL Double deriving Show

number_sum :: [Number] -> (Integer, Double)
number_sum [] = (0,0.0)
number_sum (x:xs) =
  case x of
    INT  n -> (a+n,b)
    REAL n -> (a,b+n)
  where
    (a,b) = number_sum xs
      