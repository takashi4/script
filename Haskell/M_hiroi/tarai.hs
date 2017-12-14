tarai :: Integer -> Integer -> Integer -> Integer
tarai x y z
  | x<=y      = y
  | otherwise = tarai (tarai (x-1) y z) (tarai (y-1) z x) (tarai (z-1) x y)

tarai' :: Integer -> Integer -> Integer -> Integer
tarai' x y z
  | x<=y      = seq z y
  | otherwise = tarai' (tarai' (x-1) y z) (tarai' (y-1) z x) (tarai' (z-1) x y)

tak :: Integer -> Integer -> Integer -> Integer
tak x y z
  | x<=y      = z
  | otherwise = tak (tak (x-1) y z) (tak (y-1) z x) (tak (z-1) x y)
