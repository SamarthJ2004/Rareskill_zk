pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/bitify.circom";

template Bit32Addition() {
  signal input x;
  signal input y;
  signal output out;

  component CheckX = Num2Bits(32);
  CheckX.in <== x;

  component CheckY = Num2Bits(32);
  CheckY.in <== y;

  component AddXY = Num2Bits(33);
  AddXY.in <== x + y;

  component Num32 = Bits2Num(32);
  for (var i =0;i< 32;i++) {
    Num32.in[i] <== AddXY.out[i];
  }

  out <== Num32.out;
}

component main = Bit32Addition();
