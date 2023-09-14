module SPI_Slave (
    input MOSI, SS_n, clk, rst_n, tx_valid,
    input [7:0] tx_data,
    output reg MISO, 
    output rx_valid,
    output reg [9:0] rx_data
);

localparam  [2:0]    IDLE      = 3'b000,
                     CHK_CMD   = 3'b001,
                     WRITE     = 3'b010,
                     READ_ADD  = 3'b011,
                     READ_DATA = 3'b100;

(* fsm_encoding = "gray" *)					 
reg    [2:0]         current_state,
                     next_state ;    


wire StoP_done, PtoS_done;
reg [2:0] PtoS_index;

reg rst_counter1, rst_counter2;

counter #(10) StoP (clk, rst_counter1, , StoP_done);
counter #(7) PtoS (clk, rst_counter2, , PtoS_done);



always @(posedge clk) begin

    if (~rst_n) begin 
         current_state <= IDLE;
    end 
    else begin 
         current_state <= next_state; 
    end  
    
end

reg rd_add_recieved;

always @(*) begin

    case (current_state)
     
      IDLE                 : 
                             if (SS_n) 
                                 next_state = IDLE; 
                             else 
                                 next_state = CHK_CMD;
      
      CHK_CMD              : 
                             if (~SS_n) begin
                                 if (~MOSI) 
                                     next_state = WRITE; 
                                 else if (~rd_add_recieved)
                                     next_state = READ_ADD;
                                 else
                                     next_state = READ_DATA; 
                             end
                             else 
                                 next_state = IDLE;
      WRITE                 : 
                             if (~SS_n) 
                                 next_state = WRITE;
                             else 
                                 next_state = IDLE; 

      READ_ADD              : 
                             if (~SS_n) 
                                 next_state = READ_ADD;
                             else 
                                 next_state = IDLE; 
      READ_DATA             : 
                             if (~SS_n) 
                                 next_state = READ_DATA;
                             else 
                                 next_state = IDLE;

      default               :    next_state = IDLE;                           
    endcase
    
end


always @(posedge clk) begin

    if (~rst_n) begin
         rx_data <= 0;
         MISO <= 0;
         rd_add_recieved <= 0;
         rst_counter2 <= 1;
         rst_counter1 <= 1;
    end
    else
    case (current_state)
     
      IDLE                 : begin 
                              MISO <= 0;
                              rst_counter2 <= 1;
                              rst_counter1 <= 1;
                              PtoS_index = 7;

      end
      
      CHK_CMD              : begin 
                              rst_counter1 <= 0;
      end 
         
      WRITE                 : 
                             if (~SS_n) 
                                 if (~StoP_done)   
                                     rx_data <= {rx_data[8:0], MOSI};
      READ_ADD              : 
                             if (~SS_n) 
                                 if (~StoP_done)  begin
                                     rd_add_recieved <= 1;
                                     rx_data <= {rx_data[8:0], MOSI};
                                 end  
      READ_DATA             : 
                             if (~SS_n) 
                                 if (StoP_done)begin
                                     if (tx_valid) begin
                                         rst_counter2 <= 0;
                                         if (~PtoS_done) begin
                                             MISO <= tx_data[PtoS_index];  
                                             PtoS_index = PtoS_index - 1;
                                         end
                                         else begin
                                             rd_add_recieved <= 0;  
                                         end
                                     end 
                                 end
                                 else 
                                     rx_data <= {rx_data[8:0], MOSI};
      default               : begin 
                              rst_counter2 <= 1;
                              rst_counter1 <= 1;

      end
  
    endcase
    
end

assign rx_valid = ((current_state == WRITE || current_state == READ_ADD || current_state == READ_DATA) && StoP_done)? 1 : 0;

endmodule