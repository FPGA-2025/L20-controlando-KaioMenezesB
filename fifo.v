module fifo(
    input   clk,
    input   rst_n,

    // Write interface
    input   wr_en,
    input   [7:0] data_in,
    output  full,

    // Read interface
    input   rd_en,
    output  reg [7:0] data_out,
    output  empty,

    // status
    output reg [3:0] fifo_words  // Current number of elements
);

    localparam DEPTH = 8;
    localparam ADDR_WIDTH = 3;

    reg [7:0] buffer [0:DEPTH-1];
    reg [ADDR_WIDTH-1:0] write_ptr;
    reg [ADDR_WIDTH-1:0] read_ptr;

    assign empty = (fifo_words == 0);
    assign full = (fifo_words == DEPTH);

    always @(posedge clk) begin
        if (!rst_n) begin
            fifo_words <= 0;
        end else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b00: fifo_words <= fifo_words;
                2'b01: fifo_words <= fifo_words - 1;
                2'b10: fifo_words <= fifo_words + 1;
                2'b11: fifo_words <= fifo_words;
            endcase
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            write_ptr <= 0;
        end else if (wr_en && !full) begin
            buffer[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            read_ptr <= 0;
            data_out <= 8'bx;
        end else if (rd_en && !empty) begin
            data_out <= buffer[read_ptr];
            read_ptr <= read_ptr + 1;
        end
    end

endmodule