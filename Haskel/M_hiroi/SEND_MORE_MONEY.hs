--  SEND
-- +MORE
-- =====
-- MONEY
-- S E N D M O R Y
-- 0 1 2 3 4 5 6 7
-- S/=0, M/=0
send_more_money =
    [x| x <- perm_n 8 [0..9], x!!0 /= 0, x!!4 /= 0,
            (x!!0)*1000+(x!!1)*100+(x!!2)*10+(x!!3)+
            (x!!4)*1000+(x!!5)*100+(x!!6)*10+(x!!1)==
            (x!!4)*10000+(x!!5)*1000+(x!!2)*100+(x!!1)*10+(x!!7)]

fukumen_solver = foldr string_map [] send_more_money
string_map (s:e:n:d:m:o:r:y:[]) a = result:a
    where send = s*1000 + e*100 + n*10 + d
          more = m*1000 + o*100 + r*10 + e
          money = m*10000 + o*1000 + n*100 + e*10 + y
          result = show send ++ "+" ++ show more ++ "=" ++ show money

perm_n :: Eq a => Int -> [a] -> [[a]]
perm_n 0 _  = [[]]
perm_n _ [] = [[]] -- 不要？
perm_n n xs =
  [x:ys| x<-xs, ys <- perm_n (n-1) (filter (/=x) xs)]

-- 別解
check_hukumen :: [Int] -> [String] -> [String]
check_hukumen (s:e:n:d:o:r:y:[]) a =
  if send + more == money then expr:a else a
  where send  = s * 1000 + e * 100 + n * 10 + d
        more  = 1000 + o * 100 + r * 10 + e
        money = 10000 + o * 1000 + n * 100 + e * 10 + y
        expr  = show send ++ "+" ++ show more ++ "=" ++ show money

hukumen_solver :: [String]
hukumen_solver = 
  foldr check_hukumen [] (perm_n 7 [0,2,3,4,5,6,7,8,9])
