/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control ( 
  input logic CLK, nRST, cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;

  typedef enum logic [3:0] 
  {
    IDLE, INSTRUCTION, STORE_1, STORE_2, LOAD_1, LOAD_2, ARBITRATE, SNOOP, CACHE_1, CACHE_2
  }state_t;

  state_t state, next_state;
  logic cpu_lru, next_cpu_lru;
  logic snooper, next_snooper, snoopy, next_snoopy;


  always_ff @(posedge CLK, negedge nRST)
  begin
    if (!nRST)
    begin
      state <= IDLE;
      cpu_lru <= 0;
      snooper <= 0;
      snoopy <= 1;
    end
    else
    begin
      state <= next_state;
      cpu_lru <= next_cpu_lru;
      snooper <= next_snooper;
      snoopy <= next_snoopy;
    end
  end

  //next state logic
  always_comb
  begin
    //default
    next_state = state;
    next_snooper = snooper;
    next_snoopy = snoopy;

    //state logic
    casez (state)

    IDLE:
    begin
      if (ccif.dWEN[0] || ccif.dWEN[1])
      begin
        next_state = STORE_1;
      end
      else if (ccif.cctrans[0] || ccif.cctrans[1])          //msi transition
      begin
        next_state = ARBITRATE;
      end
      else if (ccif.iREN[0] || ccif.iREN[1])
      begin
        next_state = INSTRUCTION;
      end
    end

    INSTRUCTION:
    begin
      if (ccif.ramstate == ACCESS)
      begin
        next_state = IDLE;
      end
    end 

    STORE_1:
    begin
      if (ccif.ramstate == ACCESS)
      begin
        next_state = STORE_2;
      end
    end

    STORE_2:
    begin
      if (ccif.ramstate == ACCESS)
      begin
        next_state = IDLE;
      end
    end

    ARBITRATE:
    begin
      if (ccif.dREN[cpu_lru])
      begin
        next_state = SNOOP;
        next_snooper = cpu_lru;
        next_snoopy = ~cpu_lru;
      end
      else if (ccif.dREN[~cpu_lru])
      begin
        next_state = SNOOP;
        next_snooper = ~cpu_lru;
        next_snoopy = cpu_lru;
      end
      else
      begin
        next_state = IDLE;           //if msi transitioned but neither reads are on / not sure if it will ever happen but good safety blanket to prevent it being stuck
      end
    end

    SNOOP:
    begin
      if (ccif.cctrans[snoopy])         //if other cpu transitions then it was found (other than I to S Causing S to S, but cpu will just get from memory
      begin
        next_state = CACHE_1;
      end
      else
      begin
        next_state = LOAD_1;
      end
    end

    CACHE_1:
    begin
      if (ccif.ramstate == ACCESS)
      begin
        next_state = CACHE_2;
      end
    end

    CACHE_2:
    begin
      if (ccif.ramstate == ACCESS)
      begin
        next_state = IDLE;
      end
    end

    LOAD_1:
    begin
      if (ccif.ramstate == ACCESS)
      begin
        next_state = LOAD_2;
      end
    end

    LOAD_2:
    begin
      if (ccif.ramstate == ACCESS)
      begin
        next_state = IDLE;
      end
    end

    endcase

  end



  //Output logic
  always_comb
  begin
    //default values
    ccif.iwait[0]  = 1'b1;
    ccif.iwait[1] = 1'b1;
    ccif.dwait[0] = 1'b1;
    ccif.dwait[1] = 1'b1;
    ccif.iload[0] = 32'b0;
    ccif.iload[1] = 32'b0;
    ccif.dload[0] = 32'b0;
    ccif.dload[1] = 32'b0;
    ccif.ramstore = 32'b0;
    ccif.ramaddr = 32'b0;
    ccif.ramWEN = 1'b0;
    ccif.ramREN = 1'b0;
    ccif.ccwait[0] = 1'b0;
    ccif.ccwait[1] = 1'b0;
    ccif.ccinv[0]  = 1'b0;
    ccif.ccinv[1]  = 1'b0;
    ccif.ccsnoopaddr[0] = 32'b0;
    ccif.ccsnoopaddr[1] = 32'b0;
    next_cpu_lru = cpu_lru;

    //EXCEPTION Logic

    casez(state)

    IDLE:
    begin
      //nothing
    end

    INSTRUCTION:
    begin
      if (ccif.iREN[cpu_lru])
      begin
        ccif.ramREN = ccif.iREN[cpu_lru];
        ccif.ramaddr = ccif.iaddr[cpu_lru];
        ccif.iload[cpu_lru] = ccif.ramload;
        if (ccif.ramstate == ACCESS)
        begin
          ccif.iwait[cpu_lru] = 1'b0;
          next_cpu_lru = ~cpu_lru;
        end
      end
      else if (ccif.iREN[~cpu_lru])
      begin
        ccif.ramREN = ccif.iREN[~cpu_lru];
        ccif.ramaddr = ccif.iaddr[~cpu_lru];
        ccif.iload[~cpu_lru] = ccif.ramload;
        if (ccif.ramstate == ACCESS)
        begin
          ccif.iwait[~cpu_lru] = 1'b0;
          next_cpu_lru = cpu_lru;
        end
      end
    end

    STORE_1:
    begin
      if (ccif.dWEN[cpu_lru])
      begin
        ccif.ramWEN = ccif.dWEN[cpu_lru];
        ccif.ramaddr = ccif.daddr[cpu_lru];
        ccif.ramstore = ccif.dstore[cpu_lru];
        //thought about stalling other cpu here but dont think its necessary bc it has to wait for this to complete anyways
        if (ccif.ramstate == ACCESS)
        begin
          ccif.dwait[cpu_lru] = 1'b0;
          next_cpu_lru = ~cpu_lru;
        end
      end
      else if (ccif.dWEN[~cpu_lru])
      begin
        ccif.ramWEN = ccif.dWEN[~cpu_lru];
        ccif.ramaddr = ccif.daddr[~cpu_lru];
        ccif.ramstore = ccif.dstore[~cpu_lru];
        if (ccif.ramstate == ACCESS)
        begin
          ccif.dwait[~cpu_lru] = 1'b0;
          next_cpu_lru = cpu_lru;
        end
      end
    end

    STORE_2:
    begin
      if (ccif.dWEN[cpu_lru])
      begin
        ccif.ramWEN = ccif.dWEN[cpu_lru];
        ccif.ramaddr = ccif.daddr[cpu_lru];
        ccif.ramstore = ccif.dstore[cpu_lru];
        //thought about stalling other cpu here but dont think its necessary bc it has to wait for this to complete anyways
        if (ccif.ramstate == ACCESS)
        begin
          ccif.dwait[cpu_lru] = 1'b0;
          next_cpu_lru = ~cpu_lru;
        end
      end
      else if (ccif.dWEN[~cpu_lru])
      begin
        ccif.ramWEN = ccif.dWEN[~cpu_lru];
        ccif.ramaddr = ccif.daddr[~cpu_lru];
        ccif.ramstore = ccif.dstore[~cpu_lru];
        if (ccif.ramstate == ACCESS)
        begin
          ccif.dwait[~cpu_lru] = 1'b0;
          next_cpu_lru = cpu_lru;
        end
      end
    end

    ARBITRATE:
    begin
      if (ccif.dREN[cpu_lru])
      begin
        ccif.ccwait[cpu_lru] = 1'b1;            //snooper cpu stalls until reply
        next_cpu_lru = ~cpu_lru;
      end
      else if (ccif.dREN[~cpu_lru])
      begin
        ccif.ccwait[~cpu_lru] = 1'b1;
        next_cpu_lru = cpu_lru;
      end
    end

    SNOOP:
    begin
      ccif.ccwait[snooper] = 1'b1; 
      ccif.ccsnoopaddr[snoopy] = ccif.daddr[snooper];          //check address in other cpu
    end

    CACHE_1:
    begin
      ccif.ccwait[snooper] = 1'b1;
      ccif.ccsnoopaddr[snoopy] = ccif.daddr[snooper];
      ccif.dload[snooper] = ccif.dstore[snoopy];         //cpu snooped into sends data to requestor
      ccif.ccinv[snoopy] = ccif.ccwrite[snooper];        //if snooper is writing, then invalidate senders block
      //question: when will we get here when ccwrite is not active if snoopy needs an msi transition to get here? I to S causes S to S. should there be an exception case? ask TA

      ccif.ramWEN = 1'b1;
      ccif.ramaddr = ccif.daddr[snoopy];            //can it also just be daddr[snooper]?
      ccif.ramstore = ccif.dstore[snoopy];
      if (ccif.ramstate == ACCESS)
      begin
        ccif.dwait[snooper] = 1'b0;
        ccif.dwait[snoopy]  = 1'b0;
      end
    end

    CACHE_2:
    begin
      ccif.ccwait[snooper] = 1'b1;
      ccif.ccsnoopaddr[snoopy] = ccif.daddr[snooper];
      ccif.dload[snooper] = ccif.dstore[snoopy];         //cpu snooped into sends data to requestor
      ccif.ccinv[snoopy] = ccif.ccwrite[snooper];        //if snooper is writing, then invalidate senders block
      //question: when will we get here when ccwrite is not active if snoopy needs an msi transition to get here? I to S causes S to S. should there be an exception case? ask TA

      ccif.ramWEN = 1'b1;
      ccif.ramaddr = ccif.daddr[snoopy];            //can it also just be daddr[snooper]?
      ccif.ramstore = ccif.dstore[snoopy];
      if (ccif.ramstate == ACCESS)
      begin
        ccif.dwait[snooper] = 1'b0;
        ccif.dwait[snoopy]  = 1'b0;
      end
    end

    LOAD_1:
    begin
      ccif.ccwait[snooper] = 1'b1;
      ccif.ramREN = 1'b1;
      ccif.ramaddr = ccif.daddr[snooper];
      ccif.dload[snooper] = ccif.ramload;
      if (ccif.ramstate == ACCESS)
      begin
        ccif.dwait[snooper] = 1'b0;
      end
    end

    LOAD_2:
    begin
      ccif.ccwait[snooper] = 1'b1;
      ccif.ramREN = 1'b1;
      ccif.ramaddr = ccif.daddr[snooper];
      ccif.dload[snooper] = ccif.ramload;
      if (ccif.ramstate == ACCESS)
      begin
        ccif.dwait[snooper] = 1'b0;
      end
    end




    endcase


  end

/*

  //dwait logic
  always_comb
  begin
    //default value
    ccif.dwait = 1'b1;

    //logic
    if ((ccif.dREN || ccif.dWEN) && (ccif.ramstate == ACCESS))
    begin
      ccif.dwait = 1'b0;
    end
  end

  //iwait logic
  always_comb
  begin
    //default value
    ccif.iwait = 1'b1;

    //logic
    if ((!(ccif.dREN || ccif.dWEN)) && (ccif.ramstate == ACCESS))
    begin
      ccif.iwait = 1'b0;
    end
  end

  //ramREN logic
  assign ccif.ramREN = ~ccif.dWEN;

  //ramWEN logic
  assign ccif.ramWEN = ccif.dWEN;

  //ramstore logic
  assign ccif.ramstore = ccif.dstore;

  //iload logic
  assign ccif.iload = ccif.dREN ? 32'b0 : ccif.ramload;

  //dload logic
  assign ccif.dload = ccif.dREN ? ccif.ramload : 32'b0;

  //ramaddr logic
  assign ccif.ramaddr = (ccif.dREN || ccif.dWEN) ? ccif.daddr : ccif.iaddr;
*/

endmodule
