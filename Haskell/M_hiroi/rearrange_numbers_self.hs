import Queue

-- [1,2,3,4,0] -> [0,4,3,2,1] : 0 は空き場所
-- 結果は手順のタプル (1,2) => index 1 と index 2 を交換する

solver :: [Int] -> [Int] -> [(Int,Int)]
solver start goal = iter (initQueue start) where
  iter q
    | isEmptyQueue = []
    | otherwise =
      let (move,q1) = dequeue q
      in if move==goal then reverse move else move
          

initQueue :: [Int] -> Queue [Int]
initQueue [] = emptyQueue
initQueue [x] = emptyQueue
initQueue xs = iter' 0 where
  iter' i = 
canRight :: Int -> [Int] -> Bool
canRight index arr =
  let ri = drop index arr
  in case ri of
     [] -> False
     [x] -> False
     x:y:[] -> y==0
     x:y:z:_ -> y==0||z==0

canLeft :: Int -> [Int] -> Bool
canLeft index arr =
  canRight 0 $ reverse $ take (index+1) arr

