`ifndef REG_SEQUENCE__SV
`define REG_SEQUENCE__SV

class reset_sequence extends uvm_sequence;
    `uvm_object_utils(reset_sequence)

    function new(string name = "reset_sequence");
        super.new(name);
    endfunction

    virtual bus_if vif;

    task body();
        if(!uvm_config_db#(virtual bus_if)::get(null, "uvm_test_top.*", "bus_if", vif)) begin
            `uvm_fatal("reset_sequence", "No vif");
        end

        vif.presetn <= 0;
        @(posedge vif.pclk);
        vif.presetn <= 1;
        @(posedge vif.pclk);
    endtask
endclass

`endif