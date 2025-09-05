pragma circom 2.0.0;

template IsBinary() {
signal input in[2];

in[0] * (in[0]-1) === 0;
in[1] * (in[1]-1) === 0;
}

component main = IsBinary();
