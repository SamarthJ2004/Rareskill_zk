pragma circom 2.0.0;

include "./node_modules/circomlib/circuits/comparators.circom";
include "./quin_selector.circom";

template Swap(n) {
  signal input in[n];
  signal input s;
  signal input t;

  signal output out[n];

  signal stEq;
  stEq <== IsEqual()([s,t]);

  component qss = QuinSelector(n);
  for (var i=0;i< n;i++) {
    qss.in[i] <== in[i];
  }
  qss.index <== s;

  component qst = QuinSelector(n);
  for (var i =0;i<n;i++) {
    qst.in[i] <== in[i];
  }
  qst.index <== t;

  component indexEqS[n];
  component indexEqT[n];
  component indexNone[n];
  signal S[n];
  signal T[n];
  signal N[n];

  for (var i=0;i<n;i++) {
    indexEqS[i] = IsEqual();
    indexEqS[i].in[0] <== i;
    indexEqS[i].in[1] <== s;

    indexEqT[i] = IsEqual();
    indexEqT[i].in[0] <== i;
    indexEqT[i].in[1] <== t;

    indexNone[i] = IsZero();
    indexNone[i].in <== indexEqS[i].out + indexEqT[i].out;

    S[i] <== indexEqS[i].out * qst.out;
    T[i] <== indexEqT[i].out * qss.out;
    N[i] <== indexNone[i].out * in[i];

    out[i] <== S[i] + (1-stEq) * T[i] + N[i];
  }
}

component main = Swap(10);
