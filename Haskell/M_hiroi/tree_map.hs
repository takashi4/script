data TreeMap k v = Nil | Node k v (TreeMap k v) (TreeMap k v) deriving Show

-- 要素１の木
singleton :: k -> v -> TreeMap k v
singleton k v = Node k v Nil Nil

-- 要素の挿入
insert :: Ord k => k -> v -> TreeMap k v -> TreeMap k v
insert x y Nil = singleton x y
insert x y (Node k v l r)
  | x==k = Node x y l r
  | x<k  = Node k v (insert x y l) r
  | x>k  = Node k v l (insert x y r)

-- 要素の探索
search :: Ord k => k -> TreeMap k v -> Maybe v
search _ Nil = Nothing
search x (Node k v l r)
  | x==k = Just v
  | x<k  = search x l
  | x>k  = search x r

-- 要素の削除
delete :: Ord k => k -> TreeMap k v -> TreeMap k v
delete x Nil = Nil
delete x (Node k v l r)
  | x<k  = Node k v (delete x l) r
  | x>k  = Node k v l (delete x r)
  | x==k = delete' l r where
      delete' Nil r = r
      delete' l Nil = l
      delete' l r   = Node k' v' l (deleteMin r) where
        Just (k',v') = searchMin r

searchMin :: TreeMap k v -> Maybe (k,v)
searchMin Nil = Nothing
searchMin (Node x y Nil _) = Just (x,y)
searchMin (Node _ _ l   _) = searchMin l

deleteMin :: TreeMap k v -> TreeMap k v
deleteMin Nil = Nil
deleteMin (Node _ _ Nil r) = r
deleteMin (Node x y l   r) = Node x y (deleteMin l) r

-- 要素の変換
fromList :: Ord k => [(k,v)] -> TreeMap k v
fromList [] = Nil
fromList ((x,y):zs) = insert x y $ fromList zs

toList :: Ord k => TreeMap k v -> [(k,v)]
toList Nil            = []
toList (Node x y l r) = toList l ++ [(x,y)] ++ toList r

-- 要素の変換（別解）
fromList' :: Ord k => [(k,v)] -> TreeMap k v
fromList' xs = foldl (\treemap (x,y) -> insert x y treemap) Nil xs

toList' :: Ord k => TreeMap k v -> [(k,v)]
toList' tree = iter tree [] where
  iter Nil xs = xs
  iter (Node k v l r) xs = iter l ((k,v):iter r xs)

-- 畳み込み
fold_left :: (a -> (k,v) -> a) -> a -> TreeMap k v -> a
fold_left _ x Nil = x
fold_left f x (Node y z l r) = fold_left f (f (fold_left f x l) (y,z)) r

fold_right :: ((k,v) -> a -> a) -> a -> TreeMap k v -> a
fold_right _ x Nil = x
fold_right f x (Node y z l r) = fold_right f (f (y,z) (fold_right f x r)) l
