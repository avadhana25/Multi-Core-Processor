`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// import types
  import cpu_types_pkg::*;

module dcache
(
    input logic CLK, n_rst,
    datapath_cache_if.dcache dcif, 
    caches_if.dcache cif
);

typedef enum logic [3:0] {IDLE, STORE1_STORE_ONE, STORE1_STORE_TWO, STORE2_STORE_ONE, STORE2_STORE_TWO, MEMORY_ONE, LOAD_ONE, MEMORY_TWO, LOAD_TWO, UPDATE} state_t;

dcache_frame [15:0] data_store1;
dcache_frame [15:0] data_store2;
dcache_frame [15:0] next_data_store1;
dcache_frame [15:0] next_data_store2;
dcachef_t cache_addr;
logic [15:0] LRU_tracker, next_LRU_tracker;
logic miss;
state_t state, next_state;



always_ff @(posedge CLK, negedge n_rst) begin
    if(!n_rst) begin
        state <= IDLE;
        LRU_tracker <= '0;
        for(int i = 0; i < 16; i++) begin
            data_store1[i] <= '0;
            data_store2[i] <= '0;
        end
    end
    else begin
        state <= next_state;
        LRU_tracker <= next_LRU_tracker;
        for(int i = 0; i < 16; i++) begin
            data_store1[i] <= next_data_store1[i];
            data_store2[i] <= next_data_store2[i];
        end
    end
end

assign cache_addr = dcachef_t'(dcif.dmemaddr);

always_comb begin : next_state_logic
    next_state = state;
    casez(state) 
        IDLE : begin
            if(miss == 1'b1 && data_store1[cache_addr.idx].dirty == 1'b1) begin
                next_state = STORE1_STORE_ONE;
            end
            else if(miss == 1'b1 && data_store2[cache_addr.idx].dirty == 1'b1) begin
                next_state = STORE2_STORE_ONE;
            end
            else if(miss == 1'b1) begin
                next_state = MEMORY_ONE;
            end
        end
        STORE1_STORE_ONE : begin
            if(cif.dwait == 1'b0) begin
                next_state = STORE1_STORE_TWO;
            end
        end
        STORE1_STORE_TWO : begin
            if(cif.dwait == 1'b0) begin
                next_state = MEMORY_ONE;
            end
        end
        STORE2_STORE_ONE : begin
            if(cif.dwait == 1'b0) begin
                next_state = STORE2_STORE_TWO;
            end
        end
        STORE2_STORE_TWO : begin
            if(cif.dwait == 1'b0) begin
                next_state = MEMORY_ONE;
            end
        end
        MEMORY_ONE : begin
            if(cif.dwait == 1'b0) begin
                next_state = LOAD_ONE;
            end
        end
        LOAD_ONE : begin
            next_state = MEMORY_TWO;
        end
        MEMORY_TWO : begin
            if(cif.dwait == 1'b0) begin
                next_state = LOAD_TWO;
            end
        end
        LOAD_TWO : begin
            if(dcif.dmemREN) begin
                next_state = IDLE;
            end
            else if(dcif.dmemWEN) begin
                next_state = UPDATE;
            end
        end
        UPDATE : begin
            next_state = IDLE;
        end
    endcase
end

always_comb begin : output_logic
    //memory controller outputs
    cif.dREN = '0;
    cif.daddr = '0;
    cif.dWEN = '0;
    cif.dstore = '0;

    //new cache values
    next_data_store1 = data_store1;
    next_data_store2 = data_store2;

    //hit/miss outputs
    dcif.dhit = '0;
    miss = '0;
    dcif.dmemload = '0;
    next_LRU_tracker = LRU_tracker;

    casez(state) 
        IDLE : begin
            if(dcif.halt == 1'b1) begin
                for(int i = 0; i < 16; i++) begin
                    next_data_store1[i].valid = 1'b0;
                    next_data_store2[i].valid = 1'b0;
                end
            end
            else if(dcif.dmemREN == 1'b1 && data_store1[cache_addr.idx].tag == cache_addr.tag && data_store1[cache_addr.idx].valid == 1'b1) begin
                dcif.dhit = 1'b1;
                dcif.dmemload = data_store1[cache_addr.idx].data[cache_addr.blkoff];
                next_LRU_tracker[cache_addr.idx] = 1'b0;
            end
            else if(dcif.dmemREN == 1'b1 && data_store2[cache_addr.idx].tag == cache_addr.tag && data_store2[cache_addr.idx].valid == 1'b1) begin
                dcif.dhit = 1'b1;
                dcif.dmemload = data_store2[cache_addr.idx].data[cache_addr.blkoff];
                next_LRU_tracker[cache_addr.idx] = 1'b1;
            end
            else if(dcif.dmemWEN == 1'b1 && data_store1[cache_addr.idx].tag == cache_addr.tag && data_store1[cache_addr.idx].valid == 1'b1) begin
                dcif.dhit = 1'b1;
                next_data_store1[cache_addr.idx].valid = 1'b1;
                next_data_store1[cache_addr.idx].dirty = 1'b1;
                next_data_store1[cache_addr.idx].tag = cache_addr.idx;
                next_data_store1[cache_addr.idx].data[cache_addr.blkoff] = dcif.dmemstore;
                next_LRU_tracker[cache_addr.idx] = 1'b0;
            end
            else if (dcif.dmemWEN == 1'b1 && data_store2[cache_addr.idx].tag == cache_addr.tag && data_store2[cache_addr.idx].valid == 1'b1) begin
                dcif.dhit = 1'b1;
                next_data_store2[cache_addr.idx].valid = 1'b1;
                next_data_store2[cache_addr.idx].dirty = 1'b1;
                next_data_store2[cache_addr.idx].tag = cache_addr.idx;
                next_data_store2[cache_addr.idx].data[cache_addr.blkoff] = dcif.dmemstore;
                next_LRU_tracker[cache_addr.idx] = 1'b1;
            end
            else if(dcif.dmemREN == 1'b1 || dcif.dmemWEN == 1'b1) begin
                miss = 1'b1;
            end
        end
        STORE1_STORE_ONE : begin
            cif.dWEN = 1'b1;
            cif.daddr = dcif.dmemaddr;
            cif.dstore = data_store1[cache_addr.idx].data[0];
        end
        STORE1_STORE_TWO : begin
            cif.dWEN = 1'b1;
            cif.daddr = dcif.dmemaddr + 4;
            cif.dstore = data_store1[cache_addr.idx].data[1];
        end
        STORE2_STORE_ONE : begin
            cif.dWEN = 1'b1;
            cif.daddr = dcif.dmemaddr;
            cif.dstore = data_store2[cache_addr.idx].data[0];
        end
        STORE2_STORE_TWO : begin
            cif.dWEN = 1'b1;
            cif.daddr = dcif.dmemaddr;
            cif.dstore = data_store2[cache_addr.idx].data[1];
        end
        MEMORY_ONE : begin
            cif.dREN = 1'b1;
            cif.daddr = dcif.dmemaddr;
        end
        LOAD_ONE : begin
            if(LRU_tracker[cache_addr.idx] == 1'b1) begin
                next_data_store1[cache_addr.idx].valid = 1'b0;
                next_data_store1[cache_addr.idx].dirty = 1'b0;
                next_data_store1[cache_addr.idx].tag = cache_addr.tag;
                next_data_store1[cache_addr.idx].data[0] = cif.dload;
            end
            else begin
                next_data_store2[cache_addr.idx].valid = 1'b0;
                next_data_store2[cache_addr.idx].dirty = 1'b0;
                next_data_store2[cache_addr.idx].tag = cache_addr.tag;
                next_data_store2[cache_addr.idx].data[0] = cif.dload;
            end
        end
        MEMORY_TWO : begin
            cif.dREN = 1'b1;
            cif.daddr = dcif.dmemaddr + 4;
        end
        LOAD_TWO : begin
            if(LRU_tracker[cache_addr.idx] == 1'b1) begin
                next_data_store1[cache_addr.idx].valid = 1'b1;
                next_data_store1[cache_addr.idx].dirty = 1'b0;
                next_data_store1[cache_addr.idx].tag = cache_addr.tag;
                next_data_store1[cache_addr.idx].data[1] = cif.dload;
            end
            else begin
                next_data_store2[cache_addr.idx].valid = 1'b1;
                next_data_store2[cache_addr.idx].dirty = 1'b0;
                next_data_store2[cache_addr.idx].tag = cache_addr.tag;
                next_data_store2[cache_addr.idx].data[1] = cif.dload;
            end
        end
        UPDATE : begin
            if(LRU_tracker[cache_addr.idx] == 1'b1) begin
                next_data_store1[cache_addr.idx].valid = 1'b1;
                next_data_store1[cache_addr.idx].dirty = 1'b1;
                next_data_store1[cache_addr.idx].tag = cache_addr.tag;
                next_data_store1[cache_addr.idx].data[cache_addr.blkoff] = dcif.dmemstore;
            end
            else begin
                next_data_store2[cache_addr.idx].valid = 1'b1;
                next_data_store2[cache_addr.idx].dirty = 1'b1;
                next_data_store2[cache_addr.idx].tag = cache_addr.tag;
                next_data_store2[cache_addr.idx].data[cache_addr.blkoff] = dcif.dmemstore;
            end
        end
    endcase
end

endmodule