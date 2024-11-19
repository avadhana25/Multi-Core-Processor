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

typedef enum logic [4:0] {IDLE, HIT_INVALIDATE, SNOOP, CACHE_1, CACHE_2, STORE1_STORE_ONE, STORE1_STORE_TWO, STORE2_STORE_ONE, STORE2_STORE_TWO, MEMORY_ONE, MEMORY_TWO, DIRTY_CHECK, STORE1_FLUSH_ONE, STORE1_FLUSH_TWO, STORE2_FLUSH_ONE, STORE2_FLUSH_TWO, DONE} state_t;
//reservation frame
  typedef struct packed {
	logic valid;
	logic [7:0] addr;
  } reserve_frame;
dcache_frame [7:0] data_store1;
dcache_frame [7:0] data_store2;
reserve_frame  reserve;          
dcache_frame [7:0] next_data_store1;
dcache_frame [7:0] next_data_store2;
reserve_frame  next_reserve;
dcachef_t cache_addr, snoop_addr;
logic [7:0] LRU_tracker, next_LRU_tracker;
logic miss, real_hit, next_real_hit;
state_t state, next_state;
word_t hit_counter, next_hit_counter;
logic [2:0] index, next_index;
logic next_dREN, next_dWEN;
word_t next_dstore, next_daddr;
logic invalidated, next_invalidated;
logic next_cctrans;

always_ff @(posedge CLK, negedge n_rst) begin
    if(!n_rst) begin
        state <= IDLE;
        LRU_tracker <= '0;
        for(int i = 0; i < 8; i++) begin
            data_store1[i] <= '0;
            data_store2[i] <= '0;
        end
        reserve <= '0;
        hit_counter <= '0;
        real_hit <= 1'b1;
        index <= '0;
        invalidated <= 0;
        cif.dREN <= 0;
        cif.dWEN <= 0;
        cif.dstore <= 0;
        cif.daddr <= 0;
        cif.cctrans <= 0;
    end
    else begin
        state <= next_state;
        LRU_tracker <= next_LRU_tracker;
        for(int i = 0; i < 8; i++) begin
            data_store1[i] <= next_data_store1[i];
            data_store2[i] <= next_data_store2[i];
        end
        reserve <= next_reserve;
        hit_counter <= next_hit_counter;
        real_hit <= next_real_hit;
        index <= next_index;
        invalidated <= next_invalidated;
        cif.dREN <= next_dREN;
        cif.dWEN <= next_dWEN;
        cif.dstore <= next_dstore;
        cif.daddr <= next_daddr;
        cif.cctrans <= next_cctrans;
    end
end

assign cache_addr = dcachef_t'(dcif.dmemaddr);
assign snoop_addr = dcachef_t'(cif.ccsnoopaddr);

