module FizzBuzz where

import Tensor
import Net
import Layer
import Train
import Text.Printf (printf)
import Control.Monad
import Control.Monad.Random 
import Data.Bits

inputs  = [binaryEncode n   | n <- [101..1023]]
targets = [fizzBuzzEncode n | n <- [101..1023]]

fizzBuzzEncode :: Int -> [Double]
fizzBuzzEncode n
  | n `mod` 15 == 0 = [0, 0, 0, 1]
  | n `mod` 5  == 0 = [0, 0, 1, 0]
  | n `mod` 3  == 0 = [0, 1, 0, 0]
  | otherwise       = [1, 0, 0, 0]

binaryEncode :: Int -> [Double]
binaryEncode n = [enc i | i <- [0..9]]
  where enc = fromIntegral . (.&.) 1 . shiftR n

netFizzBuzz :: Rand StdGen Net
netFizzBuzz = do
  linearLayer1 <- linearLayer 10 50
  linearLayer2 <- linearLayer 50 4
  return $ mkNet [linearLayer1, tanhLayer, linearLayer2]

trainFizzBuzz :: Int -> Net -> Rand StdGen Net
trainFizzBuzz epochs net = train net (zip inputs targets) epochs 0.001

testNet :: Net -> IO ()
testNet net = forM_ (zip [0..100] targets) check
  where check (input,target) = do
          let pred = toList . snd $ predict net (fromLists [binaryEncode input])
              actual = fizzBuzzEncode input
          printf "in: %s expected: %s predicted: %s\n"
                 (show input) (label input actual) (label input pred)
        label n pred = let idx = maxIndex pred
                       in case idx of
                            0 -> show n
                            1 -> "fizz"
                            2 -> "buzz"
                            3 -> "fizzbuzz"

maxIndex :: Ord a => [a] -> Int
maxIndex (x:xs) = fst $ foldl max' (0,x) (zip [1..] xs)
  where max' a b
          | snd a > snd b = a
          | snd a < snd b = b
          | otherwise = a
