pragma circom 2.0.0;

template Multiply2_add2() {
signal input x;
signal input y;
signal output out;

out <== x * y +2;
}

component main = Multiply2_add2();
