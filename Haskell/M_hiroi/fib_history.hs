import Control.Monad.Writer

-- fibonacci の履歴を取る
-- 配列に格納バージョン
fibo::Int->(Int,[String])
fibo n = fibo' n [] where
  fibo' n xs =
    let ys = xs++["fibo " ++ show n ++ " called"]
    in  if n<2 then (1,ys++["fibo "++show n++" =1"])
        else let (a,zs1)=fibo' (n-1) ys
                 (b,zs2)=fibo' (n-2) zs1
                 c=a+b
             in  (c,zs2++["fibo "++show n++" ="++show c])

-- Writerモナドに格納
fiboM::Int->Writer [String] Int
fiboM n = do
  tell ["fibo "++show n++" called"]
  if n<2 then do
    tell ["fibo "++show n++" =1"]
    return 1
  else do
    a<-fiboM (n-1)
    b<-fiboM (n-2)
    tell ["fibo "++show n++ " ="++show (a+b)]
    return (a+b)

