fact :: Integer -> Integer
fact n
  | n==0 = 1
  | otherwise = n*fact (n-1)
  
fact' :: Integer -> Integer
fact' n = _fact n 1

_fact :: Integer -> Integer -> Integer
_fact n acc
  | n==0 = acc
  | otherwise = _fact (n-1) (n*acc)
 