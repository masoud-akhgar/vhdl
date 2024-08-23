//memory unit
module DMemBank(input memread, input memwrite, input [31:0] address, input [31:0] writedata, output reg [31:0] readdata);
 
reg [31:0] mem_array [255:0];
  
  initial begin
    $readmemb("data.mem", mem_array);
  end
 
  always@(memread, memwrite, address, mem_array[address], writedata)
  begin
    if(memread)begin
      readdata=mem_array[address>>>2];
      $display("Read Data in Data Mem:%b",readdata);
    end

    else if(memwrite)
    begin
      mem_array[address>>>2]= writedata;
      $display("Write Data in Data Mem:%b", writedata);
    end

  end

endmodule

