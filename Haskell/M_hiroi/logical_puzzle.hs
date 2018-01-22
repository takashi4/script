-- ３人の友達が、あるプログラミング競技会で１位、２位、３位になった。
-- この３人は、名前も、好きなスポーツも、国籍も異なる。
-- Michael はバスケットが好きで、アメリカ人よりも上位であった。
-- イスラエル人の Simon はテニスをする者よりも上位であった。
-- クリケットをするものが１位であった。
-- 誰がオーストラリア人か？
-- Richard はどのようなスポーツをするか？
import Data.List

data Name    = Michael | Simon | Richard deriving (Eq,Show)
data Sports  = Basket | Tennis | Cricket deriving (Eq,Show)
data Country = US | Israel | Australia deriving (Eq,Show)
data Person = Person {name::Name, sports::Sports, country::Country} deriving (Eq,Show)

aussie::Maybe Person
aussie = find (\x->country x==Australia) $ foldr (\x y->(_flatten x) ++ y) []  result

richard::Maybe Person
richard = find (\x->name x==Richard) $ foldr (\x y->_flatten x ++ y) []  result

result::[(Person,Person,Person)]
result = [(p1,p2,p3)|p1<-allComb, p2<-allComb, p3<-allComb, cond1 p1 p2 p3, cond2 p1 p2 p3, cond3 p1 p2 p3, cond4 p1 p2 p3] where
  allComb = [Person name sports country| name<-[Michael,Simon,Richard], sports<-[Basket,Tennis,Cricket], country<-[US,Israel,Australia]]


cond1::Person->Person->Person->Bool
cond1 p1 p2 p3 = _neq p1 p2 && _neq p2 p3 && _neq p3 p1

cond2::Person->Person->Person->Bool
cond2 p1 p2 p3 = name p1==Michael && sports p1==Basket && (country p2==US || country p3==US)
              || name p2==Michael && sports p2==Basket && country p3==US

cond3::Person->Person->Person->Bool
cond3 p1 p2 p3 = name p1==Simon && country p1==Israel && (sports p2==Tennis || sports p3==Tennis)
              || name p2==Simon && country p2==Israel && sports p3==Tennis 

cond4::Person->Person->Person->Bool
cond4 p1 p2 p3 = sports p1==Cricket 

_neq::Person->Person->Bool
_neq p1 p2 = name p1/=name p2
          && sports p1/=sports p2
          && country p1/=country p2

_flatten::(Person,Person,Person)->[Person]
_flatten (x,y,z) = [x,y,z]
