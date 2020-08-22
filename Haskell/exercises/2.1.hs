import Data.Map.Strict (Map, fromList, (!))
import Control.Monad.Writer.Strict (Any)
import Data.List (nub)

data Prop = TruthValue Bool | PropVar String
  | OpNOT Prop | OpAND Prop Prop | OpOR Prop Prop | OpCON Prop Prop | OpBI Prop Prop deriving (Eq, Show)

type VarAsign = Map String Bool

emptyAsign :: Map Any a
emptyAsign = fromList []

eval :: Prop -> VarAsign -> Bool
eval (TruthValue b) _ = b 
eval (PropVar x) a = a ! x
eval (OpNOT p) a = not (eval p a) 
eval (OpAND p1 p2) a = (eval p1 a) && (eval p2 a)
eval (OpOR p1 p2) a = (eval p1 a) || (eval p2 a)
eval (OpCON p1 p2) a = not ((eval p1 a) && not (eval p2 a))
eval (OpBI p1 p2) a = (eval p1 a) == (eval p2 a)

--tautology :: Prop -> Bool



propVars :: Prop -> [String]
propVars (TruthValue _) = []
propVars (PropVar x) = [x]
propVars (OpNOT p) = propVars p
propVars (OpAND p1 p2) = concat(propVars p1, propVars p2)
propVars (OpOR p1 p2) = concat(propVars p1, propVars p2)
propVars (OpCON p1 p2) = concat(propVars p1, propVars p2)
propVars (OpBI p1 p2) = concat(propVars p1, propVars p2)

assigns :: Prop -> [VarAsign]
assigns p =  (nub [fromList [(x,y)] | x <- (propVars p), y <- [True, False]])

main = putStrLn "hola"