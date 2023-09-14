module Single_port_Async_RAM #(
    parameter MEM_DEPTH = 256,
              ADDR_SIZE = 8
) (
    input [9:0] din,
    input clk, rst_n, rx_valid,
    output reg tx_valid,
    output reg [7:0] dout
);

reg [7:0] mem [MEM_DEPTH - 1 : 0];

reg [ADDR_SIZE - 1 : 0] wr_addr, rd_addr;

always @(posedge clk) begin
    if (~rst_n)begin
        dout <= 0;
        tx_valid <= 0;
        wr_addr <= 0;
        rd_addr <= 0;
    end

    else begin

    tx_valid <= (din[9] & din[8] & rx_valid)? 1 : 0;

    
    if (rx_valid)  
        case (din[9:8])

          2'b00 :    wr_addr <= din[7:0];
          2'b01 :    mem[wr_addr] <= din[7:0];
          2'b10 :    rd_addr <= din[7:0];
          2'b11 :    dout <= mem[rd_addr];
        endcase
    end
end



endmodule
