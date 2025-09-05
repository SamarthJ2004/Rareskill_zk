pragma circom 2.0.0;

include "circomlib/circuits/comparators.circom";   // do it "./node_modules/circomlib/..." if dont want to specify -l path

template Max(n) {
  signal input in[n];
  signal output out;

  var max = 0;
  for (var i =0;i<n;i++) {
    max = in[i] > max ? in[i] : max;
  }
  assert(max == 89);
  signal maxSignal;
  maxSignal <-- max;

  component GTE[n];
  component EQ[n];

  var acc;
  for (var i = 0;i<n;i++) {
    GTE[i] = GreaterEqThan(252);
    GTE[i].in[0] <== maxSignal;
    GTE[i].in[1] <== in[i];

    GTE[i].out === 1;

    EQ[i] = IsEqual();
    EQ[i].in[0] <== maxSignal;
    EQ[i].in[1] <== in[i];
    acc += EQ[i].out;
  }

  signal allZero;
  allZero <== IsEqual()([0, acc]);
  allZero === 0;
  out <== maxSignal;
}

component main = Max(8);
