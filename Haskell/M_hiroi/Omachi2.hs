import Data.List

splitDigit :: Integer -> [Integer]
splitDigit 0 = []
splitDigit n = n `mod` 10 : splitDigit (n `div` 10)

check :: Integer -> Bool
check n = 10 == (length . nub .splitDigit) (n*(n+1)*(n+2))

answer :: Integer -> String
answer n = show n ++ "*" ++ show (n+1) ++ "*" ++ show (n+2) ++ "=" ++ show (n*(n+1)*(n+2))

omachi_solver :: [String]
omachi_solver = map answer $ filter check [s..e]
  where
    s = floor   $ 1023456789**(1/3)
    e = ceiling $ 9876543210**(1/3)
    