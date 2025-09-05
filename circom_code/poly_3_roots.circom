pragma circom 2.0.0;

include "circomlib/circuits/pointbits.circom";
include "circomlib/circuits/comparators.circom";

template CheckRoot() {
  signal input root;
  signal input coff[3];
  signal v1;
  signal v2;
  signal v3;
  signal output out;
  v1 <== root * root;
  v3 <== coff[0] * v1;
  v2 <== coff[1] * root + v1 + coff[2];

  component iszero = IsZero();
  iszero.in <== v2;
  out <-- iszero.out;
}

template RootsPoly_3() {
  signal input coff[3];      // [a,b,c] , ax2+bx+c
  signal roots[2];
  signal output out;

  var determinant = sqrt(coff[1] * coff[1] - 4 * coff[0] * coff[2]);
  var root1 = ((-1) * coff[1] + determinant) / 2 ;
  var root2 = ((-1) * coff[1] - determinant) / 2 ;

  roots[0] <-- root1;
  roots[1] <-- (-1) * root2;

  // constraints
  component checkRoot1 = CheckRoot();
  component checkRoot2 = CheckRoot();

  checkRoot1.root <== roots[0];
  checkRoot1.coff <== coff;

  checkRoot2.root <== roots[1];
  checkRoot2.coff <== coff;

  // both must satisfy polynomial
  out <== checkRoot1.out * checkRoot2.out;

}

component main = RootsPoly_3();
