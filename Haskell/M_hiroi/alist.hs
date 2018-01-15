data Alist k v = Nil | Cell k v (Alist k v) deriving Show

-- 連想リストの生成
acons :: a -> b ->  Alist a b -> Alist a b
acons k v alis = Cell k v alis

pairlis :: [a] -> [b] -> Alist a b
pairlis (a:as) (b:bs) = acons a b $ pairlis as bs 
pairlis _ _ = Nil

fromList :: [(a,b)] -> Alist a b
fromList ((a,b):abs) = Cell a b $ fromList abs
fromList _ = Nil

assoc :: Eq a => a -> Alist a b -> Maybe (a,b)
assoc _ Nil = Nothing
assoc k (Cell k' v xs)
  | k==k'    = Just (k,v)
  |otherwise = assoc k xs

assoc_if :: (a->Bool) -> Alist a b -> Maybe (a,b)
assoc_if _    Nil = Nothing
assoc_if pred (Cell k v alis)
  | pred k    = Just (k,v)
  | otherwise = assoc_if pred alis 

keys :: Alist a b -> [a]
keys Nil = []
keys (Cell k _ alis) = k:(keys alis)

values :: Alist a b -> [b]
values Nil = []
values (Cell _ v alis) = v:(values alis)

toList :: Alist a b -> [(a,b)]
toList Nil = []
toList (Cell k v alis) = (k,v):(toList alis)

instance Eq k => Eq (Alist k v) where
  xs == ys = subset xs1 ys1 && subset ys1 xs1
    where xs1 = keys xs
          ys1 = keys ys

subset :: Eq a => [a] -> [a] -> Bool
subset [] _ = True
subset (x:xs) ys
  | null $ member x ys = False
  | otherwise  = subset xs ys

member :: Eq a => a -> [a] -> [a]
member _ [] = []
member x zs@(y:ys)
  | x==y      = zs
  | otherwise = member x ys

