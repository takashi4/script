
-- f a b c     = a:b:c:[]

{-
f :: a->b->c->d
f31 :: (a->b->c->d) -> a -> c -> b -> d
f32 :: (a->b->c->d) -> b -> a -> c -> d
f33 :: (a->b->c->d) -> b -> c -> a -> d
f34 :: (a->b->c->d) -> c -> a -> b -> d
f35 :: (a->b->c->d) -> c -> b -> a -> d
-}
f a b c = a:b:c:[]
  

f31 f a c b -- f a b c
            -- = (f a) b c
            -- = flip (f a) c b
            = (flip.f) a c b

f32 f b a c -- f a b c
            -- = (f a b) c
            -- = (flip f b a) c
            = flip f b a c

f33 f b c a -- f a b c
            -- = (f a b) c
            -- = (flip f b a) c
            -- = flip f b a c
            -- = (flip f b) a c
            -- = flip (flip f b) c a
            = (flip.(flip f)) b c a

f34 f c a b -- f a b c
            -- = (f a) b c
            -- = flip (f a) c b
            -- = flip.f a c b
            -- = (flip.f a c) b
            -- = (flip (flip.f) c a) b
            = flip (flip.f) c a b

f35 f c b a -- f a b c
            -- = flip (flip.f) c a b
            -- = (flip (flip.f) c) a b
            -- = flip (flip (flip.f) c) b a
            = (flip.(flip (flip.f))) c b a
            
-- まとめると
-- f31 = flip.f
-- f32 = flip f
-- f33 = flip.(flip f)
-- f34 = flip (flip.f)
-- f35 = flip.(flip (flip.f))
