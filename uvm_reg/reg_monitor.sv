`ifndef REG_MONITOR__SV
`define REG_MONITOR__SV

class reg_monitor extends uvm_monitor;
    `uvm_component_utils(reg_monitor)

    function new(string name = "reg_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction

    uvm_analysis_port#(bus_pkt) mon_ap;
    virtual bus_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon_ap = new("mon_ap", this);
        uvm_config_db#(virtual bus_if)::get(null, "uvm_test_top.*", "bus_if", vif);
    endfunction

    virtual task run_phase(uvm_phase phase);
        fork
            forever begin
                @(posedge vif.pclk);
                if (vif.psel &vif.penable & vif.penable) begin
                    bus_pkt pkt = bus_pkt::type_id::create("pkt");
                    pkt.addr = vif.paddr;
                    if (vif.pwrite) begin
                        pkt.data = vif.pwdata;
                    end
                    else begin
                        pkt.data = vif.prdata;
                    end

                    pkt.write = vif.pwrite;
                    mon_ap.write(pkt);
                end
            end
        join_none
    endtask
endclass

`endif 