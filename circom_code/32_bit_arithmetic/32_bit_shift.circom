pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../quin_selector.circom";

template BitShift() {
  signal input x;
  signal input s;

  signal power_of_2[32];
  power_of_2[0] <== 1;

  component quin = QuinSelector(32);
  quin.index <== s;
  quin.in[0] <== 1;

  for (var i=1;i<32;i++) {
    power_of_2[i] <== power_of_2[i-1] * 2;
    quin.in[i] <== power_of_2[i];
  }

  signal output out;

  out <== x * quin.out;
}

component main = BitShift();
