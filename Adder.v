module Adder(input [31:0] in1, in2, output [31:0] out);
    assign out = in1 + in2;
    always @(*) begin
        $display("Adder for Pc , AdderBranch");
    end
endmodule