`ifndef COUNTER_MONITOR__SV
`define COUNTER_MONITOR__SV

class counter_monitor extends uvm_monitor;
    `uvm_component_utils(counter_monitor)

    function new(string name="counter_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    uvm_analysis_port #(counter_item) mon_analysis_port;
    virtual counter_if vif;

    virtual function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual counter_if)::get(this, "", "counter_vif", vif))
            `uvm_fatal("MON", "Could not get vif")

        mon_analysis_port = new("mon_analysis_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            @(posedge vif.clk);
            if(vif.cnt_en)begin
                counter_item item = counter_item::type_id::create("item");
                item.count_en = vif.cnt_en;
                item.counter_out = vif.data;

                mon_analysis_port.write(item);
            //`uvm_info("MON", $sformatf("Saw item %s", item.convert2str()), UVM_HIGH);
            end
        end
    endtask
    
endclass

`endif