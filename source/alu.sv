/*
Aakash Vadhanam
alu source file
8/26/24
*/

//all types
`include "cpu_types_pkg.vh"

// import types
  import cpu_types_pkg::*;


module alu(alu_if.alu alu);

//LOGIC
always_comb
begin
    //default values
    alu.port_out = '0;
    alu.negative = 0;
    alu.overflow = 0;
    alu.zero     = 0;

    //ALU LOGIC
    casez (alu.ALUOP)

        //ADD LOGIC
        ALU_ADD: 
        begin
            alu.port_out = $signed(alu.port_a) + $signed(alu.port_b);
            //OVERFLOW LOGIC
            if ((alu.port_a[31] == alu.port_b[31]) && (alu.port_a[31] != alu.port_out[31]))    //pos+pos = neg or neg+neg = pos
            begin
                alu.overflow = 1'b0;
            end
        end

        //SUB LOGIC
        ALU_SUB:
        begin
            alu.port_out = $signed(alu.port_a) - $signed(alu.port_b);
            //OVERFLOW LOGIC
            if ((alu.port_a[31] != alu.port_b[31]) && (alu.port_a[31] != alu.port_out[31]))     //pos-neg = neg or neg-pos = pos
            begin
                alu.overflow = 1'b0;
            end
        end

        //SHIFT LOGIC LEFT LOGIC
        ALU_SLL:
        begin
            alu.port_out = alu.port_a << alu.port_b;
        end

        //SHIFT LOGIC RIGHT LOGIC
        ALU_SRL:
        begin
            alu.port_out = alu.port_a >> alu.port_b;
        end

        //SHIFT ARITHMETIC RIGHT LOGIC
        ALU_SRA:
        begin
            alu.port_out = $signed(alu.port_a) >>> alu.port_b;
        end

        //AND LOGIC
        ALU_AND:
        begin
            alu.port_out = alu.port_a & alu.port_b;
        end

        //OR LOGIC 
        ALU_OR:
        begin
            alu.port_out = alu.port_a | alu.port_b;
        end

        //XOR LOGIC
        ALU_XOR:
        begin
            alu.port_out = alu.port_a ^ alu.port_b;
        end

        //LESS THAN SIGNED LOGIC
        ALU_SLT:
        begin
            alu.port_out = $signed(alu.port_a) < $signed(alu.port_b);
        end

        //LESS THAN UNSIGNED LOGIC
        ALU_SLTU:
        begin
            alu.port_out = alu.port_a < alu.port_b;
        end 
    endcase
    

    //NEGATIVE LOGIC
    if (alu.port_out[31] == 1)
    begin
        alu.negative = 1'b1;
    end
    
    //ZERO LOGIC
    if (alu.port_out == 0)
    begin
        alu.zero = 1'b1;
    end
end

endmodule