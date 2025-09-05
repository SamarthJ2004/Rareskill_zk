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

template And2() {
signal input in1;
signal input in2;
signal output out;

component mul = Multiplier_2();
component binCheck[2];

binCheck[0] = isBinary();
binCheck[0].in <-- in1;
binCheck[1] = isBinary();
binCheck[1].in <== in2;

mul.in1 <== binCheck[0].out;
mul.in2 <== binCheck[1].out;

out <== mul.out;
}

component main = And2();
