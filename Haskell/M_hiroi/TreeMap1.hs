module TreeMap1 (
  TreeMap,
  insert, emptyTree, singleton,
  search, searchMin, searchMax,
  delete, deleteMin, deleteMax,
  toList, fromList, isEmptyTree,
  fold_left, fold_right
) where

import qualified Tree as T

-- データ型定義
data Item k v = Item k v | Item' k deriving Show
type TreeMap k v = T.Tree (Item k v)

instance Eq k => Eq (Item k v) where
  (Item k1 _)==(Item k2 _) = k1==k2
  (Item k1 _)==(Item' k2)  = k1==k2
  (Item' k1)==(Item k2 _)  = k1==k2
  (Item' k1)==(Item' k2)   = k1==k2

instance Ord k => Ord (Item k v) where
  (Item k1 _) `compare` (Item k2 _) = k1 `compare` k2
  (Item k1 _) `compare` (Item' k2)  = k1 `compare` k2
  (Item' k1)  `compare` (Item k2 _) = k1 `compare` k2
  (Item' k1)  `compare` (Item' k2)  = k1 `compare` k2

-- 値を取り出す
getValue :: Item k v -> v
getValue (Item k v) = v

-- タプルに変換する
toPair :: Item k v -> (k,v)
toPair (Item k v) = (k,v)

-- 空の木
emptyTree :: TreeMap k v
emptyTree = T.emptyTree

-- 要素が一つの木
singleton :: k -> v -> TreeMap k v
singleton k v = T.singleton (Item k v)

-- 探索
search :: Ord k => k -> TreeMap k v -> Maybe v
search x tree = case T.search (Item' x) tree of
  Nothing         -> Nothing
  Just (Item _ v) -> Just v
search' :: Ord k => k -> TreeMap k v -> Maybe v
search' x tree = fmap getValue $ T.search (Item' x) tree

searchMin :: Ord k => TreeMap k v -> Maybe (k,v)
searchMin tree = case T.searchMin tree of
  Nothing -> Nothing
  Just (Item k v) -> Just (k,v)
searchMin' :: Ord k => TreeMap k v -> Maybe (k,v)
searchMin' tree = fmap toPair $ T.searchMin tree

searchMax :: Ord k => TreeMap k v -> Maybe (k,v)
searchMax tree = case T.searchMax tree of
  Nothing -> Nothing
  Just (Item k v) -> Just (k,v)
searchMax' :: Ord k => TreeMap k v -> Maybe (k,v)
searchMax' tree = fmap toPair $ T.searchMax tree

-- 挿入
insert :: Ord k => k -> v -> TreeMap k v -> TreeMap k v
insert k v tree = T.insert (Item k v) tree

-- 削除
deleteMin :: TreeMap k v -> TreeMap k v
deleteMin tree = T.deleteMin tree

deleteMax :: TreeMap k v -> TreeMap k v
deleteMax tree = T.deleteMax tree

delete :: Ord k => k -> TreeMap k v -> TreeMap k v
delete k tree = T.delete (Item' k) tree

-- 変換
fromList :: Ord k => [(k,v)] -> TreeMap k v
fromList xs = foldl (\a (k,v)-> insert k v a) emptyTree xs

toList :: TreeMap k v -> [(k,v)]
toList tree = map toPair $ T.toList tree

-- 畳み込み
fold_left :: (a->(k,v)->a) -> a -> TreeMap k v -> a
fold_left f a tree = T.fold_left (\b x-> f b (toPair x)) a tree

fold_right :: ((k,v)->a->a) -> a -> TreeMap k v -> a
fold_right f a tree = T.fold_right (\x b-> f (toPair x) b) a tree

-- 空の木か
isEmptyTree :: TreeMap k v -> Bool
isEmptyTree tree = T.isEmptyTree tree
