module Mux
(
	output reg [31:0] out,
	input select,
	input [31:0] in1,
	input [31:0] in2
);

always @ (*) begin

if (select == 1'b0)
	out = in1;
else	
	out = in2;
	
$display("MUX");
end


endmodule
