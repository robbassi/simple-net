module Tensor (
  module Data.Matrix,
  Tensor,
  mkTensor,
  mkBias,
) where

import Data.Matrix
import Data.Random.Normal (mkNormals)
import Control.Monad.Random (Rand, StdGen, liftRand, next)

type Tensor = Matrix Double
-- ^ Tensor will just be an instance of Matrix

mkTensor :: Int -> Int -> Rand StdGen Tensor
-- ^ Build a tensor, using the standard normal distribution for values
mkTensor rs cs = liftRand next >>= return . fromList rs cs . mkNormals

mkBias :: Int -> Int -> Rand StdGen Tensor
-- ^ Similar to tensor, but repeats one row (due to limitations in library)
mkBias rs cs = do
  seed <- liftRand next
  let row = take cs (mkNormals seed)
  return . fromLists $ take rs (repeat row)

