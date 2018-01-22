import Control.Monad

perm::Eq a=>Int->[a]->[[a]]
perm n xs = iter 0 [] where
  iter m ys
    |m==n = return $ reverse ys
    |m/=n = do
       x<-xs
       guard $ x `notElem` ys
       iter (m+1) (x:ys)
       
  
