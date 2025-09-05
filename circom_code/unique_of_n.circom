pragma circom 2.0.0;

include "./node_modules/circomlib/circuits/comparators.circom";

template ForceNotEqual() {
signal input in[2];

component eq = IsEqual();
eq.in[0] <== in[0];
eq.in[1] <== in[1];
eq.out === 0;
}

template AllUnique(n) {
  signal input in[n];

  component Freq[n * (n-1) / 2 ];

  var index =0;
  for (var i =0;i<n; i++) {
    for (var j = i+1; j<n;j++) {
      Freq[index] = ForceNotEqual();
      Freq[index].in[0] <== in[i];
      Freq[index].in[1] <== in[j];
      index++;
    }
  }
}

component main  = AllUnique(6);