always_comb begin : next_state_logic
    next_state = state;
    //latching memory requests
    next_dREN = cif.dREN;
    next_dWEN = cif.dWEN;
    next_daddr = cif.daddr;
    next_dstore = cif.dstore;
    next_cctrans = cif.cctrans;
    casez(state) 
        IDLE : begin
            if(dcif.halt == 1'b1) begin
                next_state = DIRTY_CHECK;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b0;
                next_daddr = 0;
                next_dstore = 0;
            end
            else if(cif.ccwait == 1'b1) begin
                next_state = SNOOP;
                if(snoop_addr.tag == data_store1[snoop_addr.idx].tag && data_store1[snoop_addr.idx].valid == 1'b1) begin //(fixed) caused combinational loop because cctrans depends on snoop addr and snoop in memory control transition depends on cctrans
                    next_cctrans = 1'b1;
                end
                else if(snoop_addr.tag == data_store2[snoop_addr.idx].tag && data_store2[snoop_addr.idx].valid == 1'b1) begin
                    next_cctrans = 1'b1;
                end
            end
            else if(dcif.dmemWEN == 1'b1 && data_store1[cache_addr.idx].tag == cache_addr.tag && data_store1[cache_addr.idx].valid == 1'b1 && data_store1[cache_addr.idx].dirty == 1'b0) begin
                next_state = HIT_INVALIDATE;
                next_daddr = cache_addr;
                next_cctrans = 1'b1;
            end
            else if(dcif.dmemWEN == 1'b1 && data_store2[cache_addr.idx].tag == cache_addr.tag && data_store2[cache_addr.idx].valid == 1'b1 && data_store2[cache_addr.idx].dirty == 1'b0) begin
                next_state = HIT_INVALIDATE;
                next_daddr = cache_addr;
                next_cctrans = 1'b1;
            end
            else if(miss == 1'b1 && LRU_tracker[cache_addr.idx] == 1'b1 && data_store1[cache_addr.idx].dirty == 1'b1) begin
                next_state = STORE1_STORE_ONE;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b1;
                next_daddr = {data_store1[cache_addr.idx].tag,cache_addr.idx,3'b0}; //piece together old address
                next_dstore = data_store1[cache_addr.idx].data[0];
            end
            else if(miss == 1'b1 && LRU_tracker[cache_addr.idx] == 1'b0 && data_store2[cache_addr.idx].dirty == 1'b1) begin
                next_state = STORE2_STORE_ONE;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b1;
                next_daddr = {data_store2[cache_addr.idx].tag,cache_addr.idx,3'b0};
                next_dstore = data_store2[cache_addr.idx].data[0];
            end
            else if(miss == 1'b1) begin
                next_state = MEMORY_ONE;
                next_dREN  = 1'b1;
                next_dWEN  = 1'b0;
                next_daddr = cache_addr.blkoff == 1'b0 ? dcif.dmemaddr : dcif.dmemaddr - 4;
                next_dstore = 0;
            end
            else if (dcif.dmemWEN == 1'b1 && dcif.datomic == 1'b1)
            begin
                next_state = HIT_INVALIDATE;
                next_daddr = cache_addr;
                next_cctrans = 1'b1;
            end
        end
        HIT_INVALIDATE : begin
            if (cif.ccwait == 1'b1)
            begin
                next_state = SNOOP;
                if(snoop_addr.tag == data_store1[snoop_addr.idx].tag && data_store1[snoop_addr.idx].valid == 1'b1) begin //causes combinational loop because cctrans depends on snoop addr and snoop in memory control transition depends on cctrans
                    next_cctrans = 1'b1;
                end
                else if(snoop_addr.tag == data_store2[snoop_addr.idx].tag && data_store2[snoop_addr.idx].valid == 1'b1) begin
                    next_cctrans = 1'b1;
                end
            end
            else if(cif.dwait == 1'b0) begin
                next_state = IDLE;
                next_cctrans = 1'b0;
            end
        end
        SNOOP : begin
            if(snoop_addr.tag == data_store1[snoop_addr.idx].tag && data_store1[snoop_addr.idx].valid == 1'b1) begin
                next_state = CACHE_1;
                next_dstore = data_store1[snoop_addr.idx].data[0];
                next_cctrans = 1'b0;
            end
            else if(snoop_addr.tag == data_store2[snoop_addr.idx].tag && data_store2[snoop_addr.idx].valid == 1'b1) begin
                next_state = CACHE_1;
                next_dstore = data_store2[snoop_addr.idx].data[0];
                next_cctrans = 1'b0;
            end
            else begin
                next_state = IDLE;
                next_cctrans = 1'b0;
            end
        end
        CACHE_1 : begin
            if(cif.dwait == 1'b0) begin
                next_state = CACHE_2;
                if(snoop_addr.tag == data_store1[snoop_addr.idx].tag && data_store1[snoop_addr.idx].valid == 1'b1) 
                begin
                    next_dstore = data_store1[snoop_addr.idx].data[1];
                end
                else if(snoop_addr.tag == data_store2[snoop_addr.idx].tag && data_store2[snoop_addr.idx].valid == 1'b1) 
                begin
                    next_dstore = data_store2[snoop_addr.idx].data[1];
                end
            end
        end
        CACHE_2 : begin
            if(cif.dwait == 1'b0) begin
                next_state = IDLE;
            end
        end
        STORE1_STORE_ONE : begin
            if(cif.dwait == 1'b0) begin
                next_state = STORE1_STORE_TWO;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b1;
                next_daddr = {data_store1[cache_addr.idx].tag,cache_addr.idx,3'b100}; //block offset 1
                next_dstore = data_store1[cache_addr.idx].data[1];
            end
        end
        STORE1_STORE_TWO : begin
            if(cif.dwait == 1'b0) begin
                next_state = MEMORY_ONE;
                next_dREN  = 1'b1;
                next_dWEN  = 1'b0;
                next_daddr = cache_addr.blkoff == 1'b0 ? dcif.dmemaddr : dcif.dmemaddr - 4;
                next_dstore = 0;
            end
        end
        STORE2_STORE_ONE : begin
            if(cif.dwait == 1'b0) begin
                next_state = STORE2_STORE_TWO;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b1;
                next_daddr =  {data_store2[cache_addr.idx].tag,cache_addr.idx,3'b100};
                next_dstore = data_store2[cache_addr.idx].data[1];
            end
        end
        STORE2_STORE_TWO : begin
            if(cif.dwait == 1'b0) begin
                next_state = MEMORY_ONE;
                next_dREN  = 1'b1;
                next_dWEN  = 1'b0;
                next_daddr = cache_addr.blkoff == 1'b0 ? dcif.dmemaddr : dcif.dmemaddr - 4;
                next_dstore = 0;
            end
        end
        MEMORY_ONE : begin
            if(cif.ccwait == 1'b1) begin
                next_state = SNOOP;
                if(snoop_addr.tag == data_store1[snoop_addr.idx].tag && data_store1[snoop_addr.idx].valid == 1'b1) begin //causes combinational loop because cctrans depends on snoop addr and snoop in memory control transition depends on cctrans
                    next_cctrans = 1'b1;
                end
                else if(snoop_addr.tag == data_store2[snoop_addr.idx].tag && data_store2[snoop_addr.idx].valid == 1'b1) begin
                    next_cctrans = 1'b1;
                end
            end
            else if(cif.dwait == 1'b0) begin
                next_state = MEMORY_TWO;
                next_dREN  = 1'b1;
                next_dWEN  = 1'b0;
                next_daddr = cache_addr.blkoff == 1'b0 ? dcif.dmemaddr + 4 : dcif.dmemaddr;
                next_dstore = 0;
            end
        end
        MEMORY_TWO : begin
            if(cif.dwait == 1'b0) begin
                next_state = IDLE;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b0;
                next_daddr = 0;
                next_dstore = 0;
            end
        end
        DIRTY_CHECK : begin
            if(cif.ccwait == 1'b1) begin
                next_state = SNOOP;
                if(snoop_addr.tag == data_store1[snoop_addr.idx].tag && data_store1[snoop_addr.idx].valid == 1'b1) begin //causes combinational loop because cctrans depends on snoop addr and snoop in memory control transition depends on cctrans
                    next_cctrans = 1'b1;
                end
                else if(snoop_addr.tag == data_store2[snoop_addr.idx].tag && data_store2[snoop_addr.idx].valid == 1'b1) begin
                    next_cctrans = 1'b1;
                end
            end
            else if(data_store1[index].dirty == 1'b1) begin
                next_state = STORE1_FLUSH_ONE;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b1;
                next_daddr = {data_store1[index].tag,index,3'b0}; //piece together old address
                next_dstore = data_store1[index].data[0];
            end
            else if(data_store2[index].dirty == 1'b1) begin
                next_state = STORE2_FLUSH_ONE;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b1;
                next_daddr = {data_store2[index].tag,index,3'b0}; //piece together old address
                next_dstore = data_store2[index].data[0];
            end
            else if(index == 3'b111) begin
                next_state = DONE;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b0;
           //     next_daddr = 32'h3100;
            //    next_dstore = hit_counter;
            end
        end
        STORE1_FLUSH_ONE : begin
            if(cif.dwait == 1'b0) begin
                next_state = STORE1_FLUSH_TWO;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b1;
                next_daddr = {data_store1[index].tag,index,3'b100}; //piece together old address
                next_dstore = data_store1[index].data[1];
            end
        end
        STORE1_FLUSH_TWO : begin
            if(cif.dwait == 1'b0 && data_store2[index].dirty == 1'b1) begin
                next_state = STORE2_FLUSH_ONE;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b1;
                next_daddr = {data_store2[index].tag,index,3'b0}; //piece together old address
                next_dstore = data_store2[index].data[0];
            end
            else if(cif.dwait == 1'b0 && data_store2[index].dirty == 1'b0 && index == 3'b111) begin
                next_state = DONE;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b0;
          //      next_daddr = 32'h3100;
          //      next_dstore = hit_counter;
            end
            else if(cif.dwait == 1'b0) begin
                next_state = DIRTY_CHECK;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b0;
                next_daddr = 0;
                next_dstore = 0;
            end
        end
        STORE2_FLUSH_ONE : begin
            if(cif.dwait == 1'b0) begin
                next_state = STORE2_FLUSH_TWO;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b1;
                next_daddr = {data_store2[index].tag,index,3'b100}; //piece together old address
                next_dstore = data_store2[index].data[1];
            end
        end
        STORE2_FLUSH_TWO : begin
            if(cif.dwait == 1'b0 && index != 3'b111) begin
                next_state = DIRTY_CHECK;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b0;
                next_daddr = 0;
                next_dstore = 0;
            end
            else if(cif.dwait == 1'b0) begin
                next_state = DONE;
                next_dREN  = 1'b0;
                next_dWEN  = 1'b0;
                next_daddr = 0;
                next_dstore = 0;
            end
        end
        DONE : begin
            //nothing
        end
    endcase
end

assign cif.ccwrite = dcif.dmemWEN;

always_comb begin : output_logic
    //new cache values
    next_data_store1 = data_store1;
    next_data_store2 = data_store2;
    next_reserve = reserve;

    //hit/miss outputs
    dcif.dhit = '0;
    miss = '0;
    dcif.dmemload = '0;
    next_LRU_tracker = LRU_tracker;
    dcif.flushed = 0;

    

    next_hit_counter = hit_counter;
    next_real_hit = 1'b1;
    next_index = index;
    next_invalidated = invalidated;

    casez(state) 
        IDLE : begin
            next_invalidated = 1'b0;
            if(dcif.halt == 1'b1) begin
                for(int i = 0; i < 8; i++) begin
             //       next_data_store1[i].valid = 1'b0;
             //       next_data_store2[i].valid = 1'b0;
                end
            end
            else if(cif.ccinv == 1'b1) begin
                if(snoop_addr.tag == data_store1[snoop_addr.idx].tag && data_store1[snoop_addr.idx].valid == 1'b1) begin
                    next_data_store1[snoop_addr.idx].valid = 1'b0;
                end
                else if(snoop_addr.tag == data_store2[snoop_addr.idx].tag && data_store2[snoop_addr.idx].valid == 1'b1) begin
                    next_data_store2[snoop_addr.idx].valid = 1'b0; 
                end
                if ({snoop_addr[31:3], 3'b0} == reserve.addr)
                begin
                    next_reserve.valid = 1'b0; 
                end

            end
            else if(dcif.dmemREN == 1'b1 && data_store1[cache_addr.idx].tag == cache_addr.tag && data_store1[cache_addr.idx].valid == 1'b1) begin
                dcif.dhit = 1'b1;
                dcif.dmemload = data_store1[cache_addr.idx].data[cache_addr.blkoff];
                next_hit_counter = hit_counter + 1;
                next_LRU_tracker[cache_addr.idx] = 1'b0;
                if (dcif.datomic == 1'b1)
                begin
                    next_reserve.valid = 1'b1;
                    next_reserve.addr  = {cache_addr.tag, cache_addr.idx, 3'b0};
                end
            end
            else if(dcif.dmemREN == 1'b1 && data_store2[cache_addr.idx].tag == cache_addr.tag && data_store2[cache_addr.idx].valid == 1'b1) begin
                dcif.dhit = 1'b1;
                dcif.dmemload = data_store2[cache_addr.idx].data[cache_addr.blkoff];
                next_hit_counter = hit_counter + 1;
                next_LRU_tracker[cache_addr.idx] = 1'b1;
                if (dcif.datomic == 1'b1)
                begin
                    next_reserve.valid = 1'b1;
                    next_reserve.addr  = {cache_addr.tag, cache_addr.idx, 3'b0};
                end
            end
            else if(dcif.dmemWEN == 1'b1 && data_store1[cache_addr.idx].tag == cache_addr.tag && data_store1[cache_addr.idx].valid == 1'b1) begin
                if (dcif.datomic == 1'b1 && invalidated == 1'b1)   //only checks after invalidation
                begin
                    if (reserve.valid == 1'b1 && {cache_addr[31:3], 3'b0} == reserve.addr)
                    begin
                        dcif.dhit = 1'b1;
                        next_data_store1[cache_addr.idx].valid = 1'b1;
                        next_data_store1[cache_addr.idx].dirty = 1'b1;
                        next_data_store1[cache_addr.idx].tag = cache_addr.tag;
                        next_data_store1[cache_addr.idx].data[cache_addr.blkoff] = dcif.dmemstore;
                        next_reserve.valid = 1'b0;
                        next_hit_counter = hit_counter + 1;
                        next_LRU_tracker[cache_addr.idx] = 1'b0;
                        dcif.dmemload = 1'b0;
                    end
                    else
                    begin
                        dcif.dhit = 1'b1;
                        dcif.dmemload = 1'b1;
                        next_LRU_tracker[cache_addr.idx] = 1'b0;
                    end
                end
                else if (dcif.datomic == 1'b0)
                begin
                    dcif.dhit = 1'b1;
                    next_data_store1[cache_addr.idx].valid = 1'b1;
                    next_data_store1[cache_addr.idx].dirty = 1'b1;
                    next_data_store1[cache_addr.idx].tag = cache_addr.tag;
                    next_data_store1[cache_addr.idx].data[cache_addr.blkoff] = dcif.dmemstore;
                    next_hit_counter = hit_counter + 1;
                    next_LRU_tracker[cache_addr.idx] = 1'b0;
                end
            end
            else if (dcif.dmemWEN == 1'b1 && data_store2[cache_addr.idx].tag == cache_addr.tag && data_store2[cache_addr.idx].valid == 1'b1) begin
                if (dcif.datomic == 1'b1 && invalidated == 1'b1)   //only checks after invalidation
                begin
                    if (reserve.valid == 1'b1 && {cache_addr[31:3], 3'b0} == reserve.addr)
                    begin
                        dcif.dhit = 1'b1;
                        next_data_store2[cache_addr.idx].valid = 1'b1;
                        next_data_store2[cache_addr.idx].dirty = 1'b1;
                        next_data_store2[cache_addr.idx].tag = cache_addr.tag;
                        next_data_store2[cache_addr.idx].data[cache_addr.blkoff] = dcif.dmemstore;
                        next_reserve.valid = 1'b0;
                        next_hit_counter = hit_counter + 1;
                        next_LRU_tracker[cache_addr.idx] = 1'b0;
                        dcif.dmemload = 1'b0;
                    end
                    else
                    begin
                        dcif.dhit = 1'b1;
                        dcif.dmemload = 1'b1;
                        next_LRU_tracker[cache_addr.idx] = 1'b0;
                    end
                end
                else if (dcif.datomic == 1'b0)
                begin
                    dcif.dhit = 1'b1;
                    next_data_store2[cache_addr.idx].valid = 1'b1;
                    next_data_store2[cache_addr.idx].dirty = 1'b1;
                    next_data_store2[cache_addr.idx].tag = cache_addr.tag;
                    next_data_store2[cache_addr.idx].data[cache_addr.blkoff] = dcif.dmemstore;
                    next_hit_counter = hit_counter + 1;
                    next_LRU_tracker[cache_addr.idx] = 1'b1;
                end
            end
            else if(dcif.dmemREN == 1'b1 || dcif.dmemWEN == 1'b1) begin
                miss = 1'b1;
                next_hit_counter = hit_counter - 1;
            end
        end
        HIT_INVALIDATE : begin
            next_invalidated = 1'b1;    //lets idle know invalidation has occured
        end
        SNOOP : begin
            
        end
        CACHE_1 : begin
            /*
            if(snoop_addr.tag == data_store1[snoop_addr.idx].tag && data_store1[snoop_addr.idx].valid == 1'b1) begin
                next_data_store1[snoop_addr.idx].valid = ~cif.ccinv;
                next_data_store1[snoop_addr.idx].dirty = 1'b0;
               // cif.dstore = data_store1[snoop_addr.idx].data[0];
            end
            else if(snoop_addr.tag == data_store2[snoop_addr.idx].tag && data_store2[snoop_addr.idx].valid == 1'b1) begin
                next_data_store2[snoop_addr.idx].valid = ~cif.ccinv;
                next_data_store2[snoop_addr.idx].dirty = 1'b0;
             //   cif.dstore = data_store2[snoop_addr.idx].data[0];
            end
            */
        end
        CACHE_2 : begin
            if(snoop_addr.tag == data_store1[snoop_addr.idx].tag && data_store1[snoop_addr.idx].valid == 1'b1 && cif.dwait == 1'b0) begin
                next_data_store1[snoop_addr.idx].valid = ~cif.ccinv;
                next_data_store1[snoop_addr.idx].dirty = 1'b0;
            end
            else if(snoop_addr.tag == data_store2[snoop_addr.idx].tag && data_store2[snoop_addr.idx].valid == 1'b1 && cif.dwait == 1'b0) begin
                next_data_store2[snoop_addr.idx].valid = ~cif.ccinv;
                next_data_store2[snoop_addr.idx].dirty = 1'b0;
            end

        end
        STORE1_STORE_ONE : begin
            next_data_store1[cache_addr.idx].dirty = 1'b0;
        end
        STORE1_STORE_TWO : begin
            next_data_store1[cache_addr.idx].valid = 1'b0;
        end
        STORE2_STORE_ONE : begin
            next_data_store2[cache_addr.idx].dirty = 1'b0;
        end
        STORE2_STORE_TWO : begin
            next_data_store2[cache_addr.idx].valid = 1'b0;
        end
        MEMORY_ONE : begin
            
            if(cif.ccinv == 1'b1) begin
                if(snoop_addr.tag == data_store1[snoop_addr.idx].tag) begin
                    next_data_store1[snoop_addr.idx].valid = 1'b0;
                end
                else if(snoop_addr.tag == data_store2[snoop_addr.idx].tag) begin
                    next_data_store2[snoop_addr.idx].valid = 1'b0;
                end
                if ({snoop_addr[31:3], 3'b0} == reserve.addr)
                begin
                    next_reserve.valid = 1'b0; 
                end
            end
            
            if(cif.dwait == 1'b0 && LRU_tracker[cache_addr.idx] == 1'b1) begin
                next_data_store1[cache_addr.idx].valid = 1'b0;
                next_data_store1[cache_addr.idx].dirty = 1'b0;
                next_data_store1[cache_addr.idx].tag = cache_addr.tag;
                next_data_store1[cache_addr.idx].data[0] = cif.dload;
            end
            else if(cif.dwait == 1'b0 && LRU_tracker[cache_addr.idx] == 1'b0) begin
                next_data_store2[cache_addr.idx].valid = 1'b0;
                next_data_store2[cache_addr.idx].dirty = 1'b0;
                next_data_store2[cache_addr.idx].tag = cache_addr.tag;
                next_data_store2[cache_addr.idx].data[0] = cif.dload;
            end
        end
        MEMORY_TWO : begin
            next_real_hit = 1'b0;
            
            if(cif.dwait == 1'b0 && dcif.dmemREN == 1'b1) begin
                if(LRU_tracker[cache_addr.idx] == 1'b1) begin
                    next_data_store1[cache_addr.idx].valid = 1'b1;
                    next_data_store1[cache_addr.idx].dirty = 1'b0;
                    next_data_store1[cache_addr.idx].tag = cache_addr.tag;
                    next_data_store1[cache_addr.idx].data[1] = cif.dload;
                    next_LRU_tracker[cache_addr.idx] = 1'b0;
                end
                else begin
                    next_data_store2[cache_addr.idx].valid = 1'b1;
                    next_data_store2[cache_addr.idx].dirty = 1'b0;
                    next_data_store2[cache_addr.idx].tag = cache_addr.tag;
                    next_data_store2[cache_addr.idx].data[1] = cif.dload;
                    next_LRU_tracker[cache_addr.idx] = 1'b1;
                end
            end
            else if(cif.dwait == 1'b0 && dcif.dmemWEN == 1'b1) begin
                if(LRU_tracker[cache_addr.idx] == 1'b1) begin
                    next_data_store1[cache_addr.idx].valid = 1'b1;
                    next_data_store1[cache_addr.idx].dirty = 1'b1;
                    next_data_store1[cache_addr.idx].tag = cache_addr.tag;
                    next_data_store1[cache_addr.idx].data[1] = cif.dload;
                    next_data_store1[cache_addr.idx].data[cache_addr.blkoff] = dcif.dmemstore;
                    next_LRU_tracker[cache_addr.idx] = 1'b0;
                end
                else begin
                    next_data_store2[cache_addr.idx].valid = 1'b1;
                    next_data_store2[cache_addr.idx].dirty = 1'b1;
                    next_data_store2[cache_addr.idx].tag = cache_addr.tag;
                    next_data_store2[cache_addr.idx].data[1] = cif.dload;
                    next_data_store2[cache_addr.idx].data[cache_addr.blkoff] = dcif.dmemstore;
                    next_LRU_tracker[cache_addr.idx] = 1'b1;
                end
            end
        end
        DIRTY_CHECK : begin
            if(data_store1[index].dirty == 1'b0 && data_store2[index].dirty == 1'b0 && index != 3'b111) begin
                next_index = index + 1;
            end
        end
        STORE1_FLUSH_ONE : begin
            next_data_store1[index].dirty = 1'b0;
        end
        STORE1_FLUSH_TWO : begin
            if(cif.dwait == 1'b0 && data_store2[index].dirty == 1'b0 && index != 3'b111) begin
                next_index = index + 1;
            end
        end
        STORE2_FLUSH_ONE : begin
            next_data_store2[index].dirty = 1'b0;
        end
        STORE2_FLUSH_TWO : begin
            if(cif.dwait == 1'b0 && index != 3'b111) begin
                next_index = index + 1;
            end
        end
        DONE : begin
            //nothing
            dcif.flushed = 1;
        end
    endcase
end

endmodule