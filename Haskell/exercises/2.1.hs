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
assigns p =  (nub [fromList [(x,y)] | x <- (propVars p), y <- [True, False]])

-- --Genera asignaciones aleatorias de valores de verdad a variables
-- randomVarAsign :: [String] -> IO VarAsign
-- randomVarAsign [] = return Map.empty
-- randomVarAsign (x:xs) = do var <- randomRIO (True, False)
--                            cs <- randomVarAsign (xs)
--                            return (Map.union (Map.insert x var Map.empty) cs)

-- -- Definir un generador de proposiciones (tipo Prop) aleatorias: 
-- -- Limitar la altura del árbol. 
-- randomProp :: Int -> IO Prop 
-- randomProp 0 = do
--                rb <- randomRIO (True,False)
--                return (TruthValue rb)
-- randomProp x = do
--                 r <- randomRIO(0, 5)
--                 case r ::  Int of
--                   0 -> do
--                         rp <- randomProp (x-1)
--                         return (OpNOT rp)
--                   1 -> do
--                         rp1 <- randomProp (x-1)
--                         rp2 <- randomProp (x-1)
--                         return (OpAND rp1 rp2)
--                   2 -> do
--                         rp1 <- randomProp (x-1)
--                         rp2 <- randomProp (x-1)
--                         return (OpOR rp1 rp2)
--                   3 -> do
--                         rp1 <- randomProp (x-1)
--                         rp2 <- randomProp (x-1)
--                         return (OpIF rp1 rp2)
--                   4 -> do
--                         rp1 <- randomProp (x-1)
--                         rp2 <- randomProp (x-1)
--                         return (OpIFF rp1 rp2)
--                   5 -> do
--                         rb <- randomRIO (True,False)
--                         return (TruthValue rb)

-- Calcula si una proposición es una tautologia (Todas las combinaciones de variables dan como resultado True)
tautology :: Prop -> Bool
tautology (TruthValue a) = a
tautology prop =  if check then and (map (eval prop) varAssigns) else eval prop (fromList [])
    where 
      varAssigns = assigns prop
      check = length varAssigns > 0

-- print (assigns (OpOR (PropVar "hola1") (OpNOT (PropVar "hola2"))))
main = print (tautology(OpAND (PropVar "hola1") (OpNOT (PropVar "hola2"))))