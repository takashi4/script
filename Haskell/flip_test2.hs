data A = A
data B = B
data C = C
data D = D

test :: A -> B -> C -> D -> a
test = undefined

test1 :: A -> B -> D -> C -> a
test1 = (flip.).test

test2 :: A -> C -> B -> D -> a
test2 = flip.test

test3 :: A -> C -> D -> B -> a
test3 = (flip.).flip.test

test4 :: A -> D -> B -> C -> a
test4 = (.flip flip).flip (.).test

test5 :: A -> D -> C -> B -> a
test5 = (.flip flip).flip (.).flip.test

test6 :: B -> A -> C -> D -> a
test6 = flip test

test7 :: B -> A -> D -> C -> a
test7 = (flip.).flip test

test8 :: B -> C -> A -> D -> a
test8 = flip.flip test

test9 :: B -> C -> D -> A -> a
test9 = (flip.).flip.flip test

test10 :: B -> D -> A -> C -> a
test10 = (.flip flip).flip (.).flip test

test11 :: B -> D -> C -> A -> a
test11 = (.flip flip).flip (.).flip.flip test

test12 :: C -> A -> B -> D -> a
test12 = (.test).flip flip

test13 :: C -> A -> D -> B -> a
test13 = (flip.).(.test).flip flip

test14 :: C -> B -> A -> D -> a
test14 = (.flip test).flip flip

test15 :: C -> B -> D -> A -> a
test15 = (flip.).(.flip test).flip flip

test16 :: C -> D -> A -> B -> a
test16 = (.flip flip).flip (.).(.test).flip flip

test17 :: C -> D -> B -> A -> a
test17 = (.flip flip).flip (.).(.flip test).flip flip

test18 :: D -> A -> B -> C -> a
test18 = (.test).(.).flip flip

test19 :: D -> A -> C -> B -> a
test19 = (.flip.test).(.).flip flip

test20 :: D -> B -> A -> C -> a
test20 = (.flip test).(.).flip flip

test21 :: D -> B -> C -> A -> a
test21 = (.flip.flip test).(.).flip flip

test22 :: D -> C -> A -> B -> a
test22 = (.(.test).flip flip).(.).flip flip

test23 :: D -> C -> B -> A -> a
test23 = (.(.flip test).flip flip).(.).flip flip

main = putStrLn ""