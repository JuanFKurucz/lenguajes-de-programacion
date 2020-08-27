import qualified Data.HashMap.Strict as Map
import Data.List (nub)
import Data.Maybe (fromJust)
import System.Random

data Prop = TruthValue Bool | PropVar String
   | OpNOT Prop
   | OpAND Prop Prop | OpOR Prop Prop
   | OpIF Prop Prop | OpIFF Prop Prop
   deriving (Eq, Show)

type VarAsign = Map.HashMap String Bool

--Evalua una proposición a variables proposicionales, dada una asignación de valores de verdad
eval :: Prop -> VarAsign -> Bool
eval (PropVar v)     va   = fromJust (Map.lookup v va)
eval (TruthValue v)  _    = v
eval (OpNOT p)       va   = not (eval p va)
eval (OpAND p1 p2)   va   = (eval p1 va) && (eval p2 va)
eval (OpOR p1 p2)    va   = (eval p1 va) || (eval p2 va)
eval (OpIF p1 p2)    va   = if (eval p2 va) then (eval p1 va) else  not (eval p1 va)
eval (OpIFF p1 p2)   va   = if (eval p1 va) then (eval p2 va) else  not (eval p2 va)

--Calcula las variables de una proposición
propVars :: Prop -> [String]
propVars (TruthValue v) = []
propVars (PropVar s)    = [s]
propVars (OpNOT p1)     = propVars p1
propVars (OpAND p1 p2)  = nub (propVars p1 ++ propVars p2)
propVars (OpOR p1 p2)   = nub (propVars p1 ++ propVars p2)
propVars (OpIF p1 p2)   = nub (propVars p1 ++ propVars p2)
propVars (OpIFF p1 p2)  = nub (propVars p1 ++ propVars p2)

--Genera asignaciones aleatorias de valores de verdad a variables
randomVarAsign :: [String] -> IO VarAsign
randomVarAsign [] = return Map.empty
randomVarAsign (x:xs) = do var <- randomRIO (True, False)
                           cs <- randomVarAsign (xs)
                           return (Map.union (Map.insert x var Map.empty) cs)

-- Definir un generador de proposiciones (tipo Prop) aleatorias: 
-- Limitar la altura del árbol. 
randomProp :: Int -> IO Prop 
randomProp 0 = do
               rb <- randomRIO (True,False)
               return (TruthValue rb)
randomProp x = do
                r <- randomRIO(0, 5)
                case r ::  Int of
                  0 -> do
                        rp <- randomProp (x-1)
                        return (OpNOT rp)
                  1 -> do
                        rp1 <- randomProp (x-1)
                        rp2 <- randomProp (x-1)
                        return (OpAND rp1 rp2)
                  2 -> do
                        rp1 <- randomProp (x-1)
                        rp2 <- randomProp (x-1)
                        return (OpOR rp1 rp2)
                  3 -> do
                        rp1 <- randomProp (x-1)
                        rp2 <- randomProp (x-1)
                        return (OpIF rp1 rp2)
                  4 -> do
                        rp1 <- randomProp (x-1)
                        rp2 <- randomProp (x-1)
                        return (OpIFF rp1 rp2)
                  5 -> do
                        rb <- randomRIO (True,False)
                        return (TruthValue rb)
