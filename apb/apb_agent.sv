`ifndef APB_AGENT__SV
`define APB_AGENT__SV

class apb_master_agent extends uvm_agent;
    `uvm_component_utils(apb_master_agent)

    apb_imonitor    apb_imon;
    apb_sequencer   apb_seqr;
    apb_driver      apb_drv;

    uvm_analysis_port#(apb_trans) ap;

    function new(string name = "apb_master_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
endclass

function void apb_master_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);

    if(is_active == UVM_ACTIVE) begin
        apb_seqr = apb_sequencer::type_id::create("apb_seqr", this);
        apb_drv  = apb_driver::type_id::create("apb_drv", this);
    end
    apb_imon = apb_imonitor::type_id::create("apb_imon", this);

endfunction


function void apb_master_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(is_active == UVM_ACTIVE) begin
        apb_drv.seq_item_port.connect(apb_seqr.seq_item_export);
    end

    apb_imon.analysis_port.connect(ap);
endfunction


class apb_slave_agent extends uvm_agent;
    `uvm_component_utils(apb_slave_agent)

    apb_omonitor  apb_omon;

    uvm_analysis_port#(apb_trans) ap;

    function new (string name="apb_slave_agent",uvm_component parent);
        super.new(name,parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
endclass

function void apb_slave_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap=new("ap",this);
    if(is_active == UVM_ACTIVE) begin
    end
    
	apb_omon=apb_omonitor::type_id::create("apb_omon",this);
    
endfunction

function void apb_slave_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    apb_omon.analysis_port.connect(ap);
endfunction
`endif
