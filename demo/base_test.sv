`ifndef BASE_TEST__SV
`define BASE_TEST__SV

class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    counter_env env;
    counter_item_seq seq;

    virtual counter_if vif;    

    extern virtual function void build_phase(uvm_phase phase);
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq.start(env.agt.sqr);
        #1000;
        phase.drop_objection(this);
    endtask

    
endclass

function void base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = counter_env::type_id::create("env", this);

    if (!uvm_config_db#(virtual counter_if)::get(this, "", "counter_vif", vif)) begin
        `uvm_fatal("TEST", "Did not get vif")
    end

    uvm_config_db#(virtual counter_if)::set(this, "env.agt.*", "couter_vif", vif);

    seq = counter_item_seq::type_id::create("seq");
    seq.randomize();
endfunction

`endif