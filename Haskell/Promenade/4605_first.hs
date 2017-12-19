data DumbTree = Empty | Fork DumbTree DumbTree
instance Show DumbTree where
  show Empty = "R"  -- "0"
  show (Fork Empty r) = "(" ++ "L" ++ "^" ++ show r ++ ")" -- 追加
  show (Fork l Empty) = "(" ++ show l ++ "^" ++ "R" ++ ")" -- 追加
  show (Fork l r) = "(" ++ show l ++ "^" ++ show r ++ ")"

trees :: Int -> [DumbTree]
trees 1 = [Empty]
trees n = concat [joins ls rs| (ls,rs) <- [lrs xs ys| (xs,ys) <- splits1 n]]

splits1 :: Int -> [(Int,Int)]
splits1 1 = []
splits1 n = (1,n-1) : [(i+1,j) | (i,j) <- splits1 (n-1)]

lrs :: Int -> Int -> ([DumbTree],[DumbTree])
lrs xs ys = (trees xs, trees ys)

joins :: [DumbTree] -> [DumbTree] -> [DumbTree]
joins ls rs = [Fork l r | l <- ls, r <- rs]
