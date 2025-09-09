pragma circom 2.0.0;

include "./should_copy.circom";

template CopyStack(m) {
  var nBits = 4;
  signal output out[m];
  signal input sp;
  signal input is_push;
  signal input is_nop;
  signal input is_add;
  signal input is_mul;

  component ShouldCopys[m];

  for (var i=0;i<m;i++) {
    ShouldCopys[i] = ShouldCopy(i, nBits);
    ShouldCopys[i].sp <== sp;
    ShouldCopys[i].is_push <== is_push;
    ShouldCopys[i].is_nop <== is_nop;
    ShouldCopys[i].is_add <== is_add;
    ShouldCopys[i].is_mul <== is_mul;

    out[i] <== ShouldCopys[i].out;
  }
}
