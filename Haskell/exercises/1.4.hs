import Data.Char
import Data.List
import Data.Map
import Data.Map.Strict (Map, fromList)
import Data.Tuple
import System.Random

data JSONValue
  = JSONNull
  | JSONBool Bool
  | JSONNumber Double
  | JSONString String
  | JSONArray [JSONValue]
  | JSONObject (Map String JSONValue)
  deriving (Eq, Show)

boolToString :: Bool -> String
boolToString True = "true"
boolToString False = "false"

stringify :: JSONValue -> String
stringify (JSONArray []) = "[]"
stringify JSONNull = "null"
stringify (JSONBool x) = boolToString x
stringify (JSONString x) = show x
stringify (JSONNumber x) = show x
stringify (JSONArray x) = "[" ++ intercalate "," (Prelude.map stringify x) ++ "]"
stringify (JSONObject m) = "{" ++ intercalate "," [(\x y -> show x ++ ":" ++ stringify y) k v | (k, v) <- tuplas] ++ "}"
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

randomInt :: Int -> IO Int
randomInt tope = do
  g <- newStdGen
  number <- randomRIO (0, tope)
  return number

randomDouble :: IO Double
randomDouble = do
  g <- newStdGen
  return (Data.List.take 1 (randoms g :: [Double]) !! 0)

  
randomArray :: Int -> Int -> Int -> IO [JSONValue]
randomArray 0 height width = return ([])
randomArray quantity height width = do
  left <- randomJSON (height-1) width
  right <- (randomArray (quantity-1) height width)
  return ([left] ++ right)

randomString :: IO String
randomString = do
  number <- randomInt 10
  key <- randomStr number ([' '..'~'])
  return key

randomNStrings :: Int -> Int -> Int -> IO [String]
randomNStrings 0 height width = return ([])
randomNStrings quantity height width = do
  left <- randomString
  right <- (randomNStrings (quantity-1) height width)
  return ([left] ++ right)

randomObject :: Int -> Int -> Int -> IO JSONValue
randomObject quantity height width = do
  keys <- randomNStrings quantity height width
  values <- randomArray quantity height width
  return (JSONObject (Data.Map.fromList (zip (nub keys) values)))

traductorJSON :: Int -> Int -> Int -> IO JSONValue
traductorJSON tipo height width =
  case tipo of
    0 -> return (JSONNull)
    1 -> do
      a <- randomBool
      return (JSONBool a)
    2 -> do
      a <- randomDouble
      return (JSONNumber a)
    3 -> do
      key <- randomString
      return (JSONString key)
    4 -> do
      quantity <- randomInt width
      values <- randomArray quantity height width
      return (JSONArray values)
    5 -> do
      quantity <- randomInt width
      object <- (randomObject quantity height width)
      return object

randomJSON :: Int -> Int -> IO JSONValue
randomJSON 0 width = do
  randomType <- (randomInt 3)
  json <- traductorJSON randomType 0 width
  return json
randomJSON height width = do
    randomType <- (randomInt 5)
    json <- traductorJSON randomType height width
    return json

main = do
  height <- randomInt 10
  width <- randomInt 10
  v <- randomJSON height width
  putStrLn (stringify v)