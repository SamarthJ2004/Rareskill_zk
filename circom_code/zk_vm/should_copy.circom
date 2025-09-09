pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";
include "./And3.circom";

template ShouldCopy(j, bits) {
  signal input sp;
  signal input is_push;
  signal input is_nop;
  signal input is_add;
  signal input is_mul;

  signal output out;

  is_add + is_mul + is_push + is_nop === 1;
  is_nop * (1-is_nop) === 0;
  is_push * (1-is_push) === 0;
  is_add * (1-is_add) === 0;
  is_mul * (1 - is_mul) === 0;

  signal spEqZero;
  signal spGteOne;

  spEqZero <== IsZero()(sp);
  spGteOne <== 1 - spEqZero;

  signal spEqOne;
  signal spGteTwo;
  
  spEqOne <== IsEqual()([sp,1]);
  spGteTwo <== 1 - spEqZero * spEqOne;

  signal oneBelowSp <== LessEqThan(bits)([j,sp-1]);
  signal threeBelowSp <== LessEqThan(bits)([j,sp-3]);

  // first condition: sp is 1 or greater and out column is 1 below sp and the current instruction is push or nop, we copy

  component condA = And3();
  condA.in[0] <== spGteOne;
  condA.in[1] <== oneBelowSp;
  condA.in[2] <== is_push + is_nop;

  // second condition: sp is 2 or greater and out colum is 3 below sp and the current instruction is mul or add, we copy

  component condB = And3();
  condB.in[0] <== spGteTwo;
  condB.in[1] <== threeBelowSp;
  condB.in[2] <== is_mul + is_add;

  out <== condA.out + condB.out;
}
