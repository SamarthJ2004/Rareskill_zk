pragma circom 2.0.0;

include "./node_modules/circomlib/circuits/comparators.circom";

template CalculateTotal(n) {
  signal input in[n];
  signal output out;

  var sum = 0;
  for (var i =0;i<n;i++) {
    sum += in[i];
  }

  out <== sum;

  // signal sums[n];

  // sums[0] <== in[0];
  // for (var i =1;i<n;i++) {
  //   sums[i] <== sums[i-1] + in[i];
  // }

  // out <== sums[n-1];

}

template QuinSelector(n) {
  signal input in[n];
  signal input index;
  signal output out;

  component lessthan = LessThan(252);
  lessthan.in[0] <== index;
  lessthan.in[1] <== n;
  lessthan.out === 1;

  component calcTotal = CalculateTotal(n);
  component eqs[n];

  for (var i =0;i<n;i++) {
    eqs[i] = IsEqual();
    eqs[i].in[0] <== i;
    eqs[i].in[1] <== index;
    calcTotal.in[i] <== in[i] * eqs[i].out;
  }

  out <== calcTotal.out;
}

