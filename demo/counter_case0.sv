`ifndef COUNTER_CASE0__SV
`define COUNTER_CASE0__SV

class counter_case0 extends base_test;
    function new(string name = "counter_case0", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    `uvm_component_utils(counter_case0)
endclass

function void counter_case0::build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq.randomize();
endfunction

`endif 