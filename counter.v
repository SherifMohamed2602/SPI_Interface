module counter #(
    parameter COUNT_NUMBER = 10
)
(
    input clk, rst,
    output reg [4:0] count,
    output done
);

always @(posedge clk) begin
    if(rst)
       count <= 0;
    else 
       count <= count + 1;
end

assign done = (count >= COUNT_NUMBER)? 1: 0;

endmodule