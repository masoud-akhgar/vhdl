//memory unit
module IMemBank(input memread, input [31:0] address, output reg [31:0] readdata);
 
  reg [31:0] mem_array [255:0];
  
  initial begin
    $readmemb("instruction.mem", mem_array);
  end
 
  always@(memread, address, mem_array[address])
  begin
    if(memread)begin
      readdata=mem_array[address>>>2];
      $display("Instruction:%b",readdata);
    end
  end

endmodule

