Simple neural net in Haskell, inspired by [joelgrus/joelnet](https://github.com/joelgrus/joelnet).

### XOR Example
```
stack ghci
*Main> :l XOR
*XOR> import System.Random
*XOR System.Random> g <- getStdGen
*XOR System.Random> testNet $ trainXOR g 100 $ netXOR g          -- 100 epochs
in: [0.0, 0.0] expected: [1.0, 0.0] predicted: [0.29961, 0.48359]
in: [1.0, 0.0] expected: [0.0, 1.0] predicted: [0.53195, 0.52127]
in: [0.0, 1.0] expected: [0.0, 1.0] predicted: [0.28034, 0.65725]
in: [1.0, 1.0] expected: [1.0, 0.0] predicted: [0.46263, 0.60407]
*XOR System.Random> testNet $ trainXOR g 10000 $ netXOR g        -- 10000 epochs
in: [0.0, 0.0] expected: [1.0, 0.0] predicted: [1.00000, 0.00000]
in: [1.0, 0.0] expected: [0.0, 1.0] predicted: [-0.00000, 1.00000]
in: [0.0, 1.0] expected: [0.0, 1.0] predicted: [-0.00000, 1.00000]
in: [1.0, 1.0] expected: [1.0, 0.0] predicted: [1.00000, 0.00000]
```
