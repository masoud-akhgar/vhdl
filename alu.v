module ALU(input [31:0] data1,data2,input [3:0] aluoperation,output reg [31:0] result,output reg zero,lt,gt,BranchCond);

  always@(aluoperation,data1,data2)
  begin
    case (aluoperation)
      4'b0000 : result = data1 + data2; // ADD
      4'b0001 : result = data1 - data2; // SUB
      4'b0010 : result = data1 & data2; // AND
      4'b0011 : result = data1 | data2; // OR
      4'b0100 : result = data1 ^ data2; // XOR
      4'b0111 : result = (data1<data2)?32'b1:32'b0;
      4'b0101 : begin //BEQ
        if (data1==data2) begin
          BranchCond = 1;
        end else begin
          BranchCond = 0;
        end
      end
      4'b0110 : begin  //BNE
        if (data1!=data2) begin
          BranchCond = 1;
        end else begin
          BranchCond = 0;
        end
      end
      default : result = data1 + data2; // ADD
    endcase
    $display("Result ALU:%b",result);
    $display("Branch Condition:%b", BranchCond);
    $display("Data:%b, %b",data1,data2);
    $display("operation:%b",aluoperation);
    if(data1>data2)
      begin
       gt = 1'b1;
       lt = 1'b0; 
      end else if(data1<data2)
      begin
       gt = 1'b0;
       lt = 1'b1;  
      end 
      
    if (result==32'd0) zero=1'b1;
    else zero=1'b0;
     $display("gt:%b, lt: %b, Zero:%b", gt,lt,zero);
  end
  

endmodule
