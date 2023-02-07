`ifndef REG_AGENT__SV
`define REG_AGENT__SV

class reg_agent extends uvm_agent;
    `uvm_component_utils(reg_agent)

    function new(string name = "reg_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    reg_driver m_drv;
    reg_monitor m_mon;
    uvm_sequencer#(bus_pkt) m_sqr;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_drv = reg_driver::type_id::create("m_drv", this);
        m_mon = reg_monitor::type_id::create("m_mon", this);
        m_sqr = uvm_sequencer#(bus_pkt)::type_id::create("m_sqr", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        m_drv.seq_item_port.connect(m_sqr.seq_item_export);
    endfunction
endclass

`endif
