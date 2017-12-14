member' :: Eq a => (a, [a]) -> [a]
member' (x, ys) = 
    let tys = tail ys
    in if null ys then []
       else if x == head ys then ys
       else member' (x, tys)
    
member'' :: Eq a => (a,[a]) -> [a]
member'' (_, [])   = []
member'' (x, xs@(y:ys))
  | x == y    = xs
  | otherwise = member'' (x,ys)

member''' (x, y) =
  case y of
    []                    -> []
    ys@(z:zs) | x==z      -> ys
              | otherwise -> member''' (x, zs)
    
