fib' :: Integer -> Integer
fib' 0 = 0
fib' 1 = 1
fib' n = fib' (n-1) + fib' (n-2)

fib'' :: Integer -> Integer
fib'' n
  | n<0       = error "fib'' out of range"
  | n==0       = 0
  | n==1       = 1
  | otherwise = fib''(n-1) + fib''(n-2)

fib''' :: Integer -> Integer
fib''' n =
  case n of
    0 -> 0
    1 -> 1
    _ | n<0       -> error "fib out of range"
      | otherwise -> fib''' (n-1) + fib''' (n-2)
      
fib'''' :: Integer -> Integer
fib'''' n = fiboi n 0 1
  where fiboi 0 acc _ = acc
        fiboi n a b = fiboi (n-1) b (a+b)
        
fibgen :: [Integer]
fibgen = 0 : 1 : zipWith (+) fibgen (tail fibgen)

fibgen' :: Integer -> Integer ->[Integer]
fibgen' n m = n : fibgen' m (n+m)

-- 減少カウンター
fib''''' :: Integer -> Integer
fib''''' n = fib_decr n 0 1
  where
    fib_decr 0 a _ = a
    fib_decr 1 _ b = b
    fib_decr n a b = fib_decr (n-1) b (a+b)

    