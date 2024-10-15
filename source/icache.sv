/*
  Aakash Vadhanam
  avadhana@purdue.edu.com

  icache module
*/

//all types
`include "cpu_types_pkg.vh"
`include "caches_if.vh"

// import types
  import cpu_types_pkg::*;


module icache (input logic CLK, nRST, datapath_cache_if.icache dcif, caches_if.icache cif);


typedef enum logic  
{
    IDLE, ALLOCATE
}state_t;


state_t      state, next_state;
icachef_t    cache_addr;           
icache_frame cache [15:0];                   //16 frames of 4 byte data - 64 byte cache
icache_frame next_cache [15:0];
logic miss;






assign cache_addr = icachef_t'(dcif.imemaddr);       //convert address to cache address format

always_ff @(posedge CLK, negedge nRST)
begin
    if (!nRST)
    begin
        for (integer i = 0; i < 16; i++)
        begin
            cache[i].valid <= 0;
            cache[i].tag   <= 0;
            cache[i].data  <= 0;
        end
        state <= IDLE;
    end
    else
    begin
        cache[cache_addr.idx] <= next_cache[cache_addr.idx];
        state <= next_state;
    end
end


//next state logic
always_comb
begin
    //default
    next_state = state;
    next_cache[cache_addr.idx] = cache[cache_addr.idx];

    //exception logic
    casez (state)

    IDLE:                                                                      //move to compare if only imemREN asserted and not halted
    begin
        if (dcif.imemREN && miss)
        begin
            next_state = ALLOCATE;
        end
    end


    ALLOCATE:                                                         //update cache with tag, valid and data from memory, return to compare once value has been retreived
    begin 
        if (!cif.iwait)                                            //memory access
        begin
            next_cache[cache_addr.idx].tag   = cache_addr.tag;
            next_cache[cache_addr.idx].valid = 1;
            next_cache[cache_addr.idx].data  = cif.iload;
            next_state = IDLE;
        end
    end

    endcase
end


//Output Logic
always_comb
begin
    //default values
    cif.iREN      = 0;
    cif.iaddr     = 0;
    dcif.ihit     = 0;
    dcif.imemload = cache[cache_addr.idx].data;
    miss          = 0;


    //exception logic
    casez (state)

    IDLE:                      //hit logic
    begin
        if ((dcif.imemREN && cache[cache_addr.idx].tag == cache_addr.tag) && cache[cache_addr.idx].valid)
        begin
            dcif.ihit = 1;
        end
        else
        begin
            miss = 1;
        end
    end


    ALLOCATE:                   //enable talking to memory
    begin
        cif.iREN = dcif.imemREN;
        cif.iaddr = dcif.imemaddr;
    end

    endcase

end



endmodule