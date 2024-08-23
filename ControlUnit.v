module ControlUnit
(input[5:0] opcode,func,
output reg RegDst,Jump,Branch,MemRead,MemReg,AluSrc,RegWrite,MemWrite,
output reg[3:0] AluOp, output reg[4:0] type
);
  always@(opcode,func)begin
    case (opcode)
      6'b000000 :
      begin
      case(func)
      6'b100000: begin // add
      RegDst <= 1; 
      Jump <= 0;
      Branch <= 0;
      MemRead <= 0;
      MemReg <= 0; 
      AluOp <= 4'b0000;
      AluSrc <= 0;
      RegWrite <=1;
      MemWrite <= 0;
      $display("add");
      type = 1;
      end
      6'b100010 : begin //sub
      RegDst <= 1; 
      Jump <= 0;
      Branch <= 0;
      MemRead <= 0;
      MemReg <= 0; 
      AluOp <= 4'b0001;
      AluSrc <= 0;
      RegWrite <=1;
      MemWrite <= 0;
      $display("sub");
      type = 2;
      end
      6'b100101 : begin //or
      RegDst <= 1'b1; 
      Jump <= 0;
      Branch <= 0;
      MemRead <= 0;
      MemReg <= 0; 
      AluOp <= 4'b0011;
      AluSrc <= 0;
      RegWrite <=1;
      MemWrite <= 0;
      $display("or");
      type = 3;
      end
      6'b100100 : begin //and
      RegDst <= 1; 
      Jump <= 0;
      Branch <= 0;
      MemRead <= 0;
      MemReg <= 0; 
      AluOp <= 4'b0010;
      AluSrc <= 0;
      RegWrite <=1;
      MemWrite <= 0;
      type = 4;
       $display("and");
      end  
      6'b101010 : begin  //slt
      RegDst <= 1; 
      Jump <= 0;
      Branch <= 0;
      MemRead <= 0;
      MemReg <= 0; 
      AluOp <= 4'b0111;
      AluSrc <= 0;
      RegWrite <=1;
      MemWrite <= 0;
      type = 5;
      $display("slt");
      end
    endcase
    end
      6'b101011 :begin  //sw
      RegDst <= 1; 
      Jump <= 0;
      Branch <= 0;
      MemRead <= 0;
      MemReg <= 0; 
      AluOp <= 4'b0000;
      AluSrc <= 1;
      RegWrite <=0;
      MemWrite <= 1;
      type = 6;
      $display("sw");
    end
      6'b100011 :begin  //lw
      RegDst <= 0; 
      Jump <= 0;
      Branch <= 0;
      MemWrite <= 0;
      MemRead <= 1;
      MemReg <= 1; 
      AluOp <= 4'b0000;
      AluSrc <= 1;
      RegWrite <= 1; 
      type = 7;  
      $display("lw");  
    end
      6'b001000 :begin  //addi
      RegDst <= 0; 
      Jump <= 0;
      Branch <= 0;
      MemRead <= 0;
      MemReg <= 0; 
      AluOp <= 4'b0000;
      AluSrc <= 1;
      RegWrite <=1;
      MemWrite <= 0;
      type = 8;
      $display("addi");
    end
      6'b001100 :begin  //andi
      RegDst <= 0; 
      Jump <= 0;
      Branch <= 0;
      MemRead <= 0;
      MemReg <= 0; 
      AluOp <= 4'b0010;
      AluSrc <= 1;
      RegWrite <=1;
      MemWrite <= 0;
      type = 9;
      $display("andi");
    end
      6'b001101 :begin  //ori
      RegDst <= 0; 
      Jump <= 0;
      Branch <= 0;
      MemRead <= 0;
      MemReg <= 0; 
      AluOp <= 4'b0011;
      AluSrc <= 1;
      RegWrite <=1;
      MemWrite <= 0;
      type = 10;
      $display("ori");
    end
      6'b000100 :begin  //beq
      RegDst <= 1; 
      Jump <= 0;
      Branch <= 1;
      MemRead <= 0;
      MemReg <= 0; 
      AluOp <= 4'b0101;
      AluSrc <= 0;
      RegWrite <=0;
      MemWrite <= 0;
      type = 11;
      $display("beq");
    end
      6'b000101 :begin  //bne
      RegDst <= 1; 
      Jump <= 0;
      Branch <= 1;
      MemRead <= 0;
      MemReg <= 0; 
      AluOp <= 4'b0110;
      AluSrc <= 0;
      RegWrite <=0;
      MemWrite <= 0;
      type = 12;
      $display("bne");
    end
      6'b001010 :begin  //slti
      RegDst <= 0; 
      Jump <= 0;
      Branch <= 0;
      MemRead <= 0;
      MemReg <= 0; 
      AluOp <= 4'b0111;
      AluSrc <= 1;
      RegWrite <=1;
      MemWrite <= 0;
      type = 13;
      $display("slti");
    end
     6'b000010:begin  //j
      RegDst <= 1; 
      Jump <= 1;
      Branch <= 0;
      MemRead <= 0;
      MemReg <= 0; 
      AluOp <= 4'b0110;
      AluSrc <= 1;
      RegWrite <=0;
      MemWrite <= 0;
      type = 14;
      $display("j");
    end
    endcase
    end
endmodule










