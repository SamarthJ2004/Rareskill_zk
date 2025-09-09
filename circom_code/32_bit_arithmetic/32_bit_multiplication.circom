pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/bitify.circom";

template Bit32Mul() {
  signal input x;
  signal input y;

  signal output out;

  component CheckX = Num2Bits(32);
  component CheckY = Num2Bits(32);

  CheckX.in <== x;
  CheckY.in <== y;

  component MulXY = Num2Bits(64);
  MulXY.in <== x * y;

  component Mul32 = Bits2Num(32);

  for (var i =0;i< 32;i++) {
    Mul32.in[i] <== MulXY.out[i];
  }

  out <== Mul32.out;
}

component main = Bit32Mul();
