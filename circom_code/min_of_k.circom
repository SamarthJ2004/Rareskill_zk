pragma circom 2.0.0;

include "./node_modules/circomlib/circuits/comparators.circom";

template MinN(n) {
signal input in[n];
signal output out;

var min = in[0];
for (var i = 1;i<n;i++) {
min = in[i] < min ? in[i] : min;
}

signal minSignal;
minSignal <-- min;

component lessthan[n];
component equal[n];
var arr;

for (var i= 0;i<n;i++){
lessthan[i] = LessEqThan(252);
lessthan[i].in[0] <== minSignal;
lessthan[i].in[1] <== in[i];

lessthan[i].out === 1;

equal[i] = IsEqual();
equal[i].in[0] <== in[i];
equal[i].in[1] <== minSignal;
arr += equal[i].out;
}

signal isZero;
isZero <== IsEqual()([0,arr]);
isZero === 0;
out <== minSignal;
}

component main = MinN(8);
