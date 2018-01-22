class Functor f => Mapplicative f where
  pure::a->f a
  (<*>)::f (a->b) ->f a->f b

instance Mapplicative Maybe where
  pure x = Just x
  Nothing <*> _ = Nothing
  (Just f) <*> x = f <$> x

instance Mapplicative (Either a) where
  pure x = Right x
  (Left x) <*> _ = Left x
  (Right f) <*> x = f <$> x

instance Mapplicative IO where
  pure x = return x
  action1 <*> action2 = do
    f <- action1
    x <- action2
    return (f x)

instance Mapplicative [] where
  pure x = [x]
  fs <*> xs = concatMap (<$> xs) fs

instance Mapplicative ((->) r) where
  pure x = \_->x
  f <*> g = \x->f x (g x)

newtype ZipList a = ZipList {getZipList::[a]}

instance Mfunctor ZipList where
  f <#> (ZipList xs) = ZipList (map f xs)
instance Mapplicative ZipList where
  pure x = ZipList (repeat x)
  ZipList fs <*> ZipList xs = ZipList (zipWith id fs xs)


