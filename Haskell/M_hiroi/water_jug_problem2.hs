import Queue
import Debug.Trace

-- ３容器での解法

solver :: (Int,Int,Int) -> Int -> [(Int,Int,Int)]
solver size goal = iter (singleton [(0,0,0)]) where
  isGoal ((a,b,c):_) = a==goal || b==goal || c==goal
  transfer = [transfer1,transfer2,transfer3,transfer4, transfer5, transfer6,
              transfer7,transfer8,transfer9,transfer10,transfer11,transfer12]
  check move q f =
    if news `elem` move then q
    else enqueue q (news:move)
    where news = f size (head move)
  iter q
    | isEmptyQueue q = []
    | otherwise =
        let (move,q1) = dequeue q
            nextQ=foldl (check move) q1 transfer
        in if isGoal move then reverse move
           else iter nextQ
--           else iter $ trace ("queue:" ++ show nextQ) nextQ

-- A を空にする
transfer1 :: (Int,Int,Int) -> (Int,Int,Int) -> (Int,Int,Int)
transfer1 _ (a,b,c) = (0,b,c)

-- A を満たす
transfer2 :: (Int,Int,Int) -> (Int,Int,Int) -> (Int,Int,Int)
transfer2 (ma,_,_) (a,b,c) = (ma,b,c)

-- A から B へ
transfer3 :: (Int,Int,Int) -> (Int,Int,Int) -> (Int,Int,Int)
transfer3 (ma,mb,_) (a,b,c) =
  if a+b > mb then (a-d,b+d,c) else (0,a+b,c)
    where d=mb-b

-- A から C へ
transfer4 :: (Int,Int,Int) -> (Int,Int,Int) -> (Int,Int,Int)
transfer4 (ma,_,mc) (a,b,c) =
  if a+c > mc then (a-d,b,c+d) else (0,b,a+c)
    where d=mc-c

-- B を空にする
transfer5 :: (Int,Int,Int) -> (Int,Int,Int) -> (Int,Int,Int)
transfer5 _ (a,b,c) = (a,0,c)

-- B を満たす
transfer6 :: (Int,Int,Int) -> (Int,Int,Int) -> (Int,Int,Int)
transfer6 (_,mb,_) (a,b,c) = (a,mb,c)

-- B から A へ
transfer7 :: (Int,Int,Int) -> (Int,Int,Int) -> (Int,Int,Int)
transfer7 (ma,mb,mc) (a,b,c) =
  if a+b > ma then (a+d,b-d,c) else (a+b,0,c)
    where d=ma-a

-- B から C へ
transfer8 :: (Int,Int,Int) -> (Int,Int,Int) -> (Int,Int,Int)
transfer8 (ma,mb,mc) (a,b,c) =
  if b+c > mc then (a,b-d,c+d) else (a,0,b+c)
    where d=mc-c

-- C を空にする
transfer9 :: (Int,Int,Int) -> (Int,Int,Int) -> (Int,Int,Int)
transfer9 _ (a,b,c) = (a,b,0)

-- C を満たす
transfer10 :: (Int,Int,Int) -> (Int,Int,Int) -> (Int,Int,Int)
transfer10 (_,_,mc) (a,b,c) = (a,b,mc)

-- C から A へ
transfer11 :: (Int,Int,Int) -> (Int,Int,Int) -> (Int,Int,Int)
transfer11 (ma,mb,mc) (a,b,c) =
  if a+c > ma then (a+d,b,c-d) else (a+c,b,0)
    where d=ma-a

-- C から B へ
transfer12 :: (Int,Int,Int) -> (Int,Int,Int) -> (Int,Int,Int)
transfer12 (ma,mb,mc) (a,b,c) =
  if b+c > mb then (a,b+d,c-d) else (a,b+c,0)
    where d=mb-b
