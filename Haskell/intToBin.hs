import Data.List

intToBin :: Int -> Int
intToBin = (read . concat . map show) . reverse . unfoldr (\x->
  if x==0 then Nothing
  else Just (mod x 2, div x 2))
  
