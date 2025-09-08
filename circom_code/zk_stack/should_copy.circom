pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";
include "./And3.circom";

template ShouldCopy(j, bits) {
  signal input sp;
  signal input is_pop;
  signal input is_push;
  signal input is_nop;

  signal output out;

  is_pop + is_push + is_nop === 1;
  is_nop * (1-is_nop) === 0;
  is_nop * (1-is_nop) === 0;
  is_nop * (1-is_nop) === 0;

  signal spEqZero;
  signal spGteOne;

  spEqZero <== IsZero()(sp);
  spGteOne <== 1 - spEqZero;

  signal spEqOne;
  signal spGteTwo;
  
  spEqOne <== IsEqual()([sp,1]);
  spGteTwo <== 1 - spEqZero * spEqOne;

  signal oneBelowSp <== LessEqThan(bits)([j,sp-1]);
  signal twoBelowSp <== LessEqThan(bits)([j,sp-2]);

  // first condition: sp is 1 or greater and out column is 1 below sp and the current instruction is push or nop, we copy

  component condA = And3();
  condA.in[0] <== spGteOne;
  condA.in[1] <== oneBelowSp;
  condA.in[2] <== is_push + is_nop;

  component condB = And3();
  condB.in[0] <== spGteTwo;
  condB.in[1] <== twoBelowSp;
  condB.in[2] <== is_pop;

  out <== condA.out + condB.out;
}
