data Tree a = Nil | Node a (Tree a) (Tree a) deriving Show

singleton :: a -> Tree a
singleton x = Node x Nil Nil

-- データの探索
search :: Ord a => a -> Tree a -> Maybe a
search _ Nil = Nothing
search x (Node y l r)
  | x==y      = Just y
  | x<y       = search x l
  | otherwise = search x r

-- 最大・最小
searchMin :: Tree a -> Maybe a
searchMin Nil = Nothing
searchMin (Node a Nil _) = Just a
searchMin (Node a l _) = searchMin l

searchMax :: Tree a -> Maybe a
searchMax Nil = Nothing
searchMax (Node a _ Nil) = Just a
searchMax (Node a _ r) = searchMax r

-- データの挿入
insert :: Ord a => a -> Tree a -> Tree a
insert x Nil = singleton x
insert x (Node y l r)
  | x==y = Node y l r
  | x<y  = Node y (insert x l) r
  | x>y  = Node y l (insert x r)

-- リストから二分木を作る
fromList' :: Ord a => [a] -> Tree a
fromList' xs = foldr insert Nil xs

fromList :: Ord a => [a] -> Tree a
fromList xs = foldl (flip insert) Nil xs

-- 最小・最大値の削除
deleteMin :: Tree a -> Tree a
deleteMin Nil = Nil
deleteMin (Node _ Nil r) = r
deleteMin (Node x l r) = Node x (deleteMin l) r

deleteMax :: Tree a -> Tree a
deleteMax Nil = Nil
deleteMax (Node _ l Nil) = l
deleteMax (Node x l r) = Node x l (deleteMax r)

-- データの削除
delete :: Ord a => a -> Tree a -> Tree a
delete x Nil = Nil
delete x (Node y l r)
  | x<y  = Node y (delete x l) r
  | x>y  = Node y l (delete x r)
  | x==y = delete' l r where
      delete' Nil r = r
      delete' l Nil = l
      delete' l r = Node x' l (deleteMin r) where
        Just x' = searchMin r

-- リストに変換（通り掛け順）
toList :: Tree a -> [a]
toList Nil = []
toList (Node x l r) = toList l ++ [x] ++ toList r

toList' :: Tree a -> [a]
toList' tree = iter tree [] where
  iter Nil xs    = xs
  iter (Node y l r) xs = iter l (y:iter r xs)

-- 畳み込み
fold_left :: (a->b->a) -> a -> Tree b -> a
fold_left _ a Nil = a
fold_left f a (Node x l r) = fold_left f (f (fold_left f a l) x) r

fold_right :: (a->b->b) -> b -> Tree a -> b
fold_right _ a  Nil = a
fold_right f a (Node x l r) = fold_right f (f x (fold_right f a r)) l


