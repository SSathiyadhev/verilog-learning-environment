`ifndef WAVE_FILE
  `error "WAVE_FILE not defined by Makefile"
`endif

module tb_bit4_adder;
    reg [3:0] tb_A, tb_B;
    reg tb_Cin;
    wire [3:0] tb_Sum;
    wire tb_Cout;

    integer i;
    integer error_count;
    bit4_adder dut_bit4_adder(.A(tb_A), .B(tb_B), .Cin(tb_Cin), .Sum(tb_Sum), .Cout(tb_Cout));
    initial begin
        $display("testing begin...");
        $dumpfile(`WAVE_FILE);
        $dumpvars(0, tb_bit4_adder);
        
        error_count = 0;
        for(i=0; i<=511; i=i+1) begin
            {tb_Cin, tb_A, tb_B} = i;
            #10;
        end

        if(error_count == 0) begin
            $display("All tests passed!");
        end
        else begin
            $display("%0d tests failed!", error_count);
        end
        $finish;
    end

    always @(tb_A, tb_B, tb_Cin) begin
        #1
        if((tb_A + tb_B + tb_Cin) == ({tb_Cout, tb_Sum})) begin
            $display("time=%0t, tb_A=%04b, tb_B=%04b, tb_Cin=%b, tb_Sum=%04b, tb_Cout=%b, ✅passed", $time, tb_A, tb_B, tb_Cin, tb_Sum, tb_Cout);
        end
        else begin
            $display("time=%0t, tb_A=%04b, tb_B=%04b, tb_Cin=%b, tb_Sum=%04b, tb_Cout=%b, ❌failed", $time, tb_A, tb_B, tb_Cin, tb_Sum, tb_Cout);
            error_count = error_count + 1;
        end

    end
endmodule
