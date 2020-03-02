module Train where

import Tensor
import Net
import Layer
import Control.Monad.Random

randRs :: Int -> (Int, Int) -> Rand StdGen [Int]
randRs n = replicateM n . liftRand . randomR

train :: Net -> [([Double],[Double])] -> Int -> Double -> Rand StdGen Net
train net _ 0 _ = return net
train net samples epochs epochLoss = do
  sampleR <- randRs 2 (0, (pred $ length samples))
  let samples' = (samples !!) <$> sampleR
      inputs = fromLists (fst <$> samples')
      targets = fromLists (snd <$> samples')
      (net', predicted) = predict net inputs
      epochLoss' = epochLoss + (netLoss net) predicted targets
      grad = (netGrad net) predicted targets
      (net'', _) = backPropagate net' grad
      net''' = (netOpt net) 0.01 net''
  train net''' samples (pred epochs) epochLoss'
