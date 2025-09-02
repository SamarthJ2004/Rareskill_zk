pragma circom 2.0.0;

template Multiply3_add5() {
signal input x;
signal input y;
signal input u;

signal output z;
signal v1;
signal v2;

v1 <== x*y;
v2 <== 3*x*v1;

z <== v2 + 5*x*y -x -2*y +3;
}

component main = Multiply3_add5();
