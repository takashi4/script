pair_stream :: [Integer] -> [Integer] -> [(Integer,Integer)]
pair_stream xs ys = iter 1 xs ys
  where iter n bs cs = zip (take n xs) (reverse (take n ys)) ++ iter (n+1) xs ys

lattice :: [(Integer,Integer)]
lattice = [(i, k-i)| k <- [0..], i <- [0..k] ]
