find_if :: (a->Bool) -> [a] -> Maybe a
find_if _    []     = Nothing
find_if pred (x:xs)
  | pred x    = Just x
  | otherwise = find_if pred xs
