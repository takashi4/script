-- 7   5   2   -> 16
-- 29  10  10  -> 92378
-- 500 249 125 -> 0
-- 123 81  82  -> timeover
-- 436 400 212 -> --------
-- 497 490 399 -> --------

type Table = [(Key,Value)]
type Key   = (Tall,B_Num)
type Value = Count
type Tall  = Integer
type A_Num = Integer
type B_Num = Integer
type Count = Integer

diV :: Count
diV = 1000003

main :: IO ()
main = do
  args <- map read . words <$> getLine
  print $ f (args!!0) (args!!1) (args!!2)

f :: Tall -> A_Num -> B_Num -> Count
f n a b
  | max_b < min_b = 0
  | otherwise = (mod (sum $ map (g n) [min_b .. max_b]) diV)
  where
    max_b = min b (div n 2)
    min_b
      | n <= a    = 0
      | otherwise = div (n-a+1) 2


g :: Tall -> B_Num -> Count
-- g n b = fst (g' n b emptyTable)
g n b = g' n b

emptyTable :: Table
emptyTable = []

globalTable :: Table
globalTable = []

-- lookupTable :: Key -> Table -> [Value]
lookupTable :: Key -> [Value]
-- lookupTable key [] = []
-- lookupTable key ((k,v):tbl)
lookupTable key = lT key globalTable
  where
    lT k []           = []
    lT k ((k',v):tbl) 
      | k > k'    = []
      | k == k'   = [v]
      | otherwise = lT k tbl

-- insertTable :: Key -> Value -> Table -> Table
insertTable :: Key -> Value -> Table
-- insertTable k v tbl = case break ((k>) . fst) tbl of
insertTable k v = case break ((k>) . fst) globalTable of
  (xs,ys) -> xs ++ (k,v):ys

--g' :: Tall -> B_Num -> Table -> (Count,Table)
g' :: Tall -> B_Num -> Count
--g' n b tbl 
g' n b
  | n < 2     = 0
  | n <2*b    = 0
  | n == 2*b  = 1
  | b == 0    = 1
  | b == 1    = n-1
  | otherwise = case lookupTable (n,b) of
    (v:_) -> v
    []    ->
      let
        b' = b-1
        v' = foldl h 0 [(2*b')..(n-2)]
          where h c n' = let c' = g' n' b'
                         in (c+c') `mod` diV
        globalTable = insertTable (n,b) v'
      in v'    
{-
  | n < 2     = (0,tbl)
  | n < 2*b   = (0,tbl)
  | n == 2*b  = (1,tbl)
  | b == 0    = (1,tbl)
  | b == 1    = (n-1,tbl)
  | otherwise = case lookupTable (n,b) tbl of
    (v:_) -> (v,tbl)
    []    ->
      let
        b' = b-1
        (cnt', tbl') = foldl h (0, tbl) [(2*b')..(n-2)]
          where h (c,t) n' = let (c',t') = g' n' b' t
                             in ((c+c') `mod` diV, t')
        tbl'' = insertTable (n,b) cnt' tbl'
      in (cnt', tbl'')
-}