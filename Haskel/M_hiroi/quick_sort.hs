quick_sort :: Ord a => [a] -> [a]
quick_sort [] = []
quick_sort (x:xs) = quick_sort s ++ (x:quick_sort l)
  where s = _small (x,xs)
        l = _large (x,xs)

_small :: Ord a => (a,[a]) -> [a]
_small (_,[]) = []
_small (x, y:ys)
  | x>y       = y:_small(x,ys)
  | otherwise = _small(x,ys)

_large :: Ord a => (a,[a]) -> [a]
_large (_,[]) = []
_large (x, y:ys)
  | x<=y      = y:_large(x,ys)
  | otherwise = _large(x,ys)

quick_sort' :: Ord a => [a] -> [a]
quick_sort' [] = []
quick_sort' (x:xs) = quick_sort' [y | y<-xs, y<x] ++ (x:quick_sort' [y | y<-xs, y>=x])
