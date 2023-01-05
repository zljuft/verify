`ifndef APB_MONITOR__SV
`define APB_MONITOR__SV

class apb_imonitor extends uvm_monitor;
    `uvm_component_utils(apb_imonitor)

    virtual apb_if.iMon vif;

    uvm_analysis_port#(apb_trans) analysis_port;

    protected apb_trans tr;
    function new(string name = "apb_imonitor", uvm_component parent);
        super.new(name, parent);
    endfunction //new()
    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void build_phase(uvm_phase phase);
endclass //apb_imonitor extends uvm_monitor

function void apb_imonitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if.iMon)::get(get_parent(), "", "iMon_if", vif)) begin
        `uvm_fatal("CFGERR", "iMonitor DUT interface not set");
    end

    analysis_port = new ("analysis_port", this);
endfunction

task apb_imonitor::run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
        do 
        @(vif.cb_imon);
        while (vif.cb_imon.sel !== 1 || vif.cb_imon.enable !== 0);
        tr = apb_trans::type_id::create("tr", this);
        tr.addr = vif.cb_imon.addr;
        tr.mode = vif.cb_imon.write == 1 ? WRITE : READ;
        @(vif.cb_imon);
        
        if(vif.cb_imon.enable != 1) begin
            `uvm_fatal("Violation","APB Protocol Violation :: Setup Phase not followed by Access Phase");
        end

        if(tr.mode == WRITE) begin
            tr.wdata = vif.cb_imon.wdata;
            `uvm_info("iMon",tr.convert2string(),UVM_LOW);
            analysis_port.write(tr);
        end
        
    end
    
endtask


class apb_omonitor extends uvm_monitor;
    `uvm_component_utils(apb_omonitor)

    virtual apb_if.oMon vif;
    uvm_analysis_port#(apb_trans) analysis_port;

    protected apb_trans tr;
    function new(string name = "apb_omonitor", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void build_phase(uvm_phase phase);
endclass //apb_omonitor extends uvm_monitor

function void apb_omonitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if.oMon)::get(get_parent(), "", "oMon_if", vif)) begin
        `uvm_fatal("CFGERR", "oMonitor DUT interface not set");
    end
    //create TLM port
    analysis_port=new("analysis_port",this);
endfunction

task apb_omonitor::run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
        @(vif.cb_omon.rdata);
        if (vif.cb_omon.rdata === 'bz || vif.cb_omon.rdata === 'bx) begin
            continue;
        end

        tr = apb_trans::type_id::create("tr", this);
        tr.wdata = vif.cb_omon.rdata;
        tr.addr = vif.cb_omon.addr;
        `uvm_info("oMon",tr.convert2string(),UVM_MEDIUM);
        analysis_port.write(tr);
    end
endtask

`endif