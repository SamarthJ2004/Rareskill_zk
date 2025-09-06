pragma circom 2.0.0;

include "./node_modules/circomlib/circuits/comparators.circom";
include "./node_modules/circomlib/circuits/multiplexer.circom";

template Fibonacci(n) {
  assert (n>=2);
  signal input in;
  signal output out;

  signal fib[n+1];

  fib[0] <== 1;
  fib[1] <== 1;
  for (var i =2;i<=n;i++) {
    fib[i] <== fib[i-1] + fib[i-2];
  }

  component mux = Multiplexer(1,n+1);
  mux.sel <== in;

  signal inLTn;
  inLTn <== LessThan(252)([in, n]);
  inLTn === 1;

  for (var i =0 ;i<=n;i++) {
    mux.inp[i][0] <== fib[i];
  }

  out <== mux.out[0];

}

component main = Fibonacci(9);
