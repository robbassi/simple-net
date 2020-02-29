module Net where

import Tensor
import Layer

type LossFunction = Tensor -> Tensor -> Double
type GradFunction = Tensor -> Tensor -> Tensor
type OptFunction = Double -> Net -> Net

data Net = Net { netLayers :: [Layer]
               , netLoss :: LossFunction
               , netGrad :: GradFunction
               , netOpt :: OptFunction }

instance Show Net where
  show net = "Net { layers = " ++ show (netLayers net) ++ " }"

mseLoss :: LossFunction
mseLoss predicted actual = sum $ (predicted - actual) ^ 2

mseGrad :: GradFunction
mseGrad predicted actual = (*2) <$> (predicted - actual)

sgdOpt :: OptFunction
sgdOpt rate net = net { netLayers = reverse . foldl f [] $ netLayers net }
  where f ls (LinearLayer i w wg b bg) = 
          (LinearLayer i (adjust w wg) wg (adjust b bg) bg):ls
        f ls l = l:ls
        adjust tensor grad = tensor - ((*rate) <$> grad)

predict :: Net -> Tensor -> (Net, Tensor)
predict net inputs = (net { netLayers = reverse layers' }, result')
  where (layers', result') = foldl f ([], inputs) (netLayers net)
        f (ls, i) l = let (l', i') = forward l i
                      in (l':ls, i')

backPropagate :: Net -> Tensor -> (Net, Tensor)
backPropagate net grad = (net { netLayers = layers' }, result')
  where (layers', result') = foldl f ([], grad) (reverse $ netLayers net)
        f (ls, g) l = let (l', g') = backward l g
                      in (l':ls, g')

mkNet :: [Layer] -> Net
mkNet layers = Net layers mseLoss mseGrad sgdOpt
