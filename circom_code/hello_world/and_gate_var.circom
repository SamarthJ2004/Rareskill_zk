pragma circom 2.0.0;

template isBinary() {
signal input in;
signal output out;

in*(in-1) === 0;
out <== in;
}

template Multiplier_2() {
signal input in1;
signal input in2;
signal output out;

out <== in1 * in2;
}

template AndN (N){
signal input in[N];
signal output out;
component mul[N-1];
component binCheck[N];

for (var i = 0;i<N;i++) {
binCheck[i] = isBinary();
binCheck[i].in <== in[i];
}

for (var i = 0;i<N-1; i++) {
mul[i] = Multiplier_2();
}

mul[0].in1 <== binCheck[0].out;
mul[0].in2 <== binCheck[1].out;

for (var i = 0;i< N-2;i++){
mul[i+1].in1 <== mul[i].out;
mul[i+1].in2 <== binCheck[i+2].out;
}

out <== mul[N-2].out;
}

component main = AndN(4);
