pragma circom 2.0.0;

include "./node_modules/circomlib/circuits/multiplexer.circom";

template Multiplexer_Example(n) {
signal input in[n];
signal input sel;
signal output out;

component mux = Multiplexer(1,n);

for (var i =0;i< n;i++) {
mux.inp[i][0] <== in[i];
}

mux.sel <== sel;

out <== mux.out[0];
}

component main = Multiplexer_Example(5);
