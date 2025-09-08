pragma circom 2.0.0;

include "./should_copy.circom";

template CopyStack(m) {
  var nBits = 4;
  signal output out[m];
  signal input sp;
  signal input is_pop;
  signal input is_push;
  signal input is_nop;

  component ShouldCopys[m];

  for (var i=0;i<m;i++) {
    ShouldCopys[i] = ShouldCopy(i, nBits);
    ShouldCopys[i].sp <== sp;
    ShouldCopys[i].is_pop <== is_pop;
    ShouldCopys[i].is_push <== is_push;
    ShouldCopys[i].is_nop <== is_nop;

    out[i] <== ShouldCopys[i].out;
  }
}
