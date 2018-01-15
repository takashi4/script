class Mfunctor f where
  (<$$>) :: (a->b) -> f a -> f b

data Alist k v = Nil | Cell k v (Alist k v) deriving Show
instance Mfunctor (Alist k) where
  f <$$> Nil = Nil
  f <$$> (Cell k v next) = Cell k (f v) (f <$$> next)
instance Mfunctor [] where
  (<$$>) = map
instance Mfunctor Maybe where
  f <$$> Nothing = Nothing
  f <$$> Just x  = Just (f x)
instance Mfunctor IO where
  f <$$> action = do
    x <- action
    return (f x)
instance Mfunctor (Either a) where
  f <$$> Left x = Left x
  f <$$> Right x = Right (f x)

-- 関数のFunctor
instance Mfunctor ((->) r) where
  (<$$>) = (.)
  
