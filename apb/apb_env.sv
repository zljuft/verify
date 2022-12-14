`ifndef APB_ENV__SV
`define APB_EVN__SV


class apb_env extends uvm_env;
    `uvm_component_utils(apb_env)

    bit[31:0] exp_pkt_count;
    real tot_cov_score;
    bit[31:0] m_matches, mis_matches;

    apb_master_agent m_agent;
    apb_slave_agent  s_agent;
    apb_socreboard   apb_scb;
    apb_coverage     apb_cov;

    function new(string name = "apb_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);
    extern virtual function void extract_phase(uvm_phase phase);
endclass

function void apb_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_agent = apb_master_agent::type_id::create("m_agent", this);
    s_agent = apb_slave_agent::type_id::create("s_agent", this);
    apb_scb = apb_socreboard::type_id::create("apb_scb", this);
    apb_cov = apb_coverage::type_id::create("apb_cov", this);
endfunction

function void apb_env::connect_phase(uvm_phase phase);
    m_agent.ap.connect(apb_scb.mon_in);
    m_agent.ap.connect(apb_cov.analysis_export);
    s_agent.ap.connect(apb_scb.mon_out);
endfunction

function void apb_env::extract_phase(uvm_phase phase);
    uvm_config_db#(int)::get(this, "m_agent.apb_seqr", "item_count", exp_pkt_count);
    uvm_config_db#(real)::get(this, "", "cov_score", tot_cov_score);
    uvm_config_db#(int)::get(this, "", "matches", m_matches);
    uvm_config_db#(int)::get(this, "", "mis_matches", mis_matches);
endfunction

function void apb_env::report_phase(uvm_phase phase);

    bit[31:0] tot_scb_cnt;
    tot_scb_cnt = m_matches + mis_matches;

    if(exp_pkt_count != tot_scb_cnt) begin
        `uvm_info("","******************************************",UVM_NONE);
        `uvm_info("FAIL","Test Failed due to packet count MIS_MATCH",UVM_NONE); 
        `uvm_info("FAIL",$sformatf("exp_pkt_count=%0d Received_in_scb=%0d ",exp_pkt_count,tot_scb_cnt),UVM_NONE); 
        `uvm_fatal("FAIL","******************Test FAILED ************");
    end
    else if(mis_matches != 0) begin
        `uvm_info("","******************************************",UVM_NONE);
        `uvm_info("FAIL","Test Failed due to mis_matched packets in scoreboard",UVM_NONE); 
        `uvm_info("FAIL",$sformatf("matched_pkt_count=%0d mis_matched_pkt_count=%0d ",m_matches,mis_matches),UVM_NONE); 
        `uvm_fatal("FAIL","******************Test FAILED ***************");
    end
    else begin
        `uvm_info("PASS","******************Test PASSED ***************",UVM_NONE);
        `uvm_info("PASS",$sformatf("exp_pkt_count=%0d Received_in_scb=%0d ",exp_pkt_count,tot_scb_cnt),UVM_NONE); 
        `uvm_info("PASS",$sformatf("matched_pkt_count=%0d mis_matched_pkt_count=%0d ",m_matches,mis_matches),UVM_NONE); 
        `uvm_info("PASS",$sformatf("Coverage=%0f%%",tot_cov_score),UVM_NONE); 
        `uvm_info("","******************************************",UVM_NONE);
    end

endfunction

`endif