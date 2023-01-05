`ifndef APB_TEST__SV
`define APB_TEST__SV

class apb_test extends uvm_test;
    `uvm_component_utils(apb_test)
    bit[31:0] pkt_count;
    virtual apb_if.master drvr_vif;
    virtual apb_if.iMon   iMon_vif;
    virtual apb_if.oMon   oMon_vif;

    apb_env env;

    function new(string name = "apb_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void final_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);
    extern virtual function void end_of_elaboration_phase(uvm_phase phase);
endclass //apb_test extends uvm_test

function void apb_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    pkt_count = 10;
    uvm_config_db#(bit)::set(this, "env.apb_cov", "coverage_enable", 1'b1);

    env = apb_env::type_id::create("env", this);

    uvm_config_db#(virtual apb_if.master)::get(this, "", "drvr_if", drvr_vif);
    uvm_config_db#(virtual apb_if.iMon)::get(this, "", "iMon_if", iMon_vif);
    uvm_config_db#(virtual apb_if.oMon)::get(this, "", "oMon_if", oMon_vif);

    uvm_config_db#(int)::set(this, "env.m_agent.apb_seqr", "item_count", pkt_count);
    uvm_config_db#(virtual apb_if.master)::set(this, "env.m_agent", "drvr_if", drvr_vif);
    uvm_config_db#(virtual apb_if.iMon)::set(this, "env.m_agent", "iMon_if", iMon_vif);
    uvm_config_db#(virtual apb_if.oMon)::set(this, "env.s_agent", "oMon_if", oMon_vif);
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent.apb_seqr.main_phase", "default_sequence", apb_sequence::get_type());
endfunction

task apb_test::main_phase(uvm_phase phase);
    //uvm_objection objection;
    super.main_phase(phase);
    phase.raise_objection(this);

    #10000;
    phase.drop_objection(this);
    // objection = phase.get_objection();
    // objection.set_drain_time(this, 100ns);
endtask

function void apb_test::final_phase(uvm_phase phase);
    super.final_phase(phase);
endfunction

function void apb_test::end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
endfunction

`endif