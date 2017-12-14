solve_master_mind :: [Int] -> [([Int], Int, Int)]
solve_master_mind xs = filter (\(ys,y,z) -> z == (length ys)) $ master_mind xs

master_mind :: [Int] -> [([Int], Int, Int)]
master_mind collect = map (\xs -> count_cow_bull collect xs) $ perm_n (length collect) [0..9]

count_cow_bull :: [Int] -> [Int] -> ([Int], Int, Int)
count_cow_bull xs ys
  | xs == ys  = let l=length ys in (ys, l,l)
  | otherwise = (ys, _cow xs ys, _bull xs ys)

_cow :: [Int] -> [Int] -> Int
_cow xs ys = __cow xs ys 0
  where
    __cow [] _ n = n
    __cow (x:xs) ys n = if elem x ys then __cow xs ys (n+1) else __cow xs ys n

_bull :: [Int] -> [Int] -> Int
_bull xs ys = __bull xs ys 0
  where
    __bull [] _ n = n
    __bull (x:xs) (y:ys) n = if x==y then __bull xs ys (n+1) else __bull xs ys n
    

perm_n :: Int -> [Int] -> [[Int]]
perm_n 0 _  = [[]]
perm_n n xs = [x:ys| x <- xs, ys <- perm_n (n-1) $ filter (/=x) xs]


-- 別解
count_bulls :: [Int] -> [Int] -> Int
count_bulls xs ys =
  foldl (\a (x,y) -> if x==y then a+1 else a) 0 (zip xs ys)

count_cows :: [Int] -> [Int] -> Int
count_cows xs ys =
  foldl (\a x -> if elem x ys then a+1 else a) 0 xs

check_code :: [Int] -> [Int] -> (Int,Int)
check_code code1 code2 = (bulls, cows)
  where bulls = count_bulls code1 code2
        cows = count_cows code1 code2 - bulls
        
check_query :: [Int] -> ([Int], Int, Int) -> Bool
check_query code (old_code, old_bulls, old_cows) =
  bulls == old_bulls && cows == old_cows
    where
      (bulls,cows) = check_code code old_code

select_code :: [Int] -> [([Int],Int,Int)] -> [Int] -> [([Int],Int,Int)]
select_code collect queries code =
  if all (check_query code) queries
  then (code, bulls, cows) : queries
  else queries
    where (bulls,cows) = check_code collect code

mastermind :: [Int] -> [([Int],Int,Int)]
mastermind collect =
  reverse $ foldl (select_code collect) [] (perm_n 4 [0..9])
