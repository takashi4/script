import Data.List

-- 数字の連結
concat_number :: [Int] -> [[Int]]
concat_number [] = [[]]
concat_number [x] = [[x]]
concat_number (x:y:zs) =
    map (x:) (concat_number (y:zs)) ++ concat_number ((x*10 + y):zs)
    
-- 式の生成
data Expr = Val Int | Add | Sub deriving (Eq,Show)

make_expr :: [Int] -> [[Expr]]
make_expr [x]    = [[Val x]]
make_expr (x:xs) =
  map (\zs-> (Val x):Add:zs) ys1 ++ map (\zs-> (Val x):Sub:zs) ys1
    where
      ys1 = make_expr xs

-- 式の計算
calc_expr :: [Expr] -> Int
calc_expr ((Val x):xs) = iter xs x
  where
    iter [] a = a
    iter (Add:(Val x):xs) a = iter xs (a+x)
    iter (Sub:(Val x):xs) a = iter xs (a-x)

-- 小町算の解法
komachi :: [Int] -> Int -> [[Expr]]
komachi xs n =
  filter (\exprs -> calc_expr exprs == n) $ concatMap make_expr $ concat_number xs

-- 式を文字列に変換
toStr :: Int -> [Expr] -> String
toStr n []     = "=" ++ show n
toStr n (x:xs) = case x of
  Add   -> "+"
  Sub   -> "-"
  Val x -> show x
 ++ toStr n xs

-- 解答
a = map (komachi [1..9]) [100..999]
b = map length a
c = maximum b

-- １．式の総数が最大になる値をすべて求めてください。
answer1 :: [Int]
answer1 = map (+100) $ elemIndices c b

-- ２．解のない値で最小のものを求めてください。
answer2 :: Int
answer2 = head $ map (+100) $ findIndices (==0) b

-- ３．解のある値で最大のものを求めてください。
answer3 :: Int
answer3 = last $ map (+100) $ findIndices (>0) b
