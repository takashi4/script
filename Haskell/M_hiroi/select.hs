select :: Eq a => [a] -> [(a,[a])]
select xs = [(y, filter (\z -> z /= y) xs)| y <- xs]

select' [x] = [(x,[])]
select' (x:xs) = (x, xs) : map (\(y,ys) -> (y, x:ys)) (select' xs)

{-
select [1..3] = (1,[2,3]) : map (....) select [2,3]
select [2,3] = (2, [3]) : map (....) select [3]
select [3] = [(3,[])]
select [2,3] = (2,[3]) : map (....) [(3,[])]
             = (2,[3]) : map (\(y,ys) -> (y, 2:ys)) [(3,[])]
             = (2,[3]) : [(3,2:[])]
             = [(2,[3]) , (3,[2])]
select [1..3] = (1,[2,3]) : map (....) [(2,[3]) , (3,[2])]
              = (1,[2,3]) : map (\(y,ys) -> (y, 1:ys)) [(2,[3]) , (3,[2])]
              = (1,[2,3]) : [(2,1:[3]), (3,1:[2])]
-}

select'' :: [a] -> [(a,[a])]
select'' [x] = [(x,[])]
select'' (x:xs) = (x,xs) : [(y,x:ys)|(y,ys) <- select'' xs] 