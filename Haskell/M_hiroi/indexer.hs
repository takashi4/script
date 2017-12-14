indexer :: [a] -> [(a,Integer)]
indexer xs = _indexer xs 0
  where _indexer [] _ = []
        _indexer (y:ys) n = (y,n) : _indexer ys (n+1)
