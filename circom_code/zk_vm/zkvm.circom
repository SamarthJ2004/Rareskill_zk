pragma circom 2.0.0;

include "./CopyStack.circom";

template ZKVM(n) {
  var NOP = 0;
  var PUSH = 1;
  var ADD = 2;
  var MUL = 3;
  var ARG = 4;

  signal input instructions[2*n];

  signal output sp[n+1];
  signal output stack[n][n];

  signal metaTable[n][5]; // IS_NOP, IS_PUSH, IS_ADD, IS_MUL, ARG

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
  metaTable[0][NOP] <== 1 - first_op_is_push;
  metaTable[0][MUL] <== 0;
  metaTable[0][ADD] <== 0;
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

  signal eqSpMinus2AndIsAdd[n][n];
  signal eqSpMinus2AndIsMul[n][n];
  for (var i=0;i <n;i++) {
    eqSpMinus2AndIsAdd[0][i] <== 0;
    eqSpMinus2AndIsMul[0][i] <== 0;
  }

  signal eqSpMinus2AndIsAddWithValue[n][n];
  signal eqSpMinus2AndIsMulWithValue[n][n];
  signal sum_result[n][n];
  signal mul_result[n][n];

  for (var i=0;i<n;i++) {
    eqSpMinus2AndIsAddWithValue[0][i] <== 0;
    eqSpMinus2AndIsMulWithValue[0][i] <== 0;
    sum_result[0][i] <== 0;
    mul_result[0][i] <== 0;
  }

  component EqPush[n];
  component EqNop[n];
  component EqMul[n];
  component EqAdd[n];

  component CopyStack[n];
  component EqSp[n][n];
  component EqSpMinus2[n][n];

  // need to delcare this array of components since can't create components inside a loop

  for (var i=1;i<n;i++) {
    EqPush[i] = IsEqual();
    EqPush[i].in[0] <== PUSH;
    EqPush[i].in[1] <== instructions[i * 2];

    EqAdd[i] = IsEqual();
    EqAdd[i].in[0] <== ADD;
    EqAdd[i].in[1] <== instructions[i * 2];

    EqMul[i] = IsEqual();
    EqMul[i].in[0] <== MUL;
    EqMul[i].in[1] <== instructions[i * 2];

    EqNop[i] = IsEqual();
    EqNop[i].in[0] <== NOP;
    EqNop[i].in[1] <== instructions[i * 2];

    metaTable[i][PUSH] <== EqPush[i].out;
    metaTable[i][NOP] <== EqNop[i].out;
    metaTable[i][ADD] <== EqAdd[i].out;
    metaTable[i][MUL] <== EqMul[i].out;
    metaTable[i][ARG] <== instructions[i * 2 + 1];

    CopyStack[i] = CopyStack(n);
    CopyStack[i].sp <== sp[i];
    CopyStack[i].is_push <== metaTable[i][PUSH];
    CopyStack[i].is_nop <== metaTable[i][NOP];
    CopyStack[i].is_add <== metaTable[i][ADD];
    CopyStack[i].is_mul <== metaTable[i][MUL];

    for (var j=0 ;j< n-1;j++) {
      sum_result[i][j] <== stack[i-1][j] + stack[i-1][j+1];
      mul_result[i][j] <== stack[i-1][j] * stack[i-1][j+1];
    }

    sum_result[i][n-1] <== 0;
    mul_result[i][n-1] <== 0;

    for (var j= 0; j<n;j ++) {
      previousCellIfShouldCopy[i][j] <== CopyStack[i].out[j] * stack[i-1][j];

      EqSp[i][j] = IsEqual();
      EqSp[i][j].in[0] <== sp[i];
      EqSp[i][j].in[1] <== j;

      eqSpAndIsPush[i][j] <== EqSp[i][j].out * metaTable[i][PUSH];

      EqSpMinus2[i][j] = IsEqual();
      EqSpMinus2[i][j].in[0] <== j;
      EqSpMinus2[i][j].in[1] <== sp[i] -2;

      eqSpMinus2AndIsAdd[i][j] <== EqSpMinus2[i][j].out * metaTable[i][ADD];
      eqSpMinus2AndIsMul[i][j] <== EqSpMinus2[i][j].out * metaTable[i][MUL];

      eqSpMinus2AndIsAddWithValue[i][j] <== eqSpMinus2AndIsAdd[i][j] * sum_result[i][j];
      eqSpMinus2AndIsMulWithValue[i][j] <== eqSpMinus2AndIsMul[i][j] * mul_result[i][j];

      stack[i][j] <== eqSpAndIsPush[i][j] * metaTable[i][ARG] + eqSpMinus2AndIsAddWithValue[i][j] + eqSpMinus2AndIsMulWithValue[i][j] + previousCellIfShouldCopy[i][j];
    }

    spBranch[i][INC] <== metaTable[i][PUSH] * (sp[i] + 1);
    spBranch[i][DEC] <== (metaTable[i][ADD] + metaTable[i][MUL]) * (sp[i] - 1);
    spBranch[i][SAME] <== metaTable[i][NOP] * (sp[i]);

    sp[i + 1] <== spBranch[i][INC] + spBranch[i][DEC] + spBranch[i][SAME];
  }
}

component main = ZKVM(5); // n is the number of instructions
