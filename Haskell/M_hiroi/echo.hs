echo :: IO ()
echo = do
  a <- getLine
  if a=="" then return ()
  else do putStrLn a
          echo
