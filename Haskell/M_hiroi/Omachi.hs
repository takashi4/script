import Data.List

omachiNumbers :: [Int]
omachiNumbers = sort $ filter (\x ->x>1000000000 && x `mod` 6==0) $ map (\xs-> foldl (\x y->10*x+y) 0 xs) $ permutations [0..9]

answer :: [[Int]]
answer = [[n,n+1,n+2]| n <- filter (\m-> elem (m*(m+1)*(m+2)) omachiNumbers) [s..e]]
  where
    h = (fromIntegral (head omachiNumbers)) :: Double
    l = (fromIntegral (last omachiNumbers)) :: Double
    s = floor   $ exp $ (1/3::Double) *log h
    e = ceiling $ exp $ (1/3::Double) *log l
