module Main where

import XOR
import Control.Monad.Random

main :: IO ()
main = do
  net <- evalRandIO (netXOR >>= trainXOR 10000)
  testNet net
