function sqrt(n) {

if (n==0) {
return 0;
}

var res = n ** ((-1) >> 1);         // Euler crieterian : a ^ (p-1/2)

if (res!=1) {
// assert(false, "SQRT does not exists");
return 0;
}

var m = 28;
var c= 

}
