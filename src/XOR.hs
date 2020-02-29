module XOR where

import Tensor
import Net
import Layer
import Train
import Text.Printf (printf)
import Control.Monad
import System.Random (StdGen) 

inputs = [[0, 0]
         ,[1, 0]
         ,[0, 1]
         ,[1, 1]]

targets = [[1, 0]
          ,[0, 1]
          ,[0, 1]
          ,[1, 0]]

netXOR :: StdGen -> Net
netXOR g = mkNet [linearLayer g 2 2, tanhLayer, linearLayer g 2 2]

trainXOR :: StdGen -> Int -> Net -> Net
trainXOR g epochs net = train g net (zip inputs targets) epochs 0.0

testNet :: Net -> IO ()
testNet net = forM_ (zip inputs targets) check
  where check (input,target) = do
          let [predA, predB] = toList . snd $ predict net (fromLists [input])
              [targA, targB] = target
              [inA, inB] = input
          printf "in: [%f, %f] expected: [%f, %f] predicted: [%.5f, %.5f]\n"
                 inA inB targA targB predA predB
          
