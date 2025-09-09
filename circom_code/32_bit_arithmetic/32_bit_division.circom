pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/bitify.circom";

template DivMod(wordsize) {
  assert (wordsize < 125);  // overflow can occur with 125*125 + 125 

  signal input numerator;
  signal input denominator;

  signal output remainder;
  signal output quotient;

  component iszero = IsZero();
  iszero.in <== denominator;
  iszero.out === 0;

  remainder <-- numerator % denominator;
  quotient <-- numerator \ denominator;

  component n2bN = Num2Bits(wordsize);
  component n2bD = Num2Bits(wordsize);
  component n2bQ = Num2Bits(wordsize);
  component n2bR = Num2Bits(wordsize);
  n2bN.in <== numerator;
  n2bD.in <== denominator;
  n2bQ.in <== quotient;
  n2bR.in <== remainder;

  numerator === denominator * quotient + remainder;

  signal remainderLessThanDenominator;

  remainderLessThanDenominator <== LessThan(wordsize)([remainder, denominator]);
  remainderLessThanDenominator === 1;
}

component main = DivMod(32);
