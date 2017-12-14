combination :: (Integer, Integer) -> Integer

combination (n,r) = if n==r || r==0 then 1 else combination (n-1,r)*n `div` (n-r)
