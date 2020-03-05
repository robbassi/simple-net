module Train where

import Tensor
import Net
import Layer
import Control.Monad.Random

randRs :: Int -> (Int, Int) -> Rand StdGen [Int]
randRs n = replicateM n . liftRand . randomR

train :: Net -> [([Double],[Double])] -> Int -> Double -> Rand StdGen Net
train net _ 0 _ = return net
train net samples epochs learnRate = do
  sampleR <- randRs (length . fst $ samples !! 0) (0, (pred $ length samples))
  let samples' = (samples !!) <$> sampleR
      inputs = fromLists (fst <$> samples')
      targets = fromLists (snd <$> samples')
      (net', predicted) = predict net inputs
      --epochLoss' = epochLoss + (netLoss net) predicted targets
      grad = (netGrad net) predicted targets
      (net'', _) = backPropagate net' grad
      net''' = (netOpt net) learnRate net''
  train net''' samples (pred epochs) learnRate
