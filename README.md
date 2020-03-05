Simple neural net in Haskell, inspired by [joelgrus/joelnet](https://github.com/joelgrus/joelnet).

### XOR Example
```
$ stack ghci
*Main> :l XOR
*XOR> evalRandIO (netXOR >>= trainXOR 1000) >>= testNet -- 1000 epochs
0.0 ^ 0.0 = 0.0, predicted: 0.06882
1.0 ^ 0.0 = 1.0, predicted: 0.99071
0.0 ^ 1.0 = 1.0, predicted: 0.52827
1.0 ^ 1.0 = 0.0, predicted: 0.58149
*XOR> evalRandIO (netXOR >>= trainXOR 5000) >>= testNet -- 5000 epochs, takes a couple of tries
0.0 ^ 0.0 = 0.0, predicted: 0.00000
1.0 ^ 0.0 = 1.0, predicted: 1.00000
0.0 ^ 1.0 = 1.0, predicted: 1.00000
1.0 ^ 1.0 = 0.0, predicted: 0.00000
```
### FizzBuzz Example
This one is still a work in progress..
```
$ stack ghci
*Main> :l FizzBuz
*FizzBuzz> evalRandIO (netFizzBuzz >>= trainFizzBuzz 5000) >>= testNet 
in: 0 expected: fizzbuzz predicted: buzz
in: 1 expected: 1 predicted: buzz
in: 2 expected: 2 predicted: 2
in: 3 expected: fizz predicted: buzz
in: 4 expected: 4 predicted: 4
in: 5 expected: buzz predicted: buzz
in: 6 expected: fizz predicted: 6
in: 7 expected: 7 predicted: 7
...
```
