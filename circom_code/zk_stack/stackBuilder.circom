pragma circom 2.0.0;

include "./CopyStack.circom";

template StackBuilder(n) {
  var NOP = 0;
  var PUSH = 1;
  var POP = 2;
  var ARG = 3;

  signal input instructions[2*n];

  signal output sp[n+1];
  signal output stack[n][n];

  signal metaTable[n][4]; // IS_NOP, IS_PUSH, IS_POP, ARG

  (instructions[0] - PUSH) * (instructions[0] - NOP) === 0; // first instruction push or nop

  signal first_op_is_push;
  first_op_is_push <== IsEqual()([PUSH, instructions[0]]);

  stack[0][0] <== first_op_is_push * instructions[1];

  for (var i=1 ;i<n;i++) {
    stack[0][i] <== 0;
  }

  sp[0] <== 0;
  sp[1] <== first_op_is_push;
  metaTable[0][PUSH] <== first_op_is_push;
  metaTable[0][POP] <== 0;
  metaTable[0][NOP] <== 1 - first_op_is_push;
  metaTable[0][ARG] <== instructions[1];

  var SAME = 0;
  var INC = 1;
  var DEC = 2;

  signal spBranch[n][3];
  spBranch[0][INC] <== first_op_is_push;
  spBranch[0][SAME] <== 1 - first_op_is_push;
  spBranch[0][DEC] <== 0;

  signal eqSpAndIsPush[n][n];
  for (var i=0;i<n;i++) {
    eqSpAndIsPush[0][i] <== 0;
  }

  signal previousCellIfShouldCopy[n][n];
  for (var i =0;i<n;i++) {
    previousCellIfShouldCopy[0][i] <== 0;
  }

  component EqPush[n];
  component EqPop[n];
  component EqNop[n];

  component CopyStack[n];
  component EqSp[n][n];

  // need to delcare this array of components since can't create components inside a loop

  for (var i=1;i<n;i++) {
    EqPush[i] = IsEqual();
    EqPush[i].in[0] <== PUSH;
    EqPush[i].in[1] <== instructions[i * 2];

    EqPop[i] = IsEqual();
    EqPop[i].in[0] <== POP;
    EqPop[i].in[1] <== instructions[i * 2];

    EqNop[i] = IsEqual();
    EqNop[i].in[0] <== NOP;
    EqNop[i].in[1] <== instructions[i * 2];

    metaTable[i][PUSH] <== EqPush[i].out;
    metaTable[i][POP] <== EqPop[i].out;
    metaTable[i][NOP] <== EqNop[i].out;

    metaTable[i][ARG] <== instructions[i * 2 + 1];

    CopyStack[i] = CopyStack(n);
    CopyStack[i].sp <== sp[i];
    CopyStack[i].is_push <== metaTable[i][PUSH];
    CopyStack[i].is_pop <== metaTable[i][POP];
    CopyStack[i].is_nop <== metaTable[i][NOP];

    for (var j= 0; j<n;j ++) {
      previousCellIfShouldCopy[i][j] <== CopyStack[i].out[j] * stack[i-1][j];

      EqSp[i][j] = IsEqual();
      EqSp[i][j].in[0] <== sp[i];
      EqSp[i][j].in[1] <== j;

      eqSpAndIsPush[i][j] <== EqSp[i][j].out * metaTable[i][PUSH];

      stack[i][j] <== eqSpAndIsPush[i][j] * metaTable[i][ARG] + previousCellIfShouldCopy[i][j];
    }

    spBranch[i][INC] <== metaTable[i][PUSH] * (sp[i] + 1);
    spBranch[i][DEC] <== metaTable[i][POP] * (sp[i] - 1);
    spBranch[i][SAME] <== metaTable[i][NOP] * (sp[i]);

    sp[i + 1] <== spBranch[i][INC] + spBranch[i][DEC] + spBranch[i][SAME];
  }
}

component main = StackBuilder(5); // n is the number of instructions
