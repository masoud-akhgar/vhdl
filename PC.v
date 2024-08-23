module PC(
    input enable,clk,
    input[31:0] in,
    output reg[31:0] out
);
    initial begin
      out = 32'd0;
    end
    always@(clk)begin
      $display("Next PC:%b", in);
      if(enable==1)
        out = in;
    end

endmodule