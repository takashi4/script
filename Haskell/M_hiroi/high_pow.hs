pow' :: (Integer, Integer) -> Integer

pow' (x,y) =
  if y==0 then 1
  else let p = pow'(x, y `div` 2)
           p2 = p*p
        in if even y then p2 else x*p2
