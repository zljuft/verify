`ifndef COUNTER_ENV__SV
`define COUNTER_ENV__SV

class counter_env extends uvm_env;
    `uvm_component_utils(counter_env)
    function new(string name = "counter_env", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    counter_agent agt;
    counter_scoreboard scb;
    

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = counter_agent::type_id::create("agt", this);
        scb = counter_scoreboard::type_id::create("scb", this);
    endfunction

    extern virtual function void connect_phase(uvm_phase phase);
endclass

function void counter_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    agt.mon.mon_analysis_port.connect(scb.m_analysis_imp);
endfunction

`endif