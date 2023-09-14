module SPI_Wrapper (
    input MOSI, SS_n, clk, rst_n,
    output MISO
);

wire [9:0] rx_data;
wire [7:0] tx_data;
wire rx_valid, tx_valid;

Single_port_Async_RAM RAM (
    .din(rx_data), 
    .clk(clk), 
    .rst_n(rst_n), 
    .rx_valid(rx_valid), 
    .tx_valid(tx_valid), 
    .dout(tx_data)
    );

SPI_Slave SPI (
    .MOSI(MOSI), 
    .SS_n(SS_n), 
    .clk(clk), 
    .rst_n(rst_n), 
    .tx_valid(tx_valid), 
    .tx_data(tx_data), 
    .MISO(MISO), 
    .rx_valid(rx_valid), 
    .rx_data(rx_data)
    );

endmodule