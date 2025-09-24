
module controller (
    input  clk, rst, s,
    input  AgtB, zi, zj,
    output reg EA, EB, WR, Li, Lj, Ei, Ej, Csel, Bout, done
);

    // State definitions
    parameter S0      = 4'd0,
              S1      = 4'd1,
              S2      = 4'd2,
              S3      = 4'd3,
              S4      = 4'd4,
              S5      = 4'd5,
              S6      = 4'd6,
              S7      = 4'd7,
              S8      = 4'd8,
              DONE_ST = 4'd9;

    reg [3:0] current_state, next_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst) 
            current_state <= S0;
        else 
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            S0: if (s) next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = (AgtB) ? S4 : S6;
            S4: next_state = S5;
            S5: next_state = S6;
            S6: begin
                if (zj) 
                    next_state = (zi) ? DONE_ST : S8;
                else 
                    next_state = S7;
            end
            S7: next_state = S2;
            S8: next_state = S1;
            DONE_ST: if (~s) next_state = S0;
        endcase
    end

    // Output logic
    always @(*) begin
        // Default values
        EA   = 1'b0;
        EB   = 1'b0;
        WR   = 1'b0;
        Li   = 1'b0;
        Lj   = 1'b0;
        Ei   = 1'b0;
        Ej   = 1'b0;
        Csel = 1'b0;
        Bout = 1'b0;
        done = 1'b0;

        case (current_state)
            S0: begin
                Li = 1'b1;
                Ei = 1'b0;
            end
            S1: begin
                EA   = 1'b1;
                Csel = 1'b0;
                Lj = 1'b1;
                Ej = 1'b0;
            end
            S2: begin

                EB   = 1'b1;
                Csel = 1'b1;
            end
            S3: begin

            end
            S4: begin
                WR   = 1'b1;
                Bout = 1'b1;   // Dout = B
                Csel = 1'b0;   // Addr = i
            end
            S5: begin
                WR   = 1'b1;
                Bout = 1'b0;   // Dout = A
                Csel = 1'b1;   // Addr = j
            end

            S6: begin
                EA   = 1'b1;
                Csel = 1'b0;
            end
            S7: begin
                Ej = 1'b1;
            end
            S8: begin
                Ei = 1'b1;
            end
            DONE_ST: begin
                done = 1'b1;
            end
        endcase
    end

endmodule


