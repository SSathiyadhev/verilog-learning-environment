module full_adder(
    input a,
    input b,
    input cin,
    output reg sum,
    output reg cout
);
    always @(*) begin
        if (cin) begin
            sum = ~(a^b);
            cout = a|b;
        end 
        else begin
            sum = a^b;
            cout = a&b;
        end
    end
endmodule
