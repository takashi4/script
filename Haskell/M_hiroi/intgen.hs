import Debug.Trace

intgen :: Integer -> [Integer]
intgen n = n : intgen (n+1)

intgen' :: Integer -> Integer -> [Integer]
intgen' n m
  | n>m = []
  | otherwise = n : trace "oops!" (intgen' (n+1) m)

intgen'' :: Integer -> Integer -> [Integer]
intgen'' n m = iter m []
  where
    iter m a
      | n>m       = a
      | otherwise = trace "oops!" (iter (m-1) (m:a))

intgen''' :: Integer -> Integer -> [Integer]
intgen''' n m = iter n []
  where
    iter x a
      | x>m = a
      | otherwise = trace "ooops!" (iter (x+1) (a ++ [x]))
