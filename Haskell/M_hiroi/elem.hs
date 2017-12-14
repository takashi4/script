elem' :: Eq a => (a, [a]) -> Bool

elem' (x, ys) =
    if null ys then False
    else if x == head ys then True
    else elem'(x, tail ys)
