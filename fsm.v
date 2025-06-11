module fsm(
    input   clk,
    input   rst_n,

    output reg wr_en,

    output [7:0] fifo_data,
    
    input [3:0] fifo_words
);

    assign fifo_data = 8'hAA;

    parameter ESCREVENDO = 1'b0, AGUARDANDO = 1'b1;
    reg state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= ESCREVENDO;
        end else begin
            case (state)
                ESCREVENDO: begin
                    if (fifo_words >= 5)
                        state <= AGUARDANDO;
                end
                AGUARDANDO: begin
                    if (fifo_words <= 2)
                        state <= ESCREVENDO;
                end
                default: state <= ESCREVENDO;
            endcase
        end
    end

    always @(*) begin
        case (state)
            ESCREVENDO: wr_en = 1'b1;
            AGUARDANDO: wr_en = 1'b0;
            default:    wr_en = 1'b1;
        endcase
    end

endmodule