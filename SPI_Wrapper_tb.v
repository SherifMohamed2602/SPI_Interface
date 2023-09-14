`timescale 1ns/1ns
module SPI_Wrapper_tb ();

reg MOSI, SS_n, clk, rst_n;
wire MISO;

parameter CLK_PERIOD = 10;

reg [7:0] wr_add, rd_add; 
reg [7:0] wr_data, rd_data;


SPI_Wrapper dut(
    .MOSI(MOSI),
    .SS_n(SS_n), 
    .clk(clk), 
    .rst_n(rst_n),
    .MISO(MISO)
);

always #(CLK_PERIOD/2) clk = ~clk ;

initial begin

    $readmemh ("data.dat" ,dut.RAM.mem);

    clk = 0;
    rst_n = 0;
    SS_n = 1;
    MOSI = 0;
    wr_add = 0;
    rd_add = 0;
    wr_data = 0;
    rd_data = 0;
    #(CLK_PERIOD)

    rst_n = 1;
    repeat(10) begin 
    $display("              TEST CASE 1: Write Address Operation");

    SS_n = 0;
    #(CLK_PERIOD)

    MOSI = 0;
    #(CLK_PERIOD);

    MOSI = 0;
    #(CLK_PERIOD);

    MOSI = 0;
    #(CLK_PERIOD);

    repeat(8)begin
        MOSI = $random;
        wr_add = {wr_add[6:0], MOSI};
        #(CLK_PERIOD);
    end

    SS_n = 1;
    #(CLK_PERIOD)
    if(dut.RAM.wr_addr == wr_add)
         $display ("no error in address of writing");
    else 
         $display ("error in address of writing");

    #(CLK_PERIOD)


    $display("              TEST CASE 2: Write Data Operation");

    SS_n = 0;
    #(CLK_PERIOD)

    MOSI = 0;
    #(CLK_PERIOD);

    MOSI = 0;
    #(CLK_PERIOD);

    MOSI = 1;
    #(CLK_PERIOD);

    repeat(8)begin
        MOSI = $random;
        wr_data = {wr_data[6:0], MOSI};
        #(CLK_PERIOD);
    end
    SS_n = 1;

    #(CLK_PERIOD)
    if(dut.RAM.mem[wr_add] == wr_data)
         $display ("no error in writing data");
    else 
         $display ("error in writing data");

    #(CLK_PERIOD)

    $display("              TEST CASE 3: Read Address Operation");

    SS_n = 0;
    #(CLK_PERIOD)

    MOSI = 1;
    #(CLK_PERIOD);

    MOSI = 1;
    #(CLK_PERIOD);

    MOSI = 0;
    #(CLK_PERIOD);

    repeat(8)begin
        MOSI = $random;
        rd_add = {rd_add[6:0], MOSI};
        #(CLK_PERIOD);
    end
    SS_n = 1;

    #(CLK_PERIOD)
    if(dut.RAM.rd_addr == rd_add)
         $display ("no error in address of read");
    else 
         $display ("error in address of read");

    #(CLK_PERIOD)

        $display("              TEST CASE 4: Read Data Operation");

    SS_n = 0;
    #(CLK_PERIOD)

    MOSI = 1;
    #(CLK_PERIOD);

    MOSI = 1;
    #(CLK_PERIOD);

    MOSI = 1;
    #(CLK_PERIOD);


    repeat(8)begin
        MOSI = $random;
        #(CLK_PERIOD);
    end

    #(CLK_PERIOD);

    repeat(8)begin
        #(CLK_PERIOD);
        rd_data = {rd_data[6:0], MISO};
    end
    SS_n = 1;
    
    #(CLK_PERIOD);
    if(dut.RAM.mem[rd_add] == rd_data)
         $display ("no error in reading data");
    else 
         $display ("error in reading data");

    #(CLK_PERIOD*2);
    end 

    $stop;
  

end

endmodule