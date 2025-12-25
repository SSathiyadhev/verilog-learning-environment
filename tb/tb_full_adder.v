`ifndef WAVE_FILE
  `error "WAVE_FILE not defined by Makefile"
`endif

module tb_full_adder;
    wire tb_cout, tb_sum;
    reg tb_a, tb_b, tb_cin;

    full_adder dut_full_adder(.a(tb_a), .b(tb_b), .cin(tb_cin), .sum(tb_sum), .cout(tb_cout));
    
    integer i;
    
    initial begin
        $display("testing begin...");
        $dumpfile(`WAVE_FILE);
        $dumpvars(0, tb_full_adder);
        $monitor("time=%0t, tb_a=%b, tb_b=%b, tb_cin=%b, tb_sum=%b, tb_cout=%b", $time, tb_a, tb_b, tb_cin, tb_sum, tb_cout);

        for(i=0; i<=7; i=i+1) begin
            {tb_a, tb_b, tb_cin} = i[2:0];
            #10;
        end

        $finish;
    end

endmodule
