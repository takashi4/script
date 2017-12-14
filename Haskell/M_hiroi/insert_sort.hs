insert_sort :: Ord a => [a] -> [a]
insert_sort [] = []
insert_sort (x:xs) = _insert_elem(x,insert_sort xs )

_insert_elem :: Ord a => (a,[a]) -> [a]
_insert_elem (x, [])   = [x]
_insert_elem (x, zs@(y:ys))
  | x<y       = x:zs
  | otherwise = y : _insert_elem(x, ys)
