fib' :: Integer -> Integer
fib' 0 = 0
fib' 1 = 1
fib' n = fib' (n-1) + fib' (n-2)

fib'' :: Integer -> Integer
fib'' n
  | n<0       = error "fib'' out of range"
  | n==0       = 0
  | n==1       = 1
  | otherwise = fib''(n-1) + fib''(n-2)

fib''' :: Integer -> Integer
fib''' n =
  case n of
    0 -> 0
    1 -> 1
    _ | n<0       -> error "fib out of range"
      | otherwise -> fib''' (n-1) + fib''' (n-2)
      
fib'''' :: Integer -> Integer
fib'''' n = fiboi n 0 1
  where fiboi 0 acc _ = acc
        fiboi n a b = fiboi (n-1) b (a+b)
        
fibgen :: [Integer]
fibgen = 0 : 1 : zipWith (+) fibgen (tail fibgen)

fibgen' :: Integer -> Integer ->[Integer]
fibgen' n m = n : fibgen' m (n+m)

-- 減少カウンター
fib''''' :: Integer -> Integer
fib''''' n = fib_decr n 0 1
  where
    fib_decr 0 a _ = a
    fib_decr 1 _ b = b
    fib_decr n a b = fib_decr (n-1) b (a+b)

-------------------- Memoize fibonacci of fib'
type Table = [(Key,Value)]
type Key   = Integer
type Value = Integer

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

fib_memo :: Key -> Value
fib_memo n =  fst $ fib_memo' n emptyTable
  where
    fib_memo' 0 tbl   = (0, tbl)
    fib_memo' 1 tbl   = (1, tbl)
    fib_memo' n tbl   = case lookupTable n tbl of
      (v:_) -> (v,tbl)
      []    ->
        let
          (v_1, tbl_1) = fib_memo' (n-1) tbl
          (v_2, tbl_2) = fib_memo' (n-2) tbl_1
          v' = v_2 + v_1
          tbl' = insertTable n v' tbl_2
        in (v', tbl')
