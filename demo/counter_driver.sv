`ifndef COUNTER_DRIVER__SV
`define COUNTER_DRIVER__SV

class counter_driver extends uvm_driver #(counter_item);
    `uvm_component_utils(counter_driver)

    function new(string name="counter_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual counter_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual counter_if)::get(this, "", "counter_vif", vif))
            `uvm_fatal("DRV", "could not get vif")
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            counter_item item;
            `uvm_info("DRV", $sformatf("wait for item from sequencer"), UVM_HIGH)
            seq_item_port.get_next_item(item);
            drive_item(item);
            seq_item_port.item_done();
        end
    endtask

    virtual task drive_item(counter_item item);
        @(vif.clk);
        vif.cnt_en <= item.count_en;
        vif.rst_n <= item.rst_n;
    endtask
endclass

`endif