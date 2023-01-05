`ifndef APB_SEQUENCER__SV
`define APB_SEQUENCER__SV

class apb_sequencer extends uvm_sequencer#(apb_trans);
    `uvm_component_utils(apb_sequencer)

    function new(string name = "apb_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

`endif




