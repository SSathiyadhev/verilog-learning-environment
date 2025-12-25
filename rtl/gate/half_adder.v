module half_adder(
    input a,
    input b,
    output sum,
    output cout
);
    xor xor1(sum, a, b);
    and and1(cout, a, b); 

endmodule
