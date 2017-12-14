import Data.ByteString.Char8
import Control.Exception

repeated ::(a -> a) -> Int -> a -> a
repeated f n = \x -> (iterate f x) !! n

printThenAdd :: (Num a, Show a) => IO a -> IO a
printThenAdd v = do { x <- v; print x; return (x+1) }
