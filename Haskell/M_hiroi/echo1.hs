echo :: IO ()
echo = do
  a <- getLine
  if a == "" then return ()
  else do putStrLn a
          echo

main :: IO ()
main = echo
{-
-- �ʉ�
main :: IO ()
main = do
  a <- getLine
  if a == "" then return ()
  else do putStrLn a
          main
-}
