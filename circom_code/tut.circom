include "circomlib/circuits/gates.circom";
include "circomlib/circuits/comparators.circom";

template DisjointExample2() {
signal input x;
signal input y;

component nand = NAND();
nand.a <== LessThan(252)([x,100]);
nand.b <== LessThan(252)([y,100]);

nand.out === 1;
}

component main = DisjointExample2();
