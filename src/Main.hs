module Main where

import XOR
import System.Random (getStdGen)

main :: IO ()
main = do
  g <- getStdGen
  testNet $ trainXOR g 10000 $ netXOR g
  
