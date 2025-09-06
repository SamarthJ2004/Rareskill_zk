pragma circom 2.1.4;

// Create a circuit which takes an input 'a',(array of length 2 ) , then  implement power modulo 
// and return it using output 'c'.

// HINT: Non Quadratic constraints are not allowed. 

include "./node_modules/circomlib/circuits/comparators.circom";
include "./node_modules/circomlib/circuits/multiplexer.circom";

template Pow(n) {
   
   // Your Code here.. 
   signal input a[2];
   signal output c;

   signal pow[n+1];
   pow[0] <== 1;
   for (var i = 1;i<=n;i++) {
    pow[i] <== pow[i-1] * a[1];
   }

   signal inLT;
   inLT <== LessThan(252)([a[0], n]);
   inLT === 1;

   component mux = Multiplexer(1,n+1);
   mux.sel <== a[0];

   for (var i=0;i<=n;i++) {
    mux.inp[i][0] <== pow[i];
   }

   c <== mux.out[0];

}

component main = Pow(8);

