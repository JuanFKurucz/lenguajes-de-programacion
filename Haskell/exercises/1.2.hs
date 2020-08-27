-- Define a method called stringify
-- It should recieve a JSON type and return a String with the formatted JSON

import Data.List
import Data.Map
import Data.Tuple
import Data.Map.Strict (Map, fromList)
import Data.Char

data JSONValue =
    JSONNull
  | JSONBool Bool
  | JSONNumber Double
  | JSONString String
  | JSONArray [JSONValue]
  | JSONObject (Map String JSONValue)
  deriving (Eq, Show)


stringify :: JSONValue -> String
stringify (JSONArray []) = "[]"
stringify (JSONNull) = "null"
stringify (JSONBool x) = show x 
stringify (JSONString x) = show x
stringify (JSONNumber x) = show x
stringify (JSONArray x) = "[" ++ intercalate "," (Prelude.map stringify x) ++ "]"
stringify (JSONObject m) = "{" ++ intercalate "," [ (\ x y -> show x  ++ ":" ++ stringify y) k v | (k, v) <- tuplas] ++ "}"
      where 
        tuplas = Data.Map.toList m

main = putStrLn (stringify (JSONObject (Data.Map.fromList [("JSON Number", JSONNumber 1.0), ("JSON String", JSONString "2"), ("JSON Array Null", JSONArray [JSONNull]), ("JSON Array String", JSONArray [(JSONString "Un String"), (JSONString "Otro String")])])))