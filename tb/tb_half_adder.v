`ifndef WAVE_FILE
  `error "WAVE_FILE not defined by Makefile"
`endif

module tb_half_adder;
    reg tb_a, tb_b;
    wire tb_sum, tb_cout;

    half_adder dut_half_adder(.a(tb_a), .b(tb_b), .sum(tb_sum), .cout(tb_cout));

    initial begin
        $display("testing begin...");
        $dumpfile(`WAVE_FILE);
        $dumpvars(0, tb_half_adder);
        $monitor("time=%0t, tb_a=%b, tb_b=%b, tb_sum=%b, tb_cout=%b", $time, tb_a, tb_b, tb_sum, tb_cout);
        tb_a = 0; tb_b=0;
        #10 tb_a = 0; tb_b=1;
        #10 tb_a = 1; tb_b=0;
        #10 tb_a = 1; tb_b=1;
        #10 $finish;
    end
endmodule
