module Stack (
  Stack,
  emptyStack,
  singleton,
  push,
  pop,
  top,
  isEmptyStack
) where

-- �X�^�b�N�̒�`
data Stack a = S [a] deriving Show

-- ��̃X�^�b�N
emptyStack :: Stack a
emptyStack = S []

-- �v�f����̃X�^�b�N�����
singleton :: a -> Stack a
singleton x = S [x]

-- �f�[�^�̒ǉ�
push :: Stack a -> a -> Stack a
push (S xs) x = S (x:xs)

-- �f�[�^�̍폜
pop :: Stack a -> (a,Stack a)
pop (S []) = error "Empty Stack"
pop (S (x:xs)) = (x,S xs)

-- �f�[�^�̎擾
top :: Stack a -> a
top (S []) = error "Empty Stack"
top (S (x:_)) = x

-- �X�^�b�N�͋�
isEmptyStack :: Stack a -> Bool
isEmptyStack (S []) = True
isEmptyStack (S _)  = False


