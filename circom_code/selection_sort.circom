pragma circom 2.0.0;

include "./node_modules/circomlib/circuits/comparators.circom";
include "./quin_selector.circom";

template GetIndexOfMin(n,start) {
  signal input in[n];
  signal output index;
  signal output out;

  var min_val = in[start];
  var idx_val = start;
  for (var i = 1+ start;i < n;i++) {
    if (in[i] < min_val) {
      min_val = in[i];
      idx_val = i;
    }
  }

  out <-- min_val;
  index <-- idx_val;

  component lte[n];

  for (var i =start ;i<n;i++) {
    lte[i] = LessEqThan(252);
    lte[i].in[0] <== out;
    lte[i].in[1] <== in[i];
    lte[i].out === 1;
  }

  component qs = QuinSelector(n);
  qs.index <== index;
  for (var i = 0;i<n;i++) {
    qs.in[i] <== in[i];
  }
  qs.out ===  out;
}

template Swap(n) {
  signal input in[n];
  signal input s;
  signal input t;

  signal output out[n];

  signal stEq;
  stEq <== IsEqual()([s,t]);

  component qss = QuinSelector(n);
  for (var i=0;i< n;i++) {
    qss.in[i] <== in[i];
  }
  qss.index <== s;

  component qst = QuinSelector(n);
  for (var i =0;i<n;i++) {
    qst.in[i] <== in[i];
  }
  qst.index <== t;

  component indexEqS[n];
  component indexEqT[n];
  component indexNone[n];
  signal S[n];
  signal T[n];
  signal N[n];

  for (var i=0;i<n;i++) {
    indexEqS[i] = IsEqual();
    indexEqS[i].in[0] <== i;
    indexEqS[i].in[1] <== s;

    indexEqT[i] = IsEqual();
    indexEqT[i].in[0] <== i;
    indexEqT[i].in[1] <== t;

    indexNone[i] = IsZero();
    indexNone[i].in <== indexEqS[i].out + indexEqT[i].out;

    S[i] <== indexEqS[i].out * qst.out;
    T[i] <== indexEqT[i].out * qss.out;
    N[i] <== indexNone[i].out * in[i];

    out[i] <== S[i] + (1-stEq) * T[i] + N[i];
  }
}

template Select(n,start) {
  signal input in[n];
  signal output out[n];

  component minIdx = GetIndexOfMin(n, start);
  for (var i=0;i<n;i++) {
    minIdx.in[i] <== in[i];
  }

  component swap = Swap(n);
  swap.s <== start;
  swap.t <== minIdx.index;
  for (var i =0;i<n;i++) {
    swap.in[i] <== in[i];
  }

  for (var i=0;i<n;i++) {
    out[i] <== swap.out[i];
  }
}

template Selection_Sort(n) {
  assert (n>0);
  signal input in[n];
  signal output out[n];

  signal intermediateSorts[n][n];

  component SSort[n-1];
  for (var i=0;i<n;i++)  {
    if (i==0) {
      for (var j=0;j<n;j++) {
        intermediateSorts[0][j] <== in[j];
      }
    } else {
      SSort[i-1] = Select(n,i-1);

      for (var j=0;j<n;j++) {
        SSort[i-1].in[j] <== intermediateSorts[i-1][j];
      }

      for (var j=0;j<n;j++) {
        SSort[i-1].out[j] ==> intermediateSorts[i][j];
      }
    }
  }

  for (var i=0;i<n;i++) {
    out[i] <== intermediateSorts[n-1][i];
  }
}

component main = Selection_Sort(9);
