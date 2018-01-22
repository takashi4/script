-- By considering the terms in the Fibonacci sequence whose values do not exceed four million,
-- find the sum of the even-valued terms.

solver = sum . filter even $ takeWhile (<4000000) fib where
  fib  = 1:2:zipWith (+) fib (tail fib)



