module bit4_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output wire [3:0] Sum,
    output wire Cout
);
    wire [4:0] carry;
    assign carry[0] = Cin;

    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin : gen_adder
            assign Sum[i] = A[i] ^ B[i] ^ carry[i];
            assign carry[i+1] = (A[i] & B[i]) | (carry[i] & (A[i] ^ B[i]));
        end
    endgenerate

    assign Cout = carry[4];

endmodule
