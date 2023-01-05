`ifndef APB_SEQUENCE__SV
`define APB_SEQUENCE__SV

class apb_sequence extends uvm_sequence#(apb_trans);
    `uvm_object_utils(apb_sequence)

    int pkt_count;

    function new(string name = "apb_sequence");
        super.new(name);
    endfunction //new()

    virtual task pre_body();
        if (!uvm_config_db#(int)::get(m_sequencer, "", "item_count", pkt_count)) begin
            `uvm_warning("SEQ", "item count is 0");
            pkt_count = 10;
        end
    endtask

    virtual task body();
        int unsigned pkt_id;
        $display("pkt_count %d", pkt_count);
        repeat(pkt_count) begin
            // req.randomize();
            `uvm_do_with(req, {addr inside {[0:255]};});
            // req.randomize();
            pkt_id ++;
            `uvm_info("SEQ", $sformatf("transaction %0d generation Done.", pkt_id), UVM_LOW)
            get_response(rsp);
            // `uvm_info("SEQ", "get rsp", UVM_LOW)
        end
    endtask
endclass //abp_sequence extends uvm_sequencestring name = "apb"

`endif