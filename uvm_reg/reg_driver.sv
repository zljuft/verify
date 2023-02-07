`ifndef REG_DRIVER__SV
`define REG_DRIVER__SV

class reg_driver extends uvm_driver#(bus_pkt);
    `uvm_component_utils(reg_driver)

    bus_pkt pkt;

    virtual bus_if vif;

    function new(string name = "reg_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual bus_if)::get(this, "*", "bus_if", vif)) begin
            `uvm_error("reg_driver", "do not get bus if handle");
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        bit[31:0] data;

        vif.psel <= 0;
        vif.penable <= 0;
        vif.pwrite <= 0;
        vif.paddr <= 0;
        vif.pwdata <= 0;

        forever begin
            seq_item_port.get_next_item(pkt);
            if (pkt.write) begin
                write(pkt.addr, pkt.data);
            end
            else begin
                read(pkt.addr, data);
                pkt.data = data;
            end
            seq_item_port.item_done();
        end
    endtask

    virtual task read(input bit[31:0] addr, output logic[31:0] data);
        vif.paddr <= addr;
        vif.pwrite <= 0;
        vif.psel <= 1;

        @(posedge vif.pclk);
        vif.penable <= 1;

        @(posedge vif.pclk);
        data = vif.prdata;
        vif.psel <= 0;
        vif.penable <= 0;
    endtask

    virtual task write(input bit[31:0] addr, input [31:0] data);
        vif.paddr <= addr;
        vif.pwdata <= data;
        vif.pwrite <= 1;
        vif.psel <= 1;

        @(posedge vif.pclk);
        vif.penable <= 1;

        @(posedge vif.pclk);
        vif.psel <= 0;
        vif.penable <= 0;
    endtask
endclass

`endif