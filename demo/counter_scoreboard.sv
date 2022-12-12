`ifndef COUNTER_SCOREBOARD__SV
`define COUNTER_SCOREBOARD__SV

class counter_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(counter_scoreboard)

    function new(string name="counter_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    bit[7:0] exp_cout = 8'b0;

    uvm_analysis_imp#(counter_item, counter_scoreboard) m_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_analysis_imp = new("m_analysis_imp", this);
        // if(!uvm_config_db#)
    endfunction

    virtual function write(counter_item item);
        
        if(item.counter_out != exp_cout)begin
            `uvm_error("SCBD", $sformatf("ERROR! out %d exp %d", item.counter_out, exp_cout))
        end
        else begin
            `uvm_info("SCBD", $sformatf("PASS ! out %d exp %d", item.counter_out, exp_cout), UVM_LOW)
        end

        if(item.count_en == 0) begin
            exp_cout = 8'b0;
        end
        else begin
            if(exp_cout != 10) begin
                exp_cout ++;
            end
            else begin
                exp_cout = 0;
            end
        end
    endfunction
endclass

`endif