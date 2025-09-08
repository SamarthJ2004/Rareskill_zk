pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/gates.circom";

template And3() {
  signal input in[3];
  signal output out;

  signal temp;
  temp <== in[0] * in[1];

  out <== temp * in[2];
}
