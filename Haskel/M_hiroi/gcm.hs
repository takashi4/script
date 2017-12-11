gcm :: (Integer, Integer) -> Integer

gcm (x,y) = if x `mod` y == 0 then y else gcm(y, x `mod` y)
