/*
Aakash Vadhanam
control unit source file
9/3/24
*/

//all types
`include "cpu_types_pkg.vh"
`include "control_unit_if.vh"

// import types
  import cpu_types_pkg::*;


module control_unit(control_unit_if.cu cuif);

opcode_t opcode;
logic [6:0] func7;
logic [2:0] func3;



always_comb
begin
  //default values

  //instruction field values
  opcode      = opcode_t'(cuif.instr[6:0]);
  cuif.rs1    = regbits_t'(cuif.instr[19:15]);
  cuif.rs2    = regbits_t'(cuif.instr[24:20]);
  cuif.rd     = regbits_t'(cuif.instr[11:7]);
  func3       = funct3_r_t'(cuif.instr[14:12]);
  func7       = cuif.instr[31:25];
  cuif.imm    = cuif.instr[31:20];


  //control logic signals
  cuif.iREN   = 1'b1;
  cuif.dWEN   = 1'b0;
  cuif.dREN   = 1'b0;
  cuif.regWr  = 1'b0;
  cuif.aluSrc = 1'b0;
  cuif.pcSrc  = 2'b0;
  cuif.rdSel  = 3'b0;         //0: alu_out  1: d_memload  2:JAL or JALR  3: LUI  4:AUIPC
  cuif.shift  = 1'b0;
  cuif.jpSel  = 1'b0;
  cuif.halt   = 1'b0;
  cuif.aluOp  = ALU_ADD;





  // instruction type logic
  casez (opcode)

  RTYPE:
  begin
    //control signals
    cuif.regWr  = 1'b1;         //write to register
    cuif.aluSrc = 1'b0;         //use rs1 and rs2 for alu
    cuif.pcSrc  = 2'b0;         //PC = PC + 4
    cuif.rdSel  = 3'b0;         //take alu_output line
    cuif.shift  = 1'b0;         //use full imm value
    
    //func-specific control signals
    casez (func3)

    ADD_SUB:
    begin
      if (func7 == 7'b0000000)         //ADD INSTRUCTION
      begin
         cuif.aluOp = ALU_ADD;
      end
      else if (func7 == 7'b0100000)    //SUB INSTRUCTION
      begin
        cuif.aluOp = ALU_SUB;
      end
    end

    XOR: 
    begin
      cuif.aluOp = ALU_XOR;
    end

    OR:
    begin
      cuif.aluOp = ALU_OR;
    end

    AND:
    begin
      cuif.aluOp = ALU_AND;
    end

    SLL:
    begin
      cuif.shift = 1'b1;        //use first five bits of second alu input
      cuif.aluOp = ALU_SLL;
    end

    SRL_SRA:
    begin
      cuif.shift = 1'b1;              //use first five bits of second alu input
      if (func7 == 7'b0000000)         //SRL INSTRUCTION
      begin
        cuif.aluOp = ALU_SRL;
      end
      else if (func7 == 7'b0100000)    //SRA INSTRUCTION
      begin
        cuif.aluOp = ALU_SRA;
      end
    end

    SLT:
    begin
      cuif.aluOp = ALU_SLT;
    end

    SLTU:
    begin
      cuif.aluOp = ALU_SLTU;
    end

    endcase

  end

  ITYPE:        //excludes LW and JALR
  begin
    //instruction fields
    func3 = funct3_i_t'(cuif.instr[14:12]);

    //control signals
    cuif.regWr  = 1'b1;         //write to register
    cuif.aluSrc = 1'b1;         //use sign extended imm as second alu input
    cuif.pcSrc  = 2'b0;         //PC = PC + 4
    cuif.rdSel  = 3'b0;         // take alu_output line
    
    //func-specific control signals
    casez (func3)

    ADDI:
    begin
      cuif.aluOp = ALU_ADD;
    end

    XORI: 
    begin
      cuif.aluOp = ALU_XOR;
    end

    ORI:
    begin
      cuif.aluOp = ALU_OR;
    end

    ANDI:
    begin
      cuif.aluOp = ALU_AND;
    end

    SLLI:
    begin 
      cuif.shift = 1'b1;                    //use first five bits of second alu input
      cuif.aluOp = ALU_SLL;
    end

    SRLI_SRAI:
    begin
      cuif.shift = 1'b1;                     //use first five bits of second alu input
      if (cuif.imm[11:5] == 7'b0000000)        //SRLI
      begin
        cuif.aluOp = ALU_SRL;
      end
      else if (cuif.imm[11:5] == 7'b0100000)   //SRAI
      begin
        cuif.aluOp = ALU_SRA;
      end  
    end

    SLTI:
    begin
      cuif.aluOp = ALU_SLT;
    end

    SLTIU:
    begin
      cuif.aluOp = ALU_SLTU;
    end

    endcase

  end

  ITYPE_LW:          //LOAD WORD
  begin
    //control signals
    cuif.regWr  = 1'b1;      //write to register
    cuif.aluSrc = 1'b1;      //use imm as second alu input
    cuif.pcSrc  = 2'b0;      //PC = PC + 4
    cuif.dREN   = 1'b1;      //enable load from memory
    cuif.rdSel  = 3'b1;      //take memory loaded from memory
    cuif.aluOp  = ALU_ADD;   //always add for load
  end

  JALR:            //I-TYPE
  begin
    //control signals
    cuif.regWr  = 1'b1;      //write to register
    cuif.aluSrc = 1'b1;      //use imm as second alu input
    cuif.rdSel  = 3'h2;      //load npc into rd
    cuif.pcSrc  = 2'h2;      //PC = alu output
    cuif.aluOp  = ALU_ADD;   //always add for jalr
  end

  STYPE:           //SW
  begin
    //adjust imm field
    cuif.imm    = {cuif.instr[31:25], cuif.instr[11:7]};

    //control signals
    cuif.regWr  = 1'b0;      //do not write to register
    cuif.aluSrc = 1'b1;      //use imm as second alu input
    //cuif.rdSel = x         //dont care value do to RegWr being 0
    cuif.dWEN   = 1'b1;      //write value to memory
    cuif.pcSrc  = 2'b0;      //PC = PC+4
    cuif.aluOp  = ALU_ADD;   //always add for sw
  end

  BTYPE:        //Branches
  begin
    //instruction fields
    func3 = funct3_b_t'(func3);

    //control signals
    cuif.regWr  = 1'b0;      //do not write to register
    cuif.aluSrc = 1'b0;      //use both register values
    //cuif.rdSel = x         //dont care value due to regWr being 0
    cuif.jpSel = 1'b0;     //use Branch Address

    if (cuif.branch)               //if branch taken
    begin
        cuif.pcSrc = 2'b1;     //PC = branchaddr
    end
    else
    begin
        cuif.pcSrc = 2'b0;     //else pc = pc + 4
    end

    casez (func3) 


    BEQ:
    begin
        cuif.aluOp = ALU_SUB;
    end

    BNE:
    begin
        cuif.aluOp = ALU_SUB;
    end

    BLT:
    begin
        cuif.aluOp = ALU_SLT;
    end

    BGE:
    begin
        cuif.aluOp = ALU_SLT;
    end

    BLTU:
    begin
        cuif.aluOp = ALU_SLTU;
    end

    BGEU:
    begin
        cuif.aluOp = ALU_SLTU;
    end


    endcase
  end

  JAL:      //Jtype
  begin
    //control signals
    cuif.regWr   = 1'b1;               //write to register
    cuif.rdSel   = 3'h2;               //write npc to register
    cuif.jpSel = 1'b1;               //take jumpaddr
    cuif.pcSrc   = 2'b1;               //pc = pc + jumpaddr  
  end

  LUI:      //Utype
  begin
    //control signals
    cuif.regWr  = 1'b1;           //write to register
    cuif.rdSel  = 3'h3;           //write {imm,12'b0} to register
    cuif.pcSrc  = 2'b0;           //pc = pc +4;
  end

  AUIPC:      //Utype
  begin
    //control signals
    cuif.regWr  = 1'b1;           //write to register
    cuif.rdSel  = 3'h4;           //write pc + {imm,12'b0} to register
    cuif.pcSrc  = 2'b0;           //pc = pc +4;
  end

  HALT:
  begin
    cuif.halt = 1'b1;
    cuif.iREN = 1'b0;
  end

  endcase

  
end




endmodule