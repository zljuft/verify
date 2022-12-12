`ifndef COUNTER_ITEM__SV
`define COUNTER_ITEM__SV

class counter_item extends uvm_sequence_item;
    `uvm_object_utils(counter_item)

    rand bit count_en;
    rand bit rst_n;
    logic[7:0] counter_out;

    virtual function string convert2str();
        return $sformatf("count_en %d,rst_n %d, counter_out %d", count_en, rst_n, counter_out);
    endfunction

    function new(string name="counter_item");
        super.new(name);
    endfunction

    // constraint c1 { count_en dist {0:/10, 1:/90};}
    constraint c1 { count_en == 1;}
    constraint c2 {rst_n == 1;}
endclass

`endif