module Tree (
  Tree,
  emptyTree, singleton, insert,
  search, searchMin, searchMax,
  delete, deleteMin, deleteMax,
  toList, fromList,
  fold_left, fold_right, isEmptyTree
) where

import qualified Data.Foldable as F
import Data.Monoid

-- データ型の定義
data Tree a = Nil | Node a (Tree a) (Tree a) deriving Show
instance F.Foldable Tree where
  foldMap f Nil=mempty
  foldMap f (Node x l r)=F.foldMap f l `mappend` f x `mappend` F.foldMap f r

-- 空の木
emptyTree :: Tree a
emptyTree = Nil

-- 要素が一つの木
singleton :: a -> Tree a
singleton x = Node x Nil Nil

-- データの挿入
insert :: Ord a => a -> Tree a -> Tree a
insert x Nil = singleton x
insert x (Node y l r)
  | x == y    = Node x l r
  | x < y     = Node y (insert x l) r
  | otherwise = Node y l (insert x r)

-- データの探索
search :: Ord a => a -> Tree a -> Maybe a
search _ Nil = Nothing
search x (Node y l r)
  | x == y    = Just y
  | x < y     = search x l
  | otherwise = search x r

searchMin :: Tree a -> Maybe a
searchMin Nil = Nothing
searchMin (Node x Nil _) = Just x
searchMin (Node _ l   _) = searchMin l

searchMax :: Tree a -> Maybe a
searchMax Nil = Nothing
searchMax (Node x _ Nil) = Just x
searchMax (Node _ _ r)   = searchMax r

-- データの削除
deleteMin :: Tree a -> Tree a
deleteMin Nil = Nil
deleteMin (Node _ Nil r) = r
deleteMin (Node x l   r) = Node x (deleteMin l) r

deleteMax :: Tree a -> Tree a
deleteMax Nil = Nil
deleteMax (Node _ l Nil) = l
deleteMax (Node x l r)   = Node x l (deleteMax r)

delete :: Ord a => a -> Tree a -> Tree a
delete x Nil = Nil
delete x (Node y l r)
  | x < y     = Node y (delete x l) r
  | x > y     = Node y l (delete x r)
  | otherwise = delete' l r where
      delete' Nil r = r
      delete' l Nil = l
      delete' l r = Node x' l (deleteMin r)
        where Just x' = searchMin r

-- データの変換
fromList :: Ord a => [a] -> Tree a
fromList xs = foldl (flip insert) Nil xs

toList :: Tree a -> [a]
toList tree = iter tree [] where
  iter Nil xs = xs
  iter (Node x l r) xs = iter l (x : iter r xs)

-- 畳み込み
fold_left :: (a -> b -> a) -> a -> Tree b -> a
-- fold_left _ a Nil = a
-- fold_left f a (Node x l r) = fold_left f (f (fold_left f a l) x) r
fold_left = F.foldl

fold_right :: (a -> b -> b) -> b -> Tree a -> b
-- fold_right _ a Nil = a
-- fold_right f a (Node x l r) = fold_right f (f x (fold_right f a r)) l
fold_right = F.foldr

-- 空の木か
isEmptyTree :: Tree a -> Bool
isEmptyTree Nil = True
isEmptyTree _   = False
