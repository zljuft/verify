`ifndef APB_SCOREBOARD__SV
`define APB_SCOREBOARD__SV

class apb_socreboard extends uvm_scoreboard;
    `uvm_component_utils(apb_socreboard)

    uvm_analysis_port #(apb_trans) mon_in;
    uvm_analysis_port #(apb_trans) mon_out;
    uvm_in_order_class_comparator #(apb_trans) m_comp;

    function new(string name = "apb_socreboard", uvm_component parent = null);
        super.new(name, parent);        
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_comp = uvm_in_order_class_comparator#(apb_trans)::type_id::create("m_comp", this);
        mon_in = new("mon_in", this);
        mon_out = new("mon_out", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        mon_in.connect(m_comp.before_export);
        mon_out.connect(m_comp.after_export);
    endfunction

    virtual function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);

        uvm_config_db#(int)::set(null, "uvm_test_top.env", "matches", m_comp.m_matches);
        uvm_config_db#(int)::set(null, "uvm_test_top.env", "mis_matches", m_comp.m_mismatches);
    endfunction

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCB",$sformatf("Scoreboard completed with matches=%0d mismatches=%0d ",m_comp.m_matches,m_comp.m_mismatches),UVM_MEDIUM);
    endfunction
endclass


`endif