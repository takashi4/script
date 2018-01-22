import Data.Bits

comb_by_bits::Int->Int->[[Int]]
comb_by_bits n r = iter 0 [] where
  n'=2^n
  iter m acc
    |m==n'     = map bitIndices $ reverse acc
    |popCount m==r = iter (m+1) (m:acc)
    |otherwise     = iter (m+1) acc

bitIndices::Int->[Int]
bitIndices a=iter a 0 where
  iter a n
    |popCount a==0=[]
    |testBit a 0  =n:iter (shiftR a 1) (n+1)
    |otherwise    =iter (shiftR a 1) (n+1)
  
-- ビットで表現する解
combination::Int->Int->[Integer]
combination n m = iter n m 0 [] where
  iter _ 0 a xs=a:xs
  iter 0 _ _ xs=xs
  iter n m a xs=
    iter (n-1) m a $ iter (n-1) (m-1) (setBit a (n-1)) xs

-- 数値を2進数に変換する
toString2::Integer->String
toString2 m = iter m [] where
  iter 0 xs = if null xs then "0" else xs
  iter m xs = iter (m `div` 2) (show (m `mod` 2) ++ xs)
