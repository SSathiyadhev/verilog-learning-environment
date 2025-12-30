module bit4_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);
    reg [4:0] carry;

    integer i;

    always @(*) begin
        carry[0] = Cin;

        for(i=0; i<=3; i=i+1) begin
            Sum[i] = A[i] ^ B[i] ^ carry[i];
            carry[i+1] = (A[i] & B[i]) | (carry[i] & (A[i] ^ B[i]));
        end
    
        Cout = carry[4];
    end

endmodule
