module datapath (
    input        clk, rst,
    // Control signals
    input        EA, EB, WR, Li, Lj, Ei, Ej, Csel, Bout,
    // Status flags
    output       AgtB, zi, zj,
    // Memory interface
    output [2:0] Addr,
    input  [7:0] Din,
    output [7:0] Dout
);

    // Internal registers and counters
    reg [7:0] A, B;
    reg [2:0] i, j;
    wire [2:0] next_i, next_j;
    
    // Address multiplexer
    assign Addr = (Csel == 1'b0) ? i : j;
    
    // Data output multiplexer
    assign Dout = (Bout == 1'b1) ? B : A;
    
    // Register A
    always @(posedge clk or posedge rst) begin
        if (rst) 
            A <= 8'b0;
        else if (EA) 
            A <= Din;
    end
    
    // Register B
    always @(posedge clk or posedge rst) begin
        if (rst) 
            B <= 8'b0;
        else if (EB) 
            B <= Din;
    end
    
    // i counter
    always @(posedge clk or posedge rst) begin
        if (rst) 
            i <= 3'b0;
        else if (Li) 
            i <= 3'b0;
        else if (Ei) 
            i <= next_i;
    end
    
    assign next_i = i + 1;
    
    // j counter
    always @(posedge clk or posedge rst) begin
        if (rst) 
            j <= 3'b0;
        else if (Lj) 
            j <= i + 1; // j = i + 1
        else if (Ej) 
            j <= next_j;
    end
    
    assign next_j = j + 1;
    
    // Comparator
    assign AgtB = (A > B);
    
    // Zero detection flags
    assign zi = (i == 3'd6); // i == k-2 (6 when k=8)
    assign zj = (j == 3'd7); // j == k-1 (7 when k=8)

endmodule


