import Debug.Trace
import Control.Monad

data Tree a = Nil | Node a (Tree a) (Tree a) deriving (Read,Show)

-- Nil => #
-- Node 1 Nil Nil => <1##>
-- Node 2 (Node 1 Nil Nil) (Node 3 Nil Nil) => <2<1##><3##>>

-- 二分木読み込み

readsTree::Read a=>ReadS (Tree a)
readsTree "" = []
readsTree ('#':s) = return (Nil,s)
readsTree ('<':s) = do
  (x,t) <-reads s
  (l,u) <-readsTree t
  (r,'>':v) <-readsTree u
  return (Node x l r ,v)
readsTree (_:s) = readsTree s

-- 実行例
-- ※文脈を与えないと結果が返らないことに注意！
a=readsTree "<2##>" :: [(Tree Int,String)]         -- [(Node 2 Nil Nil,"")]
b=readsTree "<3<1##><4##>>" :: [(Tree Int,String)] -- [(Node 3 (Node 1 Nil Nil) (Node 4 Nil Nil),"")]
c=readsTree "<3<1##><4##>" :: [(Tree Int,String)]  -- [] パースエラーのため結果無

