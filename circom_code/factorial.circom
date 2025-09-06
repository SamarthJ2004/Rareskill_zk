pragma circom 2.0.0;

include "./node_modules/circomlib/circuits/multiplexer.circom";
include "./node_modules/circomlib/circuits/comparators.circom";

template factorial(n) {
  signal input in;
  signal output out;

  signal factorials[n+1];

  factorials[0] <== 1;

  for (var i = 1;i <= n;i++) {
    factorials[i] <== factorials[i-1] * i;
  }

  signal inLTn;
  inLTn <== LessThan(252)([in, n]);
  inLTn === 1;

  component mux = Multiplexer(1,n);

  mux.sel <== in;

  for (var i =0 ;i< n;i++) {
    mux.inp[i][0] <== factorials[i];
  }

  out <== mux.out[0];
}

component main = factorial(100);
