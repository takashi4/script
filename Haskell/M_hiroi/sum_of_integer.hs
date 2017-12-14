sum_of_integer :: (Integer,Integer) -> Integer
sum_of_integer (n,m)
  | n > m = 0
  | otherwise = n + sum_of_integer(n+1, m)

sum_of_sq_integer :: (Integer, Integer) -> Integer
sum_of_sq_integer (n,m)
  | n>m = 0
  | otherwise = n^2 + sum_of_sq_integer(n+1,m)

sum_of_cu_integer :: (Integer, Integer) -> Integer
sum_of_cu_integer (n,m)
  | n>m = 0
  | otherwise = n^3 + sum_of_cu_integer(n+1,m)
  
sum_of :: (Integer -> Integer, Integer, Integer) -> Integer
sum_of (func, n, m)
  | n>m = 0
  | otherwise = func n + sum_of (func, n+1, m)

square :: Num a => a -> a
square x = x^2

cube :: Num a => a -> a
cube x = x^3

sum_of' :: (Integer -> Integer) -> Integer -> Integer -> Integer
sum_of' func x y
  | x>y       = 0
  | otherwise = func x + sum_of' func (x+1) y

sum_of_integer' = sum_of' id
sum_of_sq_integer' = sum_of' (\z -> z^2)
sum_of_cu_integer' = sum_of' (\z -> z^3)
