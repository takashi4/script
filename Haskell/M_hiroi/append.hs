append' :: ([a],[a]) -> [a]
append' (x,y) = if null x then y else head x : append' (tail x, y)

append'' :: ([a],[a]) -> [a]
append'' ([],   y) = y
append'' (x:xs, y) = x : append'' (xs, y)

append''' (xs, ys) =
  case xs of
    []     -> ys
    (z:zs) -> z : append''' (zs,ys)
    