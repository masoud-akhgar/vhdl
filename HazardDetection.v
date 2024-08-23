module Cre(input[31:0]IR,output reg re1, re2);

always @(*) begin
    case (IR[31:26])
        6'b000000: begin //R-Type
          re1 = 1;
          re2 = 1;
        end
        6'b001000,6'b001100,6'b001101,6'b001010: begin //addi, andi, ori, slti
          re1 = 1;
          re2 = 0;
        end
        6'b100011, 6'b101011: begin //lw, sw
          re1 = 1;
          re2 = 0;
        end
        6'b000010: begin //j
          re1 = 0;
          re2 = 0;
        end 
        6'b000100, 6'b000101: begin  //beq, bne
          re1 = 1;
          re2 = 0;
        end
    endcase
$display("Cre %b, %b", re1,re2);
end

endmodule

module Cdest(input[31:0]IR, output reg[4:0] WS, output reg WE);

always @(*) begin
    case (IR[31:26])
        6'b000000:begin //R-Type
            WE = 1;
            WS = IR[15:11];
        end 
        6'b001000,6'b001100,6'b001101,6'b001010,6'b100011: begin //addi, andi, ori, slti, lw
          WE = 1;
          WS = IR[20:16];
        end 
        6'b000010, 6'b000100, 6'b000101, 6'b101011: begin //j, beq, bne, sw
          WE = 0;
        end
    endcase
    $display("Cdest %b, %b", WE,WS);
end
endmodule
module HazardUnit(input[31:0] IF_ID, ID_EX,
input[4:0] WsEX, WsMEM, rs, rt,
input WeEX, WeMEM, re1, re2, BranchCond,
output reg PcEnable, IF_ID_En, ControlSelect, InstructionSelect, Plus_ControlFlow, Branch_notJump);

initial begin
  ControlSelect = 0;
  InstructionSelect = 0;
  Plus_ControlFlow = 0;
  Branch_notJump = 0;
end

always @(*) begin
  if ((ID_EX[31:26] == 6'b000100 || ID_EX[31:26] == 6'b000101) && BranchCond == 1) begin //beq, bne
    ControlSelect = 1;
    InstructionSelect = 1;
    Plus_ControlFlow = 1;
    Branch_notJump = 1;
    $display("HazardUnit");
  end else if(IF_ID[31:26] == 6'b000010) begin //j
    ControlSelect = 0;
    InstructionSelect = 1;
    Plus_ControlFlow = 1;
    Branch_notJump = 0;
    $display("HazardUnit");
  end else begin
    ControlSelect = 0;
    InstructionSelect = 0;
    Plus_ControlFlow = 0;
    Branch_notJump = 0;
  end
  if ((((rs == WsEX) && re1 && WeEX) || ((rt == WsEX) && re2 && WeEX)) && ID_EX[31:26] == 6'b100011 && rt!=0) begin //lw
    PcEnable = 0;
    IF_ID_En = 0;
    ControlSelect = 1;
    $display("HazardUnit");
  end else begin
    PcEnable = 1;
    IF_ID_En = 1;
    ControlSelect = 0;
  end
  
end



endmodule