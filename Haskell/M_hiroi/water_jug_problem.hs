import Queue
import Debug.Trace

-- (0,0) -> (8,0) -> (8,5)
--                -> (3,5)
--       -> (0,5) -> (8,5)
--                -> (5,0)
-- 0 を水道から満杯にする
-- 0 を他方から注ぐ
-- 0 でないものを捨てる
-- 0 でないものを他方にそそぐ
-- 禁止事項：
--   0 でないときに水道から満杯にすること
--   満杯でないときに捨てること

solver :: (Int,Int) -> Int -> [(Int,Int)]
solver size goal = iter (singleton [(0,0)]) where
  isGoal ((a,b):_) = a==goal || b==goal
  transfer = [transfer1,transfer2,transfer3,transfer4,transfer5,transfer6]
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
           else iter $ trace ("queue:" ++ show nextQ) nextQ

-- A を空にする
transfer1 :: (Int,Int) -> (Int,Int) -> (Int,Int)
transfer1 _ (a,b) = (0,b)

-- A を満たす
transfer2 :: (Int,Int) -> (Int,Int) -> (Int,Int)
transfer2 (ma,_) (a,b) = (ma,b)

-- A から B へ
transfer3 :: (Int,Int) -> (Int,Int) -> (Int,Int)
transfer3 (ma,mb) (a,b) =
  if a+b > mb then (a-c,b+c) else (0,a+b)
    where c=mb-b

-- B を空にする
transfer4 :: (Int,Int) -> (Int,Int) -> (Int,Int)
transfer4 _ (a,b) = (a,0)

-- B を満たす
transfer5 :: (Int,Int) -> (Int,Int) -> (Int,Int)
transfer5 (_,mb) (a,b) = (a,mb)

-- B から A へ
transfer6 :: (Int,Int) -> (Int,Int) -> (Int,Int)
transfer6 (ma,mb) (a,b) =
  if a+b > ma then (a+c,b-c) else (a+b,0)
    where c=ma-a
