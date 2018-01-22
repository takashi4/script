-- logical_puzzle.hs の模範解答
import Control.Monad

-- データ定義
data Nation = US | IL | AU deriving (Eq,Show)
data Sports = Basket | Cricket | Tennis deriving (Eq,Show)
data Name   = Michael | Simon | Richard deriving (Eq,Show)
data Person = Person {name::Name, rank::Int, nation::Nation, sports::Sports} deriving Show

-- データの作成
makePerson::Name->[Person]
makePerson name = do
  r <-[1,2,3]
  n <-[US,IL,AU]
  s <-[Basket,Cricket,Tennis]
  return (Person name r n s)

-- 国籍を探す
findNation::Nation->[Person]->Person
findNation _ [] = error "findNation"
findNation x (y:ys) = if x==nation y then y else findNation x ys

-- スポーツを探す
findSports::Sports->[Person]->Person
findSports _ [] = error "findSports"
findSports x (y:ys) = if x==sports y then y else findSports x ys

-- 名前以外で重複あるか
isDuplicate::Person->Person->Bool
isDuplicate x y = rank x==rank y || nation x==nation y || sports x==sports y

-- 同じ要素があるか
check::Person->Person->Person->Bool
check a b c = isDuplicate a b || isDuplicate b c || isDuplicate c a

-- 解法
solver::[[Person]]
solver = do
  m <-makePerson Michael
  s <-makePerson Simon
  r <-makePerson Richard
  guard $ not $ check m s r
  guard $ sports m==Basket
  guard $ nation m/=US
  guard $ nation s==IL
  let usRank = rank $ findNation US [m,s,r]
      teRank = rank $ findSports Tennis [m,s,r]
      crRank = rank $ findSports Cricket [m,s,r]
  guard $ rank m<usRank
  guard $ rank s<teRank
  guard $ crRank==1
  return [m,s,r]
  
