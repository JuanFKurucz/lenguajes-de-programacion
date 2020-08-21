import System.Random

randomStr :: Int -> String -> IO String
randomStr n chars = do
    g <- newStdGen
    return (take n [chars !! i | i <- randomRs (0, (length chars) - 1) g])

main = do
    str <- randomStr 5 "abcdefghijklmnopq"
    putStrLn str