module Train where

import Tensor
import Net
import Layer
import System.Random

train :: StdGen -> Net -> [([Double],[Double])] -> Int -> Double -> Net
train _ net _ 0 _ = net
train g net samples epochs epochLoss = 
  train (snd $ next g) net''' samples (pred epochs) epochLoss'
  where sampleR = take 2 $ randomRs (0, pred $ length samples) g
        samples' = (samples !!) <$> sampleR
        inputs = fromLists (fst <$> samples')
        targets = fromLists (snd <$> samples')
        (net', predicted) = predict net inputs
        epochLoss' = epochLoss + (netLoss net) predicted targets
        grad = (netGrad net) predicted targets
        (net'', _) = backPropagate net' grad
        net''' = (netOpt net) 0.01 net''
        
