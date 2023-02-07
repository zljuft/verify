`ifndef REG_TEST__SV
`define REG_TEST__SV

import reg_pkg::*;
import uvm_pkg::*;

class reg_base_test extends uvm_test;
    `uvm_component_utils(reg_base_test)

    reg_test_env m_env;
    reset_sequence m_reset_seq;
    uvm_status_e status;

    function new(string name = "reg_base_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_env = reg_test_env::type_id::create("m_env", this);
        m_reset_seq = reset_sequence::type_id::create("m_reset_seq", this);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        phase.raise_objection(this);
        m_reset_seq.start(m_env.m_agt.m_sqr);
        phase.drop_objection(this);
    endtask
endclass

class reg_rw_test extends reg_base_test;
    `uvm_component_utils(reg_rw_test)

    function new(string name = "reg_rw_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task main_phase(uvm_phase phase);
        reg_sys_block reg_model;
        uvm_status_e status;
        int rdata;

        phase.raise_objection(this);
        m_env.m_reg_env.set_report_verbosity_level(UVM_HIGH);

        uvm_config_db#(reg_sys_block)::get(null, "uvm_test_top", "m_reg_model", reg_model);

        reg_model.traffic.timer[1].write(status, 32'hcafe_feed);
        reg_model.traffic.timer[1].read(status, rdata);

        reg_model.traffic.timer[1].set(32'hface);

        reg_model.traffic.timer[1].predict(32'hcafe_feed);
        reg_model.traffic.timer[1].mirror(status, UVM_CHECK);

        reg_model.traffic.ctrl.bl_yellow.set(1);
        reg_model.traffic.update(status);

        reg_model.traffic.stat.write(status, 32'h12345678);
        phase.drop_objection(this);
    endtask

    virtual task shutdown_phase(uvm_phase phase);
        super.shutdown_phase(phase);
        phase.raise_objection(this);
        #100ns;
        phase.drop_objection(this);
    endtask
endclass

`endif