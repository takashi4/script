type Amount = Integer
type Coin   = Integer
type Count  = Integer

cc :: Amount -> [Coin] -> Count
cc 0 _  = 1 -- 金額がちょうど０なら、両替は１通り
cc _ [] = 0 -- 両替に使う貨幣が無ければ、両替は０通り
cc a ccs@(c:cs)
  | a<0       = 0 -- 金額が0より少なければ、両替は０通り
  | otherwise = cc (a-c) ccs -- 最初の種類の貨幣額面を引いた金額の両替の場合の数
              + cc a     cs  -- 最初の種類の貨幣以外を使う両替の場合の数

