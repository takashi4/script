# 7   5   2   -> 16
# 29  10  10  -> 92378
# 500 249 125 -> 0
# 123 81  82  -> timeover
# 436 400 212 -> --------
# 497 490 399 -> --------

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
g n b = fst (g' n b emptyTable)

emptyTable :: Table
emptyTable = []

lookupTable :: Key -> Table -> [Value]
lookupTable key [] = []
lookupTable key ((k,v):tbl)
  | key > k   = []
  | key == k  = [v]
  | otherwise = lookupTable key tbl

insertTable :: Key -> Value -> Table -> Table
insertTable k v tbl = case break ((k>) . fst) tbl of
  (xs,ys) -> xs ++ (k,v):ys

g' :: Tall -> B_Num -> Table -> (Count,Table)
g' n b tbl 
  | n < 2     = (0,tbl)
  | n < 2*b   = (0,tbl)
  | n == 2*b  = (1,tbl)
  | b == 0    = (1,tbl)
  | b == 1    = (n-1,tbl)
  | otherwise = case lookupTable (n,b) tbl of
                    (v:_) -> (v,tbl)
                    []    -> let
                                b' = b-1
                                (cnt', tbl') = foldl h (0, tbl) [(2*b')..(n-2)]
                                    where h = \(c, t) n' -> let
                                                                (c',t') = g' n' b' t
                                                            in ((c+c') `mod` diV, t')
                             in (cnt', tbl')