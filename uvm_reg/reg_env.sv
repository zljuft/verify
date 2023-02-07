`ifndef REG_ENV__SV
`define REG_ENV__SV

class reg_env extends uvm_env;
    `uvm_component_utils(reg_env)

    function new(string name = "reg_env",  uvm_component parent);
        super.new(name, parent);
    endfunction

    reg_sys_block m_reg_model;
    reg_adapter   m_adapter;
    uvm_reg_predictor#(bus_pkt) m_predictor;
    reg_agent      m_agent;

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        m_reg_model = reg_sys_block::type_id::create("m_reg_model", this);
        m_adapter = reg_adapter::type_id::create("m_adapter", this);
        m_predictor = uvm_reg_predictor#(bus_pkt)::type_id::create("m_predictor", this);

        m_reg_model.build();
        m_reg_model.lock_model();

        uvm_config_db #(reg_sys_block)::set(null, "uvm_test_top", "m_reg_model", m_reg_model);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        m_predictor.map = m_reg_model.default_map;
        m_predictor.adapter = m_adapter;
    endfunction
endclass



`endif