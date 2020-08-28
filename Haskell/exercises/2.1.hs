import Data.Map.Strict (Map, fromList, (!))
import Control.Monad.Writer.Strict (Any)
import Data.List (nub)

-- Definimos tipo de dato Prop para los 7 tipos de proposiciones que vamos a utilizar
data Prop =
    TruthValue Bool
  | PropVar String
  | OpNOT Prop
  | OpAND Prop Prop
  | OpOR Prop Prop 
  | OpCON Prop Prop
  | OpBI Prop Prop
  deriving (Eq, Show)

-- Definimos un "alias" para el mapa/diccionario propocicion -> valor
type VarAsign = Map String Bool

-- ??
emptyAsign :: Map Any a
emptyAsign = fromList []

-- Hace la evaluación de las variables proposicionales segun la asignación dada en el mapa VarAsign
eval :: Prop -> VarAsign -> Bool
eval (TruthValue b) _ = b 
eval (PropVar x) a = a ! x
eval (OpNOT p) a = not (eval p a) 
eval (OpAND p1 p2) a = (eval p1 a) && (eval p2 a)
eval (OpOR p1 p2) a = (eval p1 a) || (eval p2 a)
eval (OpCON p1 p2) a = not ((eval p1 a) && not (eval p2 a))
eval (OpBI p1 p2) a = (eval p1 a) == (eval p2 a)

-- Calcula las conbinaciones de las variables de una propocicion
propVars :: Prop -> [String]
propVars (TruthValue _) = []
propVars (PropVar x) = [x]
propVars (OpNOT p) = propVars p
propVars (OpAND p1 p2) = nub ((propVars p1) ++ (propVars p2))
propVars (OpOR p1 p2) = nub ((propVars p1) ++ (propVars p2))
propVars (OpCON p1 p2) = nub ((propVars p1) ++ (propVars p2))
propVars (OpBI p1 p2) = nub ((propVars p1) ++ (propVars p2))

-- Asigna valores a las variables proposicionales de una proposicion (entiendo que es preferentemente a las PropVar String)
assigns :: Prop -> [VarAsign]
assigns p = [fromList(zip vars i) | i <- assignsAux varsLenght]
    where
      vars = propVars p
      varsLenght = length vars

-- Devulve todas las posibles conbinaciones de True y False para n variables
assignsAux :: Int -> [[Bool]]
assignsAux 0 = [[]]
assignsAux n = (map (False:) xs) ++ (map (True:) xs)
    where xs = assignsAux (n-1)


-- Calcula si una proposición es una tautologia (Todas las combinaciones de variables dan como resultado True)
tautology :: Prop -> Bool
tautology (TruthValue a) = a
tautology prop =  if check then and (map (eval prop) varAssigns) else eval prop (fromList [])
    where 
      varAssigns = assigns prop
      check = length varAssigns > 0

 main = print (tautology (OpOR (PropVar "hola1") (OpNOT (PropVar "hola2")))) -- Not Tautology
-- main = print (tautology(OpBI (OpAND (PropVar "a1") (PropVar "a2")) (OpAND (PropVar "a2") (PropVar "a1")))) -- Tautology
-- main = print (tautology (OpOR(OpOR(PropVar "q1")(PropVar "q2"))(OpOR(PropVar "q3")(OpNOT (PropVar"q1"))))) -- Tautology
-- main = print (tautology (OpOR(OpOR(PropVar "q1")(PropVar "q2"))(OpOR(PropVar "q3")(OpNOT (PropVar"q4"))))) -- Not Tautology
-- main = print (tautology (TruthValue False )) -- Not Tautology
-- main = print (tautology (TruthValue True )) -- Tautology

