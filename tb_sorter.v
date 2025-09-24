`timescale 1ns/1ps

module tb_sorter;

    reg clk, rst, s;
    wire done;

    // Instantiate the sorter_top
    sorter_top uut (
        .clk(clk),
        .rst(rst),
        .s(s),
        .done(done)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    integer k;

    initial begin
        // Enable waveform dump
        $dumpfile("sorter_waveform.vcd");   // VCD file name
        $dumpvars(0, tb_sorter);            // dump all signals in tb_sorter

        // Initialize signals
        clk = 0;
        rst = 1;
        s   = 0;

        // Apply reset
        #20 rst = 0;

        // Start sorting
        #10 s = 1;

        // Wait until sorting is done
        wait (done);

        // Wait a few cycles for stability
        #20;

        // Print sorted memory contents
        $display("==== SORTED RESULT ====");
        for (k = 0; k < 8; k = k + 1) begin
            $display("memory[%0d] = %0d", k, uut.memory[k]);
        end

        $finish;
    end

endmodule


