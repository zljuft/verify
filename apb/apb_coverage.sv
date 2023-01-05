`ifndef APB_COVERAGE__SV
`define APB_COVERAGE__SV

class apb_coverage extends uvm_subscriber#(apb_trans);
    real coverage_score;
    bit coverage_enable;
    apb_trans pkt;

    covergroup apb_cov with function sample(apb_trans pkt);
        option.comment = "coverage for apb";
        coverpoint pkt.addr;
    endgroup

    `uvm_component_utils_begin(apb_coverage)
        `uvm_field_int(coverage_enable, UVM_DEFAULT)
    `uvm_component_utils_end

    function new(string name = "apb_coverage", uvm_component parent);
        super.new(name, parent);  
        uvm_config_db#(bit)::get(this, "", "coverage_enable", coverage_enable);
        if(coverage_enable == 1) begin
            `uvm_info("apb_cov","Coverage enabled in apb_coverage",UVM_MEDIUM);
            apb_cov = new;
        end      
    endfunction

    virtual function void write(T t);
        if(!$cast(pkt, t.clone))begin
            `uvm_fatal("COV","Transaction object supplied is NULL in apb_coverage component");
        end

        if(coverage_enable == 1) begin
            apb_cov.sample(pkt);
            coverage_score = apb_cov.get_coverage();
            `uvm_info("COV",$sformatf("Coverage=%0f ",coverage_score),UVM_NONE);
        end
    endfunction

    virtual function void extract_phase(uvm_phase phase);
        uvm_config_db#(real)::set(null, "uvm_test_top.env", "cov_score", coverage_score);
    endfunction

endclass

`endif