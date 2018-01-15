-- 既約分数表現

kiyaku :: (Integer,Integer) -> (Integer,Integer)
kiyaku (x,y) = (x `div` g, y `div` g)
  where g=gcd x y

kiyaku_answer :: (Integer,Integer) -> String
kiyaku_answer (x,y) = show (fst k) ++ "/" ++ show (snd k)
  where k=kiyaku (x,y)