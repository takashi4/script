primes :: [Integer]
primes = 2:3:5:7:[x| x <- [11,13..], is_prime x ]
  where is_prime n = all (\x -> n `mod` x /=0) (takeWhile (\x -> x*x <=n) primes)

primes' :: [Integer]
primes' = 2 : sieve [3,5..]
  where sieve (x:xs) = x : sieve (filter (\y -> y `mod` x /= 0) xs)

primes'' :: [Integer]
primes'' = 2: sieve [3,5..]
  where sieve (x:xs) = x : sieve [y| y<-xs, (mod y x) /=0]
