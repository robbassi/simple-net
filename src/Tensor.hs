module Tensor (
  module Data.Matrix,
  Tensor,
  mkTensor,
  mkBias,
) where

import Data.Matrix
import qualified Data.Vector as V
import Data.Random.Normal (mkNormals)
import System.Random

type Tensor = Matrix Double
-- ^ Tensor will just be an instance of Matrix

mkTensor :: StdGen -> Int -> Int -> Tensor
-- ^ Build a tensor, using the standard normal distribution for values
mkTensor g rs cs = fromList rs cs (mkNormals seed)
  where (seed, _) = next g

mkBias :: StdGen -> Int -> Int -> Tensor
-- ^ Similar to tensor, but repeats one row (due to limitations in library)
mkBias g rs cs = fromLists $ take rs (repeat row)
  where row = take cs $ mkNormals seed
        (seed, _) = next g

