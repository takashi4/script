module Queue (
  Queue,
  emptyQueue,
  singleton,
  enqueue,
  dequeue,
  front,
  isEmptyQueue
) where

-- �L���[�̒�`
data Queue a = Q [a] [a] deriving Show

-- ��̃L���[
emptyQueue :: Queue a
emptyQueue = Q [] []

-- �v�f����̃L���[��Ԃ�
singleton :: a -> Queue a
singleton x = Q [x] []

-- �f�[�^�̒ǉ�
enqueue :: Queue a -> a -> Queue a
enqueue (Q front rear) x = Q front (x:rear)

-- �f�[�^�̎�o��
dequeue :: Queue a -> (a,Queue a)
dequeue (Q [] []) = error "Empty Queue"
dequeue (Q [] rear) = dequeue (Q (reverse rear) [])
dequeue (Q (x:xs) rear) = (x,Q xs rear)

-- �擪�f�[�^�̎Q��
front :: Queue a -> a
front (Q [] []) = error "Empty Queue"
front (Q [] rear) = front (Q (reverse rear) [])
front (Q (x:_) _) = x

-- �L���[�͋�
isEmptyQueue :: Queue a -> Bool
isEmptyQueue (Q [] []) = True
isEmptyQueue (Q _  _ ) = False
