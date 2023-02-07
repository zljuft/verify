`ifndef REG_TEST_ENV__SV
`define REG_TEST_ENV__SV

class reg_test_env extends uvm_env;
    `uvm_component_utils(reg_test_env)

    reg_agent m_agt;
    reg_env   m_reg_env;

    function new(string name= "reg_test_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_agt = reg_agent::type_id::create("m_agt", this);
        m_reg_env = reg_env::type_id::create("m_reg_env", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        m_reg_env.m_agent = m_agt;
        m_agt.m_mon.mon_ap.connect(m_reg_env.m_predictor.bus_in);
        m_reg_env.m_reg_model.default_map.set_sequencer(m_agt.m_sqr, m_reg_env.m_adapter);
    endfunction
endclass

`endif