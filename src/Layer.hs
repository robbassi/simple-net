module Layer where

import Tensor
import Control.Monad.Random

data Layer = 
    LinearLayer 
      { linInputs :: Tensor
      , linWeight :: Tensor
      , linWeightGrad :: Tensor
      , linBias :: Tensor
      , linBiasGrad :: Tensor }
  | ActivationLayer 
      { actInputs :: Tensor
      , actF :: Tensor -> Tensor
      , actF' :: Tensor -> Tensor }

instance Show Layer where
  show (LinearLayer i _ _ _ _) = "LinearLayer { inputs = " ++ show i ++ ", ... }"
  show (ActivationLayer i _ _) = "ActivationLayer { inputs = " ++ show i ++ ", ... }"

forward :: Layer -> Tensor -> (Layer, Tensor)
forward (LinearLayer _ w wg b bg) inputs = 
  (LinearLayer inputs w wg b bg, inputs * w + b)
forward (ActivationLayer _ f f') inputs =
  (ActivationLayer inputs f f', f inputs)

backward :: Layer -> Tensor -> (Layer, Tensor)
backward (LinearLayer inputs w wg b bg) grad = 
  (LinearLayer inputs w wg' b bg', grad * transpose w)
  where wg' = transpose inputs * grad
        bg' = sumRows grad
backward (ActivationLayer inputs f f') grad =
  (ActivationLayer inputs f f', grad * f' inputs)

sumRows :: Tensor -> Tensor
sumRows t = fromLists . take (nrows t) $ repeat sum
  where sum = foldl (zipWith (+)) z rows
        rows = toLists t
        z = rows !! 0

linearLayer :: Int -> Int -> Rand StdGen Layer
linearLayer r c = do
  weight     <- mkTensor r c
  weightGrad <- mkTensor r c
  bias       <- mkBias r c
  biasGrad   <- mkBias r c
  return $ LinearLayer (identity 0) weight weightGrad bias biasGrad

tanhLayer :: Layer
tanhLayer = ActivationLayer (identity 0) f f'
  where f = fmap tanh
        f' = fmap tanh'
        tanh' x = 1 - tanh x ^ 2

