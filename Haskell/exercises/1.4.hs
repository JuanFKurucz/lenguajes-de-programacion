import System.Random
import Data.Map
import Data.List
import Data.Tuple
import Data.Map.Strict (Map, fromList)
import Data.Char

data JSONValue
  = JSONNull | JSONBool Bool | JSONNumber Double
  | JSONString String | JSONArray [JSONValue]
  | JSONObject (Map String JSONValue)
  deriving (Eq, Show)

  
stringify :: JSONValue -> String
stringify (JSONArray []) = "[]"
stringify JSONNull = "null"
stringify (JSONBool x) = show x 
stringify (JSONString x) = show x
stringify (JSONNumber x) = show x
stringify (JSONArray x) = "[" ++ intercalate "," (Prelude.map stringify x) ++ "]"
stringify (JSONObject m) = "{" ++ intercalate "," [ (\ x y -> show x  ++ ":" ++ stringify y) k v | (k, v) <- tuplas] ++ "}"
      where 
        tuplas = Data.Map.toList m

randomStr :: Int -> String -> IO String
randomStr n chars = do
    g <- newStdGen
    return (Data.List.take n [chars !! i | i <- randomRs (0, (length chars) - 1) g])

randomBool :: IO Bool
randomBool = do
    g <- newStdGen
    return (Data.List.take 1 (randoms g :: [Bool]) !! 0)

randomInt :: Int -> IO Integer
randomInt tope = do
    g <- newStdGen
    return (Data.List.take 1 (randoms g :: [Integer]) !! 0) 

randomDouble :: IO Double
randomDouble = do
  g <- newStdGen
  return (Data.List.take 1 (randoms g :: [Double]) !! 0) 

traductorJSON :: Int -> Int -> Int -> IO JSONValue
traductorJSON tipo alto ancho = 
    case tipo of
        1 -> return (JSONNull)
        2 -> do
            a <- randomBool
            return (JSONBool a)
        3 -> do
            a <- randomDouble
            return (JSONNumber a)
        4 -> do
            number <- randomInt 10
            a <- randomStr number "qwertyuiopasdfghjklzxcvbnm1234567890.,;[]{}?!"
            return (JSONString a)
        5 -> return (JSONNull)
        6 -> return (randomJSON alto ancho)


randomJSON :: Int -> Int -> IO JSONValue
randomJSON 0 0 = return (JSONNull)
randomJSON alto ancho = return (JSONNull)


main = do
    v <- traductorJSON 4--randomJSON 0 0
    putStrLn (stringify v)

aaa x = case x of 
    1 ->  "A"
    2 ->  "B"
    3 ->  "C"