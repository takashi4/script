import Debug.Trace

-- nobsun
xzip xs ys = zip xs (reverse ys)

-- aoki
xzip2 xs ys = f where
  (f,s) = xzip2' xs ys
  xzip2' []     ys = ([],ys)
  xzip2' (x:xs) ys = ((x,y):list, trace ("ys'" ++ show ys') ys') where
    (list,(y:ys')) = xzip2' xs ys
    
