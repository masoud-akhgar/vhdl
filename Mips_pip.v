
module Pipeline(input clk);
wire [31:0] instruction;
wire [31:0] ReadData1;
wire [31:0] ReadData2;
wire [31:0] ALUResult;
wire [31:0] ReadDataMem;
wire [31:0] NextPcAddress;
wire [31:0] BranchAddress;
wire re1,re2,we1,we2,we3;
wire [4:0]ws1,ws2,ws3;
wire RegDst,Jump,Branch,MemRead,MemToReg,ALUSrc,RegWrite,MemWrite,zero,lt,gt,BranchCond;
reg RegWrite_WB, RegDst_WB,MemRead_MEM,MemWrite_MEM, MemToReg_WB,ALUSrc_EX;
wire [3:0] Aluop;
reg[3:0] Aluop_EX;
wire [4:0] TypeOfInstruction;
wire[31:0] Mux_branchORjump;
wire[31:0] Mux_plusORcontrolflow;
wire [31:0] SignE;
wire [31:0] ShiftLeftOut;
wire [31:0] MuxSrc;

wire PcEnable;
wire IF_ID_En;
wire ControlSelect;
wire InstructionSelect;
wire Plus_ControlFlow, Branch_notJump;
wire [1:0] SelectorA;
wire [1:0] SelectorB;
wire [31:0] outPC;
wire [31:0] IF_ID_instructionOut;
wire [31:0] JumpAddress;
wire [4:0]  MuxDst_WB;
wire [31:0] MuxMemReg_WB;

reg [31:0] ID_EX_A;
reg [31:0] ID_EX_B;
reg [31:0] EX_MEM_B;                     
reg [31:0] IF_EX_instruction;
reg [31:0] EX_MEM_instruction;
reg [31:0] MEM_WB_instruction;
reg [31:0] NextPc_IF_ID;
reg [31:0] NextPc_ID_EX;
reg [31:0] NextPc_EX_MEM;
reg [31:0] EX_MEM_ALURes;
reg [31:0] MEM_WB_MUX;

wire [31:0] MUX_WB_RegData;

Mux branchORjump(Mux_branchORjump, Branch_notJump, JumpAddress, BranchAddress);

Mux plusORcontrolflow(Mux_plusORcontrolflow,Plus_ControlFlow,NextPcAddress,Mux_branchORjump);

PC pc(PcEnable,clk,Mux_plusORcontrolflow ,outPC);

Adder nextPC(outPC, 4 ,NextPcAddress);

IMemBank instructionMem(1'b1,outPC,instruction);

MidReg IF_IDinstruction(IF_ID_En,clk,InstructionSelect?32'd32:instruction,IF_ID_instructionOut);

assign JumpAddress = {  NextPc_IF_ID[31:28] ,(IF_ID_instructionOut[25:0]<<<2) }  ;

initial begin
  #20
    IF_EX_instruction = 32'dz;
    EX_MEM_instruction = 32'dz;
    MEM_WB_instruction = 32'dz;   
end


ControlUnit controlunit(IF_ID_instructionOut[31:26], IF_ID_instructionOut[5:0],RegDst,Jump,Branch,MemRead,MemToReg,ALUSrc,RegWrite,MemWrite,
Aluop, TypeOfInstruction);


RegFile registerFile(clk,IF_ID_instructionOut[25:21],IF_ID_instructionOut[20:16], MuxDst_WB, MUX_WB_RegData ,RegWrite_WB,ReadData1,ReadData2);


// Hazard Detection
Cre cre(IF_ID_instructionOut,re1,re2);
Cdest cdest1(IF_EX_instruction,ws1,we1);
Cdest cdest2(EX_MEM_instruction,ws2,we2);
HazardUnit hazardunit(IF_ID_instructionOut,IF_EX_instruction,ws1,ws2,IF_ID_instructionOut[25:21],IF_ID_instructionOut[20:16] ,we1,we2,re1,re2,BranchCond,PcEnable,IF_ID_En,ControlSelect,InstructionSelect,Plus_ControlFlow, Branch_notJump);

//Forward WB
assign ws3 = (RegDst_WB?MEM_WB_instruction[15:11]:MEM_WB_instruction[20:16]);
assign we3 = RegWrite_WB;


ForwardUnit forwardunit(ws1,ws2,ws3,IF_ID_instructionOut[25:21],IF_ID_instructionOut[20:16],we1,we2,we3,re1,re2,SelectorA,SelectorB);



SignExtend signextend(IF_EX_instruction[15:0],SignE);

ShiftLeft2 shiftleft2(SignE,ShiftLeftOut);

Adder adderBranch(NextPc_ID_EX,ShiftLeftOut, BranchAddress);


// Mux MuxALUSrc(MuxSrc,ALUSrc, SignE,ReadData2);

ALU alu(ID_EX_A,(ALUSrc_EX?32'(signed'(IF_EX_instruction[15:0])):ID_EX_B),Aluop_EX,ALUResult,zero,lt,gtl,BranchCond);

DMemBank DMem(MemRead_MEM,MemWrite_MEM,EX_MEM_ALURes,EX_MEM_B,ReadDataMem);




 


 assign MUX_WB_RegData = ( MemToReg_WB?(ReadDataMem) : (EX_MEM_ALURes) ) ;

//Mux_RegDst MuxRegDst(MuxDst_WB, RegDst,IF_ID_instructionOut[15:11],IF_ID_instructionOut[20:16]);

//Mux MuxMemToReg(MuxMemReg_WB, MemToReg, ReadDataMem,EX_MEM_ALURes);

always@(clk)
begin

    //  Fetch
      NextPc_IF_ID <= NextPcAddress;
    //

    //Decode
      NextPc_ID_EX <= NextPc_IF_ID;

      Aluop_EX <= Aluop;
      MemRead_MEM <= MemRead;
      MemWrite_MEM <= MemWrite;
      RegWrite_WB <=RegWrite;
      RegDst_WB <= RegDst;
      MemToReg_WB <= MemToReg;
      ALUSrc_EX <= ALUSrc;
      ID_EX_A <= SelectorA[1]? ( SelectorA[0]?(MEM_WB_MUX) : (MUX_WB_RegData) ) : ( SelectorA[0]?(ALUResult) : (ReadData1) ) ;
      ID_EX_B <= SelectorB[1]? ( SelectorB[0]?(MEM_WB_MUX) : (MUX_WB_RegData) ) : ( SelectorB[0]?(ALUResult) : (ReadData2) ) ;
      IF_EX_instruction <= IF_ID_instructionOut;
      $display("EX a:%b, b:%b",ID_EX_A,ID_EX_B);

    //Execute
      NextPc_EX_MEM <= NextPc_ID_EX;
      EX_MEM_ALURes <= ALUResult;
      EX_MEM_instruction <= IF_EX_instruction;
      EX_MEM_B <= ID_EX_B;

    // MEM
      MEM_WB_MUX <= MUX_WB_RegData;
      MEM_WB_instruction <= EX_MEM_instruction;
end


endmodule