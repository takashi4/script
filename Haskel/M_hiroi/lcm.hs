gcm :: (Integer, Integer) -> Integer
gcm (x,y) = if (y==0) then x else gcm(y, (mod x y))

lcm' :: (Integer, Integer) -> Integer
lcm' (x,y) = x*y `div` gcm(x,y)
