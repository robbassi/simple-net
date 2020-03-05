module XOR where

import Tensor
import Net
import Layer
import Train
import Text.Printf (printf)
import Control.Monad
import Control.Monad.Random 

inputs = [[0, 0]
         ,[1, 0]
         ,[0, 1]
         ,[1, 1]]

targets = [[0]
          ,[1]
          ,[1]
          ,[0]]

netXOR :: Rand StdGen Net
netXOR = do
  linearLayer1 <- linearLayer 2 2
  linearLayer2 <- linearLayer 2 1
  return $ mkNet [linearLayer1, tanhLayer, linearLayer2]

trainXOR :: Int -> Net -> Rand StdGen Net
trainXOR epochs net = train net (zip inputs targets) epochs 0.01

testNet :: Net -> IO ()
testNet net = forM_ (zip inputs targets) check
  where check (input,target) = do
          let [pred] = toList . snd $ predict net (fromLists [input])
              [targ] = target
              [inA, inB] = input
          printf "%f ^ %f = %f, predicted: %.5f\n"
                 inA inB targ pred
          
