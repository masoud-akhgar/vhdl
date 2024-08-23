module RegFile (clk, readreg1, readreg2, writereg, writedata, RegWrite, readdata1, readdata2);
  input [4:0] readreg1, readreg2, writereg;
  input [31:0] writedata;
  input clk, RegWrite;
  output [31:0] readdata1, readdata2;

  reg[31:0]min,max;

  reg [31:0] regfile [31:0];

  initial begin
    $readmemb("registers.mem", regfile);
  end

  always @(posedge clk)
  begin
    regfile[0]=0;
		  	if (RegWrite) 
	 				regfile[writereg] <= writedata;
          $display("Reg Write:%b", writedata);
  end
  // always @(posedge clk or negedge clk) begin
  //   $display("RegFile: Read Data1:%b , Read Data2:%b",readdata1, readdata2);
  // end
  assign readdata1 = regfile[readreg1];
  assign readdata2 = regfile[readreg2];
endmodule
 