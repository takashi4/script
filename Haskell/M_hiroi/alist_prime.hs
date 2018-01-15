data Alist' k v = Nil' | Cell' {key :: k, value :: v, rest :: Alist' k v} deriving Show

acons' :: a -> b -> Alist' a b -> Alist' a b
acons' k v alis = Cell' {key=k, value=v, rest=alis}

pairlis' :: [a] -> [b] -> Alist' a b
pairlis' (a:as) (b:bs) = Cell' {key=a, value=b, rest=pairlis' as bs}
pairlis' _ _ = Nil'

fromList' :: [(a,b)] -> Alist' a b
fromList' ((a,b):cs) = Cell' {key=a, value=b, rest=fromList' cs}
fromList' _          = Nil'

assoc' :: Eq a => a -> Alist' a b -> Maybe (a,b)
assoc' _ Nil' = Nothing
assoc' a (Cell' {key=k, value=v, rest=alis})
  | k==a      = Just (k,v)
  | otherwise = assoc' a alis

assoc_if' :: (a->Bool) -> Alist' a b -> Maybe (a,b)
assoc_if' _ Nil' = Nothing
assoc_if' pred (Cell' {key=k, value=v, rest=alis})
  | pred k    = Just (k,v)
  | otherwise = assoc_if' pred alis

keys' :: Alist' a b -> [a]
keys' Nil' = []
keys' (Cell' {key=k, rest=alis}) = k:(keys' alis)

values' :: Alist' a b -> [b]
values' Nil' = []
values' (Cell' {value=v, rest=alis}) = v:(values' alis)

toList' :: Alist' a b -> [(a,b)]
toList' Nil' = []
toList' (Cell' {key=k, value=v, rest=alis}) = (k,v):(toList' alis)

