import Data.Bits

bitIndices::(Ord a,Bits a)=>a->[Int]
bitIndices a=iter a 0 where
  iter a n
    |popCount a==0=[]
    |testBit a 0  =n:iter (shiftR a 1) (n+1)
    |otherwise    =iter (shiftR a 1) (n+1)
  
-- 模範解（負数の考慮が必要）
bitIndices'::(Num a, Ord a, Bits a)=>a->[Int]
bitIndices' n=
  if n>0 then iterP n 0 else iterN n 0
  where
    iterP 0 _ = []
    iterP n i = let xs=iterP (shiftR n 1) (i+1)
                in  if testBit n 0 then i:xs else xs
    iterN (-1) _ = []
    iterN n i = let xs=iterN (shiftR n 1) (i+1)
                in  if testBit n 0 then xs else i:xs
