`ifndef REG_ADAPTER__SV
`define REG_ADAPTER__SV

class reg_adapter extends uvm_reg_adapter;
    `uvm_object_utils(reg_adapter)

    function new(string name = "reg_adapter");
        super.new(name);
    endfunction //new()

    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        bus_pkt pkt = bus_pkt::type_id::create("pkt");
        pkt.write = rw.kind == UVM_WRITE ? 1 : 0;
        pkt.addr = rw.addr;
        pkt.data = rw.data;

        return pkt;
    endfunction

    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        bus_pkt pkt;

        if (!$cast(pkt, bus_item)) begin
            `uvm_fatal("reg_adapter", "failed to case bus_item to pkt");
        end

        rw.kind = pkt.write ? UVM_WRITE : UVM_READ;
        rw.addr = pkt.addr;
        rw.data = pkt.data;
    endfunction
endclass //reg_adapter extends uvm_reg_adapter


`endif
