`ifndef COUNTER_SEQUENCE__SV
`define COUNTER_SEQUENCE__SV

class counter_item_seq extends uvm_sequence;
    `uvm_object_utils(counter_item_seq)

    function new(string name = "counter_item_seq");
        super.new(name);
    endfunction

    rand int num;

    constraint c1 {soft num inside {[10:50]};}

    virtual task body();
        for (int i = 0; i < num; i++) begin
            counter_item item = counter_item::type_id::create("counter_item");
            start_item(item);
            item.randomize();
            `uvm_info("SEQ", $sformatf("generate new item %s", item.convert2str()), UVM_HIGH);
            finish_item(item);
        end
        
        `uvm_info("SEQ", $sformatf("Done generation of %d items.", num), UVM_LOW);
    endtask


endclass

`endif