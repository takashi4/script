calc :: IO ()
calc = do
  putStr "read x? "
  x <- readLn :: IO Integer
  putStr "read y? "
  y <- readLn :: IO Integer
  let
    a = x+y
    b = x-y
    c = x*y
    d = x `div` y
    n1 = show x
    n2 = show y
  putStrLn (n1 ++ "+" ++ n2 ++ "=" ++ show a)
  putStrLn (n1 ++ "-" ++ n2 ++ "=" ++ show b)
  putStrLn (n1 ++ "*" ++ n2 ++ "=" ++ show c)
  putStrLn (n1 ++ " div " ++ n2 ++ "=" ++ show d)
  