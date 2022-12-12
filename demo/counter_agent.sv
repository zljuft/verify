`ifndef COUNTER_AGENT__SV
`define COUNTER_AGENT__SV

class counter_agent extends uvm_agent;
    `uvm_component_utils(counter_agent)

    function new(string name="counter_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    uvm_sequencer #(counter_item) sqr;
    counter_driver    drv;
    counter_monitor   mon;

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
   
endclass

function void counter_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);

    sqr = uvm_sequencer #(counter_item)::type_id::create("sqr", this);
    drv = counter_driver::type_id::create("drv", this);
    mon = counter_monitor::type_id::create("mon", this);
endfunction

function void counter_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    drv.seq_item_port.connect(sqr.seq_item_export);
endfunction

`endif