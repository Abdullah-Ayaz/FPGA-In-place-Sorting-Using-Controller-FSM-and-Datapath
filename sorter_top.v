

module sorter_top (
    input  clk, rst, s,
    output done
);

    // Internal signals
    wire EA, EB, WR, Li, Lj, Ei, Ej, Csel, Bout;
    wire AgtB, zi, zj;
    wire [2:0] Addr;
    wire [7:0] mem_din;
    wire  [7:0] mem_dout;

    // Memory (RAM)
    reg [7:0] memory [0:7];
    
    // Initialize memory with predefined values
    initial begin
        memory[0] = 8'd90;
        memory[1] = 8'd25;
        memory[2] = 8'd60;
        memory[3] = 8'd15;
        memory[4] = 8'd30;
        memory[5] = 8'd75;
        memory[6] = 8'd45;
        memory[7] = 8'd10;
    end
    
    // Memory read/write operations
    always @(posedge clk) begin
        if (WR) begin
            memory[Addr] <= mem_din;
        end

    end
    assign  mem_dout = memory[Addr];    
    // Datapath instance
    datapath dp (
        .clk(clk),
        .rst(rst),
        .EA(EA),
        .EB(EB),
        .WR(WR),
        .Li(Li),
        .Lj(Lj),
        .Ei(Ei),
        .Ej(Ej),
        .Csel(Csel),
        .Bout(Bout),
        .AgtB(AgtB),
        .zi(zi),
        .zj(zj),
        .Addr(Addr),
        .Din(mem_dout),
        .Dout(mem_din)
    );
    
    // Controller instance
    controller ctrl (
        .clk(clk),
        .rst(rst),
        .s(s),
        .AgtB(AgtB),
        .zi(zi),
        .zj(zj),
        .EA(EA),
        .EB(EB),
        .WR(WR),
        .Li(Li),
        .Lj(Lj),
        .Ei(Ei),
        .Ej(Ej),
        .Csel(Csel),
        .Bout(Bout),
        .done(done)
    );

endmodule




