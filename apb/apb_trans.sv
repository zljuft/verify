`ifndef APB_TRANS__SV
`define APB_TRANS__SV

typedef enum {
    IDEL,
    RESET,
    READ,
    WRITE,
    RAL_READ,
    RAL_WRITE
} mode_e;

typedef enum bit [1:0] {
    NOT_OK,
    OK,
    PENDING,
    ERROR
} response_e;

class apb_trans extends uvm_sequence_item;

    rand bit[31:0] addr;
    rand bit[31:0] wdata;

    response_e status_e;
    mode_e mode;

    `uvm_object_utils_begin(apb_trans)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(wdata, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "apb_trans");
        super.new(name);    
    endfunction //new()

    virtual function string convert2string();
        return $sformatf("addr=%0x data=%0x", addr, wdata);
    endfunction
endclass //apb_trans extends uvm_sequence_item

`endif

