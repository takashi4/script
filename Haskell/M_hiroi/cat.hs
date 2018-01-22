import System.IO

cat::FilePath->IO()
cat filename = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle
  putStr contents
  hClose handle

-- 行数指定 cat
cat'::Int->FilePath->IO()
cat' n filename = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle
  mapM_ putStrLn $ take n $ lines contents
  hClose handle
  
-- 行数指定 cat で行頭に行番号付き(パティング有り)
cat''::Int->FilePath->IO()
cat'' n filename = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle
  mapM_ (putStrLn._addNum) $ zip [1..] $ take n $ lines contents
  hClose handle

_addNum (x,y) = (_rjust 6 (show x)) ++ " " ++ y
_rjust n str = replicate (n-length str) ' ' ++ str

