import Data.List
import Debug.Trace

data Komachi = I Integer | OP Char | Nil deriving Show

eval :: [Komachi] -> Integer
eval = calc . parse . toStr

toStr :: [Komachi] -> String
toStr [] = ""
toStr ((I i):xs) = show i ++ toStr xs
toStr ((OP s):xs) = [s] ++ toStr xs
toStr (Nil:xs) = toStr xs

parse :: String -> [String]
parse [] = []
parse ('+':xs) = "+" : parse xs
parse ('-':xs) = "-" : parse xs
parse xs       = ys : parse zs
  where
    (ys,zs) = break (\x -> x=='+'||x=='-') xs

calc :: [String] -> Integer
calc []  = 0
calc [x] = read x :: Integer
calc ("-":x:xs) = (-1)*(read x :: Integer) + calc xs
calc ("+":x:xs) =      (read x :: Integer) + calc xs
calc (x:xs) = (read x :: Integer) + calc xs

makeKomachi :: [[Komachi]]
makeKomachi = map (\xs ->
                    (concat $ zipWith (\y z -> [I y, z]) [1..8] xs) ++ [I 9]
              ) $ dupPerm 8 [OP '+', OP '-', Nil]

dupPerm :: Integer -> [Komachi] -> [[Komachi]]
dupPerm 0 _ = [[]]
dupPerm n xs = [x:y | x<-xs, y<-dupPerm (n-1) xs]

-- 100～999 の解をもつ小町算について
target = filter (\x-> 100<=x && x<1000) $ map (\x -> eval x) makeKomachi
-- １．式の総数が最大になる値をすべて求めてください。
countDup :: [Integer] -> [(Integer, Integer)]
countDup a = _countDup a []
  where
    _countDup [] ys     = ys
    _countDup (x:xs) ys = _countDup xs zs
      where 
        (y1s, y2s) = break ((x<=).fst) ys
        zs = case y2s of
          ((x',n):y2s')
            | x'==x      -> y1s ++ (x,n+1):y2s'
            | otherwise  -> y1s ++ (x,1):(x',n):y2s'
          _        -> y1s ++ [(x,1)]
          
maxDup :: [(Integer,Integer)] -> [Integer]
maxDup xs = _maxDup xs []
  where
    _maxDup [] ys         = map fst ys
    _maxDup ((x,n):xs) ys = _maxDup xs zs
      where
        zs
          | null ys          = [(x,n)]
          | snd (ys !! 0)<n  = [(x,n)]
          | snd (ys !! 0)==n = (x,n):ys
          | otherwise        = ys

answer1 :: [Integer]
answer1 = (sort . maxDup . countDup) target

-- ２．解のない値で最小のものを求めてください。

findMin :: [Integer] -> [Integer] -> Integer
findMin [] _ = 999
findMin (x:xs) (y:ys)
  | x == y = findMin xs ys
  | otherwise = y

answer2 = findMin ( (sort.nub) target ) [100..999]

-- ３．解のある値で最大のものを求めてください。

answer3 = (head.reverse.sort.nub) target
