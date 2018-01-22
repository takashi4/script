class Mmonad m where
  ret  ::a->m a             -- return
  bind ::m a->(a->m b)->m b -- >>=

instance Mmonad Maybe where
  ret x = Just x
  bind Nothing  _ = Nothing
  bind (Just x) f = f x

instance Mmonad (Either a) where
  ret x = Right x
  bind (Left  x) _ = Left x
  bind (Right x) f = f x

instance Mmonad IO where
  ret  = return
  bind action f = do
    x<-action
    f x

instance Mmonad [] where
  ret x = [x]
  bind xs f = concatMap f xs
  
instance Mmonad ((->) r) where
  ret x = \_->x
  bind f g = \x->g (f x) x
  
-- Reader ���i�h �f�[�^�^�̒�`
newtype Reader e a = Reader {runReader::e->a}

-- �C���X�^���X�̐ݒ�
instance Mmonad (Reader e) where
  ret x = Reader $ \_->x
  bind (Reader f) g = Reader $ \e-> runReader (g (f e)) e

ask :: Reader a a
ask = Reader id

local::(e->e) -> Reader e a -> Reader e a
local f c = Reader $ \e->runReader c (f e)

-- State ���i�h �f�[�^�^�̒�`
newtype State s a = State {runState::s->(a,s)}

-- �C���X�^���X�̐ݒ�
instance Mmonad (State s) where
  ret x = State $ \s->(x,s)
  bind (State f) g = State $ \s->let (x,s1) = f s
                                 in  runState (g x) s1

-- ��Ԏ擾�iget�j
get::State s s
get = State $ \s->(s,s)

-- ��ԍX�V�iput�j
put::s->State s ()
put s = State $ \_->((),s)

-- for Stack
type Stack a = [a]

pop::State (Stack Int) Int
pop = bind get $ \(x:xs)->bind (put xs) $ \_->ret x

push::Int->State (Stack Int) ()
push x = bind get $ \xs->put (x:xs)

stackTest::State (Stack Int) ()
stackTest = bind pop $ \a->bind pop $ \b->push (a+b)

-- ���i�f�B�b�N�֐�
sequence'::Mmonad m=>[m a]->m [a]
sequence' []     = ret []
sequence' (x:xs) = bind x $ \y->bind (sequence' xs) $ \ys->ret (y:ys)

mapM'::Mmonad m=>(a->m b)->[a]->m [b]
mapM' _ [] = ret []
mapM' f (x:xs) = bind (f x) $ \y->bind (mapM' f xs) $ \ys->ret (y:ys)

liftM::Mmonad m=>(a->b)->m a->m b
liftM  f x = bind x $ \y->ret (f y) -- <$> �Ɠ���

liftM2::Mmonad m=>(a->b->c)->m a->m b->m c
liftM2 f x y = bind x $ \x'->bind y $ \y'->ret (f x' y')

ap::Mmonad m=>m (a->b)->m a->m b
ap f x = bind f $ \g->bind x $ \y->ret (g y) -- <*> �Ɠ���

join::Mmonad m=>m (m a)->m a
join x = x `bind` id

filterM::Mmonad m=>(a->m Bool)->[a]->m [a]
filterM _ [] = ret []
filterM p (x:xs) = bind (filterM p xs) $ \ys->bind (p x) $ \t->ret (if t then (x:ys) else ys)

foldM::Mmonad m=>(a->b->m a)->a->[b]->m a
foldM _ a [] = ret a
foldM f a (x:xs) = bind (f a x) $ \a'->foldM f a' xs
